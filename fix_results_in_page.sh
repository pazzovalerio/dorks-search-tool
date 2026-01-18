#!/bin/bash
set -e

PROJECT="$HOME/dorks-search-tool"

echo "======================================"
echo " FIX: RISULTATI MOSTRATI NELLA PAGINA "
echo "======================================"

cd "$PROJECT"

echo "[1/3] Aggiorno assets/app.js ..."

cat > assets/app.js <<'EOF'
let DORKS = {};

fetch('data/dorks.json')
  .then(r => r.json())
  .then(data => {
    DORKS = data;
    const sel = document.getElementById('category');
    Object.keys(data).forEach(k => {
      sel.innerHTML += `<option value="${k}">${data[k].label}</option>`;
    });
  });

document.getElementById('searchBtn').onclick = () => {
  const kw = keyword.value.trim();
  const siteVal = site.value.trim();
  const cat = category.value;

  if (!kw) {
    alert("Inserisci una parola chiave");
    return;
  }

  let html = "";

  DORKS[cat].queries.forEach(q => {
    let query = q.replaceAll('{{keyword}}', kw);
    if (siteVal) query = `site:${siteVal} ` + query;

    const url = "https://www.google.com/search?q=" + encodeURIComponent(query);

    html += `🔍 <a href="${url}" target="_blank">${query}</a>\n\n`;
  });

  output.innerHTML = html;
};
EOF

echo "[2/3] Aggiorno assets/style.css ..."

cat >> assets/style.css <<'EOF'

/* ===============================
   Risultati cliccabili
=============================== */
pre a {
  color: #60a5fa;
  text-decoration: none;
}

pre a:hover {
  text-decoration: underline;
}
EOF

echo "[3/3] Fatto."
echo
echo "Ora esegui:"
echo "  git status"
echo "  git add assets/app.js assets/style.css"
echo "  git commit -m \"Show search results inside page\""
echo "  git push"
echo
echo "======================================"
echo " FIX COMPLETATO"
echo "======================================"
