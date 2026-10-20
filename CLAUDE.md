# CLAUDE.md

## 项目概述

ai-agents 是团队共享的 AI 编码规范与 skills 仓库：规范按分类做成 Agent Skills 标准的 skill，既可被各 AI 工具按需加载，也可由 agent-docs 拼装成业务项目的 AGENTS.md / CLAUDE.md。仓库同时是 Claude Code plugin 与 marketplace。

## 目录结构

```
ai-agents/
├── .claude-plugin/              # plugin.json、marketplace.json
├── skills/                      # <分类>/<名>/SKILL.md，索引见 skills/README.md
│   ├── common/  backend/  orm/  frontend/
│   ├── claude/                  # 只写入 CLAUDE.md
│   └── tools/agent-docs/        # 生成器：SKILL.md + scripts/build.sh
├── examples/linligo/            # 业务项目接入示例（.agents/agent-docs/）
├── .agents/agent-docs/          # 本仓库自身的 project.md、modules.txt
├── scripts/install.sh           # 软链 skills 到 ~/.agents/skills
└── docs/                        # 人读文档、提示词
```

## 常用命令

```bash
# 重新生成本仓库的 AGENTS.md / CLAUDE.md
skills/tools/agent-docs/scripts/build.sh .

# 生成示例项目，检查输出
skills/tools/agent-docs/scripts/build.sh examples/linligo /tmp/linligo-out

# 校验 plugin 与 marketplace
claude plugin validate .

# 安装 skills 到 ~/.agents/skills（可传目标目录）
scripts/install.sh
```

## 仓库约定

- 新增 skill 放到 `skills/<分类>/<名>/SKILL.md`，`name` 与目录名一致且全仓库唯一，并在 `skills/README.md` 登记。
- 新增分类目录时，同步加入 `.claude-plugin/plugin.json` 的 `skills` 列表。
- skill 正文以 `##` 为顶级标题，只写规则、事实和命令；来源与解释写进 `docs/ai-guide.md`。
- 一条规则只放在一个 skill 里；skill 之间互不引用。
- 改动 skill 后重新生成示例，确认输出符合预期；发布前提升 `plugin.json` 的 `version`。

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

## Git 规范

- 分支：`main`、`dev`、`feature/xxx`、`fix/xxx`。
- 提交信息遵循 Conventional Commits：`<type>(<scope>): <描述>`，type 取 `feat`、`fix`、`refactor`、`docs`、`test`、`chore`。
- **MUST**：提交前必须通过所有测试。
- 一次提交只做一件事；不提交构建产物、IDE 配置、`.env`。
- 未经用户要求不执行 commit、push、强制推送、改写历史。

## 文档维护

- `AGENTS.md` 与 `CLAUDE.md` 由 agent-docs 生成，不要直接修改。
- 项目专属内容改项目内 `.agents/agent-docs/` 下的文件（`project.md`、`modules.txt` 等）；通用规范改 ai-agents 仓库中的 `skills/<分类>/<名>/SKILL.md`。改完用 agent-docs 重新生成。
- 技术选型确定、模块调整、命令变化时，同步更新 `project.md` 与 `modules.txt`。
- 同一类错误被纠正两次以上，把规则补进对应的 skill 或 `project.md`。
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
