# 提示词：生成 AGENTS.md 文档

你是一名资深软件工程师，负责为当前项目编写一份符合官方规范的 `AGENTS.md` 文件。请根据我提供的项目信息，生成一份完整、可执行的 AGENTS.md。

### 背景知识

AGENTS.md 是给 AI 编码助手（如 Cursor、Aider、Gemini CLI 等）阅读的项目配置文件，目的是让 AI 快速理解项目、遵守规范、正确执行命令。官方规范建议包含以下内容：

1. **项目概述**（Project Overview）：项目是什么、技术栈、仓库结构
2. **构建和测试命令**（Setup Commands）：安装、开发、测试、构建等命令
3. **代码风格和规范**（Code Style）：语言特性、格式化工具、命名约定
4. **测试说明**（Testing Instructions）：CI 位置、测试命令、覆盖率要求
5. **PR 和提交规范**（PR Instructions）：标题格式、issue 关联、review 要求

完整示例还应包括：数据库命令、项目结构树、安全注意事项、常见问题（Common Issues）。

### 我需要你遵守的规则

- 使用 Markdown 格式，用 `##` 二级标题划分章节
- 命令使用反引号包裹，代码块标注语言
- 项目结构用代码块画目录树，并加行内注释
- 只写与项目实际相关的内容，不要编造不存在的命令或工具
- 信息不足时，用 `<!-- TODO: 补充 xxx -->` 标注，不要臆造
- 语言：中文说明 + 英文命令/代码（与示例风格一致）

### 请按以下结构输出

```
# AGENTS.md

## Project Overview
（项目名称、一句话定位、前后端/数据库/包管理技术栈）

## Setup Commands
（安装依赖、启动开发、测试、构建、lint、类型检查）

## Database Commands
（如适用：迁移、种子数据、可视化工具）

## Code Style Guidelines
### <语言/框架 1>
### <语言/框架 2>
### API Design（如适用）

## Project Structure
（目录树 + 注释）

## Testing Instructions
（CI 配置文件位置、单测/E2E 命令、覆盖率目标、合并前要求）

## PR Instructions
（标题格式、type 枚举、issue 关联、review 要求、CI 要求）

## Security Notes
（密钥管理、输入校验、查询安全等）

## Common Issues
### <常见报错 1>
### <常见报错 2>
```

### 我的项目信息

- 项目名称：{{项目名称}}
- 项目定位：{{一句话描述}}
- 前端技术栈：{{如 React 18 + TypeScript + Vite + TailwindCSS}}
- 后端技术栈：{{如 Node.js + Express + TypeScript}}
- 数据库 / ORM：{{如 PostgreSQL + Prisma}}
- 包管理器 / 仓库形式：{{如 pnpm monorepo}}
- 测试框架：{{如 Vitest + Playwright}}
- CI 工具：{{如 GitHub Actions，配置文件路径}}
- 团队规模与协作方式：{{如 3 前端 2 后端，GitHub PR 流程}}
- 其他约定：{{如状态管理用 Zustand、表单用 React Hook Form + Zod、响应格式 {code,data,message}}}

请根据以上信息生成完整的 AGENTS.md。
