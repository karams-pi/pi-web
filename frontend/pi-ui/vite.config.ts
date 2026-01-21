import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      "/api": {
        target: "http://localhost:5000", // <- troque para a porta do seu backend
        changeOrigin: true,
        secure: false, // se usar https no backend, mantenha secure:false
      },
    },
  },
});
