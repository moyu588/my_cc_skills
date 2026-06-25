# my_cc_skills

## 项目简介

个人 Claude Code Skills 仓库，用于：

- **管理自建 Skills** — 存放自己创建和维护的 Claude Code Skill（如 `token-audit`）
- **收录社区精品** — 持续追踪 GitHub 上高质量、高 Star 的 Skill 类项目，聚焦安全、软件工程、开发效率三大领域
- **快速参考** — 需要某个领域的 Skill 时，可快速查找和评估

项目本身已集成 [OpenWolf](https://github.com/openwolf)（AI 辅助开发的 anatomy 追踪与记忆系统），`.wolf/anatomy.md` 自动维护项目文件索引，`.wolf/cerebrum.md` 记录开发偏好与约定。

## 🛠️ 个人 Skills（自建）

> 自己创建和维护的 Claude Code Skills，详细用法见各子目录下的 `README.md`。

<table>
<colgroup><col width="18%"><col width="40%"><col width="42%"></colgroup>
<tr><th>项目</th><th>简介</th><th>说明</th></tr>
<tr><td><a href="./token-audit/">token-audit</a></td><td>通用 Token 浪费分析与自动修复，适用于 Claude Code + OpenWolf 项目栈</td><td>零依赖 Node.js 脚本，场景感知（LLM Wiki / 代码开发 / 通用），支持 quick / full / trend 三种分析模式，自然语言触发，MIT 开源</td></tr>
</table>

## 🌟 精选 Skills（来自社区）

> 聚焦**安全 / 开发 / 软件工程**三大领域，按 ⭐ Star 数排序。Star 数据基于 2026 年 6 月 25日。

---

## 🔒 安全（Security × Skill）

<table>
<colgroup><col width="16%"><col width="10%"><col width="37%"><col width="37%"></colgroup>
<tr><th>项目</th><th>Stars</th><th>简介</th><th>评价分析</th></tr>
<tr><td><a href="https://github.com/mukul975/Anthropic-Cybersecurity-Skills">Anthropic-Cybersecurity-Skills</a></td><td>🔥 高活跃</td><td>817 个结构化网络安全技能，映射 MITRE ATT&CK、NIST CSF 2.0、MITRE ATLAS、D3FEND 等 6 大框架，兼容 20+ 平台</td><td>覆盖最全的安全 Skill 仓库，框架映射完整，适合防御体系建设与合规映射，安全从业者<b>首选参考库</b></td></tr>
<tr><td><a href="https://github.com/trailofbits/skills">trailofbits/skills</a></td><td>🏛️ 官方权威</td><td>顶级安全研究机构 Trail of Bits 官方出品，专注 AI 辅助安全分析、测试与开发</td><td>出处可信、质量有保障，安全领域<b>含金量最高的官方 Skill</b>，适合代码审计与安全研究</td></tr>
<tr><td><a href="https://github.com/hypnguyen1209/offensive-claude">offensive-claude</a></td><td>⭐ 实战向</td><td>Claude Code 攻防工具包，覆盖红队、漏洞开发、AD 攻击、EDR 绕过、移动端渗透</td><td>攻击链完整，内容深度强，适合红队演练与 CTF，<b>需在授权环境下使用</b></td></tr>
<tr><td><a href="https://github.com/SnailSploit/Claude-Red">Claude-Red</a></td><td>⭐ 结构精良</td><td>每个 Skill 均为结构化 SKILL.md，覆盖 SQLi、Shellcode、EDR 绕过、初始访问等攻击面</td><td>方法论清晰，专家级攻击面覆盖，适合渗透测试人员<b>按需加载特定攻击技能</b></td></tr>
<tr><td><a href="https://github.com/elementalsouls/Claude-BugHunter">Claude-BugHunter</a></td><td>⭐ Bug Bounty</td><td>71 个技能、15 个斜杠命令、681 个漏洞报告模式，覆盖 24 个漏洞类别</td><td>数据量大、模式丰富，漏洞报告模板尤为实用，<b>Bug Bounty 效率最高的专项 Skill</b></td></tr>
<tr><td><a href="https://github.com/0xSteph/pentest-ai-agents">pentest-ai-agents</a></td><td>⭐ 多智能体</td><td>将 Claude Code 转变为攻击性安全研究助手，多个专业化子代理协作</td><td>架构设计合理，适合复杂渗透测试场景的任务分解与并行执行，<b>子代理协作是亮点</b></td></tr>
<tr><td><a href="https://github.com/Masriyan/Claude-Code-CyberSecurity-Skill">Claude-Code-CyberSecurity-Skill</a></td><td>⭐ 攻防均衡</td><td>15 个网络安全专项 Skills，覆盖攻击性安全、防御运营、逆向工程、红队作战</td><td>攻防双视角，适合需要全面安全能力的从业者，<b>入门安全 Skill 的好选择</b></td></tr>
</table>

---

## 💻 软件工程（Software Engineering × Skill）

<table>
<colgroup><col width="16%"><col width="10%"><col width="37%"><col width="37%"></colgroup>
<tr><th>项目</th><th>Stars</th><th>简介</th><th>评价分析</th></tr>
<tr><td><a href="https://github.com/obra/superpowers">obra/superpowers</a></td><td>⭐ <b>228,740</b></td><td>完整软件开发方法论 Skills：TDD（红绿重构）、YAGNI、DRY、子代理驱动开发，支持 Claude Code / Codex / OpenCode</td><td>安装后 Claude 先问清需求再拆解计划，实测可<b>自主工作 2+ 小时不跑偏</b>，软件工程领域<b>必装第一名</b></td></tr>
<tr><td><a href="https://github.com/affaan-m/ecc">affaan-m/ECC</a></td><td>⭐ <b>211,900</b></td><td>Agent Harness 性能优化系统，v2.0 含 262 Skills、64 Agents、84 命令 Shims，支持 7 个主流 Harness</td><td>10+ 个月真实工程实践沉淀，含记忆持久化、安全扫描、Token 优化，重度 Agent 用户的<b>终极配置</b></td></tr>
<tr><td><a href="https://github.com/mattpocock/skills">mattpocock/skills</a></td><td>⭐ <b>130,016</b></td><td>TypeScript 布道师 Matt Pocock 的个人 Claude Code Skills 集，直接来自真实 <code>.claude</code> 目录</td><td>真实工程师生产实践沉淀，<b>质量远超 AI 生成模板</b>，TypeScript / 前端开发者高度契合</td></tr>
<tr><td><a href="https://github.com/garrytan/gstack">garrytan/gstack</a></td><td>⭐ <b>110,407</b></td><td>8 个专业化斜杠命令：<code>/plan-ceo-review</code>、<code>/plan-eng-review</code>、<code>/review</code>、<code>/ship</code>、<code>/browse</code>、<code>/qa</code>、<code>/retro</code> 等</td><td>把 Claude Code 变成一支专家团队，支持 10 个并行 Agent，<b>独立开发者和小团队的效率神器</b></td></tr>
<tr><td><a href="https://github.com/addyosmani/agent-skills">addyosmani/agent-skills</a></td><td>⭐ <b>60,265</b></td><td>Google Chrome 工程师出品，24 个生产级工程 Skills，覆盖 DEFINE→PLAN→BUILD→VERIFY→REVIEW→SHIP 完整生命周期</td><td>出处权威，工程规范最严谨，兼容 Claude / Cursor / Gemini CLI / Copilot / Kiro 等多平台，<b>团队工程规范首选</b></td></tr>
<tr><td><a href="https://github.com/Jeffallan/claude-skills">Jeffallan/claude-skills</a></td><td>⭐ 社区精品</td><td>66 个全栈开发专项 Skills，覆盖语言、后端/前端框架、基础设施、API、测试、DevOps、安全、数据/ML 共 12 类</td><td>框架覆盖广，渐进式加载设计合理，<b>全栈工程师日常使用的好选择</b></td></tr>
<tr><td><a href="https://github.com/zxkane/aws-skills">zxkane/aws-skills</a></td><td>⭐ 云原生</td><td>AWS CDK 最佳实践、成本优化 MCP Server、Serverless / 事件驱动架构模式</td><td><b>AWS 重度用户的效率神器</b>，架构决策有据可依，适合云原生开发团队</td></tr>
</table>

---

## 🤖 开发效率 & 元工具（Dev Productivity × Skill）

<table>
<colgroup><col width="16%"><col width="10%"><col width="37%"><col width="37%"></colgroup>
<tr><th>项目</th><th>Stars</th><th>简介</th><th>评价分析</th></tr>
<tr><td><a href="https://github.com/ComposioHQ/awesome-claude-skills">ComposioHQ/awesome-claude-skills</a></td><td>⭐ <b>65,600</b></td><td>最大社区 Skills 聚合目录，1000+ 生产可用 Skills，支持 Claude / Codex / Cursor / Gemini CLI 等 11 个平台</td><td><b>发现新 Skill 的最佳入口</b>，质量参差不齐，建议作为索引使用而非全量安装</td></tr>
<tr><td><a href="https://github.com/anthropics/skills">anthropics/skills</a></td><td>⭐ <b>45,100</b></td><td>Anthropic 官方仓库，含 docx/pdf/pptx/xlsx 文档处理、web-artifacts-builder、mcp-builder、webapp-testing、skill-creator</td><td><b>质量基准线最高，规范最权威</b>，是理解 Skill 标准格式的首选参考，<code>skill-creator</code> 是入门创建 Skill 的官方起点</td></tr>
<tr><td><a href="https://github.com/FrancyJGLisboa/agent-skill-creator">FrancyJGLisboa/agent-skill-creator</a></td><td>⭐ 社区增强</td><td>5 阶段自动创建流程，输出 1500~2000 行生产级 Python + 10000+ 字文档，支持从 YouTube / 文档自动提取工作流</td><td>官方 skill-creator 的重量级社区替代，<b>从"描述重复任务"到"生成完整 Skill"全自动</b>，适合业务流程自动化落地</td></tr>
<tr><td><a href="https://github.com/orchestra-research/AI-research-SKILLs">Orchestra-Research/AI-Research-SKILLs</a></td><td>⭐ <b>10,100</b></td><td>98 个 AI 研究专项 Skills，覆盖模型架构/微调/RAG/安全对齐/分布式训练/推理服务等 23 个类别</td><td><b>AI 研究员的完整工具链</b>，vLLM/TRL/Megatron 等主流框架均有专项 Skill，从论文构思到发表全流程覆盖</td></tr>
</table>
