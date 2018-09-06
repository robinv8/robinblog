---
title: nginx-proxy使用说明
date: 2017-12-25 23:11:44
tags: nginx
categories: 随记
comment: true
origin: 1
---
# nginx-proxy使用说明
> 这是使用docker-gen自动化的Docker容器的nginx代理，减少手动配置nginx。

[GitHub地址](https://github.com/jwilder/nginx-proxy)里面有具体的使用教程。

我的项目使用docker部署并使用nginx-proxy做的反向代理，在使用过程中碰到两个问题：

- 如何在nginx-proxy中使用SSL
- 在代理多个nginx项目的情况下，如何对指定的项目进行https访问

我在阿里云CA证书中心给我的域名 申请了免费版的SSL [https://rnode.me](https://rnode.me),该证书针对单域名有效，因此我只希望我的主域名通过https访问，其他二级域名通过http访问。

现在针对以上两个问题做个总结。

## 如何在nginx-proxy中使用SSL

yaml配置如下：
```
a-nginx:
  image: daocloud.io/daocloud/nginx-proxy:alpine
  privileged: false
  restart: always
  ports:
  - 80:80
  - 443:443
  volumes:
  - /root/nginx/certs:/etc/nginx/certs
  - /root/nginx/conf.d:/etc/nginx/conf.d
  - /var/run/docker.sock:/tmp/docker.sock:ro
  environment:
  - VIRTUAL_PORT=443
  - VIRTUAL_PROTO=https
```

在这里重点配置certs证书位置，还要注意的是证书后缀为crt，如果不是可以进行证书转换，并配置`VIRTUAL_PORT=443`、`VIRTUAL_PROTO=https`。

以上配置就开启了https访问，但由于nginx-proxy `HTTPS_METHOD`属性默认开启`redirect`,会导致所有被代理的所有项目都通过https访问，但由于单一证书的原因，只有主域名可以正常访问，其他域名访问异常。

在这里至于要给nginx项目添加配置如下：
```
myblog:
  image: daocloud.io/tranren/myblog:master-b63956b
  privileged: false
  restart: always
  ports:
  - '80'
  environment:
  - HTTPS_METHOD=nohttps
  - LETSENCRYPT_HOST=blog.rnode.me
  - VIRTUAL_HOST=blog.rnode.me
```

关键一句 `HTTPS_METHOD=nohttps`哈哈大问题解决了，其他nginx项目也一样，添加该配置即可。

