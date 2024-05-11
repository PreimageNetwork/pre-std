// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ITypes.sol";
import "./ISet.sol";

interface IKindRegistry is ISet {
    event KindCreated(
        uint64 id, ObjectMeta meta, bytes32 code, ElementType[] stateSpec, uint64[] relSpec, bytes32 desc, address owner
    );
    event KindUpdated(uint64 id, ObjectMeta meta, bytes32 code, uint64[] relSpec, bytes32 desc);
    event KindUpgraded(uint64 id, ObjectMeta meta);
    event KindTouched(uint64 id, ObjectMeta meta);
    event KindDestroyed(uint64 id, ObjectMeta meta);

    function register(bytes32 code, ElementType[] memory stateSpec, uint64[] memory relSpec, bytes32 desc)
        external
        returns (uint64);

    function update(uint64 id, bytes32 code, bytes32 desc) external returns (ObjectMeta memory);

    function update(uint64 id, bytes32 code, bytes32 desc, uint64[] memory relSpec)
        external
        returns (ObjectMeta memory);

    function codeAt(uint64 id, uint32 rev) external view returns (bytes32);

    function stateSpecAt(uint64 id, uint32 rev) external view returns (ElementType[] memory);

    function relSpecAt(uint64 id, uint32 rev) external view returns (uint64[] memory);
}
