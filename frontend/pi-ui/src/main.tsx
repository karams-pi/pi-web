import React from "react";
import ReactDOM from "react-dom/client";
import { HashRouter } from "react-router-dom";
import App from "./App";
import "./index.css";

// Interceptar fetch para tratar rotas relativas do EDC na nuvem (produção)
const originalFetch = window.fetch;
window.fetch = async (input, init) => {
  let url = "";
  if (typeof input === "string") {
    url = input;
  } else if (input instanceof URL) {
    url = input.toString();
  } else if (input && typeof input === "object" && "url" in input) {
    url = (input as Request).url;
  }

  if (url.startsWith("/api/edc/")) {
    const apiBase = (import.meta.env.VITE_API_BASE ?? "http://localhost:5000").replace(/\/+$/, "");
    const targetUrl = `${apiBase}${url}`;
    if (typeof input === "string") {
      return originalFetch(targetUrl, init);
    } else if (input instanceof URL) {
      return originalFetch(new URL(targetUrl), init);
    } else {
      const newRequest = new Request(targetUrl, input as RequestInfo);
      return originalFetch(newRequest, init);
    }
  }

  return originalFetch(input, init);
};

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <HashRouter>
      <App />
    </HashRouter>
  </React.StrictMode>,
);

