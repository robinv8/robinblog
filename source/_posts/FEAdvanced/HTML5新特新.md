---
title: 前端进阶系列—HTML5新特性
date: 2018-04-07 23:01:57
tags: [html, css, javascript, html5]
categories: [前端进阶系列]
comment: true
origin: 1
---

HTML5 是对 HTML 标准的第五次修订。其主要的目标是将互联网语义化，以便更好地被人类和机器阅读，并同时提供更好地支持各种媒体的嵌入。HTML5 的语法是向后兼容的。现在国内普遍说的 H5 是包括了 CSS3，JavaScript 的说法（严格意义上说，这么叫并不合适，但是已经这么叫开了，就将错就错了）。

## 语义特性

HTML5 赋予网页更好的意义和结构

- 文件类型声明（<!DOCTYPE>）仅有一型：<!DOCTYPE HTML>。
- 新的解析顺序：不再基于 SGML。
- 新的元素：section, video, progress, nav, meter, time, aside, canvas, command, datalist, details, embed, figcaption, figure, footer, header, hgroup, keygen, mark, output, rp, rt, ruby, source, summary, wbr。
- input 元素的新类型：date, email, url 等等。
- 新的属性：ping（用于 a 与 area）, charset（用于 meta）, async（用于 script）。
- 全域属性：id, tabindex, repeat。
- 新的全域属性：contenteditable, contextmenu, draggable, dropzone, hidden, spellcheck。
- 移除元素：acronym, applet, basefont, big, center, dir, font, frame, frameset, isindex, noframes, strike, tt。

## 本地存储特性

HTML5 离线存储包含：`应用程序缓存（Application Cache）`、`本地存储`、`索引数据库`、`文件接口`

### 应用程序缓存

通过创建 cache manifest 文件，可以轻松的创建 web 应用的离线版本
其优势在于：

- **离线浏览**-用户可在应用离线时使用它们
- **速度**-已缓存静态资源，使加载更快
- **减少服务器负载**-浏览器将只存服务器下载更新过或修改过的资源

### 本地存储

- localStorage
- sessionStorage

从名字上看就可以很清楚的辨认两者的区别，前者是一直存在本地的，后者只是伴随着 session，窗口一旦关闭就没了。

### 索引数据库（indexed DB）

从本质上说，IndexedDB 允许用户在浏览器中保存大量的数据。任何需要发送大量数据的应用都可以得益于这个特性，可以把数据存储在用户的浏览器端。当前这只是 IndexedDB 的其中一项功能，IndexedDB 也提供了强大的基于索引的搜索 api 功能以获得用户所需要的数据。

用户可能会问：IndexedDB 是和其他以前的存储机制(如 cookie,session)有什么不同？

Cookies 是最常用的浏览器端保存数据的机制,但其保存数据的大小有限制并且有隐私问题。Cookies 并且会在每个请求中来回发送数据，完全没办法发挥客户端数据存储的优势。

再来看下 Local Storage 本地存储机制的特点。Local Storage 在 HTML 5 中有不错的支持，但就总的存储量而言依然是有所限制的。Local Storage 并不提供真正的“检索 API”,本地存储的数据只是通过键值对去访问。Local Storage 对于一些特定的需要存储数据的场景是很适合的，例如，用户的喜好习惯，而 IndexedDB 则更适合存储如广告等数据（它更象一个真正的数据库）。

一般来说,有两种不同类型的数据库:关系型和文档型(也称为 NoSQL 或对象)。关系数据库如 SQL Server,MySQL,Oracle 的数据存储在表中。文档数据库如 MongoDB,CouchDB,Redis 将数据集作为个体对象存储。IndexedDB 是一个文档数据库，它在完全内置于浏览器中的一个沙盒环境中(强制依照（浏览器）同源策略)。

对数据库的每次操作，描述为通过一个请求打开数据库,访问一个 object store，再继续。

**IndexedDB 是否适合应用程序的几个关键点**

- 你的用户通过浏览器访问您的应用程序,（浏览器）支持 IndexedDB API 吗 ?
- 你需要存储大量的数据在客户端?
- 你需要在一个大型的数据集合中快速定位单个数据点?
- 你的架构在客户端需要事务支持吗?

如果你对其中的任何问题回答了“是的”,很有可能,IndexedDB 是你的应用程序的一个很好的候选。

### 文件接口

看这里[http://www.cnblogs.com/zichi/p/html5-file-api.html](http://www.cnblogs.com/zichi/p/html5-file-api.html)

## 设备访问特性

包括`地理位置API`、`媒体访问API`、`访问联系人及事件`、`设备方向`

#### 地理位置

看这里[https://developer.mozilla.org/zh-CN/docs/Web/API/Geolocation/Using_geolocation](https://developer.mozilla.org/zh-CN/docs/Web/API/Geolocation/Using_geolocation)

#### 媒体访问

看这里[https://developer.mozilla.org/zh-CN/docs/Web/Guide/HTML/Using_HTML5_audio_and_video](https://developer.mozilla.org/zh-CN/docs/Web/Guide/HTML/Using_HTML5_audio_and_video)

#### 访问联系人及事件

看这里 [https://blog.csdn.net/qq_27626333/article/details/51815229](https://blog.csdn.net/qq_27626333/article/details/51815229)

#### 设备方向

看这里 [https://developer.mozilla.org/zh-CN/docs/Web/API/Detecting_device_orientation](https://developer.mozilla.org/zh-CN/docs/Web/API/Detecting_device_orientation)

## 连接特性

HTTP 是无连接的，一次请求，一次响应。想要实现微信网页版扫一扫登录，网页版微信聊天的功能，需要使用轮询的方式达到长连接的效果，轮询的大部分时间是在做无用功，浪费网络，浪费资源。现在 HTML5 为我们带来了更高效的连接方案 **Web Sockets** 和**Server-Sent Events**。

## 网页多媒体特性

HTML5 支持原生的音视频能力：**Audio**、**video**

## 三维、图形及特效特性

大致包含 SVG, Canvas, WebGL, 和 CSS3 3D，下面分别进行研究。

## 性能与集成特性

性能与集成特性主要包括两个东西，Web Workers 和 XMLHttpRequest 2。

参考文章：

- [HTML5 新特性浅谈](http://www.ganecheng.tech/blog/52819118.html)
- [HTML5 新增内容](https://leohxj.gitbooks.io/front-end-database/html-and-css-basic/what-is-html5.html)
