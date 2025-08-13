=========PORTFOLIO ========

=========Aufgabe 4a: Nur Schema (Tabellen) ============

PRAGMA foreign_keys = ON;

-- 0) Alte Tabellen löschen (beim erneuten Ausführen Fehler vermeiden)
DROP TABLE IF EXISTS PERSON_SCHICHT;
DROP TABLE IF EXISTS SCHICHT_RAUM;
DROP TABLE IF EXISTS PERSON_QUALIFIKATION;
DROP TABLE IF EXISTS ABWESENHEIT;
DROP TABLE IF EXISTS SCHICHT;
DROP TABLE IF EXISTS RAUM;
DROP TABLE IF EXISTS QUALIFIKATION;
DROP TABLE IF EXISTS PERSON;

-- 1) Basistabellen
CREATE TABLE PERSON (
    PersonID        INTEGER PRIMARY KEY,
    Name            TEXT NOT NULL,
    Berufsgruppe    TEXT,
    Fachgebiet      TEXT,
    Email           TEXT,
    Mobilnummer     TEXT,
    Verfuegbarkeit  TEXT     -- 'Ja' / 'Nein' (alternativ 0/1)
);

CREATE TABLE QUALIFIKATION (
    QualifikationID INTEGER PRIMARY KEY,
    Bezeichnung     TEXT NOT NULL
);

CREATE TABLE RAUM (
    RaumID      INTEGER PRIMARY KEY,
    Raumnummer  TEXT,
    Funktion    TEXT,      -- Behandlungsraum / Aufwachraum / OP / Beobachtungszimmer
    Kapazitaet  INTEGER
);

