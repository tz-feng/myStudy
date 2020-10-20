# Redis入门

## 1.基础知识

（1）redis默认有16个数据库（可以从配置文件中查看），默认是第0个，可以使用select进行切换。

（2）dbsize	查看数据大小。

（3）keys *	查看当前数据库所以的key。

（4）flushdb	清空当前数据库内容。

（5）flushall	清空所有数据库内容。



**思考**：redis端口号为什么是6379？因为redis的作者喜欢的明星在九宫格输入中是6379。（了解一下即可）



redis是==单线程==的！是C语言写的，官方提供的数据为100000+的QPS。
redis为什么单线程还那么块？
1、误区1：高性能的服务器一定是多线程？
2、误区2：多线程（CPU上下文切换）一定比单线程效率高！
核心：redis是将所有的数据全部存放在内存中，所以说使用单线程去操作效率是最高的，多线程（CPU上下文切换：耗时的操作），对于内存系统来说，如果没有上下文切换效率就是最高的！多次读写都是在一个CPU上的，在内存情况这个就是最佳的方案！



## 2.五大数据类型

![image-20200824210053809](D:\Typora-photos\redis\image-20200824210053809.png)

中文翻译：

Redis 是一个开源（BSD许可）的，内存中的数据结构存储系统，它可以用作==数据库==、==缓存==和==消息中间件==。 它支持多种类型的数据结构，如 字符串（strings）， 散列（hashes）， 列表（lists）， 集合（sets）， 有序集合（sorted sets） 与范围查询， bitmaps， hyperloglogs 和 地理空间（geospatial） 索引半径查询。 Redis 内置了 复制（replication），LUA脚本（Lua scripting）， LRU驱动事件（LRU eviction），事务（transactions） 和不同级别的 磁盘持久化（persistence）， 并通过 Redis哨兵（Sentinel）和自动 分区（Cluster）提供高可用性（high availability）。



### Redis-key

```bash
127.0.0.1:6379> keys *		#查询本数据库的所有key
(empty array)
127.0.0.1:6379> set name yjy	#设置key的值
OK
127.0.0.1:6379> get name		#获取key的值
"yjy"
127.0.0.1:6379> set age 22		
OK
127.0.0.1:6379> exists name
(integer) 1
127.0.0.1:6379> move name 1		#将某个key移动到某个数据库
(integer) 1
127.0.0.1:6379> keys *
1) "age"
127.0.0.1:6379> select 1		#切换数据库
OK
127.0.0.1:6379[1]> keys *
1) "name"
127.0.0.1:6379[1]> select 0
OK
127.0.0.1:6379> set name hxh
OK
127.0.0.1:6379> get name
"hxh"
127.0.0.1:6379> clear
127.0.0.1:6379> expire name 10	#设置key的过期时间
(integer) 1
127.0.0.1:6379> ttl name		#查看过期剩余时间
(integer) 3
127.0.0.1:6379> ttl name
(integer) 2
127.0.0.1:6379> ttl name
(integer) 1
127.0.0.1:6379> ttl name
(integer) -2
127.0.0.1:6379> get name
(nil)
127.0.0.1:6379> keys *
1) "age"
127.0.0.1:6379> del age		#删除某一个key
(integer) 1
127.0.0.1:6379> get age
(nil)
127.0.0.1:6379> 

```



官方文档：

![image-20200824212258056](D:\Typora-photos\redis\image-20200824212258056.png)



### String（字符串）

- append		在末尾追加字符串，如果如果当前key不存在，就相当于set key。

  ```bash
  127.0.0.1:6379> get k1				#获取key的值
  "v1"
  127.0.0.1:6379> append k1 hello		#追加字符串
  (integer) 7
  127.0.0.1:6379> keys *
  1) "k1"								#返回整个字符串长度
  127.0.0.1:6379> append k2 yjy		#因为k2不存在，所以相当于set k2 yjy
  (integer) 3
  127.0.0.1:6379> get k2
  "yjy"
  ```



- strlen		获取字符串长度

  ```bash
  127.0.0.1:6379> get k1			#获取key的值
  "v1hello"
  127.0.0.1:6379> strlen k1		#获取字符串长度
  (integer) 7
  ```

  

- incr和decr          自增和自减

  ```bash
  127.0.0.1:6379> set views 0		#设置key的值
  OK
  127.0.0.1:6379> get views		#获取key的值
  "0"
  127.0.0.1:6379> incr views		#自增（i++）
  (integer) 1						#返回当前值
  127.0.0.1:6379> incr views
  (integer) 2
  127.0.0.1:6379> incr views
  (integer) 3
  127.0.0.1:6379> incr views
  (integer) 4
  127.0.0.1:6379> get views
  "4"
  127.0.0.1:6379> decr views		#自减（i--）
  (integer) 3
  127.0.0.1:6379> decr views
  (integer) 2
  127.0.0.1:6379> decr views
  (integer) 1
  127.0.0.1:6379> get views
  "1"
  127.0.0.1:6379> 
  ```

  

- incrby 和 decrby          设置步长（i += x 和 i -= x）

  ```bash
  127.0.0.1:6379> get views			#获取key的值
  "1"
  127.0.0.1:6379> INCRBY views 5		#设置步长，指定增量
  (integer) 6
  127.0.0.1:6379> INCRBY views 5
  (integer) 11
  127.0.0.1:6379> GET views
  "11"
  127.0.0.1:6379> DECRBY views 3		#设置步长，指定减量
  (integer) 8
  127.0.0.1:6379> DECRBY views 3
  (integer) 5
  127.0.0.1:6379> get views
  "5"
  ```

  

- getrange 和 setrange         getrange是获取字符串的某个范围，如果想获取全部将范围设置成（0，-1）。setrange是替换某个范围的值

  ```bash
  127.0.0.1:6379> set k1 hello,yjy		#设置key的值
  OK
  127.0.0.1:6379> GETRANGE k1 3 7			#获取某个范围，这里是[3,7]两边都是闭区间
  "lo,yj"
  127.0.0.1:6379> GETRANGE k1 0 -1		#获取全部，相当于get k1
  "hello,yjy"
  127.0.0.1:6379> SETRANGE k1 2 xxx		#替换指定位置开始的字符串，从下标为2的字符串开始替换
  (integer) 9								#返回长度
  127.0.0.1:6379> get k1
  "hexxx,yjy"
  ```

  

- setex 和 setnx       setex是设置过期时间，setnx是如果当前key不存在再设置。

  ```bash
  127.0.0.1:6379> setex k2 30 yjy			#设置k2 30秒后过期
  OK
  127.0.0.1:6379> ttl k2			#显示剩余过期时间
  (integer) 23
  127.0.0.1:6379> setnx mykey mysql		#判断mykey是否存在，不存在，所以创建成功。
  (integer) 1
  127.0.0.1:6379> setnx mykey oracle		#判断mykey是否存在，存在，所以创建失败。
  (integer) 0
  127.0.0.1:6379> get mykey
  "mysql"
  127.0.0.1:6379> keys *			#查看所有key，证明k2已经过期。
  1) "k1"
  2) "mykey"
  
  ```

  

- mset 和 mget         一次设置多个key和一次获取多个key

  ```bash
  127.0.0.1:6379> mset k1 v1 k2 v2 k3 v3		#设置多个key
  OK
  127.0.0.1:6379> keys *		#查看所有key	
  1) "k3"
  2) "k2"
  3) "k1"
  4) "mykey"
  127.0.0.1:6379> mget k1 k2 k3		#获取多个key
  1) "v1"
  2) "v2"
  3) "v3"
  127.0.0.1:6379> msetnx k1 v1 k4 v4		#msetnx是一个原子性的操作，要么一起成功，要么一起失败。
  (integer) 0
  127.0.0.1:6379> get k4
  (nil)
  ```

  

- 设置对象的方式

  ```bash
  set user:1 {name:zhangsan,age:3}	#设置一个user:1 对象 值为json字符来保存一个对象！
  
  #这里的key是一个巧妙的设计： user:{id}:{filed} ,如此设计再Redis中是完全OK的！
  
  127.0.0.1:6379> mset user:1:name yjy user:1:age 22
  OK
  127.0.0.1:6379> mget user:1:name  user:1:age
  1) "yjy"
  2) "22"
  ```

  

- getset        先get再set

  ```bash
  127.0.0.1:6379> getset db mysql		#如果不存在，返回nil，再设置值为mysql。
  (nil)
  127.0.0.1:6379> get db
  "mysql"
  127.0.0.1:6379> getset db oracle	#如果存在，返回当前值，再设置值为oracle。
  "mysql"
  127.0.0.1:6379> get db
  "oracle"
  ```

String类似的使用场景：value除了是字符串还可以是数字

- 计数器
- 统计多单位数量
- 粉丝数
- 对象缓存存储！



### List（列表）

基本的数据类型，列表

![image-20200824224208568](D:\Typora-photos\redis\image-20200824224208568.png)

在redis里面，我们可以把list玩成 栈、队列、阻塞队列！

所有的list命令都是以l开头的，redis不区分大小写命令



- lpush和rpush		lpush是从头部插入（左边），rpush是从尾部插入（右边）

  ```bash
  127.0.0.1:6379> lpush list one		#将一个或多个值，插入列表头部
  (integer) 1
  127.0.0.1:6379> lpush list two
  (integer) 2
  127.0.0.1:6379> lpush list three
  (integer) 3
  127.0.0.1:6379> lrange list 0 -1	#获取列表的值
  1) "three"
  2) "two"
  3) "one"
  127.0.0.1:6379> rpush list four		#将一个或多个值，插入列表尾部
  (integer) 4
  127.0.0.1:6379> lrange list 0 -1
  1) "three"
  2) "two"
  3) "one"
  4) "four"
  ```

  

- lrange                 获取列表的值，范围（0，-1）表示获取所有值

  ```bash
  127.0.0.1:6379> lrange list 0 -1		#获取列表所有值
  1) "three"
  2) "two"
  3) "one"
  4) "four"
  127.0.0.1:6379> lrange list 1 2			#获取列表区间为[1,2]的值
  1) "two"
  2) "one"
  ```

  

