#!/usr/bin/env bash
# danger-guard.sh —— 安全兜底（第 0 条铁律的机器防线）
#
# 挂在 PreToolUse(Bash)：Claude 每次要执行 shell 命令前，本脚本先检查命令内容。
# 命中高危模式 → exit 2 拦截，stderr 内容会反馈给 Claude 让它换方案或找用户授权。
# 模式清单可按项目增删；修改后无需重启（每次调用都重新读取）。
#
# 注意：这是"兜底"不是"全保"——正则拦不住所有危险操作，家规（CLAUDE.md）仍是第一防线。

input=$(cat)

# 从 stdin 的 hook JSON 里提取 Claude 要执行的命令
cmd=$(printf '%s' "$input" | python3 -c \
  "import sys,json
try:
    print(json.load(sys.stdin).get('tool_input',{}).get('command',''))
except Exception:
    print('')" 2>/dev/null)

[ -z "$cmd" ] && exit 0

# 高危模式清单（扩展正则，忽略大小写）
patterns=(
  'rm[[:space:]]+-[a-z]*r[a-z]*f|rm[[:space:]]+-[a-z]*f[a-z]*r'          # rm -rf / rm -fr（任何路径都拦，白名单自行放行）
  'mkfs'                                                                    # 格式化磁盘
  'dd[[:space:]].*of=/dev/'                                                 # 裸写块设备
  '(DROP|TRUNCATE)[[:space:]]+(TABLE|DATABASE)'                            # 删表/删库
  'git[[:space:]]+push[[:space:]].*(--force(-with-lease)?|[[:space:]]-f)'   # 强推
  'git[[:space:]]+reset[[:space:]]+--hard'                                 # 硬重置丢改动
  'git[[:space:]]+clean[[:space:]]+-[a-z]*f'                               # 强制清理未跟踪文件
  '(shutdown|reboot|poweroff|halt)[[:space:]]*'                            # 关机重启
  'systemctl[[:space:]]+(stop|disable|mask)[[:space:]]'                     # 停服务（防连带杀进程事故）
  '>[[:space:]]*/dev/(sd|nvme|vd)'                                         # 重定向写裸盘
  'chmod[[:space:]]+-R[[:space:]]+777'                                     # 递归放开权限
  'kill(all)?[[:space:]]+-9?[[:space:]]*-1\b'                              # kill -1 / killall 全杀
)

for p in "${patterns[@]}"; do
  if printf '%s' "$cmd" | grep -qiE "$p"; then
    {
      echo "🛑 danger-guard 拦截了高危命令（命中模式: $p）"
      echo "第 0 条铁律：生产环境与数据的安全稳定优先于进度和功能。"
      echo "如确需执行：① 先向用户说明该命令的目的、影响范围、是否触碰生产；"
      echo "② 由用户明确授权后人工执行，或改用更安全的替代方案（如 rm 指定具体文件而非 -rf 目录、先备份再改库）。"
    } >&2
    exit 2
  fi
done

exit 0
