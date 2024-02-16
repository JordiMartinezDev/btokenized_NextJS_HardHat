// SPDX-License-Identifier: MIT


// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations ( structs.. )
// State variables ( addresses, mappings, uint..)
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;


import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    error BasicNft__TokenUriNotFound();

    mapping(uint256 tokenId => string tokenUri) private s_tokenIdToUri;
    uint256 private s_tokenCounter;

    constructor(string memory _name,string memory _symbol) ERC721(_name, _symbol) {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert BasicNft__TokenUriNotFound();
        }
        return s_tokenIdToUri[tokenId];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
    function setNftApproval(address approvedAddres) public {

        setApprovalForAll(approvedAddres, true);
    }
    //JUST A TEST
    function getMyNftBalance(address owner) public view  returns (uint256) {
        
        return balanceOf(msg.sender);
    }
}