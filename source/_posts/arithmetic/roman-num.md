---
title: 罗马数字转阿拉伯数字
date: 2017-10-11 23:19:44
tags: 算法
categories: 算法笔记
comment: true
origin: 1
thumbnail: http://cdn.rnode.me/images/20170922/img2.png
---
# 题目
输入一个罗马数字，输出对应的阿拉伯数字。

# 代码
```javascript
/**
 * @param {string} s
 * @return {number}
 */
var romanToInt = function(s) {
    // 建立七个罗马数字与阿拉伯数字的对应关系
    var temps = {
        I:1,
        V:5,
        X:10,
        L:50,
        C:100,
        D:500,
        M:1000
    }
    ,num=0
    /**
     *输出一个二维数组[[X,1]]
     *一维元素表示拆分后的罗马数字的
     *二维元素表示具体的罗马数字以及对应重复的次数
     */
    ,sArray=[];
    for(var i=0;i<s.length;i++){
        var sArr=[];
        if(s[i]===s[i-1]){
            //记录罗马数字重复的次数
            sArray[sArray.length-1][1]++;
        }else{
			sArr[0]=s[i];
            sArr[1]=1;
            sArray.push(sArr);
		}
    }
    for(i=0;i<sArray.length;i++){
        var current=sArray[i][0]
        ,currentNum=temps[current]
        ,flag=1
        ,len=sArray[i][1];
        if(i+1<sArray.length){
            //遵循左减右加的规则，若当前值大于右侧的值加，反正减
            if(temps[sArray[i+1][0]]-currentNum>0){
                flag=-1;
            }else{
                flag=1;
            }
        }
        num+=temps[current]*len*flag;
    }
    return num;

};
```
如果大家有好的解题思路，欢迎留言。