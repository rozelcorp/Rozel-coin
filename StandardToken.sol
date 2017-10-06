/*
You should inherit from StandardToken or, for a token like you would want to
deploy in something like Mist, see HumanStandardToken.sol.
(This implements ONLY the standard functions and NOTHING else.
If you deploy this, you won't have anything useful.)

Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
.*/
pragma solidity ^0.4.11;


import "./Token.sol";


contract StandardToken is Token {

    struct Account {
        uint votes;
        uint lastVote;
        uint lastDividends;
    }

    modifier voteUpdater(address _to, address _from) {
        if (accounts[_from].lastVote == voteEnds) {
            if (accounts[_to].lastVote < voteEnds) {
                accounts[_to].votes = balances[_to];
                accounts[_to].lastVote = voteEnds;
            }
        } else if (accounts[_from].lastVote < voteEnds) {
            accounts[_from].votes = balances[_from];
            accounts[_from].lastVote = voteEnds;
            if (accounts[_to].lastVote < voteEnds) {
                accounts[_to].votes = balances[_to];
                accounts[_to].lastVote = voteEnds;
            }
        }
        _;

    }
    modifier updateAccount(address account) {
      var owing = dividendsOwing(account);
      if(owing > 0) {
        account.send(owing);
        accounts[account].lastDividends = totalDividends;
      }
      _;
    }
    function dividendsOwing(address account) internal returns(uint) {
      var newDividends = totalDividends - accounts[account].lastDividends;
      return (balances[account] * newDividends) / totalSupply;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    function voteCount(address _proposal) constant returns (uint256 count) {
        return votes[_proposal];
    }
    function voteBalance(address _owner) constant returns (uint256 balance)
    {
        return accounts[_owner].votes;

    }
    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) 
    updateAccount(msg.sender)
    voteUpdater(_to, msg.sender)
    returns (bool success) 
    {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value)
    updateAccount(msg.sender) 
    voteUpdater(_to, _from)
    returns (bool success) 
    {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    mapping (address => Account) accounts;
    mapping (address => uint ) votes;
}
