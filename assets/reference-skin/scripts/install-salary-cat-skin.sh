#!/bin/zsh
set -euo pipefail

source "$(dirname "$0")/lib.sh"
PORT=9335
NO_LAUNCHERS=0
NO_COPY=0
while (( $# )); do
  case "$1" in
    --port) PORT="${2:-}"; shift 2 ;;
    --no-launchers) NO_LAUNCHERS=1; shift ;;
    --no-copy) NO_COPY=1; shift ;;
    -h|--help) print -- "Usage: $0 [--port 9335] [--no-launchers] [--no-copy]"; exit 0 ;;
    *) salary_cat_die "未知参数：$1" ;;
  esac
done
salary_cat_validate_port "$PORT"
NODE="$(salary_cat_find_node)"
/bin/mkdir -p "$SALARY_CAT_STATE_ROOT"

INSTALL_ROOT="$HOME/.codex/skills/codex-monthly-salary-cat-skin"
ACTIVE_ROOT="$SALARY_CAT_SKILL_ROOT"
if (( ! NO_COPY )) && [[ "$SALARY_CAT_SKILL_ROOT" != "$INSTALL_ROOT" ]]; then
  /bin/mkdir -p "${INSTALL_ROOT:h}"
  /usr/bin/ditto "$SALARY_CAT_SKILL_ROOT" "$INSTALL_ROOT"
  ACTIVE_ROOT="$INSTALL_ROOT"
  print -- "已将完整工具目录安装到：$INSTALL_ROOT"
fi
/bin/chmod +x "$ACTIVE_ROOT"/scripts/*.sh

CONFIG_PATH="${CODEX_SALARY_CAT_SKIN_CONFIG_PATH:-$HOME/.codex/config.toml}"
"$NODE" "$ACTIVE_ROOT/scripts/theme-config.mjs" install "$CONFIG_PATH" "$SALARY_CAT_STATE_ROOT/config.before-salary-cat-skin.toml"

create_launcher() {
  local name="$1" script_path="$2" extra_arg="$3"
  local desktop_dir="${CODEX_SALARY_CAT_SKIN_DESKTOP_DIR:-$HOME/Desktop}"
  local app="$desktop_dir/$name.app"
  local bundle_id="com.local.codex-monthly-salary-cat-skin.${script_path:t:r}"
  /bin/mkdir -p "$app/Contents/MacOS"
  /bin/cat > "$app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>launcher</string>
  <key>CFBundleIdentifier</key><string>$bundle_id</string>
  <key>CFBundleName</key><string>$name</string>
  <key>CFBundleDisplayName</key><string>$name</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>LSUIElement</key><true/>
</dict></plist>
PLIST
  local quoted_script="${(q)script_path}"
  /bin/cat > "$app/Contents/MacOS/launcher" <<LAUNCHER
#!/bin/zsh
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:\${PATH:-}"
export CODEX_SALARY_CAT_SKIN_NODE=${(q)NODE}
exec $quoted_script --port $PORT $extra_arg >>"\$HOME/Library/Application Support/CodexSalaryCatSkin/desktop-launcher.log" 2>&1
LAUNCHER
  /bin/chmod +x "$app/Contents/MacOS/launcher"
  /usr/bin/codesign --force --sign - "$app" >/dev/null 2>&1
  /usr/bin/touch "$app"
}

if (( ! NO_LAUNCHERS )); then
  /bin/mkdir -p "${CODEX_SALARY_CAT_SKIN_DESKTOP_DIR:-$HOME/Desktop}"
  create_launcher "Codex 月薪喵" "$ACTIVE_ROOT/scripts/start-salary-cat-skin.sh" "--restart-existing"
  create_launcher "Codex 月薪喵 - Restore" "$ACTIVE_ROOT/scripts/restore-salary-cat-skin.sh" ""
fi

print -- "安装完成。双击桌面的“Codex 月薪喵”即可启动；双击 Restore 可一键还原。"
