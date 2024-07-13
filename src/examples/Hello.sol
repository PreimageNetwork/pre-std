// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/ISetProvider.sol";
import "../interfaces/IMintableSet.sol";
import "../utils/Set.sol";

contract Hello is IMintableSet, ISetProvider, Set {
    error NoSpecifyingId();
    error NotImplemented();

    address _setRegistry;
    address _kindRegistry;
    address _relRegistry;
    uint64 _kind;

    constructor() Set(msg.sender) {
        _kind = 18;
    }

    function mint(uint64 id) external override returns (uint64) {
        if (id != 0) revert NoSpecifyingId();
        id = _nextId();
        ObjectMeta memory meta = ObjectMeta({rev: 1, krev: 0, srev: 0, cap: 0, kind: _kind, set: _set});
        bytes32[] memory state = new bytes32[](0);
        _create(id, meta, state, msg.sender);
        emit URI(_pimUri(id, meta.rev), uint256(id));
        return id;
    }

    function mint(uint64, /*id*/ bytes memory /*input*/ ) external pure override returns (uint64) {
        revert NotImplemented();
    }

    function onRegister(
        address setRegistry,
        address kindRegistry,
        address relRegistry,
        address owner,
        uint64 universe,
        uint64 self,
        string memory uriBase,
        string memory uriQuery
    ) external override returns (bytes4) {
        __Set_init(owner, universe, self, uriBase, uriQuery);
        _setRegistry = setRegistry;
        _kindRegistry = kindRegistry;
        _relRegistry = relRegistry;
        return ISetProvider.onRegister.selector;
    }

    function onTouch(uint64 /*id*/ ) external pure override returns (bytes4) {
        return ISetProvider.onTouch.selector;
    }

    function onTransfer(uint64, /*id*/ address, /*from*/ address /*to*/ ) external pure override returns (bytes4) {
        return ISetProvider.onTransfer.selector;
    }
}
