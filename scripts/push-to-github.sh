#!/bin/bash
# ============================================================
# Push AGENTROPOLIS-OFFGRID-PUB files to GitHub
# Run this from the directory ABOVE AGENTROPOLIS-OFFGRID-PUB/
# ============================================================

set -e

REPO_URL="https://github.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB.git"
WORK_DIR="AGENTROPOLIS-OFFGRID-PUB"

echo "[1/4] Cloning existing repo..."
git clone $REPO_URL $WORK_DIR-PUSH
cd $WORK_DIR-PUSH

echo "[2/4] Copying files from build directory..."
cp -r ../$WORK_DIR/. .

echo "[3/4] Staging all files..."
git add -A
git status

echo "[4/4] Committing and pushing..."
git commit -m "feat: initial AGENTROPOLIS OFFGRID node stack

- docker-compose.yml: full node stack (Ollama + RELAY + 5x MCP servers)
- scripts/install.sh: one-command node setup
- scripts/update-node.sh: pull latest configs
- scripts/register-node.sh: on-chain registration
- node/src/relay.js: RELAY MCP coordination server
- node/monitor/index.js: health monitor + uptime pings
- contracts/XentsProtocol.sol: \$XENTS reward distribution (Base)
- mcp/mcp-config.json: RANGER-approved MCP whitelist
- docs/DOCTRINE.md: MCP RANGER governance rules
- docs/ECONOMICS.md: \$XENTS token model
- docs/HARDWARE.md: solar setup guide
- .github/workflows/ci.yml: CI validation

ALL MINDS VALID."

git push origin main

echo ""
echo "✓ Pushed to https://github.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB"
echo ""
echo "Cleanup: rm -rf $WORK_DIR-PUSH"
