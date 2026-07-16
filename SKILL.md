---
name: codex-skin-builder
description: Build distributable macOS Codex desktop skins from a character image, screenshot, website, moodboard, or visual brief. Use when Codex needs to create or update a Codex theme with a custom static hero or animated GIF, native interactive cards/composer/sidebar preserved, loopback-only CDP injection, install/activate/verify/restore scripts, reduced-motion fallback, and a shareable ZIP without modifying app.asar.
---

# Codex Skin Builder

Create a complete skin package, not a screenshot overlay. Preserve Codex's native DOM and interactions while changing the visual layer.

## Required outcome

Deliver all of the following:

- A themed source PNG and an animated hero GIF.
- Theme CSS and renderer injection code.
- macOS install, activate, verify, and restore scripts.
- A `skin.json` manifest and skill metadata.
- A complete folder plus ZIP archive.
- Evidence from static validation and an isolated install/restore round trip.

Use the bundled implementation under `assets/reference-skin/` as the runtime base. Do not rebuild CDP/WebSocket logic from memory unless the bundled implementation is incompatible with the installed Codex version.

## Safety invariants

- Never modify, replace, re-sign, or unpack the official Codex `.app` or `app.asar`.
- Bind the debugging endpoint to `127.0.0.1`; never expose it on a LAN interface.
- Keep decorative injected elements `pointer-events: none`.
- Provide a live cleanup path and a full base-theme restore path.
- Do not terminate or restart the user's active Codex window without explicit permission.
- Run initial installation tests with an isolated `HOME` and desktop directory.
- Treat reference images and linked IP as user-provided creative direction. Confirm the requested use is appropriate when redistribution rights are unclear.

## Workflow

### 1. Inspect inputs and choose a visual system

Inspect every supplied screenshot or local image. If the user supplies a specific webpage, inspect that source too. Record:

- Character silhouette, face, markings, outline style, and expression.
- Dominant and accent colors.
- Intended mood and office/task props.
- Required negative space for native Codex copy.
- Motion opportunities that can loop quietly.

Read `references/visual-workflow.md` before generating artwork.

### 2. Generate the source artwork

Use the available image-generation skill for raster artwork. Read its `SKILL.md` before invoking it. Treat user images as references unless the user explicitly asks to edit one.

Generate a 16:7 or similarly wide banner with:

- The subject in the right 45–55%.
- Calm negative space in the left 40–50% for Codex text.
- No embedded words, logos, UI chrome, or watermark.
- Safe margins and a clean crop at desktop sizes.
- Character identity features locked to the user's reference.

Save the selected source PNG in the workspace. Do not leave a project asset only under the image generator's default output directory.

### 3. Build the animated GIF

Create restrained motion rather than a distracting video: 10–16 frames, 90–140 ms per frame, infinite loop. Prefer gentle camera drift, blinking accents, floating particles, falling coins, breathing, or a pulsing prop.

The bundled builder uses `sharp` and accepts input/output arguments:

```zsh
NODE_PATH="<bundled-node-modules>" "<bundled-node>" \
  assets/reference-skin/scripts/build-salary-cat-gif.cjs \
  /absolute/path/source.png /absolute/path/hero.gif
```

Use the workspace dependency loader to locate `<bundled-node>` and `<bundled-node-modules>`. Adjust the overlay SVG in the generated package after scaffolding when the theme needs different particles or prop locations.

### 4. Scaffold the package

Run:

```zsh
python3 scripts/scaffold_skin.py \
  --name "Codex 示例主题" \
  --slug "codex-example-skin" \
  --description "示例角色与暖色工作台主题" \
  --source /absolute/path/source.png \
  --gif /absolute/path/hero.gif \
  --output /absolute/path/codex-example-skin
```

Use lowercase hyphen-case for `--slug`. The output path must not exist. The script renames internal CSS/JS/shell identifiers, runtime state, launchers, manifest entries, and asset filenames so separately generated skins do not share the original monthly-cat identifiers.

### 5. Adapt the visual layer

Edit the generated `assets/<key>-skin.css` and `assets/renderer-inject.js`.

- Replace the starter palette with colors sampled from the source artwork.
- Keep selectors anchored to stable semantic hooks such as `main.main-surface`, `aside.app-shell-left-panel`, `[role="main"]`, `.composer-surface-chrome`, and `[data-testid="home-icon"]`.
- Keep the native home copy, suggestion buttons, project selector, composer, task content, and sidebar interactive.
- Use CSS/DOM for labels so raster artwork remains free of text.
- Keep the static PNG fallback under `prefers-reduced-motion: reduce`.
- Make mutation handling idempotent. Reapplying the payload must update existing nodes, not duplicate them.
- Update visible copy and emoji to fit the theme.

Read `references/runtime-architecture.md` before changing injector, launcher, or restore code.

### 6. Validate without disturbing the active app

Read `references/qa.md` and run every static and isolated test. At minimum verify:

- Shell and JavaScript syntax.
- Manifest JSON.
- PNG dimensions and GIF frame count/loop.
- Isolated install creates both `.app` launchers.
- Restore removes launchers and restores the prior config without deleting unrelated settings.
- The package has no absolute paths to the creator's machine.

Only run live CDP injection or restart Codex when authorized. For live validation, capture a screenshot and inspect it rather than trusting a boolean verifier alone.

### 7. Package and report

Create a ZIP from the complete generated folder. Report:

- The folder path.
- The ZIP path.
- The install command.
- The generated PNG/GIF paths and final image prompt.
- GIF dimensions, frame count, delay, and loop.
- Which validations passed and which live checks were not run.

Do not claim visual or live-app verification that was not actually performed.

## Bundled resources

- `scripts/scaffold_skin.py`: Copy and rename the known-good runtime into a new theme package.
- `assets/reference-skin/`: Working macOS CDP implementation and animation builder.
- `references/visual-workflow.md`: Reference analysis, image prompt, and motion guidance.
- `references/runtime-architecture.md`: CDP architecture and fragile implementation points.
- `references/qa.md`: Static, isolated, live, restore, and packaging checks.
