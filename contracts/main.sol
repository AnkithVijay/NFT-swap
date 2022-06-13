//SPDX-License-Identifier: MIT
//Developer: KryptoKoders
//Github: https://github.com/KwikKodersIND/
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Main is ERC721 {
    constructor() ERC721("NFTSwap", "NTSP") {}

    uint256 counter = 0;

    enum TradingObjectStatus {
        Pending,
        Confirmed,
        Cancelled,
        Expired,
        WaitingForConfirmation1,
        WaitingForConfirmation2
    }

    struct SwapTradingObject {
        uint256 id;
        address owner1;
        address owner2;
        uint256 token1;
        uint256 token2;
        address token1Address;
        address token2Address;
        bool owner1Confirmed;
        bool owner2Confirmed;
        string chainId;
        TradingObjectStatus status;
    }

    struct OwnerTradingObject {
        address owner;
        uint256 tradingId;
        bool isActive;
        uint256 creationTime;
        uint256 expiryTime;
    }

    OwnerTradingObject public ownerTradingObject;
    OwnerTradingObject[] public ownerTradingObjects;

    mapping(address => OwnerTradingObject[]) public ownerTradingObjectsCount;

    SwapTradingObject public swapTradingObject;
    SwapTradingObject[] public swapTradingObjects;

    mapping(uint256 => SwapTradingObject[]) public swapsAvailable;

    function getID() internal returns (uint256) {
        return ++counter;
    }

    function createTrade(
        address caddress,
        uint256 tokenID,
        string calldata chainId,
        uint256 expiryTime
    ) external payable {
        uint256 id = getID();
        ownerTradingObjects.push(
            OwnerTradingObject(
                msg.sender,
                id,
                true,
                block.timestamp,
                block.timestamp + expiryTime
            )
        );
        SwapTradingObject memory _swapTradingObj;
        _swapTradingObj.id = id;
        _swapTradingObj.owner1 = msg.sender;
        _swapTradingObj.token1 = tokenID;
        _swapTradingObj.token1Address = caddress;
        _swapTradingObj.status = TradingObjectStatus.Pending;
        _swapTradingObj.chainId = chainId;
        swapTradingObjects.push(_swapTradingObj);
    }
}
