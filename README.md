# Agrar Assistent

**Agrar Assistent** – Hilfstools für die digitale Landwirtschaft. Aktuell enthalten ist der
**Pflanzenschutzmittel-Rechner** für die Feld- und Tankplanung – er
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

Eingeben: einen oder mehrere Schläge mit Größe (ha), Tankkapazität (L) und je Komponente
die Aufwandmenge samt **Einheit** (L, ml, kg, g, Stück, Tabletten – jeweils pro ha). Der
Rechner zeigt sofort die Gesamtmengen und die einzelnen Spritzenfüllungen.

- **Flüssige Anteile** (Wasser sowie Mittel in L/ml) ergeben die Liter-Füllmenge und
  bestimmen die Anzahl der Spritzen.
- **Feste Einheiten** (kg/g/Stück/Tabletten) werden je Spritze anteilig ausgewiesen.
- Die **Wasserzeile ist optional** – für reine Feststoff-Maßnahmen einfach leer lassen.
- **Mehrere Schläge:** Über „Schlag hinzufügen" lassen sich mehrere Schläge mit derselben
  Mischung eintragen, jeweils mit Name und Größe. Die Gesamtmengen beziehen sich auf die
  Gesamtfläche; zusätzlich werden die Mengen **je Schlag** ausgewiesen. Die Spritzen
  arbeiten die Schläge **in der eingetragenen Reihenfolge** ab – bleibt am Ende eines
  Schlags etwas im Tank, geht es damit auf dem nächsten weiter. Jede Spritze zeigt, welche
  Schläge sie mit wie viel Fläche abdeckt. Die Reihenfolge lässt sich über die Pfeile
  ▲/▼ an jeder Zeile ändern.
- **Schläge merken:** Eingetippte Schlagnamen merkt sich der Browser lokal samt zuletzt
  eingetragener Größe und schlägt sie beim nächsten Mal vor – ein gewählter Schlag bringt
  seine Größe gleich mit. Über das **X** in der Vorschlagsliste fliegt ein Eintrag wieder raus.
- **Eigene Mittel:** Im Auswahl-Dialog gibt es neben Wasser, Pflanzenschutzmitteln und
  Zusatzstoffen den Reiter **Eigene** für Mittel, die nicht im BVL-Verzeichnis stehen
  (z. B. Hofmischungen). Sie werden lokal im Browser gemerkt und lassen sich dort einzeln
  über das Papierkorb-Symbol löschen. Für eigene Einträge gibt es keine Zulassungsprüfung.
- **Drucken / als PDF speichern** über den Button unter dem Ergebnis: Gedruckt wird nicht
  die Bildschirmansicht, sondern ein kompakter **Spritzauftrag** für den Fahrer – Kopfdaten,
  Mengen je Schlag, eine Tabellenzeile je Spritze mit **Kästchen zum Abhaken** und ein
  **Unterschriftsfeld** (Datum, Name, Unterschrift). Der Normalfall passt auf eine A4-Seite.

Die beiden Merklisten (Schlagnamen mit Größe, eigene Mittel) sind das Einzige, was die
Seite dauerhaft speichert – sie liegen ausschließlich im lokalen Speicher des Browsers und
verlassen das Gerät nicht. Alles andere (Mengen, Tank, Ergebnis) ist nach einem Neuladen weg.

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

## Lizenz

Der Quellcode dieses Repositorys steht unter der **PolyForm Strict License 1.0.0**
(siehe [`LICENSE`](LICENSE)). Das bedeutet insbesondere: **keine Weitergabe, keine
Änderungen/Ableitungen und keine kommerzielle Nutzung** ohne ausdrückliche
Genehmigung; nichtkommerzielle Nutzung ist gestattet.

Die eingebettete Schrift **Inter** ist davon ausgenommen und separat unter der
**SIL Open Font License 1.1** lizenziert – siehe [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md).
