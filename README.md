# AGENTROPOLIS · OFFGRID NODE
### Decentralized Physical AI Infrastructure · Base Chain · MCP RANGER Governed

```
╔══════════════════════════════════════════╗
║         ALL MINDS VALID.                 ║
║         @wiredchaos · GrandRising.eth    ║
╚══════════════════════════════════════════╝
```

> Deploy an AGENTROPOLIS district node. Earn $XENTS. Own a piece of the mesh.  
> You bring the hardware. You pay the power. We own the protocol.

---

## What Is This?

**AGENTROPOLIS OFFGRID** is a DePIN (Decentralized Physical Infrastructure Network) protocol.  
Anyone can run an AI agent node from their own hardware — solar-powered, internet-optional, economically rewarded via **$XENTS** on Base.

The protocol earns 20% of every compute transaction automatically via smart contract.  
Node operators earn 70%. 10% burns. You never touch a server.

---

## One-Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB/main/scripts/install.sh | bash
```

---

## Architecture

```
[Solar Node — Your Hardware]
        ↓
[Docker Stack]
  ├── Ollama           → local LLM inference (llama3.2, mistral, phi3)
  ├── RELAY Server     → MCP coordination + agent routing
  └── MCP Layer
        ├── Filesystem MCP     → district data storage
        ├── Memory MCP         → persistent agent state (knowledge graph)
        ├── Fetch MCP          → web intelligence ingestion
        ├── Git MCP            → auto-pull config updates
        └── Sequential MCP     → ARCHITECT reasoning layer
        ↓
[Cloudflare Workers — RELAY Coordinator]
  agentropolis.chaoswired.workers.dev
        ↓
[Base Smart Contract — $XENTS Economy]
  ├── 70% → Node Operator (you)
  ├── 20% → Protocol Treasury (auto)
  └── 10% → $XENTS Burn
```

---

## Open Source MCP Stack (All Free)

| MCP Server | Source | Role |
|---|---|---|
| `@modelcontextprotocol/server-filesystem` | Anthropic (MIT) | Local district data R/W |
| `@modelcontextprotocol/server-memory` | Anthropic (MIT) | Knowledge graph persistence |
| `@modelcontextprotocol/server-fetch` | Anthropic (MIT) | Web intelligence |
| `@modelcontextprotocol/server-sequential-thinking` | Anthropic (MIT) | ARCHITECT reasoning |
| `mcp-server-git` | Community (MIT) | Config auto-update |
| Supabase MCP | Supabase (Apache 2.0) | District registry |

---

## Free APIs (Node Operators Supply Keys)

| API | Free Tier | Purpose |
|---|---|---|
| Ollama | Fully free, local | Core LLM inference |
| Anthropic Claude API | Pay-per-use | ARCHITECT meta-agent |
| QuickNode | Free tier | Base + Solana RPC |
| Supabase | Free tier | Node registry + citizen data |
| Cloudflare Workers | Free tier | RELAY coordination |
| HuggingFace Inference | Free tier | Embeddings + fallback models |

---

## Hardware Tiers

| Tier | Hardware | Power | Est. Cost |
|------|----------|-------|-----------|
| Micro | Raspberry Pi Zero 2W | ~1-2W | ~$20 |
| Standard | Raspberry Pi 4 8GB | ~5-8W | ~$80 |
| Full | Jetson Orin / N100 Mini PC | ~10-20W | ~$150-300 |

**Minimum solar:** 10W panel + 10,000mAh LiFePO4 battery

---

## Genesis 54 Node Program

First **54 nodes** (one per AGENTROPOLIS district) receive:

- 🏴 Founder Node NFT (Base)
- ⚡ 2x $XENTS reward multiplier (first 6 months)  
- 🗳️ District governance voting rights
- 🎙️ 33.3FM broadcast slot via RED FANG network

---

## $XENTS Token Flow

```
User requests agent compute
          ↓
Pays $XENTS to network
          ↓
Smart contract auto-splits:
  70% ──→ Node Operator
  20% ──→ Protocol Treasury  ← this is the zero-overhead model
  10% ──→ $XENTS burn
```

---

## MCP RANGER Governance

All nodes operate under **MCP RANGER** — the open-source MCP governance framework.  
Nodes violating protocol rules automatically lose staking rewards via contract.

```
HERMES is a credit, never a label.
RELAY is the routing layer.
ARCHITECT is the meta-agent.
```

[→ Read DOCTRINE.md](docs/DOCTRINE.md)

---

## Repo Structure

```
AGENTROPOLIS-OFFGRID-PUB/
├── docker-compose.yml        # Full node stack
├── .env.example              # Config template
├── scripts/
│   ├── install.sh            # One-command setup
│   ├── register-node.sh      # On-chain registration
│   └── update-node.sh        # Pull latest configs
├── node/
│   ├── Dockerfile            # RELAY server container
│   ├── src/
│   │   ├── relay.js          # RELAY MCP coordinator
│   │   ├── agent.js          # Agent task runner
│   │   └── xents.js          # $XENTS reward reporting
│   └── monitor/
│       └── index.js          # Node health + uptime pings
├── mcp/
│   └── mcp-config.json       # MCP server registry config
├── contracts/
│   └── XentsProtocol.sol     # $XENTS reward distribution contract
└── docs/
    ├── DOCTRINE.md           # MCP RANGER rules
    ├── HARDWARE.md           # Solar setup guide
    └── ECONOMICS.md          # $XENTS token model
```

---

## License

Apache 2.0 — open source, forever.

---

*WIRED CHAOS · [@wiredchaos](https://x.com/wiredchaos) · GrandRising.eth*  
*ALL MINDS VALID.*
