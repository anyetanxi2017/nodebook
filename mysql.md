
# 创建数据库
```
CREATE DATABASE  `wordpress` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
# 递归查询下级ID
```
DELIMITER //
CREATE FUNCTION `queryChildList`(rootId INT)
    RETURNS varchar(1000)
    READS SQL DATA
BEGIN
    DECLARE sTemp VARCHAR(1000);
    DECLARE sTempChd VARCHAR(1000);
    SET sTemp = '';
    SET sTempChd = cast(rootId as CHAR);
    WHILE sTempChd is not null
        DO
            SET sTemp = concat(sTemp, ',', sTempChd);
            SELECT group_concat(id) INTO sTempChd FROM us_user where FIND_IN_SET(pid, sTempChd) > 0;
        END WHILE;
    RETURN sTemp;
END //
DELIMITER ;

```
