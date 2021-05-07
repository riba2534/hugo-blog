# riba2534's Blog

目前我的博客托管在腾讯云上，是 Typecho 的 php 动态网站：https://blog.riba2534.cn

现在技术博客流行静态化，专注于内容，我也想逐渐把我的博客静态化，调研了一下，目前比较好的静态化工具有 hugo 和 hexo ，由于本人目前从事 Golang 开发，遂选择 hugo 作为静态化博客的工具。

迁移博客不是一时就可以完成的，打算慢慢搞，目前新的静态化博客地址暂为：https://blog2.riba2534.cn

等到静态化博客准备好之后，直接弃用本来的 typecho ，直接采用 blog2.

---

主题链接：https://github.com/AmazingRise/hugo-theme-diary

评论系统：
- https://github.com/DesertsP/Valine-Admin
- https://valine.js.org/
- https://www.leancloud.cn/ (ServerLess云服务)

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
