// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ITypes.sol";

interface ISetProvider {
    event SupplyCreated(SupplyRule[] rules);

    function onRegister(
        address setRegistry,
        address kindRegistry,
        address relRegistry,
        address owner,
        uint64 universe,
        uint64 self,
        string memory uriBase,
        string memory uriQuery
    ) external returns (bytes4);

    function onTouch(uint64 id) external returns (bytes4);

    function onTransfer(uint64 id, address from, address to) external returns (bytes4);
}
