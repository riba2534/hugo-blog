---
title: Django2.0中使用MrakDown编辑器并在前端显示
date: 2018-12-16T16:31:00+08:00
lastmod: 2018-12-31T17:27:50+08:00
draft: false
featured_image: https://s1.ax1x.com/2018/12/31/F4JAnx.jpg
tags:
- Django
- Python
categories: Django
comment: true

---

# Django2.0中使用MrakDown编辑器并在前端显示

## 前言

在使用`Django`的过程中，有一个使用文本编辑器的需求，原本使用的是富文本编辑器`django-ckeditor`但是它不是`MarkDown`编辑器，经过一翻寻找我找到了`Editor.Md`这个项目，这是一款优秀的`MrakDown`编辑器，并且有人贴心得把它移植到了`Django`上，下面我记载一下使用方法

> 本文所用的操作系统为`Deepin 15.8`
>
> Python版本:`Python 3.6.5`
>
> Django版本:2.0

## 添加编辑器到后台

首先我们需要安装编辑器，这个编辑器在`GitHub`的地址是:[django-mdeditor](https://github.com/pylixm/django-mdeditor)

1. 安装`django-mdeditor`:

   ```shell
   sudo pip3 install django-mdeditor
   ```

2. 然后在项目目录的`settings.py`加入:

   ```python
   INSTALLED_APPS = [
         ...
         'mdeditor',
   ]
   ```

3. 添加媒体路径到设置中:

   ```python
   MEDIA_ROOT = os.path.join(BASE_DIR, 'uploads')
   MEDIA_URL = '/media/'
   ```

4. 在项目的`urls.py`中加入:

   ```python
   from django.contrib import admin
   from django.urls import path, include
   from django.conf import settings
   from django.conf.urls.static import static
   from . import views
   urlpatterns = [
       path('admin/', admin.site.urls),
       path('blog/', include('blog.urls')),
       path('mdeditor/', include('mdeditor.urls')),
   ]
   urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
   
   ```

5. 添加一个博客`APP`:

   此过程不表，假设你已经创建好一个博客app，并且在`admin.py`注册了`model`,在`models.py`中添加:

   ```python
   from django.db import models
   from mdeditor.fields import MDTextField
   
   class Blog(models.Model, ReadNumExpandMethod):
       title = models.CharField(max_length=50)  
       content = MDTextField()  # 类型为编辑器提供的字段
   ```

   然后运行:

   ```shell
   python3 manage.py makemigrations
   python3 manage.py migrate
   ```

此时打开我们的后台，应该已经可以看到效果了:

![](https://i.loli.net/2018/12/02/5c03d6369d1ed.png)



## 前端渲染

此时，后台虽然已经有了`MarkDown`编辑器，但是在前端并没有展示出来,我们需要用一些方法在前端显示.

首先需要安装一个第三方库:

```shell
pip3 install markdown
```

此时我们已经在`models.py`里面注册了这个子段，我们需要在`views.py`中显示出来,我是返回了一个字典，读者可以根据自己的需要，找到具体的内容，调用`markdown`方法来解析成html返回给前端:

```python
blog/views.py

import markdown
from django.shortcuts import render_to_response, get_object_or_404

def blog_detail(request, blog_pk):  # 博客内容
    context = {}
    context['blog'] = get_object_or_404(Blog, id=blog_pk)
    context['blog'].content = markdown.markdown(context['blog'].content,
                                                extensions=[
        'markdown.extensions.extra',
        'markdown.extensions.codehilite',
        'markdown.extensions.toc',
    ])
    response = render_to_response("blog/blog_detail.html", context)  
    return response
```

这样我们在模板中展示 `{{ blog.content }}` 的时候，就不再是原始的 `Markdown` 文本了，而是渲染过后的 HTML 文本。注意这里我们给 `markdown` 渲染函数传递了额外的参数 `extensions`，它是对 `Markdown` 语法的拓展，这里我们使用了三个拓展，分别是 `extra、codehilite、toc`。extra 本身包含很多拓展，而 codehilite 是语法高亮拓展，这为我们后面的实现代码高亮功能提供基础.

在前端调用的时候，此时支持显示纯粹的`html`代码，我们需要在前端解析`html`，可以这样:

在对应模型标签中填入`{{ blog.content|safe }}`即可.

此时效果为:

![](https://i.loli.net/2018/12/02/5c03da977e1e0.png)



接下来有代码高亮的环节，这些内容不在本文讨论范围之内，请自行搜索.

## 参考博客

1. [Django2.0整合markdown编辑器](https://blog.csdn.net/King_Giji/article/details/80577482)
2. [支持 Markdown 语法和代码高亮](https://www.zmrenwu.com/post/11/)