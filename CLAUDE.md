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
  BVL-API (s. u.). Eingaben und Berechnung sind flüchtig – sie überleben keinen Reload.
- **Einzige Ausnahme: lokale Komfortlisten** in `localStorage` (Schlagnamen samt zuletzt
  eingetragener Größe unter `agrar-assistent.schlaege` – Einträge `{ name, ha }`, alte reine
  Namens-Strings bleiben lesbar –, eigene Mittel als reine Namen unter
  `agrar-assistent.eigene-mittel`) – keine weiteren Berechnungsdaten, nichts verlässt den
  Browser. Zugriff ausschließlich über `storeEntries`/`storeList`/`storeAdd`/`storeRemove`;
  ist `localStorage` blockiert (`file://`,
  strenge Browsereinstellungen, Quota), fällt der Code still auf einen Sitzungsspeicher
  zurück. Jeder Eintrag muss in der UI einzeln löschbar bleiben. Neue Speicherarten nur
  nach Abstimmung – und dann auch `privacy.html` (Ziffer 6) mitziehen.
- **Dark-Theme only** (Bildschirm). Farbwerte sind Material-3-Tokens (Seed `#FF9900`) als
  CSS-Variablen `--mat-sys-*` im `:root`. Ausnahme: die `@media print`-Blöcke nutzen bewusst
  feste helle Druckfarben (Papier ist hell) und physische Einheiten (mm/pt) – kein Verstoß
  gegen die Token-Regel.
- **Druck = eigenes Blatt:** Der Rechner druckt nie seine Bildschirmansicht, sondern
  `#printSheet` (direktes Kind von `body`, am Bildschirm `display: none`). `renderPrintSheet()`
  baut es aus `compute()` direkt vor dem Druck (Druck-Button + `beforeprint`). Im Druck blendet
  `body[data-view="rechner"] > :not(.print-sheet)` alles andere aus; `switchView` setzt
  `data-view`, die Katalog-Tabs drucken weiter ihre (hell umgefärbte) Bildschirmansicht.
  Inhalt: Kopfdaten, Mengen je Schlag, eine Tabellenzeile je Spritze mit Abhak-Kästchen,
  Unterschriftsfeld (Datum, Name, Unterschrift – nur der Fahrer).
- **Icons als inline-SVG** (keine Icon-Fonts).
- **Schrift:** `Inter Variable` ist als **Base64-`@font-face` eingebettet** (Subset
  `latin`, Quelle `@fontsource-variable/inter`). Bewusst **kein Font-CDN** – die Schrift
  ist selbst gehostet (hier direkt eingebettet), also kein Fremd-Datenabfluss (DSGVO).
  System-Fallback (`Segoe UI`/`system-ui`) bleibt.
