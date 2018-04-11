pragma solidity ^0.4.11;

import "./ROZEL.sol";
import "./Math.sol";


contract preICO is Math {

	ROZEL public ROZEL_token; 
	address public founder; 
	address public sale_address = 0x2222222222222222222222222222222222222222;

	//Price / 100
	uint public price = 37348272642390287;
	//uint price = div(100 ether, 267750 * ether)

	uint public begins = 1508457600;
	uint public ends = 1509321600;


	modifier isExpired() {
		if (now < begins) {
			throw;
		}
		if(now > ends) {
			throw;
		}
		_;
	}
	function preICO(address tokenAddress, address founderAddress) {
		founder = founderAddress;
		ROZEL_token = ROZEL(tokenAddress);

	}

	function () payable
		isExpired 
	{
		uint amount = msg.value;
		uint tokens = div(amount * 100 ether, price);
		if (founder.send(amount)) {
			ROZEL_token.transferFrom(sale_address, msg.sender, tokens);
		} else {
			throw;
		}
	}
}
