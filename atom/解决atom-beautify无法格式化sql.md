先上error：
```
Error: Could not find 'sqlformat'. The program may not be installed.
See https://github.com/andialbrecht/sqlparse for program installation instructions.
Your program is properly installed if running 'where.exe sqlformat' in your CMD prompt returns an absolute path to the executable. If this does not work then you have not installed the program correctly and so Atom Beautify will not find the program. Atom Beautify requires that the program be found in your PATH environment variable.
Note that this is not an Atom Beautify issue if beautification does not work and the above command also does not work: this is expected behaviour, since you have not properly installed your program. Please properly setup the program and search through existing Atom Beautify issues before creating a new issue. See https://github.com/Glavin001/atom-beautify/search?q=sqlformat&type=Issues for related Issues and https://github.com/Glavin001/atom-beautify/tree/master/docs for documentation. If you are still unable to resolve this issue on your own then please create a new issue and ask for help.
```
`sqlformat`未安装。  
看了网上有人一样的错误。GitHub也有这个[issues](https://github.com/Glavin001/atom-beautify/issues/397)
作者的解答。
```text
Glavin001 commented on 12 Jun 2015
I was hoping to see more about your PATH environment variable from the Help Debug Editor logs...

Let's try this another way:

run echo %PATH% in your CMD prompt
run process.env.PATH in the JavaScript Console of Atom's Developer Tools (Atom -> View -> Developer -> Toggle Developer Tools)
I hope to see that 1) they match and 2) D:\Python34\Scripts\ is found in both of them, thus indicating that sqlformat has been installed properly.
```
意思大概是系统的环境变量里面的*`PATH`*要和aotm里面的一样。  
atom可执行安装时在系统里面默认的环境变量`ATOM_HOME`在：`C:\Users\{usernane}}\AppData\Local\atom\bin`，所以只要安装好[sqlparse](https://github.com/andialbrecht/sqlparse),然后把`sqlformat`拷贝到`ATOM_HOME`里。

---------
## 安装*[sqlparse](https://github.com/andialbrecht/sqlparse)*
```
python setup.py install
```
## 将`sqlformat`拷贝到`ATOM_HOME`
