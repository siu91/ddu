*2016/01/27 星期三 20:53:32* 

----------
## *scala*基础*(```一些特征```)* ##

- 不刻意区分基本类型和引用类型(```Java中简单区分方法：基本数据类型‘==’，引用类型‘equals()’```)

	    Java引用类型：
	    1. Class，Object，String、Date
	    2. Collection、Array等
	    3. 基本类型的包装类：Short、Intger、Long、Float、Double、Byte、Character、Boolean

- 七种基本数据类型：`short、int、long、float、double、byte、char、boolean`

- 没有包装类型，但提供了`RichInt、RichDouble、RichChar`等工具类。

- 语法：当每行只有一个语句时不需要 `;`

- 没有 `a++`和`a--`

- 可以使用特殊字符命名方法

- 没有参数的方法，没有`()`

- 没有静态方法

- 多数方法规则为：`a.method(arg)`

## *practice* ##

1. 在*Scala REPL*中键入`3.`,然后按`Tab`键。有哪些方法可被调用？

	    scala> 3.
	    %              &              *              +              -
	    /              >              >=             >>             >>>
	    ^              asInstanceOf   isInstanceOf   toByte         toChar
	    toDouble       toFloat        toInt          toLong         toShort
	    toString       unary_+        unary_-        unary_~        |
1.  在*Scala REPL*中，计算`3的平方根`，然后再对该值`求平方`，现在，这个结果与3相差多少？（```提示：res变量是你的朋友```）

	    scala> import math._
	    import math._

	    scala> sqrt(3)
	    res5: Double = 1.7320508075688772

	    scala> pow(res5,2)
	    res6: Double = 2.9999999999999996
1. `res`变量是val还是var？（```答案：val```）

	    scala> res0=1
	    <console>:11: error: reassignment to val
	    res0=1
	      ^

1. *Scala*允许你用数字去乘字符串—去 REPL中试一下 `“crazy” * 3`, 这个操作做什么？在 *Scaladoc*中如何找到这个操作？

	    scala> "crazy"*3
	    res7: String = crazycrazycrazy
1. `10 max 2`的含义是什么？`max`方法定义在哪个类中？

	    scala> 10 max 2
	    res8: Int = 10

	    scala> 2 max 10
	    res9: Int = 10

	    scala> 2 max 1
	    res10: Int = 2

	    scala> math.m
	    max   min
1. 用`BigInt`计算`2的1024次方`。

	    scala> val a : BigInt = 2
	    a: scala.math.BigInt = 2

	    scala> a.pow(1024)
	    res11: scala.math.BigInt = 179769313486231590772930519078902473361797697894230657273430081157732675805500963132708477322407536021120113879871393357658789768814416622492847430639474124377767893424865485276302219601246094119453082952085005768838150682342462881473913110540827237163350510684586298239947245938479716304835356329624224137216
1. 为了在使用`probablePrime(100, Random)`获取随机素数时不在`probablePrime`和`Radom`之前使用任何限定符，你需要引入什么？

	    scala> import scala.math.BigInt.probablePrime
	    import scala.math.BigInt.probablePrime

	    scala> import scala.util.Random
	    import scala.util.Random

	    scala> probablePrime(100, Random)
	    res14: scala.math.BigInt = 798359383762662813538670278007
1. 创建随机文件的方式之一是生成一个随机的`BigInt`，然后把它转换成`三十六进制`，输出类似`qsnveffwfweq434ojjlk`这样的字符串，查阅*scaladoc*，找到在*scala*中实现该逻辑的办法。

	    scala> res14.toString(36)
	    res15: String = 25eha06gg0ih6d6y1zsn
1. 在*Scala*中如何获取字符串的`首字符`和`尾字符`？

	    scala> val str : String = "abcdefg"
	    str: String = abcdefg

	    scala> str.head
	    res20: Char = a

	    scala> str.last
	    res21: Char = g
1. `take, drop, takeRight, dropRight`这些字符串函数是做什么用的？和`substring`相比，它们的优点和缺点都有哪些？

	    scala> str.take(1)
	    res29: String = a

	    scala> str.take(2)
	    res30: String = ab

	    scala> str.take(-1)
	    res31: String = ""

	    scala> str.take(0)
	    res32: String = ""

	    scala> str.takeRight(1)
	    res42: String = g

	    scala> str.takeRight(2)
	    res43: String = fg

	    scala> str.takeRight(-1)
	    res44: String = ""

	    scala> str.takeRight(0)
	    res45: String = ""

	    scala> str.drop(1)
	    res34: String = bcdefg

	    scala> str.drop(2)
	    res35: String = cdefg

	    scala> str.drop(-1)
	    res36: String = abcdefg

	    scala> str.drop(0)
	    res37: String = abcdefg

	    scala> str.dropRight(1)
	    res38: String = abcdef

	    scala> str.dropRight(2)
	    res39: String = abcde

	    scala> str.dropRight(-1)
	    res40: String = abcdefg

	    scala> str.dropRight(0)
	    res41: String = abcdefg


# 控制结构和函数 #

*2016/01/28 星期四 19:39:32*

----------

### 要点： ###
- if表达式有值。
- 块也有值——值是它最后一个表达式的值。
- *Scala*的`for循环`就像是增强版的*Java* `for循环`。
- 分号`;`不是必须的。
- `void`类型是`Unit`。
- 避免在函数式定义中使用`return`。
- 异常与*Java*一样。
- *Scala*没有`受检异常`。

	    受检异常：非RuntimeException
