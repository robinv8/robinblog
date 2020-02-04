---
title: React 生命周期的打怪升级之路
date: 2020-01-20 23:48:00
origin: 1
categories: react
---

# React 生命周期的打怪升级之路

> 号外号外！走过路过千万不要错过！

截止目前为止 React 已经发布了 `v16.12.0` 版本, React 生命周期也是日常开发低头不见，抬头见的狗子，可惜狗子它变了。

## 改变原因

v16.3 版本之前， React 中的更新操作是同步的，这可能会导致性能问题。

举个例子，假如有一个庞大的模块里面嵌套超级多的组件，一旦最顶部的 render 方法执行了，然后依次执行组件的 render 方法，直到最底层组件。这个过程会导致主线程卡主。

官方为了解决这个问题，因此引入了 React Fiber，其解决思路是分片执行，一个更新过程被分为两个阶段(Phase)：第一个阶段 Reconciliation Phase 和第二阶段 Commit Phase。

在第一阶段 Reconciliation Phase，React Fiber 会找出需要更新哪些 DOM，这个阶段是可以被打断的；但是到了第二阶段 Commit Phase，那就一鼓作气把 DOM 更新完，绝不会被打断。

而这两个阶段也对应到不同的生命周期：

第一阶段

- componentWillMount
- componentWillReceiveProps
- shouldComponentUpdate
- componentWillUpdate

第二阶段

- componentDidMount
- componentDidUpdate
- componentWillUnmount

可以看看这个例子：[Fiber vs Stack Demo](https://claudiopro.github.io/react-fiber-vs-stack-demo/)

## 变更对比

以前：

![](http://cdn.rnode.me/images/20200120001848.png)

现在( v16.3 )：

![](http://cdn.rnode.me/images/20200120001707.png)

对比上下两张图，发现 React 废弃了以下方法：

- componentWillMount
- componentWillReceiveProps
- componentWillUpdate

这里需要说明一下：为了做到版本版本兼容 增加 `UNSAFE_componentWillMount`,`UNSAFE_componentWillReceiveProps`和`UNSAFE_componentWillUpdate`方法，新旧方法都能使用，但使用旧方法，开发模式下会有红色警告，在 React v17 更新时会彻底废弃。

新增了方法如下：

- getDerivedStateFromProps
- getSnapshotBeforeUpdate

## 阶段梳理

下面从三个阶段（挂载、更新、卸载）梳理下生命周期方法。

![](http://cdn.rnode.me/images/20200120002540.png)

### constructor 构造函数

执行的生命周期方法，如果需要做一些初始化操作，比如初始化 state, 反之则无需为 React 组件实现构造函数。

### getDerivedStateFromProps

当组件实例化的时候，这个方法替代了 componentWillMount()，而当接收到新的 props 时，该方法替代了 componentWillReceiveProps() 和 componentWillUpdate()。

```javascript
static getDerivedStateFromProps(nextProps, prevState)
```

其中 v16.3 版本中 re-rendering 之后此方法不会被调用，而 v16.4 版本中 re-rendering 之后都会调用此方法，这意味即使 props 未发生改变，一旦父组件发生 re-rendering 那么子组件的该方法依然会被调用。

### componentWillMount/UNSAVE_componentWillMount (即将废弃)

部分同学日常会把数据请求放在该方法内，以便于快速获取数据并展现，但事实上，请求再快再怎么快，也快不过首次 render，并且 React Fiber 执行机制的原因，会导致该方法被执行多次，这也意味着接口被请求多次。因此该方法在 v17 版本以后将被彻底废弃。

### componentDidMount

在组件挂载完成后调用，且全局只调用一次。可以在这里使用 refs，获取真实 dom 元素。该钩子内也可以发起异步请求，并在异步请求中可以进行 setState。

### componentWillReceiveProps/UNSAFE_componentWillReceiveProps (即将废弃)

被 getDerivedStateFromProps 方法取代。

### shouldComponentUpdate

每次调用 setState 后都会调用 shouldComponentUpdate 判断是否需要重新渲染组件。默认返回 true，需要重新 render。返回 false 则不触发渲染。在比较复杂的应用里，有一些数据的改变并不影响界面展示，可以在这里做判断，优化渲染效率。

### componentWillUpdate

依旧是 React Fiber 执行机制的原因，在该方法记录 DOM 状态就不再准确了。

### getSnapshotBeforeUpdate

触发该方法的时机，是在更新 DOM 之前的一瞬间，比 componentWillUpdate 记录的 DOM 状态更为精确。

### componentDidUpdate

除了首次 render 之后调用 componentDidMount，其它 render 结束之后都是调用 componentDidUpdate。

### componentWillUnmount

组件被卸载的时候调用。一般在 componentDidMount 里面注册的事件需要在这里删除。

## 总结

由于 React 同步更新组件的原因，会引起性能问题，造成主线程卡死，因此引入 React Fiber 对核心算法的一次重新实现。 紧接着发现， React Fiber 会让部分生命周期方法行多次，而废除这部分方法，引入新方法。

参考文章：

[React Fiber 是什么](https://zhuanlan.zhihu.com/p/26027085)

[React v16.3 之后的组件生命周期函数](https://zhuanlan.zhihu.com/p/38030418)

[浅谈 React Fiber 及其对 lifecycles 造成的影响](https://blog.techbridge.cc/2018/03/31/react-fiber-and-lifecycle-change/)

[讲讲今后 React 异步渲染带来的生命周期变化](https://juejin.im/post/5abf4a09f265da237719899d)

[React 新旧生命周期的思考理解](https://zhuanlan.zhihu.com/p/65124686)
