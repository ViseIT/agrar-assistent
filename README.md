# Agrar Assistent

**Agrar Assistent** – Hilfstools für die digitale Landwirtschaft. Aktuell enthalten ist der
**PSM-Rechner** (Pflanzenschutzmittel-Rechner) für die Feld- und Tankplanung – er
berechnet die benötigten Gesamtmengen und die Aufteilung auf einzelne Spritzenfüllungen
(Tank-Splitting) mit ausgeglichenem Mischverhältnis. Weitere Tools folgen (als Tabs).

Die Anwendung ist eine **einzige HTML-Datei**. Sie läuft im Browser – kein Server,
keine Installation, keine Anmeldung, kein Cloud-Konto.

## Nutzung

**Online (empfohlen):** Die GitHub-Pages-Seite des Repos öffnen. Dort funktioniert
alles inklusive der Live-Mittelsuche.

**Lokal:** `index.html` herunterladen und per Doppelklick im Browser öffnen. Die
**Berechnung** funktioniert vollständig offline. Die **Live-Mittelsuche** ist dabei
allerdings nicht verfügbar (siehe unten) – Mittelnamen können dann frei eingetippt werden.

Eingeben: Feldgröße (ha), Tankkapazität (L) und je Komponente die Aufwandmenge samt
**Einheit** (L, ml, kg, g, Stück, Tabletten – jeweils pro ha). Der Rechner zeigt sofort
die Gesamtmengen und die einzelnen Spritzenfüllungen.

- **Flüssige Anteile** (Wasser sowie Mittel in L/ml) ergeben die Liter-Füllmenge und
  bestimmen die Anzahl der Spritzen.
- **Feste Einheiten** (kg/g/Stück/Tabletten) werden je Spritze anteilig ausgewiesen.
- Die **Wasserzeile ist optional** – für reine Feststoff-Maßnahmen einfach leer lassen.
- **Drucken / als PDF speichern** über den Button oben rechts (z. B. zum Weitergeben an
  den Fahrer).

## Pflanzenschutzmittel-Suche (BVL)

Die Mittelsuche (Autocomplete inkl. Zulassungsnummer und Gültigkeitsdatum) fragt **live**
die öffentliche Pflanzenschutzmittel-Zulassungs-API des
**Bundesamts für Verbraucherschutz und Lebensmittelsicherheit (BVL)** ab
(`https://psm-api.bvl.bund.de`). Dadurch sind die Zulassungsdaten immer aktuell –
ohne dass hier etwas gepflegt oder gehostet werden muss. Abgelaufene Zulassungen werden
markiert.

> **Wichtig – lokale Datei vs. Online:** Die BVL-API weist Anfragen von lokal geöffneten
> Dateien (`file://`, technisch „Origin: null") mit HTTP 403 ab. Die Live-Mittelsuche
> funktioniert daher nur, wenn die Seite über eine echte Web-Adresse geladen wird
> (z. B. die GitHub-Pages-URL). Beim direkten Doppelklick auf die Datei bleibt der
> reine Rechner voll nutzbar; Mittelnamen werden dann frei eingegeben.

## Aktualisierung

Updates werden über dieses GitHub-Repository bereitgestellt. Bei Nutzung über GitHub Pages
ist automatisch immer die aktuelle Version geladen; lokal genügt es, die neue `index.html`
herunterzuladen.

## Hinweis

Angaben ohne Gewähr und ohne Rechtsberatung. Maßgeblich sind stets die amtliche
Zulassung und das Produktetikett. Datenquelle der Mitteldaten: BVL (PSM-Zulassungs-API).
