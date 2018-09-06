---
title: angular模块库开发
date: 2017-10-19 11:15:57
tags: [javascript,angular]
categories: [随记]
comment: true
origin: 1
---
# angular模块库开发实例
随着前端框架的诞生，也会随之出现一些组件库，方便日常业务开发。今天就聊聊angular4组件库开发流程。

下图是button组件的基础文件。

![image](http://cdn.rnode.me/images/20171019/img1.png)

nk-button.component.ts为该组件的核心文件，看看代码：

```javascript
import {Component, Renderer2, ElementRef, AfterContentInit, ViewEncapsulation, Input} from '@angular/core';

@Component({
  selector: '[nk-button]',
  templateUrl: './nk-button.component.html',
  encapsulation: ViewEncapsulation.None,
  styleUrls: ['./nk-button.component.scss']
})
export class NkButtonComponent implements AfterContentInit {
  _el: HTMLElement;
  _prefixCls = 'ky-btn';
  _type: string;
  _size: string;
  _shape: string;
  _classList: Array<string> = [];

  @Input()
  get nkType() {
    return this._type;
  }

  set nkType(value) {
    this._type = value;
    this._setClass();
  }

  @Input()
  get nkSize() {
    return this._size;
  }

  set nkSize(value: string) {
    this._size = value;
    this._setClass();
  }

  @Input()
  get nkShape() {
    return this._shape;
  }

  set nkShape(value: string) {
    this._shape = value;
    this._setClass();
  }

  constructor(private _elementRef: ElementRef, private _renderer: Renderer2) {
    this._el = this._elementRef.nativeElement;
    this._renderer.addClass(this._el, this._prefixCls);
  }

  ngAfterContentInit() {
  }

  /**
   *设置class属性
   */
  _setClass(): void {
    this._classList = [
      this.nkType && `${this._prefixCls}-${this.nkType}`,
      this.nkSize && `${this._prefixCls}-${this.nkSize}`,
      this.nkShape && `${this._prefixCls}-${this.nkShape}`
    ].filter(item => {
      return item;
    });
    this._classList.forEach(_className => {
      this._renderer.addClass(this._el, _className);
    });
  }
}
```

针对核心概念ElementRef、Renderer2、ViewEncapsulation做简要说明：

# ElementRef
在应用层直接操作 DOM，就会造成应用层与渲染层之间强耦合，通过 ElementRef 我们就可以封装不同平台下视图层中的 native 元素 (在浏览器环境中，native 元素通常是指 DOM 元素)，最后借助于 Angular 提供的强大的依赖注入特性，我们就可以轻松地访问到 native 元素。

[参考链接](https://segmentfault.com/a/1190000008653690)

# Renderer2
渲染器是 Angular 为我们提供的一种内置服务，用于执行 UI 渲染操作。在浏览器中，渲染是将模型映射到视图的过程。模型的值可以是 JavaScript 中的原始数据类型、对象、数组或其它的数据对象。然而视图可以是页面中的段落、表单、按钮等其他元素，这些页面元素内部使用DOM来表示。

[参考链接](https://segmentfault.com/a/1190000010326100)

# ViewEncapsulation

ViewEncapsulation 允许设置三个可选的值：

* ViewEncapsulation.Emulated - 无 Shadow DOM，但是通过 Angular 提供的样式包装机制来封装组件，使得组件的样式不受外部影响。这是 Angular 的默认设置。
* ViewEncapsulation.Native - 使用原生的 Shadow DOM 特性
* ViewEncapsulation.None - 无 Shadow DOM，并且也无样式包装

[参考链接](https://segmentfault.com/a/1190000008677532)

button组件创建思路：
* 针对button我们只需修改其样式，因此在这里创建属性指令
* 提供属性接口
* 根据其传入的属性值动态渲染DOM


至此，最简单的button就开发结束。

# 模块打包流程
## 合并html、css到component文件
```javascript
let fs = require('fs');
let pathUtil = require('path');
let sass = require('node-sass');
let filePath = pathUtil.join(__dirname, 'src', 'temp_components');

let fileArray = [];

function fildFile(path) {
  if (fs.statSync(path).isFile()) {
    if (/\.component.ts/.test(path)) {
      fileArray[0] = path;
    }
    if (/\.html$/.test(path)) {
      fileArray[1] = readFile(path)
    }
    if (/\.component.scss$/.test(path)) {
      fileArray[2] = path;
    }
  } else if (fs.statSync(path).isDirectory()) {
    let paths = fs.readdirSync(path);

    if (fileArray.length === 3) {
      writeFile(fileArray);
      fileArray = [];
    }
    paths.forEach((p) => {
      fildFile(pathUtil.join(path, p));
    });
  }

}

function readFile(file) {
  return fs.readFileSync(file);
}

function writeFile(fileArray) {
  let file = fileArray[0];
  let content = fileArray[1];
  let scssPath = fileArray[2];
  mergeContent(file, content, scssPath)
    .then(result => {
      if (!result) return;
      fs.writeFile(file, result, function (err) {
        if (err) console.error(err);
        console.log('file merge success!');
      })
    });

}

/**
 * 转换scss
 * @param path
 * @returns {Promise}
 */
function processScss(path) {
  return new Promise((resolve, reject) => {
    sass.render({
      file: path
    }, (err, result) => {
      if (!err) {
        resolve(result.css.toString())
      } else {
        reject(err);
      }
    })
  })
}

function mergeContent(file, content, scssPath) {
  let componentContent = readFile(file);
  let htmlRegex = /(templateUrl *:\s*[\"|\'])(.*[\"|\']\,?)/g;
  let scssRegex = /(styleUrls *:\s*)(\[.*\]\,?)/g;

  let newContent = '';
  if (htmlRegex.test(componentContent) && scssRegex.test(componentContent)) {
    let contentArray = componentContent.toString().split(htmlRegex);
    contentArray[1] = 'template:`';
    contentArray[2] = content + '`,';
    contentArray.forEach(con => {
      newContent += con;
    })
    contentArray = newContent.toString().split(scssRegex);

    return new Promise((resolve, reject) => {
      processScss(scssPath)
        .then(result => {
          newContent = '';
          contentArray[1] = 'styles:[`';
          contentArray[2] = result + '`],';
          contentArray.forEach(con => {
            newContent += con;
          })
          resolve(newContent)
        }, err => {
          reject(err);
        })
    });
  }
}

fildFile(filePath);
```
## ts编译(tsconfig-aot.json)
```
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "./publish/src",
    "baseUrl": "./",
    "declaration": true,
    "importHelpers": true,
    "module": "es2015",
    "sourceMap": false,
    "target": "es2015",
    "types": [
      "node"
    ]
  },
  "files": [
    "./src/temp_components/ng-kylin.module.ts"
  ],
  "angularCompilerOptions": {
    "annotateForClosureCompiler": true,
    "strictMetadataEmit": true,
    "flatModuleOutFile": "index.js",
    "flatModuleId": "ng-kylin",
    "skipTemplateCodegen": true
  }
}
```
## rollup打包 (rollup-config.js)
```javascript
import resolve from 'rollup-plugin-node-resolve'
import replace from 'rollup-plugin-replace'

