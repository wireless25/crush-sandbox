import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig(({ command }) => ({
  plugins: [
    vue(),
    tailwindcss(),
  ],
  base: command === "serve" ? "/" : "/crush-sandbox/",
}));