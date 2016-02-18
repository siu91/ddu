- git clone git@github.com:gongice/ops.git
```shell
$ git clone git@github.com:gongice/ops.git
Cloning into 'ops'...
remote: Counting objects: 813, done.
Receiving objects: 100% (813/813), 514.64 KiB | 94.00 KiB/s, done
Resolving deltas:   0% (0/445)
Resolving deltas: 100% (445/445), done.
Checking connectivity... done.
```
- $ git status  
```shell
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in wor

        modified:   .gitignore
        modified:   README.md
        modified:   a2l
        modified:   ap
        modified:   c
        modified:   check-vm.py
        modified:   colines
        modified:   console-text-color-themes.sh
        modified:   cp-svn-url.sh
        modified:   docs/install.md
        modified:   docs/java.md
        modified:   docs/shell.md
        modified:   docs/vcs.md
        modified:   echo-args.sh
        modified:   find-in-jars.sh
        modified:   monitor-host.sh
        modified:   parseOpts.sh
        modified:   rp
        modified:   show-busy-java-threads.sh
        modified:   show-cpu-and-memory.sh
        modified:   show-duplicate-java-classes
        modified:   svn-merge-stop-on-copy.sh
        modified:   swtrunk.sh
        modified:   tcp-connection-state-counter.sh
        modified:   test-cases/parseOpts-test.sh
        modified:   test-cases/self-installer.sh
        modified:   tpl/run-cmd-tpl.sh
        modified:   xpf
        modified:   xpl
Untracked files:
  (use "git add <file>..." to include in what will be commit
        run-remote.sh
        "\346\265\213\350\257\225/"
no changes added to commit (use "git add" and/or "git commit
```

- $ git commit -m "add run-remote.sh"

- $ git push origin master
```shell
Counting objects: 11, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (8/8), 1.33 KiB | 0 bytes/s, done.
Total 8 (delta 4), reused 0 (delta 0)
To git@github.com:gongice/ops.git
   78bd3fe..35d0919  master -> master
   ```
