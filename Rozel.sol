pragma solidity ^0.4.11;

// Created By: Strategic Investments in Strategic Areas Group

import "./StandardToken.sol";
import "./Math.sol";

contract SISA is StandardToken, Math {


	string constant public name = "ROZEL Token";
	string constant public symbol = "RZL";
	uint constant public decimals = 18;

	address public ico_tokens = 0x1111111111111111111111111111111111111111;
	address public preICO_tokens = 0x2222222222222222222222222222222222222222;
	address public bounty_funds;
	address public founder;
	address public admin;
	address public team_funds;
	address public issuer;
	address public preseller;





	function () payable {
	  totalDividends += msg.value;
	  //deduct(msg.sender, amount);
	}


	modifier onlyFounder() {
	    // Only founder is allowed to do this action.
	    if (msg.sender != founder) {
	        throw;
	    }
	    _;
	}
	modifier onlyAdmin() {
	    // Only admin is allowed to do this action.
	    if (msg.sender != admin) {
	        throw;
	    }
	    _;
	}
    modifier onlyIssuer() {
        // Only Issuer is allowed to proceed.
        if (msg.sender != issuer) {
            throw;
        }
        _;
    }


    // modifier hasNotVoted() {
    // 	if (voted[msg.sender]){
    // 		throw;
    // 	}
    // 	_;
    // }
    // function voteCount(address _proposal) 
    //     public
    //     returns (uint256) 
    // {
    //     return votes[_proposal];
    // }
    // function voteBalance(address _owner) 
    //     public
    //     constant returns (uint256)
    // {
    //     return accounts[_owner].votes;

    // }
    function castVote(address proposal) 
    	public
    {
    	if (accounts[msg.sender].lastVote < voteEnds) {
    		accounts[msg.sender].votes = balances[msg.sender];
    		accounts[msg.sender].lastVote = voteEnds;

    	} else if (accounts[msg.sender].votes == 0 ) {
    		throw;
    	}
    	votes[proposal] = accounts[msg.sender].votes;
    	accounts[msg.sender].votes = 0;
    	
    }
    function callVote() 
    	public
    	onlyAdmin
    	returns (bool)
    {
    	voteEnds = now; //+ 7 days;

    }
    function issueTokens(address _for, uint256 amount)
        public
        onlyIssuer
        returns (bool)
    {
        if(allowed[ico_tokens][issuer] >= amount) { 
            transferFrom(ico_tokens, _for, amount);

            // Issue(_for, msg.sender, amount);
            return true;
        } else {
            throw;
        }
    }
    function changePreseller(address newAddress)
        external
        onlyAdmin
        returns (bool)
    {    
        delete allowed[preICO_tokens][preseller];
        preseller = newAddress;

        allowed[preICO_tokens][preseller] = balanceOf(preICO_tokens);

        return true;
    }
    function changeIssuer(address newAddress)
        external
        onlyAdmin
        returns (bool)
    {    
        delete allowed[ico_tokens][issuer];
        issuer = newAddress;

        allowed[ico_tokens][issuer] = balanceOf(ico_tokens);

        return true;
    }
	function ROZEL(address _founder, address _admin, address _bounty, address _team) {
		founder = _founder;
		admin = _admin;
		bounty_funds = _bounty;
		team_funds = _team;
		totalSupply = 98100000 * 1 ether;
		balances[preICO_tokens] = 5297400 * 1 ether;
		balances[bounty_funds] = 4532220 * 1 ether;
		balances[team_funds] = 3619890 * 1 ether;
		balances[ico_tokens] = 1280205 * 1 ether;



	}

}
