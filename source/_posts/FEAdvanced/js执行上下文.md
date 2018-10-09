---
title: 前端进阶系列—什么是执行上下文？什么是调用栈
date: 2018-10-09 09:29:57
tags: [html,css,javascript,html5]
categories: [前端进阶系列]
comment: true
origin: 1
---
```text
原文作者：Valentino
原文链接：https://www.valentinog.com/blog/js-execution-context-call-stack
```

## 什么是Javascript中的执行上下文？

我打赌你不知道答案。

编程语言中最基础的组成部分是什么？

变量和函数对吗？每个人都可以学习这些板块。

但除了基础知识之外还有什么？

在称自己为中级（甚至是高级）Javascript开发人员之前，你应该掌握的Javascript的核心是什么？

有很多：`Scope(作用域)`、`Closure(闭包)`、`Callbacks(回调)`、`Prototype(原型)`等等。

但在深入研究这些概念之前，您至少应该了解Javascript引擎的工作原理。

在这篇文章中，我们将介绍每个Javascript引擎的两个基本部分：执行上下文和调用堆栈。

（不要害怕。它比你想象的容易）。

准备好了吗？

目录
1. 你会学到什么？
2. Javascript如何执行您的代码？
3. Javascript引擎
4. 它是如何工作的？
5. 全局存储器？
6. 什么是调用栈？
7. 什么是局部执行上下文？
8. 总结

## 你会学到什么？

在这篇文章中你将学到：
* Javascript引擎是如何工作的？
* Javascript中执行上下文
* 什么是调用栈
* 全局执行上下文和局部执行上下文之间的区别

## Javascript如何执行您的代码?

通过查看Javascript内部功能，您将成为更好的Javascript开发人员，即使您无法掌握每一个细节。

现在，看看下面的代码：
```javascript
var num = 2;

function pow(num) {
    return num * num;
}
```
现在告诉我：你认为在浏览器里以何种顺序执行这段代码？

换句话说，如果您是浏览器，您将如何阅读该代码？

这听起来很简单。

大多数人认为“是的，浏览器执行功能pow并返回结果，然后将2分配给num。”

在接下来的部分中，您将发现那些看似简单的代码行背后的机制。

## Javascript引擎

要了解Javascript如何运行您的代码，我们应该遇到第一件可怕的事情：

执行上下文

在Javascript中什么是执行上下文？

每次在浏览器（或Node）中运行Javascript时，引擎都会执行一系列步骤。

其中一个步骤涉及创建全局执行上下文。

什么是引擎？

也就是说，Javascript引擎是运行Javascript代码的“引擎”。

如今有两个突出的Javascript引擎：Google V8和SpiderMonkey。

V8是Google开源的Javascript引擎，在Google Chrome和Nodejs中使用。

SpiderMonkey是Mozilla的JavaScript引擎，用于Firefox。

到目前为止，我们有Javascript引擎和执行上下文。

现在是时候了解它们如何协同工作了。

## 它是如何工作的？

每次运行一些Javascript代码是，引擎都会创造一个全局执行上下文。

执行上下文是一个比喻的词，用于描述运行Javascript代码的环境。

我觉得你很难想象出这些抽象的东西。

现在将全局执行上下文视为一个框：