- lpop和rpop          移除

  ```bash
  127.0.0.1:6379> LPOP list			#移除首个元素
  "three"								#返回被移除的值
  127.0.0.1:6379> RPOP list			#移除最后一个元素
  "four"
  127.0.0.1:6379> LRANGE list 0 -1
  1) "two"
  2) "one"
  ```

  

- lindex                获取指定位置的值

  ```bash
  127.0.0.1:6379> LRANGE list 0 -1
  1) "two"
  2) "one"
  127.0.0.1:6379> LINDEX list 0		#获取列表的第一个元素
  "two"
  127.0.0.1:6379> LINDEX list 1		#获取列表的第二个元素
  "one"
  ```

  

- Llen               获取列表长度

  ```bash
  127.0.0.1:6379> LRANGE list 0 -1
  1) "two"
  2) "one"
  127.0.0.1:6379> LLEN list		#获取列表长度
  (integer) 2
  ```

  

- lrem              移除指定的值

  ```bash
  127.0.0.1:6379> LRANGE list 0 -1
  1) "three"
  2) "three"
  3) "two"
  4) "one"
  127.0.0.1:6379> LREM list 1 two			#移除一个two
  (integer) 1
  127.0.0.1:6379> LRANGE list 0 -1
  1) "three"
  2) "three"
  3) "one"
  127.0.0.1:6379> LREM list 1 three		#移除一个three
  (integer) 1
  127.0.0.1:6379> LRANGE list 0 -1
  1) "three"
  2) "one"
  127.0.0.1:6379> LPUSH list three
  (integer) 3
  127.0.0.1:6379> LRANGE list 0 -1
  1) "three"
  2) "three"
  3) "one"
  127.0.0.1:6379> LREM list 2 three		#移除两个three
  (integer) 2
  127.0.0.1:6379> LRANGE list 0 -1
  1) "one"
  ```

  

- ltrim              修剪，截取列表的某个区间（对列表就行修改，只留下截取部分）

  ```bash
  127.0.0.1:6379> RPUSH mylist "hello"
  (integer) 1
  127.0.0.1:6379> RPUSH mylist "hello1"
  (integer) 2
  127.0.0.1:6379> RPUSH mylist "hello2"
  (integer) 3
  127.0.0.1:6379> RPUSH mylist "hello3"
  (integer) 4
  127.0.0.1:6379> LTRIM mylist 1 2			#通过下标截取指定的长度，这个list已经被改变，截断了只剩下截取的元素。
  OK	
  127.0.0.1:6379> LRANGE mylist 0 -1			
  1) "hello1"
  2) "hello2"
  ```

  

- rpoplpush           移除列表的最后一个元素，并将他移动到新的列表中

  ```bash
  127.0.0.1:6379> rpush mylist "hello"
  (integer) 1
  127.0.0.1:6379> rpush mylist "hello1"
  (integer) 2
  127.0.0.1:6379> rpush mylist "hello2"
  (integer) 3
  127.0.0.1:6379> rpush mylist "hello3"
  (integer) 4
  127.0.0.1:6379> RPOPLPUSH mylist otherlist		#移除列表的最后一个元素，并将他移动到新的列表中。
  "hello3"
  127.0.0.1:6379> LRANGE mylist 0 -1		#查看原来列表的所有值
  1) "hello"
  2) "hello1"
  3) "hello2"
  127.0.0.1:6379> LRANGE otherlist 0 -1		#查看目标列表中确实存在该值
  1) "hello3"
  ```

  

- lset            修改指定下标的值，如果该元素不存在，则报错。

  ```bash
  127.0.0.1:6379> EXISTS list				#判断key是否存在
  (integer) 0
  127.0.0.1:6379> lset list 0 item		#如果key不存在，报错
  (error) ERR no such key
  127.0.0.1:6379> LPUSH list "hello"
  (integer) 1
  127.0.0.1:6379> LRANGE list 0 0
  1) "hello"
  127.0.0.1:6379> lset list 0 item		#修改指定位置的值
  OK
  127.0.0.1:6379> LRANGE list 0 0
  1) "item"
  127.0.0.1:6379> lset list 1 item1		#如果指定位置不存在元素，报错
  (error) ERR index out of range
  ```

  

- linsert              将某一个具体的value插入到某个元素的前面或后面

  ```bash
  127.0.0.1:6379> RPUSH mylist "hello"
  (integer) 1
  127.0.0.1:6379> RPUSH mylist "world"
  (integer) 2
  127.0.0.1:6379> LINSERT mylist before "world" "other"		#将vlaue放在某个值前面
  (integer) 3
  127.0.0.1:6379> LRANGE mylist  0 -1
  1) "hello"
  2) "other"
  3) "world"
  127.0.0.1:6379> LINSERT mylist after world new		#将vlaue放在某个值后面
  (integer) 4
  127.0.0.1:6379> LRANGE mylist  0 -1
  1) "hello"
  2) "other"
  3) "world"
  4) "new"
  ```

  

>小结

- list实际上是一个链表，before Node after  ， left ， right都可以插入值

- 如果key不存在，创建新的链表

- 如果key存在，新增内容

- 如果移除了所有值，空链表，也代表不存在！

- 在两边插入或者改动值，效率最高！中间元素，相对来说效率会低一点~

消息队列！（Lpush Rpop） ，   栈（Lpush  Lpop）



### Set（集合）

set中的值是不能重复的，set是一个无序不重复集合

- sadd和srem                 添加一个或多个元素 和 删除一个或多个元素

  ```bash
  127.0.0.1:6379> sadd myset hello			#添加一个元素
  (integer) 1
  127.0.0.1:6379> sadd myset yjy
  (integer) 1
  127.0.0.1:6379> sadd myset hello,yjy
  (integer) 1
  127.0.0.1:6379> SMEMBERS myset				#查看所有元素
  1) "yjy"
  2) "hello,yjy"
  3) "hello"
  127.0.0.1:6379> SREM myset yjy				#删除一个元素
  (integer) 1
  127.0.0.1:6379> SMEMBERS myset
  1) "hello,yjy"
  2) "hello"
  
  127.0.0.1:6379> sadd myset2 hello yjy world
  (integer) 3
  127.0.0.1:6379> srem myset2 hello yjy 
  (integer) 2
  127.0.0.1:6379> SMEMBERS myset
  1) "world"
  ```

- smembers               #查看所有元素

  ```bash
  127.0.0.1:6379> SMEMBERS myset				#查看所有元素
  1) "hello,yjy"
  2) "hello"
  ```

  

- scard            获取set集合中元素的个数

  ```bash
  127.0.0.1:6379> SMEMBERS myset				#查看所有元素
  1) "hello,yjy"
  2) "hello"
  127.0.0.1:6379> SCARD myset					#获取set集合中元素的个数
  (integer) 2
  ```

  

- srandmember                随机抽取一个set中的元素

  ```bash
  127.0.0.1:6379> SRANDMEMBER myset				#随机抽取一个set中的元素
  "hello"
  127.0.0.1:6379> SRANDMEMBER myset
  "hello,yjy"
  127.0.0.1:6379> SRANDMEMBER myset
  "hello,yjy"
  127.0.0.1:6379> SRANDMEMBER myset
  "hello,yjy"
  127.0.0.1:6379> SRANDMEMBER myset
  "hello"
  ```

  

- spop                              随机移除一个元素

  ```bash
  127.0.0.1:6379> SMEMBERS myset			#查看所有元素
  1) "yjy"
  2) "yjy2"
  3) "hello,yjy"
  4) "hello"
  5) "yjy3"
  127.0.0.1:6379> spop myset				#随机移除一个元素
  "yjy2"
  127.0.0.1:6379> SMEMBERS myset
  1) "hello"
  2) "yjy"
  3) "hello,yjy"
  4) "yjy3"
  127.0.0.1:6379> spop myset
  "hello,yjy"
  127.0.0.1:6379> SMEMBERS myset
  1) "hello"
  2) "yjy"
  3) "yjy3"
  ```

  

- smove               将指定值移动到另一个set中

  ```bash
  127.0.0.1:6379> sadd set1 set
  (integer) 1
  127.0.0.1:6379> sadd set1 hello
  (integer) 1
  127.0.0.1:6379> sadd set1 world
  (integer) 1
  127.0.0.1:6379> sadd set1 yjy
  (integer) 1
  127.0.0.1:6379> sadd set2 set2
  (integer) 1
  127.0.0.1:6379> smove set1 set2 world			#将set1中的world移动到set2
  (integer) 1
  127.0.0.1:6379> SMEMBERS set2
  1) "world"
  2) "set2"
  127.0.0.1:6379> SMEMBERS set1
  1) "set"
  2) "yjy"
  3) "hello"
  127.0.0.1:6379> keys *
  1) "set1"
  2) "set3"
  3) "set2"
  127.0.0.1:6379> SMEMBERS set3
  1) "hello"
  127.0.0.1:6379> smove set3 set4 hello			#如果原set集合中移动值后为空，则该key被删除，如果目标set集合不存在则产生一个set集合。
  (integer) 1
  127.0.0.1:6379> keys *
  1) "set1"
  2) "set4"
  3) "set2"
  127.0.0.1:6379> SMEMBERS set4
  1) "hello"
  127.0.0.1:6379> smove set4 set1 yjy			#如果指定值不存在，那么移动失败
  (integer) 0
  
  ```

  

- sdiff，sinter和sunion                 差集，交集和并集

  ```bash
  127.0.0.1:6379> sadd set1 a
  (integer) 1
  127.0.0.1:6379> sadd set1 b
  (integer) 1
  127.0.0.1:6379> sadd set1 c
  (integer) 1
  127.0.0.1:6379> sadd set2 d
  (integer) 1
  127.0.0.1:6379> sadd set2 e
  (integer) 1
  127.0.0.1:6379> sadd set2 c
  (integer) 1
  127.0.0.1:6379> SDIFF set1 set2			#差集
  1) "a"
  2) "b"
  127.0.0.1:6379> SINTER set1 set2		#交集		共同好友的实现
  1) "c"
  127.0.0.1:6379> SUNION set1 set2		#并集
  1) "c"
  2) "a"
  3) "b"
  4) "e"
  5) "d"
  ```

  

