// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/ISet.sol";
import "../interfaces/ITypes.sol";
import "../libraries/RevisionStore.sol";
import "./PimUri.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ERC1155Upgradeable, OwnableUpgradeable
abstract contract Set is ERC1155, Ownable, ISet {
    error IdExhausted();

    using RevisionStore for RevisionStore.Storage;

    RevisionStore.Storage private _revisions;
    uint64 internal _universe;
    uint64 internal _self;
    uint64 internal _counter;

    constructor(string memory baseUri, address initilalOwner) ERC1155("") Ownable(initilalOwner) {}

    function __Set_init(address initialOwner, uint64 universe_, uint64 self, string memory baseUri) internal {
        _setURI(baseUri);
        _transferOwnership(initialOwner);
        _counter = ID_KIND_SYSTEM_MAX;
        _universe = universe_;
        _self = self;
    }

    function _onlyHolder(uint64 id, address holder) internal view {
        _revisions.onlyHolder(id, holder);
    }

    function _create(uint64 id, ObjectMeta memory meta, bytes32[] memory state, address owner) internal {
        _revisions.create(id, meta, state, owner);
    }

    function _nextId() internal returns (uint64) {
        if (_counter >= ID_MAX) revert IdExhausted();
        _counter++;
        return _counter;
    }

    // ISet
    function update(uint64 id, bytes32[] memory state) public virtual override returns (ObjectMeta memory) {
        return _revisions.update(id, state);
    }

    function upgrade(uint64 id, uint32 krev, uint32 srev) public override returns (ObjectMeta memory) {
        _revisions.onlyHolder(id, _msgSender());
        ObjectMeta memory meta = _revisions.upgrade(id, krev, srev);
        emit URI(_pimUri(id, meta.rev), uint256(id));
        return meta;
    }

    function touch(uint64 id) public override returns (ObjectMeta memory) {
        _revisions.onlyHolder(id, _msgSender());
        ObjectMeta memory meta = _revisions.touch(id);
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
    function _setURI(string memory uri_) internal override {
        ERC1155._setURI(uri_);
    }

    // internals
    function _erc1155Uri() internal view returns (string memory) {
        // https://pim.li/1155/{universe}/{self}/0x\{id\}/meta
        return PimUri.erc1155Uri(_universe, _self);
    }

    function _pimUri(uint64 id, uint32 rev) internal view returns (string memory) {
        // https://pim.li/{universe}.{self}.{id}/{rev}/meta
        return PimUri.pimUri(_universe, _self, id, rev);
    }
}
