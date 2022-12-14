
# 博客搭建

## 介绍

博客地址：https://fastcv.cc


1. 这个主题的初衷是打造一个好用的、面向程序员的知识管理工具。
2. 轻松构建一个结构化的知识库，让你的知识海洋像一本本书一样清晰易读。
3. 博客功能提供一种知识的碎片化形态，并支持个性化博客配置。
4. 简洁高效，以 Markdown 为中心的项目结构。内置自动化工具，以更少的配置完成更多的事。配合多维索引快速定位每个知识点。


该博客基于改造：  
[vuepress-theme-vdoing主题](https://doc.xugaoyi.com/)   
[Dra-M个人博客](https://github.com/moxiaolong/dram-vdiong)


代码拉取（branch：blog-template）
> https://github.com/rcbb-cc/rcbb-blog

下文所有的内容都基于 rcbb-blog（branch：blog-template）。

## 快速上手

```
(1)拉取项目，并切换使用 blog-template 分支。  
    https://github.com/rcbb-cc/rcbb-blog.git

(2)进入项目目录
    cd rcbb-blog

(3)安装依赖
    npm install

(4)启动项目
    npm run dev
```

正确启动后就可以访问了。

## 构建

这里以 zhangsan 做为关键词来构建博客。

需要进行更改的内容。

```
(1)重命名项目
    将 rcbb-blog 重命名为 zhangsan-blog
    
(2)更改项目中所有的关键字
    rcbb 更改为 zhangshan
    日常bb 更改为 张三
    
(3)假设你的域名为 zhangsan-blog.com
    rcbb.cc 更改为 zhangsan-blog.com
    
(4)百度推送链接code需要进行更换
    文件地址为：/rcbb-blog/docs/.vuepress/config/baiduCode.ts
    需要注册登录百度统计：https://tongji.baidu.com
    添加自己的域名后
    百度统计官网：使用设置->代码管理->代码获取
    获取到code值
    
(5)更改百度收录的url
    文件地址为：/rcbb-blog/baiduPush.sh
    如何获取百度链接推送的url？
    登录百度账号后访问：https://ziyuan.baidu.com/
    百度搜索资源平台官网：搜索服务->资源提交->普通收录
    https://ziyuan.baidu.com/linksubmit/index?site=https://zhangsan-blog.com
```

## 博客如何部署到自己的服务器

为了方便平时的博客更新内容，项目中并不会直接通过脚本上传到自己的服务器，而是通过 Github Actions 来实现自动更新到自己的服务器。

[mqyqingfeng：还不会用 GitHub Actions ？](https://github.com/mqyqingfeng/Blog/issues/237)


首先先将项目推送到 github 上，在 Actions 会看到 CI 错误。

![CI错误](https://rcbb-blog.oss-cn-guangzhou.aliyuncs.com/2022/07/20220725144306-dc50b2.png?x-oss-process=style/yuantu_shuiyin)

因为`rcbb-blog/.github/ci.yml`中还有很多参数并未设置。

### ci.yml

参数配置在 secrets 中。

![secrets参数](https://rcbb-blog.oss-cn-guangzhou.aliyuncs.com/2022/07/20220725145715-3fa094.png?x-oss-process=style/yuantu_shuiyin)

#### 参数配置

**ACCESS_TOKEN**

ACCESS_TOKEN 从哪获取？

Github 点击自己头像 Settings -> Developer settings -> Personal access tokens  
token设置永不过期，可勾选项全勾上。

![ACCESS_TOKEN获取](https://rcbb-blog.oss-cn-guangzhou.aliyuncs.com/2022/07/20220725145539-31a25f.png?x-oss-process=style/yuantu_shuiyin)

获取到 ACCESS_TOKEN 后设置到 secrets 中。

**Secrets设置**

到哪设置secrets？

回到 rcbb-blog 项目中 Settings -> Secrets -> Actions

![Secrets设置](https://rcbb-blog.oss-cn-guangzhou.aliyuncs.com/2022/07/20220725150052-2ea040.png?x-oss-process=style/yuantu_shuiyin)

其他的参数也是这么设置：
```
# ssh username
key：BLOG_USERNAME
value：root

# 远程服务器IP，自己服务器的IP地址
key：BLOG_HOST
value：165.56.89.12
    
远程服务器ssh端口，默认22
key：BLOG_PORT
value：22

认证服务器秘钥对的私钥
key：BLOG_SSH_PRIVATE_KEY
value：xxx
```

![Secrets](https://rcbb-blog.oss-cn-guangzhou.aliyuncs.com/2022/07/20220725151059-8f84fd.png?x-oss-process=style/yuantu_shuiyin)

**认证服务器私钥**

认证服务器秘钥对的私钥怎么获取？

```
(1)在自己服务器上执行
    然后一路回车就能创建成功
    ssh-keygen -m PEM
    
(2)把公钥放到服务器中
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    
(3)copy私钥
    cat /root/.ssh/id_rsa
```

### 服务器设置

创建所需目录

```
mkdir -p /apps/www/rcbb.cc
mkdir -p /apps/www/release
```

安装 nginx

```
(1)安装
    yum install -y nginx

(2)启用 Nginx
    systemctl start nginx

(3)设置为在系统启动时自动启动
    systemctl enable nginx

(4)验证
    在浏览器输入自己的公网IP
    如果出现nginx页面，则代表成功
```

创建测试文件

```
(1)创建目录
    mkdir -p /apps/www/rcbb.cc

(2)进入目录
    cd /apps/www/rcbb.cc

(3)创建文件
    touch index.html

(4)写入内容
    echo '<!doctype html><html><head><meta charset="utf-8"><title>Hello World!</title></head><body>Hello World!</body></html>' > index.html
    
(5)进入配置文件目录
    cd /etc/nginx

(6)修改配置文件内容
    vim nginx.conf
    
(7)在 location / {} 中添加内容
    location / {
      root /apps/www/rcbb.cc/;
      index index.html;
    }
    保存退出修改后，重新加载配置文件。
    
(8)重新加载配置文件
    systemctl reload nginx
    
(9)验证
    浏览器输入服务器 IP，看见 Hello World! 就代表成功了。  
```

### 测试

在 master 分支上进行 push，就会触发 Actions。

![Actions](https://rcbb-blog.oss-cn-guangzhou.aliyuncs.com/2022/07/20220725154211-d45663.png?x-oss-process=style/yuantu_shuiyin)

![服务器上的文件](https://rcbb-blog.oss-cn-guangzhou.aliyuncs.com/2022/07/20220725154546-8d1d06.png?x-oss-process=style/yuantu_shuiyin)

这时在浏览器中输入自己公网 IP，如果可以正确访问，则代表一切顺利~