使用场景：共同关注，共同爱好，二度好友（六度分割理论：你和任何一个陌生人之间所间隔的人不会超五个），推荐好友！



### Hash（哈希）

Map集合，key-map!这个时候值是一个map集合，即value = <key-value>。本质上与String类型没有什么区别



- hset 和 hget                     向hash中添加一个值 和 获取一个值

  ```bash
  127.0.0.1:6379> clear
  127.0.0.1:6379> HSET myhash field1 hello		#向hash中添加值
  (integer) 1
  127.0.0.1:6379> hget myhash field1 				#获取hash中的某个值
  "hello"
  
  ```

  

- hmset 和 hmget                 向hash中添加多个值 和 获取多个值

  ```bash
  127.0.0.1:6379> hmset hash2 field1 hello field2 world		#向hash中添加多个值
  OK
  127.0.0.1:6379> hmget hash2 field1 field2			#获取hash中的多个个值
  1) "hello"
  2) "world
  ```

  

- hgetall                       获取hash中的所有值，返回值以key-value的方式。

  ```bash
  127.0.0.1:6379> HGETALL hash2			#获取hash中的所有值
  1) "field1"								#返回值以key-value的方式
  2) "hello"
  3) "field2"
  4) "world"
  ```

  

- hdel                   删除hash中指定的key字段！对应的value也会被删除。

  ```bash
  127.0.0.1:6379> hdel hash2 field1			#删除hash中指定的key字段！对应的value也会被删除。
  (integer) 1
  127.0.0.1:6379> HGETALL hash2
  1) "field2"
  2) "world"
  ```

  

- hlen                 获取hash表的字段数量

  ```bash
  127.0.0.1:6379> HGETALL hash2
  1) "field2"
  2) "world"
  3) "field1"
  4) "hello"
  127.0.0.1:6379> hlen hash2			#获取hash表的字段数量
  (integer) 2
  ```

  

- hexists            判断hash中指定字段是否存在

  ```bash
  127.0.0.1:6379> HEXISTS hash2 field1			#判断hash中指定字段是否存在
  (integer) 1
  127.0.0.1:6379> HEXISTS hash2 field3
  (integer) 0
  ```

  

- hkeys 和 hvals           获取所有的key 和 获取所有的value

  ```bash
  127.0.0.1:6379> hkeys hash2			#获取所有的key
  1) "field2"
  2) "field1"
  127.0.0.1:6379> hvals hash2			#获取所有的value
  1) "world"
  2) "hello"
  ```

  

- hincrby                   设置步长（自增自减，hash中没有decr方法，但是使用hincrby设置步长为负数即可实现自减）

  ```bash
  127.0.0.1:6379> hset hash2 field3 5
  (integer) 1
  127.0.0.1:6379> HINCRBY hash2 field3 1			#自增，步长为1
  (integer) 6
  127.0.0.1:6379> HINCRBY hash2 field3 1
  (integer) 7
  127.0.0.1:6379> HINCRBY hash2 field3 -1			#自减，步长为1
  (integer) 6
  127.0.0.1:6379> hget hash2 field3
  "6"
  ```

  

- hsetnx                 如果不存在则可以设置值

  ```bash
  127.0.0.1:6379> hsetnx hash2 field4 hello		#不存在，则可以设置值
  (integer) 1
  127.0.0.1:6379> hsetnx hash2 field4 world		#存在，则不可以设置值
  (integer) 0
  
  ```

  

- 设置对象

  ```bash
  127.0.0.1:6379> hmset user:1 name yjy age 22
  OK
  127.0.0.1:6379> hmget user:1 name age 
  1) "yjy"
  2) "22"
  ```

  

hash变更的数据 user name age，尤其是用户信息之类的，经常变动的信息！hash更适合对象存储，String更加适合字符串存储！



### Zset（有序集合）

在set的基础上，增加了一个值，set k1 v1        zset k1 score1 v1

- zadd 和 zrem            添加一个或多个元素 和 删除一个或多个元素

  ```bash
  127.0.0.1:6379> zadd myzset 1 one				#添加一个元素
  (integer) 1
  127.0.0.1:6379> zadd myzset 2 two 3 three		#添加多个元素
  (integer) 2
  127.0.0.1:6379> ZRANGE myzset 0 -1				#查看所有元素
  1) "one"
  2) "two"
  3) "three"
  127.0.0.1:6379> ZREM myzset two					#删除一个元素
  (integer) 1
  127.0.0.1:6379> ZRANGE myzset 0 -1				
  1) "one"
  2) "three"
  127.0.0.1:6379> ZREM myzset one three			#删除多个元素
  (integer) 2
  ```

  

- zrange 和 zrevrange               获取指定==下标范围==内的元素并==升序==排序 和 获取指定==下标范围==内的元素并==降序==排序

  ```bash
  127.0.0.1:6379> zadd salary 5000 xiaoming 2500 xiaohong 8000 xiaoyang 10000 xiaohuang
  (integer) 4
  127.0.0.1:6379> ZRANGE salary 0 -1		#查看所有元素，按照升序排序
  1) "xiaohong"
  2) "xiaoming"
  3) "xiaoyang"
  4) "xiaohuang"
  127.0.0.1:6379> ZREVRANGE salary 0 -1	#查看所有元素，按照降序排序
  1) "xiaohuang"
  2) "xiaoyang"
  3) "xiaoming"
  4) "xiaohong"
  ```



- zrangebyscore 和 zrevrangebyscore          获取指定==score范围==内的元素，并按照score字段进行==升序==排序 和 获取指定==score范围==内的元素，并按照score字段进行==降序==排序

  ```bash
  127.0.0.1:6379> ZRANGEBYSCORE salary -inf +inf		#获取所有元素，并按照score字段进行升序排序。 -inf表示负无穷  +inf表示正无穷
  1) "xiaohong"
  2) "xiaoming"
  3) "xiaoyang"
  4) "xiaohuang"
  127.0.0.1:6379> ZRANGEBYSCORE salary 5000 8000		#获取score在[5000,8000]内的元素，并且按照升序排序
  1) "xiaoming"
  2) "xiaoyang"
  127.0.0.1:6379> ZRANGEBYSCORE salary (2500 8000		##获取score在(2500,8000]内的元素，并且按照升序排序
  1) "xiaoming"
  2) "xiaoyang"
  127.0.0.1:6379> ZRANGEBYSCORE salary -inf +inf withscores	#获取所有元素并且显示score字段，并按照score字段进行升序排序。
  1) "xiaohong"
  2) "2500"
  3) "xiaoming"
  4) "5000"
  5) "xiaoyang"
  6) "8000"
  7) "xiaohuang"
  8) "10000"
  127.0.0.1:6379> zrevrangebyscore salary +inf -inf 	#获取所有元素，并按照score字段进行降序排序。
  1) "xiaohuang"
  2) "xiaoyang"
  3) "xiaoming"
  4) "xiaohong"
  ```



- zcard 和 zcount                获取整个集合元素的个数 和 获取指定score范围内的元素的个数

  ```bash
  127.0.0.1:6379> zcard salary			#获取集合元素的个数
  (integer) 4
  127.0.0.1:6379> zcount salary 2500 8000		#获取score[2500,8000]的元素的个数
  (integer) 3
  127.0.0.1:6379> zcount salary (2500 8000	#获取score(2500,8000]的元素的个数
  (integer) 2
  127.0.0.1:6379> zcount salary -inf +inf		#获取score[-∞,+∞]的元素的个数
  (integer) 4
  ```

  

应用场景：

成绩表，工资表，带权重进行判断。

排行榜应用实现，取Top N 测试！



## 3.三种特殊数据类型

### geospatial 地理位置

朋友的定位，附近的人，打车距离计算？

Redis 的 Geo 在Redis3.2 版本就推出了！这个功能可以推算地理位置的信息，两地之间的距离，方圆几里的人。

可以查询一些测试数据：http://www.jsons.cn/lngcode/

只有六个命令

![image-20200825173038413](D:\Typora-photos\redis\image-20200825173038413.png)



- geoadd 和 geopos			添加地理位置 和 从key里返回所有给定位置元素的位置（经度和纬度）。

  ```bash
  # geoadd		添加地理位置
  # 规则：两级无法直接添加，我们一般会下载城市数据，直接通过java程序一次性导入！
  # 有效的经度从-180度到180度。
  # 有效的纬度从-85.05112878度到85.05112878度。
  # 当坐标位置超出上述指定范围时，该命令将会返回一个错误。
  # 参数 key 值（经度，维度，名称）	不知为何官方文档写的是维度，经度，名称。
  127.0.0.1:6379> GEOADD china:city 116.41 39.90 beijing 121.47 31.12 shanghai 113.28 23.12 guangzhou 114.09 22.55 shenzhen 106.50 29.53 chongqing 104.07 30.66 chengdu		#添加地理位置（可以一个或多个） 
  (integer) 6
  127.0.0.1:6379> geopos china:city beijing shanghai		#获取指定名称的经纬度（可以一个或多个）
  1) 1) "116.40999823808670044"
     2) "39.90000009167092543"
  2) 1) "121.47000163793563843"
     2) "31.1199997456060018"
  ```

  

- geodist                 返回两个给定位置之间的距离。如果两个位置之间的其中一个不存在， 那么命令返回空值。

  ```bash
  # 单位：
  # 指定单位的参数 unit 必须是以下单位的其中一个：
  # 	m 表示单位为米。
  # 	km 表示单位为千米。
  # 	mi 表示单位为英里。
  # 	ft 表示单位为英尺。
  # 如果用户没有显式地指定单位参数， 那么 GEODIST 默认使用米作为单位。
  127.0.0.1:6379> geodist china:city beijing shanghai km	#查看北京到上海的直线距离
  "1078.1846"
  127.0.0.1:6379> geodist china:city beijing shanghai
  "1078184.5798"
  ```

  

