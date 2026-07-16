# Runtime notes

- The launcher discovers the signed app by Bundle ID `com.openai.codex`; current macOS releases may still use `/Applications/ChatGPT.app/Contents/MacOS/ChatGPT`.
- It launches with `--remote-debugging-address=127.0.0.1 --remote-debugging-port=<port>` and injects through CDP.
- Default port is `9335`; keep a custom port consistent across start, verify, and restore.
- The injector polls app page targets and reinjects after document loads. Renderer-side mutation observation covers in-page route changes.
- State and logs live under `~/Library/Application Support/CodexSalaryCatSkin`.
- The installer copies the entire skill to `~/.codex/skills/codex-monthly-salary-cat-skin`; desktop launchers point to this stable path.
- The animated GIF is converted to a blob URL in the renderer. Reduced-motion mode selects `salary-cat-source.png` before creating the blob URL.
- The start script stops the known Dream Skin daemon; the renderer also calls Dream Skin cleanup so visual layers do not mix.
- Environment overrides are `CODEX_SALARY_CAT_SKIN_APP_PATH`, `CODEX_SALARY_CAT_SKIN_NODE`, `CODEX_SALARY_CAT_SKIN_STATE_ROOT`, `CODEX_SALARY_CAT_SKIN_CONFIG_PATH`, and `CODEX_SALARY_CAT_SKIN_DESKTOP_DIR`.
