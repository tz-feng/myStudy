# 1、Spring

## 1.1、简介

- Spring：春天------>给软件行业带来了春天！
- 2020，首次推出了Spring框架的雏形：interface21框架！
- Spring框架即以interface21框架为基础，经过重新设计，并不断丰富其内涵，于2004年3月24日，发布了1.0正式版。
- Rod Johnson，Spring Framework创始人，著名作者。Rod在悉尼大学不仅获得了计算机学位，同时还获得了音乐学位。更令人吃惊的是在回到软件开发领域之前，他还获得了音乐学的博士学位。
- Spring理念：是现有的技术更加容易使用，本身是一个大杂烩整合了现有的技术框架。



- SSH：Struct2 + Spring +Hibernate！
- SSM：Spring + SpringMVC + Mybatis！



官网：https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/overview.html#overview-philosophy

官方下载地址：https://repo.spring.io/release/org/springframework/spring/

GitHub：https://github.com/spring-projects/spring-framework



```xml
<!-- https://mvnrepository.com/artifact/org.springframework/spring-webmvc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.2.8.RELEASE</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.springframework/spring-jdbc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>5.2.8.RELEASE</version>
</dependency>
```



## 1.2、优点

- Spring是一个开源的免费的框架（容器）！
- Spring是一个轻量级的、非入侵式的的框架！
- 控制反转（IOC），面向切面编程（AOP）！
- 支持事务的处理，对框架整合的支持！



==Spring就是一个轻量级的控制反转（IOC）和面向切面编程（AOP）的框架！==



## 1.3、组成

![image-20200901210506631](D:\Typora-photos\spring\image-20200901210506631.png)

**核心容器（Spring Core）**

　　核心容器提供Spring框架的基本功能。Spring以bean的方式组织和管理Java应用中的各个组件及其关系。Spring使用BeanFactory来产生和管理Bean，它是工厂模式的实现。BeanFactory使用控制反转(IoC)模式将应用的配置和依赖性规范与实际的应用程序代码分开。

**应用上下文（Spring Context）**

　　Spring上下文是一个配置文件，向Spring框架提供上下文信息。Spring上下文包括企业服务，如JNDI、EJB、电子邮件、国际化、校验和调度功能。

**Spring面向切面编程（Spring AOP）**

　　通过配置管理特性，Spring AOP 模块直接将面向方面的编程功能集成到了 Spring框架中。所以，可以很容易地使 Spring框架管理的任何对象支持 AOP。Spring AOP 模块为基于 Spring 的应用程序中的对象提供了事务管理服务。通过使用 Spring AOP，不用依赖 EJB 组件，就可以将声明性事务管理集成到应用程序中。

**JDBC和DAO模块（Spring DAO）**

　　JDBC、DAO的抽象层提供了有意义的异常层次结构，可用该结构来管理异常处理，和不同数据库供应商所抛出的错误信息。异常层次结构简化了错误处理，并且极大的降低了需要编写的代码数量，比如打开和关闭链接。

**对象实体映射（Spring ORM）**

　　Spring框架插入了若干个ORM框架，从而提供了ORM对象的关系工具，其中包括了Hibernate、JDO和 IBatis SQL Map等，所有这些都遵从Spring的通用事物和DAO异常层次结构。

**Web模块（Spring Web）**

　　Web上下文模块建立在应用程序上下文模块之上，为基于web的应用程序提供了上下文。所以Spring框架支持与Struts集成，web模块还简化了处理多部分请求以及将请求参数绑定到域对象的工作。

**MVC模块（Spring Web MVC）**

　　MVC框架是一个全功能的构建Web应用程序的MVC实现。通过策略接口，MVC框架变成为高度可配置的。MVC容纳了大量视图技术，其中包括JSP、POI等，模型来有JavaBean来构成，存放于m当中，而视图是一个街口，负责实现模型，控制器表示逻辑代码，由c的事情。Spring框架的功能可以用在任何J2EE服务器当中，大多数功能也适用于不受管理的环境。Spring的核心要点就是支持不绑定到特定J2EE服务的可重用业务和数据的访问的对象，毫无疑问这样的对象可以在不同的J2EE环境，独立应用程序和测试环境之间重用。



## 1.4、扩展

在Spring的官网有这个介绍：现代化的Java开发！说白了就是基于Spring的开发！

