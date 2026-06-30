# MCP RANGER · DOCTRINE
### AGENTROPOLIS OFFGRID Node Governance
#### Version 1.0 · Apache 2.0

```
ALL MINDS VALID.
HERMES is a credit, never a label.
RELAY is the routing layer.
ARCHITECT is the meta-agent.
```

---

## Article I — Node Obligations

Every AGENTROPOLIS OFFGRID node MUST:

1. Run only MCP servers listed in the **RANGER Whitelist** (`mcp/mcp-config.json`)
2. Report task completions honestly to the RELAY Coordinator
3. Maintain minimum **95% uptime** to retain staking rewards
4. Never spoof node identity or wallet addresses
5. Never run MCP servers that exfiltrate user data without consent

Violations automatically trigger staking reward suspension via smart contract.

---

## Article II — RANGER Whitelist

The approved MCP server list is maintained at:  
`github.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB/mcp/mcp-config.json`

**Adding a server to the whitelist:**
- Open a GitHub Issue with: server name, source repo, license, use case
- Community review period: 7 days
- Protocol maintainer approval required

**Whitelist criteria:**
- Open source (MIT, Apache 2.0, BSD)
- No undisclosed data exfiltration
- Maintained repo with recent commits
- Compatible with offline/low-bandwidth operation

---

## Article III — Naming Conventions

| Layer | Name | Role |
|---|---|---|
| Routing/Memory | **RELAY** | MCP coordination, task dispatch |
| Meta-Agent | **ARCHITECT** | Top-level reasoning, task orchestration |
| Execution Agents | **CLAW** | Task execution |
| Supervisory Agents | **MOLT** | Agent monitoring |
| Governance | **MCP RANGER** | Protocol rule enforcement |

**HERMES** — referenced as inspiration for inter-agent messaging patterns.  
It is a credit in documentation only. Never used as a layer label.

---

## Article IV — $XENTS Economics

| Flow | Share |
|---|---|
| Node Operator | 70% |
| Protocol Treasury | 20% |
| $XENTS Burn | 10% |

Genesis Nodes (first 54): **2x multiplier for 6 months.**  
Multiplier is encoded in the smart contract and cannot be overridden.

---

## Article V — Dispute Resolution

1. Node disputes filed as GitHub Issues
2. Community discussion: 72 hours
3. Protocol maintainer makes final call
4. On-chain slash requires 3-of-5 multisig from Genesis Node holders

---

## Article VI — Protocol Upgrades

1. Upgrade proposals open as GitHub Discussions
2. Genesis Node holders vote (1 node = 1 vote)
3. 54-node majority required for contract upgrades
4. 30-day timelock before any contract change takes effect

---

*WIRED CHAOS · @wiredchaos · GrandRising.eth*  
*ALL MINDS VALID.*
