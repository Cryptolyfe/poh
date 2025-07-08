// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TimedInheritance.sol";

contract TimedInheritanceTest is Test {
    TimedInheritance ti;
    address owner = address(0x1);
    address heir  = address(0x2);

    // runs before each test function
    function setUp() public {
        // give the owner some ETH so they can deploy
        vm.deal(owner, 10 ether);

        // deploy contract as the owner, funding it with 5 ETH
        vm.prank(owner);
        ti = new TimedInheritance{value: 5 ether}(heir);
    }

    /// Owner can “ping” with zero-ETH which resets lastPing
    function testHeartbeat() public {
        uint256 before = ti.lastPing();

        // move time forward 10 days so we can see the change
        vm.warp(block.timestamp + 10 days);

        vm.prank(owner);
        ti.withdraw(0);                      // zero-value ping

        assertGt(ti.lastPing(), before);     // lastPing updated
    }

    /// Heir cannot claim early
    function testHeirCannotClaimTooSoon() public {
        vm.prank(heir);
        vm.expectRevert();                   // any revert is fine
        ti.claimOwnership();
    }

    /// After 30 days of silence, heir can claim
    function testHeirCanClaimAfter30Days() public {
        vm.warp(block.timestamp + 30 days + 1);

        vm.prank(heir);
        ti.claimOwnership();

        assertEq(ti.owner(), heir);
    }

    /// If owner pings, the 30-day timer resets
    function testPingResetsTimer() public {
        // owner pings at day 10
        vm.warp(block.timestamp + 10 days);
        vm.prank(owner);
        ti.withdraw(0);

        // heir tries to claim at day 20 (10 days after ping) → should fail
        vm.warp(block.timestamp + 10 days);
        vm.prank(heir);
        vm.expectRevert();
        ti.claimOwnership();
    }
}
