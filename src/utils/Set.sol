// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/ISet.sol";
import "../interfaces/ITypes.sol";
import "../libraries/RevisionStore.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract Set is ERC1155, Ownable, ISet {
    error IdExhausted();

    using RevisionStore for RevisionStore.Storage;

    RevisionStore.Storage private _revisions;
    uint64 internal _universe;
    uint64 internal _set;
    uint64 internal _counter;
    string internal _base;
    string internal _query;

    constructor(address initilalOwner) ERC1155("") Ownable(initilalOwner) {}

    function __Set_init(
        address initialOwner,
        uint64 universe,
        uint64 set,
        string memory uriBase,
        string memory uriQuery
    ) internal {
        _transferOwnership(initialOwner);
        _counter = 0;
        _universe = universe;
        _set = set;
        _base = uriBase;
        _query = uriQuery;
    }

    function _onlyHolder(uint64 id, address holder) internal view {
        _revisions.onlyHolder(id, holder);
    }

    function _nextId() internal returns (uint64) {
        if (_counter >= ID_MAX) revert IdExhausted();
        _counter++;
        return _counter;
    }

    function _create(uint64 id, ObjectMeta memory meta, bytes32[] memory state, address owner) internal {
        _revisions.create(id, meta, state, owner);
        emit Created(id, meta, state, owner);
        _mint(owner, id, 1, "");
        emit URI(_pimUri(id, 1), uint256(id));
    }

    // ISet
    function update(uint64 id, bytes32[] memory state) public virtual override returns (ObjectMeta memory) {
        _revisions.onlyHolder(id, _msgSender());
        ObjectMeta memory meta = _revisions.update(id, state);
        emit Updated(id, meta, state);
        emit URI(_pimUri(id, meta.rev), uint256(id));
        return meta;
    }

    function upgrade(uint64 id, uint32 krev, uint32 srev) public override returns (ObjectMeta memory) {
        _revisions.onlyHolder(id, _msgSender());
        ObjectMeta memory meta = _revisions.upgrade(id, krev, srev);
        emit Upgraded(id, meta);
        emit URI(_pimUri(id, meta.rev), uint256(id));
        return meta;
    }

    function touch(uint64 id) public override returns (ObjectMeta memory) {
        _revisions.onlyHolder(id, _msgSender());
        ObjectMeta memory meta = _revisions.touch(id);
        emit Touched(id, meta);
        emit URI(_pimUri(id, meta.rev), uint256(id));
        return meta;
    }

    function revAt(uint64 id, uint32 rev) public view override returns (uint32) {
        return _revisions.revAt(id, rev);
    }

    function metaAt(uint64 id, uint32 rev) public view override returns (ObjectMeta memory meta) {
        return _revisions.metaAt(id, rev);
    }

    function stateAt(uint64 id, uint32 rev) public view override returns (bytes32[] memory state) {
        return _revisions.stateAt(id, rev);
    }

    function ownerOf(uint64 id) public view override returns (address) {
        return _revisions.ownerOf(id);
    }

    // ERC1155
    function uri(uint256 id) public view override(ERC1155, IERC1155MetadataURI) returns (string memory) {
        uint64 id64 = uint64(id);
        uint32 rev = revAt(id64, 0);
        return _pimUri(id64, rev);
    }

    function _pimUri(uint64 id, uint32 rev) internal view returns (string memory) {
        // {base}{universe}.{self}.{id}/{rev}/meta{query}
        return string(
            abi.encodePacked(
                _base,
                Strings.toString(_universe),
                ".",
                Strings.toString(_set),
                ".",
                Strings.toString(id),
                "/",
                Strings.toString(rev),
                "/meta",
                _query
            )
        );
    }
}
