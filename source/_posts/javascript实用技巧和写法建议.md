---
title: javascript实用技巧和写法建议
date: 2017-09-06 11:58:57
tags: javascript
categories: 随记
comment: true
author: 守候
origin: 2
thumbnail: http://cdn.rnode.me/images/article1.jpg
---
# 前言
从大学到现在，接触前端已经有几年了，感想方面，就是对于程序员而言，想要提高自己的技术水平和编写易于阅读和维护的代码，我觉得不能每天都是平庸的写代码，更要去推敲，去摸索和优化代码，总结当中的技巧，积极听取别人的建议，这样自己的技术水平会提高的更快。那么今天，我在这里就分享一下关于javascript方面的写作的实用技巧和建议，这些技巧和建议是我平常在开发项目上会用到的，希望能让大家学到知识，更希望能起到一个交流意见的作用，也就是说大家有什么好的技巧或者建议，欢迎分享，或者觉得我的想法存在什么问题，欢迎指出!

# 更短的数组去重写法
```javascript
[...new Set([2,"12",2,12,1,2,1,6,12,13,6])]
//[2, "12", 12, 1, 6, 13]
//es6的新特性
```
# 对象深浅拷贝
关于对象的深浅拷贝，我个人见解就是有一下几点：
1. 深拷贝和浅拷贝只针对像Object, Array这样的引用类型数据。

2. 浅拷贝是对对象引用地址进行拷贝，并没有开辟新的栈，也就是拷贝后的结果是两个对象指向同一个引用地址，修改其中一个对象的属性，则另一个对象的属性也会改变。

3. 深拷贝则是开启一个新的栈，两个对象对应两个不同的引用地址，修改一个对象的属性，不会改变另一个对象的属性。

