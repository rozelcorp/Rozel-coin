pragma solidity ^0.4.11;


contract Proposal {
	string name; 
	string description;

	function Proposal(string _name, string _description) {
		name = _name;
		description = _description;
	}
}