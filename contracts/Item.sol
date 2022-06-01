// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ItemManager.sol";

contract Item {
    uint256 public priceInWei;
    uint256 public index;
    uint256 public pricePaid;
    itemManager parentContract;

    constructor(
        itemManager _parentContract,
        uint256 _priceInWei,
        uint256 _index
    ) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Payment for the Item has been already done");
        require(priceInWei == msg.value, "Only full payments are allowed");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value: msg.value}(
            abi.encodeWithSignature("paymentTrigger(uint256)", index)
        );
        require(success, "The Transaction is not succesfull, Cancelling");
    }
}
