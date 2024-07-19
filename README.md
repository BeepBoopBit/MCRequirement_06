# DegenToken

A smart contract implementation for the DegenToken, an ERC20 token with additional functionality for minting, burning, and redeeming items.

## Description

The DegenToken contract allows for the creation and management of a custom ERC20 token named "Degen" with the symbol "DGN". This contract also includes functionalities for minting new tokens, burning existing tokens, adding items to a list, and redeeming items using the tokens.

## Getting Started

### Prerequisites

To work with this contract, you'll need:

- [Remix IDE](https://remix.ethereum.org/) or any other Solidity development environment.
- MetaMask or another Ethereum wallet for deploying and interacting with the contract.

### Installing

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a new file and name it `main.sol`.
3. Copy and paste the Solidity code into `main.sol`.

### Compiling

1. In Remix, select the Solidity compiler from the sidebar.
2. Set the compiler version to `0.8.18`.
3. Compile the `main.sol` file.

### Deploying

1. In Remix, go to the "Deploy & Run Transactions" tab.
2. Select the environment (e.g., JavaScript VM, Injected Web3).
3. Deploy the `DegenToken` contract.

### Interacting with the Contract

#### Minting Tokens

To mint new tokens, use the `mint` function:

```solidity
function mint(address to, uint256 amount) public onlyOwner
```

#### Burning Tokens

To burn tokens, use the `burn` function:

```solidity
function burn(uint256 amount) public
```

#### Adding Items

To add a new item, use the `addItem` function:

```solidity
function addItem(string memory name, uint256 price, uint256 stock) public onlyOwner
```

#### Redeeming Items

To redeem an item, use the `redeem` function:

```solidity
function redeem(uint256 itemId, uint256 amount) public
```

#### Viewing Items

To view an item's details, use the `getItem` function:

```solidity
function getItem(uint256 itemId) public view returns (string memory name, uint256 price, uint256 stock)
```

### Code (main.sol)

```solidity
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
    }

    function getItem(uint256 itemId) public view returns (string memory name, uint256 price, uint256 stock) {
        Item storage item = items[itemId];
        return (item.name, item.price, item.stock);
    }
}
```

## Authors

Renz Angelo Aguirre

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
