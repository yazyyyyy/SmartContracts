pragma solidity ^0.4.0;

contract Ballot{
    
    struct Voter{
        uint weight;
        bool voted;
        uint8 vote;
    }
    
    struct Proposal{
        uint voteCount;
    }
    
    enum Stage {Init, Reg, Vote, Done}
    Stage public stage = Stage.Init;
    
    address chairPerson;
    mapping(address => Voter) voters;
    Proposal[] proposals;
    
    uint startTime;
    //modifier
    modifier validStage(Stage reqStage){
        require(stage == reqStage);
        _;
    }
    
    event votingCompleted();
    
    function Ballot(uint8 _numProposals) public{
        chairPerson = msg.sender;
        voters[chairPerson].weight = 2;
        stage = Stage.Reg;
        proposals.length = _numProposals;
        startTime = now;
    }
    
    function register(address toVoter) public validStage(Stage.Reg){
        //if(stage != Stage.Reg) return;
        if(msg.sender != chairPerson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        if(now > (10 + startTime)) {
            stage = Stage.Vote;
            startTime = now;
        }
    }
    
    function vote(uint8 toProposal) public validStage(Stage.Vote){
        //if(stage != Stage.Vote) return;
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
        if(now > (10 + startTime)) {
            stage = Stage.Done;
            votingCompleted();
        }
    }
    
    function winningProposal() public validStage(Stage.Done) constant returns (uint8 _winningProposal) {
        //if(stage != Stage.Done) return;
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}