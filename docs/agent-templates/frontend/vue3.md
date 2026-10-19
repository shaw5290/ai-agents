## Vue 3 规范

- 使用 `<script setup lang="ts">` + 组合式 API，不用选项式 API。
- 请求统一封装在 `api/` 目录，按业务模块拆分；页面中不直接调用 `axios` / `fetch`。
- 接口入参和返回值定义 TypeScript 类型，禁止 `any`。
- 全局状态用 Pinia；只在组件内使用的状态不放进 store。
- 可复用逻辑抽成 `composables/useXxx.ts`。
- 组件名 PascalCase，文件夹与路由路径 kebab-case。
- props 用 `defineProps<T>()` 声明类型，事件用 `defineEmits<T>()`。
