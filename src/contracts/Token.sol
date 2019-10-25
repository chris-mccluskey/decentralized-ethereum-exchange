pragma solidity ^0.5.0; // Version of Solidity

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Token { // All code for the smart contract will be within this contract declaration
	using SafeMath for uint;

	// Variable
	string public name = "Muskey Coin"; // public makes name readable outside of the smart contract
	string public symbol = "MUSK";
	uint256 public decimals = 18; // unit256 means unsigned intiger and 256 is number of bites. A number without a sign 1 is a uint, -1 has a sign (-). We always want these numbers to be positive, can't have negaitve balances.
	uint256 public totalSupply;
	mapping(address => uint256) public balanceOf; // Track balances for the token on the blockchain - Stores information. Mapping is like a dictionary in python, key - value pairs (address: token_balance). It is doing two things, a state variable and expose a balanceOf fuction because it's public, solidity generates a function for free when we use public in the declaration.
	mapping(address => mapping(address => uint256)) public allowance;

	// Events
	event Transfer(address indexed from, address indexed to, uint256 value); // indexed means you can subscribe to only listen for events that involve either the from or the two addressses.
	event Approval(address indexed owner, address indexed spender, uint256 value);
	constructor() public {
		totalSupply = 1000000 * (10 ** decimals);
		balanceOf[msg.sender] = totalSupply; // assigns total supply of the token to the address to deploys the contract.
	}
    // Send tokens - Impliments behavior / fuctionality
	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(balanceOf[msg.sender] >= _value); // require is a solidity function, if the argument is `true` the code below will run, if false it will throw an error
		_transfer(msg.sender, _to, _value);
		return true;
	}

	function _transfer(address _from, address _to, uint256 _value) internal {
		require(_to != address(0)); // Solidity has the `require` function, if the argument is True it will proceed with execution below, if False it will throw an exception.
		balanceOf[_from] = balanceOf[_from].sub(_value); // subtractign balance of value sent from their senders balance on the blockchain
		balanceOf[_to] = balanceOf[_to].add(_value); // adding the balance of the value sent from the sender to the receiver
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
