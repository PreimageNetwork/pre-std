// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../interfaces/ITypes.sol";

library RevisionStore {
    error InvalidId();
    error InvalidMeta();
    error InvalidOwner();
    error ObjectAlreadyExists();
    error ObjectNotExist();
    error RevisionNotExist();
    error InvalidRevision();
    error CallerNotHolder();

    struct RevisionRecord {
        ObjectMeta meta;
        bytes32[] state;
    }

    struct ObjectRecord {
        address owner;
        uint32 latest;
        uint32 extra1;
        uint32 extra2;
    }

    struct Storage {
        mapping(uint256 => ObjectRecord) records;
        mapping(uint256 => RevisionRecord) revisions;
    }

    function create(Storage storage $, uint64 id, ObjectMeta memory meta, bytes32[] memory state, address owner)
        external
    {
        if (id < ID_MIN || id > ID_MAX) revert InvalidId();
        if (meta.rev != 1 || meta.krev == 0 || meta.srev == 0 || meta.kind == 0 || meta.set == 0) revert InvalidMeta();
        if (owner == address(0)) revert InvalidOwner();
        if ($.records[id].latest != 0) revert ObjectAlreadyExists();

        $.records[uint256(id)] = ObjectRecord(owner, 1, 0, 0);
        $.revisions[_revKey(id, meta.rev)] = RevisionRecord(meta, state);
    }

    function destroy(Storage storage $, uint64 id) external {
        ObjectRecord storage rec = $.records[id];
        if (rec.latest == 0) revert ObjectNotExist();

        rec.latest = REV_DESTROYED;
    }

    function update(Storage storage $, uint64 id, bytes32[] memory state) external returns (ObjectMeta memory) {
        ObjectRecord storage obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        RevisionRecord memory revRec = $.revisions[_revKey(id, obRec.latest)];
        if (revRec.meta.rev == 0) revert RevisionNotExist();

        ObjectMeta memory meta = revRec.meta;
        meta.rev += 1;
        $.revisions[_revKey(id, meta.rev)] = RevisionRecord(meta, state);
        obRec.latest = meta.rev;
        return meta;
    }

    function upgrade(Storage storage $, uint64 id, uint32 krev, uint32 srev) external returns (ObjectMeta memory) {
        // check revision record
        ObjectRecord storage obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        RevisionRecord memory revRec = $.revisions[_revKey(id, obRec.latest)];
        if (revRec.meta.rev == 0) revert RevisionNotExist();
        // check params
        ObjectMeta memory meta = revRec.meta;
        if (srev == 0 && krev == 0) revert InvalidRevision();
        if (srev > 0) {
            if (srev <= meta.srev) revert InvalidRevision();
            meta.srev = srev;
        }
        if (krev > 0) {
            if (krev <= meta.krev) revert InvalidRevision();
            meta.krev = krev;
        }

        meta.rev += 1;
        $.revisions[_revKey(id, meta.rev)] = RevisionRecord(meta, revRec.state);
        obRec.latest = meta.rev;
        return meta;
    }

    function touch(Storage storage $, uint64 id) external returns (ObjectMeta memory) {
        ObjectRecord storage obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();

        RevisionRecord memory revRec = $.revisions[_revKey(id, obRec.latest)];
        ObjectMeta memory meta = revRec.meta;
        meta.rev += 1;
        $.revisions[_revKey(id, meta.rev)] = RevisionRecord(meta, revRec.state);
        obRec.latest = meta.rev;
        return meta;
    }

    function metaAt(Storage storage $, uint64 id, uint32 rev) external view returns (ObjectMeta memory) {
        ObjectRecord memory obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        rev = rev == 0 ? obRec.latest : rev;
        RevisionRecord memory revRec = $.revisions[_revKey(id, rev)];
        if (revRec.meta.rev == 0) revert RevisionNotExist();
        return revRec.meta;
    }

    function stateAt(Storage storage $, uint64 id, uint32 rev) external view returns (bytes32[] memory) {
        ObjectRecord memory obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        rev = rev == 0 ? obRec.latest : rev;
        RevisionRecord memory revRec = $.revisions[_revKey(id, rev)];
        if (revRec.meta.rev == 0) revert RevisionNotExist();
        return revRec.state;
    }

    function revAt(Storage storage $, uint64 id, uint32 rev) external view returns (uint32) {
        ObjectRecord memory obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        rev = rev == 0 ? obRec.latest : rev;
        RevisionRecord memory revRec = $.revisions[_revKey(id, rev)];
        if (revRec.meta.rev == 0) revert RevisionNotExist();
        return rev;
        // if (rev == 0) {
        //     return obRec.latest;
        // } else if (rev > obRec.latest) {
        //     revert RevisionNotFound();
        // } else {
        //     return rev;
        // }
    }

    function ownerOf(Storage storage $, uint64 id) external view returns (address) {
        ObjectRecord memory obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        return obRec.owner;
    }

    function dataOf(Storage storage $, uint64 id)
        external
        view
        returns (ObjectMeta memory meta, bytes32[] memory state, address owner)
    {
        ObjectRecord memory obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        RevisionRecord memory revRec = $.revisions[_revKey(id, obRec.latest)];
        if (revRec.meta.rev == 0) revert RevisionNotExist();
        return (revRec.meta, revRec.state, obRec.owner);
    }

    function onlyHolder(Storage storage $, uint64 id, address holder) external view {
        ObjectRecord memory obRec = $.records[id];
        if (obRec.latest == 0) revert ObjectNotExist();
        if (obRec.owner != holder) revert CallerNotHolder();
    }

    function _revKey(uint64 id, uint32 rev) private pure returns (uint256) {
        return (uint256(rev) << 64) | uint256(id);
    }
}
