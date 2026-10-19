# CLAUDE.md

## 项目概述

LinliGo 是多端项目：Spring Boot + Spring Cloud 微服务后端、Web 端、uni-app 小程序端。

## 技术栈

| 层 | 选型 |
|---|---|
| 语言 | Java 17+ |
| 后端框架 | Spring Boot 3.x、Spring Cloud |
| 注册/配置中心 | Nacos（待定） |
| 网关 | Spring Cloud Gateway |
| 服务调用 | OpenFeign + LoadBalancer |
| 限流熔断 | Sentinel（待定） |
| ORM | MyBatis-Plus（待定） |
| 数据库 | MySQL 8 |
| 缓存 | Redis |
| 消息队列 | RocketMQ / RabbitMQ（待定） |
| 鉴权 | Spring Security + JWT / Sa-Token（待定） |
| 构建 | Maven 多模块 |
| Web 前端 | Vue 3 + Vite + TypeScript（待定） |
| 小程序 | uni-app（Vue 3） |
| 部署 | Docker / Docker Compose |

## 目录结构

```
LinliGo/
├── linligo-server/              # 后端 Maven 父工程
│   ├── linligo-common/          # 工具类、统一返回、异常、常量
│   ├── linligo-api/             # Feign 接口与 DTO
│   ├── linligo-gateway/         # 路由、鉴权、跨域、限流
│   ├── linligo-auth/            # 登录、令牌签发
│   └── linligo-modules/         # 业务微服务
│       ├── linligo-user/
│       └── ...
├── linligo-web/                 # Web 前端
├── linligo-uniapp/              # uni-app 小程序
├── deploy/                      # docker-compose、Nginx、SQL 脚本
└── docs/                        # 设计文档、接口文档、AI 文档模板
```

- 新增模块命名为 `linligo-xxx`。
- 包名：`com.linligo.<服务名>.<层>`。
- 服务名：`linligo-<服务>`。
- SQL 变更脚本放 `deploy/sql/`。

## 常用命令

```bash
# 后端（linligo-server/）
mvn clean install -DskipTests
mvn -pl linligo-modules/linligo-user -am spring-boot:run
mvn test

# Web 前端（linligo-web/）
pnpm install && pnpm dev
pnpm build
pnpm lint

# 小程序（linligo-uniapp/）
pnpm install
pnpm dev:mp-weixin
pnpm build:mp-weixin

# 本地依赖环境
docker compose -f deploy/docker-compose.yml up -d

# 重新生成 AGENTS.md / CLAUDE.md
docs/agent-templates/build.sh linligo
```

## 行为准则

### 先想后写

- 明确说出假设；不确定就问。
- 需求有多种理解时，列出来让用户选，不要默默挑一个。
- 有更简单的做法就直说，该反对时要反对。
- 有不清楚的地方就停下，指出具体哪里不清楚，然后提问。

### 简单优先

- 不做需求之外的功能。
- 只用一次的代码不做抽象。
- 不加没人要求的灵活性或可配置性。
- 不为不可能发生的情况写异常处理。
- 写了 200 行而 50 行就能搞定的，重写。

### 外科手术式修改

- 不顺手优化相邻的代码、注释或格式。
- 没坏的东西不重构。
- 沿用现有风格。
- 发现无关的死代码，指出来，不要删。
- 删除因你的改动而不再使用的 import / 变量 / 方法；原本就存在的死代码不动。
- diff 中每一行改动都必须能追溯到用户的需求。

### 目标驱动执行

把任务转化为可验证的目标：

- 加参数校验 → 先写非法输入的测试，再让它通过。
- 修 bug → 先写能复现 bug 的测试，再让它通过。
- 重构 → 重构前后测试都要通过。

多步骤任务先给出计划：

```
1. [步骤] → 验证：[检查方式]
2. [步骤] → 验证：[检查方式]
```

## 工作要求

- 新增依赖前先说明理由；优先使用已有依赖与工具类。
- 涉及数据库结构、公共模块、鉴权的改动，先给出方案再动手。
- 完成后运行相关模块的构建/测试，如实报告结果；测试失败附上输出，跳过的步骤要说明。
- 回复与代码注释使用中文；标识符使用英文。

## 安全规范

- 禁止将密码、密钥、Token 写入代码或提交到仓库；使用环境变量或配置中心。
- 所有外部输入在服务端校验，不信任前端校验结果。
- 权限校验在服务端完成；接口按最小权限设计。
- SQL 只用参数绑定，禁止拼接用户输入。
- 日志中不输出密码、Token、身份证号、手机号等敏感信息，必要时脱敏。

## Git 规范

- 分支：`main`、`dev`、`feature/xxx`、`fix/xxx`。
- 提交信息遵循 Conventional Commits：`<type>(<scope>): <描述>`，type 取 `feat`、`fix`、`refactor`、`docs`、`test`、`chore`。
- 一次提交只做一件事；不提交构建产物、IDE 配置、`.env`。
- 未经用户要求不执行 commit、push、强制推送、改写历史。

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