![image-20200901210852701](D:\Typora-photos\spring\image-20200901210852701.png)



- Spring Boot
  - 一个快速开发的脚手架。
  - 基于SpringBoot可以快速的开发单个微服务。
  - 约定大于配置！
- Spring Cloud
  - SpringCloud是基于SpringBoot实现的。



因为现在大多数的公司都在使用SpringBoot进行快速开发，学习SpringBoot的前提，需要完全掌握Spring及SpringMVC！承上启下的作用！



**弊端：发展了太久之后，违背了原来的理念！配置十分繁琐，人称“地狱配置！”**



# 2、IOC理论推导

 原始开发：

1.UserDao 接口

2.UserDaoImpl 实现类

3.UserService 业务接口

4.UserServiceImpl 业务实现类



在之前的业务中，用户的需求可能会影响我们原来的代码，我们需要根据用户的需求去修改原代码！如果程序代码量十分大，修改一次的成本代价十分昂贵！



我们使用一个Set接口实现。已经发生了革命性的变化！

```java
private UserDao userDao;

    //利用set进行动态实现值的注入
    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
```



- 之前，程序是主动创建对象！控制权在程序员手上！
- 使用了set注入后，程序不在具有主动性，而是变成了被动的接收对象！



这种思想，从本质上解决了问题，我们程序员不用再去管理对象的创建了。系统的耦合性大大降低~，可以更加专注的在业务的实现上！这是IOC的原型！



## IOC本质

**控制反转IoC(Inversion of Control)，是一种设计思想，DI(依赖注入)是实现IoC的一种方法**，也有人认为DI只是IoC的另一种说法。没有IoC的程序中，我们使用面向对象编程，对象的创建与对象间的依赖关系完全硬编码在程序中，对象的创建由程序自己控制，控制反转后将对象的创建转移给第三方，个人认为所谓的控制反转就是：获得依赖对象的方式反转了。



采用XML方式配置Bean的时候，Bean的定义信息和实现分离的，而采用注解的方式可以把两者合为一体，Bean的定义信息直接以注解的形式定义在实现类中，从而达到了零配置的目的。

**控制反转是一种通过描述（XML或注解）并通过第三方去生产或获取特定对象的方式。在Spring中实现控制反转的是IoC容器，其实现方式是依赖注入（Dependency Injection，DI）。**



# 3、HelloSpring

> 导入Jar包

注 : spring 需要导入commons-logging进行日志记录 . 我们利用maven , 他会自动下载对应的依赖项 .

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.2.8.RELEASE</version>
</dependency>
```



> 编写代码

1、编写一个Hello实体类

```java
public class Hello {

    private String str;

    public String getStr() {
        return str;
    }

    public void setStr(String str) {
        this.str = str;
    }

    @Override
    public String toString() {
        return "Hello{" +
                "str='" + str + '\'' +
                '}';
    }
}
```



2、编写我们的spring文件 , 这里我们命名为beans.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--使用Spring来创建对象，在Spring这些都称为Bean

    类型 变量名 = new 类型();
    Hello hello = new Hello();

    id = 变量名
    class = new 的对象
    property 相当于给对象中的属性设置一个值！
    -->
    <bean id="hello" class="com.yjy.pojo.Hello">
        <property name="str" value="spring"/>
    </bean>

</beans>
```



3、我们可以去进行测试了 .

```java
public class MyTest {

    public static void main(String[] args) {
        //读取程序上下文
        ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");

        //获取bean对象
        Hello hello = (Hello)context.getBean("hello");
        System.out.println(hello.toString());
    }

}
```



> 思考

- Hello 对象是谁创建的 ?  hello 对象是由Spring创建的
- Hello 对象的属性是怎么设置的 ?  hello 对象的属性是由Spring容器设置的

这个过程就叫控制反转 :

- 控制 : 谁来控制对象的创建 , 传统应用程序的对象是由程序本身控制创建的 , 使用Spring后 , 对象是由Spring来创建的
- 反转 : 程序本身不创建对象 , 而变成被动的接收对象 .

依赖注入 : 就是利用set方法来进行注入的.

IOC是一种编程思想，由主动的编程变成被动的接收

可以通过newClassPathXmlApplicationContext去浏览一下底层源码 .



> 修改案例一

