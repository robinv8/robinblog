---
title: angular4 运行 ng build -pord 出错
date: 2017-11-21 10:12:00
categories: 随记
comment: true
author: 秋风 8
origin: 2
---

1. npm, angular cli 安装成功后;
2. 安装依赖时用 npm install ，由于需要 FQ，一直安装不下去;
3. 用了 taobao 镜像 用 cnpm install 依赖安装成功;
4. 在用 ng build 时成功，但用 ng build -prod 时出错。错误如下:

![](http://cdn.rnode.me/images/20171121/img1.png)

大致意思是找不到 package.json,之前用 angular4.0 没问题，装到最新的就有问题了，可能是使用 cnpm 装依赖引起的，因为 npm install 装不成功，不能确定是不是用 npm install 就可以了，

目前暂时用 ng build --prod --no-extract-license 解决，能成功运行，如果有碰到此问题的，可以用此命令试试。

[转载地址](http://www.cnblogs.com/phen/p/7726407.html)
