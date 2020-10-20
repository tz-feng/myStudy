

# SpringMVC

## 1、什么是MVC

### 1.1、什么是MVC

- MVC是模型(Model)、视图(View)、控制器(Controller)的简写，是一种软件设计规范。
- 是将业务逻辑、数据、显示分离的方法来组织代码。
- MVC主要作用是**降低了视图与业务逻辑间的双向偶合**。
- MVC不是一种设计模式，**MVC是一种架构模式**。当然不同的MVC存在差异。



**Model（模型）：**数据模型，提供要展示的数据，因此包含数据和行为，可以认为是领域模型或JavaBean组件（包含数据和行为），不过现在一般都分离开来：Value Object（数据Dao） 和 服务层（行为Service）。也就是模型提供了模型数据查询和模型数据的状态更新等功能，包括数据和业务。

**View（视图）：**负责进行模型的展示，一般就是我们见到的用户界面，客户想看到的东西。

**Controller（控制器）：**接收用户请求，委托给模型进行处理（状态改变），处理完毕后把返回的模型数据返回给视图，由视图负责展示。也就是说控制器做了个调度员的工作。



### 1.2、Model1时代

- 在web早期的开发中，通常采用的都是Model1。

- Model1中，主要分为两层，视图层和模型层。

  ![image-20201006112030355](D:\Typora-photos\SpringMVC\image-20201006112030355.png)

优点：架构简单，比较适合小型项目的开发

缺点：JSP职责不单一，不利于维护



### 1.3、Model2时代

Model2把一个项目分成三部分，包括**视图、控制、模型。**

![image-20201006112411640](D:\Typora-photos\SpringMVC\image-20201006112411640.png)



职责分析：

Model：模型

1. 业务逻辑
2. 保存数据的状态

View：视图

1. 显示页面

Controller：控制器

1. 获取前端数据
2. 调用业务逻辑
3. 转发或重定向到指定的页面



### 1.4、回顾Servlet

1. 创建一个Maven工程作为父工程，导入所需要的依赖

   ```xml
   <dependencies>
       <dependency>
           <groupId>javax.servlet</groupId>
           <artifactId>javax.servlet-api</artifactId>
           <version>4.0.1</version>
       </dependency>
       <dependency>
           <groupId>javax.servlet.jsp</groupId>
           <artifactId>javax.servlet.jsp-api</artifactId>
           <version>2.3.3</version>
       </dependency>
       <dependency>
           <groupId>javax.servlet.jsp.jstl</groupId>
           <artifactId>jstl-api</artifactId>
           <version>1.2</version>
       </dependency>
       <dependency>
           <groupId>taglibs</groupId>
           <artifactId>standard</artifactId>
           <version>1.1.2</version>
       </dependency>
       <dependency>
           <groupId>org.springframework</groupId>
           <artifactId>spring-webmvc</artifactId>
           <version>5.2.9.RELEASE</version>
       </dependency>
   </dependencies>
   ```

2. 在父工程里创建一个web项目

3. 在子项目内导入servlet和jsp依赖

   ```xml
   <dependencies>
     <dependency>
       <groupId>javax.servlet.jsp</groupId>
       <artifactId>javax.servlet.jsp-api</artifactId>
       <version>2.3.3</version>
     </dependency>
     <dependency>
       <groupId>javax.servlet</groupId>
       <artifactId>javax.servlet-api</artifactId>
       <version>4.0.1</version>
     </dependency>
   </dependencies>
   ```

4. 修改web.xml，修改为最新版

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
            version="4.0"
            metadata-complete="true">
   
   </web-app>
   ```

5. 配置Tomcat

6. 编写一个servlet

   ```java
   public class HelloServlet extends HttpServlet {
   
       @Override
       protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
           String method = req.getParameter("method");
   
           if (method.equals("add")) {
               req.setAttribute("msg","执行了add方法");
           }else if (method.equals("delete")) {
               req.setAttribute("msg","执行了delete方法");
           }
   
           req.getRequestDispatcher("/WEB-INF/jsp/hello.jsp").forward(req,resp);
       }
   
       @Override
       protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
           doGet(req, resp);
       }
   }
   ```

7. 在web.xml中注册servlet

   ```xml
   <servlet>
       <servlet-name>hello</servlet-name>
       <servlet-class>com.yjy.servlet.HelloServlet</servlet-class>
   </servlet>
   <servlet-mapping>
       <servlet-name>hello</servlet-name>
       <url-pattern>/hello</url-pattern>
   </servlet-mapping>
   ```

8. 测试

- localhost:8080/hello?method=add

- localhost:8080/hello?method=delete



## 2、什么是SpringMVC

### 2.1、概述

==Spring MVC是Spring Framework的一部分，是基于Java实现MVC的轻量级Web框架。==

官方文档：https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/web.html#spring-web



**我们为什么要学习SpringMVC呢?**

Spring MVC的特点：

1. 轻量级，简单易学
2. 高效 , 基于请求响应的MVC框架
3. 与Spring兼容性好，无缝结合
4. 约定优于配置
5. 功能强大：RESTful、数据验证、格式化、本地化、主题等
6. 简洁灵活

Spring的web框架围绕**DispatcherServlet** [ 调度Servlet ] 设计。



### 2.2、中心控制器

Spring的web框架围绕DispatcherServlet设计。DispatcherServlet的作用是将请求分发到不同的处理器。从Spring 2.5开始，使用Java 5或者以上版本的用户可以采用基于注解的controller声明方式。

Spring MVC框架像许多其他MVC框架一样, **以请求为驱动** , **围绕一个中心Servlet分派请求及提供其他功能**，**DispatcherServlet是一个实际的Servlet (它继承自HttpServlet 基类)**。



SpringMVC的原理如下图所示：

客户端发送的请求会被前端控制器拦截，前端控制器对请求进行解析后找到相对应的控制器。控制器获取前端传来的参数调用相对应的业务逻辑。通过模型将数据返回给控制器，控制器再将ModelAndView返回给前端控制器。然后前端控制器将数据交给视图进行渲染，然后将渲染后的页面返回给用户。

![image-20201006120413546](D:\Typora-photos\SpringMVC\image-20201006120413546.png)



### 2.3、SpringMVC执行原理

![image-20201006122140702](D:\Typora-photos\SpringMVC\image-20201006122140702.png)

图为SpringMVC的一个较完整的流程图，实线表示SpringMVC框架提供的技术，不需要开发者实现，虚线表示需要开发者实现。



**简要分析执行流程**

1. DispatcherServlet表示前置控制器，是整个SpringMVC的控制中心。用户发出请求，DispatcherServlet接收请求并拦截请求。

   我们假设请求的url为 : http://localhost:8080/SpringMVC/hello

   **如上url拆分成三部分：**

   http://localhost:8080服务器域名

   SpringMVC部署在服务器上的web站点

   hello表示控制器

   通过分析，如上url表示为：请求位于服务器localhost:8080上的SpringMVC站点的hello控制器。

2. HandlerMapping为处理器映射。DispatcherServlet调用HandlerMapping,HandlerMapping根据请求url查找Handler。

3. HandlerExecution表示具体的Handler,其主要作用是根据url查找控制器，如上url被查找控制器为：hello。

4. HandlerExecution将解析后的信息传递给DispatcherServlet,如解析控制器映射等。

5. HandlerAdapter表示处理器适配器，其按照特定的规则去执行Handler。

6. Handler让具体的Controller执行。

7. Controller将具体的执行信息返回给HandlerAdapter,如ModelAndView。

8. HandlerAdapter将视图逻辑名或模型传递给DispatcherServlet。

9. DispatcherServlet调用视图解析器(ViewResolver)来解析HandlerAdapter传递的逻辑视图名。

10. 视图解析器将解析的逻辑视图名传给DispatcherServlet。

11. DispatcherServlet根据视图解析器解析的视图结果，调用具体的视图。

12. 最终视图呈现给用户。



## 3、第一个SpringMVC程序

### 3.1、配置版

1. 创建一个新的web项目

2. 确认导入了SpringMVC的依赖

3. 配置web.xml，注册DispatcherServlet

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
            version="4.0">
   
     <!--配置DispatchServlet：这个是SpringMVC的核心；请求分发器，前端控制器-->
     <servlet>
       <servlet-name>springmvc</servlet-name>
       <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
       <!--DispatcherServlet要绑定Spring的配置文件-->
       <init-param>
         <param-name>contextConfigLocation</param-name>
         <param-value>classpath:springmvc-servlet.xml</param-value>
       </init-param>
       <!--启动级别：1-->
       <load-on-startup>1</load-on-startup>
     </servlet>
   
     <!--
     在SpringMVC中，  / /*
     /：只匹配所有的请求，不会去匹配jsp页面
     /*：匹配所有的请求，包括jsp页面
     -->
   
     <servlet-mapping>
       <servlet-name>springmvc</servlet-name>
       <url-pattern>/</url-pattern>
     </servlet-mapping>
   </web-app>
   ```

4. 创建一个springmvc-servlet.xml的配置文件

