# AGENTS.md

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
└── docs/                        # 设计文档、接口文档
```

新增模块命名为 `linligo-xxx`。

## 常用命令

```bash
# 后端（linligo-server/）
mvn clean install -DskipTests
mvn -pl linligo-modules/linligo-user -am spring-boot:run
mvn test
mvn -pl <模块> test -Dtest=类名#方法名

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
```

## 后端规范

### 分层

- `controller` → `service`（接口 + `impl`）→ `mapper` → 数据库。
- Controller 只做参数校验、调用 Service、组装返回，不写业务逻辑。
- `entity` 对应表，`dto` 用于入参和服务间传输，`vo` 用于出参。禁止把 `entity` 直接返回给前端。
- 包名：`com.linligo.<服务名>.<层>`。

### 接口

- RESTful，路径小写中划线：`/api/v1/user-addresses/{id}`。
- 统一返回 `R<T>`：`{ "code": 0, "msg": "ok", "data": ... }`；分页返回 `PageResult<T>`。
- 业务异常抛 `BizException(错误码)`，由全局异常处理器转换；Controller 中不 try-catch 吞异常。
- 入参用 `jakarta.validation` 注解校验。
- 服务间调用走 `linligo-api` 中的 Feign 接口，不跨服务访问数据库。

### 数据库

- 表名、字段名小写下划线，表名带业务前缀，如 `user_account`。
- 每张表必须包含：`id`（bigint，雪花 ID）、`create_time`、`update_time`、`create_by`、`update_by`、`deleted`。
- 表结构变更必须提交 SQL 脚本到 `deploy/sql/`，文件名带日期与序号。
- 禁止在循环中查询数据库。

### 配置

- 公共配置放 Nacos，本地开发用 `application-dev.yml`。
- 禁止将密码、密钥、Token 提交到仓库。

## 前端规范（Web 与 uni-app）

- Vue 3 `<script setup>` + TypeScript。
- 请求统一封装在 `api/` 目录，按业务模块拆分；页面中不直接调用 `axios` / `uni.request`。
- 全局状态用 Pinia。
- 组件名 PascalCase，文件夹与路由路径 kebab-case。
- uni-app 平台差异用条件编译（`// #ifdef MP-WEIXIN`），收敛在工具层。
- 非首屏页面放入分包。

## Git 规范

- 分支：`main`、`dev`、`feature/xxx`、`fix/xxx`。
- 提交信息遵循 Conventional Commits：`feat(user): 新增收货地址接口`。
- 一次提交只做一件事；不提交构建产物、IDE 配置、`.env`。

## 项目特定要求

- 新增依赖前先说明理由；优先使用已有依赖与工具类。
- 涉及数据库结构、`linligo-common`、`linligo-api`、网关鉴权的改动，先给出方案再动手。
- 完成后运行相关模块的构建/测试，如实报告结果；测试失败附上输出，跳过的步骤要说明。
- 回复与代码注释使用中文；标识符使用英文。

## 文档维护

- 技术选型确定、模块调整、命令变化时，同步更新本文件对应小节。
- 同一类错误被纠正两次以上，把规则补进对应小节。
- 发现本文件与代码实际不一致时，指出并提出修改建议。
