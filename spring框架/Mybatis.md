# Mybatis

## 1、简介

### 1.1、什么是Mybatis

![image-20200919160115592](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200919160115592.png)

- MyBatis 是一款优秀的**持久层框架**
- 支持自定义 SQL、存储过程以及高级映射。
- MyBatis 免除了几乎所有的 JDBC 代码以及设置参数和获取结果集的工作。
- MyBatis 可以通过简单的 XML 或注解来配置和映射原始类型、接口和 Java POJO（Plain Old Java Objects，普通老式 Java 对象）为数据库中的记录。
- MyBatis 本是[apache](https://baike.baidu.com/item/apache/6265)的一个开源项目[iBatis](https://baike.baidu.com/item/iBatis), 2010年这个项目由apache software foundation 迁移到了google code，并且改名为MyBatis 。
- 2013年11月迁移到Github。



如何获得Mybatis

- maven仓库：

  ```xml
  <!-- https://mvnrepository.com/artifact/org.mybatis/mybatis -->
  <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>3.5.2</version>
  </dependency>
  ```

- Github：https://github.com/mybatis/mybatis-3/releases

- 中文文档：https://mybatis.org/mybatis-3/zh/index.html



### 1.2、持久化

数据持久化

- 持久化就是将程序的数据在持久状态和瞬时状态转化的过程
- 内存：**断电即失**
- 数据库(Jdbc)，io文件持久化。
- 生活：冷藏、罐头。

**为什么需要持久化？**

- 有一些对象，不能让他丢掉。

- 内存太贵了



### 1.3、持久层

Dao层，Service层，Controller层...

- 完成持久化工作的代码块
- 层界限十分明显。



### 1.4、为什么需要Mybatis

- 帮助程序员将数据存入到数据库中。

- 方便
- 传统的JDBC代码太复杂了。简化。框架。自动化。
- 不用Mybatis也可以。更容易上手。
- 优点：
  - 简单易学
  - 灵活
  - sql和代码的分离，提高了可维护性。
  - 提供映射标签，支持对象与数据库的orm字段关系映射
  - 提供对象关系映射标签，支持对象关系组建维护
  - 提供xml标签，支持编写动态sql。



**最重要的一点：使用的人多！**



## 2、第一个Mybatis程序

思路：搭建环境-->导入Mybatis-->编写代码-->测试

### 2.1、搭建环境

搭建数据库

```sql
CREATE DATABASE `mybatis`;

USE `mybatis`;

CREATE TABLE `user`(
  `id` INT(20) NOT NULL,
  `name` VARCHAR(30) DEFAULT NULL,
  `pwd` VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY(`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO `user`(`id`,`name`,`pwd`)
VALUES
(1,'yjy','123456'),
(2,'zhangsan','123456'),
(3,'lisi','123456')
```

新建项目

1. 新建一个普通的Maven项目

2. 删除src目录

3. 导入maven依赖

    ```xml
   <!--导入依赖-->
       <dependencies>
           <!--mysql驱动-->
           <dependency>
               <groupId>mysql</groupId>
               <artifactId>mysql-connector-java</artifactId>
               <version>8.0.20</version>
           </dependency>
           <!--mybatis-->
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis</artifactId>
               <version>3.5.2</version>
           </dependency>
           <!--junit-->
           <dependency>
               <groupId>junit</groupId>
               <artifactId>junit</artifactId>
               <version>4.12</version>
               <scope>test</scope>
           </dependency>
       </dependencies>
   ```



### 2.2、创建一个模块

- 编写mybatis的核心配置文件

  ```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE configuration
          PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
          "http://mybatis.org/dtd/mybatis-3-config.dtd">
  <!--configuration核心配置文件-->
  <configuration>
  
      <environments default="development">
          <environment id="development">
              <transactionManager type="JDBC"/>
              <dataSource type="POOLED">
                  <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                  <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=true&amp;useUnicode=true&amp;charcterEncoding=UTF-8"/>
                  <property name="username" value="root"/>
                  <property name="password" value="love19980920"/>
              </dataSource>
          </environment>
      </environments>
  
      <!--每一个Mapper.xml都需要在Mybatis核心配置文件中注册！-->
      <mappers>
          <mapper resource="com/yjy/dao/UserMapper.xml" />
      </mappers>
  </configuration>
  ```

  

- 编写mybatis工具类

```java
public class MybatisUtils {

    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
            //使用Mybatis第一步：获取sqlSessionFactory对象
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    //既然有了 SqlSessionFactory，顾名思义，我们可以从中获得 SqlSession 的实例。
    //SqlSession 提供了在数据库执行 SQL 命令所需的所有方法。

    public static SqlSession getSqlSession() {
        return sqlSessionFactory.openSession();
    }

}
```



### 2.3、编写代码

- 实体类

  ```java
  public class User {
  
      private int id;
      private String name;
      private String pwd;
  
      public User() {
      }
  
      public User(int id, String name, String pwd) {
          this.id = id;
          this.name = name;
          this.pwd = pwd;
      }
  
      public int getId() {
          return id;
      }
  
      public void setId(int id) {
          this.id = id;
      }
  
      public String getName() {
          return name;
      }
  
      public void setName(String name) {
          this.name = name;
      }
  
      public String getPwd() {
          return pwd;
      }
  
      public void setPwd(String pwd) {
          this.pwd = pwd;
      }
  
      @Override
      public String toString() {
          return "User{" +
                  "id=" + id +
                  ", name='" + name + '\'' +
                  ", pwd='" + pwd + '\'' +
                  '}';
      }
  }
  ```

  

- Dao接口

  ```java
  public interface UserDao {
  
      List<User> getUserList();
  
  }
  ```

  

- 接口实现类由原来的UserDaoImpl转变为一个Mapper配置文件

  ```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE mapper
          PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
          "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
  <!--namespace=绑定一个对应的Dao/Mapper接口 -->
  <mapper namespace="com.yjy.dao.UserDao">
      <!--select查询语句-->
      <select id="getUserList" resultType="com.yjy.pojo.User">
          select * from user
      </select>
  </mapper>
  ```

  

### 2.4、测试

注意点：org.apache.ibatis.binding.BindingException: Type interface com.yjy.dao.UserDao is not known to the MapperRegistry.

**MapperRegistry是什么？**所有的mapper.xml都需要在mybatis配置中通过mappers标签注册

- junit测试

  ```java
  public class UserDaoTest {
  
      @Test
      public void test(){
          //第一步：获取SqlSession对象
          SqlSession sqlSession = MybatisUtils.getSqlSession();
  
          //方式一：getMapper
          UserDao mapper = sqlSession.getMapper(UserDao.class);
          List<User> list = mapper.getUserList();
  
          //方式二：
  //        List<User> users = sqlSession.selectList("com.yjy.dao.UserDao.getUserList");
  
          for (User user : list) {
              System.out.println(user.toString());
          }
  
          //关闭SqlSession
          sqlSession.close();
      }
  
  }
  ```



可能会遇到的错误：

1. 配置文件没有注册
2. 绑定接口错误
3. 方法名不对
4. 返回类型不对
5. maven导出资源问题



## 3、CRUD

### 1、namespace

namespace中的包名要和 Dao/Mapper中的包名一致！



### 2、select

选择，查询语句；

- id：就是对应的namespace中的方法名；
- resultType：Sql语句执行的返回值！
- parameterType：参数类型！



1. 编写接口

   ```java
   //根据ID查询用户
   User getUserById(int i);
   ```

   

2. 编写对应的mapper中的sql语句

   ```xml
   <select id="getUserById" resultType="com.yjy.pojo.User">
       select * from user where id = #{id}
   </select>
   ```

   

3. 测试

   ```java
   @Test
   public void getUserById() {
       SqlSession sqlSession = MybatisUtils.getSqlSession();
   
       UserMapper mapper = sqlSession.getMapper(UserMapper.class);
   
       User user = mapper.getUserById(1);
   
       System.out.println(user.toString());
   
       sqlSession.close();
   }
   ```

   



### 3、Insert

```xml
<insert id="addUser" parameterType="com.yjy.pojo.User">
    insert into user(id,name,pwd) values(#{id},#{name},#{pwd})
</insert>
```



### 4、update

```xml
<update id="updateUser" parameterType="com.yjy.pojo.User">
    update user set name=#{name},pwd=#{pwd} where id = #{id}
</update>
```



### 5、Delete

```xml
<delete id="deleteUser" parameterType="int">
    delete from user where id = #{id}
</delete>
```



注意点：

- 增删改需要提交事务！



### 6、万能map

假设，我们的实体类，或者数据库中的表，字段或者参数过多，我们应当考虑使用Map！

```java
//万能的Map
int addUser2(Map<String,Object> map);
```

```xml
<!--对象中的属性，可以直接取出来	传递map的key-->
<insert id="addUser2" parameterType="map">
    insert into user(id,pwd) values(#{userid},#{passWord});
</insert>
```

```java
@Test
    public void addUser() {
        SqlSession sqlSession = MybatisUtils.getSqlSession();

        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        
        Map<String,Object> map = new HashMap<String,Object>();
        
        map.put("userid",5);
        map.put("password","2222333")

        int res = mapper.addUser(map);

        if (res>0) {
            sqlSession.commit();
            System.out.println("成功添加用户！！");
        }

        sqlSession.close();

    }
```



Map传递参数，直接在sql中去key即可！	【parameterType="map"】

对象传递参数，直接在sql中去对象的属性即可！	【parameterType="Object"】

只有一个基本类型参数的情况下，可以直接在sql中取到！

多个参数用Map，**或者注解！**



### 7、思考题

模糊查询怎么写？

1. Java代码执行的时候，传递通配符% %

   ```java
   List<User> userList = mapper.getUserLike("%li%")
   ```

   

2. 在sql拼接中使用通配符！

   ```sql
   select * from user where name like "%"#{value}"%"
   ```



## 4、配置解析

### 1、核心配置文件

- mybatis-config.xml

- MyBatis 的配置文件包含了会深深影响 MyBatis 行为的设置和属性信息。

  ```xml
  configuration（配置）
  properties（属性）
  settings（设置）
  typeAliases（类型别名）
  typeHandlers（类型处理器）
  objectFactory（对象工厂）
  plugins（插件）
  environments（环境配置）
  environment（环境变量）
  transactionManager（事务管理器）
  dataSource（数据源）
  databaseIdProvider（数据库厂商标识）
  mappers（映射器）
  ```



### 2、环境配置（environments）

**不过要记住：尽管可以配置多个环境，但每个 SqlSessionFactory 实例只能选择一种环境。**



Mybatis默认的事务管理器就是JDBC，连接池：POOLED



### 3、属性（properties）

我们可以通过properties属性来实现引用配置文件

这些属性可以在外部进行配置，并可以进行动态替换。你既可以在典型的 Java 属性文件中配置这些属性，也可以在 properties 元素的子元素中设置。【db.properties】

![image-20200919203620586](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200919203620586.png)

编写一个配置文件

db.properties

```properties
driver=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/mybatis?useSSL=true&useUnicode=true&charcterEncoding=UTF-8
username=root
password=love19980920
```



在核心配置文件中引入

```xml
<properties resource="db.properties" />
```

- 可以直接引入外部文件
- 可以在其中添加一些属性配置
- 由于properties加载的顺序是：在properties元素体内的属性会先被读取，然后再根据properties元素中的resource属性读取类路径下的属性文件。并覆盖已读取的同名属性。最后读取作为方法参数传递的属性，并覆盖已读取的同名属性。所以优先级为：property子元素<properties配置文件<程序参数传递



### 4、类型别名（typeAliases）

- 类型别名可为 Java 类型设置一个缩写名字。
- 意在降低冗余的全限定类名书写.

```xml
<!--可以给实体类起别名-->
<typeAliases>
    <typeAlias type="com.yjy.pojo.User" alias="hello"/>
</typeAliases>
```

**typeAlias标签的别名不区分大小写**

也可以指定一个包名，MyBatis 会在包名下面搜索需要的 Java Bean

扫描实体类的包，它的默认别名就为这个类的 类命，首字母小写！

```xml
<!--可以给实体类起别名-->
<typeAliases>
    <package name="com.yjy.pojo"/>
</typeAliases>
```

**package标签的别名不区分大小写**

在实体类比较少的时候，使用第一种方式。

如果实体类十分多，建议使用第二种。

第一种可以DIY别名，第二种则“不行”，如果非要改，需要在实体类上增加注解

```java
@Alias("hello")
public class User {
```

**@Alias起的别名也不分大小写**



### 5、设置

这是 MyBatis 中极为重要的调整设置，它们会改变 MyBatis 的运行时行为。

![image-20200919231134304](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200919231134304.png)

![image-20200919231206253](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200919231206253.png)



### 6、其他配置

- [typeHandlers（类型处理器）](https://mybatis.org/mybatis-3/zh/configuration.html#typeHandlers)
- [objectFactory（对象工厂）](https://mybatis.org/mybatis-3/zh/configuration.html#objectFactory)
- [plugins（插件）](https://mybatis.org/mybatis-3/zh/configuration.html#plugins)
  - MyBatis Generator Core
  - MyBatis Plus
  - 通用mapper



### 7、映射器（mappers）

MapperRegistry：注册绑定我们的Mapper文件；

方式一：

```xml
<!--每一个Mapper.xml都需要在Mybatis核心配置文件中注册！-->
<mappers>
    <mapper resource="com/yjy/dao/UserMapper.xml" />
</mappers>
```

方式二：使用class文件绑定注册

```xml
<!--每一个Mapper.xml都需要在Mybatis核心配置文件中注册！-->
<mappers>
    <!--<mapper resource="com/yjy/dao/UserMapper.xml" />-->
    <mapper class="com.yjy.dao.UserMapper" />
</mappers>
```

注意点：

- 接口和他的Mapper配置文件必须同名！
- 接口和他的Mapper配置文件必须在同一包下！

方式三：使用扫描包进行注入绑定

```xml
<!--每一个Mapper.xml都需要在Mybatis核心配置文件中注册！-->
<mappers>
    <!--<mapper resource="com/yjy/dao/UserMapper.xml" />-->
    <!--<mapper class="com.yjy.dao.UserMapper" />-->
    <package name="com.yjy.dao"/>
</mappers>
```

注意点：

- 接口和他的Mapper配置文件必须同名！
- 接口和他的Mapper配置文件必须在同一包下！



### 8、生命周期和作用域

![image-20200919235010431](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200919235010431.png)

生命周期类别，作用域，是至关重要的，因为错误的使用会导致非常严重的**并发问题**。

**SqlSessionFactoryBuilder：**

- 一旦创建了 SqlSessionFactory，就不再需要它了。
- 局部变量

**SqlSessionFactory：**

- 说白了就是可以想象为：数据库连接池
- SqlSessionFactory 一旦被创建就应该在应用的运行期间一直存在，**没有任何理由丢弃它或重新创建另一个实例。**
- 因此 SqlSessionFactory 的最佳作用域是应用作用域。
- 最简单的就是使用单例模式或者静态单例模式。

**SqlSession：**

- 连接到连接池的请求！
- SqlSession 的实例不是线程安全的，因此是不能被共享的，所以它的最佳的作用域是请求或方法作用域。
- 用完之后需要赶紧关闭，否则资源被占用！

![image-20200919235542460](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200919235542460.png)

这里面的每一个Mapper，就代表一个具体的业务！



## 5、解决属性名与字段名不一致的问题

数据库中的字段

![image-20200919235915649](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200919235915649.png)

新建一个项目，拷贝之前的，测试实体类字段不一致的情况

```java
public class User {

    private int id;
    private String name;
    private String password;
}
```

测试出现问题

![image-20200920002309507](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200920002309507.png)



```xml
//select * from user where id = #{id}
//类型处理器
//select id,name,pwd from user where id = #{id}
```



解决方法：

- 起别名

  ```xml
  <select id="getUserById" resultType="com.yjy.pojo.User">
      select id,name,pwd as password from user where id = #{id}
  </select>
  ```

  

- 

### 2、ResultMap

结果集映射

```
id 	name 	pwd
id 	name 	password
```

```xml
<!--结果集映射-->
<resultMap id="userMap" type="User">
    <!--column数据库中的字段，property实体类中的属性-->
    <result column="id" property="id"/>
    <result column="name" property="name"/>
    <result column="pwd" property="password"/>
</resultMap>

<select id="getUserById" resultMap="userMap">
    select * from user where id = #{id}
</select>
```



- `resultMap` 元素是 MyBatis 中最重要最强大的元素。
- ResultMap 的设计思想是，对简单的语句做到零配置，对于复杂一点的语句，只需要描述语句之间的关系就行了。
- `ResultMap` 的优秀之处——你完全可以不用显式地配置它们。 
- 如果这个世界总是这么简单就好了。





![image-20200920003718706](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200920003718706.png)



## 6、日志

### 6.1、日志工厂

如果一个数据库操作，出现了异常，我们需要排错。日志就是最好的助手！

曾经：sout、debug

现在：日志工厂！

![image-20200920122137789](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200920122137789.png)

- SLF4J 
-  LOG4J 【掌握】
-  LOG4J2 
-  JDK_LOGGING 
-  COMMONS_LOGGING 
-  STDOUT_LOGGING 【掌握】
-  NO_LOGGING



在Mybatis中具体使用哪一个日志实现，在设置中设定！

**STDOUT_LOGGING 标准日志输出**

在mybatis核心配置文件中，配置我们的日志！

```xml
<settings>
    <setting name="logImpl" value="STDOUT_LOGGING"/>
</settings>
```

![image-20200920123942522](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200920123942522.png)



### 6.2、Log4j

什么是Log4j？

- Log4j是[Apache](https://baike.baidu.com/item/Apache/8512995)的一个开源项目，通过使用Log4j，我们可以控制日志信息输送的目的地是[控制台](https://baike.baidu.com/item/控制台/2438626)、文件、[GUI](https://baike.baidu.com/item/GUI)组件
- 也可以控制每一条日志的输出格式
- 通过定义每一条日志信息的级别，我们能够更加细致地控制日志的生成过程
- 通过一个[配置文件](https://baike.baidu.com/item/配置文件/286550)来灵活地进行配置，而不需要修改应用的代码。



1. 先导入log4j的包

   ```xml
   <!-- https://mvnrepository.com/artifact/log4j/log4j -->
   <dependency>
       <groupId>log4j</groupId>
       <artifactId>log4j</artifactId>
       <version>1.2.17</version>
   </dependency>
   ```

2. log4j.properties

   ```properties
   #将等级为DEBUG的日志信息输出到console和file这两个目的地，console和file的定义在下面的代码
   log4j.rootLogger=DEBUG,console,file
   
   #控制台输出的相关设置
   log4j.appender.console = org.apache.log4j.ConsoleAppender
   log4j.appender.console.Target = System.out
   log4j.appender.console.Threshold=DEBUG
   log4j.appender.console.layout = org.apache.log4j.PatternLayout
   log4j.appender.console.layout.ConversionPattern=【%c】-%m%n
   
   #文件输出的相关设置
   log4j.appender.file = org.apache.log4j.RollingFileAppender
   log4j.appender.file.File=./log/mybatis.log
   log4j.appender.file.MaxFileSize=10mb
   log4j.appender.file.Threshold=DEBUG
   log4j.appender.file.layout=org.apache.log4j.PatternLayout
   log4j.appender.file.layout.ConversionPattern=【%p】【%d{yy-MM-dd}】【%c】%m%n
   
   #日志输出级别
   log4j.logger.org.mybatis=DEBUG
   log4j.logger.java.sql=DEBUG
   log4j.logger.java.sql.Statement=DEBUG
   log4j.logger.java.sql.ResultSet=DEBUG
   log4j.logger.java.sql.PreparedStatement=DEBUG
   ```

3. 配置log4j为日志的实现

   ```xml
   <settings>
       <setting name="logImpl" value="LOG4J"/>
   </settings>
   ```

4. Log4j的使用，直接测试运行刚才的查询

   ![image-20200920131108691](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200920131108691.png)



**简单实用**

1. 在要使用Log4j的类中，导入包 import org.apache.log4j.Logger;

2. 日志对象，参数为当前类的class

   ```java
   static Logger logger = Logger.getLogger(UserMapperTest.class);
   ```

3. 日志级别

   ```java
   logger.info("info:进入了testLog4j");
   logger.debug("debug:进入了testLog4j");
   logger.error("error:进入了testLog4j");
   ```

   

## 7、分页

**思考：为什么要分页？**

- 减少数据的处理量



### 7.1、使用Limit分页

```sql
-- 语法：SELECT * FROM USER LIMIT startIndex,pageSize
SELECT * FROM USER LIMIT 3;		-- [0,n];
```



使用Mybatis实现分页，核心SQL

1. 接口

   ```java
   //分页查询用户
   List<User> getUserByLimit(Map<String,Integer> map);
   ```

2. Mapper.xml

   ```xml
   <select id="getUserByLimit" parameterType="map" resultMap="userMap">
       select * from user limit #{startIndex},#{pageSize};
   </select>
   ```

3. 测试

   ```java
   @Test
   public void getUserByLimit() {
       SqlSession sqlSession = MybatisUtils.getSqlSession();
   
       UserMapper mapper = sqlSession.getMapper(UserMapper.class);
   
       Map<String, Integer> map = new HashMap<String, Integer>();
   
       map.put("startIndex",1);
       map.put("pageSize",2);
       List<User> users = mapper.getUserByLimit(map);
   
       for (User user : users) {
           System.out.println(user.toString());
       }
   }
   ```

   

### 7.2、使用RowBounds分页

不再使用SQL实现分页

1. 接口

   ```java
   //分页查询用户2
   List<User> getUserByRowBounds();
   ```

   

2. mapper.xml

   ```xml
   <select id="getUserByRowBounds" resultMap="userMap">
       select * from user
   </select>
   ```

   

3. 测试

   ```java
   //使用RowBounds分页
   @Test
   public void getUserByRowBounds() {
       SqlSession sqlSession = MybatisUtils.getSqlSession();
   
       RowBounds rowBounds = new RowBounds(0, 3);
   
       List<User> users = sqlSession.selectList("com.yjy.dao.UserMapper.getUserByRowBounds", null, rowBounds);
   
       for (User user : users) {
           System.out.println(user.toString());
       }
   
       sqlSession.close();
   }
   ```

   

### 7.3、分页插件

- Mybatis Pagehelper



## 8、使用注解开发

### 8.1、面向接口编程

- 大家之前都学过面向对象编程，也学习过接口，但是真正的开发中，很多时候我们会选择面向接口编程

- **根本原因：==解耦==，可拓展，提高复用，分层开发中，上层不用管具体的实现，大家都遵守共同的标准，是的开发变得容易，规范性更好**

- 在一个面向对象的系统中，系统的各种功能是由许许多多的不同对象协作完成的。在这种情况下，各个对象内部是如何实现自己的，对系统设计人员来讲就不那么重要了；

- 而各个对象之间的协作关系则成为系统设计的关键。小到不同类之间的通信，达到各模块之间的交互，在系统设计之初都是要着重考虑的，这也是系统设计的主要工作内容。面向接口编程就是指按照这种思想来编程。



**关于接口的理解**

- 接口从更深层次的理解，应是定义（规范，约束）与实现（名实分离的原则）的分离。
- 接口的本身反映了系统设计人员对系统的抽象理解。
- 接口应有两类：
  - 第一类是对一个个体的抽象，它可对应为土匪抽象体（abstract class）；
  - 第二类是对一个个体某方面的抽象，即形成一个抽象面（interface）；
- 一个个体有可能有多个抽象面。抽象体与抽象面是有区别的。



**三个面向区别**

- 面型对象是指，我们考虑问题时，以对象为单位，考虑它的属性及方法。
- 面向过程是指，我们考虑问题时，以一个具体的流程（事务过程）为单位，考虑它的实现。
- 接口设计与非接口设计时针对复用技术而言的，与面向对象（过程）不是一个问题。更多的体现就是对系统整体的架构。



### 8.2、使用注解开发

1. 注解在接口上的实现

   ```java
   //查询用户
   @Select("select * from user")
   List<User> getUsers();
   ```

   

2. 需要在核心配置文件中绑定接口

   ```xml
   <mappers>
   <mapper class="com.yjy.dao.UserMapper" />
   </mappers>
   ```

   

3. 测试

   ```java
   @Test
   public void getUsers() {
       SqlSession sqlSession = MybatisUtils.getSqlSession();
   
       UserMapper mapper = sqlSession.getMapper(UserMapper.class);
   
       List<User> users = mapper.getUsers();
   
       for (User user : users) {
           System.out.println(user.toString());
       }
   }
   ```



本质：反射机制实现

原理：动态代理！

![image-20200920204409989](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200920204409989.png)



**Mybatis详细的执行流程**

![image-20200920204409989](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/temp.png)



### 8.3、CRUD

我们可以在工具类创建的时候实现自动提交事务！

```java
public static SqlSession getSqlSession() {
    return sqlSessionFactory.openSession(true);
}
```



编写接口，增加注解

```java
public interface UserMapper {

    //查询用户
    @Select("select * from user")
    List<User> getUsers();

    @Insert("insert into user(id,name,pwd) values(#{id},#{name},#{password})")
    int insertUser(User user);

    @Update("update user set name=#{name} where id=#{id}")
    int updateUser(@Param("name") String name, @Param("id") int id);

    @Delete("delete from user where id=#{id}")
    int deleteUser(@Param("id") int id);

}
```



测试类

【注意：我们必须要将接口注册绑定到我们的核心配置文件中！】



**关于@Param()注解**

- 基本类型的参数或者String类型，需要加上
- 引用类型不需要加
- 如果只有一个基本类型的化，可以忽略，但是建议都加上！
- 我们在SQL中引用的就是我们这里的 @Param()中设定的属性名！



**#{} 与 ${}的区别**

- #{}可以防止SQL注入



## 9、Lombok

使用步骤：

1. 在IDEA中安装Lombok插件

2. 在项目中导入Lombok的jar包

   ```xml
   <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
   <dependency>
       <groupId>org.projectlombok</groupId>
       <artifactId>lombok</artifactId>
       <version>1.18.12</version>
       <scope>provided</scope>
   </dependency>
   
   ```

3. 在实体类上加注解即可

   ```java
   @Data
   @NoArgsConstructor
   @AllArgsConstructor
   ```

   

```java
@Getter and @Setter
@FieldNameConstants
@ToString
@EqualsAndHashCode
@AllArgsConstructor, @RequiredArgsConstructor and @NoArgsConstructor
@Log, @Log4j, @Log4j2, @Slf4j, @XSlf4j, @CommonsLog, @JBossLog, @Flogger, @CustomLog
@Data
@Builder
@SuperBuilder
@Singular
@Delegate
@Value
@Accessors
@Wither
@With
@SneakyThrows
@val
@var
```

说明：

```
@Data:无参构造，get，set，toString，hashcode，equals
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode
@Getter
@Setter
```



## 10、多对一处理

多对一：

![image-20200921173810980](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200921173810980.png)

- 多个学生，对应一个老师
- 对于学生这边而言，**关联**..，多个学生，关联一个老师【多对一】
- 对于老师而言，**集合**，一个老师，有很多学生【一对多】

![image-20200921174447936](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200921174447936.png)



SQL：

```sql
CREATE TABLE `teacher` (
  `id` INT(10) NOT NULL,
  `name` VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT INTO teacher(`id`, `name`) VALUES (1, '秦老师'); 

CREATE TABLE `student` (
  `id` INT(10) NOT NULL,
  `name` VARCHAR(30) DEFAULT NULL,
  `tid` INT(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fktid` (`tid`),
  CONSTRAINT `fktid` FOREIGN KEY (`tid`) REFERENCES `teacher` (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('1', '小明', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('2', '小红', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('3', '小张', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('4', '小李', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('5', '小王', '1');
```



### **测试环境搭建**

1. 导入lombok

   ```xml
   <dependency>
       <groupId>org.projectlombok</groupId>
       <artifactId>lombok</artifactId>
       <version>1.18.12</version>
       <scope>provided</scope>
   </dependency>
   ```

   

2. 新建实体类Tecaher，Student

   ```java
   @Data
   public class Student {
   
       private int id;
       private String name;
   
       //学生需要关联老师
       private Teacher teacher;
   }
   ```

   ```java
   @Data
   public class Teacher {
   
       private int id;
       private String name;
   }
   ```

   

3. 建立Mapper接口

   ```java
   public interface StudentMapper {
   
   }
   ```

   ```java
   public interface TeacherMapper {
   
       @Select("select * from teacher where id=#{tid}")
       Teacher getTeacher(@Param("tid") int id);
   }
   ```

   

4. 建立Mapper.xml文件

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE mapper
           PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   <mapper namespace="com.yjy.dao.StudentMapper">
   
   </mapper>
   ```

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE mapper
           PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   <mapper namespace="com.yjy.dao.TeacherMapper">
   
   </mapper>
   ```

   

5. 在核心配置文件中绑定注册我们的Mapper接口或者文件！【方式很多，随心选】

   ```xml
   <mappers>
       <package name="com.yjy.dao"/>
   </mappers>
   ```

   

6. 测试查询是否能成功！

   ```java
   @Test
   public void test() {
       SqlSession sqlSession = MybatisUtils.getSqlSession();
   
       TeacherMapper mapper = sqlSession.getMapper(TeacherMapper.class);
   
       Teacher teacher = mapper.getTeacher(1);
   
       System.out.println(teacher.toString());
   
       sqlSession.close();
   }
   ```



### 按照查询嵌套处理（类似SQL的子查询）

```xml
<!--
    思路：
        1.查询所有的学生信息
        2.根据查询出来的学生的tid，寻找对应的老师！
    子查询
    -->

<select id="getStudents" resultMap="StudentTeacher">
    select * from student
</select>

<resultMap id="StudentTeacher" type="Student">
    <result property="id" column="id" />
    <result property="name" column="name" />
    <association property="teacher" column="tid" javaType="Teacher" select="getTeacher" />
</resultMap>

<select id="getTeacher" resultType="Teacher">
    select * from teacher where id=#{tid}
</select>
```



### 按照结果嵌套处理（类似SQL的联表查询）

```xml
<!--按照结果嵌套查询-->
<select id="getStudents2" resultMap="StudentTeacher2">
    select s.id sid,s.name sname,tid,t.name tname from student s left join teacher t on s.tid = t.id
</select>

<resultMap id="StudentTeacher2" type="Student">
    <result property="id" column="sid" />
    <result property="name" column="sname" />
    <association property="teacher" javaType="Teacher">
        <result property="id" column="tid" />
        <result property="name" column="tname" />
    </association>
</resultMap>
```



回顾Mysql 多对一查询方式：

- 子查询
- 联表查询



## 11、一对多

比如：一个老师拥有多个学生！

对于老师而言，就是一对多的关系！



### 环境搭建

1. 环境搭建，和刚才一样

**实体类**

```java
@Data
public class Student {

    private int id;
    private String name;
    private int tid;
}
```

```java
@Data
public class Teacher {

    private int id;
    private String name;

    //一个老师拥有多个学生
    private List<Student> students;
}
```



### 按照结果嵌套查询

```xml
<select id="getTeacherById" resultMap="TeacherAndStudents">
    select t.id id,t.name tname,s.id sid,s.name sname,tid
    from teacher t
    left join student s
    on t.id = s.tid
    where t.id = #{id}
</select>

<resultMap id="TeacherAndStudents" type="Teacher">
    <result property="id" column="id" />
    <result property="name" column="tname" />
    <collection property="students" ofType="Student">
        <result property="id" column="sid" />
        <result property="name" column="sname" />
        <result property="tid" column="tid" />
    </collection>
</resultMap>
```



### 按照查询嵌套处理

```xml
<!--按照查询嵌套处理-->
<select id="getTeacherById2" resultMap="TeacherAndStudents2">
    select id,name from teacher where id=#{id}
</select>

<resultMap id="TeacherAndStudents2" type="Teacher">
    <!--如果这里不对teacher的id进行映射的话，那么teacher的id会为0。弹幕说由于collection拿走了id，所以没办法映射，因此需要手动设置-->
    <result property="id" column="id" />
    <!--collection不写javaType也可以，因为通过反射能得到-->
    <collection property="students" ofType="Student" column="id" select="getStudentByTeacherId">
        <result property="id" column="id" />
        <result property="name" column="name" />
        <result property="tid" column="tid" />
    </collection>
</resultMap>

<select id="getStudentByTeacherId" resultType="Student">
    select * from student where tid = #{id}
</select>
```



### 小结

1. 关联 - association	【多对一】
2. 集合 - collection       【一对多】
3. javaType      &      ofType
   1. javaType  用来指定实体类中属性的类型
   2. ofType  用来指定映射到List或者集合中的pojo类型，泛型中的约束类型！



注意点：

- 保证SQL的可读性，尽量保证通俗易懂
- 注意一对多和多对一，属性名和字段的问题！
- 如果问题不好排查错误，可以使用日志，建议使用Log4j



**慢SQL      1s        1000s**

面试高频

- Mysql引擎
- InnoDb底层原理
- 索引
- 索引优化！



## 12、动态SQL

**==什么是动态SQL：动态SQL就是指根据不同的条件生成不同的SQL==**

利用动态 SQL，可以彻底摆脱这种痛苦。

```xml
如果你之前用过 JSTL 或任何基于类 XML 语言的文本处理器，你对动态 SQL 元素可能会感觉似曾相识。在 MyBatis 之前的版本中，需要花时间了解大量的元素。借助功能强大的基于 OGNL 的表达式，MyBatis 3 替换了之前的大部分元素，大大精简了元素种类，现在要学习的元素种类比原来的一半还要少。

if
choose (when, otherwise)
trim (where, set)
foreach
```



### 搭建环境

```sql
CREATE TABLE `blog`(
    `id` VARCHAR(50) NOT NULL COMMENT '博客id',
    `title` VARCHAR(100) NOT NULL COMMENT '博客标题',
    `author` VARCHAR(30) NOT NULL COMMENT '博客作者',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `views` INT(30) NOT NULL COMMENT '浏览量'
)ENGINE=INNODB DEFAULT CHARSET=utf8
```



创建一个基础工程

1. 导包

   注意：如果想要在main文件下进行junit测试，不要在pom设置`<scope>test</scope>`。

2. 编写配置文件

3. 编写实体类

   ```java
   @Data
   public class Blog {
   
       private String id;
       private String title;
       private String author;
       private Date createTime;
       private int views;
   
   }
   ```

4. 编写实体类对应Mapper接口 和 Mapper.xml文件



### IF

```xml
<select id="queryBlogIf" parameterType="map" resultType="Blog">
    select * from blog where 1=1
    <if test="title != null">
        and title = #{title}
    </if>
    <if test="author != null">
        and author = #{author}
    </if>
</select>
```



### choose(when、otherwise)

choose相当于Java的switch，case

```xml
<select id="queryBlogChoose" parameterType="map" resultType="Blog">
        select * from blog
        <where>
            <choose>
                <when test="title != null">
                    title = #{title}
                </when>
                <when test="author != null">
                    and author = #{author}
                </when>
                <otherwise>
                    and views = #{views}
                </otherwise>
            </choose>
        </where>
    </select>
```



### trim(where、set)

#### 1、where

where标签的作用：*where* 元素只会在子元素返回任何内容的情况下才插入 “WHERE” 子句。而且，若子句的开头为 “AND” 或 “OR”，*where* 元素也会将它们去除。（俗话：至少要符合一个条件才会加where，如果where后面是以and或or开头会自动删去and或or）

```xml
<select id="queryBlogIf" parameterType="map" resultType="Blog">
    select * from blog
    <where>
        <if test="title != null">
            and title = #{title}
        </if>
        <if test="author != null">
            and author = #{author}
        </if>
    </where>
</select>
```



#### 2、set

set标签的作用；*set* 元素会动态地在行首插入 SET 关键字，并会删掉额外的逗号（俗话：至少要符合一个条件才会加set，如果set后面有多余的”,“则会被删除。）

```xml
<update id="updateBlog" parameterType="map">
    update blog
    <set>
        <if test="title != null">
            title = #{title},
        </if>
        <if test="author != null">
            author = #{author}
        </if>
    </set>
    where id = #{id}
</update>
```



**==所谓的动态SQL，本质还是SQL语句，只是我们可以在SQL层面，去执行一个逻辑代码==**



### SQL片段

有的时候，我们可能会将一些公共的部分抽取出来，方便复用！

1. 使用SQL标签抽取公共的部分

   ```xml
   
   ```

2. 在需要使用的地方使用Include标签引用即可

   ```xml
   
   ```



注意事项：

- 最好基本单表来定义SQL片段！
- 不要存在where标签





### Foreach

```sql
select * from blog where id in (1,2,3)
foreach主要是实现(1,2,3)集合的部分。
```



![image-20200922155521437](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200922155521437.png)



 ```xml
<!--
	需要实现的sql语句：select * from blog where id in (1,2,3)
-->
<select id="queryBlogForeach" parameterType="map" resultType="Blog">
    select * from blog
    <where>
        <foreach collection="ids" item="id" open="id in (" separator="," close=")">
            #{id}
        </foreach>
    </where>
</select>
 ```



==动态SQL就是在拼接SQL语句，我们只要保证SQL的正确性，按照SQL的格式，去排列组合就可以了huancu==

建议：

- 先在Mysql中写出完整的SQL，再对应着取修改称为我们的动态SQL实现通用即可！



## 13、缓存

### 13.1、简介

```
查询	:	连接数据库，耗资源
	一次查询的结果，给他暂存在一个可以直接取到的地方！-->内存	:	缓存
	
我们再次查询相同数据的时候，直接走缓存，就不用走数据库了
```



1. 什么是缓存[ Cache ]？
   - 存在内存中的临时数据。
   - 将用户经常查询的数据放在缓存（内存）中，用户取查询数据就不用从磁盘上（关系型数据库数据文件）查询，从缓存中查询，从而提高查询效率，解决了高并发系统的性能问题。
2. 为什么使用缓存？
   - 减少和数据库的交互次数，减少系统开销，提高系统效率。
3. 什么样的数据能使用缓存？
   - 经常查询并且不经常改变的数据。



### 13.2、Mybatis缓存

- MyBatis包含一个非常强大的查询缓存特性，它可以非常方便地定制和配置缓存。缓存可以极大的提升查询效率。
- MyBatis系统中默认定义了两级缓存：**一级缓存**和**二级缓存**
  - 默认情况下，只有一级缓存开启。（SqlSession级别的缓存，也称为本地缓存）
  - 二级缓存需要手动开启和配置，他是基于namespace级别的缓存。
  - 为了提高扩展性，MyBatis定义了缓存接口Cache。我们可以通过实现Cache接口来定义二级缓存



### 13.3、一级缓存

- 一级缓存也叫本地缓存：SqlSession
  - 与数据库同一次会话期间查询到的数据会存放在本地缓存中。
  - 以后如果需要获取相同的数据，直接从缓存中拿，没必要再去查询数据库；



测试步骤：

1. 开启日志！

   ```xml
   <!--标准的日志工厂实现-->
   <setting name="logImpl" value="STDOUT_LOGGING"/>
   ```

2. 测试在一个Session中查询同一个记录

   ```java
   @Test
   public void test() {
       SqlSession sqlSession = MybatisUtils.getSqlSession();
   
       UserMapper mapper = sqlSession.getMapper(UserMapper.class);
   
       User user = mapper.getUserById(1);
       System.out.println(user);
   
       System.out.println("==================================");
   
       User user2 = mapper.getUserById(1);
       System.out.println(user2);
   
       sqlSession.close();
   }
   ```

   



缓存失败的情况：

1. 查询不同的东西
2. 增删改操作，可能会改变原来的数据，所以必定会刷新缓存！
3. 查询不同的Mapper.xml
4. 手动清理缓存！



小结：一级缓存默认是开启的，只在一次SqlSession中有效，也就是拿到连接到关闭连接这个区间段！

一级缓存就是一个Map。



### 13.4、二级缓存

- 二级缓存也叫全局缓存，一级缓存作用域太低了，所以诞生了二级缓存
- 基于namespace级别的缓存，一个名称空间，对应一个二级缓存；
- 工作机制
  - 一个绘画查询一条数据，这个数据就会被放在当前会话的一级缓存中；
  - 如果当前会话关闭了，这个会话对应的一级缓存就没了；但是我们想要的是，会话关闭了，一级缓存中的数据被保存到了二级缓存中；
  - 新的会话查询信息，就可以从二级缓存中获取内容；
  - 不同的mapper查出的数据会放在自己对应的缓存（map）中；



步骤：

1. 开启全集缓存

   ```xml
   <!--显示开启全局缓存-->
   <setting name="cacheEnabled" value="true"/>
   ```

2. 在要使用二级缓存的Mapper中开启缓存

   ```xml
   <!--在要使用二级缓存的Mapper中开启缓存-->
   <cache/>
   ```

   也可以自定义参数

    ```xml
   <cache
          eviction="FIFO"
          flushInterval="60000"
          size="512"		
          readOnly="true"/>
   
   <!--创建了一个 FIFO 缓存，每隔 60 秒刷新，最多可以存储结果对象或列表的 512 个引用，而且返回的对象被认为是只读的，因此对它们进行修改可能会在不同线程中的调用者产生冲突。-->
    ```

   - 默认的清除策略是 LRU。

   - flushInterval（刷新间隔）属性可以被设置为**任意的正整数**，设置的值应该是一个**以毫秒为单位**的合理时间量。 **默认情况是不设置**，也就是没有刷新间隔，**缓存仅仅会在调用语句时刷新。**

   - size（引用数目）属性可以被设置为**任意正整数**，要注意欲缓存对象的大小和运行环境中可用的内存资源。默认值是 1024。

   - readOnly（只读）属性可以被设置为 true 或 false。**只读的缓存会给所有调用者返回缓存对象的相同实例**。 因此这些对象不能被修改。这就提供了可观的性能提升。**而可读写的缓存会（通过序列化）返回缓存对象的拷贝。（因此需要对持久类进行序列化）** 速度上会慢一些，但是更安全，因此默认值是 false。

3. 测试  

   ```java
   @Test
   public void test2() throws InterruptedException {
       SqlSession sqlSession = MybatisUtils.getSqlSession();
       SqlSession sqlSession2 = MybatisUtils.getSqlSession();
       
       UserMapper mapper = sqlSession.getMapper(UserMapper.class);
       UserMapper mapper2 = sqlSession2.getMapper(UserMapper.class);
   
       User user = mapper.getUserById(1);
       System.out.println(user);
       sqlSession.close();
   
       System.out.println("==============================================================");
   
       User user2 = mapper2.getUserById(1);
       System.out.println(user2);
       sqlSession2.close();
   
       System.out.println(user==user2);
       
   }
   ```



小结：

- 只要开启了二级缓存，在同一个Mapper下就有效
- 所有的数据都会先放在一级缓存中；
- 只有当会话提交，或者关闭的时候，才会提交到二级缓存中！



### 13.5、缓存原理

![image-20200922205914847](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mybatis/image-20200922205914847.png)





### 13.6、自定义缓存-ehcache

```xml
Ehcache是一种广泛使用的开源Java分布式缓存。主要面向通用缓存
```

要在程序中使用ehcache，先要导包！

```xml
<!-- https://mvnrepository.com/artifact/org.mybatis.caches/mybatis-ehcache -->
<dependency>
    <groupId>org.mybatis.caches</groupId>
    <artifactId>mybatis-ehcache</artifactId>
    <version>1.2.1</version>
</dependency>
```

在mapper中指定使用我们的ehcache缓存实现！

```xml
<cache type="org.mybatis.caches.EhcacheCache"/>
```





ehcache.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="http://ehcache.org/ehcache.xsd"
         updateCheck="false">

    <diskStore path="./tmpdir/Tmp_EhCache"/>

    <defaultCache
                  eternal="false"
                  maxElementsInMemory="10000"
                  overflowToDisk="false"
                  diskPersistent="false"
                  timeToIdleSeconds="1800"
                  timeToLiveSeconds="259200"
                  memoryStoreEvictionPolicy="LRU"/>

    <cache
           name="cloud_user"
           eternal="false"
           maxElementsInMemory="5000"
           overflowToDisk="false"
           diskPersistent="false"
           timeToIdleSeconds="1800"
           timeToLiveSeconds="1800"
           memoryStoreEvictionPolicy="LRU"/>
</ehcache>
```





