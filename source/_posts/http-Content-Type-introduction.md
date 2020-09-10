---
title: 理解HTTP之Content-Type
date: 2018-1-30 13:10:44
tags: http
categories: 随记
comment: true
author: 夏日小草
origin: 2
---

## About

查看 Restful API 报头插件：[Chrome 插件 REST Console](https://chrome.google.com/webstore/detail/rest-console/cokgbflfommojglbmbpenpphppikmonn/related?utm_source=chrome-ntp-icon)，以及发送 Restful API 工具：[Chrome 插件 POST Man](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?utm_source=chrome-ntp-icon)

在 HTTP 1.1 规范中，HTTP 请求方式有 OPTIONS、GET、HEAD、POST、PUT、DELETE、TRACE、CONNECT

通常我们用的只有 GET、POST，然而对于 Restful API 规范来说，请求资源要用 PUT 方法，删除资源要用 DELETE 方法。

例如发送个 DELETE 包：

> http://example.com/my/resource?id=12345

那么通过 id 就能获取到信息，这个包只有 header，并不存在 body，下面讨论几个包含 body 的发包的 body 传输格式。

## Content-Type

Content-Type 用于指定内容类型，一般是指网页中存在的 Content-Type，Content-Type 属性指定请求和响应的 HTTP 内容类型。如果未指定 ContentType，默认为 text/html。

在 nginx 中有个配置文件 mime.types，主要是标示 Content-Type 的文件格式。

下面是几个常见的 Content-Type:

1. text/html
2. text/plain
3. text/css
4. text/javascript
5. application/x-www-form-urlencoded
6. multipart/form-data
7. application/json
8. application/xml

前面几个都很好理解，都是 html，css，javascript 的文件类型，后面四个是 POST 的发包方式。

## application/x-www-form-urlencoded

application/x-www-form-urlencoded 是常用的表单发包方式，普通的表单提交，或者 js 发包，默认都是通过这种方式，

比如一个简单地表单：

```html
<form
  enctype="application/x-www-form-urlencoded"
  action="http://homeway.me/post.php"
  method="POST"
>
  <input type="text" name="name" value="homeway" />
  <input type="text" name="key" value="nokey" />
  <input type="submit" value="submit" />
</form>
```

那么服务器收到的 raw header 会类似：

```
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Encoding:gzip, deflate
Accept-Language:zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4,gl;q=0.2,de;q=0.2
Cache-Control:no-cache
Connection:keep-alive
Content-Length:17
Content-Type:application/x-www-form-urlencoded
```

那么服务器收到的 raw body 会是，name=homeway&key=nokey，在 php 中，通过\$\_POST 就可以获得数组形式的数据。

## multipart/form-data

multipart/form-data 用在发送文件的 POST 包。

这里假设我用 python 的 request 发送一个文件给服务器：

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

这里 Content-Type 告诉我们，发包是以 multipart/form-data 格式来传输，另外，还有 boundary 用于分割数据。

当文件太长，HTTP 无法在一个包之内发送完毕，就需要分割数据，分割成一个一个 chunk 发送给服务端，

那么--用于区分数据快，而后面的数据 633e61ebf351484f9124d63ce76d8469 就是标示区分包作用。

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

php 中$_POST只能读取application/x-www-form-urlencoded数据，$\_FILES 只能读取 multipart/form-data 类型数据，

那么，要读取 text/xml 格式的数据，可以用：

> file=fopen(‘php://input′,‘rb′);file=fopen(‘php://input′,‘rb′); data = fread(file,length);fclose(file,length);fclose(file);

或者

> \$data = file_get_contents(‘php://input’);

## application/json

通过 json 形式将数据发送给服务器，一开始，我尝试通过 curl，给服务器发送 application/json 格式包，

然而我收到的数据如下：

> ————————–e1e1406176ee348a Content-Disposition: form-data; name=”nid” 2 ————————–e1e1406176ee348a Content-Disposition: form-data; name=”uuid” cf9dc994-a4e7-3ad6-bc54-41965b2a0dd7 ————————–e1e1406176ee348a Content-Disposition: form-data; name=”access_token” 956731586df41229dbfec08dd5d54eedb98d73d2 ————————–e1e1406176ee348a–

后来想想明白了，HTTP 通信中并不存在所谓的 json，而是将 string 转成 json 罢了，也就是，`application/json`可以将它理解为`text/plain`，普通字符串。

之所以出现那么多乱七八糟的-------应该是 php 数组传输进去，存在的转换问题吧（我目前能想到的原因）。

本文出自 夏日小草,转载请注明出处:http://homeway.me/2015/07/19/understand-http-about-content-type/
