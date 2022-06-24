// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

abstract contract Ownable {
    // Owner's address
    address private _owner;

    // Ownership transferred event
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    // return the address of the owner

    function owner() public view returns(address) {
        return _owner;
    }

    // Only owner modifier
    // Throws error if called by any account other than the owner
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    // Now let's go ahead and create our isOwner function which will return if msg.sender is the owner or not
    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }

    // Allow the owner to transfer ownership
    function transferOwnership(address newOwner) public virtual onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner!= address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    // Allow the current user to take control over the contract
    function renounceOwnershop() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    } 


}
