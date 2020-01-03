---
title: 高阶组件
date: 2020-01-03 21:48:00
origin: 1
categories: react
---

## 首次使用场景

项目初期只有一个添加商品模块，因业务迭代，从多图商品中分离出视频商品，当前存在的问题：

1. 版本迭代势必势必同时修改两个模块；
2. 大量逻辑，方法重复。

## 方案筛选

鉴于以上问题，寻找的解决方案有：

1. 公共逻辑代码抽离；
2. 公共容器组件抽离；
3. Mixin;
4. 高阶组件。

公共逻辑抽离方案，公共逻辑中包含了 state、props、以及 setState,如果提取公共逻辑代码，势必重新处理相关状态，对原有模块破坏性大。

公共容器组件方案，合并两个模块公共部分，把上传部分分离成多图上传组件，视频上传组件，通过传入参数区分类型，也就意味着合并路由名称，添加参数区分，修改成本高。

Mixin 方案，但其方案存在缺陷。[详情，看这里](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html)

最后能选择的最优方案就是高阶组件，侵入性小，函数式思想（同样的输入，返回同样的输出、可预测性强），

## 概念介绍

### 高阶函数

其满足高阶函数的至少两个条件：

- 接受一个或多个函数作为输入
- 输出一个函数

### 高阶组件

定义：类比高阶函数的定义，高阶组件就是接受一个组件作为参数，在函数中对组件做一系列的处理，随后返回一个新的组件作为返回值。

## 高阶组件解读

示例 1 (属性代理模式)

```
const HOC = (WrappedComponent) => {
  return class extends Component {
    render() {
      return <WrappedComponent {...this.props}/>
    }
  }
}
```

示例 2 (反向继承模式)

```
const HOC = (WrappedComponent) => {
  return class extends WrappedComponent {
    render() {
      return super.render();
    }
  }
}
```

what? 属性代理、反向继承，继承就算了，怎么还反向继承，别急放下看

### 属性代理

简单讲就是包裹组件，操作 props，基本上组件嵌套、传参什么的都干过。

上代码

```
const HOC = (WrappedComponent) => {
  return class extends Component {
    render() {
      return <WrappedComponent {...this.props}/>
    }
  }
}

class WrappedComponent extends Component{
    render(){
        //....
    }
}

//高阶组件使用
export default HOC(WrappedComponent)
```

#### 属性操作

上代码

```
const HOC = (WrappedComponent) => {
  return class extends Component {
    render() {
    	const newProps = {
    		name: "HOC"
    	}
      return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}

class WrappedComponent extends Component{
    render(){
        //....
    }
}

//高阶组件使用
export default HOC(WrappedComponent)
```

组件传参基本都干过

#### refs 引用

```
const HOC = (WrappedComponent) => {
  return class extends Component {
    render() {
      return <WrappedComponent ref={this.onRef} {...this.props}/>
    }
  }
}
```

基本上都这个干过，使用组件实例方法。

#### 抽象 State

上代码

```
const HOC = (WrappedComponent) => {
  return class extends Component {
  	onChange = (data = {}) => {
  		this.setState(data)
  	}
    render() {
    	const {name = ''} = this.state;
    	const newProps = {
    		name: {
    			value: name,
    			onChange: (e)=>this.onChange({name: e.target.value})
			}
    	}
    	return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}

class WrappedComponent extends Component{
    render(){
    	const {name} = this.props;
       return <input {...name} />
    }
}

//高阶组件使用
export default HOC(WrappedComponent)
```

细细品味上面写法的精髓，当你需要操作大量表单的时候，会发现它的好。

刚开始没理解抽象 State 的含义，通过写笔记搞明白了，就是把需要在原组件，通过 state 动态赋值的操作，抽象到高阶组件中通过 props 传值。

总结： 属性代理的模式，跟平常写组件的模式差不多，只不过加了些技巧。

### 反向继承

再看看上面的示例

```
const HOC = (WrappedComponent) => {
  return class extends WrappedComponent {
    render() {
      return super.render();
    }
  }
}
```

`super.render()`这种模式只在 es6 类继承的时候通过`super.method()`，用在这里实在是妙。

从写法上看，继承了传入组件，使用`super.render()`自然是执行了传入组件的 render 方法，也就是渲染了传入组件对应的页面，有趣的事情开始了。

#### 操作 state 以及 props。

操作 state,我理解，但操作 props，什么鬼，直到看到这样一段代码：

```
//该例子来源于 React 高阶组件(HOC)入门指南 掘金
const HOCFactoryFactory = (...params) => {
    // 可以做一些改变 params 的事
    return (WrappedComponent) => {
        return class HOC extends Component {
            render() {
                return <WrappedComponent {...this.props} />;
            }
        }
    }
}

HOCFactoryFactory(params)(WrappedComponent)

//类似场景 redux
connect(params)(Index)
```

又明白了。

#### 渲染劫持

别人写的代码

```
//例子来源于《深入React技术栈》

const HOC = (WrappedComponent) =>
    class extends WrappedComponent {
        render() {
            const elementsTree = super.render();
            let newProps = {};
            if (elementsTree && elementsTree.type === 'input') {
                newProps = {value: 'may the force be with you'};
            }
            const props = Object.assign({}, elementsTree.props, newProps);
            const newElementsTree = React.cloneElement(elementsTree, props, elementsTree.props.children);
            return newElementsTree;
    }
}
class WrappedComponent extends Component{
    render(){
        return(
            <input value={'Hello World'} />
        )
    }
}
export default HOC(WrappedComponent)
```

跟操作 DOM 差不多（个人理解），目前没有用到这个的场景，不做赘述。

高阶组件基本使用场景介绍完了，回到正题，聊聊，我在实际项目中是怎么用的。

说几个数据：

**改造模块前**：

多图商品模块代码，900 行。视频商品模块代码，1000 行

**改造模块后**：

多图商品模块代码，554 行。视频商品模块代码，650 行

抽离出的高阶组件代码 387 行

当前水平只能到这一步了。

我采用了反向继承的方案，属性代理，只能满足操作 props，但不能操作 state,大家或许会有疑问，人家不是可以抽象 state，是的，瞅清楚，是抽象不是操作。

还有就是没办法属性代理没办法使用原组件静态方法。大神提供了批量复制静态方法的库`hoist-non-react-statics`

最终满足我操作 props，尤其是操作 state 的可行性方案，就是高阶组件的反向继承。

目前研究学习并实践的内容就到这里了，如果后续有补充的，也会持续更新。
