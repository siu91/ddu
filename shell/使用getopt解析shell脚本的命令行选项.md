2016/2/4 下午2:28:27

---------------------

getopt不是一个标准的unix命令，但主流的Linux发行版中都自带了。  
- [getopt官网](http://frodo.looijaard.name/project/getopt)
- [下载安装](http://frodo.looijaard.name/system/files/software/getopt/getopt-1.1.6.tar.gz)
- [帮助文档](http://frodo.looijaard.name/project/getopt/man/getopt)


具体的用法可以参考官方的示例脚本：
```bash
#!/bin/bash

#echo $@

#-o或--options选项后面接可接受的短选项，如ab:c::，表示可接受的短选项为-a -b -c，其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面接可接受的长选项，用逗号分开，冒号的意义同短选项。
#-n选项后接选项解析错误时提示的脚本名字
# 还有一种 -a或−−alternative Allow long options to start with a single ’−’.
ARGS=`getopt -o ab:c:: --long along,blong:,clong:: -n 'example.sh' -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

#echo $ARGS
#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"

while true
do
    case "$1" in
        -a|--along)
            echo "Option a";
            shift
            ;;
        -b|--blong)
            echo "Option b, argument $2";
            shift 2
            ;;
        -c|--clong)
            case "$2" in
                "")
                    echo "Option c, no argument";
                    shift 2  
                    ;;
                *)
                    echo "Option c, argument $2";
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

#处理剩余的参数
for arg in $@
do
    echo "processing $arg"
done
```
需要注意的是，像上面的-c选项，后面是可接可不接参数的，如果需要传递参数给-c选项，则必须使用如下的方式：
```bash
#./getopt.sh -b 123 -a -c456 file1 file2
Option b, argument 123
Option a
Option c, argument 456
processing file1
processing file2
#./getopt.sh --blong 123 -a --clong=456 file1 file2  
Option b, argument 123
Option a
Option c, argument 456
processing file1
processing file2
```
# 附录
## *GETOPT SYNOPSIS*
```bash
SYNOPSIS
getopt optstring parameters
getopt [options] [−−] optstring parameters
getopt [options] −o|−−options optstring [options] [−−] parameters
```

## *GETOPT OPTIONS*
```bash
OPTIONS
−a, −−alternative

Allow long options to start with a single ’−’.

−h, −−help

Output a small usage guide and exit successfully. No other output is generated.

−l, −−longoptions longopts

The long (multi−character) options to be recognized. More than one option name may be specified at once, by separating the names with commas. This option may be given more than once, the longopts are cumulative. Each long option name in longopts may be followed by one colon to indicate it has a required argument, and by two colons to indicate it has an optional argument.

−n, −−name progname

The name that will be used by the getopt(3) routines when it reports errors. Note that errors of getopt(1) are still reported as coming from getopt.

−o, −−options shortopts

The short (one−character) options to be recognized. If this option is not found, the first parameter of getopt that does not start with a ’−’ (and is not an option argument) is used as the short options string. Each short option character in shortopts may be followed by one colon to indicate it has a required argument, and by two colons to indicate it has an optional argument. The first character of shortopts may be ’+’ or ’−’ to influence the way options are parsed and output is generated (see section SCANNING MODES for details).

−q, −−quiet

Disable error reporting by getopt(3).

−Q, −−quiet−output

Do not generate normal output. Errors are still reported by getopt(3), unless you also use −q.

−s, −−shell shell

Set quoting conventions to those of shell. If no −s argument is found, the BASH conventions are used. Valid arguments are currently ’sh’ ’bash’, ’csh’, and ’tcsh’.

−u, −−unquoted

Do not quote the output. Note that whitespace and special (shell−dependent) characters can cause havoc in this mode (like they do with other getopt(1) implementations).

−T, −−test

Test if your getopt(1) is this enhanced version or an old version. This generates no output, and sets the error status to 4. Other implementations of getopt(1), and this version if the environment variable GETOPT_COMPATIBLE is set, will return ’−−’ and error status 0.

−V, −−version

Output version information and exit successfully. No other output is generated.
```
