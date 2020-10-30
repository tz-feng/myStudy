# 1、集合类的简介

## 1.1、什么是集合类

集合类是Java数据结构的实现。Java的集合类是java.util包中的重要内容，它允许以各种方式将元素分组，并定义了各种使这些元素更容易操作的方法。可以往里面保存多个对象的类，**==存放的是对象==**，不同的集合类有不同的功能和特点，适合不同的场合，用以解决一些实际问题。



## 1.2、集合的分类

Java中的集合类可以分为两大类：**一类是实现Collection接口；另一类是实现Map接口**。

Collection是一个基本的集合接口，Collection中可以容纳一组集合元素（Element）。

Map没有继承Collection接口，与Collection是并列关系。Map提供键（key）到值（value）的映射。一个Map中不能包含相同的键，每个键只能映射一个值。



### 1.2.1、Collection接口

Collection有两个重要的子接口List和Set。List表达一个有序的集合，List中的每个元素都有索引，使用此接口能够准确的控制每个元素插入的位置。用户也能够使用索引来访问List中的元素，List类似于Java的数组。Set集合注重独一无二的性质,该体系集合可以知道某物是否已存在于集合中，不会存储重复的元素，用于存储无序(存入和取出的顺序不一定相同)元素，值不能重复。

Collection接口、List接口、Set接口以及相关类的关系：

![image-20201026160243249](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/java集合/image-20201026160243249.png)



### 1.2.2、Map接口

Map（也称为字典、关联数组）是用于保存具有映射关系的数据，保存两组值，key和value，这两组值可以是任何应用类型的数据。

Map的key不允许重复（底层Map的keySet()返回的是key的Set集合，所以key不会重复），即Map中对象的任意两个key通过equals()方法得到的都是false。而Map的value值是可以重复的（Map的底层values()方法返回类型是Collection，可以存储重复元素），通过key总能找到唯一的value，Map中的key组成一个Set集合，所以可以通过keySet()方法返回所有key。Set底层也是通过Map实现的，只不过value都是null的Map来实现的

![image-20201026183510509](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/java集合/image-20201026183510509.png)



## 1.3、常用的集合类

List下有ArrayList，LinkedList，Vector

Set下有HashSet，LinkedHashSet，TreeSet

Map下有HashMap，LinkedHashMap， TreeMap，Hashtable



# 2、List集合

## 2.1、ArrayList

### 2.1.1、简介

`ArrayList`是List使用中最常用的实现类，它的查询速度快，效率高，但增删慢，线程不安全。`ArrayList`实现了Serializable接口，因此它支持序列化，能够通过序列化传输，实现了`RandomAccess`接口，支持快速随机访问，实际上就是通过下标序号进行快速访问，实现了Cloneable接口，能被克隆。



### 2.1.2、实现原理

`ArrayList`底层实现采用的数据结构是数组，并且数组默认大小为10。



### 2.1.3、扩容机制

- jdk1.8的扩容算法：

  ```java
  newCapacity = oldCapacity + ( oldCapacity >> 1 );
  ```

  `oldCapacity >> 1`是移位运算，相当于`oldCapacity`除以2，但是>>的效率更高。

- jdk1.6的扩容算法：

  ```java
  newCapacity = ( oldCapacity * 3 ) / 2 +1 。
  ```



## 2.2、Vector

### 2.2.1、简介

`Vector`的底层也是通过数组实现的，默认大小也是10。主要特点：查询快，增删慢 ，线程安全，但是效率低。



### 2.2.2、实现原理

创建对象与`ArrayList`类似，但有一点不同，它可以设置扩容是容量增长大小。
Vector的三个构造器：

```java
//无参构造
public Vector() {
        this(10);
}

//设置vevtor的容量大小
public Vector(int initialCapacity) {
        this(initialCapacity, 0);
}

//设置vevtor的容量大小以及溢出时的增量
public Vector(int initialCapacity, int capacityIncrement) {
        super();
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal Capacity: "+
                                               initialCapacity);
        this.elementData = new Object[initialCapacity];
        this.capacityIncrement = capacityIncrement;
}
```


其实前两种构造器最后还是要用到第三个构造器，所以new Vector(); 与 new Vector(10);与 new Vector(10,0); 三个是等同的。



### 2.2.3、扩容机制

- jdk1.8的扩容算法：

  ```java
  newCapacity = oldCapacity + ( ( capacityIncrement > 0 ) ? capacityIncrement : oldCapacity );
  ```

  如果增量值大于0，那么扩容时直接加上增量的大小；如果不大于0，那么让原容量乘以2。

