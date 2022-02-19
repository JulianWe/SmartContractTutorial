pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

contract Voting {

    // struct to safe option positions and if the option exists
    struct OptionPos {
        uint pos;
        bool exists;
    }

    uint[] public votes;
    string[] public options;
    mapping (address => bool) hasVoted;
    mapping (string => OptionPos) posOfOption;

    constructor (string[] _options) public {

        // create options from deployment input 
        options = _options;
        // set votes array length to available options
        votes.length = options.length;

        // fill posOfOption mapping to be able to voteByOptionName
        for (uint i = 0; i < options.length; i++){
            OptionPos memory optionPos = OptionPos(i, true);
            string optionName = options[i];
            posOfOption[optionName] = optionPos;
        }

    }

    // function to vote by option position and increase voting count
    function voteUsingOptionPosition(uint option) public {

        // Check allowed option value
        require(0 <= option && option < options.length,  "Invalid Operation" );
        // Check if an Account has already voted
        require(!hasVoted[msg.sender], "This Address has already voted");

        // increase vote for selected option
        votes[option] = votes[option] +1;
        // set hasVoted to yes
        hasVoted[msg.sender] = true;
    }


    // function to vote by optionName 
    function voteByOptionName (string optionName) public {

        // Check if an Account has already voted
        require(!hasVoted[msg.sender], "This Address has already voted");

        // use mapping to get position of option by optionName
        // Note: using memory instead of storage = cheaper gas fee
        OptionPos memory optionPos = posOfOption[optionName];
        // check if option exists 
        require(optionPos.exists,"Option does not exist"); 

        // increase vote for selected option using optionPos struct
        votes[optionPos.pos] = votes[optionPos.pos] + 1;
        // set hasVoted to yes
        hasVoted[msg.sender] = true;

    }


    // function to read available voting options
    function getVotingOptions() public view returns (string[]) {

        return options;
    }

    // function to get voting counts
    function getVotes() public view returns (uint[]) {

        return votes; 
    }

}
