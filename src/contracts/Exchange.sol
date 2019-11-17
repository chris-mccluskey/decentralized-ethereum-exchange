pragma solidity ^0.5.0;
import "./Token.sol";

contract Exchange {
    // Variables
    address public feeAccount; // the account that receives exchange fees
    uint256 public feePercent; // the fee percentage we take from exchange fees
	  mapping(address => mapping(address => uint256)) public tokens; // A nested mapping. First key will be the token address, 2nd key will be the address of the user that has deposited tokens themselves, value the amount of tokens in the users address
    constructor (address _feeAccount, uint256 _feePercent) public { // _ is used for local variables when they represent the values that will be passed to a state variable. _ is convention
        feeAccount = _feeAccount;
        feePercent = _feePercent;
    }
    function depositToken(address _token, uint _amount) public {
      tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount)
      require(Token(_token).transferFrom(msg.sender, address(this), _amount)); // require returns a truthy value, if it is False the function will stop execution
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