- georadius                以给定的经纬度为中心， 返回键包含的位置元素当中， 与中心的距离不超过给定最大距离的所有位置元素。

  ```bash
  127.0.0.1:6379> GEORADIUS china:city 110 30 1000 km		#以110，30为中心，返回1000km以内的所有城市名。
  1) "chongqing"
  2) "chengdu"
  3) "shenzhen"
  4) "guangzhou"
  127.0.0.1:6379> GEORADIUS china:city 110 30 500 km		#以110，30为中心，返回500km以内的所有城市名。
  1) "chongqing"
  127.0.0.1:6379> GEORADIUS china:city 110 30 800 km withcoord	#以110，30为中心，返回800km以内的所有城市名，并返回经纬度。
  1) 1) "chongqing"
     2) 1) "106.49999767541885376"
        2) "29.52999957900659211"
  2) 1) "chengdu"
     2) 1) "104.07000213861465454"
        2) "30.66000108433032523"
  127.0.0.1:6379> GEORADIUS china:city 110 30 800 km withdist		#以110，30为中心，返回800km以内的所有城市名，并返回距离。
  1) 1) "chongqing"
     2) "341.9374"
  2) 1) "chengdu"
     2) "573.9398"
  127.0.0.1:6379> GEORADIUS china:city 110 30 1000 km withdist count 2		#以110，30为中心，返回1000km以内的所有城市名，并且限定返回数量，返回的结果是根据距离从小到大排序。
  1) 1) "chongqing"
     2) "341.9374"
  2) 1) "chengdu"
     2) "573.9398"
  127.0.0.1:6379> GEORADIUS china:city 110 30 1000 km withdist count 4
  1) 1) "chongqing"
     2) "341.9374"
  2) 1) "chengdu"
     2) "573.9398"
  3) 1) "guangzhou"
     2) "831.7713"
  4) 1) "shenzhen"
     2) "923.3692"
  
  ```

  

- georadiusbymember               以某个元素为中心，给出半径搜索其范围内的元素。

  ```bash
  127.0.0.1:6379> GEORADIUSBYMEMBER china:city beijing 1000 km 		#搜索以北京为中心，1000km范围内的城市。
  1) "beijing"
  127.0.0.1:6379> GEORADIUSBYMEMBER china:city shanghai 1000 km 		#搜索以上海为中心，1000km范围内的城市。
  1) "shanghai"
  127.0.0.1:6379> GEORADIUSBYMEMBER china:city chongqing 1000 km 		#搜索以重庆为中心，1000km范围内的城市。
  1) "chongqing"
  2) "chengdu"
  3) "guangzhou"
  ```

  

- geohash                          返回一个或多个位置元素的 Geohash 表示。该命令将返回11个字符的Geohash字符串

  ```bash
  #将二维经纬度转换为一维的字符串，如果两个字符串与相似，那么他们的距离越接近。
  127.0.0.1:6379> geohash china:city beijing shanghai		#返回北京，上海的geohash。
  1) "wx4fbzx4me0"
  2) "wtw3h15z0h0"
  ```

  

#### GEO的底层实现原理

GEO 底层实现原理就是Zset！我们可以使用Zset 命令来操作geo

```bash
127.0.0.1:6379> ZRANGE china:city 0 -1
1) "chongqing"
2) "chengdu"
3) "shenzhen"
4) "guangzhou"
5) "shanghai"
6) "beijing"
```



### hyperloglog

什么是基数？

A{1，3，5，7，8，7}

B{1，3，5，7，8}

基数 = 不重复元素的个数，可以接受误差。



>简介

Redis 2.8.9 版本就更新了 Hyperloglog 数据结构！

Redis Hyperloglog 基数统计的算法！

有点，占用的内存是固定，2^64 不同的元素的计数，只需要费12KB内存！如果从内存角度来比较的话 Hyperloglog首选！

**网页的 UV（一个人访问一个网站多次，但是还是算作一个人）**

传统的方式，用set保存用户的id，然后就可以统计set中的元素数量作为标准判断！

这个方式如果保存大量的用户id，就会比较麻烦！我们的目的是为了计数，而不是为了保存id；

Hyperloglog 会有0.81%的错误率！统计UV任务，可以忽略不计的！



只有三个命令：

- pfadd                  将指定元素添加到hyperloglog中
- pfcount               获取指定hyperloglog的基数
- pfmerge              合并多个hyperloglog



> 测试使用

```bash
127.0.0.1:6379> pfadd mykey a b c d e f g h i j		#创建第一组元素
(integer) 1
127.0.0.1:6379> pfcount mykey			#统计第一组元素的基数
(integer) 10
127.0.0.1:6379> pfadd mykey2 a b c d e f g h d j k r  v v d d r g	#创建第二组元素
(integer) 1
127.0.0.1:6379> pfcount mykey2		#统计第二组元素的基数
(integer) 12
127.0.0.1:6379> PFMERGE mykey3 mykey mykey2		#将第一组元素与第二组元素合并，创建第三组元素
OK
127.0.0.1:6379> pfcount mykey3		#统计第三组元素的基数
(integer) 13
```



如果允许容错，那么一定可以使用Hyperloglog！

如果不允许容错，那么就使用set或者自己的数据类型！



### bitmaps

统计用户信息，活跃，不活跃！登录，未登录！打卡，未打卡！只涉及两种状态的统计，可以使用Bitmaps！

Bitmaps 位图，数据结构！都是操作二进制来进行记录，就只有0和1两个状态！

如打卡：365天 = 365bit ，1字节=8bit     一年就46个字节左右！



常用命令：

- setbit					设置bit值，0或1
- getbit                    获取bit值
- bitcount                计数bit值为1的个数



> 测试

统计打卡：

```bash
127.0.0.1:6379> setbit mykey 0 1		#设置bit值
(integer) 0								#返回原来的bit值
127.0.0.1:6379> setbit mykey 1 0
(integer) 0
127.0.0.1:6379> setbit mykey 2 1
(integer) 0
127.0.0.1:6379> setbit mykey 3 1
(integer) 0
127.0.0.1:6379> setbit mykey 4 1
(integer) 0
127.0.0.1:6379> setbit mykey 5 1
(integer) 0
127.0.0.1:6379> setbit mykey 6 0
(integer) 0
127.0.0.1:6379> GETBIT mykey 2 			#获取指定的元素的bit值
(integer) 1
127.0.0.1:6379> GETBIT mykey 6
(integer) 0
127.0.0.1:6379> BITCOUNT mykey			#计算bit值为1的个数
(integer) 5

```



## 4.事务

### Redis事务本质

一组命令的集合！一个事务中的所有命令都会被序列化，在事务执行过程中，会按照顺序执行！

特性：一次性、顺序性、排他性！执行一系列命令！

```bash
----- 队列 set set set 队列 -----
```

==Redis事务没有隔离级别的概念！==

所有的命令在事务中，并没有直接被执行！只有发起执行命令的时候才会被执行！

**==Redis单条命令式保存原子性的，但是事务不保证原子性！==**



### Redis的事务

- 开启事务（nulti）
- 命令入队（......）
- 执行事务（exec）

>正常执行事务！

```bash
127.0.0.1:6379> multi			#开启事务
OK
#命令入队
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> set k3 v3
QUEUED
127.0.0.1:6379> get k2
QUEUED
127.0.0.1:6379> exec			#执行事务
1) OK
2) OK
3) OK
4) "v2"
```



>放弃事务（discard）

```bash
127.0.0.1:6379> multi			#开启事务
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> set k4 v4
QUEUED
127.0.0.1:6379> DISCARD			#放弃事务
OK
127.0.0.1:6379> get k4			#事务队列中的命令都不会执行！
(nil)
```



> 编译型异常（代码有问题！命令有错！），事务中所有的命令都不会被执行！

```bash
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> set k3 v3
QUEUED
127.0.0.1:6379> getset k3
(error) ERR wrong number of arguments for 'getset' command
127.0.0.1:6379> set k4 v4
QUEUED
127.0.0.1:6379> set k5 v5
QUEUED
127.0.0.1:6379> exec
(error) EXECABORT Transaction discarded because of previous errors.
127.0.0.1:6379> get k1
(nil)
127.0.0.1:6379> get k3
(nil)
127.0.0.1:6379> get k5
(nil)

```



> 运行时异常（1/0），如果事务队列中存在语法性，那么执行命令的时候，其他命令是可以正常执行的，错误命令抛出异常！

```bash
127.0.0.1:6379> set k1 v1
OK
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> INCR k1			#由于k1是字符串，没办法自增，所以会报错
QUEUED
127.0.0.1:6379> set k3 v3
QUEUED
127.0.0.1:6379> set k4 v4
QUEUED
127.0.0.1:6379> EXEC	
#虽然第二条命令报错了，但是其他的命令仍然有执行。
1) OK
2) (error) ERR value is not an integer or out of range
3) OK
4) OK
127.0.0.1:6379> get k1
"v1"
127.0.0.1:6379> get k2
"v2"
127.0.0.1:6379> get k3
"v3"
127.0.0.1:6379> get k4
"v4"
```



> 监控！

**悲观锁：**

- 很悲观，认为什么时候都会出现问题，无论做什么都要加锁！

**乐观锁：**

- 乐观锁，人所什么时候都不会出问题，所以不会上锁！更新数据的时候会去判断一下，在此期间是否有人修改过这个数据
- 获取version
- 更新的时候比较version



> Redis监控测试

正常执行成功！

```bash
127.0.0.1:6379> set money 100
OK
127.0.0.1:6379> set out 0
OK
127.0.0.1:6379> WATCH money			#对 money 对象进行监控
OK
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> DECRBY money 20
QUEUED
127.0.0.1:6379> INCRBY out 20
QUEUED
127.0.0.1:6379> EXEC
1) (integer) 80
2) (integer) 20
```



