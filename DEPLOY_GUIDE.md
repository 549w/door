# 快速部署指南

## 第一步：在 GitHub 创建私有仓库

1. 访问 https://github.com/new
2. Repository name: `door`
3. 勾选 **Private**
4. **不要**勾选 Add README、.gitignore 或 license
5. 点击 **Create repository**

## 第二步：推送本地代码到 GitHub

```bash
cd /Users/jianghongyu/Projects/imjhy/door
git remote add origin git@github.com:YOUR_GITHUB_USERNAME/door.git
git push -u origin main
```

> 将 `YOUR_GITHUB_USERNAME` 替换为你的 GitHub 用户名

## 第三步：配置服务器 SSH Key（如果还没有）

在服务器上运行：
```bash
ssh tencent-server
ssh-keygen -t rsa -b 4096 -C "deploy@imjhy.com"
cat ~/.ssh/id_rsa.pub
```

将输出的公钥内容添加到：
- GitHub → Settings → SSH and GPG keys → New SSH key

## 第四步：在服务器上配置 Git 拉取

```bash
ssh tencent-server
cd /var/www/door.imjhy.com
git init
git remote add origin git@github.com:YOUR_GITHUB_USERNAME/door.git
git pull origin main
chown -R www-data:www-data . 2>/dev/null || chown -R root:root .
systemctl restart nginx
```

## 第五步：设置自动更新（可选）

### 方案 A：使用定时任务（简单）

```bash
ssh tencent-server
crontab -e
```

添加以下行（每小时检查一次更新）：
```
0 * * * * cd /var/www/door.imjhy.com && git pull origin main && systemctl reload nginx
```

### 方案 B：使用 GitHub Actions（推荐）

1. 获取服务器 SSH 私钥：
   ```bash
   cat ~/.ssh/id_rsa
   ```

2. 在 GitHub 仓库添加 Secrets：
   - 进入 Settings → Secrets and variables → Actions → New repository secret
   - 添加 `SSH_PRIVATE_KEY`：粘贴上面的私钥内容
   - 添加 `SERVER_HOST`：`43.142.69.28`

3. 之后每次 `git push` 都会自动部署

## 验证部署

访问：https://door.imjhy.com

## 后续更新

```bash
# 修改文件后
cd door
git add .
git commit -m "更新说明"
git push

# 如果使用定时任务，等待自动更新
# 如果手动更新：
ssh tencent-server "cd /var/www/door.imjhy.com && git pull"
```
