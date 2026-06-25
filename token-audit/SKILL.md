# token-audit Skill

> Token 浪费分析与自动修复。支持自然语言触发，场景感知（LLM Wiki / 代码开发 / 通用）。

## 触发方式

自然语言，任意一个即可：
- "token 浪费" / "token 消耗" / "token 分析" / "token 审计"
- "为什么 token 这么贵" / "分析会话日志" / "检查 token 效率"
- "最近 token 用量" / "API 费用"
- 当用户说 "帮我看看浪费在哪" 或类似表达时

Slash command `/token-audit` 默认使用 **quick** 模式。

## 工作流

### Step 1: 意图分类

根据用户措辞判断分析深度（`/token-audit` 无附加说明时默认 quick）：

| 用户说 | 模式 | 特征 |
|--------|------|------|
| "扫一眼" / "快速检查" / "有没有问题" | **quick** | `--quick` 标志，跳过慢速扫描，30 秒内出结论 |
| "深度分析" / "完整报告" / "审计" | **full** | 完整采集 + 对比快照 + 生成报告 |
| "最近越来越贵" / "和上周比" / "趋势" | **trend** | full 模式 + 加载历史快照做对比 |

### Step 2: 场景嗅探

执行脚本获取 `scenario_hints`，然后：

1. 读取项目根目录的 `CLAUDE.md`（如存在）
2. 结合 hints 匹配 `.claude/skills/token-audit/profiles/` 目录下的场景配置
3. 匹配规则：`detect.dirs` 命中 ≥2 个 且 `detect.files` 命中 ≥1 个 → 确认场景
4. 无匹配 → 使用 `fallback.json`

### Step 3: 数据采集

```bash
node .claude/skills/token-audit/token-audit.mjs . [--quick]
```

脚本输出 JSON → stdout。**脚本零副作用、零写入**。

### Step 4: 智能分析

将 JSON 数据与 profile 期望值对比，按照 `waste_sources_priority` 顺序逐项检查：

1. **anatomy.md 膨胀检测**
   - 对比 `max_lines` / `max_files` / `max_size_kb` 阈值
   - 从 `top_level_dirs` 找出 `should_not_track` 中 `tracked > 0` 的目录 → 污染源
   - 从 `top_level_dirs` 找出 `should_track` 中 `tracked_pct < 50` 的目录 → 遗漏风险

2. **会话文件膨胀**
   - 对比 `sessions_healthy` 阈值
   - 列出 `age_days > max_age_days` 的过期会话
   - 计算可释放磁盘空间

3. **排除规则有效性**
   - 检查 `ineffective_excludes` → 已声明但未生效的规则
   - 检查 `expected_excludes` 中哪些尚未配置 → 推荐追加

4. **冲突文件**
   - `conflicted_files.count > 0` → 建议清理

5. **CLAUDE.md 膨胀**
   - `est_tokens_per_session > 3000` → 建议精简

### Step 5: Token 对比

将当前 token 消耗与上次快照（如存在）对比：

- `anatomy_est_tokens_per_session` 上涨 >10% → 退化警告
- `sessions.count` 增长趋势 → 建议清理
- 输出中只对比 token 数据，不做 API 价格换算（价格实时变动，不做硬编码）

### Step 6: 输出与修复

#### Quick 模式输出
```
🔍 快速扫描 (<project>) — <scenario> 场景
✅ anatomy.md: <lines> 行 / <files> 文件（阈值 <threshold>）
⚠️ 会话文件: <count> 个，<over> 个过期
🔴 <N> 个问题 | 预估每会话浪费 ~<tokens> tok
要深度分析吗？
```

#### Full 模式输出
完整的 Markdown 报告，包含：
- 浪费点一览表（严重程度排序）
- 每个浪费点的量化数据 + 根因分析
- Token 账单（必要 vs 浪费）
- 修复方案（含具体 diff）
- 询问用户是否执行修复

#### 修复执行
用户确认后，执行以下操作：
1. 更新 `.wolf/config.json`（追加 exclude_patterns / 调整参数）
2. 删除过期会话文件（保留最近 30 天）
3. 删除冲突副本文件
4. 运行 `openwolf scan` 重建 anatomy.md
5. 保存快照到 `.claude/skills/token-audit/snapshots/YYYY-MM-DD.json`
6. 更新 `.wolf/memory.md`

### Step 7: 保存快照

修复完成后，将当前 JSON 数据复制到 `.claude/skills/token-audit/snapshots/` 目录，文件名 `YYYY-MM-DD.json`。下次 trend 模式自动对比。

## 文件位置

运行时文件位于 `.claude/skills/token-audit/`（由 `install.sh` / `install.ps1` 自动部署）：

```
.claude/skills/token-audit/
├── SKILL.md               # Skill 定义（本文件）
├── token-audit.mjs        # 主脚本
├── profiles/              # 场景配置
│   ├── llm-wiki.json
│   ├── code-dev.json
│   └── fallback.json
└── snapshots/             # 历史快照
    └── .gitkeep
```

GitHub 源项目（`token-audit/`）安装后可安全删除。

## 约束

- 脚本只做数据采集，**从不修改文件**
- 修复操作需用户明确确认后执行
- `conflicted_files.search_dirs` 可能漏检非标准目录下的冲突文件，如发现遗漏请补充
- 只做 token 消耗分析，不做 API 价格换算
