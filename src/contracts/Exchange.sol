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

    // Events
    event Deposit(address token, address user, uint256 amount, uint256 balance);
    event Withdraw(address token, address user, uint amount, uint balance);

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
