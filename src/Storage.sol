// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// put all events here

abstract contract Storage {
    address public owner;

    string[] public communities;
    Post[] public posts;

    mapping(string => uint256[]) communityPosts;
    mapping(uint256 => mapping(address => bool)) postUpvotedBy;

    struct Post {
        address owner;
        string content;
        uint256 creationTime;
        uint256 upvotes;
        string community;
    }
}
