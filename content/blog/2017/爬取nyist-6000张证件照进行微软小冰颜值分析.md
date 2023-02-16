---
title: 爬取nyist-6000张证件照进行微软小冰颜值分析
date: 2017-09-08T22:49:00+08:00
lastmod: 2017-09-08T22:55:29+08:00
draft: false
featured_image: https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d24475d5.jpg
tags:
- 数据分析
categories: 数据分析
comment: true

---

# Python爬取nyist-6000张证件照进行颜值分析



## 前言

本文章同步至CSDN博客：http://blog.csdn.net/riba2534/article/details/77894500

前几天学校要求更新档案资料库的照片，所以要求每个人去照证件照，大多数人是在学校里面的一个照相的地方照的，为了容易使同学们拿到照片，他们会每天把每个人的证件照上传到一个网站，于是我就用爬虫爬取了**6000+**照片，结合**微软小冰**的人脸识别中的**颜值分析**功能对每张照片进行打分，然后进行一次简单的颜值分析，下面简单说一说我的过程,**结论在最后**

## 工具准备

- python-3.6.2（必备）
- requests库（请求网络）
- re库（正则表达式）
- base64库（对base64编码进行处理）
- time库（构造post请求时要用到）
- os库（处理一些文件要用到）
- matplotlib库（用于绘制图表）
  1. 采集照片的网址：http://ngsying.com/list.asp?classid=22
  2. 微软小冰的颜值分析网址：https://kan.msxiaobing.com/ImageGame/Portal?task=yanzhi&feid=541a6dd6cd178819892a917dd772e702
  3. 微软的图片服务器网址：http://kan.msxiaobing.com/Api/Image/UploadBase64



## 一、爬取并保存图片

首先，我们打开要采集照片的地址：http://ngsying.com/list.asp?classid=22,会看到这样：
![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d251f359.jpg)

然后引入相关的库：

```python
import re
import requests
from bs4 import BeautifulSoup
import lxml
import os
```

我们打开这些链接发现：

1. http://ngsying.com/show.asp?id=99
2. http://ngsying.com/show.asp?id=100

因为日期的不同，所以网页地址变得只是后面的数字，所以我们只需要找到我们要爬取的第一个页面的标号和最后一个页面的标号，然后对每一个页面分别爬取就好了。
随便打开一个页面，会发现图片是这样的：


![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d260f2f2.jpg)

我们解析一下网页源代码会发现是这样的：

![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d26c82a6.jpg)

这些图片都无一例外的藏在`img`标签里面的，所以我们只需要把这些里面的内容提取出来就可以得到每一张图片的地址了。
提取的方法有很多种，比如用`BeautifulSoup`,但是这里由于这个标签并不需要解析成文档树，可以直接写一个正则表达式提取出来，所以我们可以这么写：

```
/upfile/201709/\d+\.JPG
```

只需要简单的匹配一下多位数字就可以了，这样我们可以写出具体代码:

![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d2751f54.jpg)

这样因为正则匹配的缘故，会返回一个包含所有图片地址的列表，那么现在我们要做的就是利用这个列表，进行保存：
这个也很简单，我们遍历一下这个列表，然后构造每一个图片链接，这里也需要用正则表达式来匹配一下文件名，用`requests`请求一下把二进制的东西保存成`.jpg`文件就好了

![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d27cd998.jpg)

现在我们的代码已经实现了对每个页面的图片进行保存，剩下的就是调用这两个函数了，我们只需要遍历一下要爬的网页的id，然后等着爬取完成就好了,爬虫爬完后会得到一个文件夹，里面就是你爬好的照片，就像这样：
![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d288d216.jpg)

到了现在，第一步就做完了，已经拥有这几千张证件照了

## 二、调用微软小冰人脸识别中的测颜值功能

首先，我们打开微软小冰的识别页面：

https://kan.msxiaobing.com/ImageGame/Portal?task=yanzhi&feid=541a6dd6cd178819892a917dd772e702

显示这样：

![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d29500a9.jpg)

这时我们点”上传图片”，然后进行抓包
![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d2a03316.jpg)

我们发现有两个`post`请求，分别是把当前图片传到微软服务器，还有一个是进行颜值测试，进行颜值测试的时候其中的一个参数要传入当前这个图片在微软服务器的地址，所以我们要分两步来做：

1. 把图片上传至微软服务器，并且得到返回的图片地址
2. 运用得到的图片地址，进行颜值颜值测试

通过抓包可以发现两个post地址，一个是提交图片的地址，另一个是获得颜值分数的地址:

```python
upload_url = 'http://kan.msxiaobing.com/Api/Image/UploadBase64'
comp_url = 'https://kan.msxiaobing.com/Api/ImageAnalyze/Process'
```

我们先说第一个，通过查看抓到的包，我们会发现每一张图片在传入服务器之前会先经过`base64`编码方式对图片进行编码，然后会post到微软的服务器，然后返回地址,那么我们就应该先对一张图片进行`base64`加密，然后我们会发现返回结果是这样的：

