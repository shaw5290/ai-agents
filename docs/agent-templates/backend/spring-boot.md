## Spring Boot 规范

### 分层

- `controller` → `service`（接口 + `impl`）→ `mapper` → 数据库。
- Controller 只做参数校验、调用 Service、组装返回，不写业务逻辑。
- `entity` 对应表，`dto` 用于入参和服务间传输，`vo` 用于出参。禁止把 `entity` 直接返回给前端。

### 接口

- RESTful，路径小写中划线：`/api/v1/user-addresses/{id}`。
- 统一返回 `R<T>`：`{ "code": 0, "msg": "ok", "data": ... }`；分页返回 `PageResult<T>`。
- 业务异常抛 `BizException(错误码)`，由全局异常处理器（`@RestControllerAdvice`）转换；Controller 中不 try-catch 吞异常。
- 入参用 `jakarta.validation` 注解校验，Controller 参数加 `@Valid` / `@Validated`。

### 事务

- `@Transactional(rollbackFor = Exception.class)` 加在 Service 方法上，不加在 Controller 上。
- 事务内不做远程调用、不发消息、不做耗时 IO。
- 同类内部方法调用不会触发事务代理，需要时拆到其他 Bean。

### 配置与日志

- 环境配置拆分为 `application-{profile}.yml`，本地开发用 `dev`。
- 使用 SLF4J（`@Slf4j`），禁止 `System.out` / `printStackTrace`。
- 依赖注入用构造器注入（`@RequiredArgsConstructor` + `final` 字段），不用字段 `@Autowired`。

### 构建与测试

- Maven 多模块时只构建/测试受影响模块：`mvn -pl <模块> -am test`。
- 单个测试：`mvn -pl <模块> test -Dtest=类名#方法名`。
