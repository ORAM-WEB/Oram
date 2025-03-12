// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AdaptiveContract.sol";
import "./SecurityChecker.sol";

contract OptimizedToken is AdaptiveContract, SecurityChecker {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }
    
    function transfer(address _to, uint256 _value) 
        public 
        noReentrant 
        validAddress(_to) 
        validAmount(_value) 
        returns (bool) 
    {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        uint256 gasStart = gasleft();
        
        balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        
        // Record transaction data for optimization
        recordTransaction(gasStart - gasleft(), _value);
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) 
        public 
        validAddress(_spender) 
        returns (bool) 
    {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) 
        public 
        noReentrant 
        validAddress(_from) 
        validAddress(_to) 
        validAmount(_value) 
        returns (bool) 
    {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
        
        uint256 gasStart = gasleft();
        
        balanceOf[_from] = balanceOf[_from] - _value;
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
        
        recordTransaction(gasStart - gasleft(), _value);
        
        emit Transfer(_from, _to, _value);
        return true;
    }
}
