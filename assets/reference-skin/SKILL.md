---
name: codex-monthly-salary-cat-skin
description: Apply, launch, verify, update, or restore the animated Monthly Salary Cat skin for the macOS Codex desktop app. Use when the user wants a warm cream, taupe, and cocoa office-cat theme, an animated GIF hero, update-safe CDP reinjection, or a safe rollback without modifying app.asar.
---

# Codex Monthly Salary Cat Skin

Apply a reversible animated renderer skin through Chromium DevTools Protocol while launching the official Codex app discovered by Bundle ID `com.openai.codex`. Never modify or re-sign the official application bundle or `app.asar`.

## Workflow

1. Run `scripts/install-salary-cat-skin.sh` once. It installs the complete skill under `~/.codex/skills/codex-monthly-salary-cat-skin`, sets matching base colors, and creates desktop launch/restore apps.
2. Run `scripts/start-salary-cat-skin.sh`; add `--restart-existing` only when restarting an open Codex app is authorized.
3. Run `scripts/verify-salary-cat-skin.sh --screenshot <absolute-path>` and inspect against `references/qa-inventory.md`.
4. Run `scripts/restore-salary-cat-skin.sh` for live removal. Add `--uninstall` to delete launchers and `--restore-base-theme` to restore backed-up base colors.

## Guardrails

- Preserve the official executable, signature, user tasks, projects, plugins, skills, and authentication state.
- Use `salary-cat-hero.gif` only inside the hero and decorative cat crop. Keep feature cards, project selector, composer, sidebar, and navigation native and clickable.
- Keep decorative chrome `pointer-events: none`.
- On reduced-motion systems use `salary-cat-source.png` and disable CSS animations.
- Stop the known Dream Skin daemon before applying this skin, and clean its DOM markers during injection.
- Keep CDP on loopback and keep the watcher alive for route/reload resilience.
- Require Node.js 18 or newer; the included WebSocket fallback has no npm runtime dependency.

## Resources

- `assets/salary-cat-hero.gif`: 12-frame looping animated hero.
- `assets/salary-cat-source.png`: original still artwork and reduced-motion fallback.
- `assets/salary-cat-skin.css`: visual system and lightweight CSS motion.
- `assets/renderer-inject.js`: idempotent DOM integration and cleanup.
- `scripts/injector.mjs`: CDP apply, watch, verify, screenshot, and removal.
