# Pocket TTS Local Voice Integration

Status: candidate offline/local speech layer for AGENTROPOLIS-OFFGRID-PUB.

Pocket TTS is being tracked because the discovery notes describe it as CPU-first, lightweight, stream-capable, and usable through Python API/CLI. That profile fits off-grid/public utility scenarios where API access should not be required.

## Off-grid usage

Potential use cases:

- offline voice prompts
- spoken instructions
- emergency/fallback narration
- public kiosk mode
- local education modules
- radio-style updates without cloud dependency

## Architecture rule

OFFGRID-PUB should consume speech through the AGENTROPOLIS voice gateway when connected to the full stack. In fully offline mode, it may use a packaged local provider adapter after validation.

## Provider priority

1. local Pocket TTS candidate
2. pre-rendered static audio
3. mock/no-audio fallback
4. hosted TTS only when connectivity and opt-in are present

## Guardrails

- Do not require a cloud API for core offline behavior.
- Do not clone real voices without explicit permission.
- Do not treat Pocket TTS as production-ready until benchmarked.
- Keep the local adapter replaceable.

## Validation checklist

Before off-grid use:

- verify install/package commands
- verify license and commercial usage terms
- test CPU-only performance on low-resource hardware
- test RAM usage
- test long instruction reads
- test streaming and file-output modes
- test failure behavior when model files are missing

## Current status

Tracked for evaluation. Not production locked.
