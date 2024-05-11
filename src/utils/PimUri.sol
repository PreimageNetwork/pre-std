// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

library PimUri {
    string constant BASE = "https://pim.li/";
    string constant BASE_1155 = "https://pim.li/1155/";

    function erc1155Uri(uint64 universe, uint64 set) internal pure returns (string memory) {
        // https://pim.li/1155/{universe}/{set}/0x\{id\}/meta
        return string(abi.encodePacked(BASE_1155, Strings.toString(universe), "/", Strings.toString(set), "/{id}/meta"));
    }

    function erc1155Uri(uint64 universe, uint64 set, uint32 rev) internal pure returns (string memory) {
        // https://pim.li/1155/{universe}/{set}/0x\{id\}/{rev}/meta
        return string(
            abi.encodePacked(
                BASE_1155,
                Strings.toString(universe),
                "/",
                Strings.toString(set),
                "/{id}/",
                Strings.toString(rev),
                "/meta"
            )
        );
    }

    function erc1155Uri(uint64 universe, uint64 set, uint64 id, uint32 rev) internal pure returns (string memory) {
        // https://pim.li/1155/{universe}/{set}/0x\{id\}/{rev}/meta
        return string(
            abi.encodePacked(
                BASE_1155,
                Strings.toString(universe),
                "/",
                Strings.toString(set),
                "/",
                Strings.toString(id),
                "/",
                Strings.toString(rev),
                "/meta"
            )
        );
    }

    function pimUri(uint64 universe, uint64 set, uint64 id, uint32 rev) internal pure returns (string memory) {
        // https://pim.li/{universe}.{self}.{id}/{rev}/meta
        return string(
            abi.encodePacked(
                BASE,
                Strings.toString(universe),
                ".",
                Strings.toString(set),
                ".",
                Strings.toString(id),
                "/",
                Strings.toString(rev),
                "/meta"
            )
        );
    }
}
