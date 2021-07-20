pragma solidity ^0.4.0;

contract Coin{
    
    address public minter;
    mapping (address => uint) public balances;
    
    event sent(address from, address to, uint amount);
    
    function Coin() public{
        minter = msg.sender;
    }
    
    function mint(address reciever, uint amount) public{
        if(msg.sender != minter) return;
        balances[reciever] += amount;
    }
    
    function send(address reciever, uint amount) public{
        if(balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        sent(msg.sender, reciever, amount);
    }
}