## 浅拷贝
```javascript
var myInfo={name:'守候',sex:'男'};
```
![](http://cdn.rnode.me/images/a2-1.png)

```javascript
var newInfo=myInfo;
```
![](http://cdn.rnode.me/images/a2-2.png)
```javascript
newInfo.sex='女';
```
![](http://cdn.rnode.me/images/a2-3.png)
```javascript
console.log(myInfo)   //{name: "守候", sex: "女"}
```
## 假-深拷贝
假-深拷贝这个是自己随性命名的，大家看看就好，别当真！
```javascript
var myInfo={name:'守候',sex:'男'};
```
![](http://cdn.rnode.me/images/a2-4.png)
```javascript
var newInfo=Object.assign({},myInfo)
```
![](http://cdn.rnode.me/images/a2-5.png)
```javascript
newInfo.sex='女';
```
![](http://cdn.rnode.me/images/a2-6.png)
```javascript
console.log(myInfo)   //{name: "守候", sex: "男"}
console.log(myInfo)   //{name: "守候", sex: "女"}
```
## 真-深拷贝
真-深拷贝这个是自己随性命名的，大家看看就好，别当真！

看着深浅拷贝，区别写法很简单，但是那个上面的深拷贝写法是有问题的。看下面案例
```javascript
var arr=[{a:1,b:2},{a:3,b:4}]
var newArr=Object.assign([],arr)
//截断数组
newArr.length=1
console.log(newArr)//[{a:1,b:2}]
console.log(arr)//[{a:1,b:2},{a:3,b:4}]
//操作newArr，这里看着对arr没影响，实际上已经挖了一个坑，下面就跳进去
newArr[0].a=123
//修改newArr[0]这个对象，也是影响了arr[0]这个对象
console.log(arr[0])//{a: 123, b: 2}
```
为什么会这样呢，因为Object.assign并不是深拷贝，是披着深拷贝外衣的浅拷贝。最多也是Object.assign会课拷贝第一层的值，对于第一层的值都是深拷贝，而到第二层的时候就是 复制引用。类似的情况还有，slice方法和contact方法等。
要解决这个问题，就得自己封装方法！如下
```javascript
//利用递归来实现深拷贝，如果对象属性的值是引用类型（Array,Object），那么对该属性进行深拷贝，直到遍历到属性的值是基本类型为止。
function deepClone(obj){
  if(!obj&& typeof obj!== 'object'){
    return;
  }
  var newObj= obj.constructor === Array ? [] : {};
  for(var key in obj){
    if(obj[key]){
      if(obj[key] && typeof obj[key] === 'object'){
        newObj[key] = obj[key].constructor === Array ? [] : {};
        //递归
        newObj[key] = deepClone(obj[key]);
      }else{
        newObj[key] = obj[key];
      }
    }
  }
  return newObj;
}
var arr=[{a:1,b:2},{a:3,b:4}]
var newArr=deepClone(arr)
console.log(arr[0])//{a:1,b:2}
newArr[0].a=123
console.log(arr[0])//{a:1,b:2}
```
还有一个方法就是简单粗暴法，我现在在用的一个方法！原理很简单，就是先把对象转成字符串，再把字符串转成对象！也能实现同样效果
```javascript
var newArr2=JSON.parse(JSON.stringify(arr));
console.log(arr[0])//{a:1,b:2}
newArr2[0].a=123
console.log(arr[0])//{a:1,b:2}
```
上面所说的浅拷贝，真假深拷贝（自己随性命名的），这几种情况，在开发上都有可能要用到，至于要使用哪一种方式，视情况而定！
# 使用事件委托
一个简单的需求，比如想给ul下面的li加上点击事件，点击哪个li，就显示那个li的innerHTML。这个貌似很简单！代码如下！
```javascript
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <ul id="ul-test">
            <li>0</li>
            <li>1</li>
            <li>2</li>
            <li>3</li>
            <li>4</li>
            <li>5</li>
            <li>6</li>
            <li>7</li>
            <li>8</li>
            <li>9</li>
        </ul>
    </body>
    <script type="text/javascript">
        var oUl=document.getElementById("ul-test");
        var oLi=oUl.getElementsByTagName("li");
        for(var i=0,len=oLi.length;i<len;i++){
            oLi[i].addEventListener("click",function(){
                alert(this.innerHTML)
            })
        }
    </script>
</html>
```
很简单，这样就实现了，实际上这里有坑，也待优化！
1. for循环，循环的是li，10个li就循环10次，绑定10次事件，100个就循环了100次，绑定100次事件！
2. 如果li不是本来就在页面上的，是未来元素，是页面加载了，再通过js动态加载进来了，上面的写法是无效的，点击li是没有反应的！
所以就者需要用事件委托（即使不考虑上面的第二种情况，也是建议使用事件委托）！代码如下
```javascript
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <ul id="ul-test">
            <li>0</li>
            <li>1</li>
            <li>2</li>
            <li>3</li>
            <li>4</li>
            <li>5</li>
            <li>6</li>
            <li>7</li>
            <li>8</li>
            <li>9</li>
        </ul>
    </body>
    <script type="text/javascript">
        var oUl=document.getElementById("ul-test");
        oUl.addEventListener("click",function(ev){
            var ev=ev||window.event;
            var target=ev.target||ev.srcElement;
            //如果点击的最底层是li元素
            if(target.tagName.toLowerCase()==='li'){
                alert(target.innerHTML)
            }
        })
    </script>
</html>
```
这样写，即使是动态添加进来的li点击也有反应，还有一个就是ul只有一个，事件绑定在ul上，无论li多少个，都是添加一次事件！但是也是可能会有问题，如果li下面还有子元素，那么点击的时候，target可能不是li，而是鼠标点击那个位置的最底层元素！如下图，如果鼠标点击白色区域，那个target就是body元素,鼠标点击绿色区域target就是div元素，鼠标点击蓝色区域target就是ul，点击橙色就是li。

![](http://cdn.rnode.me/images/a2-7.png)
# 使用对象作为函数参数
大家试想下这样一个函数--函数接受几个参数，但是这几个参数都不是必填的，函数该怎么处理？是不是下面这样
```javascript
function personInfo(name,phone,card){
    ...
}
//以上函数，可以任意传参数。比如我想传card等于1472586326。这下是不是这样写
personInfo('','','1472586326')
```
有没有觉得上面写法奇怪，不太优雅？下面这里看着舒服一点！
```javascript
function personInfo(opt){
    ...
}
personInfo({card:'1472586326'})
```
再想一下，如果一个函数，参数很多，怎么处理？
```javascript
function test(arg1,arg2,arg3,arg4,arg5,arg6,arg7){
    ...
}
```
密集恐惧症复发没有复发？下面这样看着会舒服一点！
```javascript
function personInfo(opt){
    ...
}
```
最后再想一下，如果需求改了，操作函数也要改！函数也要增加一个参数。
```javascript
//原来函数
function personInfo(name,phone,card){
    ...
}
//修改后
function personInfo(name,age,phone,card){
    ...
}
```
这样就是参数修改一次，函数的参数就要修改一次！如果是用对象，就不会出现这样问题！
```javascript
//修改前后都是这样，变得是函数的操作内容和调用时候的传参！
function personInfo(opt){
    ...
}
```
看了上面的几个栗子，总结来说，就是当函数的参数不固定的时候，参数多(三个或者三个以上)的时候，建议用一个对象记录参数，这样会比较方便，也为以后如果参数要改留了条后路！
# 使用push和apply合并数组
合并数组这个已经是老生常谈的话题了，方法也是多种多样！
## contact
```javascript
var arr1=[1,2,3,4,5],arr2=[6,7,8,9,10];
arr1=arr1.concat(arr2)
console.log(arr1)//[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```
concat会一个全新的数组，表示arr1和arr2两个数组的组合，并让arr1和arr2不变。简单吧？
但如果arr1和arr2的长度都很长，那就产生了一个很长很长的数组，内存又被占用了那么多。
## for
```javascript
var arr1=[1,2,3,4,5],arr2=[6,7,8,9,10];
for(var i=0,len=arr2.length;i<len;i++){
    arr1.push(arr2[i])
}
console.log(arr1)//[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```
这里是往arr1循环添加arr2的元素，但是有一个情况，arr1的长度远小于arr2的长度，是不是循环arr1性能更好，循环次数更少。处理这个很简单，但是万一不知道arr1和arr2到底哪个长度更少呢？而且，for循环不够优雅！
## reduce
```javascript
var arr1=[1,2,3,4,5],arr2=[6,7,8,9,10];
arr1 = arr2.reduce( function(coll,item){
     coll.push( item );
     return coll;
 }, arr1 );
 console.log(arr1)//[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 ```
 逼格高了一点，而且用ES6的箭头函数还可以减少一些代码量，但它仍然需要一个函数，每个元素都需要调用一次。
 ## push.apply
 ```javascript
 var arr1=[1,2,3,4,5],arr2=[6,7,8,9,10];
 arr1.push.apply(arr1,arr2);
 console.log(arr1)//[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 ```
 这个是建议写法，逼格看着高，代码少，也不会产生新的数组，也不难理解，就是调用arr1.push这个函数实例的apply方法，同时把arr2当作参数传入，这样arr1.push这个方法就会遍历arr2数组的所有元素，达到合并的效果。相当于arr1.push.apply(arr1,[6,7,8,9,10]);，最后相当于arr1.push(6,7,8,9,10)
# toFixed保留整数
在开发上，经常会遇到最多保留多少位小数或者类似的问题，针对这个，使用toFixed可以很简单的解决问题，但是如果数据是要和后台交互的，而且后台存储的数据一般是保存数字类型，而使用toFixed后生成的是一个字符串，这下，就需要把toFixed生成的是一个字符串转成数字类型，转发很多。今天我说一个最简单--+。代码如下
```javascript
var a=123.36896335.toFixed(2)
console.log(a)//'123.37'
a=+a
console.log(a)//123.37
```
PS：a=a|0和~~a也可以实现，但是生成的是一个整数，如下
```javascript
var a=123.36896335.toFixed(2)
console.log(a)//'123.37'
a=a|0
console.log(a)//123
//---------------------------------分割线
var a=123.36896335.toFixed(2)
console.log(a)//'123.37'
a=~~a
console.log(a)//123
```
# 其它类型数据转布尔数据
其它类型数据转布尔数据
```javascript
console.log(!!'123')
//true
!!12
//true
!!-1
//true
!![]
//true
!!''
//false
!!null
//false
```
# 缓存变量
for循环缓存length
```javascript
var arr=[1,2,3,4,5,6]
for(var i=0,i<arr.length;i++){
    ...
}
//------------------------分割线
var arr=[1,2,3,4,5,6]
for(var i=0,len=arr.length;i<len;i++){
    ...
}
```
第一段就是每一次循环的时候，都要查询一次arr.length。第二段代码就是缓存了arr.length，每次对比len就好，理论上是第二段代码的写法比较好，性能比较高！但是随着浏览器的发展，这个细节的性能上的影响貌似远远小于预期，现在还是建议缓存！我写了下面的测试用例(谷歌浏览器测试)！
```javascript
var arr100=[], arr10000=[];
for(var i=0;i<100;i++){
    arr100.push(i)
}
for(var i=0;i<10000;i++){
    arr10000.push(i)
}
//缓存情况
function testCache(arr){
    console.time();
    for(var i=0;len=arr.length;i<len;i++){

    }
    console.timeEnd()
}
//不缓存情况
function testNoCache(arr){
    console.time();
    for(var i=0;len=arr.length;i<len;i++){

    }
    console.timeEnd()
}
testCache(arr100)//default: 0.007ms
testCache(arr10000)//default: 0.035ms
testNoCache(arr100)//default: 0.012ms
testNoCache(arr10000)//default: 0.109ms
//这只是一个最简单的数组，如果遍历的是一个nodeList（元素列表），效果可能会更明显。
```
## 元素事件
这里我用jquery来讲解，比较容易理解，原生js也是这个道理！如下代码
```javascript
$('.div1').click(function(){
   ...
})
//--------------------------分割线
var $div1=$('.div1');
$div1.click(function(){
   ...
})
```
上面的代码，改变的也是缓存了$('.div1')，但是这里就建议是第二种写法了，因为第一种点击一次就要查询一次.div1，Dom的操作还是能减少就减少！
# 使用innerHTML添加元素
比如有一个需求，往ul里面添加10个li，两种方法，如下代码
```javascript
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <ul id="ul-test">

        </ul>
    </body>
    <script type="text/javascript">
        var oUl=document.getElementById("ul-test");
        //createElement方式
        console.time();
        for(var i=0;i<10;i++){
            var oLi=document.createElement('li');
            oLi.innerHTML=i;
            oUl.appendChild(oLi);
        }
        console.timeEnd();
        //innerHTML方式
        console.time();
        var _html='';
        for(var i=0;i<10;i++){
            _html+='<li>'+i+'</li>'
        }
        oUl.innerHTML=_html;
        console.timeEnd();
    </script>
</html>
```
大家把代码用浏览器打开，发现基本是第二种方式更快，第8点也说了，DOM操作能少就少！第一种要操作10次DOM，第二种只需要操作1次DOM。还有一个就是，这个只是很简单的li,如果是下面的列表呢？用第一种方式，得createElement多少次，innerHTML多少次，appendChild多少次？代码多，各个节点的逻辑和嵌套关系也乱！用第二种方式就是一个拼接字符串的操作，比第一种方式好多了，如果用es6的模板字符串，就更简单了！

![](http://cdn.rnode.me/images/a2-8.png)
# 将参数转成数组
函数里的arguments，虽然拥有length属性，但是arguments不是一个数组，是一个类数组，没有push,slice等方法。有些时候，需要把arguments转成数组，转的方法也不止一个，推荐的是是下面的写法！
```javascript
var _arguments=Array.prototype.slice.apply(arguments)
```
# 函数节流
这里拿一个栗子说，比如mousemove,onscroll,onresize这些事件触发的时候，可能已经触发了60次事件，这样很消耗性能，而且实际上，我们并不需要这么频繁的触发，只要大约100毫秒触发一次就好！那么这样就需要函数节流了！

普通写法
```javascript
var count = 0;
function beginCount() {
    count++;
    console.log(count);
}
document.onmousemove = function () {
   beginCount();
};
```
效果

![](http://cdn.rnode.me/images/a2-9.gif)

节流写法

```javascript
var count = 0;
function beginCount() {
    count++;
    console.log(count);
}
function delayFn(method, thisArg) {
    clearTimeout(method.props);
    method.props = setTimeout(function () {
        method.call(thisArg)
    },100)
}
document.onmousemove = function () {
    delayFn(beginCount)
};
```

效果

![](http://cdn.rnode.me/images/a2-10.gif)
这种方式，其实是有问题的，在不断触发停下来等待100ms才开始执行，中间操作得太快直接无视。于是在网上找到下面这种方案！

第二种节流写法
```javascript
function delayFn2 (fn, delay, mustDelay){
     var timer = null;
     var t_start;
     return function(){
         var context = this, args = arguments, t_cur = +new Date();
         //先清理上一次的调用触发（上一次调用触发事件不执行）
         clearTimeout(timer);
         //如果不存触发时间，那么当前的时间就是触发时间
         if(!t_start){
             t_start = t_cur;
         }
         //如果当前时间-触发时间大于最大的间隔时间（mustDelay），触发一次函数运行函数
         if(t_cur - t_start >= mustDelay){
             fn.apply(context, args);
             t_start = t_cur;
         }
         //否则延迟执行
         else {
             timer = setTimeout(function(){
                 fn.apply(context, args);
             }, delay);
         }
     };
}
var count=0;
function fn1(){
    count++;
    console.log(count)
}
//100ms内连续触发的调用，后一个调用会把前一个调用的等待处理掉，但每隔200ms至少执行一次
document.onmousemove=delayFn2(fn1,100,200)
```

![](http://cdn.rnode.me/images/a2-11.gif)

# 小结
好了，关于我自己总结的一些实用技巧和建议，就到这里了！关于javascript的技巧和建议，这点大家还是要多看网上的资源，也要自己多总结，毕竟我自己总结的只是我自己发现的，只是冰山一角。但还是希望这篇文章能帮到大家，让大家学习到知识。当然，更希望的是能起到一个交流意见的作用。如果大家有什么建议，技巧。也欢迎分享。觉得我哪里写错了，写得不够好，也欢迎指出！让大家一起互相帮助，互相学习！


