import type { PropsWithChildren } from "react";

export function AppShell({ children }: PropsWithChildren) {
  return (
    <div style={styles.shell}>
      <header style={styles.header}>
        <div style={styles.brand}>
          <strong>PI</strong>
          <span style={styles.subtitle}>Painel</span>
        </div>
      </header>

      <main style={styles.main}>
        <section style={styles.card}>{children}</section>
      </main>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  shell: { minHeight: "100vh" },
  header: {
    height: 64,
    display: "flex",
    alignItems: "center",
    padding: "0 20px",
    borderBottom: "1px solid rgba(255,255,255,0.08)",
    background: "rgba(0,0,0,0.15)",
    backdropFilter: "blur(8px)",
    position: "sticky",
    top: 0,
  },
  brand: { display: "flex", gap: 10, alignItems: "baseline" },
  subtitle: { color: "#9ca3af", fontSize: 14 },
  main: {
    padding: 24,
    display: "grid",
    placeItems: "start center",
  },
  card: {
    width: "min(1100px, 100%)",
    background: "rgba(255,255,255,0.06)",
    border: "1px solid rgba(255,255,255,0.10)",
    borderRadius: 16,
    padding: 24,
    boxShadow: "0 20px 60px rgba(0,0,0,.35)",
  },
};
