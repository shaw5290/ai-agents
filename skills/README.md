# Skills 索引

按分类分层，每个叶子目录是一个符合 Agent Skills 标准的 skill：`<分类>/<名>/SKILL.md`。安装时展平为 `<名>`，skill 名在所有分类间唯一。

skill 分两类：

- **规范**：团队自己维护的编码规范，可被 `modules.txt` 用 `<分类>/<名>` 引用，生成时取 `SKILL.md` 去掉 frontmatter 后的正文。
- **第三方**：从外部引入的能力型 skill，只按需加载，不写进 `modules.txt`。修改时尽量保持与上游一致，便于同步。

## common：通用约束（规范）

| Skill | 内容 |
|---|---|
| `coding-behavior` | 编码行为准则：先想后写、简单优先、外科手术式修改、目标驱动执行 |
| `dev-workflow` | 工作要求：依赖与公共模块改动先给方案、同步文档、完成后构建测试 |
| `security` | 安全规范：密钥、输入与权限校验、密码存储与响应脱敏、参数化查询、日志脱敏 |
| `git-conventions` | Git 规范：分支、提交信息、提交前置条件 |
| `doc-maintenance` | AI 文档维护：生成文件不直接改，改源文件再重新生成 |

## backend：后端

| Skill | 类型 | 内容 |
|---|---|---|
| `spring-boot` | 规范 | 单体与微服务共用：分层、代码风格、接口、事务、配置与日志、测试 |
| `spring-cloud` | 规范 | 微服务追加：网关、Feign、服务边界、配置中心 |
| `mysql` | 规范 | 表设计、索引、迁移脚本、查询约束 |
| `autotable-usage` | 第三方 | AutoTable 自动建表框架使用指南，含 yudao-cloud 接入经验 |

## orm：三选一（`mybatis-plus-join` 需配合 `mybatis-plus`）

| Skill | 类型 | 内容 |
|---|---|---|
| `mybatis-plus` | 规范 | MyBatis-Plus 用法与约束 |
| `mybatis-plus-join` | 规范 | MyBatis-Plus-Join 联表查询 |
| `mybatis-flex` | 规范 | MyBatis-Flex 用法与约束 |

## frontend：前端

| Skill | 类型 | 内容 |
|---|---|---|
| `vue3` | 规范 | Vue 3 + TypeScript 团队约定 |
| `uniapp` | 规范 | uni-app 小程序团队约定 |
| `vue-skills` | 第三方 | Vue 3 模式参考：组件、composables、路由、状态、表单、性能、测试 |
| `uni-app` | 第三方 | uni-app 框架参考：配置、组件、生命周期、API |
| `uview-pro` | 第三方 | uView Pro 组件库：组件、工具、hooks、布局 |
| `frontend-design` | 第三方 | 有设计感的前端界面实现 |
| `taste-skill` | 第三方 | UI/UX 设计约束，避免千篇一律的 AI 风格 |

## web：浏览器与联网

| Skill | 类型 | 内容 |
|---|---|---|
| `agent-browser` | 第三方 | 浏览器自动化：页面操作、表单、截图、数据提取 |
| `drissionpage` | 第三方 | 基于 DrissionPage 的浏览器控制与 HTTP 请求 |
| `web-access` | 第三方 | 搜索、网页抓取、登录后操作等联网任务 |

## gitnexus：基于 GitNexus 知识图谱的代码分析（需安装 GitNexus）

| Skill | 类型 | 内容 |
|---|---|---|
| `gitnexus-guide` | 第三方 | GitNexus 工具、图谱结构、工作流参考 |
| `gitnexus-cli` | 第三方 | 索引仓库、查看状态、生成 wiki 等 CLI 操作 |
| `gitnexus-exploring` | 第三方 | 理解架构、追踪调用链 |
| `gitnexus-debugging` | 第三方 | 追踪错误来源 |
| `gitnexus-impact-analysis` | 第三方 | 改动影响面与安全性分析 |
| `gitnexus-refactoring` | 第三方 | 安全地重命名、提取、拆分、移动代码 |
| `gitnexus-pr-review` | 第三方 | PR 变更、风险与测试覆盖审查 |
| `gitnexus-pr-swarm-review` | 第三方 | 多评审者协同的生产就绪审查 |
| `gitnexus-pdg-query` | 第三方 | 控制 / 数据依赖查询 |
| `gitnexus-taint-analysis` | 第三方 | 污点分析、source→sink 数据流 |

## ponytail：极简方案与过度设计审查

| Skill | 类型 | 内容 |
|---|---|---|
| `ponytail` | 第三方 | 强制最简可行方案，支持 lite / full / ultra 强度 |
| `ponytail-review` | 第三方 | 只针对过度设计的代码审查 |
| `ponytail-audit` | 第三方 | 全仓库过度设计审计 |
| `ponytail-debt` | 第三方 | 汇总 `ponytail:` 注释形成技术债清单 |
| `ponytail-help` | 第三方 | ponytail 模式与命令速查 |

## workflow：任务规划与协作流程

| Skill | 类型 | 内容 |
|---|---|---|
| `create-plan` | 第三方 | 按要求生成简明计划 |
| `planning-with-files` | 第三方 | 用 task_plan.md / findings.md / progress.md 做文件化规划 |
| `context-manager` | 第三方 | 上下文工程、记忆系统设计 |
| `gh-fix-ci` | 第三方 | 用 `gh` 排查并修复失败的 GitHub Actions 检查 |

## writing：写作

| Skill | 类型 | 内容 |
|---|---|---|
| `humanizer-zh` | 第三方 | 去除中文文本中的 AI 写作痕迹 |

## claude：Claude Code 专属，只写入 CLAUDE.md

| Skill | 类型 | 内容 |
|---|---|---|
| `claude-code` | 规范 | Claude Code 工作方式、扩展结构、常用指令 |

## tools：工具

| Skill | 类型 | 内容 |
|---|---|---|
| `agent-docs` | 规范 | 为项目接入规范、生成 AGENTS.md / CLAUDE.md |
| `skill-creator` | 第三方 | 创建与校验 skill |
| `file-organizer` | 第三方 | 整理文件与目录、查找重复文件 |

## 新增 skill

1. 放到对应分类下：`<分类>/<名>/SKILL.md`。没有合适的分类就新建，分类名小写中划线，并加入 `.claude-plugin/plugin.json` 的 `skills` 列表。
2. frontmatter 必填 `name`（与目录名一致，小写字母、数字、连字符，全仓库唯一）和 `description`（写清做什么、何时使用）。
3. 规范类 skill 的正文以 `##` 作为顶级标题，只写规则、事实和命令。
4. 第三方 skill 保留原有 LICENSE 文件，并在 `docs/ai-guide.md` 的内容来源中登记。
5. 在本文件对应分类的表格中登记。
