# 对门微电影主页

极简风格的微电影《对门》官方网站。

## 特性

- 纯黑背景设计
- SVG Logo 滚动缩小效果
- 图片画廊滚动展示
- HTTPS 加密访问
- GitHub 自动部署

## 本地开发

```bash
# 在 door 目录下
python3 -m http.server 8000
```

访问 `http://localhost:8000`

## 部署流程

### 首次部署

1. **创建 GitHub 仓库**
   - 访问 https://github.com/new
   - 仓库名: `door`
   - 勾选 Private
   - 不要初始化任何文件

2. **推送代码到 GitHub**
   ```bash
   cd door
   git remote add origin git@github.com:YOUR_USERNAME/door.git
   git push -u origin main
   ```

3. **配置服务器 SSH Key**
   ```bash
   # 在服务器上运行
   ssh-keygen -t rsa -b 4096
   # 将 ~/.ssh/id_rsa.pub 内容添加到 GitHub Deploy Keys
   ```

4. **在服务器上克隆仓库**
   ```bash
   ssh tencent-server
   cd /var/www/door.imjhy.com
   git init
   git remote add origin git@github.com:YOUR_USERNAME/door.git
   git pull origin main
   ```

### 使用 GitHub Actions 自动部署（推荐）

1. **添加 Secrets 到 GitHub 仓库**
   - 进入仓库 Settings → Secrets and variables → Actions
   - 添加以下 secrets:
     - `SSH_PRIVATE_KEY`: 服务器的 SSH 私钥内容
     - `SERVER_HOST`: 服务器 IP 地址 (43.142.69.28)

2. **获取 SSH 私钥**
   ```bash
   cat ~/.ssh/id_rsa
   ```

3. **每次推送到 main 分支会自动部署**

### 手动更新

```bash
# 本地修改后
git add .
git commit -m "更新说明"
git push

# 或在服务器上手动拉取
ssh tencent-server "cd /var/www/door.imjhy.com && git pull origin main"
```

## 访问地址

- HTTPS: https://door.imjhy.com
- HTTP: http://door.imjhy.com (自动重定向到 HTTPS)

## 技术栈

- HTML5 + CSS3 + JavaScript
- Nginx Web Server
- Let's Encrypt SSL
- Git 版本控制
