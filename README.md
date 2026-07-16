# Codex Skin Builder

把角色图片、截图、网页或视觉灵感，制作成可安装、可验证、可恢复的 macOS Codex 桌面动态皮肤。

这个仓库不是一张覆盖界面的截图模板。它保留 Codex 原生侧边栏、功能卡、项目选择器、输入框和任务内容，只通过 CSS、DOM 与仅监听 `127.0.0.1` 的 Chromium DevTools Protocol 改变视觉层；不会修改、替换或重签官方 Codex `.app`，也不会修改 `app.asar`。

## 真实效果素材

下面两张图均来自仓库内置的 `assets/reference-skin`，也是脚手架实际使用的参考实现。

![月薪喵参考皮肤动态主视觉](assets/reference-skin/assets/salary-cat-hero.gif)

<details>
<summary>查看静态源图（系统开启“减少动态效果”时使用）</summary>

![月薪喵参考皮肤静态源图](assets/reference-skin/assets/salary-cat-source.png)

</details>

- 动态主视觉：`salary-cat-hero.gif`，1264 × 553，12 帧循环动画。
- 静态源图：`salary-cat-source.png`，1942 × 809。
- CSS、注入器、安装器、验证器与恢复脚本都位于同一个参考皮肤目录中。

## 它会生成什么

每次脚手架生成的皮肤都是一个完整、可独立分发的目录，包含：

- 静态 PNG 与循环 GIF 主视觉。
- 主题 CSS 和渲染进程注入代码。
- macOS 安装、启动、验证与恢复脚本。
- `skin.json` 清单和 Codex skill 元数据。
- 独立的运行状态目录、调试端口和桌面启动器名称。
- 原生交互保留、减少动态效果回退和清理路径。

## 快速开始

### 1. 克隆并准备素材

```zsh
git clone https://github.com/kongxcer555/codex-skin-builder.git
cd codex-skin-builder
```

准备一张横向 PNG 源图和对应的循环 GIF。推荐让主体位于画面右侧 45–55%，左侧留出 Codex 原生文案所需的负空间；图片中不要嵌入文字、Logo、界面边框或水印。

### 2. 生成独立皮肤包

```zsh
python3 scripts/scaffold_skin.py \
  --name "Codex 示例主题" \
  --slug "codex-example-skin" \
  --description "示例角色与暖色工作台主题" \
  --source /absolute/path/source.png \
  --gif /absolute/path/hero.gif \
  --output /absolute/path/codex-example-skin
```

`--slug` 只接受小写字母、数字和连字符；输出目录必须尚不存在。脚手架会基于内置参考实现复制完整运行时，并同步重命名 CSS/JS/shell 标识、状态目录、启动器、清单与素材文件，避免不同皮肤互相冲突。

### 3. 调整视觉层

生成后主要编辑：

```text
codex-example-skin/
├── assets/
│   ├── example-hero.gif
│   ├── example-source.png
│   ├── example-skin.css
│   └── renderer-inject.js
├── scripts/
├── references/
├── agents/openai.yaml
├── skin.json
└── SKILL.md
```

在 `assets/example-skin.css` 中替换色板、卡片与装饰效果，在 `assets/renderer-inject.js` 中调整可见文案和主题节点。保持注入幂等，装饰层使用 `pointer-events: none`，并保留 `prefers-reduced-motion` 的静态 PNG 回退。

### 4. 验证和打包

发布前至少检查：

- Shell 与 JavaScript 语法。
- `skin.json` 格式及所有素材路径。
- PNG 尺寸、GIF 帧数与循环设置。
- 隔离环境中的安装/恢复往返。
- CDP 只绑定 `127.0.0.1`。
- 生成包中不存在创建者机器的绝对路径。

完整检查项见 [`references/qa.md`](references/qa.md)。只有在获得明确授权后，才应重启当前 Codex 窗口或执行实时 CDP 注入验证。

## 直接体验内置参考皮肤

内置的“月薪喵 × 打工人”皮肤是一套真实、完整的 macOS 实现，可用于理解生成包的最终结构：

```zsh
cd assets/reference-skin
/bin/zsh scripts/install-salary-cat-skin.sh
```

验证并截图：

```zsh
~/.codex/skills/codex-monthly-salary-cat-skin/scripts/start-salary-cat-skin.sh --restart-existing
~/.codex/skills/codex-monthly-salary-cat-skin/scripts/verify-salary-cat-skin.sh \
  --screenshot "$HOME/Desktop/codex-salary-cat-check.png"
```

恢复并卸载：

```zsh
~/.codex/skills/codex-monthly-salary-cat-skin/scripts/restore-salary-cat-skin.sh \
  --restore-base-theme --uninstall
```

参考皮肤的详细说明见 [`assets/reference-skin/README.zh-CN.md`](assets/reference-skin/README.zh-CN.md)。

## 项目结构

```text
codex-skin-builder/
├── SKILL.md                         # Skill 工作流与交付要求
├── agents/openai.yaml              # Codex skill 展示元数据
├── scripts/scaffold_skin.py        # 皮肤包脚手架
├── assets/reference-skin/          # 可运行的月薪喵参考实现
│   ├── assets/                     # PNG、GIF、CSS 与注入代码
│   ├── scripts/                    # 构建、安装、启动、验证、恢复脚本
│   ├── references/                 # 运行说明与 QA 清单
│   ├── skin.json
│   └── SKILL.md
└── references/
    ├── visual-workflow.md           # 素材分析、构图和动效建议
    ├── runtime-architecture.md      # CDP 与注入架构
    └── qa.md                        # 静态、隔离、实时与恢复测试
```

## 安全边界

- 不修改、不解包、不重签官方 Codex 应用或 `app.asar`。
- 调试端点只允许监听 `127.0.0.1`，不得暴露到局域网。
- 不在未经授权的情况下关闭或重启用户正在使用的 Codex 窗口。
- 生成包必须提供实时清理和完整恢复路径。
- 初次安装测试使用隔离的 `HOME` 与桌面目录。
- 使用第三方角色或图片制作可再分发皮肤前，应确认相应使用与传播权限。

## 运行要求

- macOS 12 或更高版本。
- 官方 Codex 桌面版。
- Python 3（运行脚手架）。
- Node.js 18 或更高版本（构建 GIF 与运行参考实现相关脚本）。
