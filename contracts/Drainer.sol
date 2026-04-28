// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {IDrainer} from "./IDrainer.sol";

/**
 * @title Drainer
 * @notice APT28 payload — drain target vault and split proceeds atomically.
 */
contract Drainer is IDrainer {

    function attack(uint256 nonce) external override {
        revert("TODO: implement");
    }

    function distribute() external override {
        revert("TODO: implement");
    }

    receive() external payable {}
}