-- 查询全部的学生	SELECT 字段 FROM 表名
SELECT * FROM `student`

-- 查询指定字段
SELECT `studentno`,`studentname` FROM `student`

-- 别名，给结果起一个名字  AS  可以个字段起别名，也可以给表起别名
SELECT `studentno` AS 学号,`studentname` AS 学生姓名 FROM `student` AS s

-- 函数 Concat(a,b) 拼接字符串
SELECT CONCAT('姓名：',`studentname`) AS 新名字 FROM `student`

-- 查询以下有哪些同学参加了考试，成绩
SELECT * FROM `result`	-- 查询全部的考试成绩
SELECT `studentno` FROM `result`	-- 查询有哪些同学参加了考试
SELECT DISTINCT `studentno` FROM `result` 	-- 发现重复数据，去重

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

CREATE TABLE `category`( 
  `categoryid` INT(10)UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主题id', 
  `pid` INT(10) NOT NULL COMMENT '父id', 
  `categoryName` VARCHAR(50) NOT NULL COMMENT '主题名字', 
  PRIMARY KEY (`categoryid`) 
) ENGINE=INNODB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8

INSERT INTO `category` (`categoryid`, `pid`, `categoryname`) 
VALUES ('2', '1', '信息技术'),
('3', '1', '软件开发'),
('4', '3', '数据库'),
('5', '1', '美术设计'),
('6', '3', 'web开发'),
('7', '5', 'ps技术'),
('8', '2', '办公信息');

-- 查询父子信息：把一张表堪为两个一模一样的表
SELECT c1.`categoryName` AS 父栏目,c2.`categoryName` AS 子栏目
FROM `category` AS c1,`category` AS c2
WHERE c1.`categoryid` = c2.`pid`

-- 查询学员所属的年级（学号，学生姓名，年级名称）
SELECT s.`studentno`,`studentname`,`gradename`
FROM `student` AS s
INNER JOIN`grade` AS g
ON s.`gradeid` = g.`gradeid`

-- 查询科目所属的年级（科目名称，年级名称）
SELECT `subjectname`,`gradename`
FROM `subject` AS sub
INNER JOIN`grade` AS g
ON sub.`gradeid` = g.`gradeid`

-- 查询了参加 数据库结构-1 考试的同学信息：学号，学生姓名，科目名，分数
SELECT s.`studentno`,`studentname`,`subjectname`,`studentresult`
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
WHERE subjectname = '数据库结构-1'

-- ================= 分页 limit  和排序 order by=================

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

-- 思考：查询 Java程序设计-1 课程成绩排名前三的学生，并且分数要大于80 的学生信息（学号，姓名，课程名称，分数） 
SELECT s.`studentno`,`studentname`,`subjectname`,`studentresult`
FROM `student` AS s
INNER JOIN `result` AS r
ON s.`studentno` = r.`studentno`
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
WHERE `subjectname` = 'Java程序设计-1' AND `studentresult`>80
ORDER BY `studentresult` DESC
LIMIT 0,3

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

-- ================== 聚合函数 ==================
-- 都能够统计 表中的数据（想查询一个表中有多少给记录，就是用这个count()）
SELECT COUNT(`borndate`) FROM student; -- Count(指定列)，会忽略所有的 null 值
SELECT COUNT(*) FROM student; -- Count(*)，不会忽略所有的 null 值，本质 计算行数
SELECT COUNT(1) FROM student; -- Count(1)，不会忽略所有的 null 值，本质 计算行数

SELECT SUM(`studentresult`) AS 总和 FROM `result`
SELECT AVG(`studentresult`) AS 平均分 FROM `result`
SELECT MAX(`studentresult`) AS 最高分 FROM `result`
SELECT MIN(`studentresult`) AS 最低分 FROM `result`

-- 查询不同课程的平均分，最高分，最低分，平均分大于75
-- 核心：（根据不同的课程分组）
SELECT `subjectname` AS 课程名,AVG(`studentresult`) AS 平均分,MAX(`studentresult`) AS 最高分,MIN(`studentresult`) AS 最低分
FROM `result` AS r
INNER JOIN `subject` AS sub
ON r.`subjectno` = sub.`subjectno`
GROUP BY `subjectname`  -- 按照哪个字段进行分组
HAVING 平均分 > 75


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


-- 测试索引
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

-- ====================== 用户权限管理 ==========================

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

-- ================================= JDBC 测试 ===============================
-- 创建测试数据库
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

-- 测试SQL
SELECT * FROM `users`

INSERT INTO `users` VALUES(4,'yjy','123456','yjy@qq.com','1998-09-20')

UPDATE `users` SET `PASSWORD` = '111111' WHERE id=4

SELECT * FROM `users` WHERE `NAME`='zhangsan' AND `PASSWORD`='123456'

DELETE FROM `users` WHERE id=4



















