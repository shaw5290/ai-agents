## uni-app 规范

- 使用 Vue 3 `<script setup lang="ts">`。
- **IMPORTANT**：所有 API 请求必须经过 `src/api/request.ts`（封装 `uni.request`），页面中不直接调用 `uni.request`。
- **NEVER**：不要在前端代码中硬编码 API 地址；基础地址从环境变量 `import.meta.env.VITE_*` 读取。
- 使用 `uni.*` API，不使用 `window`、`document` 等浏览器专属 API。
- 平台差异用条件编译（`// #ifdef MP-WEIXIN`），收敛在工具层，不散落在页面中。
- 尺寸单位用 `rpx`。
- 非首屏页面放入分包；静态资源较大的放 CDN，不放主包。
- 页面在 `pages.json` 注册，路径 kebab-case。
