# AI 编码助手配置说明

本项目为 Claude Code、Codex、Cursor 等 AI 编码助手准备了一组指令文档。本文说明各文件的作用、加载关系和维护方式，供团队成员阅读；AI 不需要读本文。

## 文件一览

| 文件 | 读者 | 内容 | 是否入库 |
|---|---|---|---|
| `AGENTS.md` | 所有 AI 工具 | 项目概述、技术栈、目录结构、命令、编码规范 | 是 |
| `CLAUDE.md` | Claude Code | 与 `AGENTS.md` 相同的项目规范，外加 Claude Code 工作方式 | 是 |
| `CLAUDE.local.md` | Claude Code（个人） | 本机环境、本地服务地址、个人偏好 | 否 |
| `.claude/rules/coding-behavior.md` | Claude Code | 编码行为准则 | 是 |
| `.claude/rules/claude-extensions.md` | Claude Code | `.claude/` 扩展结构、常用指令、Skills 映射 | 是 |

## 加载关系

```
Claude Code
├── CLAUDE.md
├── CLAUDE.local.md            （自动加载）
└── .claude/rules/*.md         （自动加载）

Codex / Cursor 等
└── AGENTS.md
```

- `.claude/rules/` 下的文件由 Claude Code 自动加载，不需要在 `CLAUDE.md` 中再引用，否则会重复。

## 内容来源

| 文件 | 来源 | 取用方式 |
|---|---|---|
| `coding-behavior.md` | [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | 原文四条准则译为中文，删去解释性语句 |
| `claude-extensions.md` | [Everything Claude Code](https://github.com/affaan-m/everything-claude-code) | 只借用组织方式（扩展结构、指令表、Skills 映射），内容按本项目改写；原项目的插件专属命令（`/tdd`、`/e2e` 等）未引入 |

## 编写原则

- 指令文档只写给 AI 的规则、事实和命令，不写来源、背景、解释，这些写进本文。
- 每条规则都应能被检验，避免"尽量写好代码"这类空话。
- `AGENTS.md` 与 `CLAUDE.md` 各自独立、互不引用，项目规范在两份文件中保持一致。
- 版本历史由 git 记录，文档内不写变更记录。

## 维护

| 发生了什么 | 改哪里 |
|---|---|
| 技术选型确定 | `AGENTS.md` 与 `CLAUDE.md` 技术栈表，去掉「待定」 |
| 新增或调整模块 | `AGENTS.md` 与 `CLAUDE.md` 目录结构 |
| 脚手架、脚本变化 | `AGENTS.md` 与 `CLAUDE.md` 常用命令，确保每条都能直接运行 |
| 新建 skill / 命令 / 子代理 | `claude-extensions.md` 的指令表和 Skills 映射 |
| AI 反复犯同一类错误 | 对应规范小节，或在 `.claude/rules/` 新增规则文件 |
| 只和自己电脑有关的配置 | `CLAUDE.local.md` |

`CLAUDE.local.md` 和 `.claude/settings.local.json` 已加入 `.gitignore`。新成员可参照 `CLAUDE.local.md` 的结构自行创建。
