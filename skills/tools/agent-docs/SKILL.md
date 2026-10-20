---
name: agent-docs
description: 为项目接入团队规范并生成 AGENTS.md、CLAUDE.md。新项目要接入 AI 规范、调整项目选用的规范模块，或需要重新生成 AGENTS.md / CLAUDE.md 时使用。
---

## 生成 AGENTS.md / CLAUDE.md

本 skill 的目录下有 `scripts/build.sh`；所有可选规范模块列在 skills 根目录的 `README.md` 中（本 skill 目录往上两级，软链安装时先用 `readlink -f` 解析本 skill 目录的真实路径）。

### 项目已接入（存在 `.agents/agent-docs/modules.txt`）

运行 `scripts/build.sh <项目根目录>`，报告生成结果。

### 接入新项目

1. 询问并确认项目信息：项目名称、一句话定位、前后端技术栈、数据库 / ORM、包管理与仓库形式、测试框架、CI、常用命令、其他约定。信息不足的地方用 `<!-- TODO: 补充 xxx -->` 标注，不臆造。
2. 读 skills 根目录的 `README.md`，按技术栈选模块，列出清单让用户确认。没有现成模块的技术栈，提出新建 skill，不写进项目文件。
3. 在项目根目录创建 `.agents/agent-docs/`：
   - `project.md`：以 `## 项目概述` 开头，包含技术栈、目录结构、常用命令和只属于本项目的约定。
   - `modules.txt`：每行一个条目，按顺序拼装。`<分类>/<名>` 引用 skill，以 `.md` 结尾的读本目录下的文件，`#` 开头为注释。`project.md` 放第一行。
   - 按需创建 `claude-skills.md`（项目的 Skills 映射，只写入 CLAUDE.md）。
4. 运行 `scripts/build.sh <项目根目录>`，展示生成的文件让用户检查。

### 规则

- `claude/` 下的条目和 `claude-` 开头的文件只写入 CLAUDE.md。
- 不要直接修改生成的 AGENTS.md / CLAUDE.md。
- 项目配置文件里不要建名为 `claude.md` 的文件：Windows 盘大小写不敏感，会被当成 `CLAUDE.md` 加载。
