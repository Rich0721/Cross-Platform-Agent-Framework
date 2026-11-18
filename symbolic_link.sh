
#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# Configuration
# ==========================================

# 預設 Framework 為此腳本所在目錄
# 每位使用者 Clone 後不需要修改絕對路徑
DEFAULT_FRAMEWORK="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P
)"

FRAMEWORK="${FRAMEWORK:-$DEFAULT_FRAMEWORK}"

# 只需要輸入 Project 路徑
if [[ $# -ne 1 ]]; then
    echo "Usage: bash symbolic_link.sh <PROJECT_PATH>"
    exit 1
fi

PROJECT="$1"

# ==========================================
# Validate paths
# ==========================================

if [[ ! -d "$FRAMEWORK" ]]; then
    echo "[ERROR] Framework not found: $FRAMEWORK"
    exit 1
fi

if [[ ! -d "$PROJECT" ]]; then
    echo "[ERROR] Project not found: $PROJECT"
    exit 1
fi

# 轉換為絕對路徑，避免相對軟連結失效
FRAMEWORK="$(cd -- "$FRAMEWORK" && pwd -P)"
PROJECT="$(cd -- "$PROJECT" && pwd -P)"

# 檢查必要來源
for source in \
    "$FRAMEWORK/.agents/agents" \
    "$FRAMEWORK/.agents/skills" \
    "$FRAMEWORK/instructions" \
    "$FRAMEWORK/AGENTS.md"
do
    if [[ ! -e "$source" ]]; then
        echo "[ERROR] Source not found: $source"
        exit 1
    fi
done

# ==========================================
# Create directories
# ==========================================

mkdir -p "$PROJECT/.agents"
mkdir -p "$PROJECT/instructions"

# ==========================================
# Symbolic Links
# ==========================================

create_link() {
    local source="$1"
    local target="$2"

    if [[ -e "$target" || -L "$target" ]]; then
        echo "[SKIP] Already exists: $target"
        return 0
    fi

    ln -s "$source" "$target"
    echo "[LINK] $target -> $source"
}

create_link \
    "$FRAMEWORK/.agents/agents" \
    "$PROJECT/.agents/agents"

create_link \
    "$FRAMEWORK/.agents/skills" \
    "$PROJECT/.agents/skills"

create_link \
    "$FRAMEWORK/instructions" \
    "$PROJECT/instructions/shared"

create_link \
    "$FRAMEWORK/AGENTS.md" \
    "$PROJECT/AGENTS.md"

# ==========================================
# Project-specific Instructions
# ==========================================

touch "$PROJECT/instructions/common-instructions.md"
touch "$PROJECT/instructions/folder-structure.md"

# ==========================================
# Update .gitignore
# ==========================================

GITIGNORE="$PROJECT/.gitignore"

# 若不存在，自動建立
if [[ ! -f "$GITIGNORE" ]]; then
    touch "$GITIGNORE"
    echo "[CREATE] .gitignore"
fi

# 需要忽略的連結路徑
IGNORE_PATHS=(
    "/.agents/agents"
    "/.agents/skills"
    "/instructions/shared"
    "/AGENTS.md"
)

# 判斷是否已有完全相同的規則
add_gitignore() {
    local pattern="$1"

    if grep -Fxq -- "$pattern" "$GITIGNORE"; then
        echo "[SKIP] Already ignored: $pattern"
        return 0
    fi

    # 確保新增規則前有換行
    if [[ -s "$GITIGNORE" ]] &&
       [[ "$(tail -c 1 "$GITIGNORE" | wc -l)" -eq 0 ]]; then
        printf '\n' >> "$GITIGNORE"
    fi

    printf '%s\n' "$pattern" >> "$GITIGNORE"
    echo "[ADD] .gitignore: $pattern"
}

for pattern in "${IGNORE_PATHS[@]}"; do
    add_gitignore "$pattern"
done

echo
echo "[SUCCESS] Agent Framework setup completed."
echo "Framework: $FRAMEWORK"
echo "Project:   $PROJECT"
