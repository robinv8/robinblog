---
title: 前端进阶系列—JS执行机制
date: 2018-10-10 16:18:57
tags: [html,css,javascript,html5]
categories: [前端进阶系列]
comment: true
origin: 1
---

一直以来，对JS的执行机制都是模棱两可，知道今天看了文章—[《这一次，彻底弄懂JavaScript执行机制》]和[《Event Loop的规范和实现》](https://juejin.im/post/5a6155126fb9a01cb64edb45)(https://juejin.im/post/59e85eebf265da430d571f89)，才对JS的执行机制有了深入的理解，下面是我的学习总结。

## 2个要点

* JS是单线程语言
* Event Loop是JS的执行机制，为了实现主线程的不阻塞，Event Loop就这么诞生了。

## 2个概念(结合Browser环境和Node环境)

* task queue(宏任务队列)：`setTimeout`、`setInterval`、`setImmediate`、`I/O`、`UI交互事件`
* microtask queue(微任务队列)：`Promise`、`process.nextTick`、`MutaionObserver`

看下图：

![](http://cdn.rnode.me/images/20181010/img3.webp)

* queue可以看成一种数据结构，用以存储需要执行的函数
* setTimeout等API注册的函数，会进入task队列
* Promise等API注册的函数会进入microtask队列
* Event Loop执行一次，从task队列中拉出一个task执行
* Event Loop继续检查microtask队列是否为空，依次执行直至清空队列

## 情景再现

JS的执行逻辑，就好比只有一个窗口的银行，客户需要一个一个排队办理业务，假如现在排队的有两个人，第一个人是办理银行卡的，第二个人是取钱的，下面来个情景对话(这就类似上图的event loop)：
客服：请问您办理什么业务？
客户1：办理银行卡。
客服：请先填写一份申请表。下一位！(此时客户1进入callback queue)
客服：请问您办理什么业务？
客户2：取钱
…………
(此时客户1已经完成申请表填写，但客户2还未结束，那么客户1还需等待，直到窗口前的这个客户办理结束)
客户1：我填好了，给您……


## 实例练习1

```javascript
console.log(1)

setTimeout(() => {
    console.log(2)
    new Promise(resolve => {
        console.log(4)
        resolve()
    }).then(() => {
        console.log(5)
    })
})

new Promise(resolve => {
    console.log(7)
    resolve()
}).then(() => {
    console.log(8)
})

setTimeout(() => {
    console.log(9)
    new Promise(resolve => {
        console.log(11)
        resolve()
    }).then(() => {
        console.log(12)
    })
})
```

分解动作：
1. 主进程运行的代码首先输出1、7；
2. 再执行一次microtask输出8；
3. 执行了一次task输出2，4；
4. 再执行一次microtask输出5；
5. 再执行另一个task输出9、11；
6. 再执行一次microtask输出12

最终结果：
1、7、8、2、4、5、9、11、12

注意的：在Node环境下process.nextTick注册的函数优先级高于Promise,大家可以在Node环境下尝试下面的例子：
```javascript
new Promise(resolve => {
    console.log(1)
    resolve()
}).then(() => {
    console.log(2)
})
new Promise(resolve => {
    console.log(3)
    resolve()
}).then(() => {
    console.log(4)
})
process.nextTick(() => {
    console.log(5)
})

console.log(6)
```

执行结果：1、3、6、5、2、4


## 实例练习2

```javascript
setTimeout(() => {
	console.log(2)
}, 2)

setTimeout(() => {
	console.log(1)
}, 1)

setTimeout(() => {
	console.log(0)
}, 0)
```
有人说结果应该是0，1，2
但正确结果是2，1，0。
因为setTimeout最低延迟是4ms，值得注意。

参考文章：
[Event Loop的规范和实现](https://juejin.im/post/5a6155126fb9a01cb64edb45)
[这一次，彻底弄懂 JavaScript 执行机制](https://juejin.im/post/59e85eebf265da430d571f89)
[JavaScript 运行机制详解：再谈Event Loop](http://www.ruanyifeng.com/blog/2014/10/event-loop.html)