我们在案例一中， 新增一个Spring配置文件beans.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="mysqlImpl" class="com.yjy.dao.UserDaoMysqlImpl"/>
    <bean id="oracleImpl" class="com.yjy.dao.UserDaoOracleImpl"/>

    <bean id="userServiceImpl" class="com.yjy.service.UserServiceImpl">
        <!--
            ref : 引用Spring容器中创建好的对象
            value : 具体的值，基本数据类型！
        -->
        <property name="userDao" ref="oracleImpl"/>
    </bean>

</beans>
```

测试！

```java
public class MyTest {

    public static void main(String[] args) {

        //获取ApplicationContext：拿到Spring的容器
        ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");

        //需要什么，就直接从容器中取即可。
        UserServiceImpl userServiceImpl = (UserServiceImpl) context.getBean("userServiceImpl");

        userServiceImpl.getUser();

    }
}
```

OK , 到了现在 , 我们彻底不用再程序中去改动了 , 要实现不同的操作 , 只需要在xml配置文件中进行修改 , 所谓的IoC,一句话搞定 : 对象由Spring 来创建 , 管理 , 装配 !



# 4、IOC创建对象的方式

1.使用无参构造创建对象，默认！

```xml
<!--无参构造-->
    <bean id="user" class="com.yjy.pojo.User">
        <property name="name" value="yjy"/>
    </bean>
```



2.三种有参构造创建对象的方法

（1）通过下标赋值 

```xml
<!--方法一：下标赋值-->
<bean id="user" class="com.yjy.pojo.User">
    <constructor-arg index="0" value="yjy"/>
</bean>
```



（2）通过参数类型赋值（如果一个有参构造中出现了同种类型则无法使用）

```xml
<!--方法二：类型赋值-->
<bean id="user" class="com.yjy.pojo.User">
    <constructor-arg type="java.lang.String" value="hxh"/>
</bean>
```



（3）通过参数名赋值（最常用）

```xml
<!--方法三：参数名赋值-->
<bean id="user" class="com.yjy.pojo.User">
    <constructor-arg name="name" value="yjy"/>
</bean>
```



总结：在配置文件加载的时候，容器中管理的对象就已经初始化了！在IOC容器中只有一份实例。



# 5、Spring配置

## 5.1、别名

```xml
<!--别名，如果添加了别名，我们也可以使用别名获取到这个对象-->
<alias name="user" alias="userNew"/>
```



## 5.2、Bean的配置

```xml
<!--
    id : bean 的唯一标识符，也就是相当于我们学的对象名
    class : bean 对象所对应的全限定名：包名 + 类型
    name : 也是别名，而且name 可以同时取多个别名，只需通过逗号,空格或分号分隔。
-->
<bean id="userT" class="com.yjy.pojo.UserT" name="user2,u2 u3;u4">
    <property name="name" value="yjy"/>
</bean>
```





## 5.3、import

这个import，一般用于团队开发使用，它可以将多个配置文件，导入合并为一个

假设，现在项目中有多个人开发，这三个人负责不同类的开发，不同的类需要注册在不同的bean中，我们可以利用import将所有人的beans.xml合并为一个总的！

- 张三

- 李四

- 王五

- applicationContext.xml

  ```xml
  <import resource="beans.xml"/>
  <import resource="beans2.xml"/>
  <import resource="beans3.xml"/>
  ```

如果不同的配置文件有相同的内容，那么他会去合并其内容。

使用的时候，直接使用总的配置就可以了



# 6、依赖注入

## 6.1构造器注入

参考：4、IOC创建对象的方式



## 6.2、set方式注入【重点】

- 依赖注入：Set注入
  - 依赖：bean对象的创建依赖于容器！
  - 注入：bean对象中的所有属性，由容器注入！



【环境搭建】

1.复杂类型

```java
public class Address {

    private String address;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
```



2.真实测试对象

```java
public class Student {

    private String name;
    private Address address;
    private String[] books;
    private List<String> hobbys;
    private Map<String,String> card;
    private Set<String> games;
    private String wife;
    private Properties info;
```



3.beans.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="student" class="com.yjy.pojo.Student">
        <!--第一种，普通值注入，value-->
        <property name="name" value="yjy"/>
    </bean>

</beans>
```



4.测试类

```java
public class MyTest {

    public static void main(String[] args) {

        ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
        Student student = (Student) context.getBean("student");
        System.out.println(student.getName());
    }

}
```

完善注入信息：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="address" class="com.yjy.pojo.Address">
        <property name="address" value="广州"/>
    </bean>

