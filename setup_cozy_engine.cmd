@echo off
setlocal enabledelayedexpansion

REM === Carpetas ===
mkdir public\assets 2>nul
mkdir data 2>nul
mkdir src\pages 2>nul
mkdir src\components 2>nul
mkdir src\lib 2>nul
mkdir src\styles 2>nul

REM === README ===
(
echo # Flick ^& Puff — Cozy Night Engine (Opcion A)
echo Static app (Astro) with curated JSON data. Embed via iframe into Shopify Cozy Hub.
echo.
echo ## Quick start
echo 1. npm create astro@latest -- --template minimal
echo 2. Replace/add files from this repo structure.
echo 3. npm i ^&^& npm run dev   (or npm run build)
echo 4. Publish to GitHub Pages and embed the URL in Shopify.
) > README.md

REM === astro.config.mjs ===
(
echo import { defineConfig } from 'astro/config';
echo export default defineConfig({
echo ^  output: 'static',
echo ^  integrations: [],
echo });
) > astro.config.mjs

REM === package.json (minimo; ajusta tras "npm create astro") ===
(
echo {
echo   "name": "flickandpuff-movie-night",
echo   "version": "0.1.0",
echo   "private": true,
echo   "scripts": {
echo     "dev": "astro dev",
echo     "build": "astro build",
echo     "preview": "astro preview"
echo   },
echo   "dependencies": {}
echo }
) > package.json

REM === Data JSONs ===
(
echo [
echo   { "tmdb": 120467, "title": "The Grand Budapest Hotel", "year": 2014, "runtime": 100, "genres": ["Comedy","Drama"], "rating": "R", "themes": ["wes","comfort-classics"], "cozy": 0.90, "pace": 0.7 },
echo   { "tmdb": 194, "title": "Amelie", "year": 2001, "runtime": 122, "genres": ["Romance","Comedy"], "rating": "PG-13", "themes": ["romcom90s","comfort-classics"], "cozy": 0.95, "pace": 0.4 },
echo   { "tmdb": 129, "title": "Spirited Away", "year": 2001, "runtime": 125, "genres": ["Animation","Fantasy"], "rating": "PG", "themes": ["ghibli","light-scifi"], "cozy": 0.92, "pace": 0.5 }
echo ]
) > data\movies.json

(
echo {
echo   "relaxed": ["yID_FIREPLACE_1","yID_RAIN_CABIN_1"],
echo   "romantic": ["yID_CANDLE_DINNER_1"],
echo   "playful": ["yID_COZY_CAFE_1"],
echo   "escape":  ["yID_SPACE_WINDOW_1"]
echo }
) > data\ambient.json

(
echo {
echo   "default": "https://open.spotify.com/playlist/1DAVUwELWTJ8eUe484w0rj",
echo   "relaxed": { "low": null, "medium": null, "high": null },
echo   "romantic": { "low": null, "medium": null, "high": null },
echo   "playful":  { "low": null, "medium": null, "high": null },
echo   "escape":   { "low": null, "medium": null, "high": null }
echo }
) > data\playlists.json

(
echo {
echo   "generic": [
echo     "Dim lights, one candle.",
echo     "Warm tea or cocoa.",
echo     "Do Not Disturb for 45 min."
echo   ],
echo   "snacks": {
echo     "relaxed": "Herbal tea ^+ dark chocolate.",
echo     "romantic": "Sparkling drink ^+ strawberries.",
echo     "playful":  "Popcorn ^+ candy mix.",
echo     "escape":   "Butter popcorn ^+ iced cola."
echo   }
echo }
) > data\pairings.json

(
echo [
echo   {"slug":"ghibli","name":"Studio Ghibli"},
echo   {"slug":"wes","name":"Wes Anderson"},
echo   {"slug":"romcom90s","name":"90s/00s Rom-Com"},
echo   {"slug":"cozy-mystery","name":"Cozy Mystery"},
echo   {"slug":"rainy-day","name":"Rainy Day"},
echo   {"slug":"holiday","name":"Holiday Classics"},
echo   {"slug":"feel-good","name":"Feel-Good Comedy"},
echo   {"slug":"nature-docs","name":"Nature Docs"},
echo   {"slug":"light-scifi","name":"Light Sci-Fi"},
echo   {"slug":"comfort-classics","name":"Comfort Classics"}
echo ]
) > data\themes.json

