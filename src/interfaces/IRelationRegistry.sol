// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "./ISet.sol";

interface IRelationRegistry is ISet {
    event RelationCreated(
        uint64 rel, PossessionMode poss, ConnectionMode conn, uint64[] adjSpec, uint256 data, address owner
    );
    event RelationUpdated(uint64 rel, uint256 data);
    event Connected(uint256 dest, uint32 rev, uint64 rel, uint256[] deps);
    event Disconnected(uint256 dest, uint32 rev, uint64 rel, uint256[] deps);

    function register(PossessionMode poss, ConnectionMode conn, uint64[] memory adjSpec, uint256 data)
        external
        returns (uint64);

    function update(uint64 rel, uint256 data) external;

    function relate(uint64 rel, uint256 dest, uint256[] memory deps) external;

    function unrelate(uint64 rel, uint256 dest, uint256[] memory deps) external;

    function checkSpec(uint64[] memory rels) external;
}
