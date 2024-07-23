// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    struct Item {
        string name;
        uint256 price;
        uint256 stock;
    }

    mapping(uint256 => Item) public items;
    mapping(address => mapping(uint256 => uint256)) public userItems;
    uint256 public nextItemId;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) payable {}

    function mint(address to, uint256 amount) public onlyOwner {    
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function addItem(string memory name, uint256 price, uint256 stock) public onlyOwner {
        items[nextItemId] = Item(name, price, stock);
        nextItemId++;
    }

    function redeem(uint256 itemId, uint256 amount) public {
        require(items[itemId].stock >= amount, "Not enough items in stock");
        uint256 cost = items[itemId].price * amount;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens");

        _burn(msg.sender, cost);
        items[itemId].stock -= amount;
        userItems[msg.sender][itemId] += amount;
    }

    function getItem(uint256 itemId) public view returns (string memory name, uint256 price, uint256 stock) {
        Item storage item = items[itemId];
        return (item.name, item.price, item.stock);
    }

    function getUserItem(address user, uint256 itemId) public view returns (uint256) {
        return userItems[user][itemId];
    }
}
