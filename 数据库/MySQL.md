# 初识MySQL

### 1.7、连接数据库

命令行连接

```sql
mysql -u root -p password	-- 连接数据库

update mysql.user set authentication_string=password('123456') where user='root' and Host = 'localhost';	-- 修改用户密码

flush privileges;	-- 刷新权限

-----------------------------------------
-- 所有的语句都是用;结尾
show databases;	-- 查看所有的数据库

use school;	-- 切换数据库	use 数据库名

show tables;	-- 查看数据库中所有的表

describe student; -- 显示数据库中某张表的所有信息	describe 表名名

create database westos;	-- 创建一个数据库	create database 数据库名

exit;	-- 退出连接

-- 单行注释

/*	（sql的多行注释）
aaasd
afdsfda
*/
```



数据库的四种语言：

DDL	定义语言

DML	操作语言

DQL	查询语言

DCL 	控制语言



## 2、操作数据库

操作数据库>操作数据库中的表>操作表中的字段

mysql关键字不区分大小写



### 2.1、操作数据库（了解）

1、创建数据库

```sql
CREATE DATABASE IF NOT EXISTS westos
```

2、删除数据库

```sql
DROP DATABASE IF EXISTS westos
```

3、使用数据库

```sql
-- 如果表名或者字段名是一个特殊字符，那么需要带``（该符号为tab 键上面的那个符号）
USE `school`
```

4、查看数据库

```sql
SHOW DATABASES	-- 查看所有的数据库
```



对比：SQLyog的可视化操作

学习思路：

- 对照sqlyog可视化历史记录查看sql！
- 固定的语法或关键字必须要强行记住！



### 2.2、数据库的列类型

> 数值

- tinyint			十分小的数据		1个字节
- smallint         较小的数据            2个字节
- mediumint    中等大小的数据    3个字节
- **int                    标准的整数           4个字节**        常用的         int
- bigint               较大的数据           8个字节
- float                 浮点数                   4个字节
- double             浮点数                   8个字节
- decimal            字符串形式的浮点数         金融计算的时候，一般是使用decimal



> 字符串

- char            字符串固定大小的             0~255
- **varchar       可变字符串                        0~65535**              常用的变量        String
- tinytext       微型文本                            2^8-1
- text              文本串                                2^16-1                 保存大文本



> 时间

java.util.Date



- date                       YYYY--MM--DD，日期格式
- time                        HH：mm：ss     时间格式
- **datetime               YYYY--MM--DD  HH：mm：ss     最常用的时间格式**
- **timestamp             时间戳，          1970.1.1到现在的毫秒数！**    也较为常用！
- year                        年份表示



> null

- 没有值，未知
- ==注意，不要使用NULL进行运算，结果为NULL==



### 2.3、数据库字段属性（重点）

**Unsigned：**

- 无符号整数
- 该列不能声明为负数



**zerofill：**

- 零填充
- 不足的位数，使用0来填充，填充在前面。例：     int(3)         5            005



**自增：**

- 通常理解为自增，自动在上一条的基础上+1(默认)
- 通常用来设计唯一的主键~ index，必须为整数类型
- 可以自定义设计主键自增的起始值和步长



**非空** NULL   not null

- 假设设置为not null，如果不给他赋值，就会报错！
- NUll，如果不填写值，默认就是null！



**默认：**

- 设置默认的值！
- sex，默认值为男，如果不指定该列的值，则会用默认的值！



### 2.4、创建数据库表（重点）

```sql
-- 目标：创建一个school数据库
-- 创建学生表(列，字段)	使用SQL 创建
-- 学号int 登录密码varchar(20) 姓名，性别varchar(2),出生日期(datetime),家庭住址，email

-- 注意点，使用英文()，表的名称和字段尽量使用``括起来
-- AUTO_INCREMENT 自增
-- 字符串使用 单引号括起来！
-- 所有的语句后面加,(英文的)，最后一个不用加
-- 

CREATE TABLE IF NOT EXISTS `student` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '学号',
  `pwd` VARCHAR(20) NOT NULL DEFAULT '123456' COMMENT '密码',
  `name` VARCHAR(20) NOT NULL DEFAULT '匿名' COMMENT '姓名',
  `sex` VARCHAR(2) NOT NULL DEFAULT '女' COMMENT '性别',
  `brithdate` DATETIME DEFAULT NULL COMMENT '出生日期',
  `address` VARCHAR(100) DEFAULT NULL COMMENT '家庭住址',
  `email` VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY(`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8
```

格式

```sql
CREATE TABLE [IF NOT EXISTS] `表名` (
  `字段名` 列类型 [属性] [索引] [注释],
  `字段名` 列类型 [属性] [索引] [注释],
  `字段名` 列类型 [属性] [索引] [注释],
  ...
  `字段名` 列类型 [属性] [索引] [注释]
)[表类型][字符集设置][注释]
```



常用命令

```sql
SHOW CREATE DATABASE school	-- 查看创建数据库的语句
SHOW CREATE TABLE student	-- 查看创建数据表的定义语句
DESC student			-- 显示表的结构
```



### 2.5、数据表的类型

```sql
-- 关于数据库引擎
/*
INNODB 默认使用~
MYISAM 早些年使用的
*/
```

|              | MYISAM | INNODB        |
| ------------ | ------ | ------------- |
| 事务支持     | 不支持 | 支持          |
| 数据行锁定   | 不支持 | 支持          |
| 外键约束     | 不支持 | 支持          |
| 全文索引     | 支持   | 不支持        |
| 表空间的大小 | 较小   | 较大，约为2倍 |

常规使用操作：

- MYISAM	节约空间，速度较块
- INNODB    安全性高，事务的处理，多表多用户操作



> 在物理空间存在的位置

所有的数据库文件都存在data目录下，一个文件夹对应一个数据库

本质还是文件的存储！

MySQL引擎在物理文件上的区别

- InnoDB 在数据库表中只有一个*.frm文件，以及上级目录下的ibdata1 文件
- MYISAM对应文件
  - *.frm      -表结构的定义文件
  - *.MYD    -数据文件（data）
  -  *.MYI     -索引文件（index）



> 设置数据库表的字符集编码

```sql
CHARSET=utf8
```

不设置的话，会是mysql默认的字符集编码~（不支持中文！）

MySQL的默认编码是Latin1，不支持中文。

在my.ini中配置默认的编码（但是不建议那样做，因为如果将数据库转移到其他的不同环境可能会出错。）

```sql
character-set-server=utf8
```



### 2.6、修改删除表

> 修改

```sql
-- 修改表名	ALTER TABLE 旧表名 RENAME AS 新表名
ALTER TABLE teacher RENAME AS teacher1
-- 增加表的字段	ALTER TABLE 表名 ADD 字段名 列属性
ALTER TABLE teacher1 ADD age INT(3)

-- 修改表的字段（重命名，修改约束）
-- ALTER TABLE 表名 MODIFY 字段名 列属性[]
ALTER TABLE teacher1 MODIFY age VARCHAR(11)	-- 修改约束
-- ALTER TABLE 表名 CHANGE 旧字段名 新字段名 列属性[]
ALTER TABLE teacher1 CHANGE `name` `id` VARCHAR(11)	-- 字段重命名

-- 删除表的字段	ALTER TABLE 表名 DROP 字段名
ALTER TABLE teacher1 DROP age
```



> 删除

```sql
-- 删除表（如果表存在再删除）	DROP TABLE 表名
DROP TABLE teacher1
```

==**所有的创建和删除操作尽量加上判断，以免报错**==



注意点：

- ``字段名，使用这个包裹！
- 注释  --  /**/
- sql 关键字大小写不敏感，建议写小写
- 所有的符号全部用英文！





## 3、MySQL数据管理

### 3.1、外键（了解即可）

> 方式一、在创建表的时候，添加约束（麻烦，比较复杂）

```sql
CREATE TABLE IF NOT EXISTS `grade` (
  `gradeid` INT(10) NOT NULL AUTO_INCREMENT COMMENT '年级id',
  `gradename` VARCHAR(50) NOT NULL COMMENT '年级名称',
  PRIMARY KEY(`gradeid`)
)ENGINE=INNODB DEFAULT CHARSET=utf8

