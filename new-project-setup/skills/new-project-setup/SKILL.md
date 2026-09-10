---
name: new-project-setup
description: 新项目标准装备初始化——从本 skill 自带的 assets/project-template/ 拷贝家规（CLAUDE.md）和 hooks 安全防线（.claude/）到当前项目，扫描代码库把占位符填成初稿交用户审核，按需配置项目级 .mcp.json，最后跑三项自检。当用户说"初始化新项目""新项目装备""装家规/hooks""拷贝项目模板""给这个老项目补装标准装备""new-project-setup"时使用本 skill；即使用户没提 skill 二字，只要意图是把标准开发装备铺进一个项目目录，就应触发。
---

# 新项目标准装备初始化

把本 skill **自带的** `assets/project-template/` 标准装备（家规 CLAUDE.md + hooks 安全防线）铺进目标项目，并把家规占位符填成贴合本项目实际的初稿。全流程七步，是装备手册（插件根目录 `README.md`，即本 skill 基目录上两级；install.sh 安装方式则与 SKILL.md 同目录）第 4 节的展开细化版。

**为什么需要这个流程**：家规和 hooks 是"第 0 条铁律"（生产与数据安全优先于一切）的落地防线。手工拷贝容易漏步骤、忘 chmod、忘填占位符，存量项目还容易误覆盖已有配置——本 skill 把流程标准化，并区分"从零初始化"和"存量项目增量补装"两个分支。

## 安全边界（先读这个）

- **只在目标项目目录内写文件**。本 skill 的 assets 目录是只读模板源；绝不写其他项目目录、绝不碰生产路径。
- **生产判断操作清单**——命中任何一条就先停下问用户，不得试错：路径疑似已知生产目录；目录内有正在运行的生产 systemd 服务/容器引用；存在生产数据库文件；用户提过"这是生产"。
- **任何分支都不得覆盖已存在的文件**：已存在的文件只能走"备份 → 合并建议 → 用户确认"；只有确认不存在的文件才允许直接拷入。
- **不自动 git commit**：流程结束时提醒用户自行做 checkpoint commit。
- 所有需要用户确认的内容（合并建议、占位符初稿、MCP 配置）**可以合并成一次对照表呈现、一轮确认**，减少交互轮次；用户主动要求逐项时再逐项。

## 第 1 步：前置检查

1. 确认目标项目根目录：向用户复述**绝对路径**；后续所有命令先 `cd` 到该目录或写绝对路径（防 bash 调用间 cwd 漂移）。
2. 确认模板源存在：`ls <skill基目录>/assets/project-template/`（skill 基目录由系统在加载本 skill 时给出，下文记作 `$SKILL_DIR`）。缺失说明插件安装不完整，报错并指引重装：`claude plugin install new-project-setup@my_cc_skills`。**不要**凭记忆手写模板内容。
3. `git status`：不是 git 仓库 → 建议先 `git init`；工作区不干净 → 提醒用户先决定是否 checkpoint commit。

## 第 2 步：分支判断（必须用 ls -a，.claude 是隐藏目录）

普通 `ls` 看不到 `.claude/`，会把存量项目误判成空项目。必须：

```bash
cd <项目目录> && ls -a
test -e CLAUDE.md && echo HAS_CLAUDE_MD || echo NO_CLAUDE_MD
test -d .claude   && echo HAS_DOT_CLAUDE || echo NO_DOT_CLAUDE
```

| 已有内容 | 走法 |
|---|---|
| 两者都无 | **从零初始化**：第 3 步整拷 |
| 只有 CLAUDE.md | **增量补装**：拷 .claude/（逐文件），CLAUDE.md 走第 4 步合并 |
| 只有 .claude/ | **增量补装**：拷 CLAUDE.md（不存在才拷），settings.json/hooks 走第 3 步合并规则 |
| 两者都有 | **增量补装**：全部走合并规则 |

## 第 3 步：拷贝与权限

**从零分支**（第 2 步确认两者都不存在）：

```bash
cd <项目目录>
cp "$SKILL_DIR/assets/project-template/CLAUDE.md" .
cp -r "$SKILL_DIR/assets/project-template/.claude" .
chmod +x .claude/hooks/*.sh
```

**增量分支**：**禁止整目录 `cp -r .claude`**——它会静默盖掉用户已有的 settings.json。逐文件拷：

```bash
cd <项目目录>
mkdir -p .claude/hooks
cp -n "$SKILL_DIR/assets/project-template/.claude/hooks/"*.sh .claude/hooks/   # -n = 已存在不覆盖
chmod +x .claude/hooks/*.sh
```

增量时的合并规则：

- **settings.json 已存在** → 不拷贝，做合并：`permissions.allow` 取并集（已有条目排前、去重）；hooks 里**不存在的事件键**直接新增模板配置；**已存在的同名事件键**（用户自己已有 hooks）不自动合并——把两边配置列给用户，等用户决定怎么合。改前先备份。
- **同名 hooks 脚本已存在**：内容相同 → 跳过并告知；内容不同 → 把 diff 给用户选（保留自己的 / 用模板的），选覆盖必须先备份。
- **CLAUDE.md 已存在** → 不拷贝，交给第 4 步合并。
- **重跑语义**：本步骤幂等——中途失败重跑时，已存在的文件一律跳过或走合并，不报错不覆盖。

