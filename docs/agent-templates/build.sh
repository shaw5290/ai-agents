#!/usr/bin/env bash
# 用法：build.sh <项目名> [输出目录]
# 读取 projects/<项目名>/modules.txt，拼装生成 AGENTS.md 和 CLAUDE.md。
# 输出目录默认为模板库所在仓库的根目录。
set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"
project="${1:?用法：build.sh <项目名> [输出目录]}"
out="${2:-$root/../..}"
list="$root/projects/$project/modules.txt"
[[ -f "$list" ]] || { echo "找不到模块清单：$list" >&2; exit 1; }

# $1 文件标题，$2 是否包含 Claude 专属模块（yes/no）
assemble() {
  echo "# $1"
  while read -r m || [[ -n "$m" ]]; do
    [[ -z "$m" || "$m" == \#* ]] && continue
    if [[ "$2" == no && ( "$m" == claude/* || "${m##*/}" == claude-* ) ]]; then
      continue
    fi
    echo
    cat "$root/$m.md"
  done < "$list"
}

assemble AGENTS.md no > "$out/AGENTS.md"
assemble CLAUDE.md yes > "$out/CLAUDE.md"
echo "已生成：$(cd "$out" && pwd)/AGENTS.md、CLAUDE.md"
