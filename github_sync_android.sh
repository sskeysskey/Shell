#!/bin/bash

# 1. 进入目录
cd /Users/yanzhang/Coding/AndroidStudioProjects || exit

# 2. 处理 Rebase 状态
if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then
    git rebase --abort
fi

# 3. 先进子模块提交变更（不要用 git submodule update）
if [ -f .gitmodules ]; then
    git submodule foreach '
        git add . 
        git commit -m "Auto commit submodule at $(date "+%Y-%m-%d %H:%M:%S")" || true
        git push || true
    '
fi

# 4. 回到父仓库，添加变更（包括子模块的新 commit 引用）
git add .

# 5. 检查是否有变更
if git diff-index --quiet HEAD --; then
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