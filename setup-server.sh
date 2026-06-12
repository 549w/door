#!/bin/bash

# 服务器端自动部署配置脚本
REPO_NAME="door"
DEPLOY_DIR="/var/www/door.imjhy.com"
GITHUB_USERNAME="your-username"

echo "=== 配置服务器自动从 GitHub 拉取代码 ==="
echo ""

# 1. 检查并安装 git
if ! command -v git &> /dev/null; then
    echo "安装 Git..."
    apt update && apt install -y git
fi

# 2. 配置 Git（如果需要）
git config --global user.email "deploy@imjhy.com" 2>/dev/null
git config --global user.name "Deploy Bot" 2>/dev/null

# 3. 检查 SSH key 是否存在
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "生成 SSH key..."
    ssh-keygen -t rsa -b 4096 -C "deploy@imjhy.com" -f ~/.ssh/id_rsa -N ""
    echo ""
    echo "SSH Key 已生成，请将以下公钥添加到 GitHub:"
    echo ""
    cat ~/.ssh/id_rsa.pub
    echo ""
    echo "访问: https://github.com/settings/keys"
    echo "按回车继续..."
    read
fi

# 4. 克隆或更新仓库
if [ -d "$DEPLOY_DIR/.git" ]; then
    echo "仓库已存在，更新代码..."
    cd $DEPLOY_DIR
    git pull origin main
else
    echo "克隆仓库到 $DEPLOY_DIR..."
    # 备份现有文件
    if [ -d "$DEPLOY_DIR" ]; then
        mv $DEPLOY_DIR ${DEPLOY_DIR}.bak
    fi
    
    git clone git@github.com:$GITHUB_USERNAME/$REPO_NAME.git $DEPLOY_DIR
    cd $DEPLOY_DIR
fi

# 5. 设置正确的权限
chown -R www-data:www-data $DEPLOY_DIR 2>/dev/null || chown -R root:root $DEPLOY_DIR
chmod -R 755 $DEPLOY_DIR

# 6. 重启 Nginx
systemctl restart nginx

echo ""
echo "=== 部署完成！==="
echo ""
echo "创建自动更新脚本..."

# 7. 创建自动更新脚本
cat > /usr/local/bin/update-door-website.sh << 'EOF'
#!/bin/bash
cd /var/www/door.imjhy.com
git pull origin main
systemctl reload nginx
echo "网站已更新 - $(date)" >> /var/log/door-website-update.log
EOF

chmod +x /usr/local/bin/update-door-website.sh

# 8. 设置定时任务（每小时检查一次更新）
(crontab -l 2>/dev/null | grep -v "update-door-website"; echo "0 * * * * /usr/local/bin/update-door-website.sh") | crontab -

echo ""
echo "已配置每小时自动检查更新。"
echo "手动更新命令: /usr/local/bin/update-door-website.sh"
echo ""
echo "测试访问: https://door.imjhy.com"