## Spring Cloud 规范

- 鉴权统一在网关完成；下游服务只信任网关传入的用户信息请求头，不对外暴露端口。
- 服务间调用只走公共 API 模块中定义的 Feign 接口；Feign 接口的入参和返回值用 DTO，不用 `entity`。
- 每个服务只访问自己的数据库，禁止跨服务直连数据库或共享表。
- Feign 调用必须配置超时；需要降级的接口提供 `fallbackFactory`。
- 跨服务数据一致性优先用消息队列做最终一致，避免分布式事务。
- 公共配置放配置中心，服务本地只保留启动必需配置。
- 服务名统一小写中划线：`<项目>-<服务>`。
- 改动 Feign 接口或公共 DTO 时，列出所有受影响的调用方。

## MySQL 规范

- 表名、字段名小写下划线，表名带业务前缀，如 `user_account`。
- 每张表必须包含：`id`（bigint，雪花 ID）、`create_time`、`update_time`、`create_by`、`update_by`、`deleted`。
- 索引命名：普通索引 `idx_<字段>`，唯一索引 `uk_<字段>`。
- 不建物理外键，关联关系由应用层维护。
- 禁止 `SELECT *`；禁止在循环中查询数据库，改为批量查询。
- 表结构变更必须提交 SQL 脚本，文件名带日期与序号，如 `20261019_01_create_user_account.sql`。
- 金额用 `decimal`，不用 `float` / `double`。

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

## Vue 3 规范

- 使用 `<script setup lang="ts">` + 组合式 API，不用选项式 API。
- 请求统一封装在 `api/` 目录，按业务模块拆分；页面中不直接调用 `axios` / `fetch`。
- 接口入参和返回值定义 TypeScript 类型，禁止 `any`。
- 全局状态用 Pinia；只在组件内使用的状态不放进 store。
- 可复用逻辑抽成 `composables/useXxx.ts`。
- 组件名 PascalCase，文件夹与路由路径 kebab-case。
- props 用 `defineProps<T>()` 声明类型，事件用 `defineEmits<T>()`。

## uni-app 规范

- 使用 Vue 3 `<script setup lang="ts">`。
- 请求统一封装 `uni.request`，页面中不直接调用。
- 使用 `uni.*` API，不使用 `window`、`document` 等浏览器专属 API。
- 平台差异用条件编译（`// #ifdef MP-WEIXIN`），收敛在工具层，不散落在页面中。
- 尺寸单位用 `rpx`。
- 非首屏页面放入分包；静态资源较大的放 CDN，不放主包。
- 页面在 `pages.json` 注册，路径 kebab-case。

## 文档维护

- `AGENTS.md` 与 `CLAUDE.md` 由 `docs/agent-templates/` 生成，不要直接修改。修改规范时改对应模块文件，再运行 `docs/agent-templates/build.sh <项目名>`。
- 技术选型确定、模块调整、命令变化时，同步更新项目模块。
- 同一类错误被纠正两次以上，把规则补进对应模块。
- 发现文档与代码实际不一致时，指出并提出修改建议。

## Claude Code 工作方式

- 跨多个模块或服务的改动，先进入 Plan 模式给出方案。
- 大范围代码检索交给 Explore 子代理。
- 派生子代理时，把相关规范写进子代理的 prompt。
- 同一类纠正出现两次以上，提议沉淀为 skill 或补进文档模板。

### 扩展结构

| 位置 | 用途 | 格式 |
|---|---|---|
| `.claude/agents/` | 专用子代理 | Markdown + YAML frontmatter（name、description、tools、model） |
| `.claude/skills/` | 工作流与领域知识 | `<名称>/SKILL.md`：何时使用、怎么做、示例 |
| `.claude/commands/` | 斜杠命令 | Markdown + description frontmatter |
| `.claude/settings.json` | 团队共享的权限与 hooks | JSON |
| `.claude/settings.local.json` | 个人权限与配置（不入库） | JSON |
| `.mcp.json` | MCP 服务配置 | JSON |

- 按需创建，不建空目录。
- 文件命名小写中划线，如 `java-reviewer.md`。

### 常用指令

| 指令 | 用途 |
|---|---|
| `/code-review` | 审查当前改动的正确性 |
| `/simplify` | 简化改动代码 |
| `/security-review` | 安全审查当前分支改动 |

### Skills 映射

| 文件 | Skill |
|---|---|
| `linligo-server/**/controller/*.java` | `new-api`（待建） |
| `linligo-server/linligo-modules/*/pom.xml` | `new-microservice`（待建） |
| `deploy/sql/*.sql` | `db-migration`（待建） |
| `linligo-uniapp/**` | `uniapp-page`（待建） |
