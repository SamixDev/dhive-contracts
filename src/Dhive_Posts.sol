// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Events} from "./Events.sol";
import {Storage} from "./Storage.sol";

contract Dhive_Posts is Storage {
    /*//////////////////////////////////////////////////////////////
                                 CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() {
        owner = msg.sender;
        // Initialize with default community
        createCommunity("apecoin.eth");
    }

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                 EXTERNAL
    //////////////////////////////////////////////////////////////*/
    function createCommunity(string memory community) public onlyOwner {
        require(bytes(community).length > 0, "Community must not be empty");

        if (!isCommunityExists(community)) {
            communities.push(community);
            emit Events.CommunityCreated(community);
        } else {
            revert("Community already exists");
        }
    }

    /*//////////////////////////////////////////////////////////////
                              INTERNAL
    //////////////////////////////////////////////////////////////*/

    function isCommunityExists(
        string memory community
    ) internal view returns (bool) {
        for (uint256 i = 0; i < communities.length; i++) {
            if (
                keccak256(abi.encodePacked(communities[i])) ==
                keccak256(abi.encodePacked(community))
            ) {
                return true;
            }
        }
        return false;
    }
}
