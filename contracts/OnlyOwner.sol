// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Ownable {
    address private _owner;

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, " caller is not the owner");
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }
}
