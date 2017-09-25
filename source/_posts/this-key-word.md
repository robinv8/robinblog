---
title: this关键字
date: 2017-09-25 23:06:52
tags: javascript
categories: javascript核心知识
comment: true
origin: 2
author: 阮一峰
thumbnail: http://cdn.rnode.me/images/20170922/img2.png
---
# 涵义
this关键字是一个非常重要的语法点。毫不夸张地说，不理解它的含义，大部分开发任务都无法完成。

首先，this总是返回一个对象，简单说，就是返回属性或方法“当前”所在的对象。
```
this.property
```
上面代码中，this就代表property属性当前所在的对象。

下面是一个实际的例子。
```javascript
var person = {
  name: '张三',
  describe: function () {
    return '姓名：'+ this.name;
  }
};

person.describe()
// "姓名：张三"
```
上面代码中，this.name表示describe方法所在的当前对象的name属性。调用person.describe方法时，describe方法所在的当前对象是person，所以就是调用person.name。

由于对象的属性可以赋给另一个对象，所以属性所在的当前对象是可变的，即this的指向是可变的。
```javascript
var A = {
  name: '张三',
  describe: function () {
    return '姓名：'+ this.name;
  }
};

var B = {
  name: '李四'
};

B.describe = A.describe;
B.describe()
// "姓名：李四"
```
上面代码中，A.describe属性被赋给B，于是B.describe就表示describe方法所在的当前对象是B，所以this.name就指向B.name。

稍稍重构这个例子，this的动态指向就能看得更清楚。
```javascript
function f() {
  return '姓名：'+ this.name;
}

var A = {
  name: '张三',
  describe: f
};

var B = {
  name: '李四',
  describe: f
};

A.describe() // "姓名：张三"
B.describe() // "姓名：李四"
```
上面代码中，函数f内部使用了this关键字，随着f所在的对象不同，this的指向也不同。

只要函数被赋给另一个变量，this的指向就会变。
```javascript
var A = {
  name: '张三',
  describe: function () {
    return '姓名：'+ this.name;
  }
};

var name = '李四';
var f = A.describe;
f() // "姓名：李四"
```
上面代码中，A.describe被赋值给变量f，内部的this就会指向f运行时所在的对象（本例是顶层对象）。

再看一个网页编程的例子。
```
<input type="text" name="age" size=3 onChange="validate(this, 18, 99);">

<script>
function validate(obj, lowval, hival){
  if ((obj.value < lowval) || (obj.value > hival))
    console.log('Invalid Value!');
}
</script>
```
上面代码是一个文本输入框，每当用户输入一个值，就会调用onChange回调函数，验证这个值是否在指定范围。回调函数传入this，就代表传入当前对象（即文本框），然后就可以从this.value上面读到用户的输入值。

总结一下，JavaScript 语言之中，一切皆对象，运行环境也是对象，所以函数都是在某个对象之中运行，this就是这个对象（环境）。这本来并不会让用户糊涂，但是 JavaScript 支持运行环境动态切换，也就是说，this的指向是动态的，没有办法事先确定到底指向哪个对象，这才是最让初学者感到困惑的地方。

如果一个函数在全局环境中运行，那么this就是指顶层对象（浏览器中为window对象）。
```javascript
function f() {
  return this;
}

f() === window // true
```
上面代码中，函数f在全局环境运行，它内部的this就指向顶层对象window。

可以近似地认为，this是所有函数运行时的一个隐藏参数，指向函数的运行环境。
# 使用场合
this的使用可以分成以下几个场合。
1. 全局环境
在全局环境使用this，它指的就是顶层对象window。
```javascript
this === window // true

function f() {
  console.log(this === window); // true
}
```
上面代码说明，不管是不是在函数内部，只要是在全局环境下运行，this就是指顶层对象window。
2. 构造函数
构造函数中的this，指的是实例对象。
```javascript
var Obj = function (p) {
  this.p = p;
};

Obj.prototype.m = function() {
  return this.p;
};
```
上面代码定义了一个构造函数Obj。由于this指向实例对象，所以在构造函数内部定义this.p，就相当于定义实例对象有一个p属性；然后m方法可以返回这个p属性。
```javascript
var o = new Obj('Hello World!');

o.p // "Hello World!"
o.m() // "Hello World!"
```
3. 对象的方法
当 A 对象的方法被赋予 B 对象，该方法中的this就从指向 A 对象变成了指向 B 对象。所以要特别小心，将某个对象的方法赋值给另一个对象，会改变this的指向。

请看下面的代码。
```javascript
var obj ={
  foo: function () {
    console.log(this);
  }
};

obj.foo() // obj
```
上面代码中，obj.foo方法执行时，它内部的this指向obj。

但是，只有这一种用法（直接在obj对象上调用foo方法），this指向obj；其他用法时，this都指向代码块当前所在对象（浏览器为window对象）。
```javascript
// 情况一
(obj.foo = obj.foo)() // window

// 情况二
(false || obj.foo)() // window

// 情况三
(1, obj.foo)() // window

```
上面代码中，obj.foo先运算再执行，即使值根本没有变化，this也不再指向obj了。这是因为这时它就脱离了运行环境obj，而是在全局环境执行。

可以这样理解，在 JavaScript 引擎内部，obj和obj.foo储存在两个内存地址，简称为M1和M2。只有obj.foo()这样调用时，是从M1调用M2，因此this指向obj。但是，上面三种情况，都是直接取出M2进行运算，然后就在全局环境执行运算结果（还是M2），因此this指向全局环境。

上面三种情况等同于下面的代码。
```javascript
// 情况一
(obj.foo = function () {
  console.log(this);
})()
// 等同于
(function () {
  console.log(this);
})()

// 情况二
(false || function () {
  console.log(this);
})()

// 情况三
(1, function () {
  console.log(this);
})()
```
如果某个方法位于多层对象的内部，这时this只是指向当前一层的对象，而不会继承更上面的层。
```javascript
var a = {
  p: 'Hello',
  b: {
    m: function() {
      console.log(this.p);
    }
  }
};

a.b.m() // undefined
```
上面代码中，a.b.m方法在a对象的第二层，该方法内部的this不是指向a，而是指向a.b。这是因为实际执行的是下面的代码。
```javascript
var b = {
  m: function() {
   console.log(this.p);
};

var a = {
  p: 'Hello',
  b: b
};

(a.b).m() // 等同于 b.m()
```
如果要达到预期效果，只有写成下面这样。
```javascript
var a = {
  b: {
    m: function() {
      console.log(this.p);
    },
    p: 'Hello'
  }
};
```
如果这时将嵌套对象内部的方法赋值给一个变量，this依然会指向全局对象。
```javascript
var a = {
  b: {
    m: function() {
      console.log(this.p);
    },
    p: 'Hello'
  }
};

var hello = a.b.m;
hello() // undefined
```
上面代码中，m是多层对象内部的一个方法。为求简便，将其赋值给hello变量，结果调用时，this指向了顶层对象。为了避免这个问题，可以只将m所在的对象赋值给hello，这样调用时，this的指向就不会变。
```javascript
var hello = a.b;
hello.m() // Hello
```
(未完……)