-- 学生表的 gradeid 字段要去引用年级表的 gradeid
-- 定义外键key
-- 给这个外键添加约束（执行引用） references 引用

CREATE TABLE IF NOT EXISTS `student` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '学号',
  `pwd` VARCHAR(20) NOT NULL DEFAULT '123456' COMMENT '密码',
  `name` VARCHAR(20) NOT NULL DEFAULT '匿名' COMMENT '姓名',
  `sex` VARCHAR(2) NOT NULL DEFAULT '女' COMMENT '性别',
  `brithdate` DATETIME DEFAULT NULL COMMENT '出生日期',
  `gradeid` INT(10) NOT NULL COMMENT '学生的年级',
  `address` VARCHAR(100) DEFAULT NULL COMMENT '家庭住址',
  `email` VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY(`id`),
  KEY `FK_gradeid` (`gradeid`),
  CONSTRAINT `FK_gradeid` FOREIGN KEY (`gradeid`) REFERENCES `grade`(`gradeid`)
)ENGINE=INNODB DEFAULT CHARSET=utf8
```

删除有外键关系的表的时候，必须要先删除引用别人的表（从表），再删除被引用的表（主表）。



> 方式二、创建表成功后，添加外键

```sql
CREATE TABLE IF NOT EXISTS `grade` (
  `gradeid` INT(10) NOT NULL AUTO_INCREMENT COMMENT '年级id',
  `gradename` VARCHAR(50) NOT NULL COMMENT '年级名称',
  PRIMARY KEY(`gradeid`)
)ENGINE=INNODB DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `student` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '学号',
  `pwd` VARCHAR(20) NOT NULL DEFAULT '123456' COMMENT '密码',
  `name` VARCHAR(20) NOT NULL DEFAULT '匿名' COMMENT '姓名',
  `sex` VARCHAR(2) NOT NULL DEFAULT '女' COMMENT '性别',
  `brithdate` DATETIME DEFAULT NULL COMMENT '出生日期',
  `gradeid` INT(10) NOT NULL COMMENT '学生的年级',
  `address` VARCHAR(100) DEFAULT NULL COMMENT '家庭住址',
  `email` VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY(`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8

-- 创建表的时候没有外键关系
ALTER TABLE `student`
ADD CONSTRAINT `FK_gradeid` FOREIGN KEY(`gradeid`) REFERENCES `grade`(`gradeid`)
```



以上的操作都是物理外键，数据库级别的外键，不建议使用！ （避免数据库过多造成困扰）

==最佳实践==

- 数据库就是单纯的表，只用来存数据，只有行（数据）和列（字段）
- 如果想使用多张表的数据，想使用外键（在程序里实现）



### 3.2、DML语言（全部记住）

**数据库意义：**数据存储，数据管理

DML语言：数据库操作语言

- insert
- update
- delete



### 3.3、添加

> insert

```sql
-- 插入语句（添加）
-- insert into 表名([字段名1，字段2，字段3]) values ('值1','值2','值3', ....)
INSERT INTO `grade`(`gradename`) VALUES('大四')

-- 由于主键自增我们可以省略（如果不写表的字段，他就会一一匹配）
INSERT INTO `grade` VALUES('大三')

-- 一般写插入语句，我们一定要数据和字段一一对应！

-- 插入多个字段
INSERT INTO `grade`(`gradename`) 
VALUES('大三'),('大二'),('大一')

INSERT INTO `student`(`name`) VALUES('张三')

INSERT INTO `student`(`name`,`pwd`,`sex`) VALUES('张三','aaaaaa','男')

INSERT INTO `student`(`name`,`pwd`,`sex`) 
VALUES('李四','bbbbbb','男'),('王五','cccccc','男')
```

语法：`insert into 表名([字段名1，字段2，字段3]) values ('值1','值2','值3', ....)`

注意事项：

1. 字段和字段之间用 英文逗号 隔开
2. 字段是可以省略的，但是后面的值必须要一一对应！
3. 可以同时插入多条数据，VALUES后面的值，需要用逗号隔开`values(),(),(),()...`



### 3.4、修改

> update

```sql
-- 修改学员名字
UPDATE `student` SET `name` = 'yjy' WHERE id = 1

-- 不指定条件的情况下，会改动整张表！
UPDATE `student` SET `name` = '长江7号'

-- 修改多个属性，逗号隔开
UPDATE `student` SET `name`='yjy',`email`='1530474773@qq.com' WHERE id = 1

-- 语法：
-- UPDATE 表名 SET colnum_name = value,[colnum_name = value, ....] WHERE [条件]
```

条件：where子句 运算符 id 等于某个值，大于某个值，在某个值区间内修改...

操作符会返回 布尔值

| 操作符                    | 含义            | 范围        | 结果  |
| ------------------------- | --------------- | ----------- | ----- |
| =                         | 等于            | 5=6         | false |
| <>或!=                    | 不等于          | 5!=6        | true  |
| >                         | 大于            | 5>6         | false |
| <                         | 小于            | 5<6         | true  |
| <=                        | 小于等于        | 5<=6        | true  |
| >=                        | 大于等于        | 5>=6        | false |
| BETWEEN    v1   AND    v2 | 在v1和v2之间    | [v1,v2]     |       |
| AND                       | 和        &&    | 5>1 AND 1>2 | false |
| OR                        | 或         \|\| | 5>1 OR 1>2  | true  |

```sql
-- 通过多个条件定位数据
UPDATE `student` SET `name`='hxh',`email`='1530474773@qq.com' WHERE id<=3 AND sex='女'
```

语法：`UPDATE 表名 SET colnum_name = value,[colnum_name = value, ....] WHERE [条件]`

注意：

- colnum_name 是数据库上的列，尽量带上``
- 条件，筛选的条件，如果没有指定，则会修改所有的列
- value，可以是一个具体的值，也可以是一个变量
- 多个设置的属性之间，使用英文逗号隔开

```sql
UPDATE `student` SET `brithdate`=CURRENT_TIME,`email`='1530474773@qq.com' WHERE `name`='hxh' AND sex='女'
```



### 3.5、删除

> delete

语法：`delete from 表名 [where 条件]`

```sql
-- 删除数据（避免这样写，会全部删除）
DELETE FROM `student`

-- 删除指定数据
DELETE FROM `student` WHERE `id`=1
```



> TRUNCATE

作用：完全清空一个数据库表，表的结构和索引不会改变

```sql
-- 清空 student 表
TRUNCATE `student`
```



> delete 和 TRUNCATE 区别

- 相同点：都能删除数据，而且都不会表结构
- 不同点：
  - TRUNCATE 重新设置 自增列 计数器会归零
  - TRUNCATE 不会影响事务



```sql
-- 测试delete 和 TRUNCATE 区别
CREATE TABLE `test`(
  `id` INT(4) NOT NULL AUTO_INCREMENT,
  `coll` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8


INSERT INTO `test`(`coll`) VALUES('1'),('2'),('3')

DELETE FROM `test`  -- 不会影响自增

TRUNCATE TABLE `test` -- 自增会归零
```

了解即可：`delete删除的问题`，重启数据库，现象

- InnoDB	自增列会从1开始	（存在内存当中的，断电即失）
- MYISAM   继续从上一个自增量开始    （存在文件中的，不会丢失）



## 4、DQL查询数据（最重点）

### 4.1、DQL

(Data Query Language：数据查询语言)

- 所有的查询操作都用它    Select
- 简单的查询，复杂的查询它都能做~
- ==数据库中最核心的语言，最重要的语句==
- 使用频率最高的语言



> Select完整的语法：

```sql
SELECT[ALL|DISTINCT|DISTINCTROW|TOP]
{* | talbe.* | [table.field1[AS alias1][,[table.]field2[AS alias2][,…]]}
FROM table_name[as table_alias]
    [left | right | inner join table2_name]  -- 联合查询
    [WHERE ...]  -- 指定结果满足的条件
    [GROUP BY ...]  -- 指定结果按照那几个字段来分组
    [HAVING ...]  --过滤分组的记录必须满足的次要条件
    [ORDER BY ...]  -- 指定查询记录按一个或多个条件排序
    [LIMIT {[offset,]row_count | row_countOFFSET offset}];  -- 指定查询的记录从哪条至哪条
```

**注意：[]括号代表可选的，{}括号代表必选的**

### 4.2、指定查询字段

```sql
-- 查询全部的学生	SELECT 字段 FROM 表名
SELECT * FROM `student`

-- 查询指定字段
SELECT `studentno`,`studentname` FROM `student`

-- 别名，给结果起一个名字  AS  可以个字段起别名，也可以给表起别名
SELECT `studentno` AS 学号,`studentname` AS 学生姓名 FROM `student` AS s

-- 函数 Concat(a,b) 拼接字符串
SELECT CONCAT('姓名：',`studentname`) AS 新名字 FROM `student`
```

语法：`SELECT 字段 FROM 表名`



> 有的时候，列名字不是那么的见名如意。我们起别名 AS         字段名 as 别名      或        表名 as 别名



> 去重  distinct

作用：去除SELECT 查询出来的结果中重复的数据，重复的数据只显示一条

```sql
-- 查询以下有哪些同学参加了考试，成绩
SELECT * FROM `result`	-- 查询全部的考试成绩
SELECT `studentno` FROM `result`	-- 查询有哪些同学参加了考试
SELECT DISTINCT `studentno` FROM `result` 	-- 发现重复数据，去重
```



> 数据库的列（表达式）

```sql
SELECT VERSION()   -- 查询系统版本 （函数）
SELECT 3*100-1 AS 计算结果   -- 用来计算 （表达式）
SELECT @@auto_increment_increment  -- 查询自增的步长 （变量）

-- 学员考试成绩 +1分查看
SELECT `studentno`,`studentresult`+1 AS 提分后 FROM `result`
```

==数据库中的表达式：文本值，列，null，函数，计算表达式，系统变量....==

select `表达式` from 表名



### 4.3、where 条件子句

作用：检索数据中`符合条件`的值

搜索的条件有一个或多个表达式组成！结果 布尔值

> 逻辑运算符

| 运算符         | 语法                  | 描述                           |
| -------------- | --------------------- | ------------------------------ |
| and     &&     | a and b      a&&b     | 逻辑与，两个都为真，结果为真   |
| or        \|\| | a or b         a\|\|b | 逻辑或，其中一个为真，结果为真 |
| Not     !      | not a           ! a   | 逻辑非，真为假，假为真！       |

==尽量使用英文字母==



```sql
-- ====================  where  =======================
SELECT `studentno`,`studentresult` FROM `result`

-- 查询考试成绩在 95~100 分之间
SELECT `studentno`,`studentresult` FROM `result`
WHERE `studentresult`>=95 AND `studentresult`<=100

-- and  &&
SELECT `studentno`,`studentresult` FROM `result`
WHERE `studentresult`>=95 && `studentresult`<=100

-- 模糊查询（区间）
SELECT `studentno`,`studentresult` FROM `result`
WHERE `studentresult` BETWEEN 95 AND 100

-- 除了1000号学生之外的同学成绩
SELECT `studentno`,`studentresult` FROM `result`
WHERE `studentno`!=1000

-- !=  not
SELECT `studentno`,`studentresult` FROM `result`
WHERE NOT `studentno`=1000
```



> 模糊查询：比较运算符

| 运算符      | 语法                | 描述                                            |
| ----------- | ------------------- | ----------------------------------------------- |
| IS NULL     | a is null           | 如果操作符为NULL，结果为真                      |
| IS NOT NULL | a is not null       | 如果操作符不为NULL，结果为真                    |
| BETWEEN     | a between b and c   | 若a 在b 和c 之间，则结果为真                    |
| Like        | a like b            | SQL匹配，如果a匹配b，则记过为真                 |
| In          | a in (a1,a2,a3....) | 假设a在a1，或者a2....其中的某一个值中，结果为真 |

```sql
-- =================  模糊查询  =================
-- ========  like  =========
-- 查询姓刘的同学
-- like结合  %（代表0到任意个字符）  _（一个字符） 通配符只能在like中使用
SELECT `studentno`,`studentname` FROM `student` 
WHERE `studentname` LIKE '刘%'

-- 查询姓刘的同学，名字后面只有一个字的
SELECT `studentno`,`studentname` FROM `student` 
WHERE `studentname` LIKE '刘_'

-- 查询姓刘的同学，名字后面只有两个字的
SELECT `studentno`,`studentname` FROM `student` 
WHERE `studentname` LIKE '刘__'

-- 查询名字中有强字的同学 %强%
SELECT `studentno`,`studentname` FROM `student` 
WHERE `studentname` LIKE '%强%'

-- ========  in（具体的一个或者多个值）  ==========
-- 查询1001，1002，1003号学员
SELECT `studentno`,`studentname` FROM `student` 
WHERE `studentno` IN (1001,1002,1003)

-- 查询在深圳的学生
SELECT `studentno`,`studentname` FROM `student` 
WHERE `address` IN ('广东深圳')

-- =========== null   not null =============
-- 查询地址为空的学生  null  ''
SELECT `studentno`,`studentname` FROM `student` 
WHERE `address` IS NULL OR `address`=''

-- 查询有出生日期的同学   不为空
SELECT `studentno`,`studentname` FROM `student` 
WHERE `borndate` IS NOT NULL

-- 查询没有出生日期的同学   为空
SELECT `studentno`,`studentname` FROM `student` 
WHERE `borndate` IS NULL
```



### 4.4、联表查询

> JOIN对比

![image-20200913160555194](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200913160555194.png)



```sql
-- ======================== 连表查询 join ========================

-- 查询参加了考试的同学（学号，姓名，科目编号，分数）
SELECT studentNo,studentName FROM `student`
SELECT subjectNo,studentResult FROM `result`

/* 思路
1.分析需求，分析查询的字段来自于哪些表，（连接查询）
2.确定使用哪种连接查询？
确定交叉点（这两个表中哪个数据是相同的）
判断的条件：学生表中的studentNo = 成绩表中的studentNo
*/
-- join（连接的表） on（判断的条件） 连接查询
-- where   等值查询
SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
INNER JOIN `result` AS r
ON s.studentNo = r.studentNo

SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
INNER JOIN `result` AS r
WHERE s.studentNo = r.studentNo

-- Right Join
SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
RIGHT JOIN `result` AS r
ON s.studentNo = r.studentNo

-- Left Join
SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
LEFT JOIN `result` AS r
ON s.studentNo = r.studentNo
```

| 操作       | 描述                                       |
| ---------- | ------------------------------------------ |
| Inner join | 如果表中至少一个匹配，就返回行             |
| Left join  | 会从左表中返回所有的值，即使右表种没有匹配 |
| Right join | 会从右表中返回所有的值，即使左表种没有匹配 |

```sql
-- ======================== 连表查询 join ========================

-- 查询参加了考试的同学（学号，姓名，科目编号，分数）
SELECT studentNo,studentName FROM `student`
SELECT subjectNo,studentResult FROM `result`

/* 思路
1.分析需求，分析查询的字段来自于哪些表，（连接查询）
2.确定使用哪种连接查询？
确定交叉点（这两个表中哪个数据是相同的）
判断的条件：学生表中的studentNo = 成绩表中的studentNo
*/
-- join（连接的表） on（判断的条件） 连接查询
-- where   等值查询
SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
INNER JOIN `result` AS r
ON s.studentNo = r.studentNo

SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
INNER JOIN `result` AS r
WHERE s.studentNo = r.studentNo

-- Right Join
SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
RIGHT JOIN `result` AS r
ON s.studentNo = r.studentNo

-- Left Join
SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
LEFT JOIN `result` AS r
ON s.studentNo = r.studentNo

-- 查询缺考的同学
SELECT s.studentNo,studentName,subjectNo,studentResult
FROM `student` AS s
LEFT JOIN `result` AS r
ON s.studentNo = r.studentNo
WHERE studentResult IS NULL

-- 思考题（查询了参加考试的同学信息：学号，学生姓名，科目名，分数）
/*
1.涉及到的表有`student` as s，`result` as r，`subject` as sub （三张表）
2.判断条件: s.studentNo = r.studentNo, r.subjectNo = sub.subjectNo
*/
SELECT s.studentNo,studentName,subjectName,studentResult
FROM `student` AS s
RIGHT JOIN `result` AS r
ON s.studentNo = r.studentNo
INNER JOIN `subject` AS sub
ON r.subjectNo = sub.subjectNo

-- 我要查询哪些数据 select ...
-- 从哪几张表中查 FROM 表 XXX Join 连接的表 on 交叉条件
-- 假设存在一种多张表查询，慢慢来，先查询两张表，然后再慢慢增加
```



> 自连接（了解）

==自己的表和自己的表连接，核心：一张表拆为两张一样的表即可==

父类

| categoryid | categoryName |
| ---------- | ------------ |
| 2          | 信息技术     |
| 3          | 软件开发     |
| 5          | 美术设计     |
|            |              |

子类

| pid  | categoryid | categoryName |
| ---- | ---------- | ------------ |
| 3    | 4          | 数据库       |
| 2    | 8          | 办公信息     |
| 3    | 6          | web开发      |
| 5    | 7          | ps技术       |

操作：查询父类对应的子类关系

| 父类     | 子类     |
| -------- | -------- |
| 信息技术 | 办公信息 |
| 发       | 数据库   |
| 软件开发 | web开发  |
| 美术设计 | ps技术   |

```sql
SELECT c1.`categoryName` AS 父栏目,c2.`categoryName` AS 子栏目
FROM `category` AS c1,`category` AS c2
WHERE c1.`categoryid` = c2.`pid`
```



### 4.5、分页和排序

> 排序

```sql
-- 排序：升序 ASC，降序DESC
-- ORDER BY 通过哪个字段排序，怎么排
-- 查询的结果根据 成绩降序 排序
SELECT s.`studentno`,`studentname`,`subjectname`,`studentresult`
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
WHERE subjectname = '数据库结构-1'
ORDER BY `studentresult` DESC
```



> 分页

```sql
-- 100万
-- 为什么要分页
-- 环节数据库压力，给人的体验更好

-- 分页，煤业只显示五条数据
-- 语法：limit 起始值，页面大小
-- LIMIT 0,3	1~3
-- LIMIT 1,3	2~4
-- LIMIT 4,3	4~7
SELECT s.`studentno`,`studentname`,`subjectname`,`studentresult`
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
WHERE subjectname = '数据库结构-1'
ORDER BY `studentresult` DESC
LIMIT 0,3

-- 第一页 limit 0,3	(1-1)*3
-- 第二页 limit 0,3	(2-1)*3
-- 第三页 limit 0,3	(3-1)*3
-- 第N页  limit 0,3	(n-1)* pageSize,pageSize
-- 【pageSize：页面大小】
-- 【(n-1)* pageSize：起始值】
-- 【n：当前页】
-- 【数据总数/页面大小 = 总页数】
```

语法：`limit(查询起始下标,pageSize)`



### 4.6、子查询

where（这个值十计算出来的）

本质：`在where语句中嵌套一个子查询语句`

```sql
-- ================== where ====================

-- 1、查询 数据库结构-1 的所有考试结果（学号，科目编号，成绩），降序排序
-- 方式一：使用连接查询
SELECT `studentno`,r.`subjectno`,`studentresult`
FROM `result` AS r
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
WHERE sub.`subjectname` = '数据库结构-1'
ORDER BY `studentresult` DESC


-- 方式二：使用子查询（由里到外）
-- 先查询 数据库结构-1 的课程编号，再查看与课程编号对应的同学的信息
SELECT `studentno`,`subjectno`,`studentresult`
FROM `result`
WHERE `subjectno` = (SELECT `subjectno` FROM `subject` WHERE `subjectname`='数据库结构-1')
ORDER BY `studentresult` DESC

-- 查询课程为 高等数学-2 且分数不小于 80 的同学的学号和姓名
SELECT s.`studentno`,`studentname` 
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
WHERE `subjectname` = '高等数学-2' AND `studentresult`>=80

-- 初改造
-- 分数不小于80分的学生的学号和姓名
SELECT s.`studentno`,`studentname` 
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
WHERE `studentresult`>=80

-- 在上面的基础上增加一个科目，高等数学-2
SELECT s.`studentno`,`studentname` 
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
WHERE `studentresult`>=80 AND `subjectno` = (
	SELECT `subjectno` FROM `subject` WHERE `subjectname`='高等数学-2'
)

-- 再改造
SELECT `studentno`,`studentname` 
FROM `student`
WHERE `studentno` IN (
	SELECT `studentno` 
	FROM `result` 
	WHERE `studentresult`>=80 
	AND `subjectno` = (SELECT `subjectno` FROM `subject` WHERE `subjectname`='高等数学-2')
) 

-- 练习：查询 C语言-1 前五名同学成绩的信息（学号，姓名，分数）
-- 方式一：连接查询
SELECT s.`studentno`,`studentname`,`studentresult`
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
WHERE `subjectname`='C语言-1'
ORDER BY `studentresult` DESC
LIMIT 0,5

-- 方式二：子查询
SELECT s.`studentno`,`studentname`,`studentresult`
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
WHERE `subjectno` = (
	SELECT `subjectno`
	FROM `subject`
	WHERE `subjectname` = 'C语言-1'
)
ORDER BY `studentresult` DESC
LIMIT 0,5 
```



### 4.7、分组和过滤

```sql
-- 查询不同课程的平均分，最高分，最低分，平均分大于75
-- 核心：（根据不同的课程分组）
SELECT `subjectname` AS 课程名,AVG(`studentresult`) AS 平均分,MAX(`studentresult`) AS 最高分,MIN(`studentresult`) AS 最低分
FROM `result` AS r
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
GROUP BY `subjectname`  -- 按照哪个字段进行分组
HAVING 平均分 > 75
```



## 5、MySQL函数

官网：https://dev.mysql.com/doc/refman/8.0/en/sql-function-reference.html

### 5.1、常用函数

```sql
-- =========================== 常用函数==========================

-- 数学运算
SELECT ABS(-8)  -- 绝对值
SELECT CEILING(9.4) -- 向上取整
SELECT FLOOR(9.4)  -- 向下取整
SELECT RAND()  -- 返回一个0~1之间的随机数
SELECT SIGN(10)  -- 判断一个数的符号，0返回0，负数返回-1，正数返回1

-- 字符串函数
SELECT CHAR_LENGTH('即使再小的帆也能远航')  -- 字符串长度
SELECT CONCAT('I',' Love',' You')  -- 拼接字符串
SELECT INSERT('我爱编程helloworld',1,2,'超级热爱')  -- 查询，从某个位置开始替换某个长度
SELECT LOWER('YjY')  -- 小写字母
SELECT UPPER('HxH')  -- 大写字母
SELECT INSTR('yjy','j')  -- 返回第一次出现的字串的索引
SELECT REPLACE('坚持就能成功','坚持','努力')  -- 替换出现的指定字符串
SELECT SUBSTR('坚持就能成功',2,3)  -- 返回指定的子字符串 (源字符串，截取的位置，截取的长度)
SELECT REVERSE('坚持就能成功')  -- 反转

-- 时间和日期函数（记住）
SELECT CURRENT_DATE() -- 获取当前日期
SELECT CURDATE()  -- 获取当前日期
SELECT NOW()  -- 获取当前的时间
SELECT LOCALTIME()  -- 本地时间
SELECT SYSDATE()  -- 系统时间

SELECT YEAR(NOW())
SELECT MONTH(NOW())
SELECT DAY(NOW())
SELECT HOUR(NOW())
SELECT MINUTE(NOW())
SELECT SECOND(NOW())  

-- 系统
SELECT SYSTEM_USER()
SELECT USER()
SELECT VERSION()
```



### 5.2、聚合函数

| 函数名称 | 描述   |
| -------- | ------ |
| COUNT()  | 计数   |
| SUM()    | 求和   |
| AVG()    | 平均值 |
| MAX()    | 最大值 |
| MIN()    | 最小值 |
| ......   | ...... |



```sql
-- ================== 聚合函数 ==================
-- 都能够统计 表中的数据（想查询一个表中有多少给记录，就是用这个count()）
SELECT COUNT(`borndate`) FROM student; -- Count(指定列)，会忽略所有的 null 值
SELECT COUNT(*) FROM student; -- Count(*)，不会忽略所有的 null 值，本质 计算行数
SELECT COUNT(1) FROM student; -- Count(1)，不会忽略所有的 null 值，本质 计算行数

SELECT SUM(`studentresult`) AS 总和 FROM `result`
SELECT AVG(`studentresult`) AS 平均分 FROM `result`
SELECT MAX(`studentresult`) AS 最高分 FROM `result`
SELECT MIN(`studentresult`) AS 最低分 FROM `result`
```



### 5.3、数据库级别的MD5加密（扩展）

什么是MD5？

主要增强算法复杂度和不可逆性。

MD5 不可逆，具体的值的 md5 是一样的，所以当我们用了MD5加密后，我们验证时是将输入的密码通过MD5加密后再进行对比。

MD5 破解网站的原理，背后是一个字典，里面存储了MD5加密后的值和加密前的值，当匹配到MD5的值之后会返回原值，所以一些比较复杂的密码那些网站是没办法破解出来的。



```sql
-- =============== 测试MD5 加密 =================
CREATE TABLE `testmd5`(
  `id` INT(4) NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `pwd` VARCHAR(50) NOT NULL,
  PRIMARY KEY(`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8

-- 明文密码
INSERT INTO `testmd5`
VALUES(1,'zhangsan','123456'),(2,'lisi','123456'),(3,'wangwu','123456')

-- 加密
UPDATE `testmd5` SET pwd=MD5(`pwd`) -- 加密全部的密码

-- 插入的时候加密
INSERT INTO `testmd5`
VALUES(4,'xiaoming',MD5('123456'))

-- 如何校验：将用户传递进来的密码，进行md5加密，然后对比加密后的值
SELECT * FROM `testmd5` WHERE `name`='xiaoming' AND `pwd`=MD5('123456')
```



## 6、事务

6.1、什么是事务

——————

1、SQL执行   A 给B 转账      A  1000         ----->    200         B  200

2、SQL执行   B 收到 A的钱     A 800         ------->   B  400

——————

将一组SQL放在一个批次中去执行~



> 事务原则：ACID原则  原子性，一致性，隔离性，持久性          （脏读，幻读.......）

参考博客连接：https://blog.csdn.net/dengjili/article/details/82468576

**原子性（Atomicity）**

要么都成功，要么都失败



**一致性（Consistency）**

事务前后数据完整性要保证一致



**隔离性（Isolation）**

事务的隔离性是多个用户并发访问数据库时，数据库为每一个用户开启的事务，不能被其他事务的操作数据所干扰，多个并发事务之间要相互隔离



**持久性（Durability）**

事务一旦提交则不可逆，被持久化到数据库中！



> 隔离所导致的问题

**脏读：**

指一个事务读取了另外一个事务未提交的数据。



**不可重复读：**

在一个事务内读取表中的某一行数据，多次读取结果不同。（这个不一定是错误，只是某些场合不对）



**虚读（幻读）：**

是指在一个事务内读取到了别的事务插入的数据，导致前后读取不一致。（一般是行影响，多了一行）



> 执行事务

```sql
-- ==================== 事务 ========================

-- mysql 是默认开启事务自动提交的
SET autocommit = 0 /* 关闭 */
SET autocommit = 1 /* 关闭（默认的） */

-- 手动处理事务

-- 事务开启
START TRANSACTION  -- 标记一个事务的开始，从这个之后的 sql 都在同一个事务内

INSERT xx
INSERT xx

-- 提交：持久化（成功）
COMMIT
-- 回滚：回到原来的样子（失败）
ROLLBACK

-- 事务结束
SET autocommit = 1 -- 开启自动提交

-- 了解
SAVEPOINT 保存点名 -- 设置一个事务的保存点
ROLLBACK TO SAVEPOINT 保存点名 -- 回滚到保存点
RELEASE SAVEPOINT 保存点名 -- 撤销保存点 
```



> 模拟场景

```sql
-- 转账
CREATE DATABASE shop CHARACTER SET utf8 COLLATE utf8_general_ci
USER shop

CREATE TABLE `account`(
  `id` INT(3) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `money` DECIMAL(9,2) NOT NULL,
  PRIMARY KEY(`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT INTO `account`(`name`,`money`)
VALUES ('A',2000.00),('B',20000.00)

-- 模拟转账：事务
SET autocommit = 0; -- 关闭自动提交
START TRANSACTION -- 开启一个事务（一组事务）

UPDATE `account` SET `money`=`money`-500 WHERE `name` = 'A' -- A减500
UPDATE `account` SET `money`=`money`+500 WHERE `name` = 'B' -- B加500

COMMIT;
ROLLBACK;

SET autocommit = 1; -- 恢复默认值
```



## 7、索引



### 7.1、索引分类

> 在一个表中，主键索引只能有一个，唯一索引可以有多个

- 主键索引（PRIMARY KEY）
  - 唯一的标识，主键不可重复，只能由一个列作为主键
- 唯一索引（UNIQUE KEY）
  - 避免重复的列出现，唯一索引可以重复，多个列都可以标识为 唯一索引
- 常规索引（KEY）
  - 默认的，index。key关键字来设置
- 全文索引（FullText）
  - 在特定的数据库引擎才有，MyISM
  - 快速定位数据



基础语法：

```sql
-- 索引的使用
-- 1、在创建表的时候给字段增加索引
-- 2.创建完毕后，增加索引

-- 显示所有的索引信息
SHOW INDEX FROM `student`

-- 增加一个全文索引  （索引名） 列名
ALTER TABLE `student` ADD FULLTEXT INDEX `studentname`(`studentname`)

-- EXPLAIN 分析sql执行的状况

EXPLAIN SELECT * FROM `student`; -- 非全文索引

EXPLAIN SELECT * FROM `student` WHERE MATCH(`studentname`) AGAINST('刘');
```



### 7.2、测试索引

```sql
CREATE TABLE `app_user`(
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) DEFAULT '' COMMENT '用户昵称',
  `email` VARCHAR(50) NOT NULL COMMENT '用户邮箱',
  `phone` VARCHAR(20) DEFAULT '' COMMENT '手机号',
  `gender` TINYINT(4) UNSIGNED DEFAULT '0' COMMENT '性别（0：男；1：女）',
  `password` VARCHAR(100) NOT NULL COMMENT '密码',
  `age` TINYINT(4) DEFAULT '0' COMMENT '年龄',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY(`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='app用户表'


SET GLOBAL log_bin_trust_function_creators = 1;

-- 插入100万数据
DELIMITER $$ -- 写函数之前必须要写，标志
CREATE FUNCTION mock_data()
RETURNS INT
BEGIN
  DECLARE num INT DEFAULT 1000000;
  DECLARE i INT DEFAULT 0;
  WHILE i<num DO
    INSERT INTO `app_user`(`name`,`email`,`phone`,`gender`,`password`,`age`) VALUES(CONCAT('用户',i),'24736743qq.com',CONCAT('18',FLOOR(RAND()*((999999999-100000000)+100000000))),FLOOR(RAND()*2),UUID(),FLOOR(RAND()*100));
    SET i = i+1;
  END WHILE;
  RETURN i;
END;
SELECT mock_data();

SELECT * FROM `app_user` WHERE `name`='用户9999'; -- 0.947 sec
SELECT * FROM `app_user` WHERE `name`='用户9999'; -- 1.129 sec
SELECT * FROM `app_user` WHERE `name`='用户9999'; -- 0.988 sec

EXPLAIN SELECT * FROM `app_user` WHERE `name`='用户9999';

-- id_表名_字段名
-- CREATE INDEX 索引名 ON 表名(字段名)
CREATE INDEX id_app_user_name ON `app_user`(`name`);

SELECT * FROM `app_user` WHERE `name`='用户9999'; -- 0 sec
SELECT * FROM `app_user` WHERE `name`='用户9999'; -- 0 sec
SELECT * FROM `app_user` WHERE `name`='用户9999'; -- 0 sec
```

加索引前：

![image-20200914170600856](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914170600856.png)

加索引后：

![image-20200914170630447](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914170630447.png)



==索引在小数据的时候，用户不大，但是大数据的时候，区别十分明显==



### 7.3、索引原则

- 索引不是越多越好
- 不要对经常变动的数据加索引
- 小数据量的表不需要加索引
- 索引一般加在常用来查询的字段上



> 索引的数据结构

参考网址：http://blog.codinglabs.org/articles/theory-of-mysql-index.html

Hash 类型的索引

Btree：InnoDB 默认的数据结构~



## 8、权限管理与备份

### 8.1、用户管理

> SQL yog 可视化管理

![image-20200914171911190](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914171911190.png)



> SQL 命令操作

用户表：mysql.user

本质：对这张表进行增删改查

```sql
- ====================== 用户权限管理 ==========================

-- 创建用户 CREATE USER 用户名 IDENTIFIED BY [WITH mysql_native_password] '密码'。
-- 如果使用的是mysql8.0，最好加上 WITH mysql_native_password，因为SQLyog的加密方式与mysql8.0不一样，所以连接时会出现密码乱码的情况
CREATE USER yjy IDENTIFIED WITH mysql_native_password BY '123456'

-- 修改密码（修改当前用户密码）
SET PASSWORD = PASSWORD('123456') -- mysql 5.7可以使用。8.0不可以，因为password字段和 password函数被删除了。

-- 修改密码（修改指定用户密码）
SET PASSWORD FOR yjy = PASSWORD('123456') -- mysql 5.7之前可使用，8.0不可以。

-- 通用的修改密码 ALTER USER 用户名@Host IDENTIFIED [WITH mysql_native_password] BY '123456';
ALTER USER 'yjy'@'%' IDENTIFIED BY '123456'; -- 通用

-- 重命名 RENAME USER 原来名字 TO 新的名字
RENAME USER yjy TO yjy2

-- 用户授权 ALL PRIVILEGES 全部的权限， 库.表
-- ALL PRIVILEGES 除了给别人授权，其他都能够干
GRANT ALL PRIVILEGES ON *.* TO yjy2

-- 查询权限
SHOW GRANTS FOR yjy2

-- Root用户权限：GRANT PROXY ON ''@'' TO 'root'@'localhost' WITH GRANT OPTION
SHOW GRANTS FOR root@localhost

-- 撤销权限 REVOKE 哪些权限 ON 哪个库的哪个表 FROM 指定对象
REVOKE ALL PRIVILEGES ON *.* FROM yjy2

-- 删除用户 DROP USER 用户名
DROP USER yjy2
```

**注意：MySQL5.7 与 MySQL8.0存在一些差异。如：MySQL8.0已经将password字段以及password函数删除掉了。**



### 8.2、MySQL 备份

为什么要备份：

- 保证重要的数据不丢失
- 数据转移



MySQL 数据库备份的方式：

- 直接拷贝物理文件

- 在Sqlyog 这种可视化工具中手动导出

  - 在想要导出的表或数据库，右键，选择备份和导出

  ![image-20200914200215571](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914200215571.png)

- 使用命令行导出 mysqldump 命令行使用

```bash
# mysqldump -h 主机 -u 用户 -p 密码（-p与密码之间不能有空格） 数据库名 表名 > 存储路径		导出一张表
mysqldump -h localhost -u root -p123456 school student > D:/a.sql
mysqldump: [Warning] Using a password on the command line interface can be insecure.

# 或mysqldump -h 主机 -u 用户 -p（后面需要输入密码） 数据库名 表名 > 存储路径
mysqldump -h localhost -u root -p school student > D:/a2.sql
Enter password: ************

# mysqldump -h 主机 -u 用户 -p 密码（-p与密码之间不能有空格） 数据库名 表名1 表名2 表名3 > 存储路径		导出多张表
mysqldump -h localhost -u root -p123456 school student result > D:/a.sql

# mysqldump -h 主机 -u 用户 -p 密码（-p与密码之间不能有空格） 数据库名 > 存储路径		导出数据库
mysqldump -h localhost -u root -p123456 school > D:/a.sql

# 导入
# 登录的情况下，切换到指定的数据库下，如果导入数据库直接导入即可，无需切换数据库
# source 备份文件路径
source d:/a.sql

mysql -u用户名 -p密码 库数据名 <  备份文件路径
```

假设你要被封数据库，防止数据丢失。

把数据库给朋友！sql文件给别人即可！



## 9、规范数据库设计

### 9.1、为什么需要设计

当数据库比较复杂的时候，我们就需要设计了

**糟糕的数据库设计：**

- 数据冗余，浪费空间
- 数据库插入和删除都会麻烦、异常【屏蔽使用物理外键】
- 程序的性能差

**良好的数据库设计：**

- 节省内存空间
- 保证数据库的完整性
- 方便我们开发系统

**软件开发中，关于数据库的设计**

- 分析需求：分析业务和需要处理的数据库的需求
- 概要设计：设计关系图 E-R图



**设计数据库的步骤：（个人博客）**

- 收集信息，分析需求
  - 用户表（用户登录注销，用户的个人信息，写博客，创建分类）
  - 分类表（文章分类，谁创建的）
  - 文章表（文章的信息）
  - 评论表
  - 友链表（友链信息）
  - 自定义表（系统信息，某个关键的字，或者一些主字段） key：value
- 标识实体（把需求落地到每个字段）
- 标识实体 之间的关系
  - 写博客：user --> blog
  - 创建博客：user --> category
  - 关注：user -->user
  - 友链：links
  - 评论：user - user - blog



### 9.2、三大范式

**为什么需要数据规范化？**

- 信息重复
- 更新异常
- 插入异常
  - 无法正常显示信息
- 删除异常
  - 丢失有效的信息



> 三大范式（了解）

**第一范式（1NF）**

要求数据库表的每一列都是不可分割的原子数据项。（俗话：保证每一列不可再拆分）

举例说明：

![image-20200914211156961](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914211156961.png)

在上面的表中，“家庭信息”和“学校信息”列均不满足原子性的要求，故不满足第一范式，调整如下：

![image-20200914211207892](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914211207892.png)

可见，调整后的每一列都是不可再分的，因此满足第一范式（1NF）；



**第二范式（2NF）**

前提：满足第一范式

确保数据库表中的每一列都和主键相关，而不能只与主键的某一部分相关（每张表只描述一件事情）

举例说明：

![image-20200914211732743](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914211732743.png)

在上图所示的情况中，同一个订单中可能包含不同的产品，因此主键必须是“订单号”和“产品号”联合组成，

但可以发现，产品数量、产品折扣、产品价格与“订单号”和“产品号”都相关，但是订单金额和订单时间仅与“订单号”相关，与“产品号”无关，

这样就不满足第二范式的要求，调整如下，需分成两个表：

 ![image-20200914211749588](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914211749588.png)![image-20200914211810693](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914211810693.png)



**第三范式（3NF）**

前提：蛮子第一范式 和 第二范式

第三范式需要确保数据表中的每一列数据都和主键直接相关，而不能间接相关。

举例说明：

![image-20200914212543036](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914212543036.png)

上表中，所有属性都完全依赖于学号，所以满足第二范式，但是“班主任性别”和“班主任年龄”直接依赖的是“班主任姓名”，

而不是主键“学号”，所以需做如下调整：

![image-20200914212603258](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914212603258.png) ![image-20200914212631474](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914212631474.png)

这样以来，就满足了第三范式的要求。



（规范数据库的设计）

**规范性 和 性能的问题**

关联查询的表不得超过三张

- 考虑商业胡的需求和目标，（成本，用户体验！）数据库的性能更重要
- 再规范性能得问题得时候，需要适当得考虑一下 规范性！
- 故意给某些表增加一些冗余的字段。（从多表查询中变为单表查询）
- 故意增加一些计算列（从大数据量降低为小数据量的查询：索引）



## 10、JDBC（重点）

### 10.1、数据库驱动

驱动：声卡，显卡，数据库。

![image-20200914220134309](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914220134309.png)

我们的程序会通过 数据库 驱动，和数据库打交道！



### 10.2、JDBC

SUN公司为了简化 开发人员的（对数据库的统一）操作，提供了一个（Java操作数据库的）规范，俗称 JDBC 

这些规范的实现有具体的厂商去做

对于开发人员来说，我们只需要掌握JDBC 接口的操作即可！

![image-20200914220525994](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200914220525994.png)

java.sql

javax.sql

还需要导入一个数据库驱动包，mysql-connector-java-8.0.20.jar



### 10.3、第一个JDBC 程序

> 创建测试数据库

```sql
CREATE DATABASE jdbcStudy CHARACTER SET utf8 COLLATE utf8_general_ci;

USE jdbcStudy;

CREATE TABLE `users`(
id INT PRIMARY KEY,
NAME VARCHAR(40),
PASSWORD VARCHAR(40),
email VARCHAR(60),
birthday DATE
);

INSERT INTO `users`(id,NAME,PASSWORD,email,birthday)
VALUES(1,'zhangsan','123456','zs@sina.com','1980-12-04'),
(2,'lisi','123456','lisi@sina.com','1981-12-04'),
(3,'wangwu','123456','wangwu@sina.com','1979-12-04')
```



1、创建一个普通项目

2、导入数据库驱动

![image-20200915094356274](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200915094356274.png)

3、编写测试代码

```java
// 我的第一个JDBC程序
public class JDBCTest01 {

    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        //1.加载驱动
        //新版驱动为：com.mysql.cj.jdbc.Driver，旧版：com.mysql.jdbc.Driver
        Class.forName("com.mysql.cj.jdbc.Driver");//固定写法，加载驱动
        

        //2.用户信息和url
        // useUnicode=true          支持中文
        // characterEncoding=utf8   编码格式
        // useSSL=true              开启安全协议
        // 不知道是个人原因还是什么，本人在连接数据库时需要设置时区，如果不设置会报错。serverTimezone=GMT%2B8
        String url = "jdbc:mysql://localhost:3306/jdbcStudy?useUnicode=true&characterEncoding=utf8&useSSL=true&serverTimezone=GMT%2B8";
        String username = "root";
        String password = "love19980920";

        //3.连接成功，数据库对象
        Connection connection = DriverManager.getConnection(url, username, password);

        //4.执行SQL的对象
        Statement statement = connection.createStatement();

        //5.执行SQL的对象，去执行SQL，可能存在结果，查看返回结果
        String query = "SELECT * FROM `users`";
        ResultSet resultSet = statement.executeQuery(query);
        while (resultSet.next()){
            System.out.println("============================================");
            System.out.println("id=" + resultSet.getObject("id"));
            System.out.println("name=" + resultSet.getObject("NAME"));
            System.out.println("pwd=" + resultSet.getObject("PASSWORD"));
            System.out.println("email=" + resultSet.getObject("email"));
            System.out.println("birthday=" + resultSet.getObject("birthday"));
        }

        //6.释放连接
        resultSet.close();
        statement.close();
        connection.close();

    }

}
```

步骤总结：

1、加载驱动

2、连接数据库 DriverManager

3、获取执行sql的对象

4、获得返回的结果集

5、释放连接



> DriverManager

```java
// DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
Class.forName("com.mysql.cj.jdbc.Driver");//固定写法，加载驱动
Connection connection = DriverManager.getConnection(url, username, password);

// Connection 代表数据库
// 数据库设置自动提交
// 事务提交
// 事务回滚
connection.setAutoCommit();
connection.commit();
connection.rollback();
```



> URL

```java
String url = "jdbc:mysql://localhost:3306/jdbcStudy?useUnicode=true&characterEncoding=utf8&useSSL=true&serverTimezone=GMT%2B8";

// mysql -- 3306
// jdbc:mysql://主机:端口号/数据库名?参数1&参数2&参数3

// oralce -- 1521
// jdbc:oracle:thin:@localhost:1521:sid
```



> Statement 执行SQL的对象	PrepareStatement 执行SQL的对象    

```java
String query = "SELECT * FROM `users`";

statement.execute();// 查询操作返回 resultSet
statement.executeQuery();// 执行任何SQL
statement.executeUpdate();// 更新、插入‘删除。都是用这个，返回一个受影响的行数。
```



> ResultSet 查询的结果集：封装了所有的查询结果

获取指定的数据类型

```sql
resultSet.getObject();// 在不知道列类型的情况下使用
// 如果知道列的类型就使用指定的类型
resultSet.getInt();
resultSet.getString();
resultSet.getFloat();
resultSet.getDate();
```

遍历，指针

```java
resultSet.beforeFirst();// 移动到最前面
resultSet.afterLast();// 移动到最后面
resultSet.next();// 移动到下一个数据
resultSet.previous();// 移动到前一行
resultSet.absolute(row);// 移动到指定行 
```



> 释放资源

```java
resultSet.close();
statement.close();
connection.close();
```



### 10.4、statement对象

==jdbc中的statement对象用于向数据库发送SQL语句，想完成对数据库的增删改查，只需要通过这个对象向数据库发送增删改查语句即可。==

Statement对象的executeUpdate方法，用于向数据库发送增、删、改的sql语句，executeUpdate执行完后，将会返回一个整数（即增删改语句导致了数据库几行数据发生了变化）。

Statement.executeQuery方法用于向数据库发送查询语句，executeQuery方法返回代表查询结果的ResultSet对象。



> CRUD操作-create

使用executeUpdate(String sql)方法完成数据添加操作，示例操作：

```java
Statement st = conn.createStatement();
String sql = "insert into user(...) values(...)";
int num = st.executeUpdate(sql);
if (num>0){
    System.out.println("插入成功！！！")
}
```



>CRUD操作-delete

使用executeUpdate(String sql)方法完成数据删除操作，示例操作：

```java
Statement st = conn.createStatement();
String sql = "delete from user where id=1";
int num = st.executeUpdate(sql);
if (num>0){
    System.out.println("删除成功！！！")
}
```



> CRUD操作-update

使用executeUpdate(String sql)方法完成数据修改操作，示例操作：

```java
Statement st = conn.createStatement();
String sql = "update user set name=’‘ where name=’‘";
int num = st.executeUpdate(sql);
if (num>0){
    System.out.println("修改成功！！！")
}
```



> CRUD操作-read

使用executeQuery(String sql)方法完成数据查询操作，示例操作：

```java
Statement st = conn.createStatement();
String sql = "select * from user where id=1";
ResultSet rs = st.executeQuery(sql);
while (re.next()){
    //根据获取列的数据类型，分别调用rs的相应方法映射到java对象中
}
```



> 代码实现

1、提取工具类

```java
public class JDBCUtils {

    private static String driver = null;
    private static String url = null;
    private static String username = null;
    private static String password = null;

    static {
        try {
            InputStream in = JDBCUtils.class.getClassLoader().getResourceAsStream("db.properties");
            Properties properties = new Properties();
            properties.load(in);

            driver = properties.getProperty("driver");
            url = properties.getProperty("url");
            username = properties.getProperty("username");
            password = properties.getProperty("password");

            // 1.驱动只用加载一次
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //获取连接
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url,username,password);
    }

    //释放连接
    public static void release(Connection conn, Statement st, ResultSet rs)  {
        if (rs!=null) {
            try {
                rs.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        if (st!=null) {
            try {
                st.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        if (conn!=null) {
            try {
                conn.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }

}
```



2、编写增删改的方法，`executeUpdate`

增

```java
public class TestCreate {

    private static Connection conn = null;
    private static Statement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();
            st = conn.createStatement();
            String sql = "INSERT INTO `users` VALUES(4,'yjy','123456','yjy@qq.com','1998-09-20')";
            int num = st.executeUpdate(sql);
            if (num>0) {
                System.out.println("成功插入数据！！！");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```

删

```java
public class TestDelete {

    private static Connection conn = null;
    private static Statement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();
            st = conn.createStatement();
            String sql = "DELETE FROM `users` WHERE id=4";
            int num = st.executeUpdate(sql);
            if (num>0) {
                System.out.println("成功删除数据！！！");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```

改

```java
public class TestUpdate {

    private static Connection conn = null;
    private static Statement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();
            st = conn.createStatement();
            String sql = "UPDATE `users` SET `PASSWORD` = '111111' WHERE id=4";
            int num = st.executeUpdate(sql);
            if (num>0) {
                System.out.println("成功修改数据！！！");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



3、查询`executeQuery`

```java
public class TestQuery {

    private static Connection conn = null;
    private static Statement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();
            st = conn.createStatement();
            String sql = "SELECT * FROM `users` WHERE id=4";
            rs = st.executeQuery(sql);
            while (rs.next()) {
                System.out.println("============================================");
                System.out.println("id=" + rs.getInt("id"));
                System.out.println("name=" + rs.getString("NAME"));
                System.out.println("pwd=" + rs.getString("PASSWORD"));
                System.out.println("email=" + rs.getString("email"));
                System.out.println("birthday=" + rs.getDate("birthday"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



> SQL 注入的问题

sql 存在漏洞，会被攻击导致数据泄露，==SQL会被拼接 or==

```java
public class SQL注入 {

    public static void main(String[] args) {
        // 正常登录
        //login("zhangsan","123456");
        login("' or '1=1","' or '1=1");
    }

    //登录业务
    public static void login(String username, String password) {
        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtils.getConnection();
            st = conn.createStatement();
            String sql = "SELECT * FROM `users` WHERE `NAME`='" + username + "' AND `PASSWORD`='" + password + "'";
            rs = st.executeQuery(sql);
            while (rs.next()) {
                System.out.println("============================================");
                System.out.println("id=" + rs.getInt("id"));
                System.out.println("name=" + rs.getString("NAME"));
                System.out.println("pwd=" + rs.getString("PASSWORD"));
                System.out.println("email=" + rs.getString("email"));
                System.out.println("birthday=" + rs.getDate("birthday"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



### 10.5、PreparedStatement对象

PreparedStatement 可以防止SQL注入。效率更好！

1、新增

```java
public class TestCreate {

    private static Connection conn = null;
    private static PreparedStatement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();

            // 区别
            // 使用? 占位符代替参数
            String sql = "INSERT INTO `users` VALUES(?,?,?,?,?)";
            st = conn.prepareStatement(sql);    // 预编译SQL，先写sql，然后不执行
            // 手动给参数赋值
            st.setInt(1,4); // id
            st.setString(2,"yjy");  // 用户名
            st.setString(3,"123456");   // 密码
            st.setString(4,"yjy@qq.com");   // 邮箱
            // 注意点：sql.Date     数据库     java.sql.Date()
            //        util.Date    Java      new Date().getTime() 获得时间戳
            st.setDate(5,new java.sql.Date(new Date().getTime()));  // 时间

            // 执行
            int num = st.executeUpdate();
            if (num>0) {
                System.out.println("成功插入数据！！！");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



2、删除

```java
public class TestDelete {

    private static Connection conn = null;
    private static PreparedStatement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();

            // 区别
            // 使用? 占位符代替参数
            String sql = "DELETE FROM `users` WHERE id=?";
            st = conn.prepareStatement(sql);    // 预编译SQL，先写sql，然后不执行
            // 手动给参数赋值
            st.setInt(1,4);  // id

            // 执行
            int num = st.executeUpdate();
            if (num>0) {
                System.out.println("成功删除数据！！！");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



3、更新

```java
public class TestUpdate {

    private static Connection conn = null;
    private static PreparedStatement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();

            // 区别
            // 使用? 占位符代替参数
            String sql = "UPDATE `users` SET `PASSWORD` = ? WHERE id=?";
            st = conn.prepareStatement(sql);    // 预编译SQL，先写sql，然后不执行
            // 手动给参数赋值
            st.setString(1,"111111"); // 密码
            st.setInt(2,4);  // id

            // 执行
            int num = st.executeUpdate();
            if (num>0) {
                System.out.println("成功修改数据！！！");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



4、查询

```java
public class TestQuery {

    private static Connection conn = null;
    private static PreparedStatement st = null;
    private static ResultSet rs = null;

    public static void main(String[] args) {
        try {
            conn = JDBCUtils.getConnection();

            // 区别
            // 使用? 占位符代替参数
            String sql = "SELECT * FROM `users` WHERE `id`=?";
            st = conn.prepareStatement(sql);    // 预编译SQL，先写sql，然后不执行
            // 手动给参数赋值
            st.setInt(1,1);  // id

            // 执行
            rs = st.executeQuery();
            while (rs.next()) {
                System.out.println("============================================");
                System.out.println("id=" + rs.getInt("id"));
                System.out.println("name=" + rs.getString("NAME"));
                System.out.println("pwd=" + rs.getString("PASSWORD"));
                System.out.println("email=" + rs.getString("email"));
                System.out.println("birthday=" + rs.getDate("birthday"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



5、防止SQL注入

```java
public class SQL注入 {

    public static void main(String[] args) {
        // 正常登录
        //login("zhangsan","123456");
        login("'' or 1=1","'' or 1=1");
    }

    //登录业务
    public static void login(String username, String password) {
        Connection conn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtils.getConnection();
            // PreparedStatement 防止SQL注入的本质，把传进来的参数当作字符
            // 假设其中存在转义字符，比如说 ' 会被直接转义
            String sql = "SELECT * FROM `users` WHERE `NAME`=? AND `PASSWORD`=?";   // Mybatis

            st = conn.prepareStatement(sql);
            st.setString(1,username);
            st.setString(2,password);

            rs = st.executeQuery(); // 查询完毕会返回一个结果集
            while (rs.next()) {
                System.out.println("============================================");
                System.out.println("id=" + rs.getInt("id"));
                System.out.println("name=" + rs.getString("NAME"));
                System.out.println("pwd=" + rs.getString("PASSWORD"));
                System.out.println("email=" + rs.getString("email"));
                System.out.println("birthday=" + rs.getDate("birthday"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn, st, rs);
        }
    }

}
```



### 10.6、事务

==要么都成功，要么都失败==

> ACID原则

原子性：要么都成功，要么都失败

一致性：总数不变

隔离性：多个进程互不干扰

持久性：一旦提交不可逆，持久化到数据库了



隔离性的问题：

脏读：一个事务读取了另一个没有提交的事务

不可重复读：在同一个事务内，重复读取表中的数据，表数据发生了改变

虚读（幻读）：在一个事务内，读取到了别人插入的数据，导致前后读出来结果不一致



> 事务测试

```java
public class TestTransaction02 {

    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtils.getConnection();
            // 关闭数据库的自动提交，自动会开启事务
            conn.setAutoCommit(false);// 开启事务

            String sql1 = "update account set money=money-100 where name='A'";
            st = conn.prepareStatement(sql1);
            st.executeUpdate();

            int x = 1/0;

            String sql2 = "update account set money=money+100 where name='B'";
            st = conn.prepareStatement(sql2);
            st.executeUpdate();

            conn.commit();
            System.out.println("成功！！");

        } catch (Exception e) {
            //如果失败，则默认回滚
//            try {
//                conn.rollback();
//            } catch (SQLException throwables) {
//                throwables.printStackTrace();
//            }
            e.printStackTrace();
        } finally {
            JDBCUtils.release(conn,st,rs);
        }
    }

}
```



10.7、数据库连接池

数据库连接 --- 执行完毕 --- 释放

连接 --- 释放 十分浪费系统资源

**池化技术：准备一些预先的资源，过来就连接预先准备好的**



最小连接数：10

最大连接数：15

等待超时：100ms



== 编写连接池，实现一个接口DataSource==



> 开源数据源实现

DBCP

C3P0

Druid：阿里巴巴



使用了这些数据库连接池之后，我们在项目开发中就不需要编写连接数据库的代码了！



> DBCP

需要使用到的jar包

commons-dbcp-1.4.jar、commons-pool-1.6.jar



> C3P0

需要使用到的jar包

c3p0-0.9.5.5.jar、mchange-commons-java-0.2.20.jar



> 结论

无论使用什么数据源，本质还是一样的，DataSource接口不会变，方法就不会变



Druid

Apache

![image-20200915223558328](https://github.com/tz-feng/myStudy/blob/main/Typora-photos/mysql/image-20200915223558328.png)