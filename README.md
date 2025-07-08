# Timed Inheritance

A self‑custody inheritance vault written in **Solidity 0.8.20**. The **owner** can withdraw ETH (or just “ping” with 0 ETH) to stay active. If 30 days pass with no activity, the **heir** can claim ownership and appoint the next heir.

> Built with **Foundry**; includes unit tests, gas report & one-click Sepolia deployment.

---

## Contract

| Item              | Value                                                       |
| ----------------- | ----------------------------------------------------------- |
| **Filename**      | `src/TimedInheritance.sol`                                  |
| **Idle period**   | `30 days` (compile‑time `constant`)                         |
| **Key functions** | `withdraw(uint256)`, `claimOwnership()`, `setHeir(address)` |
| **Events**        | `Ping`, `Withdrawal`, `HeirChanged`, `OwnershipTaken`       |
| **External libs** | None                                                        |


---

## Quick start

```bash
git clone https://github.com/cryptolyfe/poh.git && cd poh
brew install foundry                 # if missing
forge build                          # compile (<1 s)
forge test --gas-report              # 4 tests • all green
```

---

## Contract API

| Function                | Access    | Purpose                                                                                   |
| ----------------------- | --------- | ----------------------------------------------------------------------------------------- |
| `withdraw(uint amount)` | **owner** | Send `amount` wei to owner; `amount = 0` ≡ heartbeat. Updates `lastPing`.                 |
| `claimOwnership()`      | **heir**  | If `block.timestamp ≥ lastPing + 30 days`, transfers `owner` to `heir` and clears `heir`. |
| `setHeir(address)`      | **owner** | Nominate a new heir at any time.                                                          |
| `receive()`             | anyone    | Accept plain ETH transfers.                                                               |

State variables (`public`): `owner`, `heir`, `lastPing`, `IDLE_PERIOD`.

---

## Testing

```bash
forge test -vv   # verbose traces
```

Tests cover:

* Heartbeat logic (`withdraw(0)`)
* Early & late heir claims
* Timer reset after ping

---

## Deploy to Sepolia

```bash
export ETH_RPC_URL="https://sepolia.infura.io/v3/<KEY>"
export PRIVATE_KEY="0x<DEPLOYER_PK>"
export HEIR="0x<FIRST_HEIR>"

forge script script/DeployInheritance.s.sol \
  --sig "run()" --broadcast --verify
```

After deployment:

```bash
cast call <ADDR> owner() --rpc-url $ETH_RPC_URL
```

---

## Security considerations

* **Re‑entrancy safe** – state updated *before* external ETH send.
* **Idle period is immutable** – change requires redeploy.
* **Gas‑safe send** – uses `call{value: …}` post‑EIP‑1884.
