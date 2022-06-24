// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
// import './Ownable.sol';
// import "@chainlink/contracts/src/v0.8/VRFConsumer.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Lottery is Ownable, VRFConsumerBase {
    
    address public manager;
    
    // we need to make it payable since we want to transfer ether to that address
    address payable[] public participants;

    event gotWinner(
        address winnerAddress,
        uint winAmount
    );

    // Let's define two variables for VRFConsumerBase
    // keyHash and fee 
    // keyHash --> Chainlink node will identify which node we will be using
    // fee --> Chainlink node fee represents the gas fee chainlink will charge, expressed in LINK Tokens
    bytes32 public keyHash;
    uint256 public fee;
    uint256 public randomVal;

    // We need the LINK and VRF Cordinator address
    // These values can be found from - 
    // https://docs.chain.link/docs/vrf-contracts/
    // We have used values for the polygon mumbai Test network
    constructor() VRFConsumerBase(
        0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed, // VRF Coordinator
        0x326C977E6efc84E512bB9C30f76E30c160eD06FB //LINK
    ) {
        // manager is the contract deployer
        manager = msg.sender;

        // standard values for polygon matic mumbai testnet fetched from chainlink
        keyHash = 0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;
        fee = 100000000000000000; // 1 LINK
    }

    // App to support recieve ether feature with No data
    receive() external payable {
        // we will set up the lottery price as 0.1 matic 
        require(msg.value == 0.1 ether);

        // Insert the participant's address inside of the participant array 
        // Since msg.sender is not of type payable, we need to explicitly cast it to a payable method
        address payable participantAddress = payable(msg.sender);
        participants.push(participantAddress);
    }

    // Now let's get the participants
    function getParticipants() external view returns(address payable[] memory) {
        return participants;
    }

    // get the balance inside of the participant's account
    // Only owner can call this function
    
    function getBalance() public view onlyOwner returns(uint) {
        return address(this.balance);
    } 

    // Call this to get a random Winner
    function getWinner() public onlyOwner returns(bytes32 requestId) {
        // We will require a minumum of 3 participants to decide a winner
        require(participants.length >= 3);
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        randomVal = randomness;

        // Index value 
        uint index = randomVal % participants.length;
        address payable winner = participants[index];

        // Transfer the total lottery matic to the winner
        // Keep 0.1 matic to the contract itself for internal oracle contract calls 
        uint amount = (participants.length - 1) * 0.1 ether;
        winner.transfer(amount);

        // Now that the winner is decided let's emit the event 
        emit gotWinner(winner, amount);

        // Lottery round over - Reset the participants array now
        participants = new address payable[](0);

    }


}
