# Skills 索引

按分类分层，每个叶子目录是一个符合 Agent Skills 标准的 skill：`<分类>/<名>/SKILL.md`。安装时展平为 `<名>`，skill 名在所有分类间唯一。

`modules.txt` 中用 `<分类>/<名>` 引用 skill，生成时取 `SKILL.md` 去掉 frontmatter 后的正文。

## common：通用约束，所有项目都用

| Skill | 内容 |
|---|---|
| `coding-behavior` | 编码行为准则：先想后写、简单优先、外科手术式修改、目标驱动执行 |
| `dev-workflow` | 工作要求：依赖与公共模块改动先给方案、完成后构建测试 |
| `security` | 安全规范：密钥、输入与权限校验、参数化查询、日志脱敏 |
| `git-conventions` | Git 规范：分支、提交信息、提交前置条件 |
| `doc-maintenance` | AI 文档维护：生成文件不直接改，改源文件再重新生成 |

## backend：后端

| Skill | 内容 |
|---|---|
| `spring-boot` | 单体与微服务共用：分层、接口、事务、配置与日志 |
| `spring-cloud` | 微服务追加：网关、Feign、服务边界、配置中心 |
| `mysql` | 表设计、索引、迁移脚本、查询约束 |

## orm：三选一（`mybatis-plus-join` 需配合 `mybatis-plus`）

| Skill | 内容 |
|---|---|
| `mybatis-plus` | MyBatis-Plus 用法与约束 |
| `mybatis-plus-join` | MyBatis-Plus-Join 联表查询 |
| `mybatis-flex` | MyBatis-Flex 用法与约束 |

## frontend：前端

| Skill | 内容 |
|---|---|
| `vue3` | Vue 3 + TypeScript |
| `uniapp` | uni-app 小程序 |

## claude：Claude Code 专属，只写入 CLAUDE.md

| Skill | 内容 |
|---|---|
| `claude-code` | Claude Code 工作方式、扩展结构、常用指令 |

## tools：工具类 skill，不拼进 AGENTS.md

| Skill | 内容 |
|---|---|
| `agent-docs` | 为项目接入规范、生成 AGENTS.md / CLAUDE.md |

## 新增 skill

1. 放到对应分类下：`<分类>/<名>/SKILL.md`。没有合适的分类就新建，分类名小写中划线。
2. frontmatter 必填 `name`（与目录名一致，小写字母、数字、连字符）和 `description`（写清做什么、何时使用）。
3. 正文以 `##` 作为顶级标题，只写规则、事实和命令。
4. 在本文件对应分类的表格中登记。
