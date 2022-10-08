#!/usr/bin/env sh
# 确保脚本抛出遇到的错误
set -e
# 生成静态文件
npm run build
# 进入生成的文件夹
cd docs/.vuepress/dist

# deploy to github
echo 'fastcv.cc' >CNAME
if [ -z "$GITHUB_TOKEN" ]; then
  msg='deploy'
  githubUrl=git@github.com:CatCatBug/fastcv-blog.git
else
  msg='来自github action的自动部署'
#  https://github.com/CatCatBug/fastcv-blog.git
  githubUrl=https://CatCatBug:${GITHUB_TOKEN}@github.com/fastcv-cc/fastcv-blog.git
  git config --global user.name "fastcv.cc"
  git config --global user.email "www.fastcv.cc@gmail.com"
fi
git init
git add -A
git commit -m "${msg}"
echo "上传github开始"
# 推送到github
git push -f $githubUrl master:gh-pages
echo "上传github完成"

# 创建release目录
mkdir ../release
# 将dist中的内容压缩到release.tgz
tar -zcvf ../release/release.tgz *