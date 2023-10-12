// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Dhive_Posts {
    address public owner;

    string[] public communities;

    event CommunityCreated(string communityName);

    constructor() {
        owner = msg.sender;
        // Initialize with default community
        createCommunity("apecoin.eth");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function createCommunity(string memory community) public onlyOwner {
        require(bytes(community).length > 0, "Community must not be empty");

        if (!isCommunityExists(community)) {
            communities.push(community);
            emit CommunityCreated(community);
        } else {
            revert("Community already exists");
        }
    }

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