- jdk1.6的扩容算法：

  ```java
  newCapacity = ( capacityIncrement > 0 ) ? ( oldCapacity + capacityIncrement ) : (  oldCapacity  * 2 );
  ```

1.6与1.8的写法变化不大，但是仔细一分析，就会发现jdk1.6中有使用乘法运算，即 `oldCapacity  * 2`。 在jdk1.8中换成了加法运算，这是因为乘法的效率是低于加法的，这也是算法的优化。



## 2.3、LinkedList

### 2.3.1、简介

`LinkedList`是一个继承于`AbstractSequentialList`的双向链表。它也可以被当作堆栈、队列或双端队列进行操作。它增删快，效率高，但是查询慢，线程不安全。



### 2.3.2、实现原理

`LinkedList`的底层实现是链表，所以没有容量大小的定义，只有上个节点，当前节点，下个节点，每个节点都有一个上级节点和一个下级节点。



# 3、Set集合

## 3.1、HashSet

### 3.1.1、简介

`HashSet`实现的是Set接口。存储元素的顺序并不是按照存入时的顺序（和List显然不同） 是按照哈希值来存的所以取数据也是按照哈希值取得。`HashSet`中存放的值是唯一的，他只能存放对象。它的底层是由`HashMap`实现的，它的对象存放在key中，value值统一为PERSENT。线程不安全。



### 3.1.2、实现原理

构造方法：

```java
private transient HashMap<E,Object> map;
//默认构造器
public HashSet() {
    map = new HashMap<>();
}
//将传入的集合添加到HashSet的构造器
public HashSet(Collection<? extends E> c) {
    map = new HashMap<>(Math.max((int) (c.size()/.75f) + 1, 16));
    addAll(c);
}
//明确初始容量和装载因子的构造器
public HashSet(int initialCapacity, float loadFactor) {
    map = new HashMap<>(initialCapacity, loadFactor);
}
//仅明确初始容量的构造器（装载因子默认0.75）
public HashSet(int initialCapacity) {
    map = new HashMap<>(initialCapacity);
}
```

从源码可以得知：`HashSet`的底层是通过`HashMap`实现的。`HashMap`的数据存储是通过数组+链表/红黑树实现的。



`HashSet`如何检查重复?

它是通过`hashCode`和`equals`两个方法进行判断。首先通过对象的`hashCode`方法进行比较，如果相等，再用equals方法进行比较。如果equals方法为true，那么说明该对象已存在数组中。如果`hashCode`方法相等，但`equals`方法为false，那么在数组的位置以链表的形式进行存储。



## 3.2、TreeSet

### 3.2.1、简介

`TreeSet`是一个有序的集合，它的作用是提供有序的Set集合。`TreeSet`是基于`TreeMap`实现的。`TreeSet`中的元素支持2种排序方式：**自然排序** 或者 根据创建`TreeSet`时，提供的 **Comparator** 进行排序。这取决于使用的构造方法。`TreeSet`是非同步的。 它的iterator 方法返回的迭代器是fail-fast的。`TreeSet`是一个**有序且不重复**的集合。



### 3.2.2、实现原理

构造方法：

```java
public class TreeSet<E> extends AbstractSet<E>
    implements NavigableSet<E>, Cloneable, java.io.Serializable
{
	public TreeSet() {
        this(new TreeMap<E,Object>());
    }
    public TreeSet(Comparator<? super E> comparator) {
        this(new TreeMap<>(comparator));
    }
    public TreeSet(Collection<? extends E> c) {
        this();
        addAll(c);
    }
    public TreeSet(SortedSet<E> s) {
        this(s.comparator());
        addAll(s);
    }
}
```

由此可见：`TreeSet`的底层是由`TreeMap`实现的，由于`TreeMap`的数据结构是红黑树，因此`TreeSet`的数据结构也是红黑树。



### 3.2.3、两种排序

- 自然排序

  `TreeSet`会调用集合元素的`compareTo(Object obj)`方法来比较元素之间的大小关系，然后将集合元素按升序排列，这种方式就是自然排序。

  当一个对象调用该方法与另一个对象进行比较时，如：`obj1.compareTo(obj2)`，如果该方法返回0，说明两者相等；如果返回时一个正数，说明obj1 > obj2；如果返回一个负数，表明 obj1< obj2

