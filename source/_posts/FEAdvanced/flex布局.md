---
title: 前端进阶系列—flex布局
date: 2018-09-16 11:57:57
tags: [html,css,javascript,html5]
categories: [前端进阶系列]
comment: true
origin: 2
---

## 背景

Flexbox布局（Flexible Box）模块（目前是W3C Last Call Working Draft）旨在提供更有效的布局方式，即使容器中的项目之间对齐和分配空间的大小未知或动态（因此单词“flex”）。

flex布局背后的主要思想是让容器能够改变其项目的宽度/高度（和顺序），以最好地填充可用空间（主要是为了适应所有类型的显示设备和屏幕尺寸）。Flex容器扩展项目以填充可用空间，或缩小它们以防止溢出。

最重要的是，flexbox布局与方向无关，而不是常规布局（基于垂直的块和基于水平的内联块）。虽然那些适用于页面，但它们缺乏灵活性来支持大型或复杂的应用程序（特别是在方向更改，调整大小，拉伸，缩小等方面）。

**注意：** Flexbox布局最适合应用程序的组件和小规模布局，而Grid布局则适用于更大规模的布局。
## 基本概念
![](http://cdn.rnode.me/images/20180912/img5.png)

容器默认存在两根轴：水平的主轴（main axis）和垂直的交叉轴（cross axis）。主轴的开始位置（与侧边的交叉点）叫做`main-start`，结束位置叫`main end`；交叉轴的开始位置叫`cross start`，结束位置叫`cross end`。

项目默认沿主轴排列。单个项目占据的主轴空间叫`main size`，占据的交叉轴空间叫`cross size`。

## 容器属性

* flex-direction
* flex-wrap
* flex-flow
* justify-content
* align-items
* align-content
### flex-direction

`flex-direction`属性决定主轴的方向（即项目的排列方向）。
![](http://cdn.rnode.me/images/20180912/flex-direction2.svg)

```css
.container {
  flex-direction: row | row-reverse | column | column-reverse;
}
```
* `row` (默认值)：主轴为水平方向，起点在左端。
* `row-reverse`：主轴为水平方向，起点在右端。
* `column`：主轴为垂直方向，起点在上沿。
* `column-reverse`：主轴为垂直方向，起点在下沿。

### flex-wrap
![](http://cdn.rnode.me/images/20180912/flex-wrap.svg)
默认情况下，flex项目都会尝试适合一行。您可以更改它并允许项目根据需要使用此属性进行换行。

```css
.container{
  flex-wrap: nowrap | wrap | wrap-reverse;
}
```

* `nowrap` (默认值)：不换行。
* `wrap`：f换行，第一行在上方。
* `wrap-reverse`：换行，第一行在下方。

### flex-flow

`flex-flow`属性是`flex-direction`和`flex-wrap`属性的复合属性。

`flex-flow` 属性用于设置或检索弹性盒模型对象的子元素排列方式。

```css
flex-flow: <‘flex-direction’> || <‘flex-wrap’>
```
### justify-content
`justify-content`属性定义了项目在主轴上的对齐方式

![](http://cdn.rnode.me/images/20180912/justify-content-2.svg)


```css
.container {
  justify-content: flex-start | flex-end | center | space-between | space-around | space-evenly;
}
```
* `flex-start`：默认值。项目位于容器的开头。
* `flex-end`：项目位于容器的尾部。
* `center`: 项目位于容器的中心。
* `space-between`：两端对齐，项目之间的间隔都相等。
* `space-around`：每个项目两侧的间隔相等。所以，项目之间的间隔比项目与边框的间隔大一倍。
* `space-evenly`：使得位于容器内部任何两个项目的间距都相同。

### align-items
`align-items`属性定义项目在交叉轴上如何对齐。
![](http://cdn.rnode.me/images/20180912/align-items.svg)

```css
.box {
  align-items: flex-start | flex-end | center | baseline | stretch;
}
```
它可能取5个值。具体的对齐方式与交叉轴的方向有关，下面假设交叉轴从上到下。

* `flex-start`：交叉轴的起点对齐。
* `flex-end`：交叉轴的终点对齐。
* `center`：交叉轴的中点对齐。
* `baseline`：项目的第一行文字的集中县对齐。
* `stretch`：默认值。如果项目未设置宽高或设为`auto`,将占满整个容器的高度。

### align-content
`align-content`属性定义了多根轴线的对齐方式。如果项目只有一根轴线，该属性不起作用。
![](http://cdn.rnode.me/images/20180912/img6.png)

```css
.box {
  align-content: flex-start | flex-end | center | space-between | space-around | stretch;
}
```
* `flex-start`：与交叉轴的起点位置对齐。
* `flex-end`：与交叉轴的终点位置对齐。
* `center`：与交叉轴的中点位置对齐。
* `space-between`：与交叉轴两端对齐，轴线之间间距平均分布。
* `spance-around`：你每根轴线两侧的间距都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。
* `stretch`：默认值。轴线站面整个交叉轴。

## 父容器属性
* order
* flex-grow
* flex-shrink
* flex-basis
* flex
* align-self

### order 
`order` 属性定义项目的排列顺序。数值越小，排列越靠前，默认为0.
![](http://cdn.rnode.me/images/20180912/img7.png)

```css
.item {
  order: <integer>;
}
```

### flex-grow
`flex-grow`属性定义项目的放大比例，默认为0，即如果存在剩余空间，也不放大。
![](http://cdn.rnode.me/images/20180912/img8.png)

```css
.item {
  flex-grow: <number>; /* default 0 */
}
```
如果所有项目的`flex-grow`属性都为1，则它们将等分剩余空间（如果有的话）。如果一个项目的`flex-grow`属性为2，其他项目都为1，则前者占据的剩余空间将比其他项多一倍。

### flex-shrink

`flex-shrink`属性定义了项目的缩小比例，默认为1，即如果空间不足，该项目将缩小。

![](http://cdn.rnode.me/images/20180912/img9.jpg)

如果所有项目的`flex-shrink`属性都为1，当空间不足时，都将等比例缩小。如果一个项目的`flex-shrink`属性为0，其他项目都为1，则空间不足时，前者不缩小。

负值对该属性无效。

### flex-basis
`flex-basis`属性定义了在分配多余空间之前，项目占据的主轴空间（main size）。浏览器根据这个属性，计算主轴是否有多余空间。它的默认值为auto，即项目的本来大小。

```css
.item {
  flex-basis: <length> | auto; /* default auto */
}
```

它可以设为跟`width`或`height`属性一样的值（比如350px），则项目将占据固定空间。

### flex

`flex`属性是`flex-grow`, `flex-shrink` 和 `flex-basis`的简写，默认值为0 1 auto。后两个属性可选。

```css
.item {
  flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]
}
```

该属性有两个快捷值：`auto` (`1 1 auto`) 和 `none` (`0 0 auto`)。

建议优先使用这个属性，而不是单独写三个分离的属性，因为浏览器会推算相关值。

### align-self

`align-self`属性允许单个项目有与其他项目不一样的对齐方式，可覆盖`align-items`属性。默认值为`auto`，表示继承父元素的`align-items`属性，如果没有父元素，则等同于`stretch。

![](http://cdn.rnode.me/images/20180912/img10.png)

```css
.item {
  align-self: auto | flex-start | flex-end | center | baseline | stretch;
}
```
该属性可能取6个值，除了auto，其他都与align-items属性完全一致。

以上内容主要摘抄阮一峰写的[Flex 布局教程：语法篇](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)