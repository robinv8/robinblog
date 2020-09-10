### STAGE 1: Build ###

# We label our stage as 'builder'
FROM node:latest as builder
WORKDIR /app
RUN npm config set user 0
RUN npm config set unsafe-perm true
RUN npm config set registry http://registry.npm.taobao.org/
RUN npm install -g hexo-cli

COPY . /app
RUN npm install
RUN hexo clean
RUN hexo g

### STAGE 2: Setup ###

FROM nginx:1.13.3-alpine

## Copy our default nginx config
#COPY nginx/conf.d/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /app/public /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
