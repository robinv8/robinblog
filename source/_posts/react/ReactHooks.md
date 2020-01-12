---
title: React Hooks学习笔记
date: 2020-01-12 23:48:00
origin: 1
categories: react
---

# React Hooks 学习笔记

看了一篇文章，也说清了 React 发展历程，我一直都坚信任何技术方案的出现都是为了以更好的方式解决问题。

## React 组件发展历程

React 组件基本可以归结三个阶段：

- createClass Components
- Class Components
- Function Components

### createClass Components

示例：

```javascript
const Index = React.createClass({
  getDefaultProps() {
    return {};
  },
  getInitialState() {
    return {
      name: "robin"
    };
  },
  render() {
    return <div></div>;
  }
});
```

这是早期创建组建的方式，我想当时 JavaScript 还没有内置的类系统。当 ES6 到来的时候，这一切都改变了。

### Class Components

示例：

```javascript
class Index extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "robin"
    };
  }

  render() {
    return <div></div>;
  }
}
```

初始化属性及状态的方式随之发生了变化，这里或许会有疑问，createClass 用的好好地，为什么还要使用以 Class 继承的方式编写组件，我想应该是为了迎合 ES 的发展。

随着项目的的复杂度提升，如果项目中全部使用类的方式开发组件是不是有点重，这个时候它来了。

### Function Components

示例：

```javascript
const Button = props => {
  return <div></div>;
};
```

我只是要封装个公共组件，用它就够。

夜黑风熬夜，组件开发时……

![](https://tva1.sinaimg.cn/large/006tNbRwly1gau6hqd4rbj309008ot8l.jpg)

想这种复合型组件就需要状态的介入，但是又犯不着使用类组件，因此诞生了 React Hooks

## React Hooks 介绍

- useState()
- useContext()
- useReducer()
- useEffect()

### useState

如果需要操作状态，代码如下：

```javascript
import React, { useState } from "react";

export default function TextInput() {
  const [name, setName] = useState("");

  return <input value={name} onChange={e => setName(e.target.value)} />;
}
```

### useContext

如果需要共享状态，代码如下：

```javascript
const AppContext = React.createContext({});

const Button1 = () => {
  const { name } = useContext(AppContext);
  return <div>{name}</div>;
};
const Button2 = () => {
  const { name, age } = useContext(AppContext);

  return (
    <div>
      {name}
      {age}
    </div>
  );
};

const Button3 = () => {
  const [name, setName] = useState("robin111");
  return (
    <AppContext.Provider
      value={{
        name: name,
        age: 29
      }}
    >
      <Button1 />
      <Button2 />
      <button onClick={() => setName("test")}>211</button>
    </AppContext.Provider>
  );
};
```

当共享状态组件嵌套时，当前的 context 值由上层组件中距离当前组件最近的 <AppContext.Provider> 的 value prop 决定。

### useReducer

Redux 提供了状态管理方案，在这里你也可以使用 useReducer。

```javascript
const [state, dispatch] = useReducer(reducer, initialArg, init);
```

借鉴了阮一峰老师的计数器实例：

```javascript
const myReducer = (state, action) => {
  switch (action.type) {
    case "countUp":
      return {
        ...state,
        count: state.count + 1
      };
    default:
      return state;
  }
};

function App() {
  const [state, dispatch] = useReducer(myReducer, { count: 0 });
  return (
    <div className="App">
      <button onClick={() => dispatch({ type: "countUp" })}>+1</button>
      <p>Count: {state.count}</p>
    </div>
  );
}
```

### useEffect

官方描述：Effect Hook 可以让你在函数组件中执行副作用操作。

```javascript
import React, { useState, useEffect } from "react";

function Example() {
  const [count, setCount] = useState(0);
  useEffect(() => {
    document.title = `You clicked ${count} times`;
  });

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </div>
  );
}
```

这段代码是官方提供的，简洁明了。

官方在 Effect 方面介绍的很详细，强烈推荐大家详读。[中文社区详解](https://zh-hans.reactjs.org/docs/hooks-effect.html)

### 自定义 Hooks

自定义的目的，是为了封装重复逻辑，共享逻辑，既然是自定义 Hooks，也不是简单函数封装，当然被封装的逻辑代码中也需要包含官方提供的 Hook 方案，方能凑效。[中文社区详解](https://zh-hans.reactjs.org/docs/hooks-custom.html)

## 总结

刚开始在项目中使用，还未能深入使用，只能列举目前能用到的示例代码，自定义 Hooks,在我看来是对 Hooks 的重构升级。

参考文章：

- [为什么会出现 React Hooks?][3]
- [Hook 简介][1]
- [React Hooks 入门教程][2]

[1]: https://zh-hans.reactjs.org/docs/hooks-intro.html
[2]: https://www.ruanyifeng.com/blog/2019/09/react-hooks.html
[3]: https://juejin.im/post/5d478b2d518825673a6ae1b9
[4]: http://www.imooc.com/article/2235
[5]: https://coolshell.cn/articles/6840.html
