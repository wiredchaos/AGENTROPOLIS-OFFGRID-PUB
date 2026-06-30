#!/bin/bash
# AGENTROPOLIS OFFGRID — Node Update Script
# ALL MINDS VALID.

CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}[AGENTROPOLIS] Updating node...${NC}"

git pull origin main --quiet
echo -e "  ✓ Pulled latest from GitHub"

docker compose pull --quiet
echo -e "  ✓ Pulled latest Docker images"

docker compose up -d --build
echo -e "  ✓ Restarted stack"

echo -e "${WHITE}  Node updated. ALL MINDS VALID.${NC}"
