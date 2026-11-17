// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Factory} from "../src/Factory.sol";

contract FactoryTest is Test {
    string internal constant RPC_URL = "https://avalanche-mainnet.gateway.tenderly.co";

    Factory internal factory;

    function setUp() public {
        vm.createSelectFork(RPC_URL);

        factory = new Factory();
    }

    function test_fork() public {
        factory.run();
    }
}
