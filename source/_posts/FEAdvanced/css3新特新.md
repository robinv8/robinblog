---
title: 前端进阶系列—css3新特性
date: 2018-09-10 20:2-:57
tags: [html,css,javascript,html5]
categories: [前端进阶系列]
comment: true
origin: 1
---

## 什么是CSS?

层叠样式表（CSS）是一种向Web文档添加样式（例如，字体，颜色，间距）的简单机制。

## 什么是CSS3?
CSS3是CSS语言的最新发展，旨在扩展CSS2.1。它带来了许多新功能和附加功能，如圆角，阴影，渐变，过渡或动画，以及多列，灵活的框或网格布局等新布局。

## 现在让我们看看有哪些新东西？

### CSS3选择器

选择器是CSS的核心。最初，CSS允许按类型，类和/或ID匹配元素。CSS2.1添加了伪元素，伪类和组合子。使用CSS3，我们可以使用各种选择器来定位页面上的几乎任何元素。

CSS2引入了几个属性选择器。这些允许基于其属性匹配元素。 CSS3扩展了那些属性选择器。在CSS3中添加了三个属性选择器;它们允许子串选择。

1. 匹配属性attr以值val开头的任何元素E.换句话说，val匹配属性值的开头。

```
E[attr^=val]
eg.          a[href^='http://sales.']{color: teal;}
```

2. 匹配属性attr以val结尾的任何元素E.换句话说，val匹配属性值的结尾。

```
E[attr$=val]
eg.          a[href$='.jsp']{color: purple;}
```

3. 匹配属性attr在属性中的任何位置匹配val的任何元素E.它类似于E [attr~ = val]，在这里val可以是单词也可以是单词的一部分。

```
E[attr*=val]  
eg.         img[src*='artwork']{
                    border-color: #C3B087 #FFF #FFF #C3B087;
                               }
```

### Pseudo-classes

您可能已经熟悉了一些用户交互伪类，即：link，：visited，：hover，：active和：focus。

在CSS3中添加了一些伪类选择器。一个是：根选择器，它允许设计者指向文档的根元素。在HTML中，它将是<html>。因为：root是通用的，它允许设计者选择XML文档的根元素，而不必知道它的名称。要在文档中需要时允许滚动条，此规则将起作用。

```
:root{overflow:auto;}
```

作为：first-child选择器的补充，添加了：last-child。有了它，可以选择父元素命名的最后一个元素。

```
div.article > p:last-child{font-style: italic;}
```

添加了一个新的用户交互伪类选择器：target目标选择器。为了在用户点击同一页面链接时将用户的注意力吸引到一段文本，像下面第一行这样的规则可以很好地工作;链接看起来像第二行，突出显示的跨度就像第三行。

```
span.notice:target{font-size: 2em; font-style: bold;}
<a href='#section2'>Section 2</a>
<p id='section2'>...</p>
```

已创建用于选择未通过测试的指定元素的功能表示法。否定伪类选择器：不能与几乎任何已实现的其他选择器耦合。例如，要在没有指定边框的图像周围放置边框，请使用这样的规则。

```
img:not([border]){border: 1;}
```

## CSS3颜色

CSS3带来了对一些描述颜色的新方法的支持。在CSS3之前，我们几乎总是使用十六进制格式（#FFF或#FFFFFF for white）声明颜色。也可以使用rgb（）表示法声明颜色，提供整数（0-255）或百分比。

颜色关键字列表已在CSS3颜色模块中进行了扩展，包括147种额外的关键字颜色（通常得到很好的支持），CSS3还为我们提供了许多其他选项：HSL，HSLA和RGBA。这些新颜色类型最显着的变化是能够声明半透明颜色。

1. RGBA 

RGBA的工作方式与RGB类似，只是它添加了第四个值：alpha，不透明度级别或alpha透明度级别。前三个值仍然代表红色，绿色和蓝色。对于alpha值，1表示完全不透明，0表示完全透明，0.5表示50％不透明。您可以使用介于0和1之间的任意数字。

```
background: rgba(0,0,0,.5) //在这里0.5的0可以省略
```

2. HSL和HSLA

