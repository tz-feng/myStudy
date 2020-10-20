# 对象在内存中的存储布局

## 对象的存储布局

![image-20200904135730014](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904135730014.png)

markword：存放关于锁的信息和GC标记信息（8个字节）。

class pointer：指向对应的Class对象（4个字节）。

instance data：存放成员变量，每个成员变量占4个字节。

padding：当整体的字节数不能被8整除时，padding会自动补齐。

对象的头部：markword + class pointer 



## 通过JOL包查看对象的内存布局

pom.xml

```xml
<dependency>
    <groupId>org.openjdk.jol</groupId>
    <artifactId>jol-core</artifactId>
    <version>0.13</version>
</dependency>
```

测试类

```java
public static void main(String[] args) {
        Object o = new Object();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
    }
```

结果：

![image-20200904141455003](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904141455003.png)



## 查看JVM默认自带的参数

![image-20200904141819886](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904141819886.png)

InitialHeapSize：初始堆大小。

MaxHeapSize：最大堆大小。

UseCompressedClassPointers：对ClassPointers进行压缩，系统是64位，默认是8个字节，由于进行压缩，所以变位4个字节。

UseCompressedOops：对Oop进行压缩（Oop：普通对象指针，即成员变量的指针），默认是8个字节，由于进行压缩，所以变位4个字节。



## 常问的面试题

==Object o = new Object() 在内存中占用多少个字节？==

答案：16个。

分析：首先markword占8个字节，然后由于开启了UseCompressedClassPointers，所以class pointer占4个字节，没有成员变量，所以0个字节。8+4=12，不能被8整除，所以padding占有4个字节进行补齐。所以最终为16个。

==问：如果不开启压缩呢？==

答案：还是16个。

分析：首先markword占8个字节，然后由于没开启UseCompressedClassPointers，所以class pointer占个字节，没有成员变量，所以0个字节。8+8=16，能被8整除，不需要padding补齐。所以最终为16个。



举一反三：

==假设一个User对象，里面有两个变量int age 和 String name，问User user = new User() 在内存中占用多少个字节？==

答案：24个。

分析：首先markword占8个字节，然后由于开启了UseCompressedClassPointers 和 UseCompressedOops，所以class pointer占4个字节，有两个成员变量，每个占4个字节，所以占用了8个字节。8+4+8=20，不能被8整除，所以padding占有4个字节进行补齐。所以最终为24个。

通过JOL来查看一下：

![image-20200904144027286](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904144027286.png)



# Synchronized的横切面详解

## markword结构图

![image-20200904145311525](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904145311525.png)

分代年龄：记录了经过多少次GC回收之后仍然被留下来。

由图可知：GC回收，从年轻带转移到老年带最多只能经历15次，因为只有4个bit。

hashCode：只有对他hashCode方法进行了调用之后才会被存储到里头，如果没有进行调用，里面是没有值的。



> 测试

测试类

```java
public static void main(String[] args) {
        Object o = new Object();
        //User user = new User();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());

        System.out.println(o.hashCode());
        System.out.println("调用hashCode方法后");
        System.out.println(ClassLayout.parseInstance(o).toPrintable());

        synchronized (o) {
            System.out.println("上锁后");
            System.out.println(ClassLayout.parseInstance(o).toPrintable());
        }
    }
```

结果

![image-20200904161204029](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904161204029.png)



1. 无锁态：即`Object o = new Object();`

   锁 = 001

   ![image-20200904161426866](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904161426866.png)

   **打印出来的结果对应的64位如下：**

   ```markdown
   (50-64 49-56 41-48 33-40)
   (25-32 17-24 9-16 1-8)
   ```

   

2. 调用hashCode方法

   001 + hashCode

   ![image-20200904162239908](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904162239908.png)

3. 偏向锁

   00

   ![image-20200904162447251](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/JVM/image-20200904162447251.png)