const format = process.env.ROLLUP_FORMAT || 'es'

let globals = {
  '@angular/animations': 'ng.animations',
  '@angular/cdk': 'ng.cdk',
  '@angular/core': 'ng.core',
  '@angular/common': 'ng.common',
  '@angular/compiler': 'ng.compiler',
  '@angular/forms': 'ng.forms',
  '@angular/platform-browser': 'ng.platformBrowser',
  'moment': 'moment',
  'moment/locale/zh-cn': null,
  'rxjs/BehaviorSubject': 'Rx',
  'rxjs/Observable': 'Rx',
  'rxjs/Subject': 'Rx',
  'rxjs/Subscription': 'Rx',
  'rxjs/observable/fromPromise': 'Rx.Observable',
  'rxjs/observable/forkJoin': 'Rx.Observable',
  'rxjs/observable/fromEvent': 'Rx.Observable',
  'rxjs/observable/merge': 'Rx.Observable',
  'rxjs/observable/of': 'Rx.Observable',
  'rxjs/operator/auditTime': 'Rx.Observable.prototype',
  'rxjs/operator/catch': 'Rx.Observable.prototype',
  'rxjs/operator/debounceTime': 'Rx.Observable.prototype',
  'rxjs/operator/distinctUntilChanged': 'Rx.Observable.prototype',
  'rxjs/operator/do': 'Rx.Observable.prototype',
  'rxjs/operator/filter': 'Rx.Observable.prototype',
  'rxjs/operator/finally': 'Rx.Observable.prototype',
  'rxjs/operator/first': 'Rx.Observable.prototype',
  'rxjs/operator/map': 'Rx.Observable.prototype',
  'rxjs/operator/pluck': 'Rx.Observable.prototype',
  'rxjs/operator/startWith': 'Rx.Observable.prototype',
  'rxjs/operator/switchMap': 'Rx.Observable.prototype',
  'rxjs/operator/takeUntil': 'Rx.Observable.prototype',
  'rxjs/operator/throttleTime': 'Rx.Observable.prototype',
}

if (format === 'es') {
  globals = Object.assign(globals, {
    'tslib': 'tslib',
  })
}

let input
let file

switch (format) {
  case 'es':
    input = './publish/src/index.js'
    file = './publish/esm15/index.js'
    break
  case 'umd':
    input = './publish/esm5/index.js'
    file = './publish/bundles/ng-kylin.umd.js'
    break
  default:
    throw new Error(`format ${format} is not supported`)
}

export default {
  input,
  output: {
    file,
    format,
  },
  exports: 'named',
  name: 'ngKylin',
  plugins: [replace({ "import * as moment": "import moment" }), resolve()],
  external: Object.keys(globals),
  globals,
}
```
## shell脚本定义执行流程(build.sh)

```
#!/usr/bin/env bash

rm -rf ./publish

cp -r src/app/components src/temp_components

node ./html.merge.js

echo 'Generating entry file using Angular compiler'
$(npm bin)/ngc -p tsconfig-aot.json
rm -rf src/temp_components

echo 'Bundling to es module'
export ROLLUP_FORMAT=es
$(npm bin)/rollup -c rollup-config.js
rm -rf publish/src/*.js
rm -rf publish/src/**/*.js
sed -e "s/from '.\//from '.\/src\//g" publish/src/index.d.ts > publish/index.d.ts
sed -e "s/\":\".\//\":\".\/src\//g" publish/src/index.metadata.json > publish/index.metadata.json
rm publish/src/index.d.ts publish/src/index.metadata.json

echo 'Transpiling es module to es5'
$(npm bin)/tsc --allowJs --importHelpers --target es5 --module es2015 --outDir publish/esm5 publish/esm15/index.js

echo 'Bundling to umd module'
export ROLLUP_FORMAT=umd
$(npm bin)/rollup -c rollup-config.js

echo 'Minifying umd module'
$(npm bin)/uglifyjs publish/bundles/ng-kylin.umd.js --output publish/bundles/ng-kylin.umd.min.js

echo 'Copying package.json'
cp package.json publish/package.json

```

至此，项目打包结束。

[源码](https://github.com/troyerwang/ng-kylin)
