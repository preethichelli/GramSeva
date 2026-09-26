import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// GramSeva Admin Dashboard — Vite + plain JS React
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
  },
})
