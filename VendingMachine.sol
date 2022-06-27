// SPDX-License-Identifier:MIT

pragma solidity ^0.8.4;

contract Vending_Machine {
    // Here we are going to need two state variables 
    // The first variable will take in the address of the owner of the contract using the address data type in solidity
    // Then we're gonna have a mapping of type uints which will consist of donutBalances
    address public owner;
    mapping (address => uint) public donutBalance;

    
    constructor() {
        owner = msg.sender; // this is a property which will set the owner as the deployer of the contract
        donutBalance[address(this)] = 100; // the initial donut balance of the vending machine to be set to 100
    }

    // Now that we have set up our constructor we will get the donutBalance via a function

    function getDonutBalances() public view returns(uint256) { // view since it will read data from the blockchain
        uint256 donuts = donutBalance[address(this)];
        return donuts;
    }

    function getOwnedDonuts(address user) view external returns(uint){
        return donutBalance[user] ;
    }

    // Now we are going to write the function to restock our vending Machine
    function restock(uint _amount) public {
        require(msg.sender == owner, "Only the owner of the machine can restock"); // Running a check to make sure only the owner can call this function
        donutBalance[address(this)] += _amount; // incrementing it with the recieved input
    }

    // Now we will write the purchase function
    // we wanna increment to the owner and decrement from the buyer
    function purchase(uint _amount) public payable {
        require(msg.value >= _amount * 0.001 ether , "You need to pay at least 0.001 eth to get the donuts");
        require(donutBalance[address(this)] >= _amount, "Not enough donuts in stock to proceed with the purchase");
        donutBalance[address(this)] -= _amount;
        donutBalance[msg.sender] += _amount;
    }

}