CREATE TABLE SCHICHT (
    SchichtID       INTEGER PRIMARY KEY,
    PersonID        INTEGER,        -- Schichtleitung (immer PERSON)
    Startzeitpunkt  TEXT NOT NULL,  -- 'YYYY-MM-DD HH:MM'
    Endzeit         TEXT NOT NULL,  -- 'YYYY-MM-DD HH:MM'
    Schichtart      TEXT,           -- Früh / Spät / Nacht
    FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE ABWESENHEIT (
    AbwesenheitID   INTEGER PRIMARY KEY,
    PersonID        INTEGER NOT NULL,
    Grund           TEXT,      -- Urlaub / Krankheit / Fortbildung / Diensttausch
    Status          TEXT,      -- beantragt / genehmigt / abgelehnt
    Startdatum      TEXT,      -- 'YYYY-MM-DD'
    Enddatum        TEXT,      -- 'YYYY-MM-DD'
    FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- 2) Beziehungstabellen (N:M)
CREATE TABLE PERSON_QUALIFIKATION (
    PersonID        INTEGER NOT NULL,
    QualifikationID INTEGER NOT NULL,
    PRIMARY KEY (PersonID, QualifikationID),
    FOREIGN KEY (PersonID)        REFERENCES PERSON(PersonID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (QualifikationID) REFERENCES QUALIFIKATION(QualifikationID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE SCHICHT_RAUM (
    SchichtID   INTEGER NOT NULL,
    RaumID      INTEGER NOT NULL,
    PRIMARY KEY (SchichtID, RaumID),
    FOREIGN KEY (SchichtID) REFERENCES SCHICHT(SchichtID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (RaumID)    REFERENCES RAUM(RaumID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PERSON_SCHICHT (
    PersonID        INTEGER NOT NULL,
    SchichtID       INTEGER NOT NULL,
    Aufgabe         TEXT,     -- Triage / Wundversorgung / Aufnahme / Schockraum ...
    Rufbereitschaft INTEGER,  -- 0/1
    PRIMARY KEY (PersonID, SchichtID),
    FOREIGN KEY (PersonID)  REFERENCES PERSON(PersonID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (SchichtID) REFERENCES SCHICHT(SchichtID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
-- ============ /Schema Ende ============


=========Aufgabe 4b PERSON (10 Mitarbeitende, international)  ============



INSERT INTO PERSON (PersonID, Name, Berufsgruppe, Fachgebiet, Email, Mobilnummer, Verfuegbarkeit) VALUES
(1,'Dr. Funda Korkmaz','Arzt/Ärztin','Innere Medizin','funda.korkmaz@stadtklinik.de','+49-170-1111111',1),
(2,'Dr. Marco Rossi','Arzt/Ärztin','Chirurgie','marco.rossi@stadtklinik.de','+49-170-2222222',1),
(3,'Dr. Markus Klein','Arzt/Ärztin','Pädiatrie','markus.klein@stadtklinik.de','+49-170-3333333',1),
(4,'Dr. Anna Müller','Arzt/Ärztin','Kardiologie','anna.mueller@stadtklinik.de','+49-170-4444444',1),
(5,'Ali Demir','Pflegekraft','Notaufnahme','ali.demir@stadtklinik.de','+49-170-5555555',1),
(6,'Elena Papadopoulos','Pflegekraft','Chirurgie','elena.papadopoulos@stadtklinik.de','+49-170-6666666',1),
(7,'Laura Becker','Pflegekraft','Intensivstation','laura.becker@stadtklinik.de','+49-170-7777777',1),
(8,'Sophie Wagner','MFA','Allgemein','sophie.wagner@stadtklinik.de','+49-170-8888888',1),
(9,'Jonas Weber','Rettungssanitäter:in','Rettungsdienst','jonas.weber@stadtklinik.de','+49-170-9999999',1),
(10,'Mehmet Yavuz','Rettungssanitäter:in','Rettungsdienst','mehmet.yavuz@stadtklinik.de','+49-170-1010101',1);

	
-- QUALIFIKATION
INSERT INTO QUALIFIKATION (QualifikationID, Bezeichnung) VALUES
(1,'Notfallmedizin-Zertifikat'),
(2,'Beatmungsschulung'),
(3,'Triage-Fortbildung');

	
-- PERSON_QUALIFIKATION
INSERT INTO PERSON_QUALIFIKATION (PersonID, QualifikationID) VALUES
(1,1),(1,2),
(2,1),
(3,3),
(4,1),(4,2),
(5,2),(5,3),
(6,3),
(7,3),
(9,1),
(10,3);

	
-- RAUM
INSERT INTO RAUM (RaumID, Raumnummer, Funktion, Kapazitaet) VALUES
(1,'ER-1','Behandlungsraum',1),
(2,'ER-2','Behandlungsraum',1),
(3,'OP-1','OP',1),
(4,'AW-1','Aufwachraum',3),
(5,'BZ-1','Beobachtungszimmer',4);

	
-- SCHICHT (Leiter = Ärzt:innen)
INSERT INTO SCHICHT (SchichtID, PersonID, Startzeitpunkt, Endzeit, Schichtart) VALUES
(101,1,'2025-08-12 07:00','2025-08-12 15:00','Früh'),
(102,2,'2025-08-12 15:00','2025-08-12 23:00','Spät'),
(103,4,'2025-08-12 23:00','2025-08-13 07:00','Nacht');

	
-- SCHICHT_RAUM
INSERT INTO SCHICHT_RAUM (SchichtID, RaumID) VALUES
(101,1),(101,4),
(102,2),(102,4),
(103,3),(103,5);

	
-- PERSON_SCHICHT (Triage in jeder Schicht andere Pflegekraft)
INSERT INTO PERSON_SCHICHT (PersonID, SchichtID, Aufgabe, Rufbereitschaft) VALUES
-- Frühschicht
(1,101,'Schockraum',0),
(5,101,'Triage',0),
(8,101,'Aufnahme',1),
(9,101,'Patiententransport',0),
-- Spätschicht
(2,102,'OP-Bereitschaft',0),
(6,102,'Triage',0),
(10,102,'Rettungseinsatz',0),
(7,102,'Pflegeleitung',1),
-- Nachtschicht
(4,103,'Konsiliardienst',1),
(7,103,'Triage',0),
(3,103,'Notaufnahmeleitung',0),
(9,103,'Rettungseinsatz',0);

	
-- ABWESENHEIT
INSERT INTO ABWESENHEIT (AbwesenheitID, PersonID, Grund, Status, Startdatum, Enddatum) VALUES
(9001,6,'Urlaub','genehmigt','2025-08-14','2025-08-20'),
(9002,10,'Fortbildung','genehmigt','2025-08-15','2025-08-16');
