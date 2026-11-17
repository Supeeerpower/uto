// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IPool} from "aave-v3-core/contracts/interfaces/IPool.sol";
import {IPriceOracle} from "aave-v3-core/contracts/interfaces/IPriceOracle.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";

contract Constants {
    IPool public constant POOL = IPool(0x794a61358D6845594F94dc1DB02A252b5b4814aD);
    uint8 public constant EMODE_CATEGORY = 2;
    uint16 public immutable EMODE_LTV = POOL.getEModeCategoryData(EMODE_CATEGORY).ltv;
    address public constant ASSET1 = 0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE;
    address public constant ASSET2 = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;
    address public constant ATOKEN1 = 0x513c7E3a9c69cA3e22550eF58AC1C0088e918FFf;
    address public constant ATOKEN2 = 0x6d80113e533a2C0fe82EaBD35f1875DcEA89Ea97;
    uint256 public immutable AMOUNT1;
    uint256 public immutable AMOUNT2;
    IPriceOracle public constant ORACLE = IPriceOracle(0xEBd36016B3eD09D4693Ed4251c67Bd858c3c7C9C);
    uint256 public immutable PRICE_1 = ORACLE.getAssetPrice(ASSET1);
    uint256 public immutable PRICE_2 = ORACLE.getAssetPrice(ASSET2);

    constructor() {
        uint256 data = POOL.getConfiguration(ASSET1).data;
        uint256 supplyCap = (data >> 116) & ((1 << 36) - 1);
        if (IERC20(ASSET1).balanceOf(ATOKEN1) > supplyCap) {
            AMOUNT1 = supplyCap;
        } else {
            AMOUNT1 = IERC20(ASSET1).balanceOf(ATOKEN1);
        }
        AMOUNT2 = IERC20(ASSET2).balanceOf(ATOKEN2);
        uint256 availableBorrow = (AMOUNT1 * EMODE_LTV / 10000) * PRICE_1 / PRICE_2;
        if (availableBorrow > AMOUNT2) {
            AMOUNT1 = (AMOUNT2 * PRICE_2 / PRICE_1) * 10000 / EMODE_LTV;
        } else {
            AMOUNT2 = availableBorrow;
        }
        console.log("AMOUNT1", AMOUNT1);
        console.log("AMOUNT2", AMOUNT2);
    }
}
