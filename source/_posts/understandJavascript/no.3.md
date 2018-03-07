---
layout: "post"
title: "深入理解JavaScript系列（3）：constructor、prototype、_proto_ 详解"
date: "2018-03-05 14:41:44"
tag: javascript
categories: javascript核心知识
comment: true
origin: 2
author: 苹果小萝卜
thumbnail: http://cdn.rnode.me/images/20170919/article1.jpg
---
本文为了解决一下问题：
  * `_proto_`(实际原型)和`prototype`(原型属性)不一样！！！
  * `constructor`属性(原型对象中包含这个属性，实例当中也同样会继承这个属性)
  * `prototype`属性(`constructor.prototype`原型对象)
  * `_proto_`属性(实例指向原型对象的指针)

首先弄清楚几个概念：
# 什么是对象

若干属性的集合

# 什么是原型

原型是一个对象，其他对象可以通过它实现继承

# 哪些对象有原型

所有的对象在默认情况下都有一个原型，因为原型本身也是对象，所以每个原型自身又有一个原型(只有一个例外，默认的对象原型在原型链的顶端)

----
# constructor 属性
>`constuctor`属性始终指向创建当前对象的构造函数

```javascript
var arr=[1,2,3];
console.log(arr.constructor); //输出 function Array(){}
var a={};
console.log(arr.constructor);//输出 function Object(){}
var bool=false;
console.log(bool.constructor);//输出 function Boolean(){}
var name="hello";
console.log(name.constructor);//输出 function String(){}
var sayName=function(){}
console.log(sayName.constructor)// 输出 function Function(){}

//接下来通过构造函数创建instance
function A(){}
var a=new A();
console.log(a.constructor); //输出 function A(){}
```
以上部分解释了任何一个对象都有constuctor属性，指向创建这个对象的构造函数

# prototype属性

注意：prototype是每个`函数对象`都具有的属性，被称为原型对象，而`_proto_`属性才是每个对象才有的是属性，一但原型对象被赋予属性和方法，那么由相应的构造函数创建的实例会继承`prototype`上的属性和方法

```javascript
//constructor : A
//instance : a
function A(){}
var a=new A();

A.prototype.name="xl";
A.prototype.sayName=function(){
    console.log(this.name);
}

console.log(a.name);// "xl"
a.sayName();// "xl"

//那么由constructor创建的instance会继承prototype上的属性和方法
```
# constructor属性和prototype属性

每个函数都有`prototype`属性，而这个`prototype`的`constructor`属性会指向这个函数。

```javascript
function Person(name){
  this.name=name;
}
Person.prototype.sayName=function(){
  console.log(this.name);
}
var person=new Person('x1');
console.log(person.constructor); // function Person(){}
console.log(person.prototype.constructor); // function Person(){}
console.log(Person.constructor); // function Function(){}
```
如果我们的重写(重新定义)这个`Person.constructor`属性，那么`constructor`属性的指向就会发生改变了。

```javascript
Person.prototype={
  setName:function(){
    console.log(this.name);
  }
}
console.log(person.constructor==Person); // 输出 false (为什么会输出false后面讲)
console.log(Person.constructor==Person); //输出 false

console.log(Person.prototype.constructor); // 输出 function Object(){}
//这里为什么会输出function Object(){}
//还记得之前说过constructor属性始终指向创建当前对象的构造函数吗？

Person.prototype={
  sayName:function(){
    console.log(this.name)
  }
}
//这里实际上是对原型对象的重写
Person.prototype=new Object(){
  sayName:function(){
    console.log(this.name)
  }
}
// 看到了吧。现在Person.prototype.constructor属性实际上指向Object的。

// 那么我如何将constructor属性再次指向Person呢？

Person.prototype.constructor=Person;
```
接下来解释为什么，看下面的例子
```javascript
function Person(name){
  this.name=name;
}

var personOne=new Person('x1');

Person.prototype={
  sayName:function(){
    console.log(this.name);
  }
}
var personTwo=new Person('x2');
console.log(personOne.costructor==Person); // true
console.log(personTwo.constructor==Person); // false

// 大家可能会对这个地方产生疑惑？为何第二个会输出false,personTwo不也是由Person创建的吗？这个地方应该要输出true啊？
// 这里涉及到js里面的原型继承
// 这个地方是因为person实例继承了Person.prototype原型对象的所有的方法和属性，包括constructor属性。当Person.prototype的constructor发生变化的时候，相应的person实例上的constructor属性也会发生变化。所以第二个会输出false
// 当然第一个是输出true，因为改变构造函数的prototype属性是在personOne被创建出来之后。
```
接下解释`_proto_`和`prototype`属性
同样拿上面的代码来解释：
```javascript
function Person(name){
  this.name=name;
}
Person.prototype.sayName=function(){
  console.log(this.name);
}
var person=name Person('x1');
person.sayName(); //输出 x1
//constructor : Person
//instance : person
//prototype : Person.prototype
```
首先给构造函数的原型对象`Person.prototype`赋值`sayName`方法，由构造函数`Person`创建的实例`person`会继承原型对象上的`sayName`方法。
# 为什么会继承原型对象的方法？
因为ECMAscript的发明者为了简化这门语言，同时又保证继承性，采用了链式继承的方法。
由`constructor`创建的每个`instance`都有个`_proto_`属性，它指向`constructor.prototype`。那么`constructor.prototype`上定义的属性和方法都会被`instance`所继承
```javascript
function Person(name){
    this.name=name;
}
Person.prototype.sayName=function(){
    console.log(this.name);
}

var personOne=new Person("a");
var personTwo=new Person("b");

personOne.sayName(); // 输出  "a"
personTwo.sayName(); //输出 "b"

console.log(personOne.__proto__==Person.prototype); // true
console.log(personTwo.__proto__==Person.prototype); // true

console.log(personOne.constructor==Person); //true
console.log(personTwo.constructor==Person); //true
console.log(Person.prototype.constructor==Person); //true

console.log(Person.constructor); //function Function(){}
console.log(Person.__proto__.__proto__); // Object{}
```
![](http://cdn.rnode.me/images/20170919/article2.jpg)