拷完验证：settings.json 是合法 JSON（`python3 -c "import json;json.load(open('.claude/settings.json'))"`）；`hooks/` 下**所有** .sh 存在且可执行（不要写死脚本数量，以模板实际内容为准）。

## 第 4 步：合并家规 + 填占位符初稿（一次对照表，一轮确认）

**增量场景先做合并建议**：对已有 CLAUDE.md 逐节列"已有内容 / 模板新增 / 建议动作"。已有自有规矩**原文保留、放在靠前位置**，模板六节并入其后。

**然后扫描代码库填占位符**（读 README、依赖清单、入口文件、数据库配置、目录结构；顺带检查空目录的 git 盲区，如空 `database/` 不会被 git 跟踪，可建议补 `.gitkeep`）：

- **项目名/一句话简介**：从 README 或 package 元数据提炼"做什么、给谁用、技术栈组成"
- **生产禁区清单**：**必须问用户，不许猜**——猜错直接违反第 0 条铁律；用户不知道就写"待补"
- **数据库**：检测实际类型与迁移方式（SQLite + create_all / Alembic / Django migrations…），写清"改表规矩 + 改库前备份"；检测不到才写"待补"
- **环境陷阱**：固定写"待补——踩坑后随时补充"，**不带【】括号**（避免与第 6 步自检 ③ 冲突；这是唯一常设豁免项）
- **发布检查清单**：把七步骨架落成本项目具体命令，**必须核对再写**：默认分支名（main 还是 master）、有无 remote、有无 tag 习惯、有无前端构建、有无生产发布环节——不适用的一步裁剪掉并注明原因，不照抄模板

存量代码项目可顺带建议：定稿后跑 `/init` 生成代码结构说明（可选补充，不替代家规）。

初稿以对照表呈现（每节：初稿内容 + 依据来源），**用户确认后才写入定稿**。

## 第 5 步：项目级 MCP（按需）

数据库检测条件（满足任一即算有）：存在 .db/.sqlite 文件；代码里有数据库连接串或 db 路径字符串；有 ORM/数据库配置文件。**只看文件会漏判**（库文件可能尚未生成）。

命中 → 问用户是否要让 Claude 直接查库：

- 同意 → 创建 `.mcp.json`，**路径优先写相对路径**（如 `uvx mcp-server-sqlite --db-path database/xx.db`），相对路径版可直接提交 git；只有含绝对路径或敏感信息时才需要 .gitignore 或占位路径。提示副作用：db 文件尚不存在时，sqlite MCP 首次连接会自动创建空库。
- 拒绝 / 无数据库 → 不创建空文件。

## 第 6 步：三项自检

1. **git 纳管**：`git status --short` 里 CLAUDE.md、`.claude/`、`.mcp.json`（若创建）出现为未跟踪 `??` **或**已跟踪被修改 ` M`——两者都算通过（增量场景文件本来就是已跟踪的）；再用 `git check-ignore <文件>` 确认没被 .gitignore 误伤。备份产生的 `.bak-*` 文件会出现在列表里，提醒用户删除或提交。本 skill 不自动 commit，提醒用户自行做 checkpoint commit。
2. **danger-guard 拦截测试**：**只用管道喂合成输入，绝不真实执行危险命令**。测三个代表模式 + 一个安全命令，核对 exit code 和 stderr 拦截文案都在：

   ```bash
   echo '{"tool_input":{"command":"rm -rf /tmp/x"}}'           | .claude/hooks/danger-guard.sh; echo "exit=$?"  # 期望 2
   echo '{"tool_input":{"command":"sqlite3 db DROP TABLE t"}}' | .claude/hooks/danger-guard.sh; echo "exit=$?"  # 期望 2
   echo '{"tool_input":{"command":"systemctl stop nginx"}}'    | .claude/hooks/danger-guard.sh; echo "exit=$?"  # 期望 2
   echo '{"tool_input":{"command":"ls"}}'                      | .claude/hooks/danger-guard.sh; echo "exit=$?"  # 期望 0
   ```

   注意：测试命令字符串本身含 "rm -rf" 等字样——若当前会话外层也挂了拦截 hook 而误拦这条 echo，恰说明防线在工作；向用户说明后临时放行或拆分字符串再测。
3. **占位符清查**：`grep -n "【" CLAUDE.md` 应无输出。（"待补"豁免项按第 4 步要求不带括号，不会干扰本检查。）

## 第 7 步：输出交付摘要

汇总表格：拷贝/合并结果、占位符状态（已定稿/待补）、MCP 配置、三项自检逐项结论、备份文件处置建议。结尾三句提醒：

1. 记得 commit 一个 checkpoint（家规：改码可回退）。
2. 日常开发按装备手册（插件 README.md）第 3 节六阶段表使用工具。
3. 碰 6 条高危触发器（认证/库结构/生产发布/不可逆批量/密钥凭据/架构重构）必须升级重型多代理流。
