#!/bin/bash

# 1. 进入目录
cd /Users/yanzhang/Coding/AndroidStudioProjects || exit

# 2. 处理 Rebase 状态
if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then
    git rebase --abort
fi

# 3. 遍历所有子仓库（包括子模块和普通嵌套仓库）并提交变更
echo "Checking sub-repositories..."
find . -mindepth 2 -name ".git" -type d | while read -r gitdir; do
    repo_dir=$(dirname "$gitdir")
    echo "Entering $repo_dir"
    (
        cd "$repo_dir" || exit
        git add .
        # 如果有变更则提交
        if ! git diff --cached --quiet; then
            git commit -m "Auto commit sub-repo at $(date "+%Y-%m-%d %H:%M:%S")"
            git push || true
        fi
    )
done

# 4. 回到父仓库，添加变更（包括子仓库的新 commit 引用）
git add .

# 5. 检查暂存区是否有变更 (使用 --cached 只检查已 add 的内容)
if git diff --cached --quiet; then
    echo "No changes to commit."
else
    current_time=$(date "+%Y-%m-%d %H:%M:%S")
    git commit -m "Auto commit at $current_time"
    
    if [ $? -eq 0 ]; then
        git push origin main
        if [ $? -eq 0 ]; then
            echo "Successfully synced to GitHub at $current_time"
        else
            echo "Error occurred while pushing to GitHub"
        fi
    else
        echo "Error occurred while committing to GitHub"
    fi
fi