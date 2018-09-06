---
title: 深入理解JavaScript系列—编写高质量JavaScript代码的基本要点
date: 2018-01-22 11:54:44
tags: javascript
categories: javascript核心知识
comment: true
author: 汤姆大叔
origin: 2
---
良好的代码编写习惯，是减少bug，以及提升代码的可读性、扩展性都是非常有效的，这系列是在看汤姆大叔[深入理解JavaScript系列](http://www.cnblogs.com/TomXu/archive/2011/12/15/2288411.html)做的一下总结。

## 书写可维护的代码(Writing Maintainable Code)
修改bug的代价是沉重的，随着时间的推移，这代价也会随之加重，要想了解历史遗留的某个bug你需要：
- 花时间学习和理解这个问题
- 花时间了解怎么解决这个问题

还有，对于大项目来说，修复bug和写代码的不是同一个人，这代价可想而知，谁都想学习新技能，有谁愿意一直围着一堆bug，因此可维护代码是非常有必要的，可维护代码意味着：
- 可读性
- 一致性
- 可预测性
- 看上去想一个人写的

## 最小全局变量(Minimizing Globals)
全局变量的问题在于，你的JavaScript应用程序和web页面上的所有代码都共享了这些全局变量，当在程序的两个不同部分定义了同名但不同作用的全局变量的时候，命名冲突在所难免。

web页面包含不是该页面开发者所写的代码也是比较常见的，比如：

- 第三方的JavaScript库
- 广告方的脚本代码
- 第三方用户跟踪和分析脚本的代码

在这里注意声明变量却忘记使用var关键字，会隐式的创建全局变量。

## 单var形式(Single var Pattern)
在函数顶部使用单var语句是比较有用的一种形式，其好处在于：
- 提供单一的地方去寻找功能所需要的所有局部变量
- 防止变量在定义之前使用的逻辑错误
- 帮助你记住声明的是局部变量，因此减少了全局变量
- 少代码

```javascript
function func() {
   var a = 1,
       b = 2,
       sum = a + b,
       myobject = {},
       i,
       j;
   // function body...
}
```

## for循环(for Loops)
```javascript
for (var i = 0; i < myarray.length; i++) {
   // 使用myarray[i]做点什么
}
```
这种循环的不足蜘蛛在于每次循环的时候数组的长度都要去获取一下，这回降低你的代码的执行效率，尤其当maarray不是数组，而是个HTMLCollection对象的时候。

HTMLCollection指的是DOM方法的返回对象，例如：
```javascript
document.getElementsByName()
document.getElementsByClassName()
document.getElementsByTagName()

```
复杂的网页dom的层级是很多的，获取长度就意味着你要实时查询DOM,而DOM的操作一般都是比较昂贵的。

这就是为什么当你循环获取值时，缓存数组或集合的长度是比较好的形式，正如下面代码显示的：

```javascript
for (var i = 0, max = myarray.length; i < max; i++) {
   // 使用myarray[i]做点什么
}
```
这样，在循环过程中，只检索一次长度值。

## for-in循环(for-in Loops)

for-in循环应该用在非数组对象的遍历上，使用for-in进行循环也被称之为“枚举”。

从技术上讲，你可以使用for-in循环数组(因为JavaScript中数组也是对象)，但这是不推荐，因为如果数组对象已经被自定义的功能增强，就可能发生逻辑错误。另外，在for-in中，属性列表的顺序是不能被保证的。所以最好数组使用正常的for循环，对象使用for-in循环。

有个很重要的hasOwnProperty()方法，当遍历对象属性的时候可以过滤掉从原型链上的属性。

思考下面一段代码：
```javascript
// 对象
var man = {
   hands: 2,
   legs: 2,
   heads: 1
};

// 在代码的某个地方
// 一个方法添加给了所有对象
if (typeof Object.prototype.clone === "undefined") {
   Object.prototype.clone = function () {};
}
```
在这个例子中，我们定义了字面量对象man,然后在对象原型上增加了名为clone的方法。此原型链是实时的，这就意味着所有的对象自动可以访问新的方法。
为了避免枚举man的时候出现clone方法。你需要应用hasOwnProerty()方法过滤原型属性。如果不做过滤，会导致clone函数显示出来，大多数情况下这是不希望出现。
```javascript
// 1.
// for-in 循环
for (var i in man) {
   if (man.hasOwnProperty(i)) { // 过滤
      console.log(i, ":", man[i]);
   }
}
/* 控制台显示结果
hands : 2
legs : 2
heads : 1
*/
// 2.
// 反面例子:
// for-in loop without checking hasOwnProperty()
for (var i in man) {
   console.log(i, ":", man[i]);
}
/*
控制台显示结果
hands : 2
legs : 2
heads : 1
clone: function()
*/
```
另外一种使用hasOwnProperty()的形式是取消Object.property上的方法：
```javascript
for (var i in man) {
   if (Object.prototype.hasOwnProperty.call(man, i)) { // 过滤
      console.log(i, ":", man[i]);
   }
}
```

其好处在于man对象重新定义hasOwnProperty情况下避免命名冲突。也避免了长属性对象的所有方法，你可以使用局部变量缓存它。
```javascript
var i, hasOwn = Object.prototype.hasOwnProperty;
for (i in man) {
    if (hasOwn.call(man, i)) { // 过滤
        console.log(i, ":", man[i]);
    }
}
```
> 严格来说，不使用hasOwnProperty()并不是一个错误。根据任务以及你对代码的自信程度，你可以跳过它以提高些许的循环速度。但是当你对当前对象内容（和其原型链）不确定的时候，添加hasOwnProperty()更加保险些。

## （不）扩展内置原型((Not) Augmenting Built-in Prototypes)

扩增构造函数的prototype属性是个很强大的增加功能的方法，但有时候它太强大了。

增加内置的构造函数原型（如Object(), Array(), 或Function()）挺诱人的，但是这严重降低了可维护性，因为它让你的代码变得难以预测。使用你代码的其他开发人员很可能更期望使用内置的 JavaScript方法来持续不断地工作，而不是你另加的方法。

另外，属性添加到原型中，可能会导致不使用hasOwnProperty属性时在循环中显示出来，这会造成混乱。

因此，不增加内置原型是最好的。你可以指定一个规则，仅当下面的条件均满足时例外：
* 可以预期将来的ECMAScript版本或是JavaScript实现将一直将此功能当作内置方法来实现。例如，你可以添加ECMAScript 5中描述的方法，一直到各个浏览器都迎头赶上。这种情况下，你只是提前定义了有用的方法。
* 如果您检查您的自定义属性或方法已不存在——也许已经在代码的其他地方实现或已经是你支持的浏览器JavaScript引擎部分。
* 你清楚地文档记录并和团队交流了变化。

如果这三个条件得到满足，你可以给原型进行自定义的添加，形式如下：
```javascript
if (typeof Object.protoype.myMethod !== "function") {
   Object.protoype.myMethod = function () {
      // 实现...
   };
}
```
## 避免隐式类型转换(Avoiding Implied Typecasting)
JavaScript的变量在比较的时候会隐式类型转换。这就是为什么一些诸如：false == 0 或 “” == 0 返回的结果是true。为避免引起混乱的隐含类型转换，在你比较值和表达式类型的时候始终使用===和!==操作符。

```javascript
var zero = 0;
if (zero === false) {
   // 不执行，因为zero为0, 而不是false
}

// 反面示例
if (zero == false) {
   // 执行了...
}
```
还有另外一种思想观点认为==就足够了===是多余的。例如，当你使用typeof你就知道它会返回一个字符串，所以没有使用严格相等的理由。然而，JSLint要求严格相等，它使代码看上去更有一致性，可以降低代码阅读时的精力消耗。（“==是故意的还是一个疏漏？”）

## parseInt()下的数值转换(Number Conversions with parseInt())

使用parseInt()你可以从字符串中获取数值，该方法接受另一个基数参数，这经常省略，但不应该。当字符串以”0″开头的时候就有可能会出问 题，例如，部分时间进入表单域，在ECMAScript 3中，开头为”0″的字符串被当做8进制处理了，但这已在ECMAScript 5中改变了。为了避免矛盾和意外的结果，总是指定基数参数。

```javascript
var month = "06",
    year = "09";
month = parseInt(month, 10);
year = parseInt(year, 10);
```
此例中，如果你忽略了基数参数，如parseInt(year)，返回的值将是0，因为“09”被当做8进制（好比执行 parseInt( year, 8 )），而09在8进制中不是个有效数字。

替换方法是将字符串转换成数字，包括：
```javascript
+"08" // 结果是 8
Number("08") // 8
```
这些通常快于parseInt()，因为parseInt()方法，顾名思意，不是简单地解析与转换。但是，如果你想输入例如“08 hello”，parseInt()将返回数字，而其它以NaN告终。
## 编码规范(coding Conventions)
建立和遵循编码规范是很重要的，这让你的代码保持一致性，可预测，更易于阅读和理解。一个新的开发者加入这个团队可以通读规范，理解其它团队成员书写的代码，更快上手干活。

许多激烈的争论发生会议上或是邮件列表上，问题往往针对某些代码规范的特定方面（例如代码缩进，是Tab制表符键还是space空格键）。如果你是 你组织中建议采用规范的，准备好面对各种反对的或是听起来不同但很强烈的观点。要记住，建立和坚定不移地遵循规范要比纠结于规范的细节重要的多。
## 命名规范(Naming Conventions)
另一种方法让你的代码更具可预测性和可维护性是采用命名规范。这就意味着你需要用同一种形式给你的变量和函数命名。

下面是建议的一些命名规范，你可以原样采用，也可以根据自己的喜好作调整。同样，遵循规范要比规范是什么更重要。
## 以大写字母写构造函数(Capitalizing Constructors)
JavaScript并没有类，但有new调用的构造函数：
```javascript
var adam = new Person();
```
因为构造函数仍仅仅是函数，仅看函数名就可以帮助告诉你这应该是一个构造函数还是一个正常的函数。

命名构造函数时首字母大写具有暗示作用，使用小写命名的函数和方法不应该使用new调用：
```javascript
function MyConstructor() {...}
function myFunction() {...}
```
## 分隔单词(Separating Words)
当你的变量或是函数名有多个单词的时候，最好单词的分离遵循统一的规范，有一个常见的做法被称作“驼峰(Camel)命名法”，就是单词小写，每个单词的首字母大写。

对于构造函数，可以使用大驼峰式命名法(upper camel case)，如MyConstructor()。对于函数和方法名称，你可以使用小驼峰式命名法(lower camel case)，像是myFunction(), calculateArea()和getFirstName()。

要是变量不是函数呢？开发者通常使用小驼峰式命名法，但还有另外一种做法就是所有单词小写以下划线连接：例如，first_name, favorite_bands, 和 old_company_name，这种标记法帮你直观地区分函数和其他标识——原型和对象。

ECMAScript的属性和方法均使用Camel标记法，尽管多字的属性名称是罕见的（正则表达式对象的lastIndex和ignoreCase属性）。
## 其它命名形式(Other Naming Patterns)
有时，开发人员使用命名规范来弥补或替代语言特性。

例如，JavaScript中没有定义常量的方法（尽管有些内置的像Number, MAX_VALUE），所以开发者都采用全部单词大写的规范来命名这个程序生命周期中都不会改变的变量，如：
```javascript
// 珍贵常数，只可远观
var PI = 3.14,
    MAX_WIDTH = 800;
```
还有另外一个完全大写的惯例：全局变量名字全部大写。全部大写命名全局变量可以加强减小全局变量数量的实践，同时让它们易于区分。

另外一种使用规范来模拟功能的是私有成员。虽然可以在JavaScript中实现真正的私有，但是开发者发现仅仅使用一个下划线前缀来表示一个私有属性或方法会更容易些。考虑下面的例子：
```javascript
var person = {
    getName: function () {
        return this._getFirst() + ' ' + this._getLast();
    },

    _getFirst: function () {
        // ...
    },
    _getLast: function () {
        // ...
    }
};
```
在此例中，getName()就表示公共方法，部分稳定的API。而_getFirst()和_getLast()则表明了私有。它们仍然是正常的公共方法，但是使用下划线前缀来警告person对象的使用者这些方法在下一个版本中时不能保证工作的，是不能直接使用的。注意，JSLint有些不鸟下划线前缀，除非你设置了noman选项为:false。

下面是一些常见的_private规范：

使用尾下划线表示私有，如name_和getElements_()
使用一个下划线前缀表_protected（保护）属性，两个下划线前缀表示__private （私有）属性
Firefox中一些内置的变量属性不属于该语言的技术部分，使用两个前下划线和两个后下划线表示，如：__proto__和__parent__。
## 注释(Writing Comments)
你必须注释你的代码，即使不会有其他人向你一样接触它。通常，当你深入研究一个问题，你会很清楚的知道这个代码是干嘛用的，但是，当你一周之后再回来看的时候，想必也要耗掉不少脑细胞去搞明白到底怎么工作的。

很显然，注释不能走极端：每个单独变量或是单独一行。但是，你通常应该记录所有的函数，它们的参数和返回值，或是任何不寻常的技术和方法。要想到注 释可以给你代码未来的阅读者以诸多提示；阅读者需要的是（不要读太多的东西）仅注释和函数属性名来理解你的代码。例如，当你有五六行程序执行特定的任务， 如果你提供了一行代码目的以及为什么在这里的描述的话，阅读者就可以直接跳过这段细节。没有硬性规定注释代码比，代码的某些部分（如正则表达式）可能注释 要比代码多。
> 最重要的习惯，然而也是最难遵守的，就是保持注释的及时更新，因为过时的注释比没有注释更加的误导人。
## 关于作者（About the Author ）

Stoyan Stefanov是Yahoo!web开发人员，多个O'Reilly书籍的作者、投稿者和技术评审。他经常在会议和他的博客[www.phpied.com](http://www.phpied.com)上发表web开发主题的演讲。Stoyan还是smush.it图片优化工具的创造者，YUI贡献者，雅虎性能优化工具YSlow 2.0的架构设计师。


本文转自：http://www.cnblogs.com/TomXu/archive/2011/12/28/2286877.html
英文原文：http://net.tutsplus.com/tutorials/javascript-ajax/the-essentials-of-writing-high-quality-javascript/