```json
{'Host': 'https://mediaplatform.msxiaobing.com', 'Url': '/image/fetchimage?key=JMGsDUAgbwOliRBabKjOIkANmt-Cu2pqpAsmCZyiMDJ6wxaO8iaLjrucUw'}
```

这是一段`json`信息，我们需要的是`url`里面的值，所以我们就用`requests`中内置的`json`解析器对它进行解析，所以，代码可以这么写：

```python
def get_img_url(file_name):
    with open(file_name,'rb') as f:
        img_base64=base64.b64encode(f.read())
    r=requests.post(upload_url,data=img_base64)
    url='https://mediaplatform.msxiaobing.com' + r.json()['Url']
    return url
```

我们通过把二进制信息进行编码，然后传入微软服务器,获得了这一张图片在服务器中的地址，然后在通过构造，得到完整的地址

那么我们现在进行第二步，把信息发到微软服务器，然后得到地址，我们看一下抓的包：

```http
Remote Address:42.159.132.179:443
Request URL:https://kan.msxiaobing.com/Api/ImageAnalyze/Process?service=yanzhi&tid=a14a6fd556cf45c181cb116f06471450
Request Method:POST
Status Code:200 OK
Response Headers
view source
Cache-Control:no-cache
Content-Encoding:gzip
Content-Type:application/json; charset=utf-8
Date:Thu, 07 Sep 2017 17:18:28 GMT
Expires:-1
Pragma:no-cache
Server:Microsoft-IIS/8.0
Transfer-Encoding:chunked
Vary:Accept-Encoding
X-Powered-By:ASP.NET
Request Headers
view source
Accept:*/*
Accept-Encoding:gzip, deflate
Accept-Language:zh-CN,zh;q=0.8
Connection:keep-alive
Content-Length:194
Content-Type:application/x-www-form-urlencoded; charset=UTF-8
Cookie:_ga=GA1.2.1597838376.1504599720; ai_user=sp1jt|2017-09-05T10:53:04.090Z; ARRAffinity=d48a0dd61144e14e99ea10eca4fef5d81bf07933a2831679353d2761cf0db5aa; cpid=YE5cTN4wQk4hTFdMf7FVTzM0bjPlNN1MJrFATNhI10hNAA; salt=761703E5A961C3EC8AD465F2A70F639F; ai_session=pWq6U|1504804573893.97|1504804670104.895
Host:kan.msxiaobing.com
Origin:https://kan.msxiaobing.com
Referer:https://kan.msxiaobing.com/ImageGame/Portal?task=yanzhi&feid=541a6dd6cd178819892a917dd772e702
User-Agent:Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36
x-ms-request-id:4KL3u
x-ms-request-root-id:idMkH
X-Requested-With:XMLHttpRequest
Query String Parameters
view source
view URL encoded
service:yanzhi
tid:a14a6fd556cf45c181cb116f06471450
Form Data
view source
view URL encoded
MsgId:1504804707562
CreateTime:1504804707
Content[imageUrl]:https://mediaplatform.msxiaobing.com/image/fetchimage?key=EjJdNJc119RQMNM3GzUGslUzG3NxdRU1EnQqNFt2MVJPbiOGhpbpzmOmXA
```

我们要构造`data`里面的信息，也就是要构造`MsgId`,`CreateTime`,`Content[imageUrl]`这三个信息，首先我们观察`MsgId`,发现它实质上就是当前的时间戳加了一个3位数的随机数,而第二个`CreateTime`其实就是当前的时间戳，第三个`Content[imageUrl]`那当然就是我们刚刚得到的图片地址了，我们就把这些参数给发上去

然后把这些请求发上去以后，会发现它的返回结果是`none`，那么这是为什么呢，这是因为微软添加了`cookies`和`refer`验证，所以我们要把这两个东西放在`headers`里面一起给传过去,然后就会发现它返回一段`json`:

```json
{'msgId': '4d39f92788774d65bd0261d6f4754865', 'timestamp': 1504805911673, 'receiverId': None, 'content': {'text': '有潜力的妹子！6.6分！性格肯定超好，男神最喜欢这种女孩纸咯，羡慕！', 'imageUrl': 'http://mediaplatform.trafficmanager.cn/image/fetchimage?key=UQAfAC8ABAAAAFcAFgAGABYASgAxAEIANwBEAEMAQwA4AEIAMAA3AEQAQQBGADYAMgA4AEQAMwA5AEMAMwA1AEMAMQAwADcANwA5ADMAMwAxAEUA', 'metadata': {'AnswerFeed': 'FaceBeautyRanking', 'w': 'vvXoifT_gNLyhvXNhsPhjMz_pt_kbkdXisHliuToh-_uhcXkgePArM3_sN_kiuzeiuTlhvv-hMDGj_3vrPX5vsXDh_b6gv_khMr6hsjxjtvXrPHKt9XtiPfCg938jtPI', 'aid': '303DB2A95867544E3E5EE047977CECF4'}}}
```

