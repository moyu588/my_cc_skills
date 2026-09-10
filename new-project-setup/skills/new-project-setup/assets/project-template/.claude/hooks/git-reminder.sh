#!/usr/bin/env bash
# git-reminder.sh —— 每个会话提醒一次 git 工作区状态
#
# 挂在 UserPromptSubmit：会话的第一条用户消息时检查 git 工作区，
# stdout 内容会被追加进 Claude 的上下文（exit 0 不拦截任何操作）。
# 对应家规："修改代码前必须 git status——工作区不干净先 commit checkpoint 再开发"。
# 用 /tmp 标记文件保证每个会话只提醒一次，不刷屏。

input=$(cat)

sid=$(printf '%s' "$input" | python3 -c \
  "import sys,json
try:
    print(json.load(sys.stdin).get('session_id','default'))
except Exception:
    print('default')" 2>/dev/null)

marker="/tmp/claude-git-reminder-${sid}"
[ -f "$marker" ] && exit 0
touch "$marker" 2>/dev/null

# 不在 git 仓库里就不提醒
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  echo "⚠️ 家规提醒：当前 git 工作区不干净（有未提交改动）。按工作流规则：修改代码前先确认这些改动是否需要 commit 一个 checkpoint，保证随时可 git reset --hard 干净回退。"
else
  echo "✅ git 工作区干净，符合'改码前检查点'家规，可直接开发。"
fi
exit 0
