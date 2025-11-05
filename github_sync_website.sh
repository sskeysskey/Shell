#!/bin/bash

# 设置工作目录
cd /Users/yanzhang/Coding/Website

# 如果有 rebase 在进行，就 abort 掉
if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then
  git rebase --abort
fi

# 获取当前时间作为commit信息
current_time=$(date "+%Y-%m-%d %H:%M:%S")

# 执行git操作
git add .
git commit -m "Auto commit at $current_time"
git push origin main

# 输出结果
if [ $? -eq 0 ]; then
    echo "Successfully synced to GitHub at $current_time"
else
    echo "Error occurred while syncing to GitHub"
fi
