#!/bin/bash
# ============================================================
# AGENTROPOLIS OFFGRID NODE — Install Script v1.0
# github.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB
#
# curl -fsSL https://raw.githubusercontent.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB/main/scripts/install.sh | bash
#
# ALL MINDS VALID.
# ============================================================

set -e

CYAN='\033[0;36m'
RED='\033[0;31m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << 'EOF'
 █████╗  ██████╗ ███████╗███╗   ██╗████████╗██████╗  ██████╗ ██████╗  ██████╗ ██╗     ██╗███████╗
██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗██╔══██╗██╔═══██╗██║     ██║██╔════╝
███████║██║  ███╗█████╗  ██╔██╗ ██║   ██║   ██████╔╝██║   ██║██████╔╝██║   ██║██║     ██║███████╗
██╔══██║██║   ██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗██║   ██║██╔═══╝ ██║   ██║██║     ██║╚════██║
██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   ██║  ██║╚██████╔╝██║     ╚██████╔╝███████╗██║███████║
╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝      ╚═════╝ ╚══════╝╚═╝╚══════╝
EOF
echo -e "${RED}                              ██████╗ ███████╗███████╗ ██████╗ ██████╗ ██╗██████╗ ${NC}"
echo -e "${RED}                             ██╔═══██╗██╔════╝██╔════╝██╔════╝ ██╔══██╗██║██╔══██╗${NC}"
echo -e "${RED}                             ██║   ██║█████╗  █████╗  ██║  ███╗██████╔╝██║██║  ██║${NC}"
echo -e "${RED}                             ██║   ██║██╔══╝  ██╔══╝  ██║   ██║██╔══██╗██║██║  ██║${NC}"
echo -e "${RED}                             ╚██████╔╝██║     ██║     ╚██████╔╝██║  ██║██║██████╔╝${NC}"
echo -e "${RED}                              ╚═════╝ ╚═╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝ ${NC}"
echo ""
echo -e "${WHITE}                                    NODE INSTALLER v1.0${NC}"
echo -e "${DIM}                          github.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB${NC}"
echo -e "${CYAN}                                    ALL MINDS VALID.${NC}"
echo ""

# ── Dependency Checks ─────────────────────────────────────
echo -e "${CYAN}[1/6] Checking dependencies...${NC}"

check_dep() {
  local cmd=$1
  local pkg=$2
  if ! command -v $cmd &> /dev/null; then
    echo -e "  ${RED}✗ $cmd not found — installing...${NC}"
    if command -v apt-get &> /dev/null; then
      sudo apt-get install -y $pkg -qq 2>/dev/null
    elif command -v brew &> /dev/null; then
      brew install $pkg 2>/dev/null
    elif command -v yum &> /dev/null; then
      sudo yum install -y $pkg -q 2>/dev/null
    else
      echo -e "  ${RED}Please install $cmd manually and re-run.${NC}"
      exit 1
    fi
  else
    echo -e "  ${CYAN}✓ $cmd${NC}"
  fi
}

check_dep docker docker.io
check_dep git git
check_dep curl curl
check_dep jq jq

# Check docker compose v2
if ! docker compose version &> /dev/null; then
  echo -e "  ${RED}✗ docker compose not found — installing plugin...${NC}"
  sudo apt-get install -y docker-compose-plugin -qq 2>/dev/null || true
else
  echo -e "  ${CYAN}✓ docker compose${NC}"
fi

# ── Clone / Update Repo ───────────────────────────────────
echo ""
echo -e "${CYAN}[2/6] Fetching AGENTROPOLIS OFFGRID...${NC}"

REPO_URL="https://github.com/wiredchaos/AGENTROPOLIS-OFFGRID-PUB.git"
INSTALL_DIR="AGENTROPOLIS-OFFGRID-PUB"

if [ -d "$INSTALL_DIR/.git" ]; then
  echo -e "  Existing install found — pulling latest..."
  cd $INSTALL_DIR
  git pull origin main --quiet
else
  git clone $REPO_URL --quiet
  cd $INSTALL_DIR
fi

# ── Generate Node Identity ────────────────────────────────
echo ""
echo -e "${CYAN}[3/6] Generating node identity...${NC}"

generate_uuid() {
  if [ -f /proc/sys/kernel/random/uuid ]; then
    cat /proc/sys/kernel/random/uuid
  elif command -v uuidgen &> /dev/null; then
    uuidgen | tr '[:upper:]' '[:lower:]'
  else
    openssl rand -hex 16 | sed 's/\(........\)\(....\)\(....\)\(....\)\(............\)/\1-\2-\3-\4-\5/'
  fi
}