- 定制排序

  当元素自身不具备比较性，或者自身具备的比较性不是所需要的，那么此时可以让容器自身具备。需要定义一个类实现Comparator，重写compare方法，并将该接口的实现类作为参数传递给`TreeMap`集合构造方法。

  当Comparable比较方式和Comparator比较方式同时存在时，以Comparator的比较方式为主。在重写compareTo或者compare方法时，必须要明确比较的主要条件相等时要比较的次要条件。



## 3.3、LinkedHashSet

### 3.3.1、简介

`LinkedHashSet`继承`HashSet`类。`LinkedHashSet`的底层使用`LinkedHashMap`存储元素。`LinkedHashSet`是有序的，它是按照插入的顺序排序的。



### 3.3.2、实现原理

父类构造方法：

```java
HashSet(int initialCapacity, float loadFactor, boolean dummy) {
    map = new LinkedHashMap<>(initialCapacity, loadFactor);
}
```

其构造方法：

```java
public class LinkedHashSet<E>
    extends HashSet<E>
    implements Set<E>, Cloneable, java.io.Serializable 
{
    
 	public LinkedHashSet(int initialCapacity, float loadFactor) {
        super(initialCapacity, loadFactor, true);
    }

    public LinkedHashSet(int initialCapacity) {
        super(initialCapacity, .75f, true);
    }

    public LinkedHashSet() {
        super(16, .75f, true);
    }

    public LinkedHashSet(Collection<? extends E> c) {
        super(Math.max(2*c.size(), 11), .75f, true);
        addAll(c);
    }

    public Spliterator<E> spliterator() {
        return Spliterators.spliterator(this, Spliterator.DISTINCT | Spliterator.ORDERED);
    }
}
```

由此可见：`LinkedHashSet`的底层使用`LinkedHashMap`存储元素。



`LinkedHashSet`为什么不支持访问顺序对元素排序？

```java
public LinkedHashMap(int initialCapacity, float loadFactor) {
    super(initialCapacity, loadFactor);
    accessOrder = false;
}
```

首先，`LinkedHashSet`所有的构造方法都是调用`HashSet`的同一个构造方法，他们的map都是一个利用`LinkedHashMap<>(initialCapacity, loadFactor)`进行实例化。而该构造方法中的`accessOrder`写死为false了。所以`LinkedHashSet`是不支持按访问顺序对元素排序的，只能按插入顺序排序。



# 4、Map集合

## 4.1、HashMap

### 4.1.1、简介

`HashMap`继承`AbstractMap`类。`HashMap`底层是数组和链表的结合体。底层是一个线性数组结构，数组中的每一项又是一个链表。`HashMap`是非同步的，线程不安全。保存的数据key和value都可以为`unll`。`HashMap`底层数组的长度是2^n，默认是16,负载因子为0.75，所以最大容量阈值`threshold = (int)(capacity * loadFactor);16*0.75=12`，当超过这个阈值的时候，开始扩容，即每次扩容增加一倍。



### 4.1.2、实现原理

**数据结构**：JDK1.8 以前`HashMap`的实现是 数组+链表。JDK1.8 开始`HashMap`的实现是 数组+链表+红黑树。

![image-20201028161441292](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/java集合/image-20201028161441292.png)



**工作原理**：使用put(key, value)存储对象到`HashMap`中，使用`get(key)`从`HashMap`中获取对象。当我们给put()方法传递键和值时，我们先对键调用`hashCode()`方法，计算并返回的`hashCode`是用于找到Map数组下标。



具体的**put过程**（JDK1.8版）

- 对Key求Hash值，然后再计算下标
- 如果没有碰撞，直接放入桶中（碰撞的意思是计算得到的Hash值相同，需要放到同一个bucket中）
- 如果碰撞了，以链表的方式链接到后面
- 如果链表长度超过阀值( TREEIFY THRESHOLD==8)，就把链表转成红黑树，链表长度低于6，就把红黑树转回链表
- 如果节点已经存在就替换旧值
- 如果桶满了(容量16*加载因子0.75)，就需要 resize（扩容2倍后重排）



具体**get过程**

- `HashMap`会使用键对象的`hashcode`找到bucket位置
- 找到bucket位置之后，会调用`keys.equals()`方法去找到链表中正确的节点，最终找到要找的值对象。



### 4.1.3、深入HashMap

`HashMap`中有两个**常量**：

```java
static final int TREEIFY_THRESHOLD = 8;
static final int UNTREEIFY_THRESHOLD = 6;
```

