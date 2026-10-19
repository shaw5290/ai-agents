# AI 编码助手文档说明

本项目的 `AGENTS.md`、`CLAUDE.md` 由 `docs/agent-templates/` 中的模块拼装生成。通用约束和各架构规范拆成独立模块，不同项目按需挑选组合。本文供团队成员阅读，AI 不需要读。

## 文件一览

| 文件 | 读者 | 是否入库 |
|---|---|---|
| `AGENTS.md` | 所有 AI 工具（Codex、Cursor 等） | 是，生成文件 |
| `CLAUDE.md` | Claude Code | 是，生成文件 |
| `CLAUDE.local.md` | Claude Code（个人本机配置） | 否 |
| `docs/agent-templates/` | 模板库，维护规范的地方 | 是 |

`CLAUDE.md` = `AGENTS.md` 的全部内容 + Claude Code 专属模块。两份文件都独立完整，互不引用。

## 模板库结构

```
docs/agent-templates/
├── build.sh                     # 拼装脚本
├── common/                      # 通用约束，所有项目都用
│   ├── behavior.md              # 编码行为准则
│   ├── workflow.md              # 工作要求
│   ├── security.md              # 安全规范
│   ├── git.md                   # Git 规范
│   └── doc-maintenance.md       # 文档维护（告诉 AI 改模板而不是改生成文件）
├── backend/
│   ├── spring-boot.md           # 单体与微服务共用：分层、接口、事务、日志
│   ├── spring-cloud.md          # 微服务追加：网关、Feign、服务边界
│   └── mysql.md
├── orm/                         # 三选一（mybatis-plus-join 需配合 mybatis-plus）
│   ├── mybatis-plus.md
│   ├── mybatis-plus-join.md
│   └── mybatis-flex.md
├── frontend/
│   ├── vue3.md
│   └── uniapp.md
├── claude/
│   └── claude-code.md           # Claude Code 工作方式、扩展结构、常用指令
└── projects/
    └── linligo/
        ├── modules.txt          # 模块清单（决定拼装内容与顺序）
        ├── project.md           # 项目概述、技术栈、目录、命令
        └── claude-skills.md     # 项目的 Skills 映射
```

## 拼装规则

- `modules.txt` 每行一个模块路径（不带 `.md`），按顺序拼接；`#` 开头为注释。
- `claude/` 下的模块和文件名以 `claude-` 开头的模块只写入 `CLAUDE.md`，其余同时写入两份文件。
- 模块文件以 `##` 作为顶级标题，生成文件的 `#` 标题由脚本添加。
- 项目模块里的 Claude 专属文件不要命名为 `claude.md`：Windows 盘大小写不敏感，Claude Code 会把它当成 `CLAUDE.md` 自动加载。

## 常见组合

| 项目类型 | 模块 |
|---|---|
| Spring Boot 单体 + MyBatis-Plus | common/* + backend/spring-boot + backend/mysql + orm/mybatis-plus |
| 再加联表查询 | 上面 + orm/mybatis-plus-join |
| Spring Boot 单体 + MyBatis-Flex | common/* + backend/spring-boot + backend/mysql + orm/mybatis-flex |
| Spring Cloud 微服务 | 上述任一 + backend/spring-cloud |
| 管理后台前端 | + frontend/vue3 |
| 小程序 | + frontend/uniapp |

`common/*` 指 behavior、workflow、security、git、doc-maintenance 五个模块。

## 新项目接入

1. 新建 `projects/<项目名>/`，参照 `projects/linligo/` 编写 `project.md`、`modules.txt`，按需写 `claude-skills.md`。
2. 生成到当前仓库根目录：`docs/agent-templates/build.sh <项目名>`。
   生成到其他项目：`docs/agent-templates/build.sh <项目名> /path/to/project`。
3. 生成到其他项目时，目标项目里没有模板库，需要改写 `common/doc-maintenance.md` 中的路径，或者在该项目的清单中不使用这个模块。

## 维护

| 发生了什么 | 改哪里 |
|---|---|
| 某类规范需要调整（对所有项目生效） | 对应的 `common/`、`backend/`、`orm/`、`frontend/` 模块 |
| 只对某个项目生效的约定 | `projects/<项目名>/project.md` |
| 技术选型确定、目录或命令变化 | `projects/<项目名>/project.md` |
| 引入或更换框架 | `projects/<项目名>/modules.txt` 增删模块；没有现成模块就新建 |
| 新建 skill / 命令 / 子代理 | `projects/<项目名>/claude-skills.md` |
| 只和自己电脑有关的配置 | `CLAUDE.local.md` |

改完运行 `build.sh` 重新生成，并把模板和生成文件一起提交。

## 编写原则

- 模块里只写给 AI 的规则、事实和命令，不写来源、背景、解释，这些写进本文。
- 每条规则都应能检验，避免"写出高质量代码"这类空话。
- 一条规则只放在一个模块里，不跨模块重复。
- 模块之间互不引用，每个模块单独拿出来都能读懂。

## 内容来源

| 模块 | 来源 |
|---|---|
| `common/behavior.md` | [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)：四条准则译为中文，删去解释性语句 |
| `claude/claude-code.md` | [Everything Claude Code](https://github.com/affaan-m/everything-claude-code)：借用扩展结构、指令表、Skills 映射的组织方式，内容按本项目改写 |
