pragma solidity ^0.4.0;

contract Bidder {
    string public name = "Yash";
    uint public bidAmount;
    bool public eligible;
    uint constant minBid = 1000;
    
    function setName(string nm) public{
        name = nm;
    }
    
    function setBidAmount(uint bd) public{
        bidAmount = bd;
    }
    
    function determineEligibility() public{
        if(bidAmount >= minBid) 
            eligible = true;
        else 
            eligible = false;
    }
}