/// <reference types="vitest" />
import react from "@vitejs/plugin-react-swc";
import { resolve } from "path";
import { defineConfig } from "vite";
import svgr from "vite-plugin-svgr";
// https://vitejs.dev/config/
export default defineConfig({
  base: "./",
  plugins: [
    react(),
    svgr({
      svgrOptions: {},
    }),
  ],
  test: {
    alias: {
      "@itential/rodeo-ui/lib/rodeo.css": resolve(
        __dirname,
        "node_modules/@itential/rodeo-ui/lib/rodeo.css",
      ),
      "@mui/material/styles": resolve(
        __dirname,
        "node_modules/@mui/material/styles",
      ),
      "@mui/x-date-pickers/AdapterDateFns": resolve(
        __dirname,
        "node_modules/@mui/x-date-pickers/AdapterDateFns",
      ),
      // ^ these need to come first or are overwritten
      "@itential/rodeo-ui": resolve(
        __dirname,
        "test/__mocks__/@itential/rodeo-ui.jsx",
      ),
      "@mui/material": resolve(__dirname, "test/__mocks__/@mui/material.jsx"),
      "@mui/x-data-grid": resolve(
        __dirname,
        "test/__mocks__/@mui/x-data-grid.tsx",
      ),
      "@mui/x-date-pickers": resolve(
        __dirname,
        "test/__mocks__/@mui/x-date-pickers.tsx",
      ),
      "@react-keycloak/web": resolve(
        __dirname,
        "test/__mocks__/@react-keycloak/web.js",
      ),
      "csv-file-validation": resolve(
        __dirname,
        "test/__mocks__/csv-file-validation.ts",
      ),
      "keycloak-js": resolve(__dirname, "test/__mocks__/keycloak-js.js"),
      nanoid: resolve(__dirname, "test/__mocks__/nanoid.ts"),
      "react-ace": resolve(__dirname, "test/__mocks__/react-ace.tsx"),
    },
    coverage: {
      enabled: true,
      exclude: [
        "builder",
        "dist",
        "helm",
        "helm-vars",
        "node_modules",
        "server",
        "test",
        "tofu",
        "utils",
      ],
      provider: "istanbul",
      reporter: ["cobertura", "text"],
      reportsDirectory: "./test/coverage/",
      reportOnFailure: true,
    },
    reporters: [["junit", { outputFile: "./junit.xml" }], ["verbose"]],
    server: {
      deps: {
        inline: ["@itential/cloud-portal-titlebar"],
      },
    },
    environment: "happy-dom",
    exclude: ["build", "node_modules"],
    globals: true,
    setupFiles: ["vitest-setup.ts"],
  },
  resolve: {
    alias: {
      "@itential/ace-builds/itential-webpack-resolver":
        "@itential/ace-builds/itential-url-resolver",
    },
  },
  build: {
    rollupOptions: {
      input: {
        main: "index.html", // entry point for your SPA
      },
      output: {
        entryFileNames: "[name].[hash].hashed.js",
        assetFileNames: "assets/[name].[hash].hashed[extname]",
      },
    },
    outDir: "dist", // directory to output the built files
  },
});
