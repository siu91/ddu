先说重点。记住：
```不要用git pull，用git fetch和git merge代替它。```


### Git中从远程的分支获取最新的版本到本地有这样2个命令：
- git fetch：相当于是从远程获取最新版本到本地，不会自动merge

- git pull：相当于是从远程获取最新版本并merge到本地

### git pull origin master
- 上述命令其实相当于git fetch 和 git merge
- 在实际使用中，git fetch更安全一些，因为在merge前，我们可以查看更新情况，然后再决定是否合并
