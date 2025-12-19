# Event Management System (WWIBE224 - Gruppe 2)

Dieses Projekt beinhaltet unsere Implementierung der Prüfungsleistung für die "Event-Management-App".

**Entwickler-Team:**
- Oleksandra Ishmatova
- Damjan Babak
- Luccas Dos Santos Sabenca Dias
- Noah Kipp
- Ghays Alnema

---

## 1. System-Setup & Testdaten

Damit die Applikationen korrekt funktionieren und die Status-Logik getestet werden kann, ist zunächst die Initialisierung der Datenbank erforderlich.

**Schritte zur Datengenerierung:**

1.  Suchen Sie im Eclipse ADT (Project Explorer) die Klasse **`ZCL_G1_EVENT_DATA_GEN`**.
2.  Starten Sie diese als Konsolenanwendung (Rechtsklick auf die Datei > *Run As* > *ABAP Application (Console)* oder Taste `F9`).
3.  Die Konsole wird den Vorgang bestätigen. Dabei werden alte Datensätze bereinigt und folgende Testobjekte neu angelegt:
    * 5 Beispiel-Events
    * 5 Teilnehmer-Datensätze
    * Verknüpfte Registrierungen

---

## 2. Nutzung der Apps

Die Lösung ist in zwei separate Anwendungen unterteilt.

### Veranstaltungens-Verwaltung (Event App)

Diese App dient der Erstellung und Pflege von Events sowie der Verwaltung von Teilnehmern.

* **Service Binding:** `ZUI_EVENT_O4G1`
* **Entity:** `Event`
* **Start:** Wählen Sie die Entity und klicken Sie auf **Preview**.

**Features:**
* **Events anlegen:** Über "Create" können neue Veranstaltungen erstellt werden.
* **Status ändern:** Nutzen Sie die Buttons "Open Event" und "Close Event", um den Event-Status zu steuern.
* **Teilnehmer hinzufügen:**
    1.  Wechseln Sie in die Detailansicht eines Events (Tab "Registrations").
    2.  Klicken Sie im Bearbeitungsmodus auf "Create".
    3.  Wählen Sie über die Suchhilfe (Lupe) im Feld **Select Participant** einen Teilnehmer aus (Suche nach Namen möglich).

### Registrierungs-Übersicht (Registration Worklist)

Diese App bietet eine zentrale Arbeitsliste zur Bearbeitung offener Anmeldungen.

* **Service Binding:** `ZUI_REGISTRATION_O4G1`
* **Entity:** `Registration`
* **Start:** Wählen Sie die Entity und klicken Sie auf **Preview**.

**Features:**
* **Übersicht:** Zeigt alle Registrierungen eventübergreifend an.
* **Filterung:** Die Liste kann nach diversen Kriterien (Status, Eventname, Person) gefiltert werden.
* **Genehmigungsprozess:**
    * Markieren Sie eine oder mehrere Zeilen.
    * Wählen Sie **Approve Registration** (Genehmigen) oder **Reject Registration** (Ablehnen).
    * *Hinweis:* Die Buttons sind nur aktiv, wenn der Status eine Bearbeitung zulässt (bereits entschiedene Anfragen können nicht erneut bearbeitet werden).
