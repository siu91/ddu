2016/2/4 下午2:49:04

---------------------------------
## 在`GitHub`上新建一个`repository`，初始化创建两个永久分支：`master`、`develop`
![图](/src/img/reate_master_develop_branch.png)
## 在本地clone仓库并checkout到develop分支
```bash
$ git clone git@github.com:gongice/git-demo.git
$ cd git-demo/
$ git branch
 master
$ git checkout develop
 ranch develop set up to track remote branch develop from origin.
 Switched to a new branch 'develop'
```
### 检查develop分支是否有更新，有更新则提交。
```bash
$ git status
      modified:   README.md
Untracked files:
(use "git add <file>..." to include in what will be committed)
      src/
no changes added to commit (use "git add" and/or "git commit -a")
$ git add *
$ git commit -m "add src/img/create_master_develop_branch.png and update README.md"
$ git push origin develop
```
## 从develop分支checkout新的功能分支进行开发，例如：`feature-discuss`
```bash
$ git checkout -b feature-discuss
# checkout -b 创建并切换到新的分支
```
### 进行`feature-discuss`分支开发
```bash
$ touch discuss.js
```
### 开发完成，提交分支开发的新功能
```bash
$ git add discuss.js
$ git status
Changes to be committed:
(use "git reset HEAD <file>..." to unstage)
      new file:   discuss.js
$ git commit -m 'finish discuss feature'
```
## 回到`develop`分支，合并`feature-discuss`代码，并提交
### 回到`develop`分支
```bash
$ git checkout develop
```
### 合并`feature-discuss`代码
```bash
$ git merge --no-ff feature-discuss
```
### 删除`feature-discuss`分支
```bash
$ git branch -d feature-discuss
```
### 提交`develop`分支
```bash
$ git push origin develop
```
![图](/src/img/finish_feature-discuss.png)
