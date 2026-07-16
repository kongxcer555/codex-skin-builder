# Codex 月薪喵皮肤（macOS）

这是一套“月薪喵 × 打工人”Codex 动态皮肤。顶部使用独立循环 GIF：棕灰侧毛、白色脸身、蓝色竖眼的月薪喵在办公室写代码，金币缓慢落下，工资信封周期发光；功能卡、项目选择器、侧边栏、输入框和任务内容仍是 Codex 原生 DOM 与原生交互，不是整张截图覆盖。

皮肤通过只绑定到 `127.0.0.1` 的 Chromium DevTools Protocol 动态注入，不修改、不重签官方 `.app`，也不修改 `app.asar`。支持页面刷新、任务切换、Codex 重启、升级后重新应用和一键恢复。

## 首次安装

要求：macOS 12 或更高版本、官方 Codex 桌面版、Node.js 18 或更高版本。

```zsh
cd /path/to/codex-monthly-salary-cat-skin
/bin/zsh scripts/install-salary-cat-skin.sh
```

安装器会把完整皮肤复制到 `~/.codex/skills/codex-monthly-salary-cat-skin`，备份并设置暖黄色基础主题，在桌面创建：

- `Codex 月薪喵.app`
- `Codex 月薪喵 - Restore.app`

以后双击 `Codex 月薪喵` 即可启动。若 Dream Skin 正在运行，月薪喵启动器会先停止旧注入守护进程，并清理旧皮肤 DOM，避免两套主题叠加。

## 验证与恢复

```zsh
~/.codex/skills/codex-monthly-salary-cat-skin/scripts/start-salary-cat-skin.sh --restart-existing
~/.codex/skills/codex-monthly-salary-cat-skin/scripts/verify-salary-cat-skin.sh --screenshot "$HOME/Desktop/codex-salary-cat-check.png"
```

只移除当前窗口皮肤，可双击桌面的 Restore；或运行：

```zsh
~/.codex/skills/codex-monthly-salary-cat-skin/scripts/restore-salary-cat-skin.sh
```

同时恢复安装前的 Codex 基础配色并删除桌面启动器：

```zsh
~/.codex/skills/codex-monthly-salary-cat-skin/scripts/restore-salary-cat-skin.sh --restore-base-theme --uninstall
```

## 动效与素材

- `assets/salary-cat-hero.gif`：12 帧循环 GIF，1264×553。
- `assets/salary-cat-source.png`：根据用户提供的月薪喵参考图生成的静态主视觉；系统开启“减少动态效果”时自动使用此图。
- `assets/salary-cat-skin.css`：金币、猫爪、徽章、卡片与输入框动效。
- 状态与日志位于 `~/Library/Application Support/CodexSalaryCatSkin`。
- 请交付整个 `codex-monthly-salary-cat-skin` 文件夹，不要只复制 GIF 或 CSS。