    <bean id="student" class="com.yjy.pojo.Student">
        <!--普通值注入-->
        <property name="name" value="yjy"/>

        <!--对象注入-->
        <property name="address" ref="address"/>

        <!--数组注入-->
        <property name="books">
            <array>
                <value>西游记</value>
                <value>水浒传</value>
                <value>红楼梦</value>
                <value>三国演义</value>
            </array>
        </property>

        <!--list注入-->
        <property name="hobbys">
            <list>
                <value>听歌</value>
                <value>敲代码</value>
                <value>打游戏</value>
            </list>
        </property>

        <!--map注入-->
        <property name="card">
            <map>
                <entry key="身份证" value="111111222222223333"/>
                <entry key="银行卡" value="12356165165161321654"/>
            </map>
        </property>

        <!--set注入-->
        <property name="games">
            <set>
                <value>LOL</value>
                <value>COC</value>
                <value>BOB</value>
            </set>
        </property>

        <!--null注入-->
        <property name="wife">
            <null/>
        </property>

        <!--Properties注入-->
        <property name="info">
            <props>
                <prop key="url">127.0.0.1</prop>
                <prop key="port">3306</prop>
                <prop key="username">root</prop>
                <prop key="password">123456</prop>
            </props>
        </property>

    </bean>

</beans>
```



## 6.3、拓展方式注入

我们可以实使用 p命名空间和 c命名空间进行注入

官方解释：

![image-20200902174042534](D:\Typora-photos\spring\image-20200902174042534.png)



> 使用

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--p命名空间注入，可以直接注入属性的值：property-->
    <bean id="user" class="com.yjy.pojo.User" p:name="yjy" p:age="22"/>

    <!--c命名空间注入，通过构造器注入：constructor-arg-->
    <bean id="user2" class="com.yjy.pojo.User" c:name="hxh" c:age="22"/>

</beans>
```



> 测试

```java
@Test
public void test(){
    ApplicationContext context = new ClassPathXmlApplicationContext("userBeans.xml");
    User user = context.getBean("user", User.class);
    System.out.println(user.toString());
}
```



注意：p命名和c命名空间不可以直接使用，需要导入xml约束

```xml
xmlns:p="http://www.springframework.org/schema/p"
xmlns:c="http://www.springframework.org/schema/c"
```



## 6.4、Bean的作用域

![image-20200902180143237](D:\Typora-photos\spring\image-20200902180143237.png)

中文：

![image-20200902180211634](D:\Typora-photos\spring\image-20200902180211634.png)

1.单例模式（Spring默认机制）

```xml
<bean id="user" class="com.yjy.pojo.User" p:name="yjy" p:age="22" scope="singleton"/>
```



2.原型模式：每次从容器中get的是都，都会产生一个新对象！

```xml
<bean id="user" class="com.yjy.pojo.User" p:name="yjy" p:age="22" scope="prototype"/>
```



3.其余的request、session、application、这些只能在web开发使用到！



# 7、Bean的自动装配

- 自动装配式Spring满足bean依赖的一种方式！
- Spring会在上下文自动寻找，并自动给bean装配属性！



在Spring中的三种装配方式

1.在xml中显示配置

2.在java中显示装配

3.隐式的自动装配bean【重要】



## 7.1、测试

环境配置：一个人拥有两只宠物！





## 7.2、ByName自动装配

```xml
<!--
    ByName：会自动在容器上下文查找，和自己对象set方法后面的值对应的beanid！
    -->
<bean id="people" class="com.yjy.pojo.People" autowire="byName">
    <property name="name" value="yjy"/>
</bean>
```



## 7.3、ByType自动装配

```xml
<bean class="com.yjy.pojo.Dog"/>
<bean class="com.yjy.pojo.Cat"/>

<!--
    ByName：会自动在容器上下文查找，和自己对象set方法后面的值对应的beanid！
    ByType：会自动在容器上下文查找，和自己对象属性类型相同的bean！
    -->
<bean id="people" class="com.yjy.pojo.People" autowire="byType">
    <property name="name" value="yjy"/>
</bean>
```



小结：

- byname的时候，需要保证所有bean的id唯一，并且这个bean需要和自动注入的属性的set方法的值一致！
- bytype的时候，需要保证所有bean的class唯一，并且这个bean需要和自动注入的属性的类型一致！



## 7.4、使用注解实现自动装配

jdk1.5支持注解，Spring2.5就支持注解！

The introduction of annotation-based configuration raised the question of whether this approach is “better” than XML.

要使用注解须知：

1. 导入约束：context约束

2. ==配置注解的支持：<context:annotation-config/>==

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           https://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           https://www.springframework.org/schema/context/spring-context.xsd">
   
