// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./Item.sol";
import "./OnlyOwner.sol";

contract itemManager is Ownable {
    enum SupplyChainState {
        Created,
        Paid,
        Delivered
    }

    struct S_items {
        Item _item;
        string _itemName;
        uint256 _itemPrice;
        itemManager.SupplyChainState _state;
    }

    mapping(uint256 => S_items) public items;
    uint256 itemIndex;

    event SupplyChainStep(
        uint256 _itemIndex,
        uint256 _step,
        address _itemAddress
    );

    function createItem(string memory _itemName, uint256 _itemPrice)
        public
        onlyOwner
    {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._itemName = _itemName;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(
            itemIndex,
            uint256(items[itemIndex]._state),
            address(item)
        );
        itemIndex++;
    }

    function paymentTrigger(uint256 _itemIndex) public payable {
        require(
            items[_itemIndex]._itemPrice == msg.value,
            "You Need to Pay in Full"
        );
        require(
            items[_itemIndex]._state == SupplyChainState.Created,
            "Items is not Available"
        );
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(
            itemIndex,
            uint256(items[_itemIndex]._state),
            address(items[_itemIndex]._item)
        );
    }

    function delieveryTrigger(uint256 _itemIndex) public onlyOwner {
        require(
            items[_itemIndex]._state == SupplyChainState.Paid,
            "Items is not Yet Paid"
        );
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStep(
            itemIndex,
            uint256(items[_itemIndex]._state),
            address(items[_itemIndex]._item)
        );
    }
}
