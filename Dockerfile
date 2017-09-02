### STAGE 1: Build ###

# We label our stage as 'builder'
FROM node:8-alpine as builder

WORKDIR /root/robinblog
RUN npm install -g hexo-util
RUN npm install -g hexo-cli

COPY ./package.json /root/robinblog
RUN npm install

COPY . /root/robinblog

RUN hexo g -d

### STAGE 2: Setup ###

FROM nginx:1.13.3-alpine

## Copy our default nginx config
#COPY nginx/conf.d/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /root/robinblog/public /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
