// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Clones} from "openzeppelin-contracts/contracts/proxy/Clones.sol";
import {Child} from "./Child.sol";

contract Factory {
    address public immutable IMPLEMENTATION;

    constructor() {
        IMPLEMENTATION = address(new Child());
    }

    function run() public {
        for (uint256 i = 0; i < 1; i++) {
            address clone = deployClone(abi.encodeWithSelector(Child.initialize.selector));
            clone.call(abi.encodeWithSelector(Child.execute.selector));
        }
    }

    function deployClone(bytes memory _data) public returns (address) {
        address clone = Clones.clone(IMPLEMENTATION);
        (bool success,) = clone.call(_data);
        require(success, "Deployment failed");
        return clone;
    }
}