当链表中节点数量大于等于TREEIFY_THRESHOLD（8），那么链表就会转换成红黑树。
当链表中节点数量小于等于UNTREEIFY_THRESHOLD（6），那么红黑树就会转换成链表。



**hash冲突**：

两个不同的key，通过`hashcode()`方法计算出一样的值。于是他们两的存储位置会发生冲突。



**发生冲突的存储方式**：

JDK1.7是链表，头插法，我猜测头插的理由是：新加入的值应该比旧的值更有可能用到，定位到数组节点时，在头部能更快找到。不论头插还是尾插，都需要把整条链表遍历一遍，确定key在不在链表里。1.7版本中，产生哈希冲突时，遍历一条链表查找对象，时间复杂度时O(n),随着链表越来越长，查找的时间越来越大。为了提高这个冲突的查找效率，JDK1.8在链表长度超过8时，把链表转变成红黑树，大大减少查找时间。为了防止链表或红黑树巨大，需要了解扩容这个概念。



**减少碰撞的方法**：

使用扰动函数，原理是让返回的`hashcode`尽量不相同，只要`hashcode`不同，就不会发生冲突，这样子链表的规模也会小，就不会频繁调用equals方法，这样可以提高`hashmap`的性能。



**hash函数的实现**：

```java
//JDK1.8
static final int hash(Object key) {
 	if (key == null){
 		return 0;
 	}
 	int h;
 	h=key.hashCode()；返回散列值也就是hashcode
 	// ^ ：按位异或
 	// >>>:无符号右移，忽略符号位，空位都以0补齐
 	//其中n是数组的长度，即Map的数组部分初始化长度
 	return (n-1)&(h ^ (h >>> 16));
}
```

具体流程：

- 判断key是否为空，如果为空则返回0，否则计算数组下标。
- 获取key的`hashcode`，将其转化为32位的二进制。将得到的二进制数与它本身往后移动16位的二进制数进行异或（即高16位与0000 0000 0000 0000异或的结果 + 高16位与低16位异或的结果）
- 再将数组的初始长度n减去1，转变为二进制，然后将其与第二步中的结果相与，最终得到数组下标。



**扩容机制与负载因子**：

初始容器容量是16，负载因子默认0.75，最大容量2的30次幂。意思就是当前容量到达12的时候，会触发扩容机制。数据结构就是为了省时间省空间，扩容机制和负载因子的设定肯定也是为了效率。



**为什么改用红黑树？**

因为原本的链表结构会导致链表过深的问题，会影响效率。其他一些树型结构也可能会形成一条链，这样也无法拒绝问题。而红黑树在插入新数据后可能需要通过左旋，右旋、变色这些操作来保持平衡，引入红黑树就是为了查找数据快，解决链表查询深度的问题。但是它也是需要付出代价的，但是该代价比遍历线性链表要小，所以当长度大于8的时候会使用红黑树，如果长度过短，引入红黑树，反而会更慢。



## 4.2、HashTable

### 4.2.1、简介

HashTable继承的是Dictionary类，它的底层原理和结构与HashMap相似。但是HashTable是同步的，线性安全，而且存放的值不能为空。



### 4.2.2、实现原理

**put方法**：

- 先获取synchronized锁。
- put方法不允许null值，如果发现是null，则直接抛出异常。
- 计算key的哈希值和index
- 遍历对应位置的链表，如果发现已经存在相同的hash和key，则更新value，并返回旧值。
- 如果不存在相同的key的Entry节点，则调用`addEntry`方法增加节点。
- `addEntry`方法中，如果需要则进行扩容，之后添加新节点到链表头部。



**get方法**：

- 先获取synchronized锁。
- 计算key的哈希值和index。
- 在对应位置的链表中寻找具有相同hash和key的节点，返回节点的value。
- 如果遍历结束都没有找到节点，则返回null。



### 4.2.3、扩容机制

**rehash扩容方法**：

- 数组长度增加一倍再加一（如果超过上限，则设置成上限值）。
- 更新哈希表的扩容门限值。
- 遍历旧表中的节点，计算在新表中的index，插入到对应位置链表的头部。



## 4.3、LinkedHashMap

### 4.3.1、简介

`LinkedHashMap`继承的是`HashMap`类。key和value都允许为空，key重复会覆盖,value可以重复，有序的，`LinkedHashMap`是非线程安全的。`LinkedHashMap`底层是由数组和循环双向链表实现的。



### 4.3.2、实现原理

`LinkedHashMap`底层是由数组和循环双向链表实现的，即它既使用`HashMap`操作数据结构，又使用`LinkedList`维护插入元素的先后顺序。



