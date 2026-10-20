---
name: git-conventions
description: Git 规范：分支命名、Conventional Commits 提交信息、提交范围与前置条件。创建分支、编写提交信息或执行 git 操作时使用。
---

## Git 规范

- 分支：`main`、`dev`、`feature/xxx`、`fix/xxx`。
- 提交信息遵循 Conventional Commits：`<type>(<scope>): <描述>`，type 取 `feat`、`fix`、`refactor`、`docs`、`test`、`chore`。
- **MUST**：提交前必须通过所有测试。
- 一次提交只做一件事；不提交构建产物、IDE 配置、`.env`。
- 未经用户要求不执行 commit、push、强制推送、改写历史。
