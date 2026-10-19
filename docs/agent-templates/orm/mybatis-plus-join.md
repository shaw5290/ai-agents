## MyBatis-Plus-Join 规范

- 需要联表的 Mapper 继承 `MPJBaseMapper<T>`。
- 联表查询用 `MPJLambdaWrapper<T>`，字段全部用方法引用：

```java
MPJLambdaWrapper<Order> w = new MPJLambdaWrapper<Order>()
        .selectAll(Order.class)
        .selectAs(User::getName, OrderVO::getUserName)
        .leftJoin(User.class, User::getId, Order::getUserId)
        .eq(Order::getStatus, status);
List<OrderVO> list = orderMapper.selectJoinList(OrderVO.class, w);
```

- 联表结果映射到 VO / DTO，不映射到 `entity`。
- 分页用 `selectJoinPage(page, VO.class, wrapper)`。
- 单次联表不超过 3 张表；更复杂的查询写 XML。
- 只能联同一数据库内的表；跨服务数据通过接口获取。
