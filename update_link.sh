
#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# Configuration
# ==========================================

DEFAULT_FRAMEWORK="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P
)"

FRAMEWORK="${FRAMEWORK:-$DEFAULT_FRAMEWORK}"

if [[ $# -ne 1 ]]; then
    echo "Usage: bash update_link.sh <PROJECT_PATH>"
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

FRAMEWORK="$(cd -- "$FRAMEWORK" && pwd -P)"
PROJECT="$(cd -- "$PROJECT" && pwd -P)"

if ! git -C "$FRAMEWORK" rev-parse \
    --is-inside-work-tree 2>/dev/null | grep -qx true; then
    echo "[ERROR] Framework is not a Git repository."
    exit 1
fi

# 確認 Framework 是 Repository 根目錄
REPO_ROOT="$(git -C "$FRAMEWORK" rev-parse --show-toplevel)"

if [[ "$(cd "$REPO_ROOT" && pwd -P)" != "$FRAMEWORK" ]]; then
    echo "[ERROR] FRAMEWORK must point to the Git repository root."
    exit 1
fi

# ==========================================
# Update Framework Repository
# ==========================================

echo "[INFO] Updating Framework..."

# 避免覆寫未提交的修改
if [[ -n "$(git -C "$FRAMEWORK" status --porcelain)" ]]; then
    echo "[ERROR] Framework has uncommitted changes."
    echo "Please commit or stash changes first."
    exit 1
fi

# 避免在 detached HEAD 狀態下更新
if ! git -C "$FRAMEWORK" symbolic-ref \
    --quiet --short HEAD >/dev/null; then
    echo "[ERROR] Framework is in detached HEAD state."
    exit 1
fi

# 僅允許 Fast-forward 更新
if ! git -C "$FRAMEWORK" pull --ff-only; then
    echo "[ERROR] Git pull failed."
    echo "Project links were not modified."
    exit 1
fi

echo "[SUCCESS] Framework updated."
git -C "$FRAMEWORK" log -1 --format="Commit: %h - %s"

# ==========================================
# Validate Framework Sources
# ==========================================

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
# Create Project Directories
# ==========================================

mkdir -p "$PROJECT/.agents"
mkdir -p "$PROJECT/instructions"

# ==========================================
# Update Symbolic Links
# ==========================================

update_link() {
    local source="$1"
    local target="$2"

    # 如果已經是 Symbolic Link
    if [[ -L "$target" ]]; then
        local current_target
        current_target="$(readlink "$target")"

        # 判斷現有連結是否指向正確來源
        if [[ "$current_target" == "$source" ]]; then
            echo "[SKIP] Link already correct: $target"
            return 0
        fi

        echo "[UPDATE] Incorrect link: $target"
        echo "         Old: $current_target"
        echo "         New: $source"

        # 只移除 Symbolic Link，不刪除來源
        rm -- "$target"
    elif [[ -e "$target" ]]; then
        # 若為實際檔案或資料夾，避免覆寫
        echo "[WARNING] Existing non-link path: $target"
        echo "          Skipped to prevent data loss."
        return 0
    fi

    ln -s "$source" "$target"
    echo "[LINK] $target -> $source"
}

update_link \
    "$FRAMEWORK/.agents/agents" \
    "$PROJECT/.agents/agents"

update_link \
    "$FRAMEWORK/.agents/skills" \
    "$PROJECT/.agents/skills"

update_link \
    "$FRAMEWORK/instructions" \
    "$PROJECT/instructions/shared"

update_link \
    "$FRAMEWORK/AGENTS.md" \
    "$PROJECT/AGENTS.md"


# ==========================================
# Update .gitignore
# ==========================================

GITIGNORE="$PROJECT/.gitignore"

if [[ ! -e "$GITIGNORE" ]]; then
    touch "$GITIGNORE"
    echo "[CREATE] .gitignore"
elif [[ ! -f "$GITIGNORE" ]]; then
    echo "[ERROR] .gitignore is not a regular file."
    exit 1
fi

IGNORE_PATHS=(
    "/.agents/agents"
    "/.agents/skills"
    "/instructions/shared"
    "/AGENTS.md"
)

add_gitignore() {
    local pattern="$1"

    # 精確比對，避免重複新增
    if grep -Fxq -- "$pattern" "$GITIGNORE"; then
        echo "[SKIP] Already ignored: $pattern"
        return 0
    fi

    # 如果最後一行沒有換行，先補換行
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

# ==========================================
# Completed
# ==========================================

echo
echo "[SUCCESS] Framework update and link synchronization completed."
echo "Framework: $FRAMEWORK"
echo "Project:   $PROJECT"
