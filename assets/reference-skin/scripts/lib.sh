#!/bin/zsh

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

SALARY_CAT_SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${(%):-%N}")" && pwd)"
SALARY_CAT_SKILL_ROOT="$(dirname "$SALARY_CAT_SCRIPT_DIR")"
SALARY_CAT_STATE_ROOT="${CODEX_SALARY_CAT_SKIN_STATE_ROOT:-$HOME/Library/Application Support/CodexSalaryCatSkin}"

salary_cat_die() {
  print -u2 -- "Codex 月薪喵: $*"
  exit 1
}

salary_cat_validate_port() {
  local port="$1"
  [[ "$port" == <-> ]] || salary_cat_die "端口必须是数字：$port"
  (( port >= 1024 && port <= 65535 )) || salary_cat_die "端口必须在 1024–65535 之间：$port"
}

salary_cat_find_node() {
  local node_path major
  if [[ -n "${CODEX_SALARY_CAT_SKIN_NODE:-}" && -x "$CODEX_SALARY_CAT_SKIN_NODE" ]]; then
    node_path="$CODEX_SALARY_CAT_SKIN_NODE"
  else
    node_path="$(command -v node 2>/dev/null || true)"
  fi
  [[ -n "$node_path" && -x "$node_path" ]] || salary_cat_die "未找到 Node.js。请先安装 Node.js 18 或更高版本。"
  major="$("$node_path" -p 'Number(process.versions.node.split(".")[0])' 2>/dev/null || true)"
  [[ "$major" == <-> ]] && (( major >= 18 )) || salary_cat_die "Node.js 版本过低；需要 Node.js 18 或更高版本。"
  print -r -- "$node_path"
}

salary_cat_bundle_id() {
  /usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$1/Contents/Info.plist" 2>/dev/null || true
}

salary_cat_find_app() {
  local candidate
  local -a candidates
  [[ -n "${CODEX_SALARY_CAT_SKIN_APP_PATH:-}" ]] && candidates+=("$CODEX_SALARY_CAT_SKIN_APP_PATH")
  candidates+=(
    "/Applications/ChatGPT.app"
    "/Applications/Codex.app"
    "$HOME/Applications/ChatGPT.app"
    "$HOME/Applications/Codex.app"
  )
  if command -v mdfind >/dev/null 2>&1; then
    while IFS= read -r candidate; do
      [[ -n "$candidate" ]] && candidates+=("$candidate")
    done < <(mdfind "kMDItemCFBundleIdentifier == 'com.openai.codex'" 2>/dev/null)
  fi
  for candidate in "${candidates[@]}"; do
    [[ -d "$candidate" ]] || continue
    [[ "$(salary_cat_bundle_id "$candidate")" == "com.openai.codex" ]] || continue
    print -r -- "$candidate"
    return
  done
  salary_cat_die "未找到官方 Codex Mac 应用（Bundle ID: com.openai.codex）。"
}

salary_cat_app_executable() {
  local app_path="$1"
  local executable
  executable="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$app_path/Contents/Info.plist" 2>/dev/null || true)"
  [[ -n "$executable" && -x "$app_path/Contents/MacOS/$executable" ]] || salary_cat_die "Codex 可执行文件无效：$app_path"
  print -r -- "$app_path/Contents/MacOS/$executable"
}

salary_cat_has_targets() {
  local port="$1"
  /usr/bin/curl -fsS --max-time 1 "http://127.0.0.1:$port/json/list" 2>/dev/null |
    /usr/bin/grep -Eq '"url"[[:space:]]*:[[:space:]]*"app://'
}

salary_cat_port_in_use() {
  /usr/bin/nc -z 127.0.0.1 "$1" >/dev/null 2>&1
}

salary_cat_state_value() {
  local node="$1" state_path="$2" key="$3"
  [[ -f "$state_path" ]] || return 0
  "$node" -e 'try { const value = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))[process.argv[2]]; if (value !== undefined && value !== null) process.stdout.write(String(value)); } catch {}' "$state_path" "$key"
}

salary_cat_stop_injector() {
  local node="$1" state_path="$2"
  local pid
  pid="$(salary_cat_state_value "$node" "$state_path" injectorPid)"
  if [[ "$pid" == <-> ]] && kill -0 "$pid" 2>/dev/null; then
    local command_line
    command_line="$(/bin/ps -p "$pid" -o command= 2>/dev/null || true)"
    if [[ "$command_line" == *"injector.mjs"* && "$command_line" == *"--watch"* ]]; then
      kill "$pid" 2>/dev/null || true
      for _ in {1..20}; do
        kill -0 "$pid" 2>/dev/null || break
        sleep 0.05
      done
      kill -KILL "$pid" 2>/dev/null || true
    fi
  fi
}
