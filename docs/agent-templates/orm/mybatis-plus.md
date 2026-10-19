## MyBatis-Plus 规范

- Mapper 继承 `BaseMapper<T>`；Service 接口继承 `IService<T>`，实现类继承 `ServiceImpl<M, T>`。
- 条件构造用 `LambdaQueryWrapper` / `LambdaUpdateWrapper`，禁止用字符串写字段名。
- Wrapper 只在 Service 层构造，不出现在 Controller。
- 主键：`@TableId(type = IdType.ASSIGN_ID)`。
- 逻辑删除：`deleted` 字段加 `@TableLogic`。
- `create_time`、`update_time`、`create_by`、`update_by` 通过 `MetaObjectHandler` 自动填充，业务代码不手动赋值。
- 分页用 `Page<T>`，必须注册 `PaginationInnerInterceptor`。
- 需要并发控制时用 `@Version` + `OptimisticLockerInnerInterceptor`。
- 批量写入用 `saveBatch` / `updateBatchById`，不在循环中单条写入。
- 复杂 SQL 写在 XML 中，不在注解里写长 SQL；XML 中只用 `#{}`，禁止 `${}` 拼接用户输入。
- 禁止无条件的 `selectList(null)` / `update(null, wrapper)` 操作大表。
