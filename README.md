**Time-Locked STX Vault – Clarity Smart Contract**

The **Time-Locked STX Vault** smart contract provides a secure mechanism to lock STX tokens until a specified block height.
It ensures that funds can only be withdrawn by the designated beneficiary after a predetermined unlock time, enabling trustless deferred payments, savings locks, and time-based custody.

---
**Features**

**Secure STX Locking:** Lock STX until a specific block height.
**Time-Based Withdrawal:** Funds can only be withdrawn after the unlock block is reached.
**Cancelable Vaults:** Vault creator can cancel and reclaim STX before the unlock time.
**Owner and Beneficiary Tracking:** Stores sender, beneficiary, amount, and release height.
**Event Logging:** Emits events for deposit, release, and cancellation actions.
**Error Handling:** Safeguards against unauthorized withdrawals, invalid amounts, or missing vaults.

---
**Contract Functions**

**1. `create-vault`**

Locks STX tokens with a beneficiary and release block height.

**Parameters:**

* `beneficiary` — Principal to receive STX
* `amount` — STX amount to lock
* `release-height` — Block height after which withdrawal is allowed

**2. `withdraw`**

Allows the beneficiary to withdraw STX **after the release height**.

**3. `cancel-vault`**

Allows the original sender to reclaim STX **before the release height**.

**4. `get-vault`**

Reads details of an existing vault entry.

---

**Usage Examples**

**Create Vault**

```clarity
(time-locked-stx-vault.create-vault
    tx-sender
    beneficiary-principal
    u1000
    u350000
)
```

**Withdraw STX**

```clarity
(time-locked-stx-vault.withdraw vault-id)
```

**Cancel Vault**

```clarity
(time-locked-stx-vault.cancel-vault vault-id)
```

---

**Events**

* `vault-created`
* `vault-withdrawn`
* `vault-cancelled`

Events help with off-chain indexing and auditing.

---

**Error Codes**

| Code                    | Meaning                                   |
| ----------------------- | ----------------------------------------- |
| `err-invalid-amount`    | Locked amount must be greater than zero   |
| `err-release-too-early` | Attempt to withdraw before release height |
| `err-not-sender`        | Caller is not the vault creator           |
| `err-not-beneficiary`   | Caller is not the designated beneficiary  |
| `err-vault-not-found`   | Vault ID does not exist                   |

---

**Testing (Clarinet)**

Run tests with:

```bash
clarinet test
```

Recommended test scenarios:

* Vault creation and validation
* Withdrawal after unlock
* Early withdrawal rejection
* Vault cancellation behavior

---

**Project Structure**

```
/contracts
   └── time-locked-stx-vault.clar
/tests
   └── time-locked-stx-vault_test.ts
README.md
Clarinet.toml
```

---

**Security Notes**

* Only the beneficiary can withdraw after the release height.
* Only the creator can cancel vaults before maturity.
* Block height ensures deterministic time-based logic.
* Designed to be simple, auditable, and secure.

---

**Contributing**

Contributions are welcome!
Submit pull requests, issues, or feature requests.

---

**License**

MIT License

---



