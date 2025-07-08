// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimedInheritance {
    address public owner;
    address public heir;
    uint256 public lastPing;
    uint256 public constant IDLE_PERIOD = 30 days;

}