测试多线程修改值，使用watch可以当作redis的乐观锁操作！

```bash
# 线程1：
127.0.0.1:6379> WATCH money			#监视
OK
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> DECRBY money 10
QUEUED
127.0.0.1:6379> INCRBY out 10
QUEUED
127.0.0.1:6379> EXEC
(nil)

# 线程2：
127.0.0.1:6379> get money			
"80"
127.0.0.1:6379> INCRBY money 1000		#修改了money的值，会使线程1的事务失败。
(integer) 1080

# 线程2在线程1开启事务后启动，在线程1执行事务前结束。
```

==在执行事务后，无论是失败还是成功，都会自动解锁。放弃事务也会自动解锁。==



## Jedis

什么是Jedis 是 Redis官方推荐的java连接开发工具！使用Java操作 Redis中间件！如果你要使用java操作redis，那么一定要对Jedis十分的熟悉！



> 测试

### 1.导入对应的依赖

```xml
<dependencies>
    <!--导入jedis的包-->
    <dependency>
        <groupId>redis.clients</groupId>
        <artifactId>jedis</artifactId>
        <version>3.3.0</version>
    </dependency>
    <!--导入fastjson的包-->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>fastjson</artifactId>
        <version>1.2.73</version>
    </dependency>
</dependencies>
```



### 2.编码测试

- 连接数据库 （创建一个jedis对象即可）

  ```java
  public static void main(String[] args) {
          // new Jedis 对象即可
          Jedis jedis = new Jedis("192.168.141.130", 6379);
          // jedis 所有的命令都是redis的所有指令！
          System.out.println(jedis.ping());
      }
  ```

  

  遇到的问题：由于本人用的是虚拟机中的redis，所以使用host:127.0.0.1 post:6379会报超时错误！

  解决方案：（本人使用的是centOS6.8，命令可能会有差异，但是流程没问题。）

  1. 修改redis的配置文件vim /usr/local/bin/myconfig/redis.conf (这是本人的配置文件的位置)。

     （1）注释掉 bind：127.0.0.1 和 关闭保护模式，然后输入 :wq 保存。

     ![image-20200827132004668](D:\Typora-photos\redis\image-20200827132004668.png)

     ![image-20200827131928943](D:\Typora-photos\redis\image-20200827131928943.png)

     （2）重启redis-server

     

  2. 开启端口或关闭防火墙

     （1）开启端口

     ​		进入防火墙的配置文件 vi /etc/sysconfig/iptables，添加相对应的端口-A INPUT -m state --state NEW -m tcp -p tcp --dport 端口号 -j ACCEPT，然后 :wq 保存，最后输入 service iptables restart 重启防火墙即可。

     ![image-20200827133326405](D:\Typora-photos\redis\image-20200827133326405.png)

![image-20200827133414127](D:\Typora-photos\redis\image-20200827133414127.png)

​			

​			（2）关闭防火墙（在实际的应用中会不安全，不建议使用）

​				直接输入 service iptables stop 关闭防火墙即可。

​				![image-20200827133557289](D:\Typora-photos\redis\image-20200827133557289.png)



- 操作命令

  ```java
  public static void main(String[] args) {
          // new Jedis 对象即可
          Jedis jedis = new Jedis("192.168.141.130", 6379);
          // jedis 所有的命令都是redis的所有指令！
          System.out.println("尝试连接：" + jedis.ping());
          System.out.println("清空数据库：" + jedis.flushDB());
          System.out.println("设置k1的值：" + jedis.set("k1", "v1"));
          System.out.println("设置k2的值：" + jedis.set("k2", "v2"));
          System.out.println("查看所有key：" + jedis.keys("*"));
          System.out.println("获取k2的值：" + jedis.get("k2"));
          System.out.println("在k1末尾追加字符串：" + jedis.append("k1", "yjy"));
          System.out.println("返回k1的长度：" + jedis.strlen("k1"));
          System.out.println("获取k1下标[1,3]的值：" + jedis.getrange("k1",1,3));
          System.out.println("从k1的下标1开始替换：" + jedis.setrange("k1",1,"xxx"));
          System.out.println("获取k1的值：" + jedis.get("k1"));
          System.out.println("设置k3的值：" + jedis.set("k3", "1"));
          System.out.println("使k3自增1：" + jedis.incr("k3"));
          System.out.println("使k3自增5：" + jedis.incrBy("k3",5));
          System.out.println("使k3自减1：" + jedis.decr("k3"));
          System.out.println("使k3自减5：" + jedis.decrBy("k3",2));
          System.out.println("设置k4的值，并在30秒后结束：" + jedis.setex("k4", 30, "hello,world"));
          System.out.println("如果k5不存在，则生成一个k5：" + jedis.setnx("k5", "hello,yjy"));
          System.out.println("设置多个值" + jedis.mset("k6 k7 k8", "v6 v7 v8"));
          System.out.println("设置多个值" + jedis.mget("k6 k7 k8"));
          System.out.println("查看所有key：" + jedis.keys("*"));
          System.out.println("删除k1" + jedis.del("k1"));
          System.out.println("查看所有key：" + jedis.keys("*"));
          System.out.println("断开连接！");
          jedis.close();
      }
  ```

  输出：

  ![image-20200827140739125](D:\Typora-photos\redis\image-20200827140739125.png)

  

- 断开连接！

  ```java
  jedis.close();
  ```

  

> 正常事务测试

```java
public static void main(String[] args) {
    Jedis jedis = new Jedis("192.168.141.130", 6379);

    JSONObject jsonObject = new JSONObject();
    jsonObject.put("name","yjy");
    jsonObject.put("age","22");

    // 清空数据库
    jedis.flushDB();

    // 开启事务
    Transaction multi = jedis.multi();
    String result = jsonObject.toJSONString();

    try {
        multi.set("user1",result);
        multi.set("user2",result);

        multi.exec();//执行事务
    }catch (Exception e) {
        multi.discard();//放弃事务
        e.printStackTrace();
    }finally {
        System.out.println(jedis.get("user1"));
        System.out.println(jedis.get("user2"));
        jedis.close();// 断开连接
    }
}
```



输出：

![image-20200827142636233](D:\Typora-photos\redis\image-20200827142636233.png)



> 异常事务测试

```java
public static void main(String[] args) {
    Jedis jedis = new Jedis("192.168.141.130", 6379);

    JSONObject jsonObject = new JSONObject();
    jsonObject.put("name","yjy");
    jsonObject.put("age","22");

    // 清空数据库
    jedis.flushDB();

    // 开启事务
    Transaction multi = jedis.multi();
    String result = jsonObject.toJSONString();

    try {
        multi.set("user1",result);
        multi.set("user2",result);
        int i = 1/0;// 代码抛出异常事务，执行失败！
        multi.exec();// 执行事务
    }catch (Exception e) {
        multi.discard();// 放弃事务
        e.printStackTrace();
    }finally {
        System.out.println(jedis.get("user1"));
        System.out.println(jedis.get("user2"));
        jedis.close();// 断开连接
    }
}
```



输出：

![image-20200827143051958](D:\Typora-photos\redis\image-20200827143051958.png)



## SpringBoot整合

说明：在SpringBoot2.x之后，原来使用的jedis 被替换为 lettuce

jedis：采用的直连，多个线程操作的话，是不安全的，如果想要避免不安全，使用jedis pool连接池！ 更像 BIO 模式

lettuce：采用netty，实力可以再多个线程中进行共享，不存在线程不安全的情况！可以减少线程数据，更像 NIO 模式



源码分析：

```java
@Bean
@ConditionalOnMissingBean(name = "redisTemplate") // 我们可以自己定义一个redisTemplate来替换这个默认的！
public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory)
      throws UnknownHostException {
   //默认的 RedisTemplate 没有过多的设置，redis 对象都是需要序列化！
   //两个泛型都是 Object, Object 的类型，我们后面使用需要强制转换 <Object, Object>
   RedisTemplate<Object, Object> template = new RedisTemplate<>();
   template.setConnectionFactory(redisConnectionFactory);
   return template;
}

@Bean
@ConditionalOnMissingBean // 由于 String 是redis中最常用的类型，所以说单独提出来了一个bean！
public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory redisConnectionFactory)
      throws UnknownHostException {
   StringRedisTemplate template = new StringRedisTemplate();
   template.setConnectionFactory(redisConnectionFactory);
   return template;
}
```



> 整合测试

1、导入依赖

```xml
<!--操作redis-->
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```



2、配置连接

```properties
//配置redis
spring.redis.host=192.168.141.130
spring.redis.port=6379
```



3、测试！

```java
@SpringBootTest
class Redis02SpringbootApplicationTests {

   @Autowired
   private RedisTemplate redisTemplate;

   @Test
   void contextLoads() {

      // redisTemplate  操作不同的数据类型，api和redis指令是一样的
      // opsForXxxxx 对某个类型进行操作
      // opsForValue 操作字符串，类似String
      // opsForList  操作List
      // opsForSet   操作Set
      // opsForHash  操作Hash
      // opsForZset  操作Zset
      // opsForGeo   操作Geo
      // opsForHyperLogLog  操作Hyperloglog

      // 常用的命令可以直接通过redisTemplate进行调用。例如：事务的开启，执行和放弃，还有查询所有key，删除key，设置过期时间等

      // 获取redis的连接对象
      // RedisConnection connection = redisTemplate.getConnectionFactory().getConnection();
      // connection.flushDb();
      // connection.flushAll();

      redisTemplate.opsForValue().set("mykey","关注我");
      System.out.println(redisTemplate.opsForValue().get("mykey"));
   }

}
```



![image-20200827200911716](D:\Typora-photos\redis\image-20200827200911716.png)



由于默认的序列化方式是JDK序列化，而我们使用的是json，所以会出现转义的情况。

![image-20200827201349700](D:\Typora-photos\redis\image-20200827201349700.png)

![image-20200827201411910](D:\Typora-photos\redis\image-20200827201411910.png)



