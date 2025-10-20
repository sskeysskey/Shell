#!/bin/bash

# --- Shell 脚本，用于将本地 LocalServer 目录同步到云服务器并重启服务 ---

# 设置颜色变量，用于美化输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== 1. 开始同步 LocalServer 目录到云服务器 ===${NC}"

# rsync 命令 (请确保这里的路径和服务器地址正确)
rsync -avz --delete --progress /Users/yanzhang/Coding/LocalServer/ root@106.15.183.158:/root/LocalServer/

# 检查 rsync 命令是否成功执行
if [ $? -ne 0 ]; then
    echo -e "${RED}!!! 同步失败，请检查错误信息。脚本已终止。 !!!${NC}"
    exit 1
fi

echo -e "${GREEN}=== 同步成功！ ===${NC}"
echo -e "${YELLOW}=== 2. 准备在服务器上重启 AppServer 服务 ===${NC}"

# 使用 systemd 的标准重启命令
RESTART_COMMAND="sudo systemctl restart appserver.service"

# --- 执行远程命令 ---
echo "正在远程执行: ssh root@106.15.183.158 \"${RESTART_COMMAND}\""
ssh root@106.15.183.158 "${RESTART_COMMAND}"

# 检查远程命令是否成功
if [ $? -eq 0 ]; then
    echo -e "${GREEN}=== 服务重启命令已成功发送！ ==="
    echo -e "${YELLOW}请稍等片刻让服务启动...${NC}"
    sleep 5 # 等待几秒钟给服务启动时间
    echo -e "${YELLOW}正在获取最新的服务状态...${NC}"
    # 远程检查服务状态，确认是否成功启动
    ssh root@106.15.183.158 "sudo systemctl status appserver.service"
else
    echo -e "${RED}!!! 服务重启失败！请登录服务器手动检查。 !!!${NC}"
fi

echo -e "${GREEN}=== 全部任务完成 ===${NC}"