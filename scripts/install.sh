#!/usr/bin/env bash
# 用法：install.sh [目标目录]
# 把 skills/<分类>/<名>/ 展平软链到目标目录（默认 ~/.agents/skills）下的 <名>/，供各 AI 工具识别。
set -euo pipefail

root="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
target="${1:-$HOME/.agents/skills}"
mkdir -p "$target"

declare -A seen
for f in "$root"/skills/*/*/SKILL.md; do
  dir="$(dirname "$f")"
  name="${dir##*/}"
  if [[ -n "${seen[$name]:-}" ]]; then
    echo "skill 重名：${seen[$name]} 与 $dir" >&2
    exit 1
  fi
  seen[$name]="$dir"
done

for name in "${!seen[@]}"; do
  link="$target/$name"
  if [[ -e "$link" || -L "$link" ]]; then
    if [[ "$(readlink -f "$link")" == "${seen[$name]}" ]]; then
      continue
    fi
    echo "已存在，跳过：$link" >&2
    continue
  fi
  ln -s "${seen[$name]}" "$link"
  echo "已安装：$name"
done