5. 在springmvc-servlet.xml配置处理映射器，处理器适配器和视图解析器

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans.xsd">
   
       <!--处理器映射器-->
       <bean class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping"/>
       <!--处理器适配器器-->
       <bean class="org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter"/>
   
       <!--视图解析器：模板引擎  Thymeleaf   Freemarker-->
       <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="InternalResourceViewResolver">
           <!--前缀-->
           <property name="prefix" value="/WEB-INF/jsp/"/>
           <!--后缀-->
           <property name="suffix" value=".jsp"/>
       </bean>
   
   </beans>
   ```

6. 编写Controller，实现Controller接口，返回ModelAndView

   ```java
   public class HelloController implements Controller {
   
       @Override
       public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
           ModelAndView mv = new ModelAndView();
   
           //业务代码
           String result = "HelloSpringMVC";
   
           mv.addObject("msg",result);
   
           //视图跳转
           mv.setViewName("hello");
   
           return mv;
       }
   }
   ```

7. 将编写好的Controller交给SpringIOC容器，注册bean

   ```xml
   <!--BeanNameUrlHandlerMapping:bean-->
   <bean id="/hello" class="com.yjy.controller.HelloController"/>
   ```

8. 编写jsp页面

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>Title</title>
   </head>
   <body>
      ${msg}
   </body>
   </html>
   ```

9. 配置Tomcat，启动测试



**可能遇到的问题：访问出现404，排查步骤：**

1. 查看控制台输出，看一下是不是缺少了什么jar包。
2. 如果jar包存在，显示无法输出，就在IDEA的项目发布中，添加lib依赖！
3. 重启Tomcat 即可解决！



### 3.2、注解版

1. 创建一个新的web项目

2. 确认所需要的依赖已经导入

3. 配置web.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
            version="4.0">
   
   
     <!--1.注册servlet-->
     <servlet>
       <servlet-name>SpringMVC</servlet-name>
       <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
       <!--通过初始化参数指定SpringMVC配置文件的位置，进行关联-->
       <init-param>
         <param-name>contextConfigLocation</param-name>
         <param-value>classpath:springmvc-servlet.xml</param-value>
       </init-param>
       <!-- 启动顺序，数字越小，启动越早 -->
       <load-on-startup>1</load-on-startup>
     </servlet>
   
   
     <!--所有请求都会被springmvc拦截 -->
     <servlet-mapping>
       <servlet-name>SpringMVC</servlet-name>
       <url-pattern>/</url-pattern>
     </servlet-mapping>
   
   
   </web-app>
   ```

   注意点：

   **/ 和 /\* 的区别：**< url-pattern > / </ url-pattern > 不会匹配到.jsp， 只针对我们编写的请求；即：.jsp 不会进入spring的 DispatcherServlet类 。< url-pattern > /* </ url-pattern > 会匹配 *.jsp，会出现返回 jsp视图 时再次进入spring的DispatcherServlet 类，导致找不到对应的controller所以报404错。

   - 注意web.xml版本问题，要最新版！
   - 注册DispatcherServlet
   - 关联SpringMVC的配置文件
   - 启动级别为1
   - 映射路径为 / 【不要用/*，会404】

4. 创建SpringMVC的配置文件

   在resource目录下添加springmvc-servlet.xml配置文件，配置的形式与Spring容器配置基本类似，为了支持基于注解的IOC，设置了自动扫描包的功能，具体配置信息如下：

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xmlns:mvc="http://www.springframework.org/schema/mvc"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans.xsd
          http://www.springframework.org/schema/context
          https://www.springframework.org/schema/context/spring-context.xsd
          http://www.springframework.org/schema/mvc
          https://www.springframework.org/schema/mvc/spring-mvc.xsd">
   
   
       <!-- 自动扫描包，让指定包下的注解生效,由IOC容器统一管理 -->
       <context:component-scan base-package="com.yjy.controller"/>
       <!-- 让Spring MVC不处理静态资源 -->
       <mvc:default-servlet-handler />
       <!--
       支持mvc注解驱动
           在spring中一般采用@RequestMapping注解来完成映射关系
           要想使@RequestMapping注解生效
           必须向上下文中注册DefaultAnnotationHandlerMapping
           和一个AnnotationMethodHandlerAdapter实例
           这两个实例分别在类级别和方法级别处理。
           而annotation-driven配置帮助我们自动完成上述两个实例的注入。
        -->
       <mvc:annotation-driven />
       
       <!-- 视图解析器 -->
       <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"
             id="internalResourceViewResolver">
           <!-- 前缀 -->
           <property name="prefix" value="/WEB-INF/jsp/" />
           <!-- 后缀 -->
           <property name="suffix" value=".jsp" />
       </bean>
   
   </beans>
   ```

   在视图解析器中我们把所有的视图都存放在/WEB-INF/目录下，这样可以保证视图安全，因为这个目录下的文件，客户端不能直接访问。

   - 让IOC的注解生效
   - 静态资源过滤 ：HTML . JS . CSS . 图片 ， 视频 .....
   - MVC的注解驱动
   - 配置视图解析器

