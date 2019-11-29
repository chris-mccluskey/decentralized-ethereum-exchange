pragma solidity ^0.5.0;
import "./Token.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Exchange {
  	using SafeMath for uint;

    // Variables
    address public feeAccount; // the account that receives exchange fees
    uint256 public feePercent; // the fee percentage we take from exchange fees
    address constant ETHER = address(0); // Store ETH in tokens mapping with blank address
	  mapping(address => mapping(address => uint256)) public tokens; // A nested mapping. First key will be the token address, 2nd key will be the address of the user that has deposited tokens themselves, value the amount of tokens in the users address
    mapping(uint256 => _Order) public orders; // A mapping, to store the orders. Key will be an id, value will be an _Order struct.
    // There is no way to check the size of a mapping wihin the blockchain, it's a limitation of the EVM
    // That is why we have an orderCount, we can see the size of the mapping with the orderCount value.
    uint256 public orderCount;
    mapping(uint256 => bool) public orderCancelled; // The items in the orders mapping cannot be removed so we are creating a new mapping to say `true` to canceld orders. They will share the same id as the orders mapping.
    mapping(uint256 => bool) public orderFilled; // Maping keeping track of orders being filled true or false
    // Events
    event Deposit(address token, address user, uint256 amount, uint256 balance);
    event Withdraw(address token, address user, uint256 amount, uint256 balance);
    event Order(
      uint256 id, // uint is the same as uint256, interchangable
      address user,
      address tokenGet,
      uint256 amountGet,
      address tokenGive,
      uint256 amountGive,
      uint256 timestamp
    );
    event Cancel(
      uint256 id,
      address user,
      address tokenGet,
      uint256 amountGet,
      address tokenGive,
      uint256 amountGive,
      uint256 timestamp
    );
    event Trade(
      uint256 id,
      address user,
      address tokenGet,
      uint256 amountGet,
      address tokenGive,
      uint256 amountGive,
      address userFill,
      uint256 timestamp
    );



    // structs
    struct _Order { // Order model. used _ to avoid naming conflict with the event order. Event order we will use outside of the smart contract while we use this model inside the contract.
      uint256 id;
      address user; // User address that created the order
      address tokenGet; // Token the user wants to purchase
      uint256 amountGet; // Amount the user wants to purchase
      address tokenGive; // Token they will use in the trade
      uint256 amountGive; // Amount of the token they want to give
      uint256 timestamp;
    }

    constructor (address _feeAccount, uint256 _feePercent) public { // _ is used for local variables when they represent the values that will be passed to a state variable. _ is convention
        feeAccount = _feeAccount;
        feePercent = _feePercent;
    }

    // Fallback: reverts (refunds) Ether if it is sent directly to this smart contract address by mistake.
    function () external {
      revert();
    }

    function depositEther() payable public { // We don't have to have ETH as parameter, we have to have the additonal modifier (payable) to access ETH in a fucntion. We can access the ETH info meta data through msg.
      tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].add(msg.value); // msg.value is the number of wei sent with the transaction.
      emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
    }

    function withdrawEther(uint _amount) public {
      require(tokens[ETHER][msg.sender] >= _amount);
      tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].sub(_amount);
      msg.sender.transfer(_amount);
      emit Withdraw(ETHER, msg.sender, _amount, tokens[ETHER][msg.sender]);
    }

    function depositToken(address _token, uint _amount) public {
      require(_token != ETHER); // Only tokens should be able to use this, not to deposit ether.
      tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount); // Add the deposit amount to the users wallet in the tokens mapping.
      require(Token(_token).transferFrom(msg.sender, address(this), _amount)); // require returns a truthy value, if it is False the function will stop execution
      emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    function withdrawToken(address _token, uint256 _amount) public {
      require(_token != ETHER);
      require(tokens[_token][msg.sender] >= _amount);
      tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);
      require(Token(_token).transfer(msg.sender, _amount));
      emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    function balanceOf(address _token, address _user) public view returns (uint256) {
      return tokens[_token][_user];
    }

    function makeOrder(address _tokenGet, uint256 _amountGEt, address _tokenGive, uint256 _amountGive) public {
      orderCount = orderCount.add(1);
      orders[orderCount] = _Order(orderCount, msg.sender, _tokenGet, _amountGEt, _tokenGive, _amountGive, now);
      emit Order(orderCount, msg.sender, _tokenGet, _amountGEt, _tokenGive, _amountGive, now);
    }

    function cancelOrder(uint256 _id) public {
      // Must be the users "my" order
      // The order must exist
      _Order storage _order = orders[_id]; // the data type is of _Order we created, we are fetching from `storage` on the block chain, assigning to the variable _order. on the right side of = we are fetching from the mapping.
      require(address(_order.user) == msg.sender); // require the address of the person calling this function (msg.sender) is the owner of the order they are canceling.
      require(_order.id == _id); // the order must exist. If the order doesn't exist, the mapping will return a blank struct with the value being 0. causeing this to fail.
      orderCancelled[_id] = true; // Set that order id value to true, meaning cancelled.
      emit Cancel(_order.id, msg.sender, _order.tokenGet, _order.amountGet, _order.tokenGive, _order.amountGive, now);
    }

    function fillOrder(uint256 _id) public {
      require(_id > 0 && _id < orderCount); // Make sure it is a valid order
      require(!orderFilled[_id]); // Require this id is not in the filled orders mapping
      require(!orderCancelled[_id]); // Require this id is not in the cancelled orders mapping
      _Order storage _order = orders[_id]; // Fetch order from storage
      _trade(_order.id, _order.user, _order.tokenGet, _order.amountGet, _order.tokenGive, _order.amountGive); // Execute the trade.
      orderFilled[_order.id] = true; // mapping of the order id being filled is set to true
    }

    function _trade(uint256 _orderId, address _user, address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive) internal  // Only used internally by the smart contract, cannot be called from outside of the contract.
      // Fee is paid by the person that filled the order (msg.sender)
      // Fee is deducted from _amountGet
      unit256 _feeAmount = _amountGive.mul(feePercent).div(100)
      // Execute trade
      // Charge fees
      tokens[_tokenGet][msg.sender] = tokens[_tokenGet][msg.sender].sub(_amountGet.add(_feeAmount)); // add the 10% fee to the msg.sender subtracted balance
      tokens[_tokenGet][_user] = tokens[_tokenGet][_user].add(_amountGet);
      tokens[_tokenGet][_feeAccount] = tokens[_tokenGet][_feeAccount].add(_feeAmount);
      tokens[_tokenGive][_user] = tokens[_tokenGive][_user].sub(_amountGive);
      tokens[_tokenGive][msg.sender] = tokens[_tokenGive][msg.sender].add(amountGive);

      emit Trade(_orderId, _user, _tokenGet, _amountGet, _tokenGive, _amountGive, msg.sender, now);
    }
}

// TODO:
// [ ] Set the fee account
// [ ] Deposit Ether
// [ ] Withdraw Ether
// [ ] Deposit tokens
// [ ] Withdraw tokens
// [ ] Check balances
// [ ] Make order
// [ ] Cancel order
// [ ] Fill order
// [ ] Charge fees
