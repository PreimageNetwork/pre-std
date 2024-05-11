// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

uint64 constant ID_KIND_OF_SET = 1;
uint64 constant ID_KIND_OF_KIND = 2;
uint64 constant ID_KIND_OF_REL = 3;

uint64 constant ID_SET_OF_SET = 1;
uint64 constant ID_SET_OF_KIND = 2;
uint64 constant ID_SET_OF_REL = 3;

uint64 constant ID_SET_SYSTEM_MAX = 16;
uint64 constant ID_KIND_SYSTEM_MAX = 16;
uint64 constant ID_REL_SYSTEM_MAX = 16;

uint64 constant ID_MIN = 1;
uint64 constant ID_MAX = type(uint64).max - 1;
uint64 constant ID_UNSPECIFIED = 0;
uint64 constant ID_WILDCARD = type(uint64).max;

uint32 constant REV_NEW = 1;
uint32 constant REV_DESTROYED = type(uint32).max;

uint256 constant STATE_SPEC_CAPACITY = 16;
uint256 constant REL_SPEC_CAPACITY = 8;
uint256 constant ADJ_SPEC_CAPACITY = 8;

enum RecordStatus {
    NONE,
    ACTIVE,
    INACTIVE,
    DELETED
}

enum StateField {
    NONE,
    IMAGE,
    JSON,
    WASM,
    BYTES32,
    UINT,
    PLANE_SPEC,
    STATE_SPEC,
    END
}

uint256 constant ELEMENT_TYPE_MIN = 1;
uint256 constant ELEMENT_TYPE_MAX = 254;

enum ElementType {
    NONE,
    IMAGE,
    JSON,
    WASM,
    BYTES32,
    UINT,
    PLANE_SPEC,
    STATE_SPEC,
    END
}

enum PossessionMode {
    NONE,
    ATTACH,
    DEPOSIT,
    DELEGATE,
    POST,
    TRANSFER,
    BURN
}

enum ConnectionMode {
    NONE,
    DEP_TO_DEST
}

enum TokenStandard {
    NONE,
    NATIVE,
    ERC20,
    ERC721,
    ERC1155
}

enum FeePolicy {
    NONE,
    FREE,
    CHARGE
}

enum PermPolicy {
    NONE,
    ANYONE,
    OWNER,
    ALLOWLIST,
    NATIVE_HOLDER,
    ERC20_HOLDER,
    ERC721_HOLDER,
    ERC1155_HOLDER
}

struct ObjectId {
    uint64 chain;
    uint64 bp;
    uint64 fa;
    uint64 sn;
}

struct ObjectMeta {
    uint32 rev;
    uint32 krev;
    uint32 srev;
    uint32 cap;
    uint64 kind;
    uint64 set;
}

struct ObjectDesign {
    uint64 start;
    uint64 end;
    uint64 bpId;
    uint32 bpRev;
    uint32 resId;
    uint256 locator;
    StateField[] stored;
    StateField[] input;
    StateField[] generated;
    uint8[] output;
}

struct TokenAmount {
    address addr;
    TokenStandard std;
    uint24 id;
    uint64 amount;
}

struct SupplyRule {
    uint32 index;
    PermPolicy permPolicy;
    FeePolicy feePolicy;
    uint40 openning;
    uint40 closing;
    uint64 start;
    uint64 end;
    uint256 perm;
    TokenAmount fee;
}

enum ResourceType {
    NONE,
    PLAIN_TABLE,
    PERMUTATION_TABLE,
    PLAIN_TABLE_ROOT
}

enum ResourceLocatorType {
    NONE,
    PATTERN_MAPPING
}

struct ResourceSchema {
    ResourceType type_;
    uint16 rows;
    StateField[] cols;
    uint16[] ends;
}

struct ResourceLocatorPatternMapping {
    uint8 type_;
    uint8 _zero;
    uint16 offset;
    int16 multiplier;
    uint16 destStart;
    uint16 destEnd;
}

struct RuleInput {
    uint32 index;
    bytes32[] proof;
}

struct ResourceInput {
    uint8 inputLen;
    uint8 storedLen;
    uint16 row;
    uint256[] input;
    uint256[] storedPreImage;
    bytes32[] storedProof;
}

struct MintDataLayout {
    uint32 rule;
    uint8 ruleProofLen;
    uint8 inputLen;
    uint8 preImageLen;
    uint8 preImageProofLen;
    uint64 preImageIndex;
    bytes32[] ruleProof;
    uint256[] input;
    uint256[] preImage;
    bytes32[] preImageProof;
}

struct MintData {
    uint32 rule;
    uint64 preImageIndex;
    bytes32[] ruleProof;
    uint256[] input;
    uint256[] preImage;
    bytes32[] preImageProof;
}
