---
title: react native系列——介绍
date: 2017-12-19 11:16:44
tags: react native
categories: react native系列教程
comment: true
origin: 1
---
## react native是什么？
>来自百度百科的介绍

React Native (简称RN)是Facebook于2015年4月开源的跨平台移动应用开发框架，是Facebook早先开源的UI框架 React 在原生移动应用平台的衍生产物，目前支持iOS和安卓两大平台。RN使用Javascript语言，类似于HTML的JSX，以及CSS来开发移动应用，因此熟悉Web前端开发的技术人员只需很少的学习就可以进入移动应用开发领域。

## react native能干什么？
React Native使你能够在Javascript和React的基础上获得完全一致的开发体验，构建世界一流的原生APP。

React Native着力于提高多平台开发的开发效率 —— 仅需学习一次，编写任何平台。(Learn once, write anywhere)

说白了就是一次开发编译成android、ios两个版本。

## react native实现机制

简单的讲就是建立js与native之间的桥梁(bridge)，将js的行为映射到native，最终的操作都是native的操作，这和webapp有本质的区别。
具体的实现机制请看[这里](http://blog.csdn.net/xiangzhihong8/article/details/52623852)。

## 几种app开发的比较

&emsp;&emsp;&emsp;&emsp;| web app | hybrid app | react native app| native app
---|---|---|---|---
原生功能体验| 差 | 良好 | 接近原生 | 优秀
渲染性能|慢 | 较快 | 快 | 非常快
是否支持设备底层访问| 不支持 | 支持|支持|支持
网络要求| 依赖网络 | 支持离线(资源存本地)| 支持离线 | 支持离线
更新复杂度| 低(服务端直接更新) | 较低(可以进行资料包更新)| 较低(可以进行资源包更新) |高(几乎通过应用商店更新)
编程语言| html5+css3+javascript | html5+css3+javascript | 主要使用js| Android(Java),iOS(OC/Swift)
社区资源| 丰富(大量前端资料) | 有局限性(不同的Hybrid相互独立)|丰富(统一的活跃社区)|	丰富(Android,iOS单独学习)
上手难度| 简单(写一次，支持不同的平台访问) | 简单(写一次，运行任何平台) |中等(学习一次，运行任何平台) |难(不同平台需要单独学习)
开发周期| 短 | 较短 | 中等 | 长
开发成本| 便宜 | 较为便宜 | 中等 | 昂贵
跨平台| 所有H5浏览器 | Android,iOS,h5浏览器 | Android、iOS|不跨平台
APP发布| web服务器 | App Store|App Store|App Store

详情参考[这里](https://www.cnblogs.com/dailc/archive/2016/10/04/5930238.html)

## react native 整套组件库

- [NativeBase](https://github.com/GeekyAnts/NativeBase)

## react native常用组件
- 动画 [react-native-animatable](https://github.com/oblador/react-native-animatable)
- 轮播 [react-native-swiper](https://github.com/leecade/react-native-swiper)
- 设备信息 [react-native-device-info](https://github.com/rebeccahughes/react-native-device-info)
- 图标 [react-native-vector-icons](https://github.com/oblador/react-native-vector-icons)
- 图片选择器 [react-native-image-picker](https://github.com/react-community/react-native-image-picker)
- 可刷新列表 [react-native-refreshable-listview](https://github.com/jsdf/react-native-refreshable-listview)
- 可滚动标签 [react-native-scrollable-tab-view](https://github.com/skv-headless/react-native-scrollable-tab-view)
- 侧栏 [react-native-side-menu](https://github.com/react-native-community/react-native-side-menu)
- 视频播放器 [react-native-video](https://github.com/react-native-community/react-native-video)
- 分页浏览 [react-native-viewpager](https://github.com/race604/react-native-viewpager)
- 可滑动到底部或上部导航栏框架 [react-native-scrollable-tab-view](https://github.com/skv-headless/react-native-scrollable-tab-view)
- 底部或上部导航框架(不可滑动) [react-native-tab-navigator](https://github.com/happypancake/react-native-tab-navigator)
- 启动白屏问题 [react-native-splash-screen](https://github.com/crazycodeboy/react-native-splash-screen)
- 路由 [react-native-router-flux](https://github.com/aksonov/react-native-router-flux)
- 持久化存储 [react-native-storage](https://github.com/sunnylqm/react-native-storage)
- 分类ListView [react-native-sortable-listview](https://github.com/deanmcpherson/react-native-sortable-listview)
- 展示html的组件 [react-native-htmlview](https://github.com/jsdf/react-native-htmlview)
- 一款简单易用的 Toast 组件 [react-native-root-toast](https://github.com/magicismight/react-native-root-toast)

下一篇：[react native 基础环境搭建](/reactnative/interduction/)

【完】
