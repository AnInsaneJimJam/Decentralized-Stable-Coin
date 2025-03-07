//SPDX-License-Identifier: MIT

// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
* @title DecentralizedStableCoin
* @author Anand Bansal
* Collateral: Exogenous (ETH & BTC)
* Relative Stability: Pegged to USD
*
* This is the contract meant to be governed by DSCEngine. This is ERC20 implementation of our stablecoin system.
*/
contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DSC_MustBeMoreThanZero();
    error DSC_BurnAmountExceedsBalance();
    error DSC_InvalidAddress();

    //0x87 is a mock address just to avoid error for now. Later put DSC engine contract address

    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(address(0x87)) {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DSC_MustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DSC_BurnAmountExceedsBalance();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DSC_InvalidAddress();
        }
        if (_amount <= 0) {
            revert DSC_MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