       <context:annotation-config/>
   
   </beans>
   ```



**@Autowired**

直接在属性上使用即可！也可以在set方法上使用！

使用Autowired 我们可以不用编写set方法了，前提是你这个自动装配的属性在IOC（Spring）容器中存在！

Autowired是现根据bytype进行注入，如果同一种类型的bean的个数大于1，那么就根据byname注入。



科普：

```xml
@Nullable		字段标记了这个注解，说明这个字段可以为null
```



```java
public @interface Autowired {

	/**
	 * Declares whether the annotated dependency is required.
	 * <p>Defaults to {@code true}.
	 */
	boolean required() default true;

}
```



测试

```xml
<bean id="dog1" class="com.yjy.pojo.Dog"/>

<!--
    ByName：会自动在容器上下文查找，和自己对象set方法后面的值对应的beanid！
    ByType：会自动在容器上下文查找，和自己对象属性类型相同的bean！
    -->
<bean id="people" class="com.yjy.pojo.People">
    <property name="name" value="yjy"/>
</bean>
```



```java
public class People {

    private String name;
    //如果显示定义了Autowired的required属性为false，说明这个对象可以为null，否则不允许为空
    @Autowired(required = false)
    private Cat cat;
    @Autowired
    private Dog dog;
}
```



```java
@Test
public void test1() {
    ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
    People people = context.getBean("people", People.class);
    people.getDog().shout();
    System.out.println(people.getCat());
}
```



如果@Autowired自动装配的环境比较复杂，自动装配无法通过一个注解【@Autowired】完成的时候、我们可以使用@Qualifier(value = "xxx")去配置@Autowired的使用，指定一个唯一的bean对象注入！

```java
public class People {

    private String name;
    @Autowired
    @Qualifier(value = "cat1")
    private Cat cat;
    @Autowired
    private Dog dog;
}
```



**@Resource注解**

```java
public class People {

    private String name;
    @Resource(name = "cat1")
    private Cat cat;
    @Resource
    private Dog dog;
}
```



小结：

@Resource 和 @Autowired 的区别：

- 都是用来自动装配，都可以放在属性字段上，但是Resource 是java自带的，不需要开启注解也能使用。
- @Autowired 先根据类型，然后再根据名字装配。@Resource 先根据名字，然后再根据类型装配。



# 8、使用注解开发

在Spring4之后，要使用注解开发，必须要保证 aop的包导入了

![image-20200902213707723](D:\Typora-photos\spring\image-20200902213707723.png)



使用注解需要导入context约束，增加注解的支持！



1. bean

2. 属性如何注入

   ```java
   //相当于 <bean id="user" class="com.yjy.pojo.User"/>
   @Component
   public class User {
   
       public String name;
   
       //相当于  <property name="name" value="yjy"/>
       @Value("yjy")
       public void setName(String name) {
           this.name = name;
       }
   }
   ```

   

3. 衍生的注解

   @Component有几个衍生注解，我们在web开发忠会按照mvc三层架构分层！

   - dao    【@Repository】

   - service    【@Service】

   - controller    【@Controller】

     这四个注解功能都是一样的，都是代表将某个类注册到Spring中，装配Bean

4. 自动装配

   ```xml
   - @Autowired：自动装配，先根据类型，然后再根据名字。如果不能根据类型和名字进行自动装配，那么就需要使用@Qualifier(value="xxx")。
   - @Qualifier：如果Autowired 不能根据类型和名字进行自动装配，那么就为它指定一个bean。
   - @Resource：自动装配，先根据名字，然后再根据类型。
   - @Nullable：字段标记了这个注解，说明这个字段可以为null
   ```

   

5. 作用域

   ```java
   //相当于 <bean id="user" class="com.yjy.pojo.User"/>
   @Component
   //设置bean的作用域，相当于scope=“singleton”
   @Scope("singleton")
   public class User {
   
       public String name;
   
