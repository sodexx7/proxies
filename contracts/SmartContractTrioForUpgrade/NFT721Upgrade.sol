// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// import {IERC721, ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC721,ERC721Upgradeable,Initializable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";


import {IERC2981, ERC2981Upgradeable} from "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";


import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title This contract's NFT  as the staking NFT in the StakingContract
 * @dev
 * 1:This NFT MAX_SUPPLY is 20;
 * 2: Support superMint and Normal Mint, each has different payment price, This implementation is based on the merkle tree and bitmap.
 *      reference:https://github.com/jordanmmck/MerkleTreesBitmaps/blob/master/src/AirDropToken.sol
 * 3: Can show the royalty info, currently all these related rewards is bond with the contract owner;
 * 4: Only the owner can withdraw this contract's balance, which acquired by selling the NFT.
 * 5: apply Ownable2Step instead of Ownable to improve the security level, beside that disable the function renounceOwnership
 * @author  Tony
 * @notice
 */
contract NFT721Upgrade is ERC721Upgradeable, ERC2981Upgradeable, Ownable2StepUpgradeable,UUPSUpgradeable {
    // check the minter belong to the uperMintList by merkle lib
    bytes32 public _merkleRoot;
    // check the mint whether or not minted
    BitMaps.BitMap private _superMintList;

    uint8 private constant MAX_SUPPLY = 20;

    uint128 public _totalSupply;

    // for simple show, currently ignore
    string public constant TOKEN_URI = "test url";

    // constructor(bytes32 merkleRoot) ERC721("NFT721", "NFT1") Ownable(msg.sender) {
    //     _merkleRoot = merkleRoot;
    //     // set the reward rate as 2.5%, the least price should bigger than 10**4wei
    //     _setDefaultRoyalty(owner(), 250);
    // }


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(bytes32 merkleRoot) external initializer {
        // init parents contracts
        __ERC721_init("NFT721", "NFT1");
        __Ownable_init(msg.sender);

        _merkleRoot = merkleRoot;
        // set the reward rate as 2.5%, the least price should bigger than 10**4wei
        _setDefaultRoyalty(owner(), 250);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, ERC2981Upgradeable) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC2981).interfaceId
            || super.supportsInterface(interfaceId);
    }

    /**
     * @dev
     * check the paymentInfo directly by the msg.value, paymentInfo was not included in the proof. If need, can put the info
     * while buidling the merkle tree.
     */
    function mintNftByProof(bytes32[] calldata proof, uint256 index) external payable {
        require(_totalSupply < MAX_SUPPLY, "Beyond totalSupply");

        // verify proof
        _verifyProof(proof, index, msg.sender);

        require(msg.value >= 0.01 ether, "NOT Enough ETH to mint at a discount");

        // check if the minter  claimed or not
        require(!BitMaps.get(_superMintList, index), "Already claimed");

        // set airdrop as claimed
        BitMaps.setTo(_superMintList, index, true);

        ++_totalSupply;
        _safeMint(msg.sender, _totalSupply);
    }

    /**
     * @dev everyone can mint, and not limit the numers.
     * If necessary, should prevent re-entrance ??
     */
    function mintNft() external payable {
        require(_totalSupply < MAX_SUPPLY, "Beyond totalSupply");
        require(msg.value >= 0.1 ether, "NOT Enough ETH to mint");

        ++_totalSupply;
        _safeMint(msg.sender, _totalSupply);
    }

    function widthDrawBalance() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }



    // Disable this function to avoid unnecessary ownership operations, which may lead to losing the contract's control forever.
    function renounceOwnership() public pure override {
        require(false, "can't renounce");
    }

    function _verifyProof(bytes32[] memory proof, uint256 index, address addr) private view {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(addr, index))));
        require(MerkleProof.verify(proof, _merkleRoot, leaf), "Invalid proof");
    }
}
