# HARDWARE GUIDE
### AGENTROPOLIS OFFGRID Node · Solar Setup

---

## Minimum Viable Node (Micro)

**Hardware: Raspberry Pi Zero 2W**

```
[10W Solar Panel]
      ↓
[MPPT Charge Controller (e.g. Waveshare Solar Power Manager)]
      ↓
[10,000mAh LiFePO4 Battery Pack]
      ↓
[Raspberry Pi Zero 2W]
  └── SD Card 64GB+
  └── USB WiFi adapter (if no built-in)
```

**Estimated cost:** ~$60-80 total  
**Power draw:** ~1-2W idle, ~2.5W under inference  
**Solar hours needed:** 4-6 hours/day for 24h operation  
**Best for:** Micro agent, data relay, uptime reporting

---

## Standard Node

**Hardware: Raspberry Pi 4 8GB**

```
[50W Solar Panel]
      ↓
[MPPT Controller (e.g. EPever Tracer 1210AN)]
      ↓
[30,000mAh LiFePO4 Battery (e.g. PowerQueen 12V 30Ah)]
      ↓
[Raspberry Pi 4 8GB]
  └── NVMe SSD via USB3 (for model storage)
  └── Active cooling fan
```

**Estimated cost:** ~$200-250 total  
**Power draw:** ~5-8W idle, ~8-12W under inference  
**Models:** llama3.2:3b, phi3:mini, mistral:7b (quantized)  
**Best for:** Full agent node, memory MCP, web fetch

---

## Full Node (Recommended for Genesis)

**Hardware: Intel N100 Mini PC or Jetson Orin NX**

```
[100W Solar Panel Array (2x 50W)]
      ↓
[MPPT Controller (EPever 20A)]
      ↓
[100Ah LiFePO4 Battery (e.g. PowerQueen 12V 100Ah)]
      ↓
[12V→19V DC-DC Converter]
      ↓
[N100 Mini PC (8-16GB RAM) or Jetson Orin NX 8GB]
  └── 512GB+ NVMe SSD
```

**Estimated cost:** ~$350-500 total  
**Power draw:** ~10-20W under load  
**Models:** llama3.2:8b, mistral:7b, codellama:13b (quantized)  
**Best for:** Multi-agent district node, full MCP stack, 33.3FM relay

---

## LoRa Mesh (Internet-Optional)

Add a LoRa/Meshtastic radio for offgrid node-to-node comms:

- **Heltec LoRa 32 V3** (~$15) — connect via USB serial
- Nodes discover each other without internet
- Task routing over radio mesh at ~250bps
- Bitcoin payment relaying via Meshtastic possible

```
[Node A] ──LoRa──→ [Node B] ──LoRa──→ [Node C]
                        ↓
              [Internet gateway node]
                        ↓
              [AGENTROPOLIS RELAY Coordinator]
```

---

## Tips

- Use **LiFePO4** (lithium iron phosphate) not LiPo — much safer for always-on
- **MPPT** controllers are 30% more efficient than PWM
- Point panels **south** (northern hemisphere) at 30-45° tilt
- Add a **weatherproof enclosure** (Pelican-style) for outdoor deployment
- Run `docker stats` to monitor power draw and optimize container limits

---

*WIRED CHAOS · @wiredchaos · GrandRising.eth*  
*ALL MINDS VALID.*
