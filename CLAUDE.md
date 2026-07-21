# Agrar Assistent – Claude Project Guidelines

## Was ist das?
**Agrar Assistent** – Hilfstools für die digitale Landwirtschaft, aktuell der
**Pflanzenschutzmittel-Rechner** als **einzelne HTML-Datei** (`index.html`).
Läuft ohne Server, ohne Build, ohne Anmeldung direkt im Browser. Auslieferung über dieses
GitHub-Repo (GitHub Pages / Datei-Download); später kommen weitere Tools als Tabs in der
Kopfzeile dazu.

## Sprache
- **Chat/Kommunikation:** Deutsch.
- **Code (Bezeichner, Kommentare):** Englisch. Sichtbare UI-Texte sind Deutsch.

## Architektur & Constraints
- **Eine Datei, keine Abhängigkeiten:** Alles (HTML, CSS, JS) inline in `index.html`.
  Kein npm, kein Bundler, kein Framework, keine externen Fonts/CDN/Assets – die Datei muss
  offline lauffähig bleiben und (für die reine Berechnung) auch per Doppelklick von
  `file://` funktionieren.
- **Kein Server, kein eigenes Hosting.** Keine Backend-Aufrufe außer der öffentlichen
  BVL-API (s. u.). Kein Speichern/Persistenz – die Seite hält keinen Zustand über einen
  Reload hinaus.
- **Dark-Theme only** (Bildschirm). Farbwerte sind Material-3-Tokens (Seed `#FF9900`) als
  CSS-Variablen `--mat-sys-*` im `:root`. Ausnahme: der `@media print`-Block nutzt bewusst
  feste helle Druckfarben (Papier ist hell) – kein Verstoß gegen die Token-Regel.
- **Icons als inline-SVG** (keine Icon-Fonts).
- **Schrift:** `Inter Variable` ist als **Base64-`@font-face` eingebettet** (Subset
  `latin`, dieselbe Datei wie die Legacy-Website via `@fontsource-variable/inter`).
  Bewusst **kein Font-CDN** – kein Fremd-Datenabfluss (DSGVO), wie beim Legacy selbst
  gehostet. System-Fallback (`Segoe UI`/`system-ui`) bleibt.
- **Kopfzeile = Topbar** im Website-Look (`agrar-assistent.de`): volle Breite, dunkelgraue Bar
  (`--mat-sys-surface-container`, #262626; bewusst dunkler als die Website-Navbar), Logo + orange „Agrar Assistent",
  orange 2-px-Akzentlinie, rechts Tabs mit inline-SVG-Icon `Pflanzenschutzmittel-Rechner`
  (aktiv) + `Pflanzenschutzmittel-Katalog` (klickbar, Inhalt noch leer). Ein Tab-Klick
  schaltet per JS (`switchView`) zwischen `#viewRechner` und `#viewKatalog` um. Weitere Tools
  kommen als zusätzliche Tabs dazu. Im Druck (`@media print`) hell, ohne Tabs/Bar.

## Rechenlogik (`compute()`)
- Je Komponente eine **Einheit** (`UNITS`: L, ml, kg, g, Stück, Tabletten). Gesamtmenge =
  Feldgröße × Aufwandmenge, gerundet über `round(v, decimals)`.
- **Rundung** (`decimalsFor`): Wasser 0 Dezimalstellen; sonst 0 wenn die Aufwandmenge
  ganzzahlig ist, sonst 2.
- **Tank-Splitting:** Nur **flüssige** Anteile (Wasser + Einheiten L/ml, via `liquidPerUnit`
  in Liter umgerechnet) ergeben die Liter-Füllmenge und bestimmen die Anzahl der Spritzen.
  **Feste** Einheiten (kg/g/Stück/Tabletten) werden je Spritze nur anteilig ausgewiesen,
  nicht in die Liter summiert.
- Proportionale Verteilung je Spritze, **Rundungsausgleich je Komponente per Index** auf
  der letzten Spritze, **Limit 20 Füllungen**. Ohne Flüssigkeit (`solidsOnly`) gibt es keine
  Aufteilung, nur einen Hinweis.
- Die Wasserzeile ist fest (nicht löschbar), aber optional: leer lassen = kein Wasser.
- Anzeige mit `Intl.NumberFormat('de-DE')` (nf0/nf2); Tankkapazität als gruppierte Ganzzahl.
- Änderungen an dieser Logik nur bewusst und getestet (Node-Testskript für Szenarien inkl.
  gemischte Einheiten, Rundungsregel, `solidsOnly`, Limit, Leerfall).

## BVL-PSM-API
- Basis: `https://psm-api.bvl.bund.de/ords/psm/api-v1/` (öffentlich, kein Key).
- **CORS offen** (`*`) → direkt aus dem Browser abfragbar, **sofern die Herkunft eine echte
  http(s)-Adresse ist**. Die WAF blockt `Origin: null` (`file://`) mit **HTTP 403** – der
  Code erkennt `location.protocol === 'file:'` und schaltet dann auf freie Namenseingabe um.
- Mittelsuche: `GET /mittel/?q={"MITTELNAME":{"$instr":"<term>"}}&limit=25` (`$instr` =
  case-insensitiver Substring). Felder: `mittelname`, `kennr`, `zul_ende`.
- Einheiten/Codes: Kodeliste 25 via `/kode?q={"KODELISTE":25,"SPRACHE":"DE"}`; Kulturen
  Kodeliste 948 / `/awg_kultur`; Maxdosis in `/awg_aufwand.m_aufwand`. Codes sind nur je
  Liste eindeutig – beim Auflösen immer `KODELISTE` mitgeben.
- **Kein Rate-Limit** dokumentiert/erzwungen (verifiziert). Trotzdem: Suche entprellen +
  laufende Anfrage abbrechen; Zusatzabfragen (AWG/Einheit/Kultur) nur bei Auswahl + pro
  Session cachen. Alle BVL-Aufrufe mit Timeout + `AbortController`; Rechner läuft ohne Netz.

## Code-Review
- Nicht-triviale Änderungen vor dem Commit mit dem `code-reviewer`-Agenten prüfen
  (`.claude/agents/code-reviewer.md`). Nach Fixes erneut reviewen, bis keine
  handlungsbedürftigen Findings mehr offen sind.

## Commits
- Kurze, präzise Commit-Messages auf Englisch. Kein Ticket-Präfix nötig (eigenständiges Repo).
