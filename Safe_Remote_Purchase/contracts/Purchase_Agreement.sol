// SPDX-License-Identifier: Unlicense

// Requirements -> The seller publishes the contract and sets the value for the item for sale
// -> Then the seller sends funds to the contract which then puts the transaction into a Locked state
// -> The seller then ships the item to the buyer and the buyer recieves the item and invokes
// a confirmation function which then releases the funds from the locked state and the buyer recieves the item
// -> In order to keep things safe and not rely on the buyer's honesty, We will ask both parties to send the 2x amount
// of the item.
// Once the transaction is resolved the buyer gets their money and deposit and the seller gets their money and deposit

pragma solidity ^0.8.0;

contract Purchase_Agreement {
    // So we are going to have three state variables
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State{
        Created,
        Locked,
        Release,
        Inactive
    }

    State public state;

    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
    }

    /// This function cannot be called in this state
    error invalidState();

    /// This function can only be called by the buyer
    error onlyBuyer();

    /// This function can only be called by the seller
    error onlySeller();

    modifier inState(State _state) {
        if(state != _state) {
            revert invalidState();
        }
        _;
    }


    modifier buyerOnly() {
        if(buyer != msg.sender) {
            revert onlyBuyer();
        }
        _;
    }

    modifier sellerOnly() {
        if(seller != msg.sender) {
            revert onlySeller();
        }
        _;
    }
    
    function confirmPurchase() external inState(State.Created) payable  {
        require(msg.value == (2 * value), "You need to pay at least 2x the amount");
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    function confirmReceived() external buyerOnly() inState(State.Locked) {
        // buyer = payable(msg.sender);
        state = State.Release;
        // in order to return the deposit to the buyer we need to use transfer 
        buyer.transfer(value);
    }

    function paySeller() public sellerOnly() inState(State.Release) {
        state = State.Inactive;
        // Now to pay the seller
        seller.transfer(3 * value);
    }


    function abort() public sellerOnly() inState(State.Created) {
        state = State.Inactive;
        // Now to abort the functions
        seller.transfer(address(this).balance);
    }
    
}