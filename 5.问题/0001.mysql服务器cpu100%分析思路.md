## 解决方法
当cpu到达100%时，进入服务器>>>进入mysql反复输入命令`show full processlist;`

查看mysql正在执行些什么操作导致cpu 100%

如果是查询sql导致的，就找到具体是哪个，看这条sql条件是否加索引了。没有就去加，加上就好了。


## 解决 MYSQL CPU 占用 100% 总结
增加 tmp_table_size 值。mysql 的配置文件中，tmp_table_size 的默认大小是 32M。如果一张临时表超出该大小，MySQL产生一个 The table tbl_name is full 形式的错误，如果你做很多高级 GROUP BY 查询，增加 tmp_table_size 值。 这是 mysql 官方关于此选项的解释：
```
tmp_table_size
This variable determines the maximum size for a temporary table in memory. If the table becomes too large, a MYISAM table is created on disk. Try to avoid temporary tables by optimizing the queries where possible, but where this is not possible, try to ensure temporary tables are always stored in memory. Watching the processlist for queries with temporary tables that take too long to resolve can give you an early warning that tmp_table_size needs to be upped. Be aware that memory is also allocated per-thread. An example where upping this worked for more was a server where I upped this from 32MB (the default) to 64MB with immediate effect. The quicker resolution of queries resulted in less threads being active at any one time, with all-round benefits for the server, and available memory.
```

对 WHERE, JOIN, MAX(), MIN(), ORDER BY 等子句中的条件判断中用到的字段,应该根据其建立索引 INDEX。

索引被用来快速找出在一个列上用一特定值的行。没有索引，MySQL不得不首先以第一条记录开始并然后读完整个表直到它找出相关的行。表越大，花费时间越多。

如果表对于查询的列有一个索引，MySQL能快速到达一个位置去搜寻到数据文件的中间，没有必要考虑所有数据。如果一个表有1000行，这比顺序读取至少快100倍。所有的MySQL索引(PRIMARY、UNIQUE和INDEX)在B树中存储。

根据 mysql 的开发文档，索引 index 用于：
1. 快速找出匹配一个WHERE子句的行
2. 当执行联结(JOIN)时，从其他表检索行。
3. 对特定的索引列找出MAX()或MIN()值
4. 如果排序或分组在一个可用键的最左面前缀上进行(例如，ORDER BY key_part_1,key_part_2)，排序或分组一个表。如果所有键值部分跟随DESC，键以倒序被读取。
5. 在一些情况中，一个查询能被优化来检索值，不用咨询数据文件。如果对某些表的所有使用的列是数字型的并且构成某些键的最左面前缀，为了更快，值可以从索引树被检索出来。

> https://blog.csdn.net/eclothy/article/details/50946405
