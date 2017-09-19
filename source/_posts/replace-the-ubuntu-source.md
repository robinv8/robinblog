---
title: Ubuntu 16.04 LTS快速更新阿里源
date: 2017-09-17 14:45:54
tags: ubuntu
comment: true
categories: ubuntu
origin: 1
thumbnail: http://cdn.rnode.me/images/20170914/speed.jpg
---
新手在使用Ubuntu的时候可能在升级时感觉很慢，如果这样他就需要换一个适合自己的源了。
下面我就简单的说一下怎样换源。
在终端里输入 sudo cp /etc/apt/sources.list /etc/apt/sources.list_backup （表示备份列表）
再输入 sudo gedit /etc/apt/sources.list
你就能看到源列表了，把你看到的都删除然后粘贴上适合你的源
源，自己找一个适合自己的

```
sudo vi /etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
##测试版源
deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
# 源码
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
##测试版源
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
# Canonical 合作伙伴和附加
deb http://archive.canonical.com/ubuntu/ xenial partner
deb http://extras.ubuntu.com/ubuntu/ xenial main
```
