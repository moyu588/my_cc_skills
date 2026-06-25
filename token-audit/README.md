# token-audit

> 通用 Token 浪费分析工具 — 适用于 **Claude Code + OpenWolf + 第三方 LLM API** 项目栈

自动扫描 `anatomy.md`、会话日志、配置文件，统计 token 消耗并生成修复方案。

## 特性

- 🔍 **零依赖** — 单文件 Node.js 脚本（`.mjs`），无 `npm install`
- 🖥️ **跨平台** — Linux / Windows 10 / Windows 11 原生支持
- 🧠 **场景感知** — LLM Wiki、代码开发、通用三种场景，自动匹配
- 📊 **Token 对比** — 与历史快照对比，追踪 token 消耗趋势
- 🤖 **Claude Code Skill** — 自然语言触发，自动分析 + 自动修复

## 快速开始

### 前置条件

- Node.js ≥ 18（Claude Code 已自带）
- OpenWolf 管理的项目（有 `.wolf/config.json`）
- （可选）Claude Code + Claudian（会话文件在 `.claudian/sessions/`）

### 安装

#### 方式 1: 克隆到项目 + 自动注册（推荐）

```bash
cd your-project
git clone https://github.com/<you>/token-audit

# Linux / macOS / Git Bash
bash token-audit/install.sh

# Windows PowerShell
powershell -ExecutionPolicy Bypass -File token-audit\install.ps1
```

安装脚本自动将 SKILL.md 注册到 `.claude/skills/token-audit/`。

#### 方式 2: 手动注册（一行命令）

```bash
# 在项目目录下
mkdir -p .claude/skills/token-audit
cp token-audit/SKILL.md .claude/skills/token-audit/SKILL.md
```

#### 方式 3: 仅命令行使用（不注册 Skill）

```bash
git clone https://github.com/<you>/token-audit
node token-audit/token-audit.mjs /path/to/project --quick
```

### 使用

#### 方式 A: Claude Code Skill（推荐）

在 Claude Code 会话中说：
- "帮我看看 token 浪费在哪"
- "最近 token 消耗有点高"
- "做一次深度 token 审计"

AI 会自动执行分析并给出修复建议。

#### 方式 B: 命令行独立使用

```bash
# 完整分析
node token-audit.mjs /path/to/project

# 快速扫一眼（跳过慢速目录扫描）
node token-audit.mjs /path/to/project --quick

# 输出到文件
node token-audit.mjs . > report.json
```

## 输出示例

```json
{
  "meta": {
    "project_root": "/home/user/my-wiki",
    "platform": "linux",
    "scenario_hints": ["llm-wiki", "claude-code"]
  },
  "anatomy": {
    "lines": 775,
    "size_kb": 35,
    "entries": 525,
    "hit_rate_pct": 0,
    "est_tokens_per_session": 8750
  },
  "top_level_dirs": [
    { "path": "wiki/", "on_disk": 200, "tracked": 150, "tracked_pct": 75 },
    { "path": ".obsidian/", "on_disk": 45, "tracked": 52, "tracked_pct": 115 }
  ],
  "sessions": {
    "count": 74,
    "total_size_mb": 4.5,
    "over_30days": 62
  },
  "config": {
    "exclude_patterns": {
      "configured": ["node_modules", ".git", "dist"],
      "ineffective": [{ "pattern": ".obsidian/plugins", "entries_still_present": 15 }]
    }
  }
}
```

## 支持的场景

| 场景 | Profile | 检测依据 |
|------|---------|---------|
| LLM Wiki 知识库 | `llm-wiki.json` | 存在 `wiki/`、`raw/` 目录 |
| 代码开发项目 | `code-dev.json` | 存在 `src/`、`tests/`，`package.json` 等 |
| 通用兜底 | `fallback.json` | 无匹配时自动使用 |

### 添加新场景

在 `profiles/` 目录下新建 JSON 文件：

```json
{
  "name": "你的场景名",
  "detect": { "dirs": ["your-dir/"], "files": ["your-file.json"] },
  "anatomy_healthy": { "max_lines": 400, "max_files": 300, "max_size_kb": 20 },
  "sessions_healthy": { "max_count": 30, "max_age_days": 30, "max_total_mb": 3 },
  "dirs_should_track": ["src/", "docs/"],
  "dirs_should_not_track": ["node_modules/", "venv/", "dist/"],
  "expected_excludes": ["node_modules", "venv", "dist"],
  "waste_sources_priority": [...]
}
```

## 项目结构

```
token-audit/
├── README.md
├── SKILL.md               # Claude Code Skill 定义
├── token-audit.mjs        # 主脚本（零依赖，Node.js ≥18）
├── profiles/
│   ├── llm-wiki.json      # LLM Wiki 场景
│   ├── code-dev.json      # 代码开发场景
│   └── fallback.json      # 通用兜底
├── snapshots/             # 历史分析快照
│   └── .gitkeep
├── .gitignore
└── LICENSE
```

## 工作原理

```
              token-audit.mjs (数据采集)
                      │
         ┌────────────┼────────────┐
         ▼            ▼            ▼
    .wolf/       .claudian/    .claude/
  anatomy.md    sessions/    settings.json
  config.json               CLAUDE.md
         │            │            │
         └────────────┼────────────┘
                      ▼
               JSON → stdout
                      │
              ┌───────┴───────┐
              ▼               ▼
        SKILL.md       人工分析
     (AI 自动诊断)    (命令行管道)
```

## 许可

MIT