5. 创建Controller

   ```java
   @Controller
   public class HelloController {
   
       @RequestMapping("/hello")
       public String hello(Model model) {
           model.addAttribute("msg","Hello,SpringMVCAnnotation");
   
           return "hello";
       }
   }
   ```

   - @Controller是为了让Spring IOC容器初始化时自动扫描到；
   - @RequestMapping是为了映射请求路径，这里因为类与方法上都有映射所以访问时应该是/HelloController/hello；
   - 方法中声明Model类型的参数是为了把Action中的数据带到视图中；
   - 方法返回的结果是视图的名称hello，加上配置文件中的前后缀变成WEB-INF/jsp/**hello**.jsp。

6. 创建视图层（jsp）

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>yjy</title>
   </head>
   <body>
       ${msg}
   </body>
   </html>
   ```

7. 配置Tomcat，测试



### 3.3、小结

实现步骤其实非常的简单：

1. 新建一个web项目
2. 导入相关jar包
3. 编写web.xml , 注册DispatcherServlet
4. 编写springmvc配置文件
5. 接下来就是去创建对应的控制类 , controller
6. 最后完善前端视图和controller之间的对应
7. 测试运行调试.



## 4、控制器Controller

- 控制器复杂提供访问应用程序的行为，通常通过接口定义或注解定义两种方法实现。
- 控制器负责解析用户的请求并将其转换为一个模型。
- 在Spring MVC中一个控制器类可以包含多个方法
- 在Spring MVC中，对于Controller的配置方式有很多种



### 4.1、实现Controller接口

实现的是org.springframework.web.servlet.mvc.Controller下的Controller，它里面只有一个方法。

```java
public interface Controller {
    @Nullable
    ModelAndView handleRequest(HttpServletRequest var1, HttpServletResponse var2) throws Exception;
}
```

实现该方法需要返回ModelAndView对象

```java
public class TestController2 implements Controller {
    @Override
    public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
        ModelAndView mv = new ModelAndView();

        mv.addObject("msg","test2");

        mv.setViewName("test");

        return mv;
    }
}
```

当编写完Controller之后需要将他在SpringMVC的配置文件中注册

```java
<bean class="com.yjy.controller.TestController2" id="/test2" />
```

注意：这里的id=“/test2”是因为他代表的是请求，当请求是/test2时他就会去寻找这个Controller。



缺点：每一个Controller中只能有一个方法，如果要多个方法则需要定义多个Controller；定义的方式比较麻烦。



### 4.2、使用注解@Controller

- @Controller注解类型用于声明Spring类的实例是一个控制器（在讲IOC时还提到了另外3个注解）；
- Spring可以使用扫描机制来找到应用程序中所有基于注解的控制器类，为了保证Spring能找到你的控制器，需要在配置文件中声明组件扫描。

```xml
<!-- 自动扫描指定的包，下面所有注解类交给IOC容器管理 -->
<context:component-scan base-package="com.yjy.controller"/>
```

编写Controller

```java
@Controller //代表这个类会被Spring接管
// 被这个注解的类，中的所有方法，如果返回值是String，并且有具体页面可以跳转，那么就会被视图解析器解析；
public class TestController1 {

    @RequestMapping("/test")
    public String test1(Model model) {
        model.addAttribute("msg","test1");
        return "test";
    }
}
```

**@RequestMapping**

@RequestMapping注解用于映射url到控制器类或一个特定的处理程序方法。可用于类或方法上。用于类上，表示类中的所有响应请求的方法都是以该地址作为父路径。



## 5、RestFul风格

**概念**

Restful就是一个资源定位及资源操作的**风格**。不是标准也不是协议，只是一种风格。基于这个风格设计的软件可以更简洁，更有层次，更易于实现缓存等机制。

**功能**

资源：互联网所有的事物都可以被抽象为资源

资源操作：使用POST、DELETE、PUT、GET，使用不同方法对资源进行操作。

分别对应 添加、 删除、修改、查询。

**传统方式操作资源** ：通过不同的参数来实现不同的效果！方法单一，post 和 get

http://127.0.0.1/item/queryItem.action?id=1 查询,GET

http://127.0.0.1/item/saveItem.action 新增,POST

http://127.0.0.1/item/updateItem.action 更新,POST

http://127.0.0.1/item/deleteItem.action?id=1 删除,GET或POST

**使用RESTful操作资源** ：可以通过不同的请求方式来实现不同的效果！如下：请求地址一样，但是功能可以不同！

http://127.0.0.1/item/1 查询,GET

http://127.0.0.1/item 新增,POST

http://127.0.0.1/item 更新,PUT

http://127.0.0.1/item/1 删除,DELETE



> 实现Restful风格

测试：

1. 新建一个Controller

2. 在Spring MVC中可以使用  @PathVariable 注解，让方法参数的值对应绑定到一个URI模板变量上。

   ```java
   @Controller
   public class RestFulController {
   
       @RequestMapping("/restful/{a}/{b}")
       public String restfulTest(@PathVariable int a, @PathVariable int b, Model model) {
           model.addAttribute("result","结果为：" + (a+b));
           return "add";
       }
   }
   ```

3. 测试



好处：

- 使路径变得更加简洁；
- 获得参数更加方便，框架会自动进行类型转换。
- 通过路径变量的类型可以约束访问参数，如果类型不一样，则访问不到对应的请求方法，如这里访问是的路径是/commit/1/a，则路径与方法不匹配，而不会是参数转换失败。



> 请求同样的地址，实现不同的功能

测试：

通过指定请求的类型来实现同样的地址，实现不同的功能。

**使用method属性指定请求类型**

用于约束请求的类型，可以收窄请求范围。指定请求谓词的类型如GET, POST, HEAD, OPTIONS, PUT, PATCH, DELETE, TRACE等。



网页默认的请求方式为GET，我们将方法的请求设置为POST

```java
@RequestMapping(value = "/restful/{a}/{b}",method = RequestMethod.POST)
public String restfulTest(@PathVariable int a, @PathVariable int b, Model model) {
    model.addAttribute("result","结果为：" + (a+b));
    return "add";
}
```

结果：

![image-20201006133727106](D:\Typora-photos\SpringMVC\image-20201006133727106.png)



我们将方法的请求改为GET

```java
@RequestMapping(value = "/restful/{a}/{b}",method = RequestMethod.GET)
public String restfulTest(@PathVariable int a, @PathVariable int b, Model model) {
    model.addAttribute("result","结果为：" + (a+b));
    return "add";
}
```

结果：

![image-20201006133826967](D:\Typora-photos\SpringMVC\image-20201006133826967.png)



**小结：**

Spring MVC 的 @RequestMapping 注解能够处理 HTTP 请求的方法, 比如 GET, PUT, POST, DELETE 以及 PATCH。

**所有的地址栏请求默认都会是 HTTP GET 类型的。**

方法级别的注解变体有如下几个：组合注解

```java
@GetMapping
@PostMapping
@PutMapping
@DeleteMapping
@PatchMapping
```

@GetMapping 是一个组合注解，平时使用的会比较多！

它所扮演的是 @RequestMapping(method =RequestMethod.GET) 的一个快捷方式。



## 6、结果跳转方式

### 6.1、ModelAndView

设置ModelAndView对象 , 根据view的名称 , 和视图解析器跳到指定的页面 

页面 : {视图解析器前缀} + viewName +{视图解析器后缀}

```xml
<!-- 视图解析器 -->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"
      id="internalResourceViewResolver">
    <!-- 前缀 -->
    <property name="prefix" value="/WEB-INF/jsp/" />
    <!-- 后缀 -->
    <property name="suffix" value=".jsp" />
</bean>
```

对应的Controller类

```java
public class JumpTest1 implements Controller {
    @Override
    public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.addObject("msg","Hello,ModelAndView");
        mv.setViewName("test");
        return mv;
    }
}
```



### 6.2、ServletAPI

通过设置ServletAPI , 不需要视图解析器 .

1、通过HttpServletResponse进行输出

2、通过HttpServletResponse实现重定向（注意：重定向不能直接访问WEB-INF下的jsp）	

3、通过HttpServletResponse实现转发

```java
@Controller
public class JumpTest2 {

    @GetMapping("/jump2/t1")
    public void test1(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.getWriter().write("Hello,SpringAPI");
    }

    @GetMapping("/jump2/t2")
    public void test2(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect("/index.jsp");
    }

    @GetMapping("/jump2/t3")
    public void test3(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.setAttribute("msg","Hello,SpringAPI");
        req.getRequestDispatcher("/WEB-INF/jsp/test.jsp").forward(req,resp);
    }
}
```



### 6.3、SpringMVC

**通过SpringMVC来实现转发和重定向 - 无需视图解析器；**

测试前，需要将视图解析器注释掉

```java
@Controller
public class JumpTest3 {

    @GetMapping("/jump3/t1")
    public String test1(Model model) {
        model.addAttribute("msg","Hello,SpringMVC");
        //转发
        return "/WEB-INF/jsp/test.jsp";
    }

    @GetMapping("/jump3/t2")
    public String test2(Model model) {
        model.addAttribute("msg","Hello,SpringMVC");
        //转发
        return "forward:/WEB-INF/jsp/test.jsp";
    }

    @GetMapping("/jump3/t3")
    public String test3() {
        //重定向
        return "redirect:/index.jsp";
    }
}
```



**通过SpringMVC来实现转发和重定向 - 有视图解析器；**

重定向 , 不需要视图解析器 , 本质就是重新请求一个新地方嘛 , 所以注意路径问题.

可以重定向到另外一个请求实现 



## 7、数据处理

### 7.1、提交的域名称和处理方法的参数名一致

提交数据 : http://localhost:8080/t1?name=yjy

处理方法 :

```java
@GetMapping("/t1")
public String test1(String name) {
    System.out.println(name);
    return "test";
}
```



### 7.2、提交的域名称和处理方法的参数名不一致

提交数据 ：http://localhost:8080/t2?username=yjy

处理方法 :

```java
//@GetMapping("username") : username提交的域的名称 .
@GetMapping("/t2")
public String test2(@RequestParam("username") String name) {
    System.out.println(name);
    return "test";
}
```



### 7.3、提交一个对象

要求提交的表单域和对象的属性名一致  , 参数使用对象即可

1、实体类

```java
public class User {
    private int id;
    private String name;
    private int age;
    //构造
    //get/set
    //tostring()
}
```

提交数据 ：http://localhost:8080/t3?id=1&name=yjy&age=3

处理方法 :

```java
@GetMapping("/t3")
public String test3(User user) {
    System.out.println(user);
    return "test";
}
```

说明：如果使用对象的话，前端传递的参数名和对象名必须一致，否则就是null。



## 8、数据显示到前端

### 8.1、通过ModelAndView

创建一个ModelAndView对象，存档数据以及要回显的页面。

```java
public class TestController2 implements Controller {
    @Override
    public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.addObject("msg","test2");
        mv.setViewName("test");
        return mv;
    }
}
```



### 8.2、通过ModelMap

```java
@RequestMapping("/hello")
public String hello(@RequestParam("username") String name, ModelMap model){
    //封装要显示到视图中的数据
    //相当于req.setAttribute("name",name);
    model.addAttribute("name",name);
    System.out.println(name);
    return "hello";
}
```



### 8.3、通过Model

```java
@RequestMapping("/ct2/hello")
public String hello(@RequestParam("username") String name, Model model){
    //封装要显示到视图中的数据
    //相当于req.setAttribute("name",name);
    model.addAttribute("msg",name);
    System.out.println(name);
    return "test";
}
```



**对比**

就对于新手而言简单来说使用区别就是：

```
Model 只有寥寥几个方法只适合用于储存数据，简化了新手对于Model对象的操作和理解；
 
ModelMap 继承了 LinkedMap ，除了实现了自身的一些方法，同样的继承 LinkedMap 的方法和特性；
 
ModelAndView 可以在储存数据的同时，可以进行设置返回的逻辑视图，进行控制展示层的跳转。
```



## 9、中文乱码问题

测试

编写一个form表单

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <form action="/e/t1" method="post">
        <input type="text" name="name"/>
        <input type="submit"/>
    </form>
</body>
</html>
```

后台编写对应的处理类

```java
@RequestMapping("/e/t1")
public String test1(@RequestParam("name") String name, Model model) {
    System.out.println(name);
    model.addAttribute("msg",name);
    return "test";
}
```

结果：当使用post请求会出现中文乱码，但使用get请求不会。

![image-20201006173438454](D:\Typora-photos\SpringMVC\image-20201006173438454.png)

### 9.1、解决方案一

自定义编码过滤器

1. 编写一个过滤器

   ```java
   public class EncodingFilter implements Filter {
       @Override
       public void init(FilterConfig filterConfig) throws ServletException {
   
       }
   
       @Override
       public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
           request.setCharacterEncoding("utf-8");
           response.setCharacterEncoding("utf-8");
           chain.doFilter(request, response);
       }
   
       @Override
       public void destroy() {
   
       }
   }
   ```

2. 在web.xml中配置

   ```xml
   <filter>
     <filter-name>encoding</filter-name>
     <filter-class>com.yjy.filter.EncodingFilter</filter-class>
   </filter>
   <filter-mapping>
     <filter-name>encoding</filter-name>
     <url-pattern>/*</url-pattern>
   </filter-mapping>
   ```



### 9.2、解决方案二（推荐使用）

SpringMVC给我们提供了一个过滤器 , 可以在web.xml中配置。

修改web.xml文件

```xml
<filter>
    <filter-name>encoding</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>encoding</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

有些极端情况下.这个过滤器对get的支持不好。



### 9.3、解决方案三

大佬自定义的编码过滤器

```java
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Map;
 
/**
 * 解决get和post请求 全部乱码的过滤器
 */
public class GenericEncodingFilter implements Filter {
 
    @Override
    public void destroy() {
    }
 
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        //处理response的字符编码
        HttpServletResponse myResponse=(HttpServletResponse) response;
        myResponse.setContentType("text/html;charset=UTF-8");
 
        // 转型为与协议相关对象
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        // 对request包装增强
        HttpServletRequest myrequest = new MyRequest(httpServletRequest);
        chain.doFilter(myrequest, response);
    }
 
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
 
}
 
//自定义request对象，HttpServletRequest的包装类
class MyRequest extends HttpServletRequestWrapper {
 
    private HttpServletRequest request;
    //是否编码的标记
    private boolean hasEncode;
    //定义一个可以传入HttpServletRequest对象的构造函数，以便对其进行装饰
    public MyRequest(HttpServletRequest request) {
        super(request);// super必须写
        this.request = request;
    }
 
