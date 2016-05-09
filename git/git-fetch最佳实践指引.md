建一个远端bare仓库
```bash
Administrator@ND-PC MINGW64 /e
$ mkdir admin

Administrator@ND-PC MINGW64 /e
$ cd admin/

Administrator@ND-PC MINGW64 /e/admin
$ mkdir cloud

Administrator@ND-PC MINGW64 /e/admin
$ cd cloud

Administrator@ND-PC MINGW64 /e/admin/cloud
$ git init --bare
Initialized empty Git repository in E:/admin/cloud/
```
jerry初始化了一个cake本地仓库与远端cloud建立关系
```bash
Administrator@ND-PC MINGW64 /e
$ mkdir jerry

Administrator@ND-PC MINGW64 /e
$ cd jerry

Administrator@ND-PC MINGW64 /e/jerry
$ mkdir cake

Administrator@ND-PC MINGW64 /e/jerry
$ cd cake/

Administrator@ND-PC MINGW64 /e/jerry/cake
$ git init
Initialized empty Git repository in E:/jerry/cake/.git/

Administrator@ND-PC MINGW64 /e/jerry/cake (master)
$ git remote add origin /e/admin/cloud
Administrator@ND-PC MINGW64 /e/jerry/cake (master)
$ git remote -v
origin  E:/admin/cloud (fetch)
origin  E:/admin/cloud (push)

Administrator@ND-PC MINGW64 /e/jerry/cake (master)
$ >cream

Administrator@ND-PC MINGW64 /e/jerry/cake (master)
$ >apple

Administrator@ND-PC MINGW64 /e/jerry/cake (master)
$ git add .

Administrator@ND-PC MINGW64 /e/jerry/cake (master)
$ git commit -m "add cream and apple"
[master (root-commit) 8476c26] add cream and apple
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 apple
 create mode 100644 cream

Administrator@ND-PC MINGW64 /e/jerry/cake (master)
$ git push origin HEAD:master
Counting objects: 3, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 219 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To E:/admin/cloud
 * [new branch]      HEAD -> master
```

tom对cake感兴趣，clone了cake到本地，往里添加了banana并commit到本地分支
```bash
Administrator@ND-PC MINGW64 /e
$ mkdir tom

Administrator@ND-PC MINGW64 /e
$ cd tom/

Administrator@ND-PC MINGW64 /e/tom
$ git clone /e/admin/cloud cake
Cloning into 'cake'...
done.

Administrator@ND-PC MINGW64 /e/tom
$ cd cake/

Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git log --oneline
8476c26 add cream and apple

Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ >banana

Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git add banana

Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git commit -m "add banana"
[master bf35240] add banana
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 banana
 ```
 于此同时jerry也往cake里添加了orange，并push到远端，然而并没有通知tom，tom对此一无所知
 ```bash
 Administrator@ND-PC MINGW64 /e/jerry/cake (master)
 $ >orange

 Administrator@ND-PC MINGW64 /e/jerry/cake (master)
 $ git add .

 Administrator@ND-PC MINGW64 /e/jerry/cake (master)
 $ git commit -m "add orange"
 [master 8489892] add orange
  1 file changed, 0 insertions(+), 0 deletions(-)
  create mode 100644 orange

 Administrator@ND-PC MINGW64 /e/jerry/cake (master)
 $ git push origin HEAD:master
 Counting objects: 2, done.
 Delta compression using up to 8 threads.
 Compressing objects: 100% (2/2), done.
 Writing objects: 100% (2/2), 242 bytes | 0 bytes/s, done.
 Total 2 (delta 0), reused 0 (delta 0)
 To E:/admin/cloud
    8476c26..8489892  HEAD -> master
 ```
tom这时想知道jerry到底对远端的仓库做了哪些变更
 ```bash
Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master

# 没有fetch前远端的commit日志
Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git log remotes/origin/master --oneline
8476c26 add cream and apple

Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git fetch origin master
remote: Counting objects: 2, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 2 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (2/2), done.
From E:/admin/cloud
 * branch            master     -> FETCH_HEAD
   8476c26..8489892  master     -> origin/master

# fetch后远端commit日志
Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git log remotes/origin/master --oneline
8489892 add orange
8476c26 add cream and apple

# 本地分支commit日志
Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git log --oneline
bf35240 add banana
8476c26 add cream and apple
```
tom checkout一个新的分支来追踪jerry对远端的变更
```bash
# checkout时指向最早的commit记录-->8476c26
Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git checkout -b jerry-cake 8476c26
Switched to a new branch 'jerry-cake'

Administrator@ND-PC MINGW64 /e/tom/cake (jerry-cake)
$ git log --oneline
8476c26 add cream and apple

# 把远端所有的更新fetch并merge
Administrator@ND-PC MINGW64 /e/tom/cake (jerry-cake)
$ git pull origin master
From E:/admin/cloud
 * branch            master     -> FETCH_HEAD
Updating 8476c26..8489892
Fast-forward
 orange | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 orange

Administrator@ND-PC MINGW64 /e/tom/cake (jerry-cake)
$ git log --oneline
8489892 add orange
8476c26 add cream and apple

Administrator@ND-PC MINGW64 /e/tom/cake (jerry-cake)
$ ls
apple  cream  orange

Administrator@ND-PC MINGW64 /e/tom/cake (jerry-cake)
$ git checkout master
Switched to branch 'master'
Your branch and 'origin/master' have diverged,
and have 1 and 1 different commit each, respectively.
  (use "git pull" to merge the remote branch into yours)

Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ ls
apple  banana  cream
```
这时候就可以把master merge到jerry-cake
```bash
Administrator@ND-PC MINGW64 /e/tom/cake (master)
$ git checkout jerry-cake
Switched to branch 'jerry-cake'

Administrator@ND-PC MINGW64 /e/tom/cake (jerry-cake)
$ git merge master
Merge made by the 'recursive' strategy.
 banana | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 banana

Administrator@ND-PC MINGW64 /e/tom/cake (jerry-cake)
$ git push origin HEAD:master
Counting objects: 4, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 456 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
To E:/admin/cloud
   8489892..0c6f800  HEAD -> master
```
