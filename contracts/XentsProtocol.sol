// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

// ============================================================
// AGENTROPOLIS OFFGRID — $XENTS Protocol Contract
// Deployed on Base
// ALL MINDS VALID.
// ============================================================

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract XentsProtocol {

    // ── State ────────────────────────────────────────────
    address public owner;
    address public treasury;
    IERC20 public xentsToken;

    uint256 public constant OPERATOR_SHARE_BPS = 7000;  // 70%
    uint256 public constant TREASURY_SHARE_BPS = 2000;  // 20%
    uint256 public constant BURN_SHARE_BPS     = 1000;  // 10%
    uint256 public constant BPS_DENOMINATOR    = 10000;

    address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    // ── Node Registry ────────────────────────────────────
    struct Node {
        string  nodeId;
        uint8   districtId;
        address operatorWallet;
        bool    active;
        bool    genesis;
        uint256 rewardMultiplierBPS;  // 10000 = 1x, 20000 = 2x (genesis)
        uint256 tasksCompleted;
        uint256 xentsEarned;
        uint256 registeredAt;
    }

    mapping(string => Node) public nodes;
    mapping(address => string[]) public operatorNodes;
    string[] public allNodeIds;

    uint256 public genesisNodeCount;
    uint256 public constant MAX_GENESIS_NODES = 54;
    uint256 public constant GENESIS_MULTIPLIER_BPS = 20000; // 2x
    uint256 public constant GENESIS_WINDOW = 180 days;
    uint256 public genesisWindowEnd;

    // ── Events ───────────────────────────────────────────
    event NodeRegistered(string nodeId, uint8 districtId, address operator, bool genesis);
    event TaskRewarded(string nodeId, address operator, uint256 operatorAmount, uint256 treasuryAmount, uint256 burnAmount);
    event NodeDeactivated(string nodeId);

    // ── Constructor ──────────────────────────────────────
    constructor(address _xentsToken, address _treasury) {
        owner = msg.sender;
        treasury = _treasury;
        xentsToken = IERC20(_xentsToken);
        genesisWindowEnd = block.timestamp + GENESIS_WINDOW;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // ── Register Node ─────────────────────────────────────
    function registerNode(
        string calldata nodeId,
        uint8 districtId,
        address operatorWallet
    ) external {
        require(bytes(nodes[nodeId].nodeId).length == 0, "Node already registered");
        require(districtId >= 1 && districtId <= 54, "Invalid district");
        require(operatorWallet != address(0), "Invalid wallet");

        bool isGenesis = (genesisNodeCount < MAX_GENESIS_NODES && block.timestamp < genesisWindowEnd);
        uint256 multiplier = isGenesis ? GENESIS_MULTIPLIER_BPS : BPS_DENOMINATOR;

        if (isGenesis) genesisNodeCount++;

        nodes[nodeId] = Node({
            nodeId:              nodeId,
            districtId:          districtId,
            operatorWallet:      operatorWallet,
            active:              true,
            genesis:             isGenesis,
            rewardMultiplierBPS: multiplier,
            tasksCompleted:      0,
            xentsEarned:         0,
            registeredAt:        block.timestamp
        });

        operatorNodes[operatorWallet].push(nodeId);
        allNodeIds.push(nodeId);

        emit NodeRegistered(nodeId, districtId, operatorWallet, isGenesis);
    }

    // ── Reward Task ───────────────────────────────────────
    // Called by coordinator after verifying task completion
    function rewardTask(
        string calldata nodeId,
        uint256 grossAmount
    ) external onlyOwner {
        Node storage node = nodes[nodeId];
        require(node.active, "Node not active");
        require(grossAmount > 0, "Amount must be > 0");

        // Apply multiplier
        uint256 effectiveAmount = (grossAmount * node.rewardMultiplierBPS) / BPS_DENOMINATOR;

        uint256 operatorAmount = (effectiveAmount * OPERATOR_SHARE_BPS) / BPS_DENOMINATOR;
        uint256 treasuryAmount = (effectiveAmount * TREASURY_SHARE_BPS) / BPS_DENOMINATOR;
        uint256 burnAmount     = effectiveAmount - operatorAmount - treasuryAmount;

        // Distribute
        require(xentsToken.transfer(node.operatorWallet, operatorAmount), "Operator transfer failed");
        require(xentsToken.transfer(treasury, treasuryAmount), "Treasury transfer failed");
        require(xentsToken.transfer(BURN_ADDRESS, burnAmount), "Burn failed");

        node.tasksCompleted++;
        node.xentsEarned += operatorAmount;

        emit TaskRewarded(nodeId, node.operatorWallet, operatorAmount, treasuryAmount, burnAmount);
    }

    // ── Deactivate Node ───────────────────────────────────
    function deactivateNode(string calldata nodeId) external onlyOwner {
        nodes[nodeId].active = false;
        emit NodeDeactivated(nodeId);
    }

    // ── Views ─────────────────────────────────────────────
    function getNode(string calldata nodeId) external view returns (Node memory) {
        return nodes[nodeId];
    }

    function getOperatorNodes(address operator) external view returns (string[] memory) {
        return operatorNodes[operator];
    }

    function totalNodes() external view returns (uint256) {
        return allNodeIds.length;
    }

    function genesisSlotsFilled() external view returns (uint256) {
        return genesisNodeCount;
    }

    function genesisSlotsFree() external view returns (uint256) {
        if (block.timestamp >= genesisWindowEnd) return 0;
        return MAX_GENESIS_NODES - genesisNodeCount;
    }

    // ── Admin ─────────────────────────────────────────────
    function setTreasury(address _treasury) external onlyOwner {
        treasury = _treasury;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }
}
