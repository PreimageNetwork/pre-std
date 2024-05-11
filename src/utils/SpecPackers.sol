// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/ITypes.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

library SpecPackers {
    error TooManyElements();
    error InvalidElementType();
    error InvalidRelationId();
    error TooManyRelations();

    function packStateSpec(ElementType[] memory stateSpec) internal pure returns (bytes32) {
        if (stateSpec.length > STATE_SPEC_CAPACITY) revert TooManyElements();
        uint256 packed = 0;
        uint256 bits = 256;
        for (uint256 i = 0; i < stateSpec.length; i++) {
            uint256 elemType = uint256(stateSpec[i]);
            if (elemType < ELEMENT_TYPE_MIN || elemType > ELEMENT_TYPE_MAX) revert InvalidElementType();
            bits -= 8;
            packed |= (elemType << bits);
        }
        return bytes32(packed);
    }

    function unpackStateSpec(bytes32 packed) internal pure returns (ElementType[] memory) {
        // determine count of elements
        uint256 size = 0;
        for (; size < packed.length; size++) {
            if (packed[size] == 0) {
                break;
            }
        }
        // decode to array
        ElementType[] memory stateSpec = new ElementType[](size);
        for (uint256 i = 0; i < stateSpec.length; i++) {
            stateSpec[i] = ElementType(uint8(packed[i]));
        }
        return stateSpec;
    }

    function packRelationSpec(uint64[] memory relSpec) internal pure returns (bytes32, bytes32) {
        if (relSpec.length > REL_SPEC_CAPACITY) revert TooManyRelations();
        uint256 packed0 = 0;
        uint256 packed1 = 0;
        uint256 i = 0;
        for (uint256 bits = 256; i < Math.min(relSpec.length, 4); i++) {
            if (relSpec[i] < ID_MIN || relSpec[i] > ID_MAX) revert InvalidRelationId();
            bits -= 64;
            packed0 |= (uint256(relSpec[i]) << bits);
        }
        for (uint256 bits = 256; i < Math.min(relSpec.length, 8); i++) {
            if (relSpec[i] < ID_MIN || relSpec[i] > ID_MAX) revert InvalidRelationId();
            bits -= 64;
            packed1 |= (uint256(relSpec[i]) << bits);
        }
        return (bytes32(packed0), bytes32(packed1));
    }

    function unpackRelationSpec(bytes32 packed0, bytes32 packed1) internal pure returns (uint64[] memory) {
        uint64[] memory rels = new uint64[](8);
        rels[0] = uint64(uint256(packed0) >> 192);
        rels[1] = uint64(uint256(packed0) >> 128);
        rels[2] = uint64(uint256(packed0) >> 64);
        rels[3] = uint64(uint256(packed0) >> 0);
        rels[4] = uint64(uint256(packed1) >> 192);
        rels[5] = uint64(uint256(packed1) >> 128);
        rels[6] = uint64(uint256(packed1) >> 64);
        rels[7] = uint64(uint256(packed1) >> 0);
        uint256 cnt = 0;
        for (; cnt < rels.length; cnt++) {
            if (rels[cnt] == 0) {
                break;
            } else if (rels[cnt] < ID_MIN || rels[cnt] > ID_MAX) {
                revert InvalidRelationId();
            }
        }
        uint64[] memory ret = new uint64[](cnt);
        for (uint256 i = 0; i < cnt; i++) {
            ret[i] = rels[i];
        }
        return ret;
    }

    // function packAdjacencySpec(uint64[] memory adjSpec)
    //     internal
    //     pure
    //     returns (uint256 adjSpec0, uint256 adjSpec1, uint256 adjSpec2, uint256 adjSpec3)
    // {
    //     require(adjSpec.length <= ADJ_SPEC_CAPACITY, "");
    //     uint256 bits = 256;
    //     uint256 i = 0;
    //     adjSpec0 = 0;
    //     for (; i < Math.min(adjSpec.length, 4); i++) {
    //         bits -= 64;
    //         adjSpec0 |= (uint256(adjSpec[i]) << bits);
    //     }
    //     bits = 256;
    //     adjSpec1 = 0;
    //     for (; i < Math.min(adjSpec.length, 8); i++) {
    //         bits -= 64;
    //         adjSpec1 |= (uint256(adjSpec[i]) << bits);
    //     }
    //     bits = 256;
    //     adjSpec2 = 0;
    //     for (; i < Math.min(adjSpec.length, 12); i++) {
    //         bits -= 64;
    //         adjSpec2 |= (uint256(adjSpec[i]) << bits);
    //     }
    //     bits = 256;
    //     adjSpec3 = 0;
    //     for (; i < Math.min(adjSpec.length, 16); i++) {
    //         bits -= 64;
    //         adjSpec3 |= (uint256(adjSpec[i]) << bits);
    //     }
    // }
}
