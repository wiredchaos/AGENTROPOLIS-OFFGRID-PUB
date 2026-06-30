// ============================================================
// AGENTROPOLIS OFFGRID — RELAY Server
// MCP coordination, agent routing, task dispatch
// ALL MINDS VALID.
// ============================================================

import express from 'express';
import { createClient } from '@supabase/supabase-js';
import fetch from 'node-fetch';

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 8080;
const NODE_ID = process.env.NODE_ID || 'unknown';
const DISTRICT_ID = process.env.DISTRICT_ID || '0';
const OPERATOR_WALLET = process.env.OPERATOR_WALLET || '';
const OLLAMA_URL = process.env.OLLAMA_URL || 'http://ollama:11434';
const COORDINATOR_URL = process.env.RELAY_COORDINATOR_URL || 'https://agentropolis.chaoswired.workers.dev';

// ── Supabase client ──────────────────────────────────────
const supabase = process.env.SUPABASE_URL
  ? createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY)
  : null;

// ── MCP Server Registry ──────────────────────────────────
const MCP_SERVERS = {
  filesystem: { url: 'http://mcp-filesystem:3001', type: 'filesystem' },
  memory:     { url: 'http://mcp-memory:3002',     type: 'memory' },
  fetch:      { url: 'http://mcp-fetch:3003',       type: 'fetch' },
  git:        { url: 'http://mcp-git:3004',         type: 'git' },
  sequential: { url: 'http://mcp-sequential:3005',  type: 'sequential-thinking' },
};

// ── Node state ───────────────────────────────────────────
let nodeState = {
  nodeId: NODE_ID,
  districtId: DISTRICT_ID,
  operatorWallet: OPERATOR_WALLET,
  status: 'online',
  tasksCompleted: 0,
  xentsPending: 0,
  startedAt: new Date().toISOString(),
};

// ── Health check ─────────────────────────────────────────
app.get('/health', (req, res) => {
  res.json({
    status: 'online',
    nodeId: NODE_ID,
    districtId: DISTRICT_ID,
    uptime: process.uptime(),
    tasksCompleted: nodeState.tasksCompleted,
    xentsPending: nodeState.xentsPending,
  });
});

// ── Node status ──────────────────────────────────────────
app.get('/status', (req, res) => {
  res.json(nodeState);
});

// ── MCP server list ──────────────────────────────────────
app.get('/mcp', (req, res) => {
  res.json({ servers: MCP_SERVERS });
});

// ── Run inference via Ollama ─────────────────────────────
app.post('/inference', async (req, res) => {
  const { prompt, model = 'llama3.2:3b', stream = false } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: 'prompt required' });
  }

  try {
    const response = await fetch(`${OLLAMA_URL}/api/generate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ model, prompt, stream }),
    });

    const data = await response.json();
    nodeState.tasksCompleted++;

    // Report task to coordinator for $XENTS accounting
    reportTask({ type: 'inference', model, promptLength: prompt.length }).catch(() => {});

    res.json({
      response: data.response,
      model: data.model,
      nodeId: NODE_ID,
      districtId: DISTRICT_ID,
    });
  } catch (err) {
    res.status(500).json({ error: 'Inference failed', detail: err.message });
  }
});

// ── Agent task handler ───────────────────────────────────
app.post('/agent/task', async (req, res) => {
  const { taskId, type, payload } = req.body;

  if (!taskId || !type) {
    return res.status(400).json({ error: 'taskId and type required' });
  }

  try {
    let result;

    switch (type) {
      case 'inference':
        result = await runInference(payload);
        break;
      case 'memory-read':
        result = await mcpCall('memory', 'read', payload);
        break;
      case 'memory-write':
        result = await mcpCall('memory', 'write', payload);
        break;
      case 'fetch':
        result = await mcpCall('fetch', 'fetch', payload);
        break;
      default:
        return res.status(400).json({ error: `Unknown task type: ${type}` });
    }

    nodeState.tasksCompleted++;
    await reportTask({ taskId, type });

    res.json({ taskId, status: 'complete', result, nodeId: NODE_ID });
  } catch (err) {
    res.status(500).json({ taskId, status: 'error', error: err.message });
  }
});

// ── Helpers ──────────────────────────────────────────────
async function runInference({ prompt, model = 'llama3.2:3b' }) {
  const response = await fetch(`${OLLAMA_URL}/api/generate`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ model, prompt, stream: false }),
  });
  const data = await response.json();
  return data.response;
}

async function mcpCall(serverName, tool, params) {
  const server = MCP_SERVERS[serverName];
  if (!server) throw new Error(`Unknown MCP server: ${serverName}`);
  const response = await fetch(`${server.url}/call`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ tool, params }),
  });
  return response.json();
}

async function reportTask(task) {
  try {
    await fetch(`${COORDINATOR_URL}/api/nodes/${NODE_ID}/tasks`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        ...task,
        nodeId: NODE_ID,
        districtId: DISTRICT_ID,
        operatorWallet: OPERATOR_WALLET,
        timestamp: new Date().toISOString(),
      }),
    });
  } catch (_) {
    // Non-fatal — tasks queue locally and sync later
  }
}

// ── Start ────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`[RELAY] AGENTROPOLIS Node ${NODE_ID} online`);
  console.log(`[RELAY] District ${DISTRICT_ID} · ${OPERATOR_WALLET}`);
  console.log(`[RELAY] Listening on :${PORT}`);
  console.log(`[RELAY] Coordinator: ${COORDINATOR_URL}`);
  console.log(`[RELAY] ALL MINDS VALID.`);

  // Ping coordinator on startup
  reportTask({ type: 'node-start' }).catch(() => {});
});
