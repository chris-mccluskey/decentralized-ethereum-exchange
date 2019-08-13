pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Token {
	using SafeMath for uint;

	// Variable
	string public name = "Muskey Coin";
	string public symbol = "MUSK";
	uint256 public decimals = 18; // unit256 means unsigned intiger and 256 is number of bites. A number without a sign 1 is a uint, -1 has a sign (-). We always want these numbers to be positive, can't have negaitve balances.
	uint256 public totalSupply;
	mapping(address => uint256) public balanceOf; // Track balances - Stores information. Mapping is like a dictionary in python, key - value pairs (address: token_balance)
	mapping(address => mapping(address => uint256)) public allowance;
	
	// Events
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
	constructor() public {
		totalSupply = 1000000 * (10 ** decimals);
		balanceOf[msg.sender] = totalSupply;
	}
    // Send tokens - Impliments behavior / fuctionality
	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(balanceOf[msg.sender] >= _value);
		_transfer(msg.sender, _to, _value);
		return true;
	}

	function _transfer(address _from, address _to, uint256 _value) internal {
		require(_to != address(0));
		balanceOf[_from] = balanceOf[_from].sub(_value);
		balanceOf[_to] = balanceOf[_to].add(_value);
		emit Transfer(_from, _to, _value);
	}

	// Approve tokens 
	function approve(address _spender, uint256 _value) public returns (bool success) {
		require(_spender != address(0));
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(_value <= balanceOf[_from]);
		require(_value <= allowance[_from][msg.sender]);
		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
		_transfer(_from, _to, _value);
		return true;
	}
}

