import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import path from 'path';
import { createHash } from 'node:crypto';
import { readdirSync, readFileSync, statSync } from 'node:fs';

// Both players of a friend match must run identical simulation code, so the build id
// is a hash of everything under src/client/game (engine, ratings, constants, teams).
function gameBuildId(): string {
  const hash = createHash('sha1');
  const walk = (dir: string) => {
    for (const name of readdirSync(dir).sort()) {
      const p = path.join(dir, name);
      if (statSync(p).isDirectory()) walk(p);
      else hash.update(name).update(readFileSync(p));
    }
  };
  walk(path.resolve(__dirname, 'src/client/game'));
  return hash.digest('hex').slice(0, 12);
}

export default defineConfig({
  root: 'src/client',
  define: { __BUILD_ID__: JSON.stringify(gameBuildId()) },
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src')
    }
  },
  build: { outDir: '../../dist', emptyOutDir: true },
  server: {
    host: "0.0.0.0",
    allowedHosts: true
  }
});
