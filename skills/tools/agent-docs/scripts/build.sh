#!/usr/bin/env bash
# 用法：build.sh <项目目录> [输出目录]
# 读取 <项目目录>/.agents/agent-docs/modules.txt，拼装生成 AGENTS.md 和 CLAUDE.md。
# 输出目录默认为项目目录。
set -euo pipefail

skills="$(cd "$(dirname "$(readlink -f "$0")")/../../.." && pwd)"
project="$(cd "${1:?用法：build.sh <项目目录> [输出目录]}" && pwd)"
out="${2:-$project}"
conf="$project/.agents/agent-docs"
list="$conf/modules.txt"
[[ -f "$list" ]] || { echo "找不到模块清单：$list" >&2; exit 1; }

# 输出模块正文：以 .md 结尾的读项目配置目录，其余读 skills/<分类>/<名>/SKILL.md 并去掉 frontmatter
emit() {
  if [[ "$1" == *.md ]]; then
    tr -d '\r' < "$conf/$1"
  else
    local f="$skills/$1/SKILL.md"
    [[ -f "$f" ]] || { echo "找不到 skill：$f" >&2; exit 1; }
    tr -d '\r' < "$f" | awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; skip=1; next} fm {next} skip && /^$/ {skip=0; next} {skip=0; print}'
  fi
}

# $1 文件标题，$2 是否包含 Claude 专属模块（yes/no）
assemble() {
  echo "# $1"
  while read -r m || [[ -n "$m" ]]; do
    m="${m%$'\r'}"
    [[ -z "$m" || "$m" == \#* ]] && continue
    if [[ "$2" == no && ( "$m" == claude/* || "${m##*/}" == claude-* ) ]]; then
      continue
    fi
    echo
    emit "$m"
  done < "$list"
}

mkdir -p "$out"
assemble AGENTS.md no > "$out/AGENTS.md"
assemble CLAUDE.md yes > "$out/CLAUDE.md"
echo "已生成：$(cd "$out" && pwd)/AGENTS.md、CLAUDE.md"