HSL代表色调，饱和度和亮度。与RGB不同，您需要通过一致地更改所有三个颜色值来操纵颜色的饱和度或亮度，使用HSL，您可以调整饱和度或亮度，同时保持相同的基色调。 HSL的语法包括色调的整数值，以及饱和度和亮度的百分比值。

hsl（）声明接受三个值：

* 0到359度的色调。一些例子是：0 =红色，60 =黄色，120 =绿色，180 =青色，240 =蓝色，300 =品红色。
* 饱和度为百分比，100％为常态。 100％的饱和度将是完整的色调，饱和度0将给你一个灰色阴影。
* 基本上导致色调值被忽略。
* 饱和度为百分比，100％为常态。 100％的饱和度将是完整的色调，饱和度0将给你一个灰色阴影》
* 基本上导致色调值被忽略。
* 轻度的百分比，50％是常态。亮度为100％为白色，50％为实际色调，0％为黑色。
 
 hsla()中的a也与rgba()中的函数相同

 3. Opacity

 除了使用HSLA和RGBA颜色指定透明度（以及很快，八位十六进制值）之外，CSS3还为我们提供了不透明度属性。 opacity设置声明它的元素的不透明度，类似于alpha。

 我们来看一个例子:

 ```css
 div.halfopaque {
    background-color: rgb(0, 0, 0);
    opacity: 0.5;
    color: #000000;
}
div.halfalpha {
    background-color: rgba(0, 0, 0, 0.5);
    color: #000000;
}
```

尽管alpha和不透明度符号的使用看似相似，但是当你看它时，它们的功能有一个关键的区别。

虽然不透明度为元素及其所有子元素设置不透明度值，但半透明RGBA或HSLA颜色对元素的其他CSS属性或后代没有影响。

## 圆角：边界半径

border-radius属性允许您创建圆角而无需图像或其他标记。要在我们的框中添加圆角，我们只需添加即可

```
border-radius: 25px;
```

border-radius属性实际上是一种速记。对于我们的“a”元素，角落大小相同且对称。如果我们想要不同大小的角落，我们可以声明最多四个唯一值

```
border-radius: 5px 10px 15px 20px;
```

## 阴影

CSS3提供了使用box-shadow属性向元素添加阴影的功能。此属性允许您指定元素上一个或多个内部和/或外部阴影的颜色，高度，宽度，模糊和偏移。

```
box-shadow: 2px 5px 0 0 rgba(72,72,72,1);
```

## 文字阴影

text-shadow为文本节点中的单个字符添加阴影。在CSS 3之前，可以通过使用图像或复制文本元素然后定位它来完成。

```
text-shadow: topOffset leftOffset blurRadius color;
```
## 线性渐变

W3C添加了使用CSS3生成线性渐变的语法。

```
Syntax: background: linear-gradient(direction, color-stop1, color-stop2, ...);
e.g.   #grad {
  background: linear-gradient(to right, red , yellow);
}
```
![](http://cdn.rnode.me/images/20180912/img1.png)
你甚至可以用度数指定方向，例如在上面的例子中，60deg而不是右边。

## 径向渐变

径向渐变是圆形或椭圆形渐变。颜色不是沿着直线前进，而是从所有方向的起点混合出来。

```
Syntax : background: radial-gradient(shape size at position, start-color, ..., last-color);
e.g.     #grad {
  background: radial-gradient(red, yellow, green);
}//Default       
         #grad {
  background: radial-gradient(circle, red, yellow, green);
}//Circle
```
![](http://cdn.rnode.me/images/20180912/img2.png)
## 背景

在CSS3中，不需要为每个背景图像包含一个元素;它使我们能够向任何元素添加多个背景图像，甚至伪元素。

```
background-image:
url(firstImage.jpg),
url(secondImage.gif),
url(thirdImage.png);
```

这些是新实现的CSS3功能，还有其他未实现的功能，我们将在实施后讨论它们。

![](http://cdn.rnode.me/images/20180912/img3.gif)

望大家有所收获，下面是我的公众号，定期更新学习资料：

![](http://cdn.rnode.me/images/my-qrcode.png)