# AI 编码规范与 Skills 使用说明

本仓库（ai-agents）统一管理团队的 AI 编码规范。规范按分类做成符合 [Agent Skills](https://agentskills.io/specification) 标准的 skill，有两种用法：

- **按需加载**：安装后，Claude Code、Codex、Cursor 等支持 Agent Skills 的工具会在相关任务中自动加载对应 skill。
- **拼进项目文档**：用 `agent-docs` skill 把选中的规范拼装成业务项目的 `AGENTS.md`、`CLAUDE.md`，每次会话都生效。

本文供团队成员阅读，AI 不需要读。

## 目录结构

```
ai-agents/
├── .claude-plugin/
│   ├── plugin.json              # Claude Code plugin 清单，skills 字段列出各分类目录
│   └── marketplace.json         # 本仓库同时作为 marketplace，source 指向 ./
├── skills/
│   ├── README.md                # skill 索引与新增规则
│   ├── common/                  # 通用约束：coding-behavior、dev-workflow、security、git-conventions、doc-maintenance
│   ├── backend/                 # spring-boot、spring-cloud、mysql
│   ├── orm/                     # mybatis-plus、mybatis-plus-join、mybatis-flex
│   ├── frontend/                # vue3、uniapp
│   ├── claude/                  # claude-code（只写入 CLAUDE.md）
│   └── tools/agent-docs/        # 生成器：SKILL.md + scripts/build.sh
├── examples/linligo/.agents/agent-docs/   # 业务项目接入示例
├── .agents/agent-docs/          # 本仓库自身的配置，生成根目录 AGENTS.md / CLAUDE.md
├── scripts/install.sh           # 把 skills 展平软链到 ~/.agents/skills
└── docs/
    ├── ai-guide.md              # 本文
    └── prompts/                 # 提示词
```

Agent Skills 标准只识别 `skills/<名>/SKILL.md` 这一层，分类只存在于本仓库中，安装时展平，因此 skill 名在所有分类之间必须唯一。

## 安装

| 方式 | 命令 | 适用 |
|---|---|---|
| Claude Code plugin | `/plugin marketplace add shaw5290/ai-agents`，再 `/plugin install ai-agents@ai-agents` | Claude Code 用户 |
| 软链到通用目录 | 克隆本仓库后运行 `scripts/install.sh`（默认装到 `~/.agents/skills`，也可传目标目录） | Codex 等读取 `~/.agents/skills` 的工具 |

- plugin 中的 skill 带命名空间，例如 `/ai-agents:agent-docs`。
- 更新：plugin 用 `/plugin marketplace update ai-agents` 后再 `/plugin update ai-agents`，然后重启；软链方式 `git pull` 即可。
- WSL 中的软链对 Windows 侧的工具不可见，Windows 侧的工具需要在 Windows 中另行安装。

要让团队成员打开业务项目时收到安装提示，在该项目的 `.claude/settings.json` 中加入：

```json
{
  "extraKnownMarketplaces": {
    "ai-agents": {
      "source": { "source": "github", "repo": "shaw5290/ai-agents" }
    }
  },
  "enabledPlugins": {
    "ai-agents@ai-agents": true
  }
}
```

## 业务项目接入

在业务项目中调用 `agent-docs` skill，它会询问项目信息、推荐模块，在项目里生成：

```
<项目>/
├── .agents/agent-docs/
│   ├── project.md               # 项目概述、技术栈、目录、命令、项目专属约定
│   ├── modules.txt              # 拼装清单
│   └── claude-skills.md         # 可选，项目的 Skills 映射（只写入 CLAUDE.md）
├── AGENTS.md                    # 生成文件
└── CLAUDE.md                    # 生成文件
```

也可以手动运行：`<ai-agents>/skills/tools/agent-docs/scripts/build.sh <项目目录> [输出目录]`。

### modules.txt 规则

- 每行一个条目，按顺序拼接；`#` 开头为注释。
- `<分类>/<名>` 引用 skill，取 `SKILL.md` 去掉 frontmatter 后的正文。
- 以 `.md` 结尾的条目读 `modules.txt` 所在目录下的文件。
- `claude/` 下的条目和 `claude-` 开头的文件只写入 `CLAUDE.md`，其余同时写入两份文件。
- 兼容 Windows 换行（CRLF）。
- 项目配置里不要建名为 `claude.md` 的文件：Windows 盘大小写不敏感，Claude Code 会把它当成 `CLAUDE.md` 加载。

完整示例见 `examples/linligo/.agents/agent-docs/`。

### 常见组合

| 项目类型 | 模块 |
|---|---|
| Spring Boot 单体 + MyBatis-Plus | common/* + backend/spring-boot + backend/mysql + orm/mybatis-plus |
| 再加联表查询 | 上面 + orm/mybatis-plus-join |
| Spring Boot 单体 + MyBatis-Flex | common/* + backend/spring-boot + backend/mysql + orm/mybatis-flex |
| Spring Cloud 微服务 | 上述任一 + backend/spring-cloud |
| 管理后台前端 | + frontend/vue3 |
| 小程序 | + frontend/uniapp |

`common/*` 指 coding-behavior、dev-workflow、security、git-conventions、doc-maintenance 五个 skill。

## 维护

| 发生了什么 | 改哪里 |
|---|---|
| 某类规范需要调整（对所有项目生效） | 本仓库 `skills/<分类>/<名>/SKILL.md` |
| 只对某个项目生效的约定 | 该项目的 `.agents/agent-docs/project.md` |
| 技术选型确定、目录或命令变化 | 该项目的 `.agents/agent-docs/project.md` |
| 引入或更换框架 | 该项目的 `modules.txt` 增删条目；没有现成 skill 就在本仓库新建 |
| 新增 skill | 本仓库对应分类下新建，并登记到 `skills/README.md` |
| 新增分类 | 新建目录，并加入 `.claude-plugin/plugin.json` 的 `skills` 列表 |
| 只和自己电脑有关的配置 | `CLAUDE.local.md` |

- 改了 skill 后，提升 `plugin.json` 的 `version` 再发布，各业务项目更新 plugin 后重新生成文档。
- 发布前运行 `claude plugin validate .`。根目录的 `CLAUDE.md` 是本仓库自身的开发文档，validate 对它给出的"不会作为 plugin 上下文加载"警告属于预期。

## 编写原则

- skill 正文里只写给 AI 的规则、事实和命令，不写来源、背景、解释，这些写进本文。
- 每条规则都应能检验，避免"写出高质量代码"这类空话。
- 一条规则只放在一个 skill 里，不跨 skill 重复。
- skill 之间互不引用，每个 skill 单独拿出来都能读懂。
- `description` 写清做什么、何时使用，工具靠它决定是否加载。

## 内容来源

| Skill | 来源 |
|---|---|
| `common/coding-behavior` | [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)：四条准则译为中文，删去解释性语句 |
| `claude/claude-code` | [Everything Claude Code](https://github.com/affaan-m/everything-claude-code)：借用扩展结构、指令表、Skills 映射的组织方式，内容按本项目改写 |
