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
