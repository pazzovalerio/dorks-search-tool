#!/bin/bash
set -e

PROJECT="$HOME/dorks-search-tool"
cd "$PROJECT"

echo "======================================"
echo " REBUILD TOOL → DORKS BROWSER MODE"
echo "======================================"

# ======================
# index.html
# ======================
cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Dorks Browser</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>

<div class="app">
  <h1>🧭 Dorks Browser</h1>
  <p class="subtitle">Esplora query avanzate senza uscire dalla pagina</p>

  <label>Parola chiave</label>
  <input id="keyword" placeholder="es. backup, password, laravel">

  <label>Dominio / TLD (opzionale)</label>
  <input id="site" placeholder="example.com oppure .it">

  <div class="box">
    <strong>Tipologia</strong>
    <label><input type="checkbox" class="type" value="directory" checked> Directory</label>
    <label><input type="checkbox" class="type" value="backup" checked> Backup</label>
    <label><input type="checkbox" class="type" value="config"> Config</label>
    <label><input type="checkbox" class="type" value="database" checked> Database</label>
    <label><input type="checkbox" class="type" value="logs"> Log</label>
  </div>

  <div class="box">
    <strong>Estensioni file</strong>
    <label><input type="checkbox" class="ext" value="sql" checked> .sql</label>
    <label><input type="checkbox" class="ext" value="zip"> .zip</label>
    <label><input type="checkbox" class="ext" value="env"> .env</label>
    <label><input type="checkbox" class="ext" value="log"> .log</label>
    <label><input type="checkbox" class="ext" value="json"> .json</label>
  </div>

  <button id="run">Genera query</button>

  <pre id="results"></pre>

  <footer>
    ⚠️ Solo per studio, audit e siti autorizzati
  </footer>
</div>

<script src="assets/app.js"></script>
</body>
</html>
EOF

# ======================
# style.css
# ======================
cat > assets/style.css <<'EOF'
* { box-sizing: border-box; }

body {
  background: #0b0d12;
  color: #eaeaea;
  font-family: system-ui, sans-serif;
  margin: 0;
}

.app {
  max-width: 760px;
  margin: auto;
  padding: 20px;
}

.subtitle {
  color: #9aa0aa;
  margin-bottom: 20px;
}

label {
  display: block;
  margin: 6px 0;
  font-size: 14px;
}

input[type="text"], input {
  width: 100%;
  padding: 10px;
  margin-bottom: 14px;
  background: #151924;
  border: 1px solid #2a2f3a;
  color: #fff;
  border-radius: 6px;
}

.box {
  background: #121620;
  padding: 12px;
  border-radius: 6px;
  margin-bottom: 14px;
}

button {
  width: 100%;
  padding: 12px;
  background: #2563eb;
  border: none;
  border-radius: 6px;
  color: #fff;
  font-weight: bold;
  cursor: pointer;
}

pre {
  background: #0f1320;
  padding: 14px;
  border-radius: 6px;
  margin-top: 16px;
  white-space: pre-wrap;
  font-size: 13px;
}

pre a {
  color: #60a5fa;
  text-decoration: none;
}

pre a:hover {
  text-decoration: underline;
}

footer {
  margin-top: 20px;
  font-size: 12px;
  color: #7f8596;
  text-align: center;
}
EOF

# ======================
# app.js
# ======================
cat > assets/app.js <<'EOF'
const BASE_QUERIES = {
  directory: kw => `intitle:"index of" "${kw}"`,
  backup: kw => `intitle:"index of" "backup" "${kw}"`,
  config: kw => `filetype:env "${kw}"`,
  database: kw => `filetype:sql "${kw}"`,
  logs: kw => `filetype:log "${kw}"`
};

document.getElementById('run').onclick = () => {
  const kw = keyword.value.trim();
  const siteVal = site.value.trim();

  if (!kw) {
    alert("Inserisci una parola chiave");
    return;
  }

  const types = [...document.querySelectorAll('.type:checked')].map(e => e.value);
  const exts  = [...document.querySelectorAll('.ext:checked')].map(e => e.value);

  let out = "";

  types.forEach(t => {
    let q = BASE_QUERIES[t](kw);

    if (exts.length && t !== "directory") {
      exts.forEach(ext => {
        let fq = q.replace(/filetype:\w+/, `filetype:${ext}`);
        if (siteVal) fq = `site:${siteVal} ` + fq;
        const url = "https://www.google.com/search?q=" + encodeURIComponent(fq);
        out += `🔍 <a href="${url}" target="_blank">${fq}</a>\n`;
      });
    } else {
      if (siteVal) q = `site:${siteVal} ` + q;
      const url = "https://www.google.com/search?q=" + encodeURIComponent(q);
      out += `🔍 <a href="${url}" target="_blank">${q}</a>\n`;
    }

    out += "\n";
  });

  results.innerHTML = out || "Nessuna query generata";
};
EOF

echo "======================================"
echo " REBUILD COMPLETATO"
echo
echo "Ora esegui:"
echo "  git add ."
echo "  git commit -m \"Rebuild tool as in-page Dorks Browser\""
echo "  git push"
echo "======================================"