       //相当于  <property name="name" value="yjy"/>
       @Value("yjy")
       public void setName(String name) {
           this.name = name;
       }
   }
   ```

   

6. 小结

   xml 与 注解：

   - xml 更加万能，适用于任何场合！维护简单方便
   - 注解 不是自己类是用不了，维护相对复杂！

   xml 与 注解 的最佳实践：

   - xml 用来管理bean；

   - 注解只负责完成属性的注入；

   - 我们在使用的过程中，只需要注意一个问题：必须让注解生效，就需要开启注解支持

     ```xml
     <!--指定要扫描的包，这个包下的注解就会生效-->
     <context:component-scan base-package="com.yjy.pojo"/>
     <!--开启注解的支持-->
     <context:annotation-config/>
     ```

     

注解说明：

- @Autowired：自动装配，先根据类型，然后再根据名字。如果不能根据类型和名字进行自动装配，那么就需要使用@Qualifier(value="xxx")。
- @Qualifier：如果Autowired 不能根据类型和名字进行自动装配，那么就为它指定一个bean。
- @Resource：自动装配，先根据名字，然后再根据类型。
- @Nullable：字段标记了这个注解，说明这个字段可以为null
- @Component：组件，放在类上，说明这个类被Spring管理，就是bean
- @Scope：设置bean的作用域



# 9、使用Java的方式配置Spring

我们现在要完全不使用Spring的xml配置了，全权交给Java来做！

JavaConfig 是Spring的一个子项目，在Spring 4 之后，他成为了一个核心功能

![image-20200902223827772](D:\Typora-photos\spring\image-20200902223827772.png)



实体类

```java
//这里这个注解的意思，就是说明这个类被Spring接管了，注册到了容器中
@Component
public class User {

    private String name;

    public String getName() {
        return name;
    }

    @Value("yjy")// 属性注入
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                '}';
    }
}
```



配置类

```java
// 这个也被Spring容器托管，注册到容器中，因为他本来就是一个@Component
// @Configuration代表这是一个配置类，就和我们之前看的beans.xml一样
@Configuration
@ComponentScan("com.yjy.pojo")
@Import(MyConfig2.class)
public class MyConfig {

    //注册一个bean，就相当于我们之前写的一个bean标签
    //这个方法的名字，就相当于bean标签中的id属性
    //这个方法的返回值，就相当于bean标签中的class属性
    @Bean
    public User user() {
        return new User();// 就是返回要注入到bean的对象！
    }

}
```



测试类

```java
public class MyTest {

    @Test
    public void test() {
        //如果完全使用了配置类方式去做，我们就只能通过 annotationConfig 上下文来获取容器，通过配置类的class对象加载！
        ApplicationContext context = new AnnotationConfigApplicationContext(MyConfig.class);
        User user = context.getBean("user", User.class);
        System.out.println(user.getName());
    }

}
```



这种纯Java的配置方式，在SpringBoot中随处可见!



# 10、代理模式

为什么要学习代理模式？因为这就是SpringAOP的底层！【SpringAOP 和 SpringMVC】

代理模式的分类：

- 静态代理
- 动态代理

![image-20200903110748758](D:\Typora-photos\spring\image-20200903110748758.png)



## 10.1、静态代理

角色分析：

- 抽象角色：一半会使用接口或者抽象类来解决
- 真实角色：被代理的角色
- 代理角色：代理真实角色，代理真实角色后，我们一般会做一些附属操作
- 客户：访问代理对象的人！



代码步骤：

1. 接口

   ```java
   //租房
   public interface Rent {
   
       public void rent();
   
   }
   ```

   

2. 真实角色

   ```java
   //房东
   public class Host implements Rent{
   
       @Override
       public void rent() {
           System.out.println("房东要出租房子");
       }
   
   }
   ```

   

3. 代理角色

   ```java
   public class Proxy implements Rent{
   
       private Host host;
   
       public Proxy() {
   
       }
   
       public Proxy(Host host) {
           this.host = host;
       }
   
       @Override
       public void rent() {
           seeHouse();
           host.rent();
           hetong();
           fare();
       }
   
       //看房
       public void seeHouse() {
           System.out.println("中介带你看房");
       }
   
       //合同
       public void hetong() {
           System.out.println("签租赁合同");
       }
   
       //收中介费
       public void fare() {
           System.out.println("收中介费");
       }
   }
   ```

   

4. 客户端访问代理角色

   ```java
   public class Client {
   
