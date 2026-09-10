# 新项目标准装备手册（new-project-setup 插件）

> **这套东西解决什么问题**：每开一个新项目，不用再纠结"该给 Claude Code 装什么、怎么用它干活"。
> 安装本插件后，在项目目录里说 `/new-project-setup`，10 分钟内项目就有了完整的"家规 + 装备 + 安全防线"。
>
> **安装（两条命令）**：
>
> ```bash
> claude plugin marketplace add moyu588/my_cc_skills
> claude plugin install new-project-setup@my_cc_skills
> ```
>
> 不方便用插件系统时，也可以 clone 本仓库后执行 `bash new-project-setup/install.sh`（拷贝式安装）。
>
> 维护者：moyu588 ｜ 编写日期：2026-09-10 ｜ 装备版本快照：ECC 2.2.1、mattpocock-skills 1.2.3（中文版）、官方插件市场 2026-08 快照 ｜ License：MIT

---

## 目录

1. [第 0 条铁律与分层规则](#1-第-0-条铁律与分层规则)
2. [配套装备安装清单（用户级，一次性）](#2-配套装备安装清单用户级一次性)
3. [六阶段使用说明](#3-六阶段使用说明)
4. [新项目初始化](#4-新项目初始化)
5. [成本护栏与模型分工](#5-成本护栏与模型分工)
6. [附录 A：Python/FastAPI 栈装备](#附录-apythonfastapi-栈装备)
7. [附录 B：Vue3/TypeScript 栈装备](#附录-bvue3typescript-栈装备)
8. [附录 C：第三方可选扩展（未验证）](#附录-c第三方可选扩展未验证)
9. [换新栈时如何自己挑装备](#6-换新栈时如何自己挑装备)
10. [安装、更新与维护](#7-安装更新与维护)

> **阅读提示**：本插件的 skill 本体（初始化流程）开箱即用，不依赖第 2 节的装备；但第 3 节六阶段工作流引用的工具（planner、tdd-guide、code-reviewer 等）来自第 2 节的插件，想让家规真正跑起来建议一并安装。

---

## 1. 第 0 条铁律与分层规则

### 第 0 条铁律（凌驾于一切之上）

> **任何时候，生产环境与数据的安全稳定，优先于进度和功能。**
> 轻量流里一旦发现有操作可能触碰生产环境或数据，立即停下、升级为重型流，没有例外。

### 什么是轻量流 / 重型流

用装修打比方：

| | 轻量流 = 老师傅一个人干活 | 重型流 = 先开图纸评审会 |
|---|---|---|
| 干活方式 | 主对话 Claude 独自完成：读码→改码→测试→自查→提交 | 主 Claude 当"项目经理"，派多个独立子代理分工+互相挑刺 |
| 流程 | 无固定流程 | ① planner 出方案（你确认）→ ② tdd-guide 先写测试 → ③ 实现 → ④ code-reviewer + security-reviewer + 语言 reviewer **三路并行评审** → ⑤ CRITICAL 问题清零 → ⑥ 你本人点头才提交 |
| 成本 | 低（一次任务约几万~十几万 token） | 约为轻量流的 5~20 倍 |
| 适用 | 修小 bug、加字段、改文案、单文件改动 | 碰高危触发器的改动、大功能、架构调整 |

### 6 条高危触发器（碰任何一条，强制升级重型流）

1. **认证/授权/密码/用户敏感数据**相关代码
2. **数据库结构变更**（加列/删列/迁移/ALTER/DROP）
3. **生产环境部署/同步/发布**
4. **不可逆批量操作**（批量删除、批量改库、批量覆盖文件）
5. **外部 API 密钥、凭据**的处理代码
6. **架构级重构**（跨多文件、改公共接口）

> 极端情况（碰生产 + 碰安全同时发生）：在重型流基础上再加 `ecc:santa-loop`——两位独立评审员背靠背审，两人都放行才算过。

---

## 2. 配套装备安装清单（用户级，一次性）

这些装在 `~/.claude/`（用户级），跟着你走，所有项目生效。**新机器/新账号才需要重装，开新项目不用重装。**

### 2.1 插件市场与插件（3 个市场、3 个插件）

```bash
# ① Anthropic 官方市场 → 装 skill-creator（用来给自己造自定义 skill）
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install skill-creator@claude-plugins-official

# ② ECC 全家桶（主力装备库：200+ skills、60+ agents、hooks、评审体系）
claude plugin marketplace add https://github.com/affaan-m/ECC.git
claude plugin install ecc@ecc

# ③ mattpocock-skills（精品小工具集：tdd、code-review、grilling、diagnosing-bugs 等；中文用户可用 vinvcn/mattpocock-skills-zh-CN 汉化版）
claude plugin marketplace add https://github.com/mattpocock/skills.git
claude plugin install mattpocock-skills@mattpocock
```

装完后在 Claude Code 会话里用 `/plugin` 可以查看和管理。ECC 安装时如询问 hooks profile，选 `standard`。

### 2.2 MCP 外设（给 Claude 接的外部工具）

| MCP | 用途 | 安装 |
|---|---|---|
| **context7** | 写代码前先查库的**最新官方文档**，防 AI 用过时 API。所有项目通用 | ECC 自带；也可单独装：`claude mcp add context7 -- npx -y @upstash/context7-mcp@latest` |
| **chrome-devtools** | 让 Claude **亲自开浏览器**点你的页面、看 console 报错、截图验证。有 Web 前端的项目才需要 | ECC 自带；单独装：`claude mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest` |
| **数据库类（按项目选配）** | 让 Claude 直接查库验数据。写在**项目级** `.mcp.json` 里，不进用户级 | SQLite 示例：`claude mcp add sqlite -- uvx mcp-server-sqlite --db-path <路径>` |

> ⚠️ MCP 总数控制在 10 个以内（ECC 官方建议），装多了挤占上下文窗口。GitHub 操作不用装 MCP，`gh` CLI 就够。

### 2.3 用户级规则文件（可选）

ECC 约定在 `~/.claude/CLAUDE.md`（个人偏好）和 `~/.claude/rules/common/*.md`（编码/Git/测试/安全通用规则）放跨项目通用规则。装了 ECC 后按它的文档初始化即可；这部分是个人习惯，不是本插件的依赖。

---

## 3. 六阶段使用说明

每个阶段按"目的 → 轻量流默认 → 重型流追加 → 怎么调用"给出。**默认全走轻量流，碰到第 1 节的 6 条触发器才升级。**

### 阶段① 需求/规划

- **目的**：动手前把"要做什么、改哪些文件、有什么风险"说清楚，你确认后才开工。
- **轻量流**：`ecc:plan` —— 它会复述需求、评估风险、生成分步计划，然后**等你说 CONFIRM 才动代码**。
- **重型流**：planner agent（Opus 档）产出完整 PRD/架构文档；复杂需求可先用 `ecc:prp-prd` 交互式问答把需求磨清楚。
- **调用示例**：`/ecc:plan 给订单列表加一个按状态筛选的功能`
- **小技巧**：需求还很模糊时，用 `mattpocock-skills:grilling` 让 AI 反过来盘问你，把模糊想法逼成明确决策（本手册就是这么产出的）。

### 阶段② 编码实现

- **目的**：按计划写代码，过程可回退。
- **轻量流**：主对话直接写。**改码前必须 `git status`**——工作区不干净先 commit 一个 checkpoint（本插件的 hooks 会自动提醒）。
- **重型流**：`ecc:feature-dev` 引导式开发；接手陌生代码库先跑 `ecc:codebase-onboarding` 摸清结构再动手。
- **调用示例**：`/ecc:feature-dev 实现导入功能的失败回滚`

### 阶段③ 测试

- **目的**：证明改动是对的，且没弄坏别的。
- **轻量流**：写完代码补测试；用 `ecc:test-coverage` 查覆盖率缺口。
- **重型流**：`ecc:tdd-guide` —— **先写测试（红）→ 实现到通过（绿）→ 重构**，覆盖率 ≥80% 是硬门槛。
- **调用示例**：`/ecc:tdd-guide 给 Excel 导入解析器补测试`
- **测试服务规矩**（建议写进用户级规则）：测试端口绑 `0.0.0.0` 非生产端口，内网/本机可访问才算交付；绝不连生产库/生产容器。

### 阶段④ 代码评审 + 安全审查

- **目的**：多双眼睛挑毛病，按严重度分级处理。
- **轻量流**：code-reviewer agent 单评审，改完即提交。
- **重型流**：**三路并行**——code-reviewer（质量）+ security-reviewer（安全）+ 语言专属 reviewer（python-reviewer / vue-reviewer / fastapi-reviewer）。规则：CRITICAL 必须修完才能提交，HIGH 应修，MEDIUM 尽量修。
- **调用示例**：`/ecc:code-review`（审本地未提交改动）；PR 评审用 `/ecc:review-pr`
- **极端情况**：`ecc:santa-loop` 双盲审，两位独立评审都放行才交付。

### 阶段⑤ 部署/发布

- **目的**：每次发布走同一条 checklist，不靠记忆靠流程。
- **默认（不分轻重，一律照单执行）**：把家规（CLAUDE.md）第 5 节的发布检查清单骨架填成你项目的具体清单，之后每次发布逐项执行、逐项输出验证摘要表。
- **重型流追加**（碰生产必碰）：每个环节由你本人确认后才继续；发布前跑 `/ecc:checkpoint` 留回退点。
- **清单骨架**（生产项目实战验证过的七步）：
  1. 确认发布内容（`git log --oneline <上次tag>..<默认分支>` 分类列出）
  2. 生产拉取（`git pull`，冲突就停下排查，禁止强制覆盖）
  3. 前端有变更必须重新构建
  4. 用 `grep` 搜构建产物里的特征字符串验证（不能只 `ls` 看文件存在）
  5. 后端有变更必须重启服务并 curl 验证
  6. 打 tag 标记发布
  7. 输出验证摘要表格

### 阶段⑥ 维护

- **目的**：文档不腐烂、死代码不堆积。
- **轻量流**：`ecc:update-docs` 从真实代码同步文档；`ecc:refactor-clean` 安全清死代码。
- **重型流**：`ecc:update-codemaps` 重建架构 codemap + `ecc:repo-scan` 全仓扫描。
- **建议节奏**：每次大版本发布后跑一遍维护三件套。

---

## 4. 新项目初始化

### 方式 A（推荐）：插件一键初始化

```bash
claude plugin marketplace add moyu588/my_cc_skills
claude plugin install new-project-setup@my_cc_skills
```

然后在项目目录里启动 Claude Code，说 **`/new-project-setup`** 或"帮我初始化项目装备"。它会自动：

1. 拷贝家规模板（CLAUDE.md）+ hooks 安全防线（`.claude/`）——模板随插件自带，无需再下载任何东西
2. 扫描代码库，把家规占位符填成初稿，**对照表交你审核**，确认后才定稿
3. 按需配置项目级 `.mcp.json`（数据库直连）
4. 跑三项自检（git 纳管 / danger-guard 拦截测试 / 占位符清查）
5. 输出交付摘要表

空项目走"从零初始化"；已有 CLAUDE.md 或 `.claude/` 的存量项目走"增量补装"——**绝不静默覆盖已有内容**，合并建议逐项交你确认，覆盖前先备份。

### 方式 B：手动拷贝（兜底）

```bash
git clone https://github.com/moyu588/my_cc_skills
cd 你的项目目录
TEMPLATE=~/my_cc_skills/new-project-setup/skills/new-project-setup/assets/project-template
cp "$TEMPLATE/CLAUDE.md" .
cp -r "$TEMPLATE/.claude" .
chmod +x .claude/hooks/*.sh
# ⚠️ 存量项目（已有 CLAUDE.md 或 .claude/）禁止照抄上面命令——会覆盖已有配置，请改用方式 A 的增量分支
```

然后让 Claude"读一下这个代码库，把 CLAUDE.md 的占位符填成初稿"，你审核定稿；已有代码的项目可再跑 `/init` 补充代码结构说明。

### 完成后自检三件事

- [ ] `git status` 能看到 `.claude/` 和 `CLAUDE.md`（未跟踪 `??` 或已修改 ` M` 都算，关键是没被 .gitignore 误伤）
- [ ] danger-guard 拦截测试——**用管道喂合成输入，绝不真实执行危险命令**：
      `echo '{"tool_input":{"command":"rm -rf /tmp/x"}}' | .claude/hooks/danger-guard.sh; echo "exit=$?"` 期望 `exit=2`（拦截）；
      `echo '{"tool_input":{"command":"ls"}}' | .claude/hooks/danger-guard.sh; echo "exit=$?"` 期望 `exit=0`（放行）
- [ ] CLAUDE.md 里没有残留的【占位符】字样（"环境陷阱"一节允许保留"待补"字样）

---

## 5. 成本护栏与模型分工

### 两模型分工（推荐配置）

| 模型档位 | 角色 | 什么时候用 |
|---|---|---|
| **Sonnet 档（主力）** | 全能工程师 | 日常轻量流的全部工作，占 80% 工作量 |
| **Opus 档（总工）** | 评审专家/架构师 | 只在重型流出场：实施方案、架构决策、安全评审、疑难 bug |
| Haiku 档 | （可不配） | 适合海量机械小活，个人开发者通常没有这种场景 |

> 判断标准：账单没压力时单模型也能凑合；**两模型是性价比最优解**；三个以上是团队级玩法。

### 三条成本习惯

1. **大任务收尾看一眼账单**：`/ecc:cost-report`，对"分层"的实际开销心里有数。
2. **模型按分工用**：别让 Opus 干改文案的活，也别让 Sonnet 硬扛架构评审。
3. **token 异常大时立刻停下**：单次任务消耗远超预期，多半是循环重试卡住了——中断、看日志、换思路，别让它烧。

---

## 附录 A：Python/FastAPI 栈装备

全部来自 ECC 插件，无需额外安装，列出来是为了"知道有这个东西、什么时候点名用"。

| 装备 | 类型 | 什么时候用 |
|---|---|---|
| `ecc:fastapi-review` | skill | FastAPI 应用评审：async 正确性、依赖注入、Pydantic schema、安全 |
| `ecc:fastapi-patterns` | skill | 写 FastAPI 代码时查最佳实践模式 |
| `ecc:python-review` / python-reviewer | skill / agent | 一切 Python 代码改动后的语言专属评审（PEP8、类型注解、Pythonic） |
| `ecc:python-patterns`、`ecc:python-testing` | skill | Python 设计模式 / pytest 测试写法 |
| `ecc:database-reviewer` | agent | 写 SQL、设计表结构、做迁移前评审（SQLite/PostgreSQL 都管） |
| `ecc:silent-failure-hunter` | agent | 专项排查"吞错误"代码——导入/批量写库必须整体 try/except + rollback |

**FastAPI + SQLite 特别提醒**（从生产项目实战教训提炼，建议写进新项目 CLAUDE.md）：
- `create_all()` 只建表不改表，加列/删列必须手动 `ALTER TABLE`，改库前先备份 db 文件
- 导入/批量写库逻辑必须整体包 try/except，异常 rollback 后返回 500+详细信息
- 后端异常信息格式 `f"{type(e).__name__}: {str(e)}"`，不许吞错

## 附录 B：Vue3/TypeScript 栈装备

| 装备 | 类型 | 什么时候用 |
|---|---|---|
| `ecc:vue-review` / vue-reviewer | skill / agent | Vue 代码改动后评审：Composition API、响应性陷阱、模板安全 |
| `ecc:typescript-reviewer` | agent | TS/JS 改动评审（vue-review 会自动带上它） |
| `ecc:vue-patterns`、`ecc:vite-patterns` | skill | Vue/构建工具最佳实践 |
| `ecc:e2e-runner` | agent | 关键用户流程的端到端测试 |
| `ecc:browser-qa`、`ecc:click-path-audit` | skill | 浏览器里真实点一遍页面验证 |
| **chrome-devtools MCP** | MCP | 前端验证主力：无图形界面的服务器上，让 Claude 开浏览器截图给你看、读 console 报错 |

**前端验证特别提醒**：测试环境的前端服务必须绑 `0.0.0.0` 的非生产端口（内网可访问才算交付）；构建产物要用 `grep` 搜特征字符串验证，不能只 `ls`。

## 附录 C：第三方可选扩展（未验证）

> 本附录由生态调研产出（2026-09），**均未实测验证**。原则：主清单（第 2 节）已覆盖日常所需，以下仅在明确需要时逐个试用，一次只加一个。

### C.1 推荐补充项（按需逐个加）

| # | 名称 | 来源/热度 | 一句话用途 | 安装 | 优先级 |
|---|---|---|---|---|---|
| 1 | **Playwright MCP** | [microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp)，微软官方，36.9k★ | 浏览器**自动化操作**（E2E 测试、填表单、页面走查），与 chrome-devtools 的"调试观察"互补；还能解锁 ECC 自带 GAN 评估循环（它硬依赖 playwright 工具） | `claude mcp add playwright -- npx @playwright/mcp@latest` | ⭐ 最高 |
| 2 | **Serena** | [oraios/serena](https://github.com/oraios/serena)，29.1k★ | 基于 LSP 的**符号级**代码检索/编辑——按函数、类精确定位，大项目省 token | `claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context claude-code` | 中（已知个别版本有工具不暴露的 issue，装后自测） |
| 3 | **Anthropic 官方文档 skills** | [anthropics/skills](https://github.com/anthropics/skills)，官方，175k★ | 生成/编辑 **Word、Excel、PPT、PDF**——写汇报材料、导出台账 Excel。ECC/mattpocock 没覆盖的能力 | 把所需 skill 目录拷入 `~/.claude/skills/`，或经官方市场安装 | 中 |
| 4 | **fastapi_mcp** | [tadata-org/fastapi_mcp](https://github.com/tadata-org/fastapi_mcp)，12k★ | 几行代码把项目自己的 FastAPI 接口暴露成 MCP 工具，Claude 可直接调你的 API 查数据 | `pip install fastapi-mcp` 后在应用里 mount（代码集成） | 低（⚠️ 生产系统只挂测试实例、只读权限） |
| 5 | **GitHub MCP 官方远程版** | [github/github-mcp-server](https://github.com/github/github-mcp-server)，32.8k★ | issue/PR/代码搜索 API 级操作。**`gh` CLI 已覆盖 90% 场景**，仅 OAuth 免 PAT/远程托管时有增量价值 | `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` | 低 |
| 6 | **logfire 插件** | 官方市场收录，Pydantic 出品 | 给 FastAPI/SQLAlchemy 应用加可观测性（trace、慢查询、异常追踪） | `/plugin install logfire@claude-plugins-official` | 低（依赖 Pydantic Logfire 云服务，介意外部服务则跳过） |
| 7 | **claude-code-security-review** | [anthropics/claude-code-security-review](https://github.com/anthropics/claude-code-security-review)，官方，6.2k★ | GitHub CI 上对每个 PR 自动跑 AI 安全评审——与本地 security-reviewer 互补（本地管提交前，它管流水线兜底） | 仓库加 workflow YAML + `ANTHROPIC_API_KEY` secret | 低（消耗 API 额度；私有仓库需评估数据出域） |
| 8 | **Figma Context MCP** | [GLips/Figma-Context-MCP](https://github.com/GLips/Figma-Context-MCP)，15.8k★ | 把 Figma 设计稿喂给 Claude 还原 UI | `claude mcp add figma -- npx -y figma-developer-mcp --figma-api-key=<KEY> --stdio` | 仅当用 Figma |

### C.2 明确排除项（防止误装）

| 排除项 | 热度 | 排除理由 |
|---|---|---|
| obra/superpowers | 284k★ 社区第一 | 方法论（brainstorm→plan→TDD→review）与 ECC 的 plan/tdd/orch 系列完全同类，同装互相打架 |
| wshobson/agents、VoltAgent | 39.5k★/25k★ | ECC 已含 200+ agents，纯重复 |
| ccusage | 18.5k★ | 成本统计，ECC cost-report/cost-tracking 已覆盖 |
| desktop-commander、browser-use | 官方市场收录 | 终端/文件是原生能力；浏览器有 chrome-devtools + Playwright 足够 |
| coderabbit、claude-security 等评审插件 | 官方市场收录 | ECC security-scan/code-review/review-pr 已覆盖 |
| 官方 Postgres/SQLite 参考 MCP | 已归档 | Anthropic 已归档且被曝 SQL 注入漏洞（前车之鉴）。将来迁 PostgreSQL 用维护中的 [crystaldba/postgres-mcp](https://github.com/crystaldba/postgres-mcp) |

### C.3 调研总结论

1. 生态处于爆发期但已过野蛮生长：官方插件市场收录 200+ 经审插件，安装统一为 `/plugin` 和 `claude mcp add` 两条路。
2. **装了 ECC + mattpocock + 官方内置后，"工作流层"就已饱和**——评审/TDD/安全/成本/记忆全覆盖，再装任何 skill 包都是重复甚至冲突。
3. **真实缺口在"能力层" MCP**：Playwright（浏览器自动化）、Serena（符号级检索）、Office 文档生成、fastapi_mcp（应用自身 API）——按需补这 3~5 个即可。
4. 新项目起手只加 Playwright MCP，其余用一周、遇到具体痛点再补。社区共识是"**装多必删多**"——skill/MCP 都能执行代码，供应链风险真实存在。

### C.4 收藏级参考资源（不安装，用来淘货）

- [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)（53.8k★）：社区总索引
- [punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)（94.7k★）：MCP 服务器大全
- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)（74.8k★）：1000+ skills 目录

---

## 6. 换新栈时如何自己挑装备

将来开 Go/Rust/React 等新栈项目，不用重新调研，按三步在 ECC 里"点名"：

1. **找语言 reviewer**：ECC 命名规律是 `ecc:<语言>-review`（如 `ecc:go-review`、`ecc:rust-review`）——问 Claude "有哪些 Go 相关的 reviewer" 即可。
2. **找 patterns/testing**：同样规律，`ecc:<语言>-patterns`、`ecc:<语言>-testing`、`ecc:<框架>-build-resolver`。
3. **拿不准就让它自己挑**：跑 `ecc:agent-sort`——它会扫描你的仓库，把 ECC 全部装备分成"日常要用"和"备而不用"两桶，生成针对这个项目的精简接入计划；或用 `ecc:project-init` 检测技术栈自动生成 dry-run 计划。

> 核心思想：**装备库（ECC）是全集，每个项目只做"挑选"，不做"新装"。** 需要全新能力时才回到第 2 节流程装新插件。

## 7. 安装、更新与维护

**安装**：

```bash
claude plugin marketplace add moyu588/my_cc_skills
claude plugin install new-project-setup@my_cc_skills
```

**更新**：作者推送新版本后，使用者执行 `claude plugin update new-project-setup`（或在 `/plugin` 菜单里更新）。

**维护约定**（给作者自己）：

- 改装备标准（家规条目、hooks 模式清单、权限白名单）→ 只改 `skills/new-project-setup/assets/project-template/`
- 改初始化流程 → 只改 `SKILL.md`
- 改方法论/工具推荐 → 只改本手册（插件根目录 README.md）
- 每次发布把 `.claude-plugin/plugin.json` 和根目录 `marketplace.json` 里的 `version` 一起 +1
