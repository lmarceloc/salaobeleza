import { defineConfig } from 'vite';
import { resolve } from 'path';

const cleanUrls = {
  name: 'clean-urls',
  configureServer(server) {
    server.middlewares.use((req, _res, next) => {
      if (req.url === '/login') req.url = '/login.html';
      else if (req.url === '/dashboard') req.url = '/dashboard.html';
      next();
    });
  },
};

export default defineConfig({
  appType: 'mpa',
  plugins: [cleanUrls],
  build: {
    target: 'es2022',
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        login: resolve(__dirname, 'login.html'),
        dashboard: resolve(__dirname, 'dashboard.html'),
      },
    },
  },
});
