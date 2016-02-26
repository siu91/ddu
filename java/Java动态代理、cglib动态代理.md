说动态代理，需要先清楚静态代理。所谓静态代理就是程序员提前实现好的代理类，编译后class文件是已经存在的。
实现原理，利用Java代理模式，由一个代理类持有委托类的实例，并实现委托类一样的接口，来实现增强方法的目的。
我们主要用它来做方法的增强，让你可以在不修改源码的情况下，增强一些方法，在方法执行前后做任何你想做的事情，甚至根本不去执行这个方法。因为在InvocationHandler的invoke方法中，你可以直接获取正在调用方法对应的Method对象。比如可以添加调用日志，做事务控制，对方法进行缓存等。
Spring容器代替工厂，Spring AOP代替JDK动态代理，让面向切面编程更容易实现。在Spring的帮助下轻松添加，移除动态代理，且对源代码无任何影响。
本文给出静态代理、JDK动态代理、CGLIB动态代理的三种例子。
## 一、静态代理
在了解代理模式的情况下看下面的代码，没什么可说的。
```java
package com.shanhy.demo.proxy;

public interface Account {

    public void queryAccount();

    public void updateAccount();

}
```
```java
package com.shanhy.demo.proxy;

public class AccountImpl implements Account {

    @Override
    public void queryAccount() {
        System.out.println("查看账户");
    }

    @Override
    public void updateAccount() {
        System.out.println("修改账户");
    }

}
```
```java
package com.shanhy.demo.proxy;

public class AccountProxy implements Account {

    private Account account;

    public AccountProxy(Account account) {
        super();
        this.account = account;
    }

    @Override
    public void queryAccount() {
        System.out.println("代理before");
        account.queryAccount();
        System.out.println("代理after");
    }

    @Override
    public void updateAccount() {
        System.out.println("代理before");
        account.updateAccount();
        System.out.println("代理after");
    }

}
```
```java
package com.shanhy.demo.proxy;

public class AccountProxyTest {

    public static void main(String[] args) {
        // AccountProxy为自己实现的代理类，可以发现，一个代理类只能为一个接口服务。
        Account account = new AccountImpl();
        AccountProxy proxy = new AccountProxy(account);
        proxy.queryAccount();
        proxy.updateAccount();
    }
}
```
## 二、JDK动态代理
使用JDK动态代理使用到一个Proxy类和一个InvocationHandler接口。
Proxy已经设计得非常优美，但是还是有一点点小小的遗憾之处，那就是它仅支持interface代理（也就是代理类必须实现接口），因为它的设计注定了这个遗憾。
```java
package com.shanhy.demo.proxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class AccountProxyFactory implements InvocationHandler {

    private Object target;

    public Object bind(Object target){
        // 这里使用的是Jdk的动态代理，其必须要绑定接口，在我们的业务实现中有可能是没有基于接口是实现的。所以说这个缺陷cglib弥补了。
        this.target = target;
        return Proxy.newProxyInstance(target.getClass().getClassLoader(),
                target.getClass().getInterfaces(), this);
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
//      System.out.println(Proxy.isProxyClass(proxy.getClass()));
        boolean objFlag = method.getDeclaringClass().getName().equals("java.lang.Object");

        Object result = null;
        if(!objFlag)
            System.out.println("代理before");
        result = method.invoke(this.target, args);
        if(!objFlag)
            System.out.println("代理after");
        return result;
    }


}
```
```java
package com.shanhy.demo.proxy;

public class AccountProxyTest {

    public static void main(String[] args) {
        // 下面使用JDK的代理类，一个代理就可以代理很多接口
        Account account1 = (Account)new AccountProxyFactory().bind(new AccountImpl());
        System.out.println(account1);
        account1.queryAccount();
}
```
## 三、CGLIB动态代理
对于上面说到JDK仅支持对实现接口的委托类进行代理的缺陷，这个问题CGLIB给予了很好的补位，解决了这个问题，使其委托类也可是非接口实现类。
CGLIB内部使用到ASM，所以我们下面的例子需要引入asm-3.3.jar、cglib-2.2.2.jar
```java
package com.shanhy.demo.proxy;

import java.lang.reflect.Method;

import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

public class AccountCglibProxyFactory implements MethodInterceptor{

    private Object target;

    public Object getInstance(Object target){
        this.target = target;
        return Enhancer.create(this.target.getClass(), this);

//      Enhancer enhancer = new Enhancer();//该类用于生成代理对象
//      enhancer.setSuperclass(this.target.getClass());//设置父类
//      enhancer.setCallback(this);//设置回调用对象为本身
//      return enhancer.create();
    }

    @Override
    public Object intercept(Object obj, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
        // 排除Object类中的toString等方法
        boolean objFlag = method.getDeclaringClass().getName().equals("java.lang.Object");
        if(!objFlag){
            System.out.println("before");
        }
        Object result = null;
//      我们一般使用proxy.invokeSuper(obj,args)方法。这个很好理解，就是执行原始类的方法。还有一个方法proxy.invoke(obj,args)，这是执行生成子类的方法。
//      如果传入的obj就是子类的话，会发生内存溢出，因为子类的方法不挺地进入intercept方法，而这个方法又去调用子类的方法，两个方法直接循环调用了。
        result = methodProxy.invokeSuper(obj, args);
//      result = methodProxy.invoke(obj, args);
        if(!objFlag){
            System.out.println("after");
        }
        return result;
    }

}
```
```java
package com.shanhy.demo.proxy;

public class Person {

    public void show(){
        System.out.println("showing");
    }
}
package com.shanhy.demo.proxy;

public class AccountProxyTest {

    public static void main(String[] args) {
        // 下面是用cglib的代理
        // 1.支持实现接口的类
        Account account2 = (Account)new AccountCglibProxyFactory().getInstance(new AccountImpl());
        account2.updateAccount();

        // 2.支持未实现接口的类
        Person person = (Person)new AccountCglibProxyFactory().getInstance(new Person());
        System.out.println(person);
        person.show();
    }
}
```
[原文](https://yq.aliyun.com/articles/6668?spm=5176.100239.yqblog1.56.x3T4IG)
