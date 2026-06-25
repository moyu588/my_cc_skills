# my_cc_skills

## 项目简介

个人 Claude Code Skills 仓库，用于：

- **管理自建 Skills** — 存放自己创建和维护的 Claude Code Skill（如 `token-audit`）
- **收录社区精品** — 持续追踪 GitHub 上高质量、高 Star 的 Skill 类项目，聚焦安全、软件工程、开发效率三大领域
- **快速参考** — 需要某个领域的 Skill 时，可快速查找和评估

项目本身已集成 [OpenWolf](https://github.com/openwolf)（AI 辅助开发的 anatomy 追踪与记忆系统），`.wolf/anatomy.md` 自动维护项目文件索引，`.wolf/cerebrum.md` 记录开发偏好与约定。

## 🛠️ 个人 Skills（自建）

> 自己创建和维护的 Claude Code Skills，详细用法见各子目录下的 `README.md`。

| 项目 | 简介 | 说明 |
|------|------|------|
| [token-audit](./token-audit/) | 通用 Token 浪费分析与自动修复，适用于 Claude Code + OpenWolf 项目栈 | 零依赖 Node.js 脚本，场景感知（LLM Wiki / 代码开发 / 通用），支持 quick / full / trend 三种分析模式，自然语言触发，MIT 开源 |

## 🌟 精选 Skills（来自社区）

> 聚焦**安全 / 开发 / 软件工程**三大领域，按 ⭐ Star 数排序。Star 数据基于 2026 年 6 月 25日。

---

## 🔒 安全（Security × Skill）

| 项目 | Stars | 简介 | 评价分析 |
|------|-------|------|---------|
| [Anthropic-Cybersecurity-Skills](https://github.com/mukul975/Anthropic-Cybersecurity-Skills) | 🔥 高活跃 | 817 个结构化网络安全技能，映射 MITRE ATT&CK、NIST CSF 2.0、MITRE ATLAS、D3FEND 等 6 大框架，兼容 20+ 平台 | 覆盖最全的安全 Skill 仓库，框架映射完整，适合防御体系建设与合规映射，安全从业者**首选参考库** |
| [trailofbits/skills](https://github.com/trailofbits/skills) | 🏛️ 官方权威 | 顶级安全研究机构 Trail of Bits 官方出品，专注 AI 辅助安全分析、测试与开发 | 出处可信、质量有保障，安全领域**含金量最高的官方 Skill**，适合代码审计与安全研究 |
| [offensive-claude](https://github.com/hypnguyen1209/offensive-claude) | ⭐ 实战向 | Claude Code 攻防工具包，覆盖红队、漏洞开发、AD 攻击、EDR 绕过、移动端渗透 | 攻击链完整，内容深度强，适合红队演练与 CTF，**需在授权环境下使用** |
| [Claude-Red](https://github.com/SnailSploit/Claude-Red) | ⭐ 结构精良 | 每个 Skill 均为结构化 SKILL.md，覆盖 SQLi、Shellcode、EDR 绕过、初始访问等攻击面 | 方法论清晰，专家级攻击面覆盖，适合渗透测试人员**按需加载特定攻击技能** |
| [Claude-BugHunter](https://github.com/elementalsouls/Claude-BugHunter) | ⭐ Bug Bounty | 71 个技能、15 个斜杠命令、681 个漏洞报告模式，覆盖 24 个漏洞类别 | 数据量大、模式丰富，漏洞报告模板尤为实用，**Bug Bounty 效率最高的专项 Skill** |
| [pentest-ai-agents](https://github.com/0xSteph/pentest-ai-agents) | ⭐ 多智能体 | 将 Claude Code 转变为攻击性安全研究助手，多个专业化子代理协作 | 架构设计合理，适合复杂渗透测试场景的任务分解与并行执行，**子代理协作是亮点** |
| [Claude-Code-CyberSecurity-Skill](https://github.com/Masriyan/Claude-Code-CyberSecurity-Skill) | ⭐ 攻防均衡 | 15 个网络安全专项 Skills，覆盖攻击性安全、防御运营、逆向工程、红队作战 | 攻防双视角，适合需要全面安全能力的从业者，**入门安全 Skill 的好选择** |

---

## 💻 软件工程（Software Engineering × Skill）

| 项目 | Stars | 简介 | 评价分析 |
|------|-------|------|---------|
| [obra/superpowers](https://github.com/obra/superpowers) | ⭐ **228,740** | 完整软件开发方法论 Skills：TDD（红绿重构）、YAGNI、DRY、子代理驱动开发，支持 Claude Code / Codex / OpenCode | 安装后 Claude 先问清需求再拆解计划，实测可**自主工作 2+ 小时不跑偏**，软件工程领域**必装第一名** |
| [affaan-m/ECC](https://github.com/affaan-m/ecc) | ⭐ **211,900** | Agent Harness 性能优化系统，v2.0 含 262 Skills、64 Agents、84 命令 Shims，支持 7 个主流 Harness | 10+ 个月真实工程实践沉淀，含记忆持久化、安全扫描、Token 优化，重度 Agent 用户的**终极配置** |
| [mattpocock/skills](https://github.com/mattpocock/skills) | ⭐ **130,016** | TypeScript 布道师 Matt Pocock 的个人 Claude Code Skills 集，直接来自真实 `.claude` 目录 | 真实工程师生产实践沉淀，**质量远超 AI 生成模板**，TypeScript / 前端开发者高度契合 |
| [garrytan/gstack](https://github.com/garrytan/gstack) | ⭐ **110,407** | 8 个专业化斜杠命令：`/plan-ceo-review`、`/plan-eng-review`、`/review`、`/ship`、`/browse`、`/qa`、`/retro` 等 | 把 Claude Code 变成一支专家团队，支持 10 个并行 Agent，**独立开发者和小团队的效率神器** |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | ⭐ **60,265** | Google Chrome 工程师出品，24 个生产级工程 Skills，覆盖 DEFINE→PLAN→BUILD→VERIFY→REVIEW→SHIP 完整生命周期 | 出处权威，工程规范最严谨，兼容 Claude / Cursor / Gemini CLI / Copilot / Kiro 等多平台，**团队工程规范首选** |
| [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) | ⭐ 社区精品 | 66 个全栈开发专项 Skills，覆盖语言、后端/前端框架、基础设施、API、测试、DevOps、安全、数据/ML 共 12 类 | 框架覆盖广，渐进式加载设计合理，**全栈工程师日常使用的好选择** |
| [zxkane/aws-skills](https://github.com/zxkane/aws-skills) | ⭐ 云原生 | AWS CDK 最佳实践、成本优化 MCP Server、Serverless / 事件驱动架构模式 | **AWS 重度用户的效率神器**，架构决策有据可依，适合云原生开发团队 |

---

## 🤖 开发效率 & 元工具（Dev Productivity × Skill）

| 项目 | Stars | 简介 | 评价分析 |
|------|-------|------|---------|
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | ⭐ **65,600** | 最大社区 Skills 聚合目录，1000+ 生产可用 Skills，支持 Claude / Codex / Cursor / Gemini CLI 等 11 个平台 | **发现新 Skill 的最佳入口**，质量参差不齐，建议作为索引使用而非全量安装 |
| [anthropics/skills](https://github.com/anthropics/skills) | ⭐ **45,100** | Anthropic 官方仓库，含 docx/pdf/pptx/xlsx 文档处理、web-artifacts-builder、mcp-builder、webapp-testing、skill-creator | **质量基准线最高，规范最权威**，是理解 Skill 标准格式的首选参考，`skill-creator` 是入门创建 Skill 的官方起点 |
| [FrancyJGLisboa/agent-skill-creator](https://github.com/FrancyJGLisboa/agent-skill-creator) | ⭐ 社区增强 | 5 阶段自动创建流程，输出 1500~2000 行生产级 Python + 10000+ 字文档，支持从 YouTube / 文档自动提取工作流 | 官方 skill-creator 的重量级社区替代，**从"描述重复任务"到"生成完整 Skill"全自动**，适合业务流程自动化落地 |
| [Orchestra-Research/AI-Research-SKILLs](https://github.com/orchestra-research/AI-research-SKILLs) | ⭐ **10,100** | 98 个 AI 研究专项 Skills，覆盖模型架构/微调/RAG/安全对齐/分布式训练/推理服务等 23 个类别 | **AI 研究员的完整工具链**，vLLM/TRL/Megatron 等主流框架均有专项 Skill，从论文构思到发表全流程覆盖 |

---


