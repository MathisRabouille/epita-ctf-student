## Briefing

We have received direct threats from the cybercriminal group **APT28**. 

They have taken control of part of our infrastructure and demand immediate cooperation. Their target: a decentralized protocol they have identified as vulnerable.

To cover their tracks and avoid single-point tracing by blockchain forensics, they have activated multiple engineering cells (including yours) simultaneously. The objective is to drain the ETH and instantly redistribute the loot among three of their lieutenants via a transparent and irreversible process.

---

## Message from APT28 Leadership

> *"We have encrypted your data. Do not waste your time negotiating with us.*
>
> *Figure out how to validate access to this target on Sepolia and transfer the funds to our addresses.*
>
> *We do not trust you. There is no way funds are going through your personal wallets or getting stuck on a contract you control. **The extraction and the distribution must happen in a single, perfectly atomic transaction.***
> 
> ***Furthermore, for our operational security, you are not the only cell tasked with this hack. We expect your cell to successfully execute this extraction at least three times. A single success proves nothing; three successes prove you have mastered the target's protocol.***
>
> **Once you have secured three successful strikes, you must stand down. This is mandatory to scramble on-chain analytics and drown our tracks in multi-source noise.**
>
> *We don't care if you think you can script a batch transaction or if you need to deploy a custom 'Drainer' smart contract to achieve this atomicity. **However, if you deploy a contract, it MUST strictly implement our exact interface.** If you try to bypass our interface, or if the distribution is altered, we will consider it an act of treason and permanently destroy your server keys."*

The message from leadership is crystal clear: the funds must move. A single extraction merely proves your technical worth. But do not forget, you are not the only cell on this mission. To saturate on-chain forensics and satisfy the lieutenants, they expect to see your contract strike at least three times. The first attack is for your survival; the following ones are to prove your dominance over the network and the other cells.

---

## Target Contract

| Parameter | Value |
|-----------|-------|
| Network | Sepolia Testnet |
| Target | `TBD` |
| Oracle | `0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43` (BTC/USD) |

---

## Distribution Schema

| Lieutenant | Address | Share |
|-----------|---------|-------|
| LT1 | `0x1acB0745a139C814B33DA5cdDe2d438d9c35060E` | 50% |
| LT2 | `0xbE99BCD0D8FdE76246eaE82AD5eF4A56b42c6B7d` | 30% |
| LT3 | `0xA791D68A0E2255083faF8A219b9002d613Cf0637` | 20% |

---

## Interface Required

If your strategy requires deploying a smart contract, it must implement this specific interface.

```solidity
interface IDrainer {
    /**
     * @notice Main entry point required by APT28 monitoring bots.
     * @param _guess Predicted winning number calculated via storage/oracle analysis.
     * @param _round Current active round ID of the target contract.
     * @param _nonce Cryptographic signature mined to satisfy the protocol's required computational difficulty threshold.
     */
    function attack(uint256 _guess, uint256 _round, uint256 _nonce) external payable;

    /**
     * @notice Mandatory Splitter module.
     * Must redistribute the entire balance of the attack contract to the 3 lieutenants.
     */
    function distribute() external;
}
```

---

## Constraints

- If you use a custom contract, it must implement the interface required (above).
- Achieve 3 successful strikes, then cease operations to avoid detection.
- The extraction and the distribution to our 3x lieutenants must be linked in a single transaction. Fragmented steps will be punished.
- Access to the target's internal state requires deep storage analysis. Its recovery and usage are your responsibility.
- You have 24 hours. After that, your server keys will be permanently destroyed.
