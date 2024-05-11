// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ITypes.sol";
import "./ISet.sol";

interface ISetRegistry is ISet {
    event SetCreated(uint64 id, ObjectMeta meta, address impl, bytes32 desc, address owner);
    event SetUpdated(uint64 id, ObjectMeta meta, bytes32 desc);
    event SetUpgraded(uint64 id, ObjectMeta meta);
    event SetTouched(uint64 id, ObjectMeta meta);
    event SetDestroyed(uint64 id, ObjectMeta meta);

    function register(address impl, bytes32 desc) external returns (uint64);

    function update(uint64 id, bytes32 desc) external returns (ObjectMeta memory);

    function implOf(uint64 id) external view returns (address);

    // function register2(address inst, uint256 data) external returns (uint64);

    // function registerTemplate(address tmpl) external;

    // function unregisterTemplate(address tmpl) external;

    // function enableTemplate(address tmpl, bool enable) external;
}
