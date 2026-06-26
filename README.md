# my_cc_skills

## 项目简介

个人 Claude Code Skills 仓库，用于：

- **管理自建 Skills** — 存放自己创建和维护的 Claude Code Skill（如 `token-audit`）
- **收录社区精品** — 持续追踪 GitHub 上高质量、高 Star 的 Skill 类项目，覆盖导航索引、网络安全、通用技能三大板块
- **快速参考** — 需要某个领域的 Skill 时，可快速查找和评估

项目本身已集成 [OpenWolf](https://github.com/openwolf)（AI 辅助开发的 anatomy 追踪与记忆系统），`.wolf/anatomy.md` 自动维护项目文件索引，`.wolf/cerebrum.md` 记录开发偏好与约定。

---

## 🛠️ 个人 Skills（自建）

> 自己创建和维护的 Claude Code Skills，详细用法见各子目录下的 `README.md`。

| 项目                            | 简介                                                | 说明                                                                                     |
| ----------------------------- | ------------------------------------------------- | -------------------------------------------------------------------------------------- |
| [token-audit](./token-audit/) | 通用 Token 浪费分析与自动修复，适用于 Claude Code + OpenWolf 项目栈 | 零依赖 Node.js 脚本，场景感知（LLM Wiki / 代码开发 / 通用），支持 quick / full / trend 三种分析模式，自然语言触发，MIT 开源 |

---

## 🌟 精选 Skills（来自社区）

> 聚焦**安全 / 软件工程 / 开发效率**三大领域，按 ⭐ Star 数排序。Star 数据基于 2026 年 6 月 26 日。

---

## 🗺️ 导航索引（Skill 生态入口）

> 这类项目**本身不是可直接安装的 Skill**，而是发现、筛选、评估 Skill 的"入口"。适合在选型阶段使用。

| 项目                                                                                          | 简介                                                                                                                                   | 评价分析                                       |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------ |
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)     | ⭐ 65,600 — 最大社区 Skills 聚合目录，1000+ 生产可用 Skills，支持 Claude / Codex / Cursor / Gemini CLI 等 11 个平台                                       | **发现新 Skill 的最佳入口**，质量参差不齐，建议作为索引使用而非全量安装  |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)     | ⭐ 47,253 — Claude Code 生态最全导航，收录 Skill、Hook、Slash Command、Agent Orchestrator、Plugin                                                  | 发现高质量 Skill 的**最佳索引**，适合定期浏览寻找新工具          |
| [wshobson/agents](https://github.com/wshobson/agents)                                       | ⭐ 37,168 — 88 个 Plugin、194 个 Agent、158 个 Skill、106 个 Command 的多 Harness 市场，单源同步到 Claude Code / Codex / Cursor / Gemini CLI / Copilot | 跨平台统一管理的**多 Harness 超市**，含完整 Plugin 质量评估框架 |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | ⭐ 31,085 — Anthropic 官方维护的高质量 Claude Code Plugin 目录，经过人工审核                                                                           | 安全安装 Skill 的**最可信来源**，规避 ToxicSkills 风险的首选 |
| [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)         | ⭐ 26,411 — 1,000+ 官方 Skill 精选集，收录 Anthropic、Google、Vercel、Stripe、HashiCorp 等顶级团队官方 Skill，手工筛选，非 AI 批量生成                              | 质量最有保障的精选集，**优先在此找官方 Skill**               |

---

## 🔒 网络安全（Security × Skill）

| 项目                                                                                                      | 简介                                                                                        | 评价分析                                                 |
| ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| [mukul975/Anthropic-Cybersecurity-Skills](https://github.com/mukul975/Anthropic-Cybersecurity-Skills)   | 🔥 高活跃 — 817 个结构化网络安全技能，映射 MITRE ATT&CK、NIST CSF 2.0、MITRE ATLAS、D3FEND 等 6 大框架，兼容 20+ 平台 | 覆盖最全的安全 Skill 仓库，框架映射完整，适合防御体系建设与合规映射，安全从业者**首选参考库** |
| [trailofbits/skills](https://github.com/trailofbits/skills)                                             | 🏛️ — 顶级安全研究机构 Trail of Bits 官方出品，专注 AI 辅助安全分析、测试与开发                                      | 出处可信、质量有保障，安全领域**含金量最高的官方 Skill**，适合代码审计与安全研究        |
| [elementalsouls/Claude-BugHunter](https://github.com/elementalsouls/Claude-BugHunter)                   | ⭐ 2,725 — 71 个技能、15 个斜杠命令、681 个漏洞报告模式，覆盖 24 个漏洞类别                                         | 数据量大、模式丰富，漏洞报告模板尤为实用，**Bug Bounty 效率最高的专项 Skill**    |
| [SnailSploit/Claude-Red](https://github.com/SnailSploit/Claude-Red)                                     | ⭐ 2,391 — 每个 Skill 均为结构化 SKILL.md，覆盖 SQLi、Shellcode、EDR 绕过、初始访问等攻击面                       | 方法论清晰，专家级攻击面覆盖，适合渗透测试人员**按需加载特定攻击技能**                |
| [hypnguyen1209/offensive-claude](https://github.com/hypnguyen1209/offensive-claude)                     | ⭐ 298 — Claude Code 攻防工具包，覆盖红队、漏洞开发、AD 攻击、EDR 绕过、移动端渗透                                    | 攻击链完整，内容深度强，适合红队演练与 CTF，**需在授权环境下使用**                |
| [Masriyan/Claude-Code-CyberSecurity-Skill](https://github.com/Masriyan/Claude-Code-CyberSecurity-Skill) | ⭐ 118 — 15 个网络安全专项 Skills，覆盖攻击性安全、防御运营、逆向工程、红队作战                                          | 攻防双视角，适合需要全面安全能力的从业者，**入门安全 Skill 的好选择**             |
| [0xSteph/pentest-ai-agents](https://github.com/0xSteph/pentest-ai-agents)                               | ⭐ 多智能体 — 将 Claude Code 转变为攻击性安全研究助手，多个专业化子代理协作                                            | 架构设计合理，适合复杂渗透测试场景的任务分解与并行执行，**子代理协作是亮点**             |

---

## 🧰 通用技能（General × Skill）

> 涵盖软件工程方法论、开发效率、AI 研究等方向，按 Star 数排序。

| 项目                                                                                                | 简介                                                                                             | 评价分析                                                                            |
| ------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| [obra/superpowers](https://github.com/obra/superpowers)                                           | ⭐ 228,740 — TDD/YAGNI/DRY 方法论 Skills，支持 Claude Code / Codex / OpenCode                         | 安装后 Claude 先问清需求再拆解计划，实测可**自主工作 2+ 小时不跑偏**，软件工程领域**必装第一名**                      |
| [affaan-m/ECC](https://github.com/affaan-m/ecc)                                                   | ⭐ 211,900 — v2.0 含 262 Skills、64 Agents、84 命令 Shims，支持 7 个主流 Harness                           | 10+ 个月真实工程实践沉淀，含记忆持久化、安全扫描、Token 优化，重度 Agent 用户的**终极配置**                        |
| [mattpocock/skills](https://github.com/mattpocock/skills)                                         | ⭐ 130,016 — TypeScript 布道师的个人 Skills 集，直接来自真实 `.claude` 目录                                     | 真实工程师生产实践沉淀，**质量远超 AI 生成模板**，TypeScript / 前端开发者高度契合                             |
| [garrytan/gstack](https://github.com/garrytan/gstack)                                             | ⭐ 110,407 — 8 个专业化斜杠命令：`/plan`、`/review`、`/ship`、`/qa`、`/retro` 等                              | 把 Claude Code 变成一支专家团队，支持 10 个并行 Agent，**独立开发者和小团队的效率神器**                       |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)                             | ⭐ 60,265 — Google Chrome 工程师出品，24 个生产级 Skills，覆盖完整开发生命周期                                       | 出处权威，工程规范最严谨，兼容 Claude / Cursor / Gemini CLI / Copilot / Kiro 等多平台，**团队工程规范首选** |
| [anthropics/skills](https://github.com/anthropics/skills)                                         | ⭐ 45,100 — Anthropic 官方仓库，含文档处理、web-artifacts-builder、mcp-builder、webapp-testing、skill-creator | **质量基准线最高，规范最权威**，是理解 Skill 标准格式的首选参考，`skill-creator` 是入门创建 Skill 的官方起点         |
| [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills)                             | ⭐ 10,219 — 66 个全栈 Skills，覆盖后端/前端/DevOps/安全/数据等 12 类                                            | 框架覆盖广，渐进式加载设计合理，**全栈工程师日常使用的好选择**                                               |
| [Orchestra-Research/AI-Research-SKILLs](https://github.com/orchestra-research/AI-research-SKILLs) | ⭐ 10,100 — 98 个 AI 研究专项 Skills，覆盖模型架构/微调/RAG/安全对齐/分布式训练等 23 个类别                                | **AI 研究员的完整工具链**，vLLM/TRL/Megatron 等主流框架均有专项 Skill，从论文构思到发表全流程覆盖                |

---

> **⚠️ 安全提示：** Snyk 的 ToxicSkills 研究发现，36% 的社区 Skill 存在 Prompt Injection，生态中共检测到 1,467 个恶意载荷。安装任何第三方 Skill 前，务必仔细审查 `SKILL.md` 及捆绑脚本，优先选择 `anthropics/claude-plugins-official` 目录中经过审核的 Skill。
