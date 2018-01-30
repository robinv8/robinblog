---
title: 理解HTTP之Content-Type
date: 2018-1-30 13:10:44
tags: http
categories: 读书笔记
comment: true
author: 夏日小草
origin: 2
---

## About
查看Restful API 报头插件：[Chrome插件REST Console](https://chrome.google.com/webstore/detail/rest-console/cokgbflfommojglbmbpenpphppikmonn/related?utm_source=chrome-ntp-icon)，以及发送Restful API工具：[Chrome插件POST Man](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?utm_source=chrome-ntp-icon)

在HTTP 1.1规范中，HTTP请求方式有OPTIONS、GET、HEAD、POST、PUT、DELETE、TRACE、CONNECT

通常我们用的只有GET、POST，然而对于Restful API规范来说，请求资源要用PUT方法，删除资源要用DELETE方法。

例如发送个DELETE包：
> http://example.com/my/resource?id=12345

那么通过id就能获取到信息，这个包只有header，并不存在body，下面讨论几个包含body的发包的body传输格式。

## Content-Type
Content-Type用于指定内容类型，一般是指网页中存在的Content-Type，Content-Type属性指定请求和响应的HTTP内容类型。如果未指定 ContentType，默认为text/html。

在nginx中有个配置文件mime.types，主要是标示Content-Type的文件格式。

下面是几个常见的Content-Type:
1. text/html
2. text/plain
3. text/css
4. text/javascript
5. application/x-www-form-urlencoded
6. multipart/form-data
7. application/json
8. application/xml

前面几个都很好理解，都是html，css，javascript的文件类型，后面四个是POST的发包方式。
## application/x-www-form-urlencoded
application/x-www-form-urlencoded是常用的表单发包方式，普通的表单提交，或者js发包，默认都是通过这种方式，

比如一个简单地表单：
```html
<form enctype="application/x-www-form-urlencoded" action="http://homeway.me/post.php" method="POST">
    <input type="text" name="name" value="homeway">
    <input type="text" name="key" value="nokey">
    <input type="submit" value="submit">
</form>
```
那么服务器收到的raw header会类似：
```
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Encoding:gzip, deflate
Accept-Language:zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4,gl;q=0.2,de;q=0.2
Cache-Control:no-cache
Connection:keep-alive
Content-Length:17
Content-Type:application/x-www-form-urlencoded
```
那么服务器收到的raw body会是，name=homeway&key=nokey，在php中，通过$_POST就可以获得数组形式的数据。

## multipart/form-data
multipart/form-data用在发送文件的POST包。

这里假设我用python的request发送一个文件给服务器：

```javascript
data = {
    "key1": "123",
    "key2": "456",
}
files = {'file': open('index.py', 'rb')}
res = requests.post(url="http://localhost/upload", method="POST", data=data, files=files)
print res
```
通过工具，可以看到我发送的数据内容如下：
```
POST http://www.homeway.me HTTP/1.1
Content-Type:multipart/form-data; boundary=------WebKitFormBoundaryOGkWPJsSaJCPWjZP

------WebKitFormBoundaryOGkWPJsSaJCPWjZP
Content-Disposition: form-data; name="key2"
456
------WebKitFormBoundaryOGkWPJsSaJCPWjZP
Content-Disposition: form-data; name="key1"
123
------WebKitFormBoundaryOGkWPJsSaJCPWjZP
Content-Disposition: form-data; name="file"; filename="index.py"
```
这里Content-Type告诉我们，发包是以multipart/form-data格式来传输，另外，还有boundary用于分割数据。

当文件太长，HTTP无法在一个包之内发送完毕，就需要分割数据，分割成一个一个chunk发送给服务端，

那么--用于区分数据快，而后面的数据633e61ebf351484f9124d63ce76d8469就是标示区分包作用。
## text/xml
微信用的是这种数据格式发送请求的。
```
POST http://www.homeway.me HTTP/1.1 
Content-Type: text/xml

<?xml version="1.0"?>
<resource>
    <id>123</id>
    <params>
        <name>
            <value>homeway</value>
        </name>
        <age>
            <value>22</value>
        </age>
    </params>
</resource>
```
php中$_POST只能读取application/x-www-form-urlencoded数据，$_FILES只能读取multipart/form-data类型数据，

那么，要读取text/xml格式的数据，可以用：
> file=fopen(‘php://input′,‘rb′);file=fopen(‘php://input′,‘rb′); data = fread(file,length);fclose(file,length);fclose(file);

或者
> $data = file_get_contents(‘php://input’);

## application/json
通过json形式将数据发送给服务器，一开始，我尝试通过curl，给服务器发送application/json格式包，

然而我收到的数据如下：
> ————————–e1e1406176ee348a Content-Disposition: form-data; name=”nid” 2 ————————–e1e1406176ee348a Content-Disposition: form-data; name=”uuid” cf9dc994-a4e7-3ad6-bc54-41965b2a0dd7 ————————–e1e1406176ee348a Content-Disposition: form-data; name=”access_token” 956731586df41229dbfec08dd5d54eedb98d73d2 ————————–e1e1406176ee348a–

后来想想明白了，HTTP通信中并不存在所谓的json，而是将string转成json罢了，也就是，`application/json`可以将它理解为`text/plain`，普通字符串。

之所以出现那么多乱七八糟的-------应该是php数组传输进去，存在的转换问题吧（我目前能想到的原因）。

本文出自 夏日小草,转载请注明出处:http://homeway.me/2015/07/19/understand-http-about-content-type/