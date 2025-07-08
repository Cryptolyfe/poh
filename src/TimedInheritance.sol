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

    constructor(address _heir) payable {
        require(_heir != address(0), "Heir = zero");
        owner = msg.sender;
        heir = _heir;
        lastPing = block.timestamp;
    }

    function withdraw(uint256 amount) external onlyOwner {
        lastPing = block.timestamp;
        emit Ping(msg.sender, lastPing);

        if (amount > 0) {
            require(address(this).balance >= amount, "insufficient balance");
            (bool ok, ) = payable(msg.sender).call{value: amount}("");
            require(ok, "Transfer failed");
            emit Withdrawl(msg.sender, amount);
        }
    }



    

}
