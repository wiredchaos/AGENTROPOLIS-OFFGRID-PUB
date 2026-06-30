#!/bin/bash
# AGENTROPOLIS OFFGRID — On-Chain Node Registration
# Registers node with $XENTS staking contract on Base
# ALL MINDS VALID.

CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
NC='\033[0m'

source .env 2>/dev/null || { echo -e "${RED}[ERROR] No .env found. Run install.sh first.${NC}"; exit 1; }

echo -e "${CYAN}[AGENTROPOLIS] Registering node on Base...${NC}"
echo ""
echo -e "  Node ID:   ${NODE_ID}"
echo -e "  District:  ${DISTRICT_ID}"
echo -e "  Wallet:    ${OPERATOR_WALLET}"
echo -e "  Contract:  ${XENTS_CONTRACT}"
echo ""

if [ -z "$OPERATOR_WALLET" ] || [ "$OPERATOR_WALLET" = "0xYourWalletAddress" ]; then
  echo -e "${RED}[ERROR] Set OPERATOR_WALLET in .env first${NC}"
  exit 1
fi

if [ -z "$XENTS_CONTRACT" ] || [ "$XENTS_CONTRACT" = "0x0000000000000000000000000000000000000000" ]; then
  echo -e "${RED}[ERROR] $XENTS contract not deployed yet. Check docs/ECONOMICS.md${NC}"
  exit 1
fi

# Call RELAY coordinator registration endpoint
curl -s -X POST \
  "${RELAY_COORDINATOR_URL}/api/nodes/register-onchain" \
  -H "Content-Type: application/json" \
  -d "{
    \"nodeId\": \"${NODE_ID}\",
    \"districtId\": \"${DISTRICT_ID}\",
    \"operatorWallet\": \"${OPERATOR_WALLET}\",
    \"contract\": \"${XENTS_CONTRACT}\"
  }" | jq .

echo ""
echo -e "${WHITE}Registration submitted. Monitor at: ${RELAY_COORDINATOR_URL}/nodes/${NODE_ID}${NC}"
