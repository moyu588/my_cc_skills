# install.ps1 — 将 token-audit 注册为 Claude Code Skill（自包含安装）
#
# 用法:
#   cd your-project
#   powershell -ExecutionPolicy Bypass -File path\to\token-audit\install.ps1
#
#   # 或指定项目根目录
#   powershell -ExecutionPolicy Bypass -File path\to\token-audit\install.ps1 -ProjectRoot C:\path\to\project
#
# 前置条件:
#   Node.js ≥ 18，项目使用 Claude Code + OpenWolf
#
# 安装后 token-audit\ 源目录可安全删除，运行时文件已全部复制到 .claude\skills\token-audit\

param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path (Join-Path $ScriptDir "token-audit.mjs"))) {
    Write-Host "❌ 错误: 找不到 token-audit.mjs，请从 token-audit 项目目录运行此脚本"
    exit 1
}

$SkillDir = Join-Path $ProjectRoot ".claude\skills\token-audit"

# 检查是否已在技能目录中运行
if ($ScriptDir -eq $SkillDir) {
    Write-Host "⚠️  已在 .claude\skills\token-audit\ 中，跳过安装"
    exit 0
}

New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $SkillDir "snapshots") | Out-Null

# 检查是否已安装
$SkillMdDest = Join-Path $SkillDir "SKILL.md"
if (Test-Path $SkillMdDest) {
    Write-Host "⚠️  token-audit Skill 已安装于 $SkillDir"
    $answer = Read-Host "   覆盖? (y/n)"
    if ($answer -ne "y" -and $answer -ne "Y") {
        Write-Host "   已取消。"
        exit 0
    }
}

# 复制运行时文件到技能目录
Copy-Item -Path (Join-Path $ScriptDir "token-audit.mjs") -Destination (Join-Path $SkillDir "token-audit.mjs") -Force
Copy-Item -Path (Join-Path $ScriptDir "SKILL.md") -Destination $SkillMdDest -Force
Copy-Item -Path (Join-Path $ScriptDir "profiles") -Destination $SkillDir -Recurse -Force

# 确保 snapshots/.gitkeep 存在
$Gitkeep = Join-Path $SkillDir "snapshots\.gitkeep"
if (-not (Test-Path $Gitkeep)) {
    New-Item -ItemType File -Path $Gitkeep -Force | Out-Null
}

Write-Host ""
Write-Host "✅ token-audit Skill 已安装"
Write-Host ""
Write-Host "   安装位置: $SkillDir"
Write-Host "   ├── SKILL.md"
Write-Host "   ├── token-audit.mjs"
Write-Host "   ├── profiles\"
Write-Host "   └── snapshots\"
Write-Host ""
Write-Host "   token-audit\ 源目录现在可以安全删除。"
Write-Host ""
Write-Host "   在 Claude Code 中说:"
Write-Host '     "扫一眼 token"'
Write-Host '     "帮我分析 token 浪费"'
Write-Host ""
Write-Host "   或命令行:"
Write-Host "     node $(Join-Path $SkillDir 'token-audit.mjs') $ProjectRoot --quick"
