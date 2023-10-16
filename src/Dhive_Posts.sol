// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Events} from "./Events.sol";
import {Storage} from "./Storage.sol";

contract DhivePosts is Storage {
    /*//////////////////////////////////////////////////////////////
                                 CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() {
        owner = msg.sender;
        // Initialize with default community
        createCommunity("dhive_test");
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

        emit Events.PostCreated(
            postId,
            msg.sender,
            content,
            community,
            block.timestamp
        );
    }

    function upvotePost(uint256 postId) public {
        require(postId < posts.length, "Invalid post ID");
        require(!postUpvotedBy[postId][msg.sender], "Post already upvoted");

        posts[postId].upvotes += 1;
        postUpvotedBy[postId][msg.sender] = true;

        emit Events.PostUpvoted(postId, msg.sender);
    }

    function addComment(uint256 postId, string memory content) public {
        require(postId < posts.length, "Invalid post ID");
        require(bytes(content).length > 0, "Content must not be empty");

        Comment memory newComment = Comment({
            owner: msg.sender,
            content: content,
            creationTime: block.timestamp,
            postId: postId
        });

        uint256 commentId = comments.length;
        comments.push(newComment);

        emit Events.CommentAdded(
            commentId,
            msg.sender,
            content,
            postId,
            block.timestamp
        );
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
                            PUBLIC VIEW
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

    function getCommentCount(uint256 postId) public view returns (uint256) {
        require(postId < posts.length, "Invalid post ID");

        uint256 commentCount = 0;
        for (uint256 i = 0; i < comments.length; i++) {
            if (comments[i].postId == postId) {
                commentCount++;
            }
        }
        return commentCount;
    }

    function getComment(
        uint256 postId,
        uint256 commentIndex
    ) public view returns (address, string memory, uint256) {
        require(postId < posts.length, "Invalid post ID");

        uint256 commentCount = 0;
        for (uint256 i = 0; i < comments.length; i++) {
            if (comments[i].postId == postId) {
                if (commentCount == commentIndex) {
                    Comment memory comment = comments[i];
                    return (
                        comment.owner,
                        comment.content,
                        comment.creationTime
                    );
                }
                commentCount++;
            }
        }
        revert("Invalid comment index");
    }
}
