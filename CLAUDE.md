# CLAUDE.md

@AGENTS.md

## Claude Code 扩展结构

| 位置 | 用途 | 格式 |
|---|---|---|
| `.claude/agents/` | 专用子代理 | Markdown + YAML frontmatter（name、description、tools、model） |
| `.claude/skills/` | 工作流与领域知识 | `<名称>/SKILL.md`：何时使用、怎么做、示例 |
| `.claude/commands/` | 斜杠命令 | Markdown + description frontmatter |
| `.claude/rules/` | 始终遵守的规则 | Markdown |
| `.claude/settings.json` | 团队共享的权限与 hooks | JSON |
| `.claude/settings.local.json` | 个人权限与配置（不入库） | JSON |
| `.mcp.json` | MCP 服务配置 | JSON |

- 按需创建，不建空目录。
- 文件命名小写中划线，如 `java-reviewer.md`。

## 常用指令

| 指令 | 用途 |
|---|---|
| `/code-review` | 审查当前改动的正确性 |
| `/simplify` | 简化改动代码 |
| `/security-review` | 安全审查当前分支改动 |
| Plan 模式 | 跨服务改动前先出方案 |

新建的命令与 skill 登记到本表和「Skills 映射」。

## Skills 映射

| 文件 | Skill |
|---|---|
| `linligo-server/**/controller/*.java` | `new-api`（待建） |
| `linligo-server/linligo-modules/*/pom.xml` | `new-microservice`（待建） |
| `deploy/sql/*.sql` | `db-migration`（待建） |
| `linligo-uniapp/**` | `uniapp-page`（待建） |

派生子代理时，把对应 skill 的约定写进子代理的 prompt。

## 工作方式

- 个人本地配置见 `CLAUDE.local.md`。
- 跨多个服务的改动，先进入 Plan 模式给出方案。
- 大范围代码检索交给 Explore 子代理。
- 后端测试只跑受影响模块：`mvn -pl <模块> -am test`。
- 同一类纠正出现两次以上，提议沉淀为 `.claude/rules/` 规则、skill，或补进 AGENTS.md。
