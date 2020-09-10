---
title: git 使用规范流程
date: 2017-12-26 10:55:44
tags: git
categories: 随记
comment: true
author: 阮一峰
origin: 2
---

团队开发，需要遵循一个 git 使用规范，方便项目的协调和维护。

git 操作需遵循以下步骤：

- 新建分支
- 提交分支 commit
- 编写提交信息
- 与主干同步
- 合并 commit
- 推送到远程仓库
- 发出 Pull Request

## 新建分支

每次开发新功能都应该新建一个单独的分支。

```
# 获取主干最新代码
$ git checkout master
$ git pull

# 新建一个开发分支myfeature
$ git checkout -b myfeature
```

## 第二步: 提交分支 commit

分支修改后，就可以提交 commit 了。

```
$ git add .
$ git status
$ git commit --verbose
```

git status 命令，用来查看发生变动的文件。

git commit 命令的 verbose 参数，会列出 diff 的结果。

## 编写提交信息

使用标识符区别提交信息

- feat：新功能（feature）
- fix：修补 bug
- docs：文档（documentation）
- style： 格式（不影响代码运行的变动）
- refactor：重构（即不是新增功能，也不是修改 bug 的代码变动）
- test：增加测试
- chore：构建过程或辅助工具的变动

例如：

```
fix：修改了某某bug
```

这只是简单的 commit message 规范，更加详细的请[转到](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)。

## 与主干同步

分支的开发过程中，要经常与主干保持同步。

```
$ git fetch origin
$ git rebase origin/master
```

## 合并 commit

分支开发完成后，很可能有一堆 commit，但是合并到主干的时候，往往希望只有一个（或最多两三个）commit，这样不仅清晰，也容易管理。
那么，怎样才能将多个 commit 合并呢？这就要用到 git rebase 命令。

```
$ git rebase -i origin/master
```

git rebase 命令的 i 参数表示互动（interactive），这时 git 会打开一个互动界面，进行下一步操作。

下面采用 Tute Costa 的例子，来解释怎么合并 commit。

```
pick 07c5abd Introduce OpenPGP and teach basic usage
pick de9b1eb Fix PostChecker::Post#urls
pick 3e7ee36 Hey kids, stop all the highlighting
pick fa20af3 git interactive rebase, squash, amend

# Rebase 8db7e8b..fa20af3 onto 8db7e8b
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

上面的互动界面，先列出当前分支最新的 4 个 commit（越下面越新）。每个 commit 前面有一个操作命令，默认是 pick，表示该行 commit 被选中，要进行 rebase 操作。

4 个 commit 的下面是一大堆注释，列出可以使用的命令。

- pick：正常选中
- reword：选中，并且修改提交信息；
- edit：选中，rebase 时会暂停，允许你修改这个 commit
- squash：选中，会将当前 commit 与上一个 commit 合并
- fixup：与 squash 相同，但不会保存当前 commit 的提交信息
- exec：执行其他 shell 命令

上面这 6 个命令当中，squash 和 fixup 可以用来合并 commit。先把需要合并的 commit 前面的动词，改成 squash（或者 s）。

```
pick 07c5abd Introduce OpenPGP and teach basic usage
s de9b1eb Fix PostChecker::Post#urls
s 3e7ee36 Hey kids, stop all the highlighting
pick fa20af3 git interactive rebase, squash, amend
```

这样一改，执行后，当前分支只会剩下两个 commit。第二行和第三行的 commit，都会合并到第一行的 commit。提交信息会同时包含，这三个 commit 的提交信息。

```

# This is a combination of 3 commits.
# The first commit's message is:
Introduce OpenPGP and teach basic usage

# This is the 2nd commit message:
Fix PostChecker::Post#urls

# This is the 3rd commit message:
Hey kids, stop all the highlighting
```

如果将第三行的 squash 命令改成 fixup 命令。

```
pick 07c5abd Introduce OpenPGP and teach basic usage
s de9b1eb Fix PostChecker::Post#urls
f 3e7ee36 Hey kids, stop all the highlighting
pick fa20af3 git interactive rebase, squash, amend
```

运行结果相同，还是会生成两个 commit，第二行和第三行的 commit，都合并到第一行的 commit。但是，新的提交信息里面，第三行 commit 的提交信息，会被注释掉。

```
# This is a combination of 3 commits.
# The first commit's message is:
Introduce OpenPGP and teach basic usage

# This is the 2nd commit message:
Fix PostChecker::Post#urls

# This is the 3rd commit message:
# Hey kids, stop all the highlighting
```

Pony Foo 提出另外一种合并 commit 的简便方法，就是先撤销过去 5 个 commit，然后再建一个新的。

```
$ git reset HEAD~5
$ git add .
$ git commit -am "Here's the bug fix that closes #28"
$ git push --force
```

squash 和 fixup 命令，还可以当作命令行参数使用，自动合并 commit。

```
$ git commit --fixup
$ git rebase -i --autosquash
```

## 推送到远程仓库

合并 commit 后，就可以推送当前分支到远程仓库了。

```
$ git push --force origin myfeature
```

git push 命令要加上 force 参数，因为 rebase 以后，分支历史改变了，跟远程分支不一定兼容，有可能要强行推送。

[转载地址](http://www.ruanyifeng.com/blog/2015/08/git-use-process.html)