![](http://cdn.rnode.me/images/20181009/javascript-what-is-global-execution-context-1-768x432.png)

让我们再看看我们的代码：

```javascript
var num = 2;

function pow(num) {
    return num * num;
}
```

引擎如何读取该代码？

这是一个简化版本：

引擎：第一行，它是变量！让我们将它存储在全局存储器中。

引擎：第三行，我看到了一个函数声明。让我们也把它存储在全局存储器中。

引擎：看起来我已经完成了。

如果我再次问你：浏览器如何“看到”以下代码，你会怎么说？

是的，它有点自上而下......

正如你所看到的那样，引擎没有运行功能pow！

这是一个函数声明，而不是函数调用。

上面的代码将转换为存储在全局存储器中的一些值：函数声明和变量。

全局存储器？

我已经对执行上下文感到困惑，现在还要问我什么是全局存储器？

接下来让我们看看什么是全局存储器

## 全局存储器

Javascript引擎也有一个全局存储器。

全局内存包含全局变量和函数声明供以后使用。

如果您阅读Kyle Simpson的“作用域和闭包”，您可能会发现全局存储器与全局作用域的概念重叠。

实际上它们是一回事。

这是些很难得概念。

但你现在不应该担心。

我希望你能理解我们难题的两个重要部分。

当Javascript引擎运行您的代码时，它会创建：

* 全局执行上下文
* 全局存储器（也称为全局作用域或全局变量环境）

一切都清楚了吗？

如果我在这一点上，我会：
* 写下一些Javascript代码
* 当你是引擎时，一步一步地解析代码
* 在执行期间创建全局执行上下文和全局存储器的图形表示

您可以在纸上或使用原型制作工具编写练习。

对于我的小例子，图片看起来如下：

![](http://cdn.rnode.me/images/20181009/javascript-global-execution-context-global-memory-768x432.png)

在下一节中，我们将看另一个可怕的事情：调用栈。

## 什么是调用栈？

您是否清楚地了解了执行上下文，全局存储器和Javascript引擎如何组合在一起？

如果没有，花时间查看上一节。

我们将在我们的难题中介绍另一篇文章：调用栈。

让我们首先回顾一下Javascript引擎运行代码时会发生什么。 它创建：
* 全局执行上下文
* 全局存储器

除了我们的例子，没有更多的事情发生：

```javascript
var num = 2;

function pow(num) {
    return num * num;
}
```

代码是纯粹的值分配。

让我们更进一步。

如果我调用该函数会发生什么？

```javascript
var num = 2;

function pow(num) {
    return num * num;
}

var res = pow(num)
```

有趣的问题。

在Javascript中调用函数的行为使引擎寻求帮助。

这个帮助来自Javascript引擎的朋友：调用栈。

它听起来可能并不明显，但Javascript引擎需要跟踪发生的情况。

它依赖于调用栈。

什么是Javascript中的调用栈？

调用栈就像是程序当前执行的日志。

实际上它是一个数据结构：堆栈。

调用栈的工作原理是什么？

不出所料，它有两种方法：push和pop。

push是将某些东西放入堆栈的行为。

也就是说，当您在Javascript中运行函数时，引擎会将该函数push到调用堆栈中。

每个函数调用都被push到调用栈中。

push的第一件事是main()（或global()），它是Javascript程序执行的主要线程。

现在，上一张图片看起来像这样：

![](http://cdn.rnode.me/images/20181009/javascript-call-stack-768x432.png)

pop另一端是从堆栈中删除某些东西的行为。

当函数执行结束时，将从调用栈中pop出去。

我们的调用栈将如下所示：

![](http://cdn.rnode.me/images/20181009/javascript-call-stack-pop-715x1024.png)

现在？您已准备好从那里掌握每个Javascript概念。

请看下一部分。

## 局部执行上下文

到目前为止，一切似乎都很清楚。

我们知道Javascript引擎创建了一个全局执行上下文和一个全局存储器。

然后，当您在代码中调用函数时：

* Javascript引擎请求帮助
* 这个帮助来自Javascript引擎的朋友：调用栈
* 调用栈会跟踪代码中调用的函数

当你在Javascript中运行一个函数时，还有另一件事情发生。

首先，该功能出现在全局执行上下文中。

然后，另一个迷你上下文出现在函数旁边：

那个迷你上下文叫做局部执行上下文。

如果您注意到，在上一张图片中，全局存储器中会出现一个新变量：var res。

变量res的值首先是undefined。

然后，只要pow出现在全局执行上下文中，该函数就会执行并且res将获取其返回值。

在执行阶段，创建局部执行上下文以保存局部变量。

![](http://cdn.rnode.me/images/20181009/javascript-local-execution-context.png)

记住这一点。

了解全局和局部执行上下文是掌握作用域和闭包的关键。

## 总结

Javascript引擎创建执行上下文，全局存储器和调用栈。但是一旦你调用一个函数，引擎就会创建一个局部执行上下文。

经常被忽视的是，新的开发人员总是将Javascript内部视为神秘的东西。

然而，它们是掌握高级Javascript概念的关键。

如果你学习执行上下文，全局存储器和调用栈，那么Scope，Closures，Callbacks和其他东西将变得轻而易举。

特别是，理解调用堆栈是至关重要的。

一旦你想象它，所有的Javascript将开始有意义：你将最终理解为什么Javascript是异步的以及我们为什么需要回调。