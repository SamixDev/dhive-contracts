// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";
import {Dhive_Posts} from "../src/Dhive_Posts.sol";

contract Dhive_Posts_Test is Test {
    // create test for the contract
    address public immutable owner = msg.sender;
    address constant alice = address(0xA11CE);
    Dhive_Posts public dhive_Posts;

    function setUp() public {
        dhive_Posts = new Dhive_Posts();
    }

    // test createCommunity function as not owner
    function test_createCommunityNotOwner(string memory community) public {
        vm.expectRevert("Only the owner can call this function");
        vm.prank(alice);
        dhive_Posts.createCommunity(community);
    }

    function test_createCommunityEmpty() public {
        vm.expectRevert("Community must not be empty");
        dhive_Posts.createCommunity("");
    }

    function test_createCommunityAsOwnerAndIsExist(
        string memory community
    ) public {
        vm.expectRevert("Community already exists");
        community = "apecoin.eth";
        dhive_Posts.createCommunity(community);
    }

    function test_createCommunityAsOwner(string memory community) public {
        community = "test";
        dhive_Posts.createCommunity(community);
    }
}