    // 对需要增强方法 进行覆盖
    @Override
    public Map getParameterMap() {
        // 先获得请求方式
        String method = request.getMethod();
        if (method.equalsIgnoreCase("post")) {
            // post请求
            try {
                // 处理post乱码
                request.setCharacterEncoding("utf-8");
                return request.getParameterMap();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        } else if (method.equalsIgnoreCase("get")) {
            // get请求
            Map<String, String[]> parameterMap = request.getParameterMap();
            if (!hasEncode) { // 确保get手动编码逻辑只运行一次
                for (String parameterName : parameterMap.keySet()) {
                    String[] values = parameterMap.get(parameterName);
                    if (values != null) {
                        for (int i = 0; i < values.length; i++) {
                            try {
                                // 处理get乱码
                                values[i] = new String(values[i]
                                        .getBytes("ISO-8859-1"), "utf-8");
                            } catch (UnsupportedEncodingException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
                hasEncode = true;
            }
            return parameterMap;
        }
        return super.getParameterMap();
    }
 
    //取一个值
    @Override
    public String getParameter(String name) {
        Map<String, String[]> parameterMap = getParameterMap();
        String[] values = parameterMap.get(name);
        if (values == null) {
            return null;
        }
        return values[0]; // 取回参数的第一个值
    }
 
    //取所有值
    @Override
    public String[] getParameterValues(String name) {
        Map<String, String[]> parameterMap = getParameterMap();
        String[] values = parameterMap.get(name);
        return values;
    }
}
```

然后在web.xml中配置过滤器即可。

一般情况下，SpringMVC默认的乱码处理就已经能够很好的解决了！



## 10、JSON交互处理

### 10.1、什么是json

- JSON(JavaScript Object Notation, JS 对象简谱) 是一种轻量级的数据交换格式。
- 采用完全独立于编程语言的**文本格式**来存储和表示数据。
- 简洁和清晰的层次结构使得 JSON 成为理想的数据交换语言。
- 易于人阅读和编写，同时也易于机器解析和生成，并有效地提升网络传输效率。



### 10.2、json的要求与格式

- 对象表示为键值对，数据由逗号分隔
- 花括号保存对象
- 方括号保存数组

**JSON 键值对**是用来保存 JavaScript 对象的一种方式，和 JavaScript 对象的写法也大同小异，键/值对组合中的键名写在前面并用双引号 "" 包裹，使用冒号 : 分隔，然后紧接着值：

```json
{"name": "yjy"}
{"age": "3"}
{"sex": "男"}
```



JSON 是 JavaScript 对象的字符串表示法，它使用文本表示一个 JS 对象的信息，本质是一个字符串。



### 10.3、JSON 和 JavaScript 对象互转

- 要实现从JSON字符串转换为JavaScript 对象，使用 JSON.parse() 方法：

  ```javascript
  var obj = JSON.parse('{"a": "Hello", "b": "World"}');
  //结果是 {a: 'Hello', b: 'World'}
  ```

- 要实现从JavaScript 对象转换为JSON字符串，使用 JSON.stringify() 方法：

  ```javascript
  var json = JSON.stringify({a: 'Hello', b: 'World'});
  //结果是 '{"a": "Hello", "b": "World"}'
  ```

测试：

1. 创建一个新的web项目

2. 在web目录下创建一个html页面

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <title>Title</title>
   
       <script type="text/javascript">
           //编写一个Javascript对象
           var user = {
               name:"小狂神",
               age:3,
               sex:"男"
           };
   
           //将js对象转换成json字符串
           var str = JSON.stringify(user);
           console.log(str);
   
           //将json字符串转换为js对象
           var user2 = JSON.parse(str);
           console.log(user2.age,user2.name,user2.sex);
   
       </script>
   </head>
   
   <body>
   
   </body>
   </html>
   ```

3. 在IDEA中使用浏览器，查看后台输出的数据

   ![image-20201006185010643](D:\Typora-photos\SpringMVC\image-20201006185010643.png)



### 10.4、如何让Controller返回JSON数据

我们可以通过String类将数据转变成JSON格式，但是比较麻烦。因此可以使用一些json解析工具。如：Jackson，阿里巴巴的fastjson 等等。



#### 10.4.1、Jackson

1. 导入所需要的依赖

   ```xml
   <!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind -->
   <dependency>
       <groupId>com.fasterxml.jackson.core</groupId>
       <artifactId>jackson-databind</artifactId>
       <version>2.11.3</version>
   </dependency>
   
   ```

2. 编写实体类

   ```java
   public class User {
       
       private String name;
       private int age;
       private String sex;
   
       public User() {
       }
   
       public User(String name, int age, String sex) {
           this.name = name;
           this.age = age;
           this.sex = sex;
       }
   
       public String getName() {
           return name;
       }
   
       public void setName(String name) {
           this.name = name;
       }
   
       public int getAge() {
           return age;
       }
   
       public void setAge(int age) {
           this.age = age;
       }
   
       public String getSex() {
           return sex;
       }
   
       public void setSex(String sex) {
           this.sex = sex;
       }
   
       @Override
       public String toString() {
           return "User{" +
                   "name='" + name + '\'' +
                   ", age=" + age +
                   ", sex='" + sex + '\'' +
                   '}';
       }
   }
   ```

3. 编写一个Controller

   ```java
   @Controller
   public class JsonController {
   
       @RequestMapping("/json1")
       @ResponseBody
       public String test1() throws JsonProcessingException {
           //创建一个对象
           User user = new User("小狂神", 3, "男");
           //创建一个jackson的对象映射器，用来解析数据
           ObjectMapper mapper = new ObjectMapper();
           //将我们的对象解析成为json格式
           String str = mapper.writeValueAsString(user);
           //由于@ResponseBody注解，这里会将str转成json格式返回；十分方便
           return str;
       }
   }
   ```

4. 配置Tomcat，测试

   ![image-20201006210113639](D:\Typora-photos\SpringMVC\image-20201006210113639.png)



**解决json中文乱码问题：**

通过@RequestMaping的produces属性来实现，比较麻烦，因为每个方法都要写。

```java
//produces:指定响应体返回类型和编码
@RequestMapping(value = "/json1",produces = "application/json;charset=utf-8")
```



通过springmvc的配置文件上添加一段消息StringHttpMessageConverter转换配置！

```xml
<mvc:annotation-driven>
    <mvc:message-converters register-defaults="true">
        <bean class="org.springframework.http.converter.StringHttpMessageConverter">
            <constructor-arg value="UTF-8"/>
        </bean>
        <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
            <property name="objectMapper">
                <bean class="org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean">
                    <property name="failOnEmptyBeans" value="false"/>
                </bean>
            </property>
        </bean>
    </mvc:message-converters>
</mvc:annotation-driven>
```



**返回json字符串统一解决**

在类上直接使用 **@RestController** ，这样子，里面所有的方法都只会返回 json 字符串了，不用再每一个都添加@ResponseBody ！我们在前后端分离开发中，一般都使用 @RestController ，十分便捷！

```java
@RestController
public class JsonController {

    @RequestMapping("/json1")
    public String test1() throws JsonProcessingException {
        //创建一个对象
        User user = new User("小狂神", 3, "男");
        //创建一个jackson的对象映射器，用来解析数据
        ObjectMapper mapper = new ObjectMapper();
        //将我们的对象解析成为json格式
        String str = mapper.writeValueAsString(user);
        return str;
    }
}
```



> 集合输出

方法：

```java
@RequestMapping("/json2")
public String test2() throws JsonProcessingException {
    //创建多个对象
    User user1 = new User("小狂神1", 3, "男");
    User user2 = new User("小狂神2", 3, "男");
    User user3 = new User("小狂神3", 3, "男");
    User user4 = new User("小狂神4", 3, "男");
    //将对象存入数组中
    ArrayList<User> users = new ArrayList<>();
    users.add(user1);
    users.add(user2);
    users.add(user3);
    users.add(user4);
    //创建一个jackson的对象映射器，用来解析数据
    ObjectMapper mapper = new ObjectMapper();
    //将我们的对象解析成为json格式
    String str = mapper.writeValueAsString(users);
    return str;
}
```

结果：

![image-20201006210722618](D:\Typora-photos\SpringMVC\image-20201006210722618.png)



> 时间输出

方法：

```java
@RequestMapping("/json3")
public String test3() throws JsonProcessingException {
    //创建一个时间对象
    Date date = new Date();
    //创建一个jackson的对象映射器，用来解析数据
    ObjectMapper mapper = new ObjectMapper();
    //将我们的对象解析成为json格式
    String str = mapper.writeValueAsString(date);
    return str;
}
```

结果：

![image-20201006211035172](D:\Typora-photos\SpringMVC\image-20201006211035172.png)

默认日期格式会变成一个数字，是1970年1月1日到当前日期的毫秒数！

Jackson 默认是会把时间转成timestamps形式



**解决方案：取消timestamps形式 ， 自定义时间格式**

方法：

```java
@RequestMapping("/json4")
public String test4() throws JsonProcessingException {
    //创建一个时间对象
    Date date = new Date();
    //创建一个jackson的对象映射器，用来解析数据
    ObjectMapper mapper = new ObjectMapper();
    //不使用时间戳的格式
    mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS,false);
    //设置日期格式
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    //将mapper的日期格式设置为sdf
    mapper.setDateFormat(sdf);
    //将我们的对象解析成为json格式
    String str = mapper.writeValueAsString(date);
    return str;
}
```

结果：

![image-20201006211957685](D:\Typora-photos\SpringMVC\image-20201006211957685.png)



> 抽取工具类

```java
public class JsonUtil {

    public static String getJson(Object object) {
        return getJson(object,"yyyy-MM-dd HH:mm:ss");
    }

    public static String getJson(Object object, String dateFormat) {
        //创建一个jackson的对象映射器，用来解析数据
        ObjectMapper mapper = new ObjectMapper();
        //不使用时间戳的格式
        mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS,false);
        //设置日期格式
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        //将mapper的日期格式设置为dateFormat
        mapper.setDateFormat(sdf);
        String json = null;
        try {
            //将传入的对象解析成为json格式
            json = mapper.writeValueAsString(object);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return json;

    }
}
```

方法：

```java
@RequestMapping("/json5")
public String test5() {
    Date date = new Date();
    String json = JsonUtil.getJson(date);
    return json;
}
```



#### 10.4.2、fastjson

fastjson 三个主要的类：

**JSONObject  代表 json 对象**

- JSONObject实现了Map接口, 猜想 JSONObject底层操作是由Map实现的。
- JSONObject对应json对象，通过各种形式的get()方法可以获取json对象中的数据，也可利用诸如size()，isEmpty()等方法获取"键：值"对的个数和判断是否为空。其本质是通过实现Map接口并调用接口中的方法完成的。

**JSONArray  代表 json 对象数组**

- 内部是有List接口中的方法来完成操作的。

**JSON代表 JSONObject和JSONArray的转化**

- JSON类源码分析与使用
- 仔细观察这些方法，主要是实现json对象，json对象数组，javabean对象，json字符串之间的相互转化。



测试：

1. 导入fastjson依赖

   ```xml
   <!-- https://mvnrepository.com/artifact/com.alibaba/fastjson -->
   <dependency>
       <groupId>com.alibaba</groupId>
       <artifactId>fastjson</artifactId>
       <version>1.2.73</version>
   </dependency>
   ```

2. 编写测试类

   ```java
   public class FastjsonDemo {
   
       public static void main(String[] args) {
           //创建一个对象
           User user1 = new User("小狂神1号", 3, "男");
           User user2 = new User("小狂神2号", 3, "男");
           User user3 = new User("小狂神3号", 3, "男");
           User user4 = new User("小狂神4号", 3, "男");
           List<User> list = new ArrayList<User>();
           list.add(user1);
           list.add(user2);
           list.add(user3);
           list.add(user4);
   
           System.out.println("*******Java对象 转 JSON字符串*******");
           String str1 = JSON.toJSONString(list);
           System.out.println("JSON.toJSONString(list)==>"+str1);
           String str2 = JSON.toJSONString(user1);
           System.out.println("JSON.toJSONString(user1)==>"+str2);
   
           System.out.println("\n****** JSON字符串 转 Java对象*******");
           User jp_user1=JSON.parseObject(str2,User.class);
           System.out.println("JSON.parseObject(str2,User.class)==>"+jp_user1);
   
           System.out.println("\n****** Java对象 转 JSON对象 ******");
           JSONObject jsonObject1 = (JSONObject) JSON.toJSON(user2);
           System.out.println("(JSONObject) JSON.toJSON(user2)==>"+jsonObject1.getString("name"));
   
           System.out.println("\n****** JSON对象 转 Java对象 ******");
           User to_java_user = JSON.toJavaObject(jsonObject1, User.class);
           System.out.println("JSON.toJavaObject(jsonObject1, User.class)==>"+to_java_user);
       }
   }
   ```



## 11、ssm整合

> 数据库环境

```sql
CREATE DATABASE `ssmbuild`;
 
USE `ssmbuild`;
 
DROP TABLE IF EXISTS `books`;
 
CREATE TABLE `books` (
  `bookID` INT(10) NOT NULL AUTO_INCREMENT COMMENT '书id',
  `bookName` VARCHAR(100) NOT NULL COMMENT '书名',
  `bookCounts` INT(11) NOT NULL COMMENT '数量',
  `detail` VARCHAR(200) NOT NULL COMMENT '描述',
  KEY `bookID` (`bookID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8
 
INSERT  INTO `books`(`bookID`,`bookName`,`bookCounts`,`detail`)VALUES 
(1,'Java',1,'从入门到放弃'),
(2,'MySQL',10,'从删库到跑路'),
(3,'Linux',5,'从进门到进牢');
```



> 基本环境配置

1. 创建一个新的maven项目，添加web的支持

2. 导入相关的pom依赖

   ```xml
   <dependencies>
     <!--Junit-->
     <dependency>
       <groupId>junit</groupId>
       <artifactId>junit</artifactId>
       <version>4.12</version>
     </dependency>
     <!--数据库驱动-->
     <dependency>
       <groupId>mysql</groupId>
       <artifactId>mysql-connector-java</artifactId>
       <version>8.0.21</version>
     </dependency>
     <!-- 数据库连接池 -->
     <dependency>
       <groupId>com.mchange</groupId>
       <artifactId>c3p0</artifactId>
       <version>0.9.5.2</version>
     </dependency>
   
     <!--Servlet - JSP -->
     <dependency>
       <groupId>javax.servlet</groupId>
       <artifactId>servlet-api</artifactId>
       <version>2.5</version>
     </dependency>
     <dependency>
       <groupId>javax.servlet.jsp</groupId>
       <artifactId>jsp-api</artifactId>
       <version>2.2</version>
     </dependency>
     <dependency>
       <groupId>javax.servlet</groupId>
       <artifactId>jstl</artifactId>
       <version>1.2</version>
     </dependency>
   
     <!--Mybatis-->
     <dependency>
       <groupId>org.mybatis</groupId>
       <artifactId>mybatis</artifactId>
       <version>3.5.2</version>
     </dependency>
     <dependency>
       <groupId>org.mybatis</groupId>
       <artifactId>mybatis-spring</artifactId>
       <version>2.0.2</version>
     </dependency>
   
     <!--Spring-->
     <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-webmvc</artifactId>
       <version>5.1.9.RELEASE</version>
     </dependency>
     <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-jdbc</artifactId>
       <version>5.1.9.RELEASE</version>
     </dependency>
   </dependencies>
   ```

3. Maven资源过滤配置

   ```xml
   <build>
     <resources>
       <resource>
         <directory>src/main/java</directory>
         <includes>
           <include>**/*.properties</include>
           <include>**/*.xml</include>
         </includes>
         <filtering>false</filtering>
       </resource>
       <resource>
         <directory>src/main/resources</directory>
         <includes>
           <include>**/*.properties</include>
           <include>**/*.xml</include>
         </includes>
         <filtering>false</filtering>
       </resource>
     </resources>
   </build>
   ```

4. 创建基本的项目结构

   com.yjy.pojo

   com.yjy.dao

   com.yjy.service

   com.yjy.controller

   mybatis-config.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE configuration
           PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-config.dtd">
   <configuration>
    
   </configuration>
   ```

   applicationContext.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd">
    
   </beans>
   ```

   

### 11.1、Mybatis层

1. 数据库配置文件database.properties

   ```properties
   jdbc.driver=com.mysql.cj.jdbc.Driver
   jdbc.url=jdbc:mysql://localhost:3306/ssmbuild?useSSL=true&useUnicode=true&characterEncoding=utf8
   jdbc.username=root
   jdbc.password=love19980920
   ```

2. IDEA关联数据库

3. 编写Mybatis的核心配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE configuration
           PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-config.dtd">
   <configuration>
   
       <typeAliases>
           <package name="com.yjy.pojo"/>
       </typeAliases>
       <mappers>
           <mapper class="com.yjy.dao.BookMapper"/>
       </mappers>
   
   </configuration>
   ```

4. 编写数据库对应的实体类

   ```java
   public class Books {
   
       private int bookID;
       private String bookName;
       private int bookCounts;
       private String detail;
   
       public Books() {
       }
   
       public Books(int bookID, String bookName, int bookCounts, String detail) {
           this.bookID = bookID;
           this.bookName = bookName;
           this.bookCounts = bookCounts;
           this.detail = detail;
       }
   
       public int getBookID() {
           return bookID;
       }
   
       public void setBookID(int bookID) {
           this.bookID = bookID;
       }
   
       public String getBookName() {
           return bookName;
       }
   
       public void setBookName(String bookName) {
           this.bookName = bookName;
       }
   
       public int getBookCounts() {
           return bookCounts;
       }
   
       public void setBookCounts(int bookCounts) {
           this.bookCounts = bookCounts;
       }
   
       public String getDetail() {
           return detail;
       }
   
       public void setDetail(String detail) {
           this.detail = detail;
       }
   
       @Override
       public String toString() {
           return "Books{" +
                   "bookID=" + bookID +
                   ", bookName='" + bookName + '\'' +
                   ", bookCounts=" + bookCounts +
                   ", detail='" + detail + '\'' +
                   '}';
       }
   }
   ```

5. 编写Dao层的 Mapper接口

   ```java
   public interface BooksMapper {
   
       //添加一本书
       int addBook(Books books);
   
       //删除一本书
       int deleteBookById(int id);
   
       //修改一本书
       int updateBook(int id);
   
       //查询一本书
       Books queryBookById(int id);
   
       //查询所有的书
       List<Books> queryAllBooks();
   
   }
   ```

6. 编写接口对应的 Mapper.xml文件

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE mapper
           PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   <mapper namespace="com.yjy.dao.BooksMapper">
   
       <insert id="addBook" parameterType="Books">
           insert into books(bookName,bookCounts,detail)
           values(#{bookName},#{bookCounts},#{detail})
       </insert>
   
       <delete id="deleteBookById" parameterType="int">
           delete from books where bookID = #{bookID}
       </delete>
   
       <update id="updateBook" parameterType="Books">
           update books
           set bookName=#{bookName},bookCounts=#{bookCounts},detail=#{detail}
           where bookID = #{bookID}
       </update>
   
       <select id="queryBookById" parameterType="int" resultType="Books">
           select * from books where bookID = #{bookID}
       </select>
   
       <select id="queryAllBooks" resultType="Books">
           select * from books
       </select>
   
   </mapper>
   ```

7. 编写Service层的接口和实现类

   接口：

   ```java
   public interface BooksService {
   
       //添加一本书
       int addBook(Books books);
   
       //删除一本书
       int deleteBookById(int id);
   
       //修改一本书
       int updateBook(Books books);
   
       //查询一本书
       Books queryBookById(int id);
   
       //查询所有的书
       List<Books> queryAllBooks();
   
   }
   ```

   实现类：

   ```java
   public class BooksServiceImpl implements BooksService{
   
       private BooksMapper booksMapper;
   
       public void setBooksMapper(BooksMapper booksMapper) {
           this.booksMapper = booksMapper;
       }
   
       @Override
       public int addBook(Books books) {
           return booksMapper.addBook(books);
       }
   
       @Override
       public int deleteBookById(int id) {
           return booksMapper.deleteBookById(id);
       }
   
       @Override
       public int updateBook(Books books) {
           return booksMapper.updateBook(books);
       }
   
       @Override
       public Books queryBookById(int id) {
           return booksMapper.queryBookById(id);
       }
   
       @Override
       public List<Books> queryAllBooks() {
           return booksMapper.queryAllBooks();
       }
   }
   ```



### 11.2、Spring层

1. 配置Spring整合MyBatis，使用的数据源是c3p0连接池

2. 编写Spring整合MyBatis的相关配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           https://www.springframework.org/schema/context/spring-context.xsd">
   
       <!-- 配置整合mybatis -->
       <!-- 1.关联数据库文件 -->
       <context:property-placeholder location="classpath:database.properties"/>
   
       <!-- 2.数据库连接池 -->
       <!--数据库连接池
           dbcp  半自动化操作  不能自动连接
           c3p0  自动化操作（自动的加载配置文件 并且设置到对象里面）
       -->
       <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
           <!-- 配置连接池属性 -->
           <property name="driverClass" value="${jdbc.driver}"/>
           <property name="jdbcUrl" value="${jdbc.url}"/>
           <property name="user" value="${jdbc.username}"/>
           <property name="password" value="${jdbc.password}"/>
           <!-- c3p0连接池的私有属性 -->
           <property name="maxPoolSize" value="30"/>
           <property name="minPoolSize" value="10"/>
           <!-- 关闭连接后不自动commit -->
           <property name="autoCommitOnClose" value="false"/>
           <!-- 获取连接超时时间 -->
           <property name="checkoutTimeout" value="10000"/>
           <!-- 当获取连接失败重试次数 -->
           <property name="acquireRetryAttempts" value="2"/>
       </bean>
       <!-- 3.配置SqlSessionFactory对象 -->
       <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
           <!-- 注入数据库连接池 -->
           <property name="dataSource" ref="dataSource"/>
           <!-- 配置MyBaties全局配置文件:mybatis-config.xml -->
           <property name="configLocation" value="classpath:mybatis-config.xml"/>
       </bean>
       <!-- 4.配置扫描Dao接口包，动态实现Dao接口注入到spring容器中 -->
       <!--解释 ：https://www.cnblogs.com/jpfss/p/7799806.html-->
       <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
           <!-- 注入sqlSessionFactory -->
           <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
           <!-- 给出需要扫描Dao接口包 -->
           <property name="basePackage" value="com.yjy.dao"/>
       </bean>
   </beans>
   ```

3. Spring整合service层

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd">
   
       <!-- 扫描service相关的bean -->
       <context:component-scan base-package="com.yjy.service" />
   
       <!--BookServiceImpl注入到IOC容器中-->
       <bean id="BookServiceImpl" class="com.yjy.service.BookServiceImpl">
           <property name="bookMapper" ref="bookMapper"/>
       </bean>
       <!-- 配置事务管理器 -->
       <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
           <!-- 注入数据库连接池 -->
           <property name="dataSource" ref="dataSource" />
       </bean>
   </beans>
   ```



### 11.3、SpringMVC层

1. 配置web.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
            version="4.0">
   
     <!--DispatcherServlet-->
     <servlet>
       <servlet-name>DispatcherServlet</servlet-name>
       <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
       <init-param>
         <param-name>contextConfigLocation</param-name>
         <!--一定要注意:我们这里加载的是总的配置文件，之前被这里坑了！-->
         <param-value>classpath:applicationContext.xml</param-value>
       </init-param>
       <load-on-startup>1</load-on-startup>
     </servlet>
     <servlet-mapping>
       <servlet-name>DispatcherServlet</servlet-name>
       <url-pattern>/</url-pattern>
     </servlet-mapping>
     <!--encodingFilter-->
     <filter>
       <filter-name>encodingFilter</filter-name>
       <filter-class>
         org.springframework.web.filter.CharacterEncodingFilter
       </filter-class>
       <init-param>
         <param-name>encoding</param-name>
         <param-value>utf-8</param-value>
       </init-param>
     </filter>
     <filter-mapping>
       <filter-name>encodingFilter</filter-name>
       <url-pattern>/*</url-pattern>
     </filter-mapping>
   
     <!--Session过期时间-->
     <session-config>
       <session-timeout>15</session-timeout>
     </session-config>
   
   </web-app>
   ```

2. 配置spring-mvc.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xmlns:mvc="http://www.springframework.org/schema/mvc"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc
       https://www.springframework.org/schema/mvc/spring-mvc.xsd">
   
       <!-- 配置SpringMVC -->
       <!-- 1.开启SpringMVC注解驱动 -->
       <mvc:annotation-driven />
       <!-- 2.静态资源默认servlet配置-->
       <mvc:default-servlet-handler/>
   
       <!-- 3.配置jsp 显示ViewResolver视图解析器 -->
       <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
           <property name="viewClass" value="org.springframework.web.servlet.view.JstlView" />
           <property name="prefix" value="/WEB-INF/jsp/" />
           <property name="suffix" value=".jsp" />
       </bean>
       <!-- 4.扫描web相关的bean -->
       <context:component-scan base-package="com.yjy.controller" />
   </beans>
   ```

3. Spring配置整合文件，applicationContext.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd">
   
       <import resource="spring/spring-dao.xml"/>
       <import resource="spring/spring-service.xml"/>
       <import resource="spring/spring-mvc.xml"/>
   
   </beans>
   ```

4. 编写Controller类以及jsp页面

   首页：index.jsp

   ```jsp
   <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   <!DOCTYPE HTML>
   <html>
   <head>
       <title>首页</title>
       <style type="text/css">
           a {
               text-decoration: none;
               color: black;
               font-size: 18px;
           }
           h3 {
               width: 180px;
               height: 38px;
               margin: 100px auto;
               text-align: center;
               line-height: 38px;
               background: deepskyblue;
               border-radius: 4px;
           }
       </style>
   </head>
   <body>
   
   <h3>
       <a href="${pageContext.request.contextPath}/book/allBook">点击进入列表页</a>
   </h3>
   </body>
   </html>
   ```

   书籍列表页面：allbook.jsp

   ```jsp
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   <html>
   <head>
       <title>书籍列表</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
   </head>
   <body>
   
   <div class="container">
       <div class="row clearfix">
           <div class="col-md-12 column">
               <div class="page-header">
                   <h1>
                       <small>书籍列表 —— 显示所有书籍</small>
                   </h1>
               </div>
           </div>
       </div>
       <div class="row">
           <div class="col-md-4 column">
               <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/toAddBook">新增</a>
           </div>
       </div>
       <div class="row clearfix">
           <div class="col-md-12 column">
               <table class="table table-hover table-striped">
                   <thead>
                   <tr>
                       <th>书籍编号</th>
                       <th>书籍名字</th>
                       <th>书籍数量</th>
                       <th>书籍详情</th>
                       <th>操作</th>
                   </tr>
                   </thead>
                   <tbody>
                   <c:forEach var="book" items="${requestScope.get('list')}">
                       <tr>
                           <td>${book.getBookID()}</td>
                           <td>${book.getBookName()}</td>
                           <td>${book.getBookCounts()}</td>
                           <td>${book.getDetail()}</td>
                           <td>
                               <a href="${pageContext.request.contextPath}/book/toUpdateBook?id=${book.getBookID()}">更改</a> |
                               <a href="${pageContext.request.contextPath}/book/del/${book.getBookID()}">删除</a>
                           </td>
                       </tr>
                   </c:forEach>
                   </tbody>
               </table>
           </div>
       </div>
   </div>
   
   </body>
   </html>
   ```

   添加书籍页面：addBook.jsp

   ```jsp
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   
   <html>
   <head>
       <title>新增书籍</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
   </head>
   <body>
   <div class="container">
       <div class="row clearfix">
           <div class="col-md-12 column">
               <div class="page-header">
                   <h1>
                       <small>新增书籍</small>
                   </h1>
               </div>
           </div>
       </div>
       <form action="${pageContext.request.contextPath}/book/addBook" method="post">
           书籍名称：<input type="text" name="bookName"><br><br><br>
           书籍数量：<input type="text" name="bookCounts"><br><br><br>
           书籍详情：<input type="text" name="detail"><br><br><br>
           <input type="submit" value="添加">
       </form>
   </div>
   
   </body>
   </html>
   ```

   更新书籍页面：updateBook.jsp

   ```jsp
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   <html>
   <head>
       <title>修改信息</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
   </head>
   <body>
   <div class="container">
       <div class="row clearfix">
           <div class="col-md-12 column">
               <div class="page-header">
                   <h1>
                       <small>修改信息</small>
                   </h1>
               </div>
           </div>
       </div>
       <form action="${pageContext.request.contextPath}/book/updateBook" method="post">
           <input type="hidden" name="bookID" value="${book.getBookID()}"/>
           书籍名称：<input type="text" name="bookName" value="${book.getBookName()}"/>
           书籍数量：<input type="text" name="bookCounts" value="${book.getBookCounts()}"/>
           书籍详情：<input type="text" name="detail" value="${book.getDetail() }"/>
           <input type="submit" value="提交"/>
       </form>
   </div>
   
   </body>
   </html>
   ```

   Controller类：

   ```java
   @Controller
   @RequestMapping("/book")
   public class BooksController {
   
       @Autowired
       private BookService bookService;
   
       //跳转到书籍列表界面
       @GetMapping("/allBook")
       public String list(Model model) {
           List<Books> list = bookService.queryAllBooks();
           model.addAttribute("list",list);
           return "allbook";
       }
   
       //跳转到添加书籍页面
       @GetMapping("/toAddBook")
       public String toAddBook() {
           return "addBook";
       }
   
       //添加书籍，并重定向到书籍列表页面
       @PostMapping("/addBook")
       public String addBook(Books books) {
           System.out.println(books);
           bookService.addBook(books);
           return "redirect:/book/allBook";
       }
   
       //跳转到更新书籍页面
       @GetMapping("/toUpdateBook")
       public String toUpdateBook(@RequestParam("id") int id, Model model) {
           Books book = bookService.queryBookById(id);
           model.addAttribute("book",book);
           return "updateBook";
       }
   
       //更新书籍，并重定向到书籍列表页面
       @PostMapping("/updateBook")
       public String updateBook(Books book) {
           System.out.println(book);
           bookService.updateBook(book);
           return "redirect:/book/allBook";
       }
   
       //删除数据
       @GetMapping("/del/{bookID}")
       public String deleteBook(@PathVariable("bookID") int id) {
           bookService.deleteBookById(id);
           return "redirect:/book/allBook";
       }
   }
   ```

5. 配置Tomcat，进行运行！



**项目结构：**

![image-20201010141259180](D:\Typora-photos\SpringMVC\image-20201010141259180.png)



## 12、Ajax

### 12.1、简介

- **AJAX = Asynchronous JavaScript and XML（异步的 JavaScript 和 XML）。**
- AJAX 是一种在无需重新加载整个网页的情况下，能够更新部分网页的技术。
- **Ajax 不是一种新的编程语言，而是一种用于创建更好更快以及交互性更强的Web应用程序的技术。**
- 在 2005 年，Google 通过其 Google Suggest 使 AJAX 变得流行起来。Google Suggest能够自动帮你完成搜索单词。
- Google Suggest 使用 AJAX 创造出动态性极强的 web 界面：当您在谷歌的搜索框输入关键字时，JavaScript 会把这些字符发送到服务器，然后服务器会返回一个搜索建议的列表。
- 就和国内百度的搜索框一样!

- 传统的网页(即不用ajax技术的网页)，想要更新内容或者提交一个表单，都需要重新加载整个网页。
- 使用ajax技术的网页，通过在后台服务器进行少量的数据交换，就可以实现异步局部更新。
- 使用Ajax，用户可以创建接近本地桌面应用的直接、高可用、更丰富、更动态的Web用户界面。



### 12.2、伪造Ajax

我们可以使用前端的一个标签来伪造一个ajax的样子。iframe标签

1. 创建一个新的web项目

2. 编写一个ajax-frame.html 使用 iframe 测试，感受下效果

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <title>Title</title>
       <script type="text/javascript">
   
           window.onload = function(){
               var myDate = new Date();
               document.getElementById('currentTime').innerText = myDate.getTime();
           };
        
           function LoadPage(){
               var targetUrl =  document.getElementById('url').value;
               console.log(targetUrl);
               document.getElementById("iframePosition").src = targetUrl;
           }
   
       </script>
   </head>
   <body>
   
       <div>
           <p>请输入要加载的地址：<span id="currentTime"></span></p>
           <p>
               <input id="url" type="text" value="https://www.baidu.com/"/>
               <input type="button" value="提交" onclick="LoadPage()">
           </p>
       </div>
   
       <div>
           <h3>加载页面位置：</h3>
           <iframe id="iframePosition" style="width: 100%;height: 500px;"></iframe>
       </div>
   
   </body>
   </html>
   ```

3. 测试



常用场景：

- 注册时，输入用户名自动检测用户是否已经存在。
- 登陆时，提示用户名密码错误
- 删除数据行时，将行ID发送到后台，后台在数据库中删除，数据库删除成功后，在页面DOM中将数据行也删除。
- ....等等



### 12.3、jQuery

Ajax的核心是XMLHttpRequest对象(XHR)。XHR为向服务器发送请求和解析服务器响应提供了接口。能够以异步方式从服务器获取新数据。

jQuery 提供多个与 AJAX 有关的方法。

通过 jQuery AJAX 方法，您能够使用 HTTP Get 和 HTTP Post 从远程服务器上请求文本、HTML、XML 或 JSON – 同时您能够把这些外部数据直接载入网页的被选元素中。

jQuery 不是生产者，而是大自然搬运工。

jQuery Ajax本质就是 XMLHttpRequest，对他进行了封装，方便调用！

```js
jQuery.ajax(...)
       部分参数：
              url：请求地址
             type：请求方式，GET、POST（1.9.0之后用method）
          headers：请求头
             data：要发送的数据
      contentType：即将发送信息至服务器的内容编码类型(默认: "application/x-www-form-urlencoded; charset=UTF-8")
            async：是否异步
          timeout：设置请求超时时间（毫秒）
       beforeSend：发送请求前执行的函数(全局)
         complete：完成之后执行的回调函数(全局)
          success：成功之后执行的回调函数(全局)
            error：失败之后执行的回调函数(全局)
          accepts：通过请求头发送给服务器，告诉服务器当前客户端可接受的数据类型
         dataType：将服务器端返回的数据转换成指定类型
            "xml": 将服务器端返回的内容转换成xml格式
           "text": 将服务器端返回的内容转换成普通文本格式
           "html": 将服务器端返回的内容转换成普通文本格式，在插入DOM中时，如果包含JavaScript标签，则会尝试去执行。
         "script": 尝试将返回值当作JavaScript去执行，然后再将服务器端返回的内容转换成普通文本格式
           "json": 将服务器端返回的内容转换成相应的JavaScript对象
          "jsonp": JSONP 格式使用 JSONP 形式调用函数时，如 "myurl?callback=?" jQuery 将自动替换 ? 为正确的函数名，以执行回调函数
```



> 测试

1. 配置web.xml 和 springmvc的配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xmlns:mvc="http://www.springframework.org/schema/mvc"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans.xsd
          http://www.springframework.org/schema/context
          https://www.springframework.org/schema/context/spring-context.xsd
          http://www.springframework.org/schema/mvc
          https://www.springframework.org/schema/mvc/spring-mvc.xsd">
   
       <!-- 自动扫描指定的包，下面所有注解类交给IOC容器管理 -->
       <context:component-scan base-package="com.yjy.controller"/>
       <mvc:default-servlet-handler />
       <mvc:annotation-driven>
           <mvc:message-converters register-defaults="true">
               <bean class="org.springframework.http.converter.StringHttpMessageConverter">
                   <constructor-arg value="UTF-8"/>
               </bean>
               <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
                   <property name="objectMapper">
                       <bean class="org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean">
                           <property name="failOnEmptyBeans" value="false"/>
                       </bean>
                   </property>
               </bean>
           </mvc:message-converters>
       </mvc:annotation-driven>
   
       <!-- 视图解析器 -->
       <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"
             id="internalResourceViewResolver">
           <!-- 前缀 -->
           <property name="prefix" value="/WEB-INF/jsp/" />
           <!-- 后缀 -->
           <property name="suffix" value=".jsp" />
       </bean>
   
   </beans>
   ```

2. 编写一个AjaxController

   ```java
   @Controller
   public class AjaxController {
   
       @RequestMapping("/a1")
       public void ajax1(String name, HttpServletResponse response) throws IOException {
           if ("admin".equals(name)) {
               response.getWriter().print(true);
           }else {
               response.getWriter().print(false);
           }
       }
   }
   ```

3. 导入jquery ， 可以使用在线的CDN ， 也可以下载导入

   ```jsp
   <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
   <script src="${pageContext.request.contextPath}/statics/js/jquery-3.5.1.js"></script>
   ```

4. 编写index.jsp

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>Title</title>
       <script src="${pageContext.request.contextPath}/statics/js/jquery-3.5.1.js"></script>
       <script>
           function a1(){
               $.post({
                   url:"${pageContext.request.contextPath}/a1",
                   data:{'name':$("#textName").val()},
                   success:function (data,status){
                       alert(data);
                       alert(status);
                   }
               })
           }
       </script>
   </head>
   <body>
       <%--onblur：失去焦点触发事件--%>
         用户名:<input type="text" id="textName" onblur="a1()"/>
   </body>
   </html>
   ```

5. 测试



### 12.4、Springmvc实现

1. 导入jackson依赖（必须为jackson）

   ```xml
   <dependency>
       <groupId>com.fasterxml.jackson.core</groupId>
       <artifactId>jackson-databind</artifactId>
       <version>2.11.3</version>
   </dependency>
   ```

2. 编写实体类

   ```java
   public class User {
   
       private String name;
       private int age;
       private String sex;
   
       public User() {
       }
   
       public User(String name, int age, String sex) {
           this.name = name;
           this.age = age;
           this.sex = sex;
       }
   
       public String getName() {
           return name;
       }
   
       public void setName(String name) {
           this.name = name;
       }
   
       public int getAge() {
           return age;
       }
   
       public void setAge(int age) {
           this.age = age;
       }
   
       public String getSex() {
           return sex;
       }
   
       public void setSex(String sex) {
           this.sex = sex;
       }
   
       @Override
       public String toString() {
           return "User{" +
                   "name='" + name + '\'' +
                   ", age=" + age +
                   ", sex='" + sex + '\'' +
                   '}';
       }
   }
   ```

3. 编写controller

   ```java
   @RequestMapping("/a2")
       public List<User> ajax2() {
           List<User> list = new ArrayList<>();
           list.add(new User("小狂神1号",3,"男"));
           list.add(new User("小狂神2号",1,"女"));
           list.add(new User("小狂神3号",2,"男"));
           return list;    //由于@RestController注解，自动将list转成json格式返回,但是需要导入jackson依赖
       }
   ```

4. 编写前端页面

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>Title</title>
       <script src="${pageContext.request.contextPath}/statics/js/jquery-3.5.1.js"></script>
       <script>
           $(function (){
               $("#btn").click(function () {
                   $.post({
                       url:"${pageContext.request.contextPath}/a2",
                       success:function (data) {
                           console.log(data)
                           var html = "";
                           for (var i=0; i<data.length; i++) {
                               html+= "<tr>" +
                               "<td>" + data[i].name + "</td>" +
                               "<td>" + data[i].age + "</td>" +
                               "<td>" + data[i].sex + "</td>" +
                               "</tr>"
                           }
                           $("#content").html(html);
                       }
                   });
               })
           })
       </script>
   </head>
   <body>
       <input type="button" id="btn" value="获取数据"/>
       <table width="80%" align="center">
           <tr>
               <td>姓名</td>
               <td>年龄</td>
               <td>性别</td>
           </tr>
           <tbody id="content">
           </tbody>
       </table>
   </body>
   </html>
   ```

5. 测试



> 注册提示效果

1. 编写controller

   ```java
   @RequestMapping("/a3")
   public String ajax3(String name, String password) {
       String msg = "";
       //模拟数据库中的数据
       if (name!=null) {
           if (name.equals("admin")) {
               msg = "用户已存在";
           }else if (name.equals("")){
               msg = "用户名不能为空";
           }else{
               msg = "OK";
           }
       }
   
       if (password!=null) {
           if (password.equals("123456")) {
               msg = "OK";
           }else if (password.equals("")){
               msg = "密码不能为空";
           }else {
               msg = "两次密码不一致";
           }
       }
   
       return msg; //由于@RestController注解，自动将list转成json格式返回,但是需要导入jackson依赖
   }
   ```

2. 编写注册页

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>Title</title>
       <script src="${pageContext.request.contextPath}/statics/js/jquery-3.5.1.js"></script>
   
       <script>
           function a1() {
               $.post({
                   url:"${pageContext.request.contextPath}/a3",
                   data:{'name':$("#name").val()},
                   success:function (data) {
                       if (data.toString()=='OK') {
                           $("#userInfo").css("color","green");
                       }else {
                           $("#userInfo").css("color","red");
                       }
                       $("#userInfo").html(data);
                   }
               })
           }
   
           function a2() {
                       $.post({
                           url:"${pageContext.request.contextPath}/a3",
                           data:{'password':$("#password").val()},
                           success:function (data) {
                               if (data.toString()=='OK') {
                                   $("#pwdInfo").css("color","green");
                               }else {
                                   $("#pwdInfo").css("color","red");
                               }
                               $("#pwdInfo").html(data);
                           }
                       })
                   }
   
       </script>
   </head>
   <body>
       <p>
           用户名:<input type="text" id="name" onblur="a1()"/>
           <span id="userInfo"></span>
       </p>
       <p>
           密码:<input type="text" id="password" onblur="a2()"/>
           <span id="pwdInfo"></span>
       </p>
   </body>
   </html>
   ```

3. 测试



## 13、拦截器（Interceptor）

### 13.1、什么是拦截器

- 拦截器是SpringMVC框架自己的，只有使用了SpringMVC框架的工程才能使用
- 拦截器只会拦截访问的控制器方法， 如果访问的是jsp/html/css/image/js是不会进行拦截的



### 13.2、自定义拦截器

想要自定义拦截器，必须实现HandlerInterceptor接口。

1. 创建一个新的web项目

2. 配置web.xml 和 spring-mvc.xml 文件

3. 编写拦截器

   ```java
   public class MyInterceptor implements HandlerInterceptor {
   
       //在请求处理的方法之前执行
       //如果返回true执行下一个拦截器
       //如果返回false就不执行下一个拦截器
       @Override
       public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
           System.out.println("===================处理前==================");
           return true;
       }
   
       @Override
       public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
           System.out.println("===================执行后==================");
       }
   
       @Override
       public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
           System.out.println("===================清理==================");
       }
   }
   ```

4. 在spring-mvc.xml中配置拦截器

   ```xml
   <!--配置拦截器-->
   <mvc:interceptors>
       <mvc:interceptor>
           <!--/** 包括路径及其子路径-->
           <!--/admin/* 拦截的是/admin/add等等这种 , /admin/add/user不会被拦截-->
           <!--/admin/** 拦截的是/admin/下的所有-->
           <mvc:mapping path="/**"/>
           <!--bean配置的就是拦截器-->
           <bean class="com.yjy.interceptor.MyInterceptor"/>
       </mvc:interceptor>
   </mvc:interceptors>
   ```

5. 编写Controller

   ```java
   @Controller
   public class InterceptorController {
   
       @RequestMapping("/interceptor")
       @ResponseBody
       public String interceptor() {
           System.out.println("控制器中的方法执行了");
           return "hello";
       }
   }
   ```

6. 编写前端

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>Title</title>
   </head>
   <body>
       <a href="${pageContext.request.contextPath}/interceptor">拦截器测试</a>
   </body>
   </html>
   ```

7. 配置Tomcat，运行测试



> 登录拦截器

实现要求：

1. 有一个内容页面以及一个登录页面
2. 用户需要登录页面之后才能访问内容页面，如果没有登录，直接访问内容页面，则跳转到登录页面



> 测试

1. 编写一个登录页面

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>登录页面</title>
   </head>
   <body>
       <form action="${pageContext.request.contextPath}/user/login" method="post">
           用户名: <input type="text" name="username"/> <br>
           密码： <input type="password" name="password"/> <br>
           <input type="submit" value="登录"/>
       </form>
   </body>
   </html>
   ```

2. 编写一个Controller处理请求

   ```java
   @Controller
   @RequestMapping("/user")
   public class LoginController {
   
       //跳转到登录页面
       @GetMapping("/toLogin")
       public String toLogin() {
           return "login";
       }
   
       //跳转到成功页面
       @GetMapping("/toSuccess")
       public String toSuccess() {
           return "success";
       }
   
       //登录提交
       @PostMapping("/login")
       public String login(@RequestParam("username") String username, @RequestParam("password") String password, HttpSession session) {
           if (username!=null && username.equals("admin") && password!=null && password.equals("123456")) {
               session.setAttribute("user",username);
               return "redirect:/user/toSuccess";
           }else {
               return "redirect:/user/toLogin";
           }
       }
   
       //注销登录
       @GetMapping("/logout")
       public String logout(HttpSession session) {
           session.removeAttribute("user");
           return "login";
       }
   }
   ```

3. 编写一个内容页面

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>内容页面</title>
   </head>
   <body>
   
       <h1>登录成功页面</h1>
       <hr>
   
       <a href="${pageContext.request.contextPath}/user/logout">注销</a>
   </body>
   </html>
   ```

4. 在主页设置两个链接，一个进入内容页面，一个进入登录页面

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java"%>
   <html>
   <head>
       <title>Title</title>
   </head>
   <body>
       <%--<a href="${pageContext.request.contextPath}/interceptor">拦截器测试</a>--%>
   
       <a href="${pageContext.request.contextPath}/user/toLogin">登录页面</a>
       <a href="${pageContext.request.contextPath}/user/toSuccess">内容页面</a>
   </body>
   </html>
   ```

5. 编写拦截器

   ```java
   public class LoginInterceptor implements HandlerInterceptor {
   
       @Override
       public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
           System.out.println("uri:" + request.getRequestURI());
           if (request.getRequestURI().contains("/toLogin") || request.getRequestURI().contains("/login")) {
               return true;
           }
   
           if (request.getSession().getAttribute("user")!=null) {
               return true;
           }else {
               request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request,response);
               return false;
           }
       }
   }
   ```

6. 配置拦截器

   ```xml
   <!--配置拦截器-->
   <mvc:interceptors>
       <mvc:interceptor>
           <mvc:mapping path="/user/**"/>
           <bean class="com.yjy.interceptor.LoginInterceptor"/>
       </mvc:interceptor>
   </mvc:interceptors>
   ```

7. 测试













