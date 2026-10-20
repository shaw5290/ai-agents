---
name: mybatis-flex
description: MyBatis-Flex 规范：Mapper 与 Service 继承、主键、逻辑删除、审计字段、TableDef 查询、分页。使用 MyBatis-Flex 编写数据访问代码时使用。
---

## MyBatis-Flex 规范

- 不与 MyBatis-Plus 混用。
- Mapper 继承 `com.mybatisflex.core.BaseMapper<T>`；Service 接口继承 `IService<T>`，实现类继承 `ServiceImpl<M, T>`。
- 实体用 `@Table("表名")`；主键 `@Id(keyType = KeyType.Generator, value = KeyGenerators.snowFlakeId)`。
- 逻辑删除：`@Column(isLogicDelete = true)`；乐观锁：`@Column(version = true)`。
- 审计字段通过 `@Table(onInsert = ..., onUpdate = ...)` 监听器填充，业务代码不手动赋值。
- 查询使用 APT 生成的 `TableDef` 构造 `QueryWrapper`，禁止用字符串写字段名：

```java
QueryWrapper qw = QueryWrapper.create()
        .select(ORDER.ALL_COLUMNS, USER.NAME.as("userName"))
        .from(ORDER)
        .leftJoin(USER).on(USER.ID.eq(ORDER.USER_ID))
        .where(ORDER.STATUS.eq(status));
List<OrderVO> list = orderMapper.selectListByQueryAs(qw, OrderVO.class);
```

- 分页用 `paginate(Page.of(pageNum, pageSize), queryWrapper)`。
- 联表结果映射到 VO / DTO，不映射到 `entity`。
- `QueryWrapper` 只在 Service 层构造，不出现在 Controller。
- 禁止无条件的全表查询、全表更新。
