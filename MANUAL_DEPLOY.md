# 手动部署指南

## 在服务器上克隆仓库

```bash
ssh tencent-server
rm -rf /var/www/door.imjhy.com
git clone https://github.com/549w/door.git /var/www/door.imjhy.com
```

## 更新网站（当你在本地推送新代码后）

```bash
ssh tencent-server
cd /var/www/door.imjhy.com
git pull origin main
```

网页会立即更新，访问 https://door.imjhy.com 即可看到最新内容。

## 本地工作流程

1. 修改 `door` 目录下的文件
2. 提交并推送到 GitHub：
   ```bash
   cd door
   git add .
   git commit -m "更新说明"
   git push
   ```
3. 登录服务器拉取更新：
   ```bash
   ssh tencent-server "cd /var/www/door.imjhy.com && git pull origin main"
   ```

就这么简单！
