## Vue 3 规范

- 使用 `<script setup lang="ts">` + 组合式 API，不用选项式 API。
- **IMPORTANT**：所有 API 请求必须经过 `src/api/request.ts` 封装；接口按业务模块拆分在 `src/api/` 下，页面中不直接调用 `axios` / `fetch`。
- **NEVER**：不要在前端代码中硬编码 API 地址；基础地址从环境变量 `import.meta.env.VITE_*` 读取。
- 接口入参和返回值定义 TypeScript 类型，禁止 `any`。
- 全局状态用 Pinia；只在组件内使用的状态不放进 store。
- 可复用逻辑抽成 `composables/useXxx.ts`。
- 组件名 PascalCase，文件夹与路由路径 kebab-case。
- props 用 `defineProps<T>()` 声明类型，事件用 `defineEmits<T>()`。
