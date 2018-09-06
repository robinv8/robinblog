---
title: angular4运行 ng build -pord 出错
date: 2017-11-21 10:12:00
categories: 随记
comment: true
author: 秋风8
origin: 2
---

# angular4运行 ng build -pord 出错
1. npm, angular cli安装成功后;
2. 安装依赖时用npm install ，由于需要FQ，一直安装不下去;
3. 用了taobao镜像 用cnpm install 依赖安装成功;
4. 在用ng build时成功，但用ng build -prod时出错。错误如下:

![](http://cdn.rnode.me/images/20171121/img1.png)

大致意思是找不到package.json,之前用angular4.0没问题，装到最新的就有问题了，可能是使用cnpm装依赖引起的，因为npm install装不成功，不能确定是不是用npm install就可以了，

目前暂时用ng build --prod --no-extract-license解决，能成功运行，如果有碰到此问题的，可以用此命令试试。

[转载地址](http://www.cnblogs.com/phen/p/7726407.html)
