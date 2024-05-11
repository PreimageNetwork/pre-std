// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ITypes.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";

interface ISet is IERC1155MetadataURI {
    event Created(uint64 id, ObjectMeta meta, bytes32[] state, address owner);
    event Updated(uint64 id, ObjectMeta meta, bytes32[] state);
    event Upgraded(uint64 id, ObjectMeta meta);
    event Touched(uint64 id, ObjectMeta meta);
    event Destroyed(uint64 id, ObjectMeta meta);

    function update(uint64 id, bytes32[] memory state) external returns (ObjectMeta memory);

    function upgrade(uint64 id, uint32 bpRev, uint32 faRev) external returns (ObjectMeta memory);

    function touch(uint64 id) external returns (ObjectMeta memory);

    function metaAt(uint64 id, uint32 rev) external view returns (ObjectMeta memory meta);

    function stateAt(uint64 id, uint32 rev) external view returns (bytes32[] memory state);

    function revAt(uint64 id, uint32 rev) external view returns (uint32);

    function ownerOf(uint64 id) external view returns (address);

    // function dataOf(
    //     uint64 id
    // )
    //     external
    //     view
    //     returns (ObjectMeta memory meta, uint256[] memory state, address owner);
}
