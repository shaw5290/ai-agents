## 项目概述

epost-integration-service：快递服务商集成服务，通过策略模式对接多家快递服务商（如 EMS）。

## 技术栈

| 技术 | 版本 |
|---|---|
| Java | 17 |
| Spring Boot | 3.2.12 |
| Spring Cloud | 2023.0.5 |
| Spring Cloud Alibaba | 2023.0.1.2（Nacos） |
| MyBatis-Plus | 3.5.x |
| MySQL | 8.0.33 |
| Redis | 7.2.1 |
| Nacos | 2.2.3 |
| Maven | 3.9.1 |
| Git | 2.43.0 |

- 可选数据源：SQLite 3.45+（单机便携）/ PostgreSQL 14+，通过 Spring profile 切换，默认 H2。
- 依赖版本统一在父 POM 中定义；禁止引入未批准的第三方依赖。

## 工作约束

- 不执行任何命令，只修改代码；所有命令由用户手动执行。
- 严禁修改需求以外的代码。
- 修改代码后同步修改对应文档。
- 需求补充后，按新需求修改代码。
- 修改后检查并修复代码规范和语法错误。
- 前端页面用内置浏览器测试，确保功能正常。

## 代码规范

- UTF-8、LF 换行、4 空格缩进（禁止 Tab），每行不超过 120 字符。
- 命名：类 PascalCase 名词；方法 camelCase 动词；常量 UPPER_SNAKE_CASE；包名全小写域名反转，如 `org.example.express`；接口以 `I` 开头或用 `-able` 后缀。
- 类结构顺序：package → import → 类 Javadoc → 静态常量 → 实例变量（按访问级别）→ 构造方法 → 公共方法 → 私有方法。
- **import 禁止重新排序**，新增的 import 全部追加在已有 import 语句之后。
- 方法内不写全限定类名（如 `java.util.Base64`），在类顶部 import。
- 用 Lombok 生成 getter / setter / toString / equals / hashCode，不手写。
- 字符串、日期、文件等常用处理用 Hutool，不手写。
- 不用魔法值、不硬编码。
- 类、公共方法、字段必须写中文 Javadoc，说明功能、参数、返回值、异常。
- 有全局异常处理，方法最外层不写 try-catch；禁止捕获 `Exception` 后不处理；异常信息带上下文并记录日志。
- 使用 SLF4J（`@Slf4j`），不使用 JDK 日志；关键流程多记录日志。级别：`DEBUG` 调试（生产关闭）、`INFO` 关键业务流程、`WARN` 需关注不影响业务、`ERROR` 影响业务运行。

## 架构

分层：Controller → Service → Strategy → Mapper → Domain。

| 层 | 职责 | 禁止 |
|---|---|---|
| Controller | 接收请求、参数校验、响应封装 | 直接操作数据库、写业务逻辑 |
| Service | 业务逻辑、事务管理、策略调度 | 直接处理 HTTP 请求 |
| Strategy | 快递服务商差异化处理 | 数据持久化 |
| Mapper | MyBatis-Plus 数据访问 | 业务逻辑 |

- 快递服务商差异用策略模式；策略由工厂动态获取；公共流程用模板方法封装。

```
org.example.express
├── configs/          # @Configuration
├── controller/       # @RestController
├── domain/           # 实体
├── dto/              # 数据传输对象
├── factory/          # 策略工厂
├── mapper/           # MyBatis Mapper
├── service/
│   └── impl/
├── strategy/         # 策略接口与实现
└── exception/        # 异常类
```

## 数据库

- 表名小写下划线，前缀 `t_`，如 `t_ems_order`；字段小写下划线。
- 索引名 `idx_<表名>_<字段>`，如 `idx_ems_order_order_no`。
- 主键 `BIGINT` 自增。
- `create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP`；`update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`。
- 逻辑删除字段 `del_flag TINYINT NOT NULL DEFAULT 0`。
- Mapper 加 `@Mapper`；实体用 `@TableName`、`@TableField` 映射并继承 `BaseEntity`；查询条件用 Lambda 构造。

## 配置

- 配置由 Nacos 管理，按 dev / test / prod 分离；敏感配置用 `${}` 引用环境变量。
- 优先级：命令行参数 > 环境变量 > Nacos > 本地 `application.yml`。
- 快递服务商在 `express.carriers.<编码>` 下配置，`appKey`、`appSecret` 用环境变量注入：

```yaml
express:
  carriers:
    ems_internal:
      name: EMS公司内下单
      enabled: true
      apiUrl: https://api.ems.com
      appKey: ${EMS_APP_KEY}
      appSecret: ${EMS_APP_SECRET}
      timeout: 30000
      maxRetry: 3
```

- `enabled: false` 的服务商在启动时被过滤，不纳入策略列表，调用返回“不支持的快递公司编码”；未配置 `enabled` 视为启用。

## 接口

- 资源名用名词复数；`GET` 查询、`POST` 创建、`PUT` 整体更新、`PATCH` 部分更新、`DELETE` 删除。
- 版本放在路径中：`/api/v1/express/orders`；旧版本保留一段时间后废弃。
- 统一响应：`{ "code": 200, "message": "success", "data": {}, "timestamp": 1779874767000 }`。
- 错误码：200 成功、400 参数错误、401 未登录或 Token 失效、403 无权限、404 资源不存在、500 系统内部错误、503 依赖服务不可用。
- 参数用 `@Valid` 校验类型和长度。
- 所有接口做权限校验，使用 JWT 认证，配置访问频率限制，走 HTTPS。

## 测试

- 覆盖率：核心业务代码单元测试 ≥ 80%；集成测试覆盖关键流程；API 测试覆盖所有接口。
- 测试类 `{ClassName}Test`，测试方法 `test{MethodName}_{Scenario}`。
- 使用测试专用数据库，测试数据互相独立，测试后清理。

## Git

- 分支：`main`（稳定）、`develop`（集成）、`feature/{名}`、`bugfix/{bug-id}`、`hotfix/{issue-id}`。
- 提交信息 `<type>(<scope>): <subject>`，可附 body、footer；type 取 `feat`、`fix`、`docs`、`style`、`refactor`、`test`、`chore`。
- 合并到 `develop` 前必须代码审查，至少 1 位评审人批准，审查代码质量、安全性、合规性。

## 部署

- 环境：dev、test、prod，各用独立数据库。
- Docker 使用官方基础镜像，镜像标签用语义化版本，最小化镜像体积，以非 root 用户运行。
- 配置 Spring Actuator 健康检查端点，容器启动时做健康检查。
- 定期扫描并更新存在漏洞的依赖。
