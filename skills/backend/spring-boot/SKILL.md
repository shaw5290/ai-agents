---
name: spring-boot
description: Spring Boot 规范：分层、代码风格、RESTful 接口与统一返回、事务、配置与日志、构建测试。编写或修改 Spring Boot 后端代码时使用。
---

## Spring Boot 规范

### 分层

- `controller` → `service`（接口 + `impl`）→ `mapper` → 数据库。
- Controller 只做参数校验、调用 Service、组装返回，不写业务逻辑。
- `entity` 对应表，`dto` 用于入参和服务间传输，`vo` 用于出参。禁止把 `entity` 直接返回给前端。

### 代码风格

- UTF-8、LF 换行、4 空格缩进，每行不超过 120 字符。
- getter / setter / toString / equals / hashCode 用 Lombok 生成，不手写。
- 字符串、日期、集合、文件等常用处理用 Hutool，不手写工具方法。
- 类在文件顶部 import，方法内不写全限定类名。
- 不用魔法值，定义为常量或枚举后引用。
- 类、公共方法、字段写中文 Javadoc，说明功能、参数、返回值、异常。

### 接口

- RESTful，路径小写中划线：`/api/v1/user-addresses/{id}`。
- 资源名用名词复数；`GET` 查询、`POST` 创建、`PUT` 整体更新、`PATCH` 部分更新、`DELETE` 删除。
- **IMPORTANT**：API 响应必须包含错误码，统一返回 `R<T>`：`{ "code": 0, "msg": "ok", "data": ... }`；分页返回 `PageResult<T>`。
- 业务异常抛 `BizException(错误码)`，由全局异常处理器（`@RestControllerAdvice`）转换；Controller 中不 try-catch 吞异常。
- 方法最外层不包 try-catch；捕获异常必须处理，日志带上下文信息。
- 入参用 `jakarta.validation` 注解校验，Controller 参数加 `@Valid` / `@Validated`。

### 事务

- `@Transactional(rollbackFor = Exception.class)` 加在 Service 方法上，不加在 Controller 上。
- 事务内不做远程调用、不发消息、不做耗时 IO。
- 同类内部方法调用不会触发事务代理，需要时拆到其他 Bean。

### 配置与日志

- 环境配置拆分为 `application-{profile}.yml`，本地开发用 `dev`。
- 使用 SLF4J（`@Slf4j`），禁止 `System.out` / `printStackTrace`。
- 日志级别：`DEBUG` 调试（生产关闭）、`INFO` 关键业务流程、`WARN` 需关注但不影响业务、`ERROR` 影响业务正常运行。
- 依赖注入用构造器注入（`@RequiredArgsConstructor` + `final` 字段），不用字段 `@Autowired`。

### 构建与测试

- Maven 多模块时只构建/测试受影响模块：`mvn -pl <模块> -am test`。
- 单个测试：`mvn -pl <模块> test -Dtest=类名#方法名`。
- 测试类命名 `{类名}Test`，测试方法命名 `test{方法名}_{场景}`。
