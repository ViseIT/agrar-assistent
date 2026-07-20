# Spritzrechner – Claude Project Guidelines

## Was ist das?
Ein **eigenständiger, lokaler Spritzrechner** als **einzelne HTML-Datei** (`index.html`).
Er läuft ohne Server, ohne Build, ohne Anmeldung direkt im Browser. Auslieferung an den
Endnutzer erfolgt über dieses GitHub-Repo (Datei-Download bzw. GitHub Pages).

## Sprache
- **Chat/Kommunikation:** Deutsch.
- **Code (Bezeichner, Kommentare):** Englisch. Sichtbare UI-Texte sind Deutsch.

## Architektur & Constraints
- **Eine Datei, keine Abhängigkeiten:** Alles (HTML, CSS, JS) inline in `index.html`.
  Kein npm, kein Bundler, kein Framework, keine externen Fonts/CDN/Assets – die Datei muss
  offline lauffähig bleiben und (für die reine Berechnung) auch per Doppelklick von
  `file://` funktionieren.
- **Kein Server, kein eigenes Hosting.** Keine Backend-Aufrufe außer der öffentlichen
  BVL-API (s. u.).
- **Dark-Theme only.** Farbwerte sind Material-3-Tokens (Seed `#FF9900`), als CSS-Variablen
  `--mat-sys-*` im `:root`. Keine Light-Variante, keine Theme-Umschaltung.
- **Icons als inline-SVG** (keine Icon-Fonts).

## Rechenlogik
Mengen- und Tank-Splitting-Berechnung in `compute()`:
- Gesamtmenge je Komponente = Feldgröße × Aufwandmenge; **Wasser auf 0**, **Mittel auf 2**
  Nachkommastellen gerundet (`round(value, decimals)`: `Math.round((v + EPSILON) * f) / f`).
- Tank-Splitting bis zur Kapazität, proportionale Verteilung je Füllung, Rundungsausgleich
  auf der letzten Füllung, **Limit 20 Füllungen** (danach Warnhinweis).
- Anzeige mit `Intl.NumberFormat('de-DE', { min/max 2 })`.
Änderungen an dieser Logik nur bewusst und getestet (Node-Testskript für Szenarien
inkl. Rundungsausgleich, Limit, Leereingaben).

## BVL-PSM-API
- Basis: `https://psm-api.bvl.bund.de/ords/psm/api-v1/` (öffentlich, kein Key).
- **CORS offen** (`Access-Control-Allow-Origin: *`) → direkt aus dem Browser abfragbar,
  **sofern die Herkunft eine echte http(s)-Adresse ist**.
- **Wichtig:** Die BVL-WAF blockt Requests mit `Origin: null` (lokal geöffnete
  `file://`-Datei) mit **HTTP 403**. Live-Mittelsuche funktioniert daher nur über eine
  echte Web-Adresse (z. B. GitHub Pages). Der Code erkennt `location.protocol === 'file:'`
  und schaltet dann auf freie Namenseingabe um, statt einen fehlschlagenden Request zu senden.
- Mittelsuche: `GET /mittel/?q={"MITTELNAME":{"$instr":"<term>"}}&limit=25`
  (`$instr` ist **case-insensitiv**, Substring). Felder: `mittelname`, `kennr`
  (Zulassungsnummer), `zul_ende` (Zulassungsende).
- Aktualität: `GET /stand/` → `datum`.
- **Fehlertoleranz wahren:** Alle BVL-Aufrufe mit Timeout + `AbortController`; der reine
  Rechner funktioniert ohne Netz weiter.

## Code-Review
- Nicht-triviale Änderungen vor dem Commit mit dem `code-reviewer`-Agenten prüfen
  (`.claude/agents/code-reviewer.md`). Nach Fixes erneut reviewen, bis keine
  handlungsbedürftigen Findings mehr offen sind.

## Commits
- Kurze, präzise Commit-Messages auf Englisch. Kein Ticket-Präfix nötig (eigenständiges Repo).
