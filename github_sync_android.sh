#!/bin/bash

# 1. 进入目录
cd /Users/yanzhang/Coding/AndroidStudioProjects || exit

# 2. 处理 Rebase 状态
if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then
    git rebase --abort
fi

# 3. 如果有子模块，先更新子模块
# 如果 ONews 是子模块，这一步很重要
if [ -f .gitmodules ]; then
    git submodule update --init --recursive
    git submodule foreach git add .
    git submodule foreach git commit -m "Auto commit submodule" || true
fi

# 4. 添加变更
git add .

# 5. 检查是否有变更，避免 commit 失败
# git diff-index --quiet HEAD 检查是否有未提交的变更
if git diff-index --quiet HEAD --; then
    echo "No changes to commit."
else
    current_time=$(date "+%Y-%m-%d %H:%M:%S")
    git commit -m "Auto commit at $current_time"
    
    # 6. 只有 commit 成功才 push
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