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
                                 PUBLIC
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

    function createPost(string memory content, string memory community) public {
        require(bytes(content).length > 0, "Content must not be empty");
        require(bytes(community).length > 0, "Community must not be empty");
        require(isCommunityExists(community), "Community does not exist");

        Post memory newPost = Post({
            owner: msg.sender,
            content: content,
            creationTime: block.timestamp,
            upvotes: 0,
            community: community
        });
        uint256 postId = posts.length;
        posts.push(newPost);

        communityPosts[community].push(postId);

        emit Events.PostCreated(postId, msg.sender, content, community);
    }

    function upvotePost(uint256 postId) public {
        require(postId < posts.length, "Invalid post ID");
        require(!postUpvotedBy[postId][msg.sender], "Post already upvoted");

        posts[postId].upvotes += 1;
        postUpvotedBy[postId][msg.sender] = true;

        emit Events.PostUpvoted(postId, msg.sender);
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

    /*//////////////////////////////////////////////////////////////
                              PUBLIC
    //////////////////////////////////////////////////////////////*/

    function getCommunityCount() public view returns (uint256) {
        return communities.length;
    }

    function getCommunityPosts(
        string memory community
    ) public view returns (uint256[] memory) {
        return communityPosts[community];
    }

    function getPostCount() public view returns (uint256) {
        return posts.length;
    }

    function getPost(
        uint256 postId
    )
        public
        view
        returns (address, string memory, uint256, uint256, string memory)
    {
        require(postId < posts.length, "Invalid post ID");

        Post memory post = posts[postId];
        return (
            post.owner,
            post.content,
            post.creationTime,
            post.upvotes,
            post.community
        );
    }
}
