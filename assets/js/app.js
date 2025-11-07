/* ===== V2 Data-Driven Recommender (GitHub Pages, no backend) ===== */

const state = { who:null, vibe:null, energy:null, length:null };
let CATALOG = [];
let PRESETS = null;

/* ---------- helpers ---------- */
const $ = s => document.querySelector(s);
const $all = s => [...document.querySelectorAll(s)];
const cap = s => s ? s[0].toUpperCase()+s.slice(1) : "";
const by = (k) => (a,b)=> (a[k]>b[k])? -1 : (a[k]<b[k])? 1 : 0;

function paramSync(push=true){
  const u = new URL(location.href);
  Object.entries(state).forEach(([k,v])=> v? u.searchParams.set(k,v):u.searchParams.delete(k));
  if(push) history.replaceState({}, "", u.toString());
}

function readParams(){
  const u = new URL(location.href);
  ["who","vibe","energy","length"].forEach(k=>{
    const v = u.searchParams.get(k);
    if(v){ state[k]=v; const btn = document.querySelector(`.fp-pills[data-group="${k}"] .fp-pill[data-value="${v}"]`); btn?.classList.add("is-active"); }
  });
}

/* ---------- UI wiring ---------- */
function initPills(){
  $all(".fp-pills").forEach(group=>{
    group.addEventListener("click", e=>{
      const btn = e.target.closest(".fp-pill"); if(!btn) return;
      group.querySelectorAll(".fp-pill").forEach(b=>b.classList.remove("is-active"));
      btn.classList.add("is-active");
      state[group.dataset.group] = btn.dataset.value;
      paramSync();
    });
  });
}

function renderShop(){
  const links = [
    ["Mugs","https://www.flickandpuff.com/collections/mugs"],
    ["Bottles & Tumblers","https://www.flickandpuff.com/collections/bottles-tumblers"],
    ["Coasters","https://www.flickandpuff.com/collections/coasters"],
    ["Notebooks","https://www.flickandpuff.com/collections/notebooks-stationery"],
    ["Pillows","https://www.flickandpuff.com/collections/pillows"],
    ["Posters","https://www.flickandpuff.com/collections/posters-wall-art"],
    ["Totes & Bags","https://www.flickandpuff.com/collections/totes-bags"],
    ["Desk Mats","https://www.flickandpuff.com/collections/desk-mats-mouse-pads"],
    ["Blankets & Throws","https://www.flickandpuff.com/collections/blankets-throws"],
    ["Gift Cards","https://www.flickandpuff.com/collections/gift-cards"],
    ["Sip & Hydrate","https://www.flickandpuff.com/collections/sip-hydrate"],
    ["Cozy Textiles","https://www.flickandpuff.com/collections/cozy-textiles"],
    ["Desk Essentials","https://www.flickandpuff.com/collections/desk-essentials"],
    ["New Arrivals","https://www.flickandpuff.com/collections/new-arrivals"],
    ["On Sale","https://www.flickandpuff.com/collections/on-sale"],
    ["Best Sellers","https://www.flickandpuff.com/collections/best-sellers"],
  ];
  const row = $("#shopRow"); row.innerHTML = "";
  links.forEach(([t,h])=>{
    const a=document.createElement("a"); a.className="fp-chip"; a.href=h; a.target="_blank"; a.rel="noopener"; a.textContent=t; row.appendChild(a);
  });
}

function buildGoogleLink(){
  const q = [state.who, state.vibe, state.energy, state.length, "movie night picks"].filter(Boolean).join(" ");
  $("#gSearch").href = "https://www.google.com/search?q="+encodeURIComponent(q);
}

function fillChecklist(){
  const set = PRESETS.checklists[state.who]?.[state.energy] || PRESETS.checklists.default;
  const ul = $("#setupList"); ul.innerHTML = "";
  set.forEach(t=>{
    const li=document.createElement("li");
    li.innerHTML=`<label><input type="checkbox"/> <span>${t}</span></label>`;
    ul.appendChild(li);
  });
}

function fillMusic(){
  const m = PRESETS.music[state.vibe]?.[state.energy] || PRESETS.music.default;
  $("#musicBox").innerHTML = `<strong>${m.title}</strong><br>${m.detail}`;
  $("#spotifyLink").href = m.spotify;
  $("#ytMusicLink").href = m.youtube;
}

function fillAmbient(){
  const a = PRESETS.ambient[state.vibe]?.[state.energy] || PRESETS.ambient.default;
  $("#ambientBox").innerHTML = `<strong>${a.title}</strong><br>${a.detail}`;
  $("#ambientLink").href = a.url;
}

