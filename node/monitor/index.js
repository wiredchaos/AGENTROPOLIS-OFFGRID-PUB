// ============================================================
// AGENTROPOLIS OFFGRID — Node Health Monitor
// Pings coordinator every 30s for uptime tracking + $XENTS
// ALL MINDS VALID.
// ============================================================

import fetch from 'node-fetch';

const RELAY_URL = process.env.RELAY_URL || 'http://relay:8080';
const COORDINATOR_URL = process.env.COORDINATOR_URL || 'https://agentropolis.chaoswired.workers.dev';
const NODE_ID = process.env.NODE_ID || 'unknown';
const OPERATOR_WALLET = process.env.OPERATOR_WALLET || '';
const PING_INTERVAL_MS = parseInt(process.env.PING_INTERVAL_MS || '30000');

let consecutiveFailures = 0;

async function ping() {
  try {
    // Check local RELAY health
    const relayRes = await fetch(`${RELAY_URL}/health`, { timeout: 5000 });
    const relayData = await relayRes.json();

    // Report to coordinator
    const report = {
      nodeId: NODE_ID,
      operatorWallet: OPERATOR_WALLET,
      status: 'online',
      tasksCompleted: relayData.tasksCompleted || 0,
      xentsPending: relayData.xentsPending || 0,
      uptime: relayData.uptime || 0,
      timestamp: new Date().toISOString(),
    };

    await fetch(`${COORDINATOR_URL}/api/nodes/${NODE_ID}/ping`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(report),
    });

    consecutiveFailures = 0;
    console.log(`[MONITOR] ✓ Ping OK · tasks=${report.tasksCompleted} · uptime=${Math.floor(report.uptime)}s`);

  } catch (err) {
    consecutiveFailures++;
    console.error(`[MONITOR] ✗ Ping failed (${consecutiveFailures}) — ${err.message}`);

    if (consecutiveFailures >= 5) {
      console.error('[MONITOR] 5 consecutive failures — RELAY may be down');
    }
  }
}

// Start monitor loop
console.log(`[MONITOR] Starting — Node ${NODE_ID}`);
console.log(`[MONITOR] Ping interval: ${PING_INTERVAL_MS}ms`);
console.log(`[MONITOR] Coordinator: ${COORDINATOR_URL}`);

ping(); // immediate first ping
setInterval(ping, PING_INTERVAL_MS);
