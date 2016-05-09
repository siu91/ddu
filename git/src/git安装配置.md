# 安装git

1）windows
安装msysgit，下载地址：http://msysgit.github.io/
安装的时候，基本选择默认设置，但是：
在Adjusting your PATH environment页，勾选Run Git from the Windows Command Prompt
2）ubuntu
用命令“git --version”查看是否已安装，且版本为1.9.5或更高。若没安装或版本太低：
$ sudo apt-get install git-core git-gui git-doc gitk  
3）mac
http://sourceforge.net/projects/git-osx-installer/，不仅能装Git本身（选1.9.5或以上版本），还有GUI的安装包
# 启动git

1）windows
Windows：使用Windows自带的命令行界面
可以在Windows自己的命令行界面下可以直接运行Git命令行，比如
D:/test> git help  
当命令中有些特殊参数的时候，要加上双引号。比如
D:/test> git log HEAD^  

特殊符号^会被Windows误解，所以要加双引号，写成
D:/test> git log "HEAD^"  

Windows：使用msysGit自带的Bash
使用Bash就不用像上面那样加双引号了。启动Git Bash的简便方法是，在Windows Explorer里，适当目录的右键弹出菜单，Git Bash。此外，也可以从Windows开始菜单进入。
初次使用时，点击界面右上角，在菜单中选择“属性”项，在弹出对话框中，勾选上“快速编辑模式”和“插入模式”，这样将来copy paste比较方便。
注意，有利有弊，这个Bash对中文的支持不太好。
2）linux
$ git help  

# 设置git

不论Windows还是Linux还是Mac，建议至少config下述内容

- git config --global user.name "test"                  # 请换成你自己的名字，除非你凑巧也叫wukong.sun  
- git config --global user.email "test@163.com"         # 同上  
- git config --global push.default simple               # 要是你非要用低版本的Git（比如1.7.x），好吧，那就不设simple设current，否则你的Git不支持  
- git config --global core.autocrlf false               # 让Git不要管Windows/Unix换行符转换的事  
- git config --global gui.encoding utf-8                # 避免git gui中的中文乱码  
- git config --global core.quotepath off                # 避免git status显示的中文文件名乱码  
其中最后两个配置是关于中文乱码的，基本够用了。
Windows上还需要配置：
- git config --global core.ignorecase false  

# 设置SSH

- 在Linux的命令行下，或Windos上Git Bash命令行窗口中（总之不要用iOS），键入：
$ssh-keygen -t rsa -C "test@163.com"  
然后一路回车，不要输入任何密码之类，生成ssh key pair。然后就生成一个目录.ssh ，里面有两个文件：id_rsa , id_rsa.pub
- 如果在Linux上，需要把其中的私钥告诉本地系统：
$ ssh-add ~/.ssh/id_rsa  

- 再把其中公钥的内容复制到GitLab上。具体方法是：
显示ssh公钥的内容：
$ cat ~/.ssh/id_rsa.pub  
打开github页面：https://github.com/settings/profile，选择SSH Keys，然后点击Add SSH Key，把刚才ssh公钥id_rsa.pub（windows下的用户目录找到.ssh文件夹进去就可以看到）的内容paste进去。不需要填title，title会自动生成。
注意：需要copy最开头的“ssh-rsa ”这几个字。
