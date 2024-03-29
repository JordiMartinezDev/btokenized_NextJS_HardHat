//SPDX-License-Identifier: MIT

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
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract MarketPlace is ReentrancyGuard, Ownable{

    error MarketPlace__SetFeeMustBeZeroOrHigher();
    error MarketPlace__NotOwner();
    error MarketPlace__NotEnoughMoneySent();

    // I think _marketProductId is unnecessary on MarketItem struct
    struct MarketItem{
        uint256 marketProductId;
        address nftContract;
        uint256 tokenId;
        uint256 price;
    }

    uint256 private _marketProductId;
    uint256 private _itemsSold;
    uint256 private _listingFee = 0.025 ether;
    
    address payable private feeMarketPlaceAddress;

    mapping(uint256 _marketProductId => MarketItem postedItems) private idToPostedMarketItems;

    event MarketItemCreated(uint indexed marketProductId, address indexed nftContract, uint256 indexed tokenId, uint256 indexed price);
    event ListingFeeUpdated(uint indexed listingFee);

    constructor() Ownable(msg.sender){

        // To simplify the development we set the FeeAddress receiver as the deployer of the contract. 
        // The address will be different in production
        feeMarketPlaceAddress = owner();

    }

    function setListingFee(uint256 fee) onlyOwner{
        if(fee < 0) revert MarketPlace__SetFeeMustBeZeroOrHigher();
        _listingFee = fee;
        emit ListingFeeUpdated(_listingFee);
    }

    function getListingFee() returns(uint256){
        return _listingFee;
    }

    function publishhNft(address nftContractAddres,uint256 id, uint256 price) public nonReentrant {

        // I think _marketProductId is unnecessary on MarketItem struct
        idToPostedMarketItems[_marketProductId] = MarketItem(_marketProductId, nftContractAddres, id, price);
        _marketProductId++;

        //check owner
        if(msg.sender == nftContractAddres._ownerOf(id)){

        IERC721(nftContractAddres).transferFrom(msg.sender, address(this), id);
        emit MarketItemCreated(_marketProductId, nftContractAddres, id, price);

        }else revert MarketPlace__NotOwner();

    }

    function purchaseItem(uint256 marketProductId) payable nonReentrant{

        MarketItem item = idToPostedMarketItems[marketProductId];

        //check price
        if(msg.value < item.price) revert MarketPlace__NotEnoughMoneySent();
        
        //sending msg.value to the seller&owner of the nft
        item.marketProductId._ownerOf(item.tokenId).transfer(msg.value);
        
        //transferring the ownership of the nft to the buyer
        item.nftContract.transferFrom(address(this),msg.sender,item.tokenId);
        removeFromListings(marketProductId);

        payable(feeMarketPlaceAddress).transfer(_listingFee);

    }

    function removeFromListings(uint256 marketProductId) private {

    }

}