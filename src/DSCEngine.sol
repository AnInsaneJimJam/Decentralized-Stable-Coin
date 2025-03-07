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

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

// import { ERC20Burnable, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DSCEngine
 * @author Anand Bansal
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token = $1 peg
 * This stablecoin has the properties:
 * - Exogenous Collateral
 * - Dollar pegged
 * - Algorithmically stable
 * - Should always be overcollateralized. At no point, should the value of all collateral <= the value of all the DSC
 *
 * Similar to DAI with no governance
 * @notice This contract is the core of DSC.
 */
contract DSCEngine is ReentrancyGuard {
    error DSCEngine_NeedsMoreThanZero();
    error DSCEngine_TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine_InvalidToken();

    mapping(address token => address priceFeed) private s_priceFeeds; //token -> pricefeeds
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;

    DecentralizedStableCoin private immutable i_dsc;

    modifier moreThanZero(uint256 _amount) {
        if (_amount <= 0) {
            revert DSCEngine_NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine_InvalidToken();
        }
        _;
    }

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine_TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    function depositCollateralAndMintDsc() external {}

    /**
     *
     * @param tokenCollateralAddress: The address of the token to be used as collateral
     * @param amountCollateral: The amount of collateral to be deposited
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
    }

    function redeemCollateralForDsc() external {}

    function burnDSC() external {}

    function mintDsc() external {}

    function redeemCollateral() external {}

    //Kick user if the value of collateral drops more than the set
    //Some one can repay your borrowed amount and get the collateral.
    function liquidate() external {}

    function getHealthFactor() external view {}
}