## 4.4、TreeMap

### 4.4.1、简介

底层数据结构是红黑树，保证元素有序，没有比较器Comparator的情况按照key的自然排序，可自定义比较器。线程不安全。



# 5、重点问题

## 5.1、List,Set,Map三者的区别

- List：List接口存储一组不唯一（可以有多个元素引用相同的对象），有序的对象
- Set：不允许重复的集合。不会有多个元素引用相同的对象。
- Map：使用键值对存储。Map会维护与Key有关联的值。两个Key可以引用相同的对象，但Key不能重复，典型的Key是String类型，但也可以是任何对象。



## 5.2、Arraylist 与 LinkedList 区别

- 线程安全：`Arraylist`和`LinkedList`都是线程不安全的。
- 数据结构：`Arraylist`的底层数据结构是数组；而`LinkedList`的底层数据结构是双向链表。
- 适用范围：`Arraylist`查询快，增删慢；而`LinkedList`查询慢，增删快。
- 内存空间：`Arraylist`占用的空间较多，因为需要预留一定的空间；而`LinkedList`占用的空间比较少。



## 5.3、ArrayList 与 Vector 区别呢?

- 线程安全：`Arraylist`是线程不安全的；而`Vector`是线程安全的。
- 扩容：`Arraylist`不能设置扩容的增量；而`Vector`可以设置扩容的增量。
- 效率：`Arraylist`的效率高，运行快；而`Vector`效率低，运行慢，因为每次都要耗费大量的时间在同步操作上。



## 5.4、HashSet、TreeSet 与 LinkedHashSet对比

- `HashSet`不能保证元素的排列顺序，顺序有可能发生变化，不是同步的，集合元素可以是null,但只能放入一个null
- `TreeSet`是`SortedSet`接口的唯一实现类，`TreeSet`可以确保集合元素处于排序状态。`TreeSet`支持两种排序方式，自然排序 和定制排序，其中自然排序为默认的排序方式。向 `TreeSet`中加入的应该是同一个类的对象。
  `TreeSet`判断两个对象不相等的方式是两个对象通过equals方法返回false，或者通过`CompareTo`方法比较没有返回0
  **自然排序**
  自然排序使用要排序元素的`CompareTo(Object obj)`方法来比较元素之间大小关系，然后将元素按照升序排列。
  **定制排序**
  自然排序是根据集合元素的大小，以升序排列，如果要定制排序，应该使用Comparator接口，实现 i`nt compare(To1,To2)`方法
- `LinkedHashSet`集合同样是根据元素的`hashCode`值来决定元素的存储位置，但是它同时使用链表维护元素的次序。这样使得元素看起 来像是以插入顺 序保存的，也就是说，当遍历该集合时候，`LinkedHashSet`将会以元素的添加顺序访问集合的元素。
  **`LinkedHashSet`在迭代访问Set中的全部元素时，性能比`HashSet`好，但是插入时性能稍微逊色于`HashSet`。**



## 5.5、LinkedHashMap、HashMap 和 TreeMap对比

- `Hashmap`是一个最常用的Map,它根据键的`HashCode`值存储数据,根据键可以直接获取它的值，具有很快的访问速度，遍历时，**取得数据的顺序是完全随机的。**

- `LinkedHashMap`保存了记录的插入顺序，**在用Iterator遍历`LinkedHashMap`时，先得到的记录肯定是先插入的.也可以在构造时用带参数，按照应用次数排序。在遍历的时候会比`HashMap`慢，不过有种情况例外，当`HashMap`容量很大，实际数据较少时，遍历起来可能会比`LinkedHashMap`慢，因为`LinkedHashMap`的遍历速度只和实际数据有关，和容量无关，而`HashMap`的遍历速度和他的容量有关。**

- **`TreeMap`实现`SortMap`接口，能够把它保存的记录根据键排序,默认是按键值的升序排序，也可以指定排序的比较器，当用Iterator 遍历`TreeMap`时，得到的记录是排过序的。**



总结：

- 我们用的最多的是`HashMap`,`HashMap`里面存入的键值对在取出的时候是随机的,在Map 中插入、删除和定位元素，`HashMap`是最好的选择。
- `TreeMap`取出来的是排序后的键值对。但如果您要按**自然顺序或自定义顺序遍历键**，那么`TreeMap`会更好。
- `LinkedHashMap`是`HashMap`的一个子类，如果需要输出的顺序和输入的相同,那么用`LinkedHashMap`可以实现,它还可以按读取顺序来排列，像连接池中可以应用。