我们按照惯例，对它进行解析，我们提取出来`['content']['text']`里面的内容就行了，所以这一段的代码：

```python
def get_score(img_url):
    sys_time = int(time.time())
    payload = {'service': 'yanzhi',
               'tid': '7531216b61b14d208496ee52bca9a9a8'}
    form = {
        'MsgId': str(sys_time) + '733',
        'CreateTime': sys_time,
        'Content[imageUrl]': img_url,
    }
    headers={
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36',
        'Cookie':'_ga=GA1.2.1597838376.1504599720; _gid=GA1.2.1466467655.1504599720; ai_user=sp1jt|2017-09-05T10:53:04.090Z; cpid=YDLcMF5LPDFfSlQyfUkvMs9IbjQZMiQ2XTJHMVswUTFPAA; salt=EAA803807C2E9ECD7D786D3FA9516786; ARRAffinity=3dc0ec2b3434a920266e7d4652ca9f67c3f662b5a675f83cf7467278ef043663; ai_session=sQna0|1504664570638.64|1504664570638'+str(random.randint(11, 999)),
        'Referer': 'https://kan.msxiaobing.com/ImageGame/Portal?task=yanzhi&feid=d89e6ce730dab7a2410c6dad803b5986'
    }
    r = requests.post(comp_url,params=payload, data=form,headers=headers)
    print(r.json())
    text=r.json()['content']['text']
    return text
```

这样的话，我们就可以获得小冰对这个照片的评价，那么对于后期处理，我们只要用正则表达式把其中的关于颜值分数的地方提取出来就好了，那么这时候就需要保存刚刚获得的评价分数，所以我们采用的方式就是对文件重命名，就是把文件名改成:`分数+原来的文件名`的形式,代码如下：

![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d2a882ad.jpg)

为了方便我们对于程序的调试，所以用一个txt文件随时把程序的log信息传进去，就像这样：

![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d2b21d70.jpg)

至此，打分环节也完成了，下面进行下一项

## 三、把分数用图表的方式绘制出来

这一步需要用到`matplotlib库`中的`pyplot`，用它可以绘制出很多种不同的图,先引入库：

```python
import matplotlib.pyplot as plt
import os
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号
```

由于微软小冰的`API`调用次数的限制，我只成功的对`2118`张图片进行了颜值的打分，很容易的得到了每个分数段区间的数量：

```python
def get_score():
    score_num=[]
    for i in range(6):
        score_num.append(0)
    list=os.listdir()
    for name in list:
        if len(name)==24:
            score=float(name[:3])
            if score>=3 and score<4:
                score_num[0]+=1
            elif score>=4 and score<5:
                score_num[1]+=1
            elif score>=5 and score<6:
                score_num[2]+=1
            elif score>=6 and score<7:
                score_num[3]+=1
            elif score>=7 and score<8:
                score_num[4]+=1
            elif score>=8 and score<=9:
                score_num[5]+=1
    return score_num
```

这样返回一个列表，里面都是每个分数区间里面的人数。

现在我们要做的就是绘制统计图，就绘制成条形图和饼图，具体的用法请参考`matplotlib`的文档，我把绘制图的代码直接贴出来：

柱形图：

```python
def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        plt.text(rect.get_x()+ 0.3, height+ 0.05, '%d' % height, ha='center', va='bottom')

def draw_column():
    score=get_score()
    plt.title('nyist证件照颜值分数分析   总数：2118')
    plt.xlabel('颜值区间')
    plt.ylabel('人数')
    plt.xticks([0,1,2,3,4,5], ['3~4分', '4~5分','5~6分','6~7分','7~8分','8~9分'])
    rect=plt.bar(left=(0,1,2,3,4,5), height=score, width=0.7, align="center")
    plt.legend((rect,), ('数量',))
    autolabel(rect)
    plt.show()
```

饼图：

```python
def draw_circle():
    score = get_score()
    labels='3~4分', '4~5分','5~6分','6~7分','7~8分','8~9分'
    sizes=score
    explode=(0,0,0,0.05,0,0)
    plt.pie(sizes,explode=explode,labels=labels,autopct='%1.1f%%',shadow=False,startangle=90)
    plt.axis('equal')
    plt.show()
```

最后的结果如下图所示：

![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d2bc4c46.jpg)
![](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d2c5edd8.jpg)

## 总结

**颜值突出的非常少，只有2%,但是大部分长得还过的去，估计是微软小冰不好意思打特别低的分~~微软小冰的颜值分析是有限制的，一分钟限制10次，一个小时限制120次，一天限制360次，我用代理ip的方式也会被限制，所幸路由器重新拨号可以破除这个限制，于是就断断续续爬了2000+照片写了这个博客~**



tips:至于照片文件，还是私下找我要吧~