if [ ! -f ".env" ]; then
  cp .env.example .env
  NODE_ID="node-$(generate_uuid)"

  echo ""
  echo -e "${WHITE}  Configure your node:${NC}"
  echo ""

  read -p "  District ID (1-54): " DISTRICT_ID
  DISTRICT_ID=${DISTRICT_ID:-1}

  read -p "  Operator Wallet (0x...): " OPERATOR_WALLET

  read -p "  Supabase URL: " SUPABASE_URL

  read -p "  Supabase Anon Key: " SUPABASE_ANON_KEY

  read -p "  Anthropic API Key (optional, press Enter to skip): " ANTHROPIC_API_KEY

  # Write config
  sed -i "s|NODE_ID=.*|NODE_ID=${NODE_ID}|" .env
  sed -i "s|DISTRICT_ID=.*|DISTRICT_ID=${DISTRICT_ID}|" .env
  sed -i "s|OPERATOR_WALLET=.*|OPERATOR_WALLET=${OPERATOR_WALLET}|" .env
  sed -i "s|SUPABASE_URL=.*|SUPABASE_URL=${SUPABASE_URL}|" .env
  sed -i "s|SUPABASE_ANON_KEY=.*|SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}|" .env
  [ -n "$ANTHROPIC_API_KEY" ] && sed -i "s|ANTHROPIC_API_KEY=.*|ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}|" .env

  echo -e "  ${CYAN}✓ Node ID: ${NODE_ID}${NC}"
else
  echo -e "  .env exists — loading config"
  source .env
fi

# ── Build + Start Stack ───────────────────────────────────
echo ""
echo -e "${CYAN}[4/6] Building node stack...${NC}"
docker compose build --quiet

echo ""
echo -e "${CYAN}[5/6] Starting services...${NC}"
docker compose up -d

echo "  Waiting for Ollama to initialize..."
sleep 8

# Pull default model
echo "  Pulling default model (llama3.2:3b)..."
docker exec agentropolis-ollama ollama pull llama3.2:3b 2>/dev/null || \
  echo "  ${DIM}Model will download on first agent request${NC}"

# ── Register Node ─────────────────────────────────────────
echo ""
echo -e "${CYAN}[6/6] Registering with AGENTROPOLIS network...${NC}"

source .env

REG_RESPONSE=$(curl -s -X POST \
  "${RELAY_COORDINATOR_URL}/api/nodes/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"nodeId\": \"${NODE_ID}\",
    \"districtId\": \"${DISTRICT_ID}\",
    \"operatorWallet\": \"${OPERATOR_WALLET}\",
    \"endpoint\": \"http://$(hostname -I | awk '{print $1}' 2>/dev/null || echo 'localhost'):8080\",
    \"tier\": \"standard\"
  }" 2>/dev/null || echo '{"status":"pending","message":"Coordinator unreachable — node queued"}')

STATUS=$(echo $REG_RESPONSE | jq -r '.status' 2>/dev/null || echo "pending")
echo -e "  Registration: ${STATUS}"

# ── Done ──────────────────────────────────────────────────
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${WHITE}  ⚡ AGENTROPOLIS NODE ONLINE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${DIM}Node ID     ${NC}  ${NODE_ID}"
echo -e "  ${DIM}District    ${NC}  ${DISTRICT_ID}"
echo -e "  ${DIM}Wallet      ${NC}  ${OPERATOR_WALLET}"
echo ""
echo -e "  ${DIM}Services:${NC}"
echo -e "    RELAY        →  http://localhost:8080"
echo -e "    Ollama       →  http://localhost:11434"
echo -e "    Filesystem   →  localhost:3001"
echo -e "    Memory       →  localhost:3002"
echo -e "    Fetch        →  localhost:3003"
echo -e "    Git          →  localhost:3004"
echo -e "    Sequential   →  localhost:3005"
echo ""
echo -e "  ${DIM}Useful commands:${NC}"
echo -e "    docker compose logs -f         # stream all logs"
echo -e "    docker compose logs -f relay   # RELAY only"
echo -e "    bash scripts/update-node.sh    # pull latest"
echo ""
echo -e "${CYAN}  $XENTS rewards begin accumulating immediately.${NC}"
echo -e "${WHITE}  ALL MINDS VALID.${NC}"
echo ""
