---
name: doc-maintenance
description: AI 文档维护规则：AGENTS.md、CLAUDE.md 由 agent-docs 生成，改规范时改源文件再重新生成。修改 AGENTS.md、CLAUDE.md 或项目规范时使用。
---

## 文档维护

- `AGENTS.md` 与 `CLAUDE.md` 由 agent-docs 生成，不要直接修改。
- 项目专属内容改项目内 `.agents/agent-docs/` 下的文件（`project.md`、`modules.txt` 等）；通用规范改 ai-agents 仓库中的 `skills/<分类>/<名>/SKILL.md`。改完用 agent-docs 重新生成。
- 技术选型确定、模块调整、命令变化时，同步更新 `project.md` 与 `modules.txt`。
- 同一类错误被纠正两次以上，把规则补进对应的 skill 或 `project.md`。
- 发现文档与代码实际不一致时，指出并提出修改建议。