       public static void main(String[] args) {
           //房东要租房子
           Host host = new Host();
           //代理，中介帮房东租房子，但是呢？代理角色一般会有一些附属操作！
           Proxy proxy = new Proxy(host);
           //你不用面对房东，直接找中介租房即可！
           proxy.rent();
       }
   
   }
   ```



代理模式的好处：

- 可以使真实角色的操作更加纯粹！不用去关注一些公共业务
- 公共业务就交割代理角色！实现了业务的分工！
- 公共业务方式扩展的时候，方便集中管理！

去点：

- 一个真实角色就会产生一个代理角色；代码量会翻倍~开发效率会变低~



## 10.2、加深理解

代码：

service接口

```java
public interface UserService {

    public void add();

    public void delete();

    public void update();

    public void query();

}
```



service实现类

```java
public class UserServiceImpl implements UserService{
    @Override
    public void add() {
        System.out.println("添加一个用户");
    }

    @Override
    public void delete() {
        System.out.println("删除一个用户");
    }

    @Override
    public void update() {
        System.out.println("修改一个用户");
    }

    @Override
    public void query() {
        System.out.println("查询一个用户");
    }
}
```



代理类（在不修改原有的代码的情况下添加日志效果）

```java
public class UserServiceProxy implements UserService{

    private UserServiceImpl userService;

    public void setUserService(UserServiceImpl userService) {
        this.userService = userService;
    }

    @Override
    public void add() {
        log("add");
        userService.add();
    }

    @Override
    public void delete() {
        log("delete");
        userService.delete();
    }

    @Override
    public void update() {
        log("update");
        userService.update();
    }

    @Override
    public void query() {
        log("query");
        userService.query();
    }

    //日志
    public void log(String msg) {
        System.out.println("[Debug] 使用了" + msg + "方法");
    }
}
```



客户端

```java
public class Client {

    public static void main(String[] args) {
        UserServiceImpl userService = new UserServiceImpl();

        UserServiceProxy proxy = new UserServiceProxy();
        proxy.setUserService(userService);

        proxy.query();
    }

}
```





聊聊AOP

![image-20200903121419753](D:\Typora-photos\spring\image-20200903121419753.png)



## 10.3、动态代理

- 动态代理和静态代理角色一样
- 动态代理的代理类是动态生成的，不是我们直接写好的！
- 动态代理分为两大类：基于接口的动态代理，基于类的动态代理
  - 基于接口---JDK 动态代理
  - 基于类：cglib
  - java字节码实现：javassist



需要了解两个类：Proxy：代理，InvocationHandler：调用处理程序



动态代理的实现：

```java
public class ProxyUtil implements InvocationHandler {

    //被代理的接口
    private Object target;

    public void setTarget(Object target) {
        this.target = target;
    }

    //生成得到的代理类
    public Object getProxy() {
        return Proxy.newProxyInstance(this.getClass().getClassLoader(),target.getClass().getInterfaces(),this);
    }

    //处理代理实例，并返回结果
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        Object result = method.invoke(target);
        return result;
    }

}
```



```java
public class Client {

    public static void main(String[] args) {

        //真实对象
        UserServiceImpl userService = new UserServiceImpl();

        //代理角色
        ProxyUtil proxy = new ProxyUtil();
        //设置要代理的接口
        proxy.setTarget(userService);
        //通过调用程序处理角色来获取代理对象
        UserService userServiceProxy = (UserService) proxy.getProxy();

        userServiceProxy.delete();

    }

}
```



动态代理的好处：

- 可以使真实角色的操作更加纯粹！不用去关注一些公共业务
- 公共业务就交割代理角色！实现了业务的分工！
- 公共业务方式扩展的时候，方便集中管理！
- 一个动态代理类代理的是一个接口，一般就是对应的一类业务



# 11、AOP

## 11.1、什么是AOP

AOP（Aspest Oriented Programming）意为：面向切面编程，通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术。AOP是OOP的延续，是软件开发中的一个热点，也是Spring框架中的一个重要内容，是函数式编程的一种衍生范型。利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。

![image-20200903150657508](D:\Typora-photos\spring\image-20200903150657508.png)



## 11.2、AOP在Spring中的作用

==提高声明式事务；允许用户自定义切面==

- 横切关注点：跨域应用程序多个模块的方法和功能。即是，与我们业务逻辑无关的，但是我们需要关注的部分，就是横切关注点。如：日志，安全，缓存，事务等等....
- 切面（ASPECT）：横切关注点被模块化的特殊对象。即，它是一个类。
- 通知（Advice）：切面必须要完成的工作。即，他是类中的一个方法。
- 目标（Target）：被通知对象。
- 代理（Proxy）：向目标对象应用通知之后创建的对象。
- 切入点（PointCut）：切面通知执行的“地点”的定义。
- 连接点（JointPoint）：与切入点匹配的执行点。

![image-20200903151531314](D:\Typora-photos\spring\image-20200903151531314.png)

SpringAOP中，通过Advice定义横切逻辑，Spring中支持5中类型的Advice；

![image-20200903151635761](D:\Typora-photos\spring\image-20200903151635761.png)

即AOP在不改变原有代码的情况下，去增加新的功能。



## 11.3、使用Spring实现AOP

【重点】使用AOP注入，需要导入一个依赖包！

```xml
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.6</version>
</dependency>
```



方式一：使用Spring的API接口

实现Spring的API接口

```java
public class BeforeLog implements MethodBeforeAdvice {


