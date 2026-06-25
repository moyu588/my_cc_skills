#!/usr/bin/env bash
# install.sh — 将 token-audit 注册为 Claude Code Skill（自包含安装）
#
# 用法:
#   cd your-project
#   bash path/to/token-audit/install.sh
#
#   # 或指定项目根目录
#   bash path/to/token-audit/install.sh /path/to/project
#
# 前置条件:
#   Node.js ≥ 18，项目使用 Claude Code + OpenWolf
#
# 安装后 token-audit/ 源目录可安全删除，运行时文件已全部复制到 .claude/skills/token-audit/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="${1:-$(pwd)}"

if [ ! -f "$SCRIPT_DIR/token-audit.mjs" ]; then
  echo "❌ 错误: 找不到 token-audit.mjs，请从 token-audit 项目目录运行此脚本"
  exit 1
fi

SKILL_DIR="$PROJECT_ROOT/.claude/skills/token-audit"

# 检查是否已在技能目录中运行（避免自我复制）
if [ "$SCRIPT_DIR" = "$SKILL_DIR" ]; then
  echo "⚠️  已在 .claude/skills/token-audit/ 中，跳过安装"
  exit 0
fi

mkdir -p "$SKILL_DIR"
mkdir -p "$SKILL_DIR/snapshots"

# 检查是否已安装
if [ -f "$SKILL_DIR/SKILL.md" ]; then
  echo "⚠️  token-audit Skill 已安装于 $SKILL_DIR"
  echo "   覆盖? (y/n)"
  read -r answer
  if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
    echo "   已取消。"
    exit 0
  fi
fi

# 复制运行时文件到技能目录
cp "$SCRIPT_DIR/token-audit.mjs" "$SKILL_DIR/token-audit.mjs"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
cp -r "$SCRIPT_DIR/profiles" "$SKILL_DIR/profiles"
if [ -f "$SKILL_DIR/snapshots/.gitkeep" ]; then
  : # 保留
else
  touch "$SKILL_DIR/snapshots/.gitkeep"
fi

echo ""
echo "✅ token-audit Skill 已安装"
echo ""
echo "   安装位置: $SKILL_DIR"
echo "   ├── SKILL.md"
echo "   ├── token-audit.mjs"
echo "   ├── profiles/"
echo "   └── snapshots/"
echo ""
echo "   token-audit/ 源目录现在可以安全删除。"
echo ""
echo "   在 Claude Code 中说:"
echo "     \"扫一眼 token\""
echo "     \"帮我分析 token 浪费\""
echo ""
echo "   或命令行:"
echo "     node $SKILL_DIR/token-audit.mjs $PROJECT_ROOT --quick"
