## 项目概述

ai-agents 是团队共享的 AI 编码规范与 skills 仓库：规范按分类做成 Agent Skills 标准的 skill，既可被各 AI 工具按需加载，也可由 agent-docs 拼装成业务项目的 AGENTS.md / CLAUDE.md。仓库同时是 Claude Code plugin 与 marketplace。

## 目录结构

```
ai-agents/
├── .claude-plugin/              # plugin.json、marketplace.json
├── skills/                      # <分类>/<名>/SKILL.md，索引见 skills/README.md
│   ├── common/  backend/  orm/  frontend/        # 规范类 skill（另含部分第三方参考）
│   ├── web/  gitnexus/  ponytail/  workflow/  writing/   # 第三方能力型 skill
│   ├── claude/                  # 只写入 CLAUDE.md
│   └── tools/                   # agent-docs 生成器及工具类 skill
├── examples/                    # 业务项目接入示例：linligo、epost-integration-service（.agents/agent-docs/）
├── .agents/agent-docs/          # 本仓库自身的 project.md、modules.txt
├── scripts/install.sh           # 软链 skills 到 ~/.agents/skills
└── docs/                        # 使用说明、提示词、参考资料（references/）
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
- 第三方 skill 尽量保持与上游一致，保留 LICENSE，并在 `docs/ai-guide.md` 登记来源；不写进 `modules.txt`。
- 规范类 skill 正文以 `##` 为顶级标题，只写规则、事实和命令；来源与解释写进 `docs/ai-guide.md`。
- 一条规则只放在一个 skill 里；skill 之间互不引用。
- 改动 skill 后重新生成示例，确认输出符合预期；发布前提升 `plugin.json` 的 `version`。
