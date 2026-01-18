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
