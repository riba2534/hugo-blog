# 主题改造记录

由于 diary 有点不满足本人需求，所以做了一点改造。

目前 hugo 的机制是项目中的 `layouts` 目录会覆盖 `themes` 中的同名文件。

在这里做一个改造记录.

---

```
layouts
├── _default
│   ├── section.html  # 在「文章」页面中增加了头图显示
│   └── single.html   # 内容页面中增加了共享协议
├── about
│   └── single.html   # 自定义的关于页面
├── archive
│   └── single.html   # 自定义的归档页面，以表格的形式列出来
├── friends
│   └── single.html   # 自定义的友链页面
├── index.html        # 主页的过滤器里面增加了过滤，只过滤属性为 `blog` 的文章
├── partials
│   ├── copyright.html    # 改了一下版权声明
│   ├── extrabar2.html    # 一个 trick 逻辑，在归档，分类，标签这种页面中我不希望出现左右翻页器，直接给删了，`taxonomy` 中的 `baseof.html` 调用了他，但是其他页面不会。
│   ├── footer-menu.html  # 我自己加的页面，增加了页面底部的菜单
│   ├── head.html         # 把数学公式的判断方式改为全局生效，twikoo 的版本更新到了 1.3.1
│   ├── journal.html      # Valine 评论系统默认的必填字段，我把昵称给去掉了
│   ├── mobile-footer2.html  # 我把手机版的翻页器删了，也是只在 `taxonomy` 中的 `baseof.html` 中生效
│   └── sidebar.html      # 在地步增加了 `footer-menu.html` 的展示
└── taxonomy              # 这个目录主要管的是聚合页面
    ├── baseof.html       # 对于聚合页面的展示，我把翻页器给删了
    ├── category.terms.html  # 页面名称写死为「分类」，翻页器给删了，做了一个统计文章数量功能
    ├── series.terms.html    # 做了一个 系列 页面，功能同上
    ├── tag.terms.html       # 直接把标签页改成小的标签，要不然太大了
    └── taxonomy.html        # 在具体的分类聚合页面，加上了头图

6 directories, 18 files
```

