// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ISet.sol";

interface IMintableSet is ISet {
    function mint(uint64 id) external returns (uint64);
    function mint(uint64 id, bytes memory input) external returns (uint64);
}
