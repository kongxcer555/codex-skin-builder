# Public-safe starter recipes

Use these recipes when the user wants a shareable Codex skin but does not yet
have a redistributable source image. The goal is to start from public-safe
artwork, keep the left side readable for native Codex text, and avoid leaking
private workspace screenshots into a theme package.

## Caishen Readable

`Caishen Readable` is a soft fortune-workspace direction: warm light, quiet
gold accents, and a large calm area for Codex copy and task panels. It is useful
when the user wants a festive skin that can still be used for long coding
sessions.

Reference links:

- Source artwork:
  `https://raw.githubusercontent.com/ChannelerH/codex-skin-packs/main/packs/caishen-readable/background.png`
- Theme notes:
  `https://github.com/ChannelerH/codex-skin-packs/tree/main/packs/caishen-readable`
- Sanitized preview and install path:
  `https://codex-theme-gallery.howardhua.chatgpt.site/themes/caishen-readable?utm_source=kongxcer-codex-skin-builder&utm_medium=github-pr&utm_campaign=public-safe-starter`

Download the source art and generate a restrained animated hero:

```zsh
mkdir -p /tmp/codex-caishen-readable
curl -L \
  -o /tmp/codex-caishen-readable/source.png \
  https://raw.githubusercontent.com/ChannelerH/codex-skin-packs/main/packs/caishen-readable/background.png

NODE_PATH="<bundled-node-modules>" "<bundled-node>" \
  assets/reference-skin/scripts/build-salary-cat-gif.cjs \
  /tmp/codex-caishen-readable/source.png \
  /tmp/codex-caishen-readable/hero.gif
```

Then scaffold the skin package:

```zsh
python3 scripts/scaffold_skin.py \
  --name "Codex Caishen Readable" \
  --slug "codex-caishen-readable-skin" \
  --description "Soft low-strain fortune workspace with readable native Codex panels" \
  --source /tmp/codex-caishen-readable/source.png \
  --gif /tmp/codex-caishen-readable/hero.gif \
  --output "$PWD/codex-caishen-readable-skin"
```

After scaffolding, tune `assets/caishen-readable-skin.css` toward a light,
low-contrast palette:

- main surface: `#fff8ec`
- sidebar surface: `#f8eddf`
- text: `#2d2520`
- accent: `#d89b45`
- soft border: `rgba(129, 85, 40, 0.18)`

Keep decorative animation away from the left 40% of the hero and the lower
composer area. If the result feels visually busy, lower background opacity first
instead of adding darker panels.

## What makes a starter safe to publish

- The artwork is original or licensed for redistribution.
- No private Codex sidebar, task names, chats, file paths, terminals, or
  workspace screenshots are embedded in the image.
- The package includes install, verify, and restore scripts.
- The GIF is decorative only; native Codex controls remain interactive.
- The README tells users how to restore the base theme before they install it.