- **Kopfzeile = Topbar** im Website-Look (`agrar-assistent.de`): volle Breite, dunkelgraue Bar
  (`--mat-sys-surface-container`, #262626; bewusst dunkler als die Website-Navbar), Logo + orange „Agrar Assistent",
  orange 2-px-Akzentlinie, rechts Tabs mit inline-SVG-Icon `Pflanzenschutzmittel-Rechner`
  (aktiv), `Pflanzenschutzmittel-Katalog` und `Zusatzstoff-Katalog` (beide mit BVL-Daten).
  Ein Tab-Klick schaltet per JS (`switchView`) zwischen `#viewRechner`, `#viewKatalog` und
  `#viewZusatzKatalog` um. Weitere Tools kommen als zusätzliche Tabs dazu. Im Druck (`@media print`) hell, ohne Tabs/Bar (der
  Rechner druckt stattdessen das eigene Blatt mit kleinem Logo-Kopf).

## Rechenlogik (`compute()`)
- **Mehrere Schläge** (`state.fields`, je `{ id, name, sizeHa, sizeFromName }`) teilen sich
  eine Mischung. Es zählen nur Schläge mit Größe > 0, gerechnet wird mit der auf 0,01 ha
  gerundeten Größe (so wie angezeigt); unbenannte heißen nach ihrer Position „Schlag N".
- Je Komponente eine **Einheit** (`UNITS`: L, ml, kg, g, Stück, Tabletten). Gesamtmenge =
  Gesamtfläche (Summe der Schläge) × Aufwandmenge, gerundet über `round(v, decimals)`.
- **Aufteilungen (je Schlag / je Spritze)** laufen über `splitCumulative`: kumulative
  Rundung – jeder Anteil ist die Differenz der gerundeten laufenden Summen. Dadurch ist die
  Summe je Komponente exakt die Gesamtmenge, kein Anteil ist negativ und jeder liegt höchstens
  eine Rundungsstelle neben seinem exakten Anteil (kein „Ausgleich auf den Letzten", der bei
  kleinen Tanks/Schlägen zu Über- oder Unterdosierung führte).
- **Schläge je Spritze:** Die Spritzen arbeiten die Schläge in der **Eingabereihenfolge** ab
  (per ▲/▼ umsortierbar); die kumulierten Liter werden linear auf die hintereinander gelegten
  Flächen abgebildet (`filling.areas`). Alle Grenzen werden vor dem Schneiden auf 0,01 ha
  gerundet – so summieren sich die Teilstücke exakt und es gibt keine „0 ha"-Splitter. Deckt
  eine Mini-Spritze < 0,01 ha ab, nennt sie trotzdem ihren Schlag (`ha: 0`, Anzeige
  „< 0,01 ha"). Ein Tank kann also einen Schlag beenden und auf dem nächsten weitermachen.
- **Gemerkte Schlaggröße:** Eine aus dem Verlauf übernommene Größe gehört nur zu diesem
  Namen (`field.sizeFromName`); beim Umbenennen wird sie verworfen bzw. durch die des neuen
  Namens ersetzt; wird der Name geleert, verfällt sie ebenfalls. Selbst getippte Größen
  bleiben und werden zum Namen gemerkt. Schon in einer anderen Zeile stehende Namen bietet
  das Dropdown nicht erneut an.
- **Rundung** (`decimalsFor`, gilt für Gesamtmenge und alle Anteile): Wasser 0
  Dezimalstellen; zählbare Einheiten (`UNITS[].whole`: Stück, Tabletten) 0 bei ganzzahliger
  Aufwandmenge, sonst 2; teilbare Einheiten (L, ml, kg, g) **immer 2** – 2,61 ha × 1 L/ha
  bleibt 2,61 L (früher auf 3 L aufgerundet, rund 15 % Überdosierung) und je Schlag steht
  genau Fläche × Aufwandmenge.
- **Tank-Splitting:** Nur **flüssige** Anteile (Wasser + Einheiten L/ml, via `liquidPerUnit`
  in Liter umgerechnet) ergeben die Liter-Füllmenge und bestimmen die Anzahl der Spritzen.
  **Feste** Einheiten (kg/g/Stück/Tabletten) werden je Spritze nur anteilig ausgewiesen,
  nicht in die Liter summiert.
- Proportionale Verteilung je Spritze nach Füllmenge (kumulativ, s. o.), **Limit 20
  Füllungen**. Bei erreichtem Limit summieren sich die Spritzen nur auf den tatsächlich
  gefüllten Anteil – der nicht berechnete Rest landet nicht auf der 20. Spritze. Ohne
  Flüssigkeit (`solidsOnly`) gibt es keine Aufteilung, nur einen Hinweis.
- Die Wasserzeile ist fest (nicht löschbar), aber optional: leer lassen = kein Wasser.
- Der **Schlagname** ist reine Beschriftung (Auftrag für Mitarbeiter/Ausdruck) und geht
  nur als Label in `compute()` ein.
- Anzeige mit `Intl.NumberFormat('de-DE')` (nf0/nf2); Tankkapazität als gruppierte Ganzzahl.
- Änderungen an dieser Logik nur bewusst und getestet (Node-Testskript für Szenarien inkl.
  gemischte Einheiten, Rundungsregel, `solidsOnly`, Limit, Leerfall, mehrere Schläge,
  Reihenfolge, Summen je Schlag und je Spritze, ganzzahlige Aufwandmengen mit kleinen Tanks
  und Schlägen – jeder Anteil höchstens eine Rundungsstelle vom exakten Anteil entfernt).

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