关于redis序列化问题

不进行序列化传对象会报错：

```java
@Test
	public void test() throws JsonProcessingException {
		// 真是的开发一半都使用json来传递对象
		User user = new User("yjy", 22);
//		String jsonUser = new ObjectMapper().writeValueAsString(user);	//转化为json
		redisTemplate.opsForValue().set("user",user);
		System.out.println(redisTemplate.opsForValue().get("user"));
	}
```

结果：

![image-20200827211002444](D:\Typora-photos\redis\image-20200827211002444.png)



解决该问题需要自己配置一个RedisTemplate

```java
@Configuration
public class RedisConfig {

    @Bean
    @SuppressWarnings("all")
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory)
            throws UnknownHostException {
        // 编写我们自己的 redisTemplate
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(redisConnectionFactory);

        // Json序列化配置
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper om = new ObjectMapper();
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        om.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(om);

        // String序列化配置
        StringRedisSerializer stringRedisSerializer = new StringRedisSerializer();

        // 配置具体的序列化方式
        template.setKeySerializer(stringRedisSerializer);   // key采用String的序列化方式
        template.setHashKeySerializer(stringRedisSerializer);   // hash的key采用String的序列化方式
        template.setValueSerializer(jackson2JsonRedisSerializer);   // value采用jackson的序列化方式
        template.setHashValueSerializer(jackson2JsonRedisSerializer);   // hash的value采用jackson的序列化方式
        template.afterPropertiesSet();

        return template;
    }

}
```



# Redis进阶

## Redis.config详解

在启动的时候，redis是通过该配置文件来启动的

> 单位

![image-20200828220611407](D:\Typora-photos\redis\image-20200828220611407.png)

1.配置文件 unit单位 对大小写不敏感！



> 包含

![image-20200828220817635](D:\Typora-photos\redis\image-20200828220817635.png)

包含其他的配置文件，就像 java 里的 import。



> 网络

```bash
bind 127.0.0.1	# 绑定id
protected-mode yes	# 保护模式
port 6379	# 端口号
```



> 通用

```bash
daemonize yes	# 以守护进程的方式运行，默认是no，我们需要自己开启为yes！

pidfile /var/run/redis_6379.pid	# 如果以后台方式运行，我们需要指定一个 pid文件！

# 日志
# Specify the server verbosity level.
# This can be one of:
# debug (a lot of information, useful for development/testing)
# verbose (many rarely useful info, but not a mess like the debug level)
# notice (moderately verbose, what you want in production probably) 生产环境
# warning (only very important / critical messages are logged)
loglevel notice

# Specify the log file name. Also the empty string can be used to force
# Redis to log on the standard output. Note that if you use standard
# output for logging but daemonize, logs will be sent to /dev/null
logfile ""	# 日志的文件位置名，如果为空就是标准的输出

databases 16	# 数据的数量，默认的是16个数据库

always-show-logo yes	# 启动时是否总是展示logo
```



> 快照

持久化，在规定的时间内，执行了多少次操作，则会持久化文件.rdb .aof

redis是内存数据库，如果没有持久化，那么数据断电及失！

```bash
# 如果900秒内，至少有一个key进行了修改，我们就进行持久化操作
save 900 1
# 如果300秒内，至少有十个key进行了修改，我们就进行持久化操作
save 300 10
# 如果60秒内，至少有10000个key进行了修改，我们就进行持久化操作
save 60 10000

stop-writes-on-bgsave-error yes	# 持久化如果出错，是否还需要继续工作！

rdbcompression yes	# 是否压缩 rdb 文件，需要消耗一些cpu资源！

rdbchecksum yes	# 保存 rdb 文件的时候，进行错误的检查校验！

dir ./	# rdb 文件保存的目录，默认是当前目录下！
```



> REPLICATION 复制，主从复制会使用到

![image-20200831185112903](D:\Typora-photos\redis\image-20200831185112903.png)



>SECURITY

```bash
requirepass foobared	# 设置redis密码，默认是没有密码

# 也可以通过命令进行设置
127.0.0.1:6379> config get requirepass		# 获取 redis 密码
1) "requirepass"
2) ""
127.0.0.1:6379> config set requirepass "123456"		# 设置 redis 密码
OK
127.0.0.1:6379> ping							# 所有的命令都没办法使用
(error) NOAUTH Authentication required.  
127.0.0.1:6379> keys *
(error) NOAUTH Authentication required.
127.0.0.1:6379> auth 123456					# 使用密码进行登录
OK
127.0.0.1:6379> config get requirepass
1) "requirepass"
2) "123456"
```



> 客户端 CLIENTS

```bash
maxclients 10000	# 设置能连接上redis的最大客户端数量
```



> 内存管理 MEMORY MANAGEMENT

```bash
maxmemory <bytes>	# redis 匹配值最大的内存容量
maxmemory-policy noeviction	# 内存达到上限之后的处理策略
	# 移除一些过期的key
	# 报错
	# ...
volatile-lru -> 对设置了过期时间的keys适用LRU淘汰策略
allkeys-lru -> 对所有keys适用LRU淘汰策略
volatile-lfu -> 对设置了过期时间的keys适用LFU淘汰策略
allkeys-lfu -> 对所有keys适用LFU淘汰策略
volatile-random -> 对设置了过期时间的keys适用随机淘汰策略
allkeys-random -> 对所有keys适用随机淘汰策略
volatile-ttl -> 淘汰离过期时间最近的keys
noeviction -> 不淘汰任何key，仅对写入操作返回一个错误
```



>APPEND ONLY 模式	aof配置

```bash
appendonly no	# 默认是不开启aof模式的，默认是使用edb方式持久化的，在大部分所有的情况下，rdb完全够用

appendfilename "appendonly.aof"	 # 持久化的文件名字

# appendfsync always	# 每次修改都会 sync，消耗性能
appendfsync everysec	# 每秒执行一次 sync（同步），可能会丢失这1s的数据！
# appendfsync no		# 不执行 sync，这个时候操作系统自己同步数据，速度最快！
```



## Redis持久化

面试和工作中，持久化都是==**重点**==

Redis 是内存数据库，如果不将内存中的数据库状态保存到磁盘，那么一旦服务器进程退出，服务器中的数据库状态也会消失。所以 Redis 提供了持久化功能！ 

### RDB（Redis DataBase）

在主从复制中，rdb就是备用的！ 从机上面！

![image-20200829120149121](D:\Typora-photos\redis\image-20200829120149121.png)

在指定的时间间隔内将内存中的数据集快照写入磁盘，也就是行话的Snapshot快照，他恢复时是将快照文件直接读到内存里。

Redis会单独创建（fork）一个子进程来进行持久化，会先将数据写入到一个临时文件中，待持久化过程都结束了，再用这个临时文件替换上次持久化好的文件。整个过程中，主进程是不进行任何IO操作的。这就确保了极高的性能。如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，那RDB方式要比AOF方式更加的高效。RDB的缺点是最后一次持久化后的数据可能丢失。我们默认的就是RDB，一般情况下不需要修改这个配置！

==rdb保存的文件 dump.rdb==



> 触发机制

1、save的规则满足的情况下，会自动触发rdb规则

2、执行 flushall 命令，也会触发我们的rdb规则！

3、退出redis，也会产生rdb文件！

有时候再生产环境我们会将这个文件进行备份！

==备份就自动生成一个 dump.rdb==

![image-20200829123107309](D:\Typora-photos\redis\image-20200829123107309.png)

> 如何恢复rdb文件！

1、只需要将rdb文件放在我们redis启动目录就可以，redis启动的时候会自动检查dump.rdb 恢复其中的数据！

2、查看需要存放的位置

```bash
127.0.0.1:6379> config get dir
1) "dir"
2) "/usr/local/bin"		# 如果该目录下存在 dump.rdb 文件，启动就会自动恢复其中的数据
```



**优点：**

1、适合大规模的数据恢复！

2、对数据的完整性要求不高！

**缺点：**

1、需要一定的时间间隔进行操作！如果redis意外宕机，这个最后一次修改数据就没有得了！

2、fork进程的时候，会占用一定的内存空间！



### AOF（Append Only File）

将我们的所有命令都记录下来，history，恢复的时候就把这个文件全部再执行一遍！

![image-20200829132731357](D:\Typora-photos\redis\image-20200829132731357.png)

以日志的形式来记录每个写操作，将Redis执行过的所有指令记录下来（读操作不记录），只许追加文件但不可以改写文件，redis启动之初会读取文件重新构建数据，换而言之，redis重启的化就根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作

==aof保存的是 appendonly.aof 文件==



> append

![image-20200829133405412](D:\Typora-photos\redis\image-20200829133405412.png)

默认是不开启的，我们需要手动进行配置！我们只需要将 appendonly 改为yes就开启 aof！

重启，redis 就可以生效了！

如果 aof文件有错误，这个时候 redis是启动不起来的，我们需要修复这个aof文件

redis 给我们提供了一个工具 `redis-check-aof`

![image-20200829135103256](D:\Typora-photos\redis\image-20200829135103256.png)

如果文件正常，重启就可以直接恢复了，但是可以发现k5不见了。

![image-20200829135240562](D:\Typora-photos\redis\image-20200829135240562.png)



> 重写规则

aof 默认就是文件的无线追加，文件会越来越大！

![image-20200829140433726](D:\Typora-photos\redis\image-20200829140433726.png)

如果 aof 文件大于64m，太大了！ fork一个新的进程来将我们的文件进行重写！



> 优点和缺点

```bash
appendonly no	# 默认是不开启aof模式的，默认是使用edb方式持久化的，在大部分所有的情况下，rdb完全够用

appendfilename "appendonly.aof"	 # 持久化的文件名字

# appendfsync always	# 每次修改都会 sync，消耗性能
appendfsync everysec	# 每秒执行一次 sync（同步），可能会丢失这1s的数据！
# appendfsync no		# 不执行 sync，这个时候操作系统自己同步数据，速度最快！
```

**优点：**

