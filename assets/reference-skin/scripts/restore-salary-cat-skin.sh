#!/bin/zsh
set -euo pipefail

source "$(dirname "$0")/lib.sh"
PORT=9335
UNINSTALL=0
RESTORE_BASE_THEME=0
while (( $# )); do
  case "$1" in
    --port) PORT="${2:-}"; shift 2 ;;
    --uninstall) UNINSTALL=1; shift ;;
    --restore-base-theme) RESTORE_BASE_THEME=1; shift ;;
    -h|--help) print -- "Usage: $0 [--port 9335] [--uninstall] [--restore-base-theme]"; exit 0 ;;
    *) salary_cat_die "未知参数：$1" ;;
  esac
done
salary_cat_validate_port "$PORT"
NODE="$(salary_cat_find_node)"
STATE_PATH="$SALARY_CAT_STATE_ROOT/state.json"
STATE_PORT="$(salary_cat_state_value "$NODE" "$STATE_PATH" port)"
[[ "$STATE_PORT" == <-> ]] && PORT="$STATE_PORT"
salary_cat_stop_injector "$NODE" "$STATE_PATH"
sleep 0.2
if salary_cat_has_targets "$PORT"; then
  "$NODE" "$SALARY_CAT_SCRIPT_DIR/injector.mjs" --remove --port "$PORT" --timeout-ms 3000 >/dev/null 2>&1 || true
fi
/bin/rm -f "$STATE_PATH"

if (( UNINSTALL )); then
  DESKTOP_DIR="${CODEX_SALARY_CAT_SKIN_DESKTOP_DIR:-$HOME/Desktop}"
  /bin/rm -rf "$DESKTOP_DIR/Codex 月薪喵.app" "$DESKTOP_DIR/Codex 月薪喵 - Restore.app" \
    "$DESKTOP_DIR/Codex 月薪猫.app" "$DESKTOP_DIR/Codex 月薪猫 - Restore.app"
fi
if (( RESTORE_BASE_THEME )); then
  CONFIG_PATH="${CODEX_SALARY_CAT_SKIN_CONFIG_PATH:-$HOME/.codex/config.toml}"
  "$NODE" "$SALARY_CAT_SCRIPT_DIR/theme-config.mjs" restore "$CONFIG_PATH" "$SALARY_CAT_STATE_ROOT/config.before-salary-cat-skin.toml"
fi
print -- "Codex 月薪喵皮肤已从当前窗口移除。"
