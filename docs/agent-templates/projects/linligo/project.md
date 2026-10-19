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
