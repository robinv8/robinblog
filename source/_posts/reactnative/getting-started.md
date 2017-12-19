---
title: react native系列——环境搭建
date: 2017-12-19 16:17:44
tags: react native
categories: react native系列教程
comment: true
origin: 1
---

安装步骤参考[reactnative.cn](http://reactnative.cn/docs/0.51/getting-started.html),由于window环境下安装比较麻烦，下面我将进行逐步安装。
根据reactnative.cn的提示第一步安装Chocolatey工具，不知道什么原因安装失败了，如图：
![](http://cdn.rnode.me/images/20171218/img2.jpg)
Chocolatey只是一个包管理器，其安装的目的就是为了很方便的安装必备软件(python2、node)，安装失败的同学，我们手动安装。

## python 安装及配置
1. [下载地址](https://www.python.org/ftp/python/2.7.14/python-2.7.14.msi)

2. 开始安装……安装成功如下：
![](http://cdn.rnode.me/images/20171218/img3.jpg)

3. 配置环境变量
![](http://cdn.rnode.me/images/20171218/img4.jpg)
4. 验证
![](http://cdn.rnode.me/images/20171218/img5.jpg)

## node 安装及配置
1. [下载地址](https://nodejs.org/dist/v8.9.3/node-v8.9.3-x64.msi)
2. 开始安装……安装成功如下：
![](http://cdn.rnode.me/images/20171218/img6.jpg)
3. 验证
![](http://cdn.rnode.me/images/20171218/img7.jpg)

安装完node后建议设置npm镜像以加速后面的过程（或使用科学上网工具）。注意：不要使用cnpm！cnpm安装的模块路径比较奇怪，packager不能正常识别！
```
npm config set registry https://registry.npm.taobao.org --global
npm config set disturl https://npm.taobao.org/dist --global
```

## Yarn、React Native的命令行工具（react-native-cli）

Yarn是Facebook提供的替代npm的工具，可以加速node模块的下载。React Native的命令行工具用于执行创建、初始化、更新项目、运行打包服务（packager）等任务。

```
npm install -g yarn react-native-cli
```
安装完yarn后同理也要设置镜像源：

```
yarn config set registry https://registry.npm.taobao.org --global
yarn config set disturl https://npm.taobao.org/dist --global
```

## android studio安装

1. [下载地址](https://dl.google.com/dl/android/studio/install/3.0.0.18/android-studio-ide-171.4408382-windows.exe)安装之前必须安装jdk！jdk！jdk！，具体安装步骤参照[这里](http://blog.csdn.net/u012934325/article/details/73441617)
2. 安装结束，并打开会看到以下图：
![](http://cdn.rnode.me/images/20171218/img8.jpg)

3. 下一步，如图：
![](http://cdn.rnode.me/images/20171218/img9.jpg)
4. 检查已安装的组件，尤其是模拟器和HAXM加速驱动。
![](http://cdn.rnode.me/images/20171218/img10.jpg)
5. 一直下一步会看到以下界面，点击完成：
![](http://cdn.rnode.me/images/20171218/img11.jpg)
6. 安装完成后，在Android Studio的欢迎界面中选择Configure | SDK Manager
![](http://cdn.rnode.me/images/20171218/img13.jpg)
7. 在SDK Platforms窗口中，选择Show Package Details，然后在Android 6.0 (Marshmallow)中勾选`Google APIs`、`Android SDK Platform 23`、`Intel x86 Atom System Image`、`Intel x86 Atom_64 System Image`以及`Google APIs Intel x86 Atom_64 System Image`。
![](http://cdn.rnode.me/images/20171218/img14.jpg)
8. 在SDK Tools窗口中，选择Show Package Details，然后在Android SDK Build Tools中勾选`Android SDK Build-Tools 23.0.1`（必须包含有这个版本。当然如果其他插件需要其他版本，你可以同时安装其他多个版本）。然后还要勾选最底部的`Android Support Repository`。
![](http://cdn.rnode.me/images/20171218/img15.jpg)
9. 开始安装以上所选内容：
![](http://cdn.rnode.me/images/20171218/img16.jpg)

## ANDROID_HOME环境变量
![](http://cdn.rnode.me/images/20171218/img17.jpg)

到这里为止基本的环境就安装结束了，在这里`强烈建议`一下，在Android studio新建一个android项目，开发工具会检测你的android开发环境，如图：
![](http://cdn.rnode.me/images/20171218/img18.jpg)

该问题同样也会影响react native 在android端的调试，点击标记的区域安装相关环境，直到该区域没有蓝色警告，如图：
![](http://cdn.rnode.me/images/20171218/img19.jpg)

到此ardroid基本环境安装结束。

## Genymotion安装

比起Android Studio自带的原装模拟器，Genymotion是一个性能更好的选择，但它只对个人用户免费。
1. 下载和安装[Genymotion](https://dl.genymotion.com/releases/genymotion-2.11.0/genymotion-2.11.0-vbox.exe)（genymotion需要依赖VirtualBox虚拟机，下载选项中提供了包含VirtualBox和不包含的选项，请按需选择）。
2. 打开Genymotion。如果你还没有安装VirtualBox，则此时会提示你安装。
3. 创建一个新模拟器并启动。
4. 启动React Native应用后，可以按下F1来打开开发者菜单。

在启动模拟器的时候报错了，如图：
![](http://cdn.rnode.me/images/20171218/img21.jpg)
实测之后发现，在genymotion安装过程中，会有VirtualBox的安装过程，其版本是5.0.28，
我们安装较新的版本 [下载地址](http://sw.bos.baidu.com/sw-search-sp/software/6bda11b7d3256/VirtualBox-5.1.30.18389-Win.exe)

哒哒哒……安装成功了，小伙伴们有木有？？？
![](http://cdn.rnode.me/images/20171218/img22.jpg)

## 测试安装

```
react-native init AwesomeProject
cd AwesomeProject
react-native run-android
```

运行成功图如下：
![](http://cdn.rnode.me/images/20171218/img23.jpg)

【完】
