// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimedInheritance {
    address public owner;
    address public heir;
    uint256 public lastPing;
    uint256 public constant IDLE_PERIOD = 30 days;

    event Ping(address indexed by, uint256 at);
    event HeirChanged(address indexed previous, address indexed newHeir);
    event OwnershipTaken(address indexed previousOwner, address indexed newOwner);
    event Withdrawl(address indexed by, uint256 amount);

    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyHeir(){
        require(msg.sender == heir, "Not heir");
        _;
    }

    

}
