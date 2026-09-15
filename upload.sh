#!/bin/bash
# 上传图片到 GitHub Pages 静态资源仓库
# 用法: ./upload.sh <文件路径> [文件路径2 ...]
#   或: ./upload.sh              (交互式输入路径)

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH=/opt/homebrew/bin:$PATH
# 走本地 clash 代理（直连 github 部分端点会超时）
export HTTPS_PROXY=http://127.0.0.1:7897
export HTTP_PROXY=http://127.0.0.1:7897

cd "$REPO_DIR"

if [ $# -eq 0 ]; then
  echo "请输入要上传的文件路径（可一次多个，空格分隔）:"
  read -r -a FILES
else
  FILES=("$@")
fi

if [ ${#FILES[@]} -eq 0 ]; then
  echo "❌ 没有指定文件"
  exit 1
fi

# 校验并复制
ADDED=()
for f in "${FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "❌ 文件不存在: $f"
    exit 1
  fi
  name=$(basename "$f")
  cp "$f" "assets/images/$name"
  ADDED+=("$name")
  echo "📄 $name  ($(du -h "$f" | cut -f1))"
done

# 更新 manifest.json（供 index.html 索引页读取）
python3 - "$REPO_DIR" "${ADDED[@]}" <<'PY'
import json, os, sys
repo = sys.argv[1]
new = sys.argv[2:]
mp = os.path.join(repo, 'assets/images/manifest.json')
try:
    cur = json.load(open(mp))
except Exception:
    cur = []
for n in new:
    if n not in cur and n != 'manifest.json':
        cur.append(n)
cur.sort()
json.dump(cur, open(mp, 'w'), ensure_ascii=False, indent=2)
print(f"📋 manifest.json: {len(cur)} 个文件")
PY

# 提交推送
git add -A
if git diff --cached --quiet; then
  echo "⚠️  没有变化，跳过提交"
else
  git commit -q -m "assets: add ${ADDED[*]}"
  git push -q
  echo "🚀 已推送"
fi

# 输出访问地址
echo ""
echo "==================== 访问地址 ===================="
for n in "${ADDED[@]}"; do
  url="https://dyl6170.github.io/assets/images/$n"
  echo "$url"
  echo "Markdown: ![$n]($url)"
done
echo "=================================================="
echo ""
echo "⏳ Pages 有 CDN 缓存，首次访问可能需等 1-3 分钟"
