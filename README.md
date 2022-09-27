# riba2534's Blog



我的博客之前托管在腾讯云上，是 Typecho 的 php 动态网站

现在技术博客流行静态化，专注于内容，我也想逐渐把我的博客静态化，调研了一下，目前比较好的静态化工具有 hugo 和 hexo ，由于本人目前从事 Golang 开发，遂选择 hugo 作为静态化博客的工具。

目前新的博客采用 Github 托管源代码+腾讯云静态页面托管的方式运行。

地址为：https://blog.riba2534.cn

---

主题链接：https://github.com/AmazingRise/hugo-theme-diary

评论系统：https://twikoo.js.org/

hugo模板开发教程：

- https://hugo.aiaide.com/post/
- https://www.jianshu.com/p/0b9aecff290c
- http://blog.wikty.com/post/hugo-tutorial/


# 构建方法

```bash
# 克隆项目
git clone git@github.com:riba2534/hugo-blog.git

# 初始化本地配置文件
git submodule init
# 拉数据
git submodule update

# 启动服务器
hugo server
```


---

由于腾讯云云函数变了收费模式，我暂时把博客移到服务器上来