// //SPDX-License-Identifier: MIT



// // What are our invariants?

// //1. The total supply of DSC should be less than the total value of collateral
// //2. Getter view functions should never revert <- evergreen invariant

// pragma solidity ^0.8.18;

// import {Test , console} from "forge-std/Test.sol";
// import {StdInvariant} from "forge-std/StdInvariant.sol";
// import {DeployDSC} from "../../script/DeployDSC.s.sol";
// import {DSCEngine} from "../../src/DSCEngine.sol";
// import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
// import {HelperConfig} from "../../script/HelperConfig.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// contract InvariantsTest is StdInvariant, Test{
//     DeployDSC deployer;
//     DSCEngine dsce;
//     DecentralizedStableCoin dsc;
//     HelperConfig config;
//     address weth;
//     address wbtc;

//     function setUp() external {
//         deployer = new DeployDSC();
//         (dsc,dsce,config) = deployer.run();
//         (,, weth, wbtc,) = config.activeNetworkConfig();
//         emit log_address(address(dsce));
//         targetContract(address(dsce));  // Registers contract for fuzzing
//     }

//     function invariant_protocolMustHaveMoreValueThanTotalSupply() public view{
//         uint256 totalSupply = dsc.totalSupply() -1 ; //check total supply
//         uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
//         uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

//         uint256 wethValue = dsce.getUsdValue(weth, totalWethDeposited);
//         uint256 wbtcValue = dsce.getUsdValue(wbtc, totalWbtcDeposited);

//         console.log("weth value: ", wethValue);
//         console.log("wbtc value: ", wethValue);
//         console.log("total supply: ", totalSupply);

//         assert(wethValue + wbtcValue >= totalSupply);
//     }
// }