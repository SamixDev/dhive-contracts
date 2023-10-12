// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// put all events here

library Events {
    event CommunityCreated(string communityName);
    event PostCreated(
        uint256 postId,
        address owner,
        string content,
        string community
    );
}