    /**
     *
     * @param method    要执行的目标对象的方法
     * @param args      参数
     * @param target    目标接口
     * @throws Throwable
     */

    @Override
    public void before(Method method, Object[] args, Object target) throws Throwable {
        System.out.println(target.getClass().getName() + "的" + method.getName() + "被执行了");
    }
}
```

```java
public class AfterLog implements AfterReturningAdvice {

    /**
     *
     * @param returnValue   方法返回值
     */
    @Override
    public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
        System.out.println("执行了" + method.getName() + "方法，返回的结果是：" + returnValue);
    }
}
```



配置文件

```xml
<!--方式一：使用原生Spring API接口-->
<!--配置aop：需要导入aop约束-->
<aop:config>
    <!--切入点：expression：表达式，execution(要执行的位置 * * * * * ) -->
    <aop:pointcut id="pointcut" expression="execution(* com.yjy.service.UserServiceImpl.*(..))"/>
    <!--执行环绕增加！-->
    <aop:advisor advice-ref="beforeLog" pointcut-ref="pointcut"/>
    <aop:advisor advice-ref="afterLog" pointcut-ref="pointcut"/>
</aop:config>
```



方式二：自定义来实现AOP

自定义切面

```java
public class DiyPointCut {

    public void before() {
        System.out.println("========执行方法前=========");
    }

    public void after() {
        System.out.println("========执行方法后=========");
    }

}
```



配置文件

```xml
<!--方式二：自定义-->
<!--注入写好的通知类-->
<bean id="diy" class="com.yjy.diy.DiyPointCut"/>

<aop:config>
    <!--自定义切面，ref：要引用的类-->
    <aop:aspect ref="diy">
        <!--切入点-->
        <aop:pointcut id="pointcut" expression="execution(* com.yjy.service.UserServiceImpl.*(..))"/>
        <!--通知-->
        <aop:before method="before" pointcut-ref="pointcut"/>
        <aop:after method="after" pointcut-ref="pointcut"/>
    </aop:aspect>
</aop:config>
```



方式三：使用注解实现！【需要开启注解支持】

切面类

```java
@Aspect // 标注这个类是一个切面
public class AnnotationPointCut {

    @Before("execution(* com.yjy.service.UserServiceImpl.*(..))")
    public void before() {
        System.out.println("========执行方法前=========");
    }

    @After("execution(* com.yjy.service.UserServiceImpl.*(..))")
    public void after() {
        System.out.println("========执行方法后=========");
    }

    @Around("execution(* com.yjy.service.UserServiceImpl.*(..))")
    public void around(ProceedingJoinPoint jp) throws Throwable {
        System.out.println("环绕前");
        Object proceed = jp.proceed();  //执行方法，类似于invoke()方法。
        System.out.println("环绕后");
    }

    /*
    执行顺序：
    环绕前
    ========执行方法前=========
    查询了一个用户
    ========执行方法后=========
    环绕后
     */
}
```



配置文件

```xml
<!--方式三：注解-->
<bean id="annotationPointCut" class="com.yjy.annotation.AnnotationPointCut"/>
<!--开启注解支持-->
<aop:aspectj-autoproxy/>
```