REM === Styles ===
(
echo :root{
echo   --ink:#2c2f33; --sub:#6b6f74; --cream:#f5f1e8; --paper:#fbf8f2;
echo   --amber:#C99F5C; --amber-d:#A67A47; --border:rgba(201,159,92,.22);
echo   --radius:10px;
echo }
) > src\styles\tokens.css

(
echo *{box-sizing:border-box}
echo html,body{margin:0;background:var(--cream);color:var(--ink)}
echo body{font-family:Manrope,system-ui,Segoe UI,Roboto,Arial,sans-serif}
echo .container{max-width:980px;margin:24px auto;padding:0 16px}
echo .title-serif{font-family:"Cormorant Garamond",serif}
echo .btn{display:inline-block;padding:12px 28px;border-radius:var(--radius);border:2px solid;line-height:1;cursor:pointer;font-weight:800;letter-spacing:.4px;text-transform:uppercase;font-size:12px}
echo .btn-primary{background:linear-gradient(135deg,var(--amber),var(--amber-d));border-color:var(--amber);color:#fff}
echo .btn-primary:hover{transform:translateY(-2px);box-shadow:0 12px 28px rgba(201,159,92,.3)}
echo .chip{appearance:none;border:1.5px solid var(--border);background:#fff;border-radius:999px;padding:9px 14px;font-weight:800;cursor:pointer;transition:.2s}
echo .chip.active{background:linear-gradient(135deg,var(--amber),var(--amber-d));color:#fff;border-color:var(--amber);box-shadow:0 6px 16px rgba(201,159,92,.25)}
echo .card{background:rgba(255,255,255,.8);backdrop-filter:blur(8px);border:1px solid var(--border);border-radius:16px;box-shadow:0 8px 28px rgba(0,0,0,.06)}
) > src\styles\base.css

(
echo @media print{
echo   body{background:#fff}
echo   .no-print{display:none !important}
echo   .itinerary{box-shadow:none;border:1px solid #ddd}
echo }
) > src\styles\print.css

REM === Components ===
(
echo ---
echo ---
echo <button class="chip" data-value={Astro.props.value}>
echo   ^{Astro.slots.default ? ^<slot /^> : Astro.props.label}
echo </button>
) > src\components\Chips.astro

(
echo ---
echo const { href, label = 'Button', variant = 'primary' } = Astro.props;
echo ---
echo <a href={href} class={"btn " + (variant === 'primary' ? 'btn-primary' : '')}><slot>{label}</slot></a>
) > src\components\Button.astro

(
echo ---
echo const { plan } = Astro.props;
echo ---
echo <section class="itinerary card" style="overflow:hidden">
echo   <div style="padding:18px;border-bottom:1px solid var(--border);background:#fff;">
echo     <h2 class="title-serif" style="margin:0;font-size:24px;">Cozy Night Itinerary</h2>
echo     <p style="margin:6px 0 0;color:var(--sub);font-weight:700;">^{plan.meta}</p>
echo   </div>
echo   <div style="padding:18px">
echo     <h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;">Setup</h4>
echo     <ul style="list-style:none;margin:0;padding:0;display:grid;grid-template-columns:repeat(2,1fr);gap:10px;">
echo       ^{plan.setup.map(s =^> `^<li style='display:flex;gap:10px'^>^<span style='width:17px;height:17px;border:2px solid var(--amber);border-radius:4px;margin-top:2px;display:inline-block'^>^</span^>^<span^>${s}^</span^>^</li^>`).join('')}
echo     </ul>
echo   </div>
echo   <div style="padding:18px;border-top:1px solid var(--border);">
echo     <h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;">Watch / Do</h4>
echo     <div style="background:var(--paper);border-left:4px solid var(--amber);border-radius:8px;padding:14px 16px;margin:8px 0">
echo       ^<strong^>^{plan.watch.title}^</strong^>^<br /^>^{plan.watch.desc}
echo     </div>
echo     ^<p style="color:var(--sub);font-size:14px;margin:0"^>^{plan.watch.note}^</p^>
echo   </div>
echo   <div style="padding:18px;border-top:1px solid var(--border);">
echo     <h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;">Soundtrack</h4>
echo     <div style="background:var(--paper);border-left:4px solid var(--amber);border-radius:8px;padding:14px 16px;margin:8px 0">
echo       ^<strong^>^{plan.music.title}^</strong^>^<br /^>^{plan.music.desc}
echo     </div>
echo   </div>
echo   <div style="padding:18px;border-top:1px solid var(--border);">
echo     <h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;">Ambient</h4>
echo     ^<p style="margin:0"^>^{plan.ambient}^</p^>
echo   </div>
echo   <div style="padding:18px;border-top:1px solid var(--border);">
echo     <h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;">Shop the vibe</h4>
echo     <div style="display:flex;flex-wrap:wrap;gap:8px">
echo       ^{plan.shop.map(s =^> `^<a class='chip' style='text-decoration:none' href='${s.url}' target='_top' rel='noopener'^>${s.label}^</a^>`).join('')}
echo     </div>
echo   </div>
echo   <div class="no-print" style="background:linear-gradient(0deg, rgba(201,159,92,.07), rgba(201,159,92,0));padding:12px 18px;border-bottom-left-radius:16px;border-bottom-right-radius:16px">
echo     ^<p style="color:var(--sub);font-size:14px;margin:0"^>^{plan.tip}^</p^>
echo   </div>
echo </section>
) > src\components\Itinerary.astro

REM === Lib: recEngine y urlState ===
(
echo export function buildPlan(input, db) {
echo   const { who, mood, energy } = input;
echo   const pool = filterPool(db.movies, who, mood, energy);
echo   const main = pool[0] || db.movies[0];
echo   const meta = `${who} \xb7 ${mood} \xb7 ${energy}`;
echo   return {
echo     meta,
echo     setup: buildSetup(energy, who),
echo     watch: { title: main.title + ^" (" ^+ main.year ^+ ^")^", desc: descFor(mood, energy), note: noteFor(who),
echo              google: `https://www.google.com/search?q=${encodeURIComponent(main.title ^+ " watch streaming")}` },
echo     music: { title: "Playlist", desc: db.playlists.default || "Open Spotify playlist" },
echo     ambient: "Open an ambient room on YouTube for this vibe.",
echo     shop: db.shop,
echo     tip: tipFor(who)
echo   };
echo }
echo
echo function filterPool(list, who, mood, energy){
echo   const avoid = (mood==='relaxed') ? ['Horror','War'] : [];
echo   return list.filter(t => {
echo     if (who==='family' ^&^& (t.rating==='R' ^|^| t.genres.includes('Horror'))) return false;
echo     if (avoid.some(a => t.genres.includes(a))) return false;
echo     return true;
echo   }).sort((a,b)=> (b.cozy - a.cozy) || (a.runtime - b.runtime));
echo }
echo function buildSetup(energy, who){
echo   const base = {
echo     low: ['Lights low, one candle.','Warm drink ready.','Do Not Disturb for 45 min.'],
echo     medium: ['2-3 soft lights.','Snacks ready.','Timer for a short break.'],
echo     high: ['Snack bar (sweet + salty).','"Cinema" volume.','Planned intermission.']
echo   }[energy] || [];
echo   const extra = {solo:'Phone on Focus.',partner:'Share one blanket.',crew:'Extra cushions/chairs.',family:'Hot chocolate mugs.'}[who] || '';
echo   return extra ? [...base, extra] : base;
echo }
echo const descFor = (mood,energy) => ({
echo   relaxed: {low:'Gentle, low-stakes feature.',medium:'Nature/feel-good film.',high:'Two cozy-drama episodes.'},
echo   romantic:{low:'Short romance + candle ritual.',medium:'Indie romance feature.',high:'Romantic epic / double.'},
echo   playful: {low:'2–3 comfort sitcom episodes.',medium:'Comedy feature + snack.',high:'Heist/comedy event night.'},
echo   escape:  {low:'Comfort fantasy film.',medium:'Adventure classic.',high:'Sci-fi mind-bender.'}
echo })[mood][energy];
echo const noteFor = who => ({solo:'Keep it light and guilt-free.',partner:'Lower volume to invite closeness.',crew:'Avoid polarizing themes.',family:'Add a short intermission.'}[who]);
echo const tipFor = who => ({solo:'Pre-warm the blanket 3 min.',partner:'2–3 candles; no ceiling lights.',crew:'Split snacks in 2 stations.',family:'Let kids pick toppings.'}[who]);
) > src\lib\recEngine.ts

(
echo export function readState() {
echo   const p = new URLSearchParams(location.search);
echo   return {
echo     who: p.get('who') || null,
echo     mood: p.get('mood') || null,
echo     energy: p.get('energy') || null
echo   };
echo }
echo export function writeState(s){
echo   const p = new URLSearchParams();
echo   if(s.who) p.set('who', s.who);
echo   if(s.mood) p.set('mood', s.mood);
echo   if(s.energy) p.set('energy', s.energy);
echo   const url = location.pathname + '?' + p.toString();
echo   history.replaceState({}, '', url);
echo }
) > src\lib\urlState.ts

REM === Page: index.astro (Builder + Itinerary) ===
(
echo ---
echo import "../styles/tokens.css";
echo import "../styles/base.css";
echo import "../styles/print.css";
echo import Itinerary from "../components/Itinerary.astro";
echo const movies = await Astro.fetchContent('^/data/movies.json');
echo const ambient = await Astro.fetchContent('^/data/ambient.json');
echo const playlists = await Astro.fetchContent('^/data/playlists.json');
echo const pairings = await Astro.fetchContent('^/data/pairings.json');
echo const shop = [
echo   {label:'Mugs', url:'https://www.flickandpuff.com/collections/mugs'},
echo   {label:'Bottles ^& Tumblers', url:'https://www.flickandpuff.com/collections/bottles-tumblers'},
echo   {label:'Coasters', url:'https://www.flickandpuff.com/collections/coasters'},
echo   {label:'Notebooks', url:'https://www.flickandpuff.com/collections/notebooks-stationery'},
echo   {label:'Pillows', url:'https://www.flickandpuff.com/collections/pillows'},
echo   {label:'Posters', url:'https://www.flickandpuff.com/collections/posters-wall-art'},
echo   {label:'Totes', url:'https://www.flickandpuff.com/collections/totes-bags'},
echo   {label:'Desk Mats', url:'https://www.flickandpuff.com/collections/desk-mats-mouse-pads'},
echo   {label:'Blankets', url:'https://www.flickandpuff.com/collections/blankets-throws'},
echo   {label:'Gift Cards', url:'https://www.flickandpuff.com/collections/gift-cards'}
echo ];
echo const db = { movies: (await import('^/data/movies.json')).default, ambient: (await import('^/data/ambient.json')).default, playlists: (await import('^/data/playlists.json')).default, pairings: (await import('^/data/pairings.json')).default, shop };
echo ---
echo
echo ^<!DOCTYPE html^>
echo ^<html lang="en"^>
echo ^<head^>
echo   ^<meta charset="utf-8" /^>
echo   ^<meta name="viewport" content="width=device-width, initial-scale=1" /^>
echo   ^<title^>Cozy Night Recommender · Flick ^& Puff^</title^>
echo   ^<link rel="preconnect" href="https://fonts.googleapis.com"^>
echo   ^<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin^>
echo   ^<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700^&family=Manrope:wght@400;600;700;800;900^&display=swap" rel="stylesheet"^>
echo ^</head^>
echo ^<body^>
echo   ^<div class="container"^>
echo     ^<header style="text-align:center;margin-bottom:16px"^>
echo       ^<h1 class="title-serif" style="font-weight:700;letter-spacing:-.2px;font-size:34px;margin:0 0 4px"^>Cozy Night Recommender^</h1^>
echo       ^<p style="color:var(--sub);margin:0;font-size:15px"^>Pick who you^'re with, your vibe, and energy.^</p^>
echo     ^</header^>
echo
echo     ^<section class="card" style="padding:14px"^>
echo       ^<div style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px"^>
echo         ^<div^>
echo           ^<h3 style="margin:0 0 8px;font-size:13px;letter-spacing:.4px;font-weight:900;text-transform:uppercase"^>Who^</h3^>
echo           ^<div style="display:flex;flex-wrap:wrap;gap:8px" id="g-who"^>
echo             ^<button class="chip" data-group="who" data-value="solo"^>^🎧 Solo^</button^>
echo             ^<button class="chip" data-group="who" data-value="partner"^>^💛 Partner^</button^>
echo             ^<button class="chip" data-group="who" data-value="crew"^>^👯 Crew^</button^>
echo             ^<button class="chip" data-group="who" data-value="family"^>^🏠 Family^</button^>
echo           ^</div^>
echo         ^</div^>
echo         ^<div^>
echo           ^<h3 style="margin:0 0 8px;font-size:13px;letter-spacing:.4px;font-weight:900;text-transform:uppercase"^>Vibe^</h3^>
echo           ^<div style="display:flex;flex-wrap:wrap;gap:8px" id="g-mood"^>
echo             ^<button class="chip" data-group="mood" data-value="relaxed"^>^☁️ Relaxed^</button^>
echo             ^<button class="chip" data-group="mood" data-value="romantic"^>^🕯️ Romantic^</button^>
echo             ^<button class="chip" data-group="mood" data-value="playful"^>^😄 Playful^</button^>
echo             ^<button class="chip" data-group="mood" data-value="escape"^>^🚀 Escape^</button^>
echo           ^</div^>
echo         ^</div^>
echo         ^<div^>
echo           ^<h3 style="margin:0 0 8px;font-size:13px;letter-spacing:.4px;font-weight:900;text-transform:uppercase"^>Energy^</h3^>
echo           ^<div style="display:flex;flex-wrap:wrap;gap:8px" id="g-energy"^>
echo             ^<button class="chip" data-group="energy" data-value="low"^>^🌙 Low^</button^>
echo             ^<button class="chip" data-group="energy" data-value="medium"^>^✨ Medium^</button^>
echo             ^<button class="chip" data-group="energy" data-value="high"^>^⚡ High^</button^>
echo           ^</div^>
echo         ^</div^>
echo       ^</div^>
echo       ^<div style="display:flex;gap:10px;justify-content:center;padding:10px 12px 16px;border-top:1px solid var(--border)"^>
echo         ^<button id="btn-build" class="btn btn-primary" disabled^>Build plan^</button^>
echo         ^<button id="btn-print" class="btn" disabled^>Print^</button^>
echo       ^</div^>
echo     ^</section^>
echo
echo     ^<div id="result" style="margin-top:16px"^>^</div^>
echo
echo     ^<p class="no-print" style="font-size:12px;color:var(--sub);text-align:center;margin:10px 0"^>^© Flick ^& Puff — static app. Embed via iframe.^</p^>
echo   ^</div^>
echo
echo   ^<script type="module"^>
echo     import { buildPlan } from '/src/lib/recEngine.ts';
echo     import { readState, writeState } from '/src/lib/urlState.ts';
echo     const db = %25db%25;
echo     const result = document.getElementById('result');
echo     const state = { who:null, mood:null, energy:null };
echo
echo     function updateButtons(){
echo       const ready = !!(state.who ^&^& state.mood ^&^& state.energy);
echo       document.getElementById('btn-build').disabled = !ready;
echo       document.getElementById('btn-print').disabled = !document.querySelector('.itinerary');
echo     }
echo     function selectChip(groupEl, value){
echo       groupEl.querySelectorAll('.chip').forEach(b=^>b.classList.remove('active'));
echo       const btn = groupEl.querySelector(`.chip[data-value="^${value}^"]`);
echo       if(btn) btn.classList.add('active');
echo     }
echo     function wireGroup(id,key){
echo       const el = document.getElementById(id);
echo       el.addEventListener('click', e=^>{
echo         const b = e.target.closest('.chip'); if(!b) return;
echo         el.querySelectorAll('.chip').forEach(x=^>x.classList.remove('active'));
echo         b.classList.add('active'); state[key] = b.dataset.value; writeState(state); updateButtons(); postResize();
echo       });
echo     }
echo     wireGroup('g-who','who'); wireGroup('g-mood','mood'); wireGroup('g-energy','energy');
echo
echo     const init = readState(); ['who','mood','energy'].forEach(k=^>{ if(init[k]){ state[k]=init[k]; selectChip(document.getElementById('g-'+k), init[k]); } });
echo     updateButtons();
echo
echo     document.getElementById('btn-build').addEventListener('click', ()=^>{
echo       const plan = buildPlan(state, db);
echo       result.innerHTML = '';
echo       const host = document.createElement('div');
echo       host.setAttribute('id','it-host');
echo       result.appendChild(host);
echo       host.innerHTML = `^<div^>${JSON.stringify(plan)}^</div^>`;
echo       // Render "server-less": instanciar plantilla simple
echo       const html = `
echo         ^<section class="itinerary card" style="overflow:hidden"^>
echo           ^<div style="padding:18px;border-bottom:1px solid var(--border);background:#fff;"^>
echo             ^<h2 class="title-serif" style="margin:0;font-size:24px;"^>Cozy Night Itinerary^</h2^>
echo             ^<p style="margin:6px 0 0;color:var(--sub);font-weight:700;"^>${plan.meta}^</p^>
echo           ^</div^>
echo           ^<div style="padding:18px"^>
echo             ^<h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;"^>Setup^</h4^>
echo             ^<ul style="list-style:none;margin:0;padding:0;display:grid;grid-template-columns:repeat(2,1fr);gap:10px;"^>
echo               ${plan.setup.map(s=^>`^<li style='display:flex;gap:10px;align-items:flex-start'^>^<span style='width:17px;height:17px;border:2px solid var(--amber);border-radius:4px;margin-top:2px;display:inline-block'^>^</span^>^<span^>${s}^</span^>^</li^>`).join('')}
echo             ^</ul^>
echo           ^</div^>
echo           ^<div style="padding:18px;border-top:1px solid var(--border);"^>
echo             ^<h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;"^>Watch / Do^</h4^>
echo             ^<div style="background:var(--paper);border-left:4px solid var(--amber);border-radius:8px;padding:14px 16px;margin:8px 0"^>
echo               ^<strong^>${plan.watch.title}^</strong^>^<br /^>${plan.watch.desc}
echo             ^</div^>
echo             ^<p style="color:var(--sub);font-size:14px;margin:0"^>${plan.watch.note} ^| ^<a href="${plan.watch.google}" target="_top"^>where to watch^</a^>^</p^>
echo           ^</div^>
echo           ^<div style="padding:18px;border-top:1px solid var(--border);"^>
echo             ^<h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;"^>Soundtrack^</h4^>
echo             ^<div style="background:var(--paper);border-left:4px solid var(--amber);border-radius:8px;padding:14px 16px;margin:8px 0"^>
echo               ^<strong^>${plan.music.title}^</strong^>^<br /^>${plan.music.desc} — ^<a href="${db.playlists.default}" target="_top"^>Open on Spotify^</a^>
echo             ^</div^>
echo           ^</div^>
echo           ^<div style="padding:18px;border-top:1px solid var(--border);"^>
echo             ^<h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;"^>Ambient^</h4^>
echo             ^<p style="margin:0"^>${plan.ambient}^</p^>
echo           ^</div^>
echo           ^<div style="padding:18px;border-top:1px solid var(--border);"^>
echo             ^<h4 style="margin:0 0 8px;letter-spacing:.45px;text-transform:uppercase;font-weight:900;font-size:13px;"^>Shop the vibe^</h4^>
echo             ^<div style="display:flex;flex-wrap:wrap;gap:8px"^>
echo               ${db.shop.map(s=^>`^<a class='chip' style='text-decoration:none' href='${s.url}' target='_top' rel='noopener'^>${s.label}^</a^>`).join('')}
echo             ^</div^>
echo           ^</div^>
echo           ^<div class="no-print" style="background:linear-gradient(0deg, rgba(201,159,92,.07), rgba(201,159,92,0));padding:12px 18px;border-bottom-left-radius:16px;border-bottom-right-radius:16px"^>
echo             ^<p style="color:var(--sub);font-size:14px;margin:0"^>${plan.tip}^</p^>
echo           ^</div^>
echo         ^</section^>
echo       `;
echo       result.innerHTML = html;
echo       postResize();
echo     });
echo     document.getElementById('btn-print').addEventListener('click', ()=^> window.print());
echo
echo     function postResize(){
echo       try { parent.postMessage({type:'fp-resize', height: document.body.scrollHeight}, '*'); } catch(e){}
echo     }
echo     new ResizeObserver(postResize).observe(document.documentElement);
echo   ^</script^>
echo ^</body^>
echo ^</html^>
) > src\pages\index.astro

echo Listo. Estructura creada.
exit /b 0
