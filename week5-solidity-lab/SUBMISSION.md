# Staking Smart Contract Assignment Submission

## Student Info

- **Name**: 이정환 (Lee Jeong-hwan)
- **GitHub Username**: ijeonghwan
- **Wallet Address**: `0xF0Fa85741d13635257c2810C3944ABcaACE670e7`

---

## 1. Contract Source Code / GitHub URL

- **GitHub Repository**: https://github.com/ijeonghwan/blockchain
- **Contract File**: [Staking.sol](https://github.com/ijeonghwan/blockchain/blob/main/week5-solidity-lab/contracts/Staking.sol)
- **Verified on Etherscan**: https://sepolia.etherscan.io/address/0xAeaEba41765Ea4a9286356EfA350201E4C9BC110#code

### Implemented Features

- ✅ **Stake (deposit)** — Users can deposit ETH into the contract
- ✅ **Withdraw** — Users can withdraw staked ETH after lock period
- ✅ **Check staked balance** — `getStakedBalance(address)` view function
- ✅ **Reward calculation** — Time-based rewards (basis points per second)
- ✅ **Time-locked staking** — 60-second lock period before withdrawal
- ✅ **Emergency withdrawal** — Allows early exit with 10% fee

### Tech Stack

- **Language**: Solidity ^0.8.26
- **Framework**: Hardhat
- **Network**: Sepolia Testnet
- **RPC Provider**: Infura

---

## 2. Deployment Transaction Hash

| Field | Value |
|-------|-------|
| **TX Hash** | `0xd5b93e799a2c19ba6c239aac6716752dbb26a5913cd8c4832f60b6ce2fddf0fc` |
| **Contract Address** | `0xAeaEba41765Ea4a9286356EfA350201E4C9BC110` |
| **Block** | `10735777` |
| **Network** | Sepolia Testnet |
| **Etherscan** | [View on Etherscan](https://sepolia.etherscan.io/tx/0xd5b93e799a2c19ba6c239aac6716752dbb26a5913cd8c4832f60b6ce2fddf0fc) |

**Constructor Arguments**:

- `_rewardRate`: `1` (0.01% per second)
- `_lockDuration`: `60` (1 minute)
- `_emergencyFee`: `10` (10%)
- `value` (initial reward pool): `0.005 ETH`

---

## 3. Stake Transaction Hash

| Field | Value |
|-------|-------|
| **TX Hash** | `0x51378b966bfce5818065a0fd53f5521299b2e45ac1e7581e380aeb148b8dd85b` |
| **Function** | `stake()` (payable) |
| **Amount Staked** | `0.005 ETH` |
| **From** | `0xF0Fa85741d13635257c2810C3944ABcaACE670e7` |
| **To** | `0xAeaEba41765Ea4a9286356EfA350201E4C9BC110` |
| **Etherscan** | [View on Etherscan](https://sepolia.etherscan.io/tx/0x51378b966bfce5818065a0fd53f5521299b2e45ac1e7581e380aeb148b8dd85b) |

---

## 4. Withdrawal Transaction Hash

| Field | Value |
|-------|-------|
| **TX Hash** | `0x919331352c9696d209193b0e6d5faa8c9e2162fe281b22e4d04332f17f8f8cca` |
| **Function** | `withdraw()` |
| **Withdrawal Type** | Normal (after 60-second lock period) |
| **Principal + Reward** | `0.003 ETH + reward` |
| **From** | `0xF0Fa85741d13635257c2810C3944ABcaACE670e7` |
| **Etherscan** | [View on Etherscan](https://sepolia.etherscan.io/tx/0x919331352c9696d209193b0e6d5faa8c9e2162fe281b22e4d04332f17f8f8cca) |

---

## Bonus: Additional Transactions

To demonstrate **all three additional features** (reward calculation, time-locked staking, emergency withdrawal):

| # | Action | TX Hash |
|---|--------|---------|
| 1 | First Stake (0.005 ETH) | [`0x51378b96...d85b`](https://sepolia.etherscan.io/tx/0x51378b966bfce5818065a0fd53f5521299b2e45ac1e7581e380aeb148b8dd85b) |
| 2 | **Emergency Withdraw** (with 10% fee) | [`0xc8d1893e...b2b4`](https://sepolia.etherscan.io/tx/0xc8d1893ed205a4ae9a8c967e03fd2b7598f91eed71205080777aed427d56b2b4) |
| 3 | Second Stake (0.003 ETH) | [`0xd8d02d96...f92c`](https://sepolia.etherscan.io/tx/0xd8d02d965cc8a4e0afd9ed5ef0a8facbb7b979e1deaa4e636b022dbb0e94f92c) |
| 4 | **Normal Withdraw** (after lock + reward) | [`0x91933135...8cca`](https://sepolia.etherscan.io/tx/0x919331352c9696d209193b0e6d5faa8c9e2162fe281b22e4d04332f17f8f8cca) |

---

## Summary

| Requirement | Status |
|-------------|--------|
| Deploy to Sepolia/Giwa testnet | ✅ Sepolia |
| Verify on blockchain explorer | ✅ Etherscan verified |
| Stake function | ✅ Tested |
| Withdraw function | ✅ Tested |
| Check staked balance | ✅ `getStakedBalance()` |
| Reward calculation (bonus) | ✅ Implemented |
| Time-locked staking (bonus) | ✅ 60s lock |
| Emergency withdrawal (bonus) | ✅ 10% fee |

---

## Quick Links

- 📂 [GitHub Repo](https://github.com/ijeonghwan/blockchain)
- 📄 [Staking.sol Source](https://github.com/ijeonghwan/blockchain/blob/main/week5-solidity-lab/contracts/Staking.sol)
- 🔍 [Contract on Etherscan](https://sepolia.etherscan.io/address/0xAeaEba41765Ea4a9286356EfA350201E4C9BC110)
- 🚀 [Deploy Script](https://github.com/ijeonghwan/blockchain/blob/main/week5-solidity-lab/scripts/deploy-staking.js)
