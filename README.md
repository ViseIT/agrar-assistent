# Spritzrechner

Ein eigenständiger **Spritzrechner** für die Feld- und Tankplanung im Pflanzenschutz –
berechnet die benötigten Gesamtmengen und die Aufteilung auf einzelne Tankfüllungen
(Tank-Splitting) mit ausgeglichenem Mischverhältnis.

Die Anwendung ist eine **einzige HTML-Datei**. Sie läuft im Browser – kein Server,
keine Installation, keine Anmeldung, kein Cloud-Konto.

## Nutzung

**Online (empfohlen):** Die GitHub-Pages-Seite des Repos öffnen. Dort funktioniert
alles inklusive der Live-Mittelsuche.

**Lokal:** `index.html` herunterladen und per Doppelklick im Browser öffnen. Die
**Berechnung** funktioniert vollständig offline. Die **Live-Mittelsuche** ist dabei
allerdings nicht verfügbar (siehe unten) – Mittelnamen können dann frei eingetippt werden.

Eingeben: Feldgröße (ha), Tankkapazität (L) und je Komponente die Aufwandmenge (L/ha).
Der Rechner zeigt sofort die Gesamtmengen, die Summe und die einzelnen Tankfüllungen.

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