/* ---------- Scoring Engine ---------- */
/* Movie schema (see data/catalog.json)
{
 id, title, year, poster, length, tags:[...], audience:["solo","partner","crew","family"], vibes:["relaxed","romantic"...],
 energy:["low","medium","high"], era:"classic|modern", friendly:["family","crew"] (optional), intensity:1..3
}
*/
const WEIGHTS = {
  audience: 4, vibes: 4, energy: 3, length: 3, friendly: 2, era: 1, intensity: 1
};

function score(movie){
  let s = 0;
  if(movie.audience?.includes(state.who)) s += WEIGHTS.audience;
  if(movie.vibes?.includes(state.vibe))   s += WEIGHTS.vibes;
  if(movie.energy?.includes(state.energy)) s += WEIGHTS.energy;

  if(state.length && movie.length===state.length) s += WEIGHTS.length;

  if(state.who==="family" && movie.friendly?.includes("family")) s += WEIGHTS.friendly;
  if(state.who==="crew"   && movie.friendly?.includes("crew"))   s += WEIGHTS.friendly;

  // tie-breakers
  if(movie.era==="classic" && state.vibe!=="escape") s += WEIGHTS.era;
  if(state.energy==="low" && movie.intensity===1) s += WEIGHTS.intensity;
  if(state.energy==="high" && movie.intensity===3) s += WEIGHTS.intensity;

  return s;
}

function renderCards(picks){
  const wrap = $("#topList"); wrap.innerHTML = "";
  picks.slice(0,6).forEach(m=>{
    const card = document.createElement("div");
    card.className="fp-card-movie";
    const poster = m.poster || "https://via.placeholder.com/92x138?text=Poster";
    const g = "https://www.google.com/search?q="+encodeURIComponent(m.title+" "+m.year+" watch");
    card.innerHTML = `
      <img alt="${m.title}" src="${poster}">
      <div class="fp-mv-body">
        <h4 class="fp-mv-title">${m.title}</h4>
        <div class="fp-mv-meta">${m.year} • ${cap(m.length)} • ${m.era}</div>
        <div class="fp-tags">
          ${[...(m.vibes||[]), ...(m.tags||[])].slice(0,4).map(t=>`<span class="fp-tag">${t}</span>`).join("")}
        </div>
        <div class="fp-cta"><a href="${g}" target="_blank" rel="noopener">Find it</a></div>
      </div>`;
    wrap.appendChild(card);
  });

  const alt = $("#altList"); alt.innerHTML = "";
  picks.slice(6,18).forEach(m=>{
    const g = "https://www.google.com/search?q="+encodeURIComponent(m.title+" "+m.year+" watch");
    const li = document.createElement("li");
    li.innerHTML = `<a href="${g}" target="_blank" rel="noopener">${m.title}</a> <span class="fp-mv-meta">(${m.year}, ${cap(m.length)})</span>`;
    alt.appendChild(li);
  });
}

/* ---------- Build ---------- */
function build(){
  const ready = state.who && state.vibe && state.energy && state.length;
  if(!ready){ alert("Pick one option in each group."); return; }

  $("#metaLine").textContent = `${cap(state.who)} · ${cap(state.vibe)} · ${cap(state.energy)} energy · ${cap(state.length)}`;
  fillChecklist();
  fillMusic();
  fillAmbient();
  buildGoogleLink();

  const ranked = CATALOG
    .map(m => ({...m, _score: score(m)}))
    .sort(by("_score"));

  renderCards(ranked);
  $("#results").classList.remove("is-hidden");
  window.scrollTo({top: $("#results").offsetTop - 8, behavior:"smooth"});
}

/* ---------- Events ---------- */
function wire(){
  $("#buildBtn").addEventListener("click", build);
  $("#shuffleBtn").addEventListener("click", ()=>{
    const rot = (arr,v)=> arr[(arr.indexOf(v)+1)%arr.length];
    state.energy = rot(["low","medium","high"], state.energy||"low");
    document.querySelectorAll(`.fp-pills[data-group="energy"] .fp-pill`).forEach(b=>b.classList.toggle("is-active", b.dataset.value===state.energy));
    paramSync();
    if(state.who && state.vibe && state.length) build();
  });
  $("#resetBtn").addEventListener("click", ()=>{
    Object.keys(state).forEach(k=> state[k]=null);
    document.querySelectorAll(".fp-pill.is-active").forEach(b=>b.classList.remove("is-active"));
    $("#results").classList.add("is-hidden");
    paramSync();
    window.scrollTo({top:0,behavior:"smooth"});
  });
  $("#printBtn").addEventListener("click", ()=> window.print());
}

/* ---------- Boot ---------- */
async function boot(){
  [CATALOG, PRESETS] = await Promise.all([
    fetch("data/catalog.json").then(r=>r.json()),
    fetch("data/presets.json").then(r=>r.json())
  ]);
  initPills();
  renderShop();
  readParams();
  wire();
  if(state.who && state.vibe && state.energy && state.length) build();
}
boot();