1、每一次修改都同步，文件的完整性会更加的好!

2、每秒同步一次，可能会丢失一秒的数据

3、从不同步，效率最高的！

**缺点：**

1、相对于数据文件来说，aof远远大于 rdb，修复速度也比 rdb慢！

2、aof运行效率也比 rdb 慢，所以我们redis默认的哦欸之就是rdb持久化！



**扩展：**

1、RDB 持久化方式能够在指定的时间间隔内对你的数据进行快照存储

2、AOF 持久化方式记录每次服务器写的操作，当服务器重启的时候会重新执行这些命令来恢复原始的数据，AOF命令以Redis 协议追加保存每次写的操作到文件末尾，Redis还能对AOF文件进行后台重写，使得AOF文件的体积不至于过大。

3、==只做缓存，如果你只希望你的数据在服务器运行的时候存在，你也可以不使用任何持久化==

4、同时开启两种持久化方式

- 在这种情况下，当redis重启的时候会优先载入AOF文件来恢复原始数据，因为在通常情况下AOF文件保存的数据集要比RDB文件保存的数据集要完整。
- RDB 的数据不实时，通过是使用两者是服务器重启也只会找AOF文件，那要不要只是用AOF呢？作者建议不要，因为RDB更适合用于备份数据库（AOF在不断变化不好备份），快速重启，而且不会有AOF可能潜在的Bug，留着作为一个万一的手段。

5、性能建议

- 因为Rdb文件只用作后备用途，建议只在Slave上持久化RDB文件，而且只要15分钟备份一次就够了，只保留 save 900 1这一条规则。
- 如果Enable AOF，好处是在最恶劣情况下也只会丢失不超过两秒的数据，启动脚本较简单，只load自己的AOF文件就可以了，代价一是带来了持续的IO，二是AOF rewrite 的最后将 rewrite 过程中产生的新数据写道新文件造成的阻塞几乎是不可避免的。只要硬盘许可，应该尽量减少AOF rewrite 的频率，AOF重写的基础大小默认值是64M太小了，可以设置到5G以上，默认超过原大小100%大小重写可以改到适当的数值。
- 如果不Enable AOF，仅靠Master-Slave Repllcation 实现高可用性也是可以的，能省掉一大笔IO，也减少了rewrite时带来的系统波动。代价是如果Master/Slave同时倒掉（断电）,会对视十几分钟的数据，启动脚本也要比较两个Master/Slave 中的RDB文件，载入较新的那个，微博就是这种架构。



## Redis发布订阅

Redis 发布订阅(pub/sub)是一种==消息通信模式== ：发送者(pub)发送消息，订阅者(sub)接收消息

Redis 客户端可以订阅任意数量的频道。

订阅/发布消息图：

第一个：消息发送者，第二个：频道，第三个：消息订阅者！

![image-20200831172709980](D:\Typora-photos\redis\image-20200831172709980.png)



下图展示了频道channel1，以及订阅这个频道的三个客户端——client2、client5和client1 之间的关系：

![image-20200831172742399](D:\Typora-photos\redis\image-20200831172742399.png)

当有新消息通过 PUBLISH 命令发送给频道channel1 时，这个消息就会被发送给订阅它的三个客户端：

![image-20200831172758625](D:\Typora-photos\redis\image-20200831172758625.png)



> 命令

这些命令被广泛用于构建即时通信应用，比如网络聊天室(chatroom)和实时广播、实时提醒等。

![image-20200831172819387](D:\Typora-photos\redis\image-20200831172819387.png)



> 测试

订阅端：

```bash
127.0.0.1:6379> SUBSCRIBE learnjava			#订阅频道
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "learnjava"
3) (integer) 1
# 等待读取推送的消息
1) "message"	# 消息
2) "learnjava"	# 频道名称
3) "hello,java"	# 消息的具体内容

1) "message"
2) "learnjava"
3) "hello,yjy"
```

发送端：

```bash
127.0.0.1:6379> PUBLISH learnjava hello,java		# 发布者发送消息到频道！
(integer) 1
127.0.0.1:6379> PUBLISH learnjava hello,yjy			# 发布者发送消息到频道！
(integer) 1
```



> 原理

Redis是使用C实现的，通过分析 Redis 源码里的 pubsub.c 文件，了解发布和订阅机制的底层实现，借此加深堆 Redis 的理解。

Redis 通过 PUBLISH、SUBSCRIBE 和 PSUBSCRIBE 等命令实现发布和订阅功能。



通过 SUBSCRIBE 命令订阅某频道后，redis-server 里维护了一个字典，字典的键就是一个个channel(频道)！而字典的值则是一个链表，链表中保存了所有订阅这个 channel 的客户端。SUBSCRIBE 命令的关键，就是将客户端添加到给定 channel 的订阅链表中。

图示：

![image-20200831175304169](D:\Typora-photos\redis\image-20200831175304169.png)

通过 PUBLISH 命令像订阅者发送消息，redis-server 会使用给定的频道作为键，在它所维护的 channel 字典中查找记录了订阅这个频道的所有客户端的链表，遍历这个链表，将消息发布给所有订阅者。



Pub/Sub 从字面上理解就是发布（Publish）与订阅（Subscribe），在Redis中，你可以设定对某一个key值进行消息发布及消息订阅，当一个key值上进行了消息发布后，所有订阅它的客户端都会收到相应的消息。这一功能最明显的用法就是用作实时消息系统，比如普通的即时聊天，群聊等功能。

使用场景：

1、实时消息系统！

2、实时聊天！（频道当作聊天室，将信息回显给所有人即可！）

3、订阅，关注系统都是可以的！

稍微复杂的场景我们就会使用 消息中间件 MQ（消息队列）



## Redis主从复制

### 概念

主从复制，是指将一台Redis服务器的数据，复制到其他Redis服务器。前者称为主节点(master/leader)，后者称为从节点(slave/follower)；==数据的复制是单向的，只能由主节点到从节点==。Master以写为主，Slave以读为主。

==默认情况下，每台Redis服务器都是主节点；==

且一个主节点可以有多个从节点（或没有从节点），但一个从节点只能有一个主节点。



### 作用

**主从复制的作用主要包括：**

1、数据冗余：主从复制实现了数据的热备份，是持久化之外的一种数据冗余方式。

2、故障恢复：当主节点出现问题时，可以由从节点提供服务，实现快速的故障恢复；实际上是一种服务的冗余。

3、负载均衡：在主从复制的基础上，配合读写分离，可以由主节点提供写服务，由从节点提供读服务（即写Redis数据时应用连接主节点，读Redis数据时应用连接从节点），分担服务器负载；尤其实在写少读多的场景下，通过多个从节点分担读负载，可以大大提高Redis服务器的并发量。

4、高可用（集群）基石：除了上述作用以外，主从复制还是哨兵和集群能够实施的基础，因此说主从复制时Redis高可用的基础。



一般来说，要将Redis运用于工程项目中，只使用一台Redis时玩玩不能的（宕机，一主二从），原因如下：

1、从结构上，单个Redis服务器会发生单点故障，并且一台服务器需要处理所有的请求负载，压力较大；

2、从容量上，单个Redis服务器内存容量优先，就算一台Redis服务器内容容量为256G，也不能将所有内存用作Redis存储内存，一般来说，==单台Redis最大使用内存不应该超过20G==。

电商网站上的商品，一般都是一次上传，无数次浏览的，说专业点也就是"多读少写"。

对于这种场景，我们可以使如下这种架构：

![image-20200831181905091](D:\Typora-photos\redis\image-20200831181905091.png)

主从复制，读写分离！80%的情况下都是在进行读操作！减缓服务器的压力！架构中经常使用！一主二从！

只要在公司中，主从复制就是必须要使用的，因为在真实的项目中不可能单机使用Redis！



### 环境配置

只配置从库，不用配置主库！

```bash
127.0.0.1:6379> info replication		# 查看当前库的信息
# Replication
role:master		# 角色 master
connected_slaves:0	# 没有从机
master_replid:d4de2beb0fee120e1a4d990672b86f69a642d4f0
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0
```

复制三个配置文件，然后修改对应的信息

1、端口

2、pid 名字

3、log 文件名字

4、dump.rdb 名字

修改完毕后，启动3个redis服务器，可以通过进程信息查看！

![image-20200831183730765](D:\Typora-photos\redis\image-20200831183730765.png)



### 一主二从

==默认情况下，每台Redis服务器都是主节点；==我们一般情况下只用配置从机就好了

一主（79）二从（80，81）

```bash
# 在从机中查看！
127.0.0.1:6380> SLAVEOF 127.0.0.1 6379		# slaveof host port 找谁当主机
OK
127.0.0.1:6380> info replication
# Replication
role:slave	# 当前角色是从机
master_host:127.0.0.1	# 可以看到主机的信息
master_port:6379
master_link_status:up
master_last_io_seconds_ago:5
master_sync_in_progress:0
slave_repl_offset:0
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:2cd80b4b1811261fb74b5b0bdc33a8bac6b3b666
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:0

# 在主机中查看
127.0.0.1:6379> info replication
# Replication
role:master
connected_slaves:1		#多了从机的配置
slave0:ip=127.0.0.1,port=6380,state=online,offset=238,lag=1		#多了从机的信息
master_replid:2cd80b4b1811261fb74b5b0bdc33a8bac6b3b666
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:238
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:238
```

如果两个都配置完了，就会有两个从机

![image-20200831184635293](D:\Typora-photos\redis\image-20200831184635293.png)

真实的主从配置应该在配置文件中配置，这样的话是永久的，这里使用的命令知识暂时的！



> 细节

主机可以写，从机不能写只能读！主机中的所有信息和数据，都会自动被从机保存！

主机写：

![image-20200831185552891](D:\Typora-photos\redis\image-20200831185552891.png)

从机只能读取内容！

![image-20200831185625333](D:\Typora-photos\redis\image-20200831185625333.png)



测试：主机断开连接，从机依旧连接到主机的，单是没有写操作，这个时候，如果主机回来了，从机一九可以直接获取到主机写的信息！

