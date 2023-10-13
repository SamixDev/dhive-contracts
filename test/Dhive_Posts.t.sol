// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Dhive_Posts} from "../src/Dhive_Posts.sol";

contract Dhive_Posts_Test is Test {
    // create test for the contract
    address public immutable owner = msg.sender;
    address constant alice = address(0xA11CE);
    Dhive_Posts public dhive_Posts;

    function setUp() public {
        dhive_Posts = new Dhive_Posts();
    }

    /*//////////////////////////////////////////////////////////////
                        TEST CREATE COMMUNITY
    //////////////////////////////////////////////////////////////*/

    // test createCommunity function as not owner
    function test_createCommunityNotOwner(string memory community) public {
        vm.expectRevert("Only the owner can call this function");
        vm.prank(alice);
        dhive_Posts.createCommunity(community);
    }

    // test createCommunity function as owner and community is empty
    function test_createCommunityEmpty() public {
        vm.expectRevert("Community must not be empty");
        dhive_Posts.createCommunity("");
    }

    // test createCommunity function as owner and community is exist
    function test_createCommunityAsOwnerAndIsExist(
        string memory community
    ) public {
        vm.expectRevert("Community already exists");
        community = "apecoin.eth";
        dhive_Posts.createCommunity(community);
    }

    // test createCommunity function as owner and community is not exist
    function test_createCommunityAsOwner(string memory community) public {
        community = "test";
        dhive_Posts.createCommunity(community);
    }

    /*//////////////////////////////////////////////////////////////
                             TEST CREATE POST
    //////////////////////////////////////////////////////////////*/

    // test createPost function with empty content
    function test_createPostEmptyContent(
        string memory content,
        string memory community
    ) public {
        vm.expectRevert("Content must not be empty");
        content = "";
        community = "apecoin.eth";
        dhive_Posts.createPost(content, community);
    }

    // test createPost function with empty community
    function test_createPostEmptyCommunity(
        string memory content,
        string memory community
    ) public {
        vm.expectRevert("Community must not be empty");
        community = "";
        content = "test";
        dhive_Posts.createPost(content, community);
    }

    // test createPost function with community not exist
    function test_createPostCommunityNotExist(
        string memory content,
        string memory community
    ) public {
        vm.expectRevert("Community does not exist");
        community = "test";
        content = "test";
        dhive_Posts.createPost(content, community);
    }

    // test createPost function with community exist
    function test_createPostCommunityExist(
        string memory content,
        string memory community
    ) public {
        content = "test";
        community = "apecoin.eth";
        dhive_Posts.createPost(content, community);
    }

    /*//////////////////////////////////////////////////////////////
                             TEST POST UPVOTE
    //////////////////////////////////////////////////////////////*/

    // test upvotePost function with invalid post ID
    function test_upvotePostInvalidPostId(uint256 postId) public {
        vm.expectRevert("Invalid post ID");
        postId = 100;
        dhive_Posts.upvotePost(postId);
    }

    // test upvotePost twice with valid post ID
    function test_upvotePostTwiceValidPostId(uint256 postId) public {
        dhive_Posts.createPost("test", "apecoin.eth");
        postId = 0;
        vm.prank(alice);
        dhive_Posts.upvotePost(postId);
        vm.expectRevert("Post already upvoted");
        vm.prank(alice);
        dhive_Posts.upvotePost(postId);
    }

    // test upvotePost function with valid post ID
    function test_upvotePostValidPostId(uint256 postId) public {
        dhive_Posts.createPost("test", "apecoin.eth");
        postId = 0;
        vm.prank(alice);
        dhive_Posts.upvotePost(postId);
    }

    /*//////////////////////////////////////////////////////////////
                            TEST POST COMMENT
    //////////////////////////////////////////////////////////////*/

    // test commentPost function with empty content
    function test_commentPostEmptyContent(
        string memory content,
        uint256 postId
    ) public {
        dhive_Posts.createPost("test", "apecoin.eth");
        vm.prank(alice);
        vm.expectRevert("Content must not be empty");
        content = "";
        postId = 0;
        dhive_Posts.addComment(postId, content);
    }

    // test commentPost function with invalid post ID
    function test_commentPostInvalidPostId(
        string memory content,
        uint256 postId
    ) public {
        dhive_Posts.createPost("test", "apecoin.eth");
        vm.prank(alice);
        vm.expectRevert("Invalid post ID");
        content = "test";
        postId = 100;
        dhive_Posts.addComment(postId, content);
    }

    // test commentPost function with valid post ID
    function test_commentPostValidPostId(
        string memory content,
        uint256 postId
    ) public {
        dhive_Posts.createPost("test", "apecoin.eth");
        vm.prank(alice);
        content = "test";
        postId = 0;
        dhive_Posts.addComment(postId, content);
    }
}
