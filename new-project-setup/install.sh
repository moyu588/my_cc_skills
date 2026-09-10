#!/usr/bin/env bash
# install.sh —— 免插件系统的兜底安装方式
#
# 推荐方式（命令安装，支持 update）：
#   claude plugin marketplace add moyu588/my_cc_skills
#   claude plugin install new-project-setup@my_cc_skills
#
# 本脚本适合不方便用插件系统的场景：把 skill 目录原样拷到 ~/.claude/skills/。
# 用法：git clone 本仓库后执行 bash new-project-setup/install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.claude/skills/new-project-setup"

mkdir -p "$DEST"
cp -r "$SCRIPT_DIR/skills/new-project-setup/." "$DEST/"
cp "$SCRIPT_DIR/README.md" "$DEST/README.md"   # 手册随 skill 同目录存放
chmod +x "$DEST/assets/project-template/.claude/hooks/"*.sh

echo "✅ 已安装到 $DEST"
echo "   模板位置：$DEST/assets/project-template/"
echo "   手册位置：$DEST/README.md"
echo "   用法：在任意项目目录里对 Claude 说 /new-project-setup 或\"帮我初始化项目装备\""
