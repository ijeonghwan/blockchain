// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Faucet {
    address public owner;
    uint public amountAllowed = 0.01 ether;
    mapping(address => uint) public lastAccessTime;
    uint public cooldownTime = 1 minutes;

    event Deposit(address indexed from, uint amount);
    event Withdrawal(address indexed to, uint amount);

    constructor() payable {
        owner = msg.sender;
    }

    function requestTokens() public {
        require(address(this).balance >= amountAllowed, "Faucet empty");
        require(
            block.timestamp >= lastAccessTime[msg.sender] + cooldownTime,
            "Cooldown active, try again later"
        );

        lastAccessTime[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(amountAllowed);

        emit Withdrawal(msg.sender, amountAllowed);
    }

    function setAmountAllowed(uint newAmount) public {
        require(msg.sender == owner, "Only owner");
        amountAllowed = newAmount;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