如果是使用命令行来配置主从，这个时候如果从机重启了，就会变回主机，不能取到原本主机的值，只要变为从机，立马就会从主机中获取值！



> 复制原理

Slave 启动成功连接到 master 后会发送一个sync同步命令

Master 接到命令，启动后台的存盘进程们同事手机所有接收到的用于修改数据集命令，在后台进程执行完毕后，==master将传送整个数据文件到slave，并完成一次完全同步。==

==全量复制==：而slave服务在接受到数据库文件数据后，将其存盘并加载到内存中。

==增量复制==：Master继续将新的所有收集到的修改命令依次传给slave，完成同步

但是只要是重新连接master，一次完全同步（全量复制）将被自动执行！我们的数据一定可以在从机中看到！



> 层层链路

上一个M链接下一个S！

![image-20200831194022779](D:\Typora-photos\redis\image-20200831194022779.png)

这时候也可以完成主从复制！



> 如果没有了主节点，这个时候能不能选择一个主节点？手动！

如果主机断开了连接，我们可以使用`SLAVEOF no one`让自己变成主机！其他的节点就可以手动连接到最新的这个主节点（手动）！如果这个时候原主机修复了，那就只能重新链接！



### 哨兵模式（自动选举主机的模式）

> 概述

主从切换技术的方法是：当主服务器宕机后，需要手动把一台服务器切换到主服务器，这就需要人工干预，费时费力，还会造成一段时间内服务不可用。这不是一种推荐的方式，更多时候，我们优先考虑哨兵模式。Redis从2.8开始正式提供了Sentinel（哨兵）架构来解决这个问题。

它能够自动切换主服务器，能够后台监控主机是否故障，如果故障了根据投票数==自动将从库转换为主库==。

哨兵模式是一种特殊的模式，首先Redis提供了哨兵的命令，哨兵是一个独立的进程，作为进程，他会独立运行。其原理是**哨兵通过发送命令，等待Redis服务器响应，从而监控运行的多个Redis实例**。

![image-20200831201557658](D:\Typora-photos\redis\image-20200831201557658.png)

这里的哨兵有两个作用

- 通过发送命令，让Redis服务器返回监控器运行状态，包括主服务器和从服务器。

- 当哨兵检测到master宕机，会自动将slave切换成master，然后通过**发布订阅模式**来通知其他从服务器，修改配置文件，让他们切换主机。



然而一个哨兵进程对Redis服务器进行监控，可能会出现问题，为此，我们可以使用多个哨兵进行监控。各个哨兵之间还会进行监控，这样就形成了多哨兵模式。

![image-20200831202008831](D:\Typora-photos\redis\image-20200831202008831.png)

假设主服务器宕机，哨兵1先检测到这个结果，系统并不会马上进行failover（故障转移）过程，仅仅是哨兵1主观任务服务器不可以，这个现象称为**主观下线**。dang后面的哨兵也检测到主服务器不可用，并且达到一定的数量值，那么哨兵之间就会进行一次投票，投票的结果有一个哨兵发起，进行failover操作。切换成功后，就会通过发布订阅模式，将各个哨兵把自己监控的从服务器实现切换逐渐，这个过程称为**客观下线**。



> 测试

目前的状态时 一主二从！

1、配置哨兵配置文件

```bash
# sentinel monitor master-name(自定义) host port 1
sentinel monitor myredis 127.0.0.1 6379 1
```

后面的1表示至少要有1个哨兵确认主机出现故障后才会进行替换。



2、启动哨兵

```bash
[root@hadoop1 bin]# redis-sentinel myconfig/sentinel.conf 
51223:X 31 Aug 2020 20:41:36.075 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
51223:X 31 Aug 2020 20:41:36.075 # Redis version=6.0.6, bits=64, commit=00000000, modified=0, pid=51223, just started
51223:X 31 Aug 2020 20:41:36.075 # Configuration loaded
51223:X 31 Aug 2020 20:41:36.098 * Increased maximum number of open files to 10032 (it was originally set to 1024).
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 6.0.6 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in sentinel mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 26379
 |    `-._   `._    /     _.-'    |     PID: 51223
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

51223:X 31 Aug 2020 20:41:36.099 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
51223:X 31 Aug 2020 20:41:36.116 # Sentinel ID is f93c8a276c4f77f5bee35cf3412f6bb73794fb74
51223:X 31 Aug 2020 20:41:36.116 # +monitor master myredis 127.0.0.1 6379 quorum 1
51223:X 31 Aug 2020 20:41:36.203 * +slave slave 127.0.0.1:6380 127.0.0.1 6380 @ myredis 127.0.0.1 6379
51223:X 31 Aug 2020 20:41:36.205 * +slave slave 127.0.0.1:6381 127.0.0.1 6381 @ myredis 127.0.0.1 6379
```

如果Master节点断开了，这个时候就会从从机中随机选择一个服务器做主机！（这里面有一个投票算法！）

![image-20200831204752864](D:\Typora-photos\redis\image-20200831204752864.png)

哨兵日志！

![image-20200831205038531](D:\Typora-photos\redis\image-20200831205038531.png)

如果主机此时回来了，只能归并到新的主机下，当做从机，这就是哨兵模式的规则！



> 哨兵模式

优点：

1、哨兵集群，基于主从复制模式，所有的主从配置优点，他全有

2、主从可以切换，故障可以转移，系统的可用性就会更好

3、哨兵模式就是主从模式的升级，手动到自动，更加健壮！

缺点：

1、Redis 不好在线扩容的，集群容量一旦到达上限，在线扩容就十分麻烦！

2、实现哨兵模式的配置其实是很麻烦的，里面有很多选择！

> 哨兵模式的全部配置！

```bash
# Example sentinel.conf

# 哨兵sentinel实力运行的端口 默认26379
port 26379

# 哨兵sentinel的工作目录
dir /tmp

# 哨兵sentinel监控redis主节点的ip port
# master-name 可以自己命名的主节点名字 只能由字母A-z、数字0-9、这三个字符“.-_”组成
# quorum 配置多个个sentinel哨兵统一任务master主节点失联 那么这是客观上认为主节点失联了
# sentinel monitor <master-name> <ip> <redis-port> <quorum>
sentinel monitor myredis 127.0.0.1 6379 1

# 当在Redis实例中开启了requirepass foobared 授权密码 这样所有连接Redis实例的客户端都要提供密码
# 设置哨兵sentinel 连接主从的密码 注意必须为主从设置一样的验证密码
# sentinel auth-pass <master-name> <passward>
sentinel auth-pass mymaster 123456

# 指定多少毫秒之后 主节点没有应答哨兵sentinel 此时 哨兵主观上任务主节点下线 默认30秒
# sentinel down-after-milliseconds <master-name> <milliseconds>
sentinel down-after-milliseconds mymaster 30000

# 这个配置项指定了在发生failover主备切换时最多可以由多少个slave同时对新的master进行 同步，
这个数字越小，完成failover所需的时间就越长，
但是如果这个数字越大，就意味着越多的slave因为replication而不可用。
可以通过将这个值设为 1 来保证每次只有一个slave 处于不能处理命令请求的状态
# sentinel parallel-syncs <master-name> <numslave>
sentinel parallel-syncs mymaster 1

# 主张转移的超时时间 failover-timeout 可以用在以下这些方面：
#1.同一个sentinel对同一个master两次failover之间的间隔时间。
#2.当一个slave从一个错误的master那里同步数据开始计算时间。直到slave被纠正为向正确的master那里同步数据时。
#3.当想要取消一个正在进行的failover所需要的时间。
#4.当金星failover时，配置所有slaves指向新的master所需的最大时间。不过，即使过了这个超时，slaves依然会被正确配置为指向master，但是就不按parallel-syncs所配置的规则来了
# 默认三分钟
# sentinel failover-timeout <master-name> <milliseconds>
sentinel failover-timeout mymaster 180000

# SCRIPTS EXECUTION

# 配置当某一事件发生时所需要执行的脚本，可以通过脚本来通知管理员，例如当系统运行不正常时发邮件通知相关人员。
# 对于脚本的运行结果由以下规则：
# 若脚本执行后返回1，那么该坏v恶霸稍后将会被再次执行，重复次数目前默认为10
# 若脚本执行后返回2，或者比2更高的一个返回值，将被将不会重复执行。
# 如果脚本在执行过程中由于收到系统终端信号被终止了，则桶返回值1时的行为相同。
# 一个脚本的最大执行时间为60s，如果超过这个时间，脚本将会被一个SIGKILL信号终止，之后重新执行。

# 通知型脚本：方sentinel由任何警告级别的时间发生时（比如说redis实例的主观失效和客观失效等等），将回去调用这个脚本，这是这个脚本应该通过邮件，SMS等方式去通知系统管理员关于系统不正常运行的信息。调用该脚本时，将传给脚本两个参数，一个时时间的类型，一个时时间的藐视。如果sentinel.conf配置文件中配置了这个脚本路径，那么必须保证这个脚本存在于这个路径，并且时可执行的，否则sentinel无法正常启动成功。
# 通知脚本
# sentinel notification-script <master-name> <script-path>
sentinel notification-script mymaster /var/redis/notify.sh

# 客户端重新配置主节点参数脚本
# 当一个master由于failover而发生改变时，这个脚本将会被调用，通知相关的客户端关于master地址已经发生改变的信息。
# 以下参数将会在调用脚本时传给脚本：
# <master-name> <role> <state> <from-ip> <from-port> <to-ip> <to-port>
# 目前<state>总是“failover”，
# <role>是”leader“或者”observer“中的一个。
# 参数 from-ip，from-port，to-ip，to-port是用来和就得master和新的master（即旧的slave）通信
# 这个脚本应该是通用的，能被多次调用，不是针对性的。
# sentinel client-reconfig-script <master-name> <script-path>
sentinel client-reconfig-script mymaster /var/redis/reconfig.sh	# 一般都是由运维来配置！
```































