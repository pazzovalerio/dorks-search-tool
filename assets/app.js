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

  if (!kw) {
    alert("Inserisci una parola chiave");
    return;
  }

  let out = "";

  DORKS[category.value].queries.forEach(q => {
    let query = q.replaceAll('{{keyword}}', kw);
    if (siteVal) query = `site:${siteVal} ` + query;

    out += query + "\n\n";

    window.open(
      "https://www.google.com/search?q=" + encodeURIComponent(query),
      "_blank"
    );
  });

  output.textContent = out;
};
