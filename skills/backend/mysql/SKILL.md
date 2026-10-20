---
name: mysql
description: MySQL 规范：表与字段命名、必备字段、索引命名、迁移脚本、查询约束。设计表结构、编写 SQL 或数据库迁移脚本时使用。
---

## MySQL 规范

- 表名、字段名小写下划线，表名带业务前缀，如 `user_account`。
- 每张表必须包含：`id`（bigint，雪花 ID）、`create_time`、`update_time`、`create_by`、`update_by`、`deleted`。
- 索引命名：普通索引 `idx_<字段>`，唯一索引 `uk_<字段>`。
- 不建物理外键，关联关系由应用层维护。
- 禁止 `SELECT *`；禁止在循环中查询数据库，改为批量查询。
- 表结构变更必须提交 SQL 脚本，文件名带日期与序号，如 `20261019_01_create_user_account.sql`。
- **CRITICAL**：所有数据库迁移脚本必须经过 review 才能执行。
- 金额用 `decimal`，不用 `float` / `double`。
