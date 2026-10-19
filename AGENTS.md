# AGENTS.md

本文件是 LinliGo 项目给 AI 编码助手（Claude Code、Codex、Cursor 等）的通用工作规范。
项目处于初始化阶段，标注「待定」的部分请在技术选型确定后更新。

## 项目概述

LinliGo 是一个多端项目：

- **后端**：Spring Boot + Spring Cloud 微服务
- **Web 端**：管理后台 / PC Web
- **小程序端**：uni-app（可同时编译到微信小程序、H5、App）

## 技术栈

| 层 | 选型 | 备注 |
|---|---|---|
| 语言 | Java 17+ | |
| 后端框架 | Spring Boot 3.x、Spring Cloud | |
| 注册/配置中心 | Nacos | 待定 |
| 网关 | Spring Cloud Gateway | |
| 服务调用 | OpenFeign + LoadBalancer | |
| 限流熔断 | Sentinel | 待定 |
| ORM | MyBatis-Plus | 待定 |
| 数据库 | MySQL 8 | |
| 缓存 | Redis | |
| 消息队列 | RocketMQ / RabbitMQ | 待定 |
| 鉴权 | Spring Security + JWT / Sa-Token | 待定 |
| 构建 | Maven 多模块 | |
| Web 前端 | Vue 3 + Vite + TypeScript | 待定 |
| 小程序 | uni-app（Vue 3） | |
| 部署 | Docker / Docker Compose | |

## 目录结构（规划）

```
LinliGo/
├── linligo-server/              # 后端 Maven 父工程
│   ├── linligo-common/          # 公共模块：工具类、统一返回、异常、常量
│   ├── linligo-api/             # Feign 接口与 DTO（供服务间调用）
│   ├── linligo-gateway/         # 网关：路由、鉴权、跨域、限流
│   ├── linligo-auth/            # 认证服务：登录、令牌签发
│   └── linligo-modules/         # 业务微服务
│       ├── linligo-user/
│       └── ...
├── linligo-web/                 # Web 前端
├── linligo-uniapp/              # uni-app 小程序
├── deploy/                      # docker-compose、Nginx、SQL 初始化脚本
└── docs/                        # 设计文档、接口文档
```

新增模块时请保持以上命名风格（`linligo-xxx`）。

## 常用命令

```bash
# 后端（在 linligo-server/ 下）
mvn clean install -DskipTests          # 全量构建
mvn -pl linligo-modules/linligo-user -am spring-boot:run   # 启动单个服务
mvn test                               # 运行全部测试
mvn -pl <模块> test -Dtest=类名#方法名    # 运行单个测试

# Web 前端（在 linligo-web/ 下）
pnpm install && pnpm dev
pnpm build
pnpm lint

# 小程序（在 linligo-uniapp/ 下）
pnpm install
pnpm dev:mp-weixin                     # 产物用微信开发者工具打开 dist/dev/mp-weixin
pnpm build:mp-weixin

# 本地依赖环境
docker compose -f deploy/docker-compose.yml up -d   # MySQL / Redis / Nacos 等
```

> 命令以实际脚手架为准，工程创建后请同步修正此节。

## 后端规范

### 分层

`controller` → `service`（接口 + `impl`）→ `mapper` → 数据库

- Controller 只做参数校验、调用 Service、组装返回，不写业务逻辑。
- 实体分层：`entity`（对应表）、`dto`（入参/服务间传输）、`vo`（出参）。禁止把 `entity` 直接返回给前端。
- 包名：`com.linligo.<服务名>.<层>`，如 `com.linligo.user.controller`。

### 接口约定

- RESTful 风格，路径小写中划线：`/api/v1/user-addresses/{id}`。
- 统一返回结构 `R<T>`：`{ "code": 0, "msg": "ok", "data": ... }`，分页使用统一的 `PageResult<T>`。
- 业务异常抛出 `BizException(错误码)`，由全局异常处理器统一转换，不在 Controller 中 try-catch 吞异常。
- 入参使用 `jakarta.validation` 注解校验（`@Valid`、`@NotBlank` 等）。
- 服务间调用走 `linligo-api` 中定义的 Feign 接口，不直接跨服务访问数据库。

### 数据库

- 表名、字段名：小写下划线；表名带业务前缀，如 `user_account`。
- 每张表必须包含：`id`（bigint，雪花 ID）、`create_time`、`update_time`、`create_by`、`update_by`、`deleted`（逻辑删除）。
- 表结构变更必须提交 SQL 脚本到 `deploy/sql/`（或 Flyway/Liquibase 目录，待定），文件名带日期与序号。
- 禁止在循环中查询数据库；批量操作用批量 API。

### 配置

- 公共配置放 Nacos，本地开发使用 `application-dev.yml`。
- **严禁**将密码、密钥、Token 提交到仓库；使用环境变量或配置中心。

## 前端规范（Web 与 uni-app 通用）

- 使用 Vue 3 `<script setup>` + TypeScript，组合式 API。
- 请求统一封装在 `api/` 目录，按业务模块拆分文件；禁止在页面中直接写 `axios` / `uni.request`。
- 全局状态使用 Pinia。
- 组件名 PascalCase，文件夹与路由路径 kebab-case。
- uni-app 中平台差异代码使用条件编译（`// #ifdef MP-WEIXIN`），并尽量收敛在工具层。
- 注意小程序主包体积限制，非首屏页面放入分包。

## Git 规范

- 分支：`main`（生产）、`dev`（开发）、`feature/xxx`、`fix/xxx`。
- 提交信息遵循 Conventional Commits：`feat(user): 新增收货地址接口`、`fix(web): 修复登录跳转`。
- 一次提交只做一件事，不提交构建产物、IDE 配置、`.env` 等本地文件。

## 对 AI 助手的要求

- 修改代码前先阅读相关模块的现有实现，保持与周边代码风格一致。
- 新增依赖前先说明理由；优先使用项目已有的依赖与工具类。
- 涉及数据库结构、公共模块（`linligo-common`、`linligo-api`）、网关鉴权的改动，先给出方案再动手。
- 完成后运行相关模块的构建/测试，如实报告结果。
- 回复与代码注释使用中文；标识符使用英文。
