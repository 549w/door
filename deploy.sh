#!/bin/bash

# GitHub 仓库 URL - 请替换为你的 GitHub 用户名
GITHUB_USERNAME="your-username"
REPO_NAME="door"

echo "=== 对门微电影主页部署脚本 ==="
echo ""
echo "请按照以下步骤操作："
echo ""
echo "1. 在 GitHub 上创建私有仓库:"
echo "   - 访问 https://github.com/new"
echo "   - Repository name: $REPO_NAME"
echo "   - 勾选 Private"
echo "   - 不要初始化 README、.gitignore 或 license"
echo "   - 点击 Create repository"
echo ""
echo "2. 将本地仓库关联到 GitHub:"
echo ""

# 添加远程仓库
git remote add origin git@github.com:$GITHUB_USERNAME/$REPO_NAME.git 2>/dev/null || {
    echo "远程仓库已存在，更新 URL..."
    git remote set-url origin git@github.com:$GITHUB_USERNAME/$REPO_NAME.git
}

echo "3. 推送到 GitHub:"
echo ""
git push -u origin main

echo ""
echo "=== 推送完成！==="
echo ""
echo "接下来需要在服务器上配置自动拉取。"
echo "请运行: ssh tencent-server 'bash -s' < setup-server.sh"
