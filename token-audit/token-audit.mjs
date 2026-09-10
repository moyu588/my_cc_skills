#!/usr/bin/env node
/**
 * token-audit.mjs — 通用 Token 浪费数据采集脚本
 *
 * 设计原则:
 *   1. 零依赖 (Node.js ≥18 内置模块)
 *   2. 纯数据采集，不做价值判断
 *   3. 跨平台 (Linux / Windows 10 / Windows 11)
 *   4. 输出 JSON → stdout，错误 → stderr
 *
 * 用法:
 *   node token-audit.mjs [项目根目录] [--quick]
 *   node token-audit.mjs /path/to/project > report.json
 *
 *   --quick  仅采集关键指标，跳过慢速扫描（适用于快速扫一眼）
 */

import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import { join, resolve, relative } from 'node:path';
import { platform } from 'node:os';

// ── 工具函数 ──────────────────────────────────────────────

/** 递归读取目录下所有文件（返回完整路径） */
function walkDir(dir, maxDepth = 8, _depth = 0) {
  if (_depth > maxDepth) return [];
  if (!existsSync(dir)) return [];
  const results = [];
  try {
    const entries = readdirSync(dir, { withFileTypes: true });
    for (const e of entries) {
      const full = join(dir, e.name);
      if (e.isDirectory() && !e.name.startsWith('.git') && e.name !== 'node_modules') {
        results.push(...walkDir(full, maxDepth, _depth + 1));
      } else if (e.isFile()) {
        results.push(full);
      }
    }
  } catch { /* permission denied — skip */ }
  return results;
}

/** 目录磁盘大小（字节） */
function dirSize(dir) {
  if (!existsSync(dir)) return 0;
  let total = 0;
  try {
    for (const f of walkDir(dir, 10)) {
      try { total += statSync(f).size; } catch { /* skip */ }
    }
  } catch { /* skip */ }
  return total;
}

/** 目录内文件数（去重，不含目录） */
function fileCount(dir) {
  if (!existsSync(dir)) return 0;
  return walkDir(dir, 10).length;
}

/** 文件年龄（天） */
function ageDays(filePath) {
  try {
    const mtime = statSync(filePath).mtimeMs;
    return (Date.now() - mtime) / (1000 * 60 * 60 * 24);
  } catch { return 0; }
}

/** 安全读取文本 */
function readText(filePath) {
  try { return readFileSync(filePath, 'utf-8'); } catch { return null; }
}

/** 检测项目场景提示（从目录名和文件名嗅探） */
function detectScenarioHints(root) {
  const hints = [];
  const topEntries = existsSync(root) ? readdirSync(root, { withFileTypes: true }) : [];
  const names = new Set(topEntries.map(e => e.name + (e.isDirectory() ? '/' : '')));
  const allNames = [...names];

  if (allNames.some(n => n.startsWith('wiki/'))) hints.push('llm-wiki');
  if (allNames.some(n => n === 'wiki/')) hints.push('llm-wiki');
  if (allNames.some(n => n === 'src/' || n === 'tests/' || n === 'lib/')) hints.push('code-dev');
  if (existsSync(join(root, 'package.json'))) hints.push('npm-project');
  if (existsSync(join(root, 'CLAUDE.md'))) hints.push('claude-code');
  if (existsSync(join(root, 'pyproject.toml')) || existsSync(join(root, 'setup.py'))) hints.push('python-project');
  if (allNames.some(n => n === 'raw/' || n === 'wiki/')) hints.push('llm-wiki');

  return [...new Set(hints)];
}

// ── 主采集函数 ──────────────────────────────────────────────

function collect(projectRoot, quickMode = false) {
  const root = resolve(projectRoot || '.');

  // ── 顶级目录分析 ──
  const topLevelDirs = [];
  if (!quickMode && existsSync(root)) {
    const entries = readdirSync(root, { withFileTypes: true });
    for (const e of entries) {
      if (!e.isDirectory()) continue;
      if (e.name.startsWith('.git') || e.name === 'node_modules') continue;
      const relPath = e.name + '/';
      const fullPath = join(root, e.name);
      topLevelDirs.push({
        path: relPath,
        on_disk: fileCount(fullPath)
      });
    }
  }

  // ── 会话文件分析 ──
  const sessionsDir = join(root, '.claudian', 'sessions');
  const sessionFiles = existsSync(sessionsDir)
    ? readdirSync(sessionsDir).filter(f => f.endsWith('.meta.json'))
    : [];
  const sessions = [];
  for (const f of sessionFiles) {
    const fp = join(sessionsDir, f);
    try {
      const s = statSync(fp);
      sessions.push({ file: f, size_bytes: s.size, age_days: Math.round(ageDays(fp) * 10) / 10, mtime: s.mtime.toISOString() });
    } catch { /* skip */ }
  }
  sessions.sort((a, b) => b.size_bytes - a.size_bytes);

  // 按月分组
  const byMonth = {};
  for (const s of sessions) {
    const month = s.mtime.slice(0, 7);
    byMonth[month] = (byMonth[month] || 0) + 1;
  }

  // ── CLAUDE.md 上下文开销估算 ──
  const claudeMdPath = join(root, 'CLAUDE.md');
  const claudeMdContent = readText(claudeMdPath);
  const claudeMdSize = claudeMdContent ? Buffer.byteLength(claudeMdContent, 'utf-8') : 0;

  // 估算每会话上下文开销（tokens ≈ bytes / 4 for prose）
  const claudeMdTokenEst = Math.round(claudeMdSize / 4);

  // ── 冲突文件检测 ──
  const conflictedFiles = [];
  if (!quickMode) {
    const searchDirs = ['.obsidian', '.claudian', '.claude'];
    for (const d of searchDirs) {
      const dp = join(root, d);
      if (!existsSync(dp)) continue;
      const allFiles = walkDir(dp, 5);
      for (const f of allFiles) {
        if (f.includes('Conflicted copy') || f.includes('conflicted copy')) {
          try {
            const s = statSync(f);
            conflictedFiles.push({ path: relative(root, f).replace(/\\/g, '/'), size_bytes: s.size });
          } catch { /* skip */ }
        }
      }
    }
  }

  // ── 返回结果 ──
  return {
    meta: {
      project_root: root,
      platform: platform(),
      timestamp: new Date().toISOString(),
      scenario_hints: detectScenarioHints(root),
      quick_mode: quickMode
    },
    claude_md: {
      exists: existsSync(claudeMdPath),
      size_bytes: claudeMdSize,
      est_tokens_per_session: claudeMdTokenEst
    },
    top_level_dirs: topLevelDirs,
    sessions: {
      dir: relative(root, sessionsDir).replace(/\\/g, '/'),
      exists: existsSync(sessionsDir),
      count: sessions.length,
      total_size_bytes: sessions.reduce((s, f) => s + f.size_bytes, 0),
      total_size_mb: Math.round(sessions.reduce((s, f) => s + f.size_bytes, 0) / (1024 * 1024) * 100) / 100,
      over_30days: sessions.filter(s => s.age_days > 30).length,
      largest_5: sessions.slice(0, 5).map(s => ({
        file: s.file,
        size_kb: Math.round(s.size_bytes / 1024),
        age_days: s.age_days
      })),
      by_month: byMonth,
      all: quickMode ? [] : sessions
    },
    conflicted_files: {
      count: conflictedFiles.length,
      files: conflictedFiles
    },
    token_breakdown: {
      claude_md_est_tokens_per_session: claudeMdTokenEst,
      total_est_tokens_per_session: claudeMdTokenEst
    }
  };
}

// ── CLI 入口 ──────────────────────────────────────────────

function main() {
  const args = process.argv.slice(2);
  const quickMode = args.includes('--quick');
  const projectRoot = args.filter(a => a !== '--quick')[0] || process.cwd();

  if (!existsSync(projectRoot)) {
    console.error(`Error: path not found: ${projectRoot}`);
    process.exit(1);
  }

  const result = collect(projectRoot, quickMode);
  console.log(JSON.stringify(result, null, 2));
}

main();