## 5.6、HashMap 和 Hashtable 的区别

- 线程安全：`HashMap`是非线程安全的，`HashTable`是线程安全的；`HashTable`内部的方法基本都经过`synchronized` 修饰。（如果要保证线程安全的话就使用 `ConcurrentHashMap`吧！）
- 效率：`HashMap`的效率高，运行快；而`HashTable`效率低，运行慢，因为每次都要耗费大量的时间在同步操作上。
- 赋值：`HashMap`键和值均可以为null；而`HashTable`键和值都不能为null，否则会直接抛出`NullPointerException`。
- 数据结构：JDK1.8之后，当链表长度大于阈值（默认为8）时，`HashMap`将链表转化为红黑树；而`HashTable`没有这种机制。
- 扩容机制：`HashMap`的初始容量大小为16，每次扩容为原来的2倍；而`HashMap`初始容量大小为11，每次扩容为原来的2倍加1。



## 5.7、HashMap 和 HashSet区别

|             HashMap              |                           HashSet                            |
| :------------------------------: | :----------------------------------------------------------: |
|          实现了Map接口           |                         实现Set接口                          |
|            存储键值对            |                          仅存储对象                          |
|  调用`put()方法`向map中添加元素  |                调用`add()`方法向map中添加元素                |
| HashMap使用键（Key）计算Hashcode | HashSet使用成员对象来计算Hashcode值，对于两个对象来说hashcode可能相同，所以`equals()`方法用来判断对象的相等性 |



## 5.8、HashSet如何检查重复

把对象加入`HashSet`时，`HashSet`会先计算对象的`hashcode`值来判断对象加入的位置，同时也会与其他加入的对象的`hashcode`值作比较，如果没有相符的`hashcode`，`HashSet`会假设对象没有重复出现。但是如果发现有相同`hashcode`值的对象，这时会调用`equals（）`方法来检查`hashcode`相等的对象是否真的相同。如果两者相同，`HashSet`就不会让加入操作成功。

`hashCode()`与`equals()`的相关规定：

- 如果两个对象相等，则`hashcode`一定也是相同的
- 两个对象相等,对两个equals方法返回true
- 两个对象有相同的`hashcode`值，它们也不一定是相等的
- 综上，equals方法被覆盖过，则`hashCode`方法也必须被覆盖
- `hashCode()`的默认行为是对堆上的对象产生独特值。如果没有重写`hashCode()`，则该class的两个对象无论如何都不会相等（即使这两个对象指向相同的数据）。

 

## 5.9、HashMap的底层实现



`HashMap`以键值对（key-value）的形式来储存元素，但调用put方法时，`HashMap`会通过hash函数来计算key的hash值，然后通过hash值&(HashMap.length-1)判断当前元素的存储位置，如果当前位置存在元素的话，就要判断当前元素与要存入的key是否相同，如果相同则覆盖，如果不同则通过拉链表来解决。JDk1.8时，当链表长度大于8时，将链表转为红黑树。

JDK1.7 和 JDK1.8的数据解构对比：JDK1.7使用的是“拉链法”，JDK1.8使用的是数组+链表+红黑树。

JDK1.7：

所谓 “**拉链法**” 就是：将链表和数组相结合。也就是说创建一个链表数组，数组中每一格就是一个链表。若遇到哈希冲突，则将冲突的值加到链表中即可。

![image-20201029153444255](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/java集合/image-20201029153444255.png)

JDK1.8：

JDK1.8之后在解决哈希冲突时有了较大的变化，当链表长度大于阈值（默认为8）时，将链表转化为红黑树，以减少搜索时间。

![image-20201029153528602](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/java集合/image-20201029153528602.png)



## 5.10、HashMap 的长度为什么是2的幂次方

由于Hash值的范围值-2147483648到2147483647，前后加起来大概40亿的映射空间。如此大的映射空间，内存是没办法存放的，所以没办法直接将Hash值拿来用。为了解决这个问题，于是就产生了hash()这个方法。hash()实际上就是对hash值进行取余，得到数据的下标。而源码中没有采用直接取余的方式，而是使用了与的方式，那是因为**取余操作中如果除数是2的幂次，则等价于与其除数减一的与操作（也就是说：如果长度是2的次幂，则hash%length==hash&(length-1)）**。为了让运算更加的高效，所以使用了与操作，因此数组的长度也必须要为2的幂次方。























