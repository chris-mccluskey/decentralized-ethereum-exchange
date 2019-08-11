pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Token {
	using SafeMath for uint;

	// Variable
	string public name = "Muskey Coin";
	string public symbol = "MUSK";
	uint256 public decimals = 18; // unit256 means unsigned intiger and 256 is number of bites. A number without a sign 1 is a uint, -1 has a sign (-). We always want these numbers to be positive, can't have negaitve balances.
	uint256 public totalSupply;

	// Track balances - Stores information
	mapping(address => uint256) public balanceOf; //mapping is like a dictionary in python, key - value pairs (address: token_balance)
	
	// Events
	event Transfer(address indexed from, address indexed to, uint256 value);

	constructor() public {
		totalSupply = 1000000 * (10 ** decimals);
		balanceOf[msg.sender] = totalSupply;
	}
    // Send tokens - Impliments behavior / fuctionality
	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(_to != address(0));
		require(balanceOf[msg.sender] >= _value);
		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
		balanceOf[_to] = balanceOf[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
		return true; 
	}
}

