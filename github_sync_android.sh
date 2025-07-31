cd /Users/yanzhang/Coding/AndroidStudioProjects

if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then
  git rebase --abort
fi

current_time=$(date "+%Y-%m-%d %H:%M:%S")

git add .
git commit -m "Auto commit at $current_time"
git push origin main

# 输出结果
if [ $? -eq 0 ]; then
    echo "Successfully synced to GitHub at $current_time"
else
    echo "Error occurred while syncing to GitHub"
fi