-- Als eerste zorgen we dat we geen conflict met een bestaande tabel krijgen door alle bestaande tabellen met dezelfde naam als onze nieuwe tabellen te droppen.
-- We gebruiken cascade op het eind, omdat we relaties hebben gelegd tussen de tabellen. De ene tabel is afhankelijk van de ander, dus kun je die niet zomaar droppen. Cascade lost dit op.
-- De television tabel is de tabel met de relaties, als we die als eerst droppen, hoeven we geen cascade te gebruiken. Je ziet ook dat we geen cascade voor cimodules hoeven te gebruiken, terwijl de televisions tabel daar wel een relatie mee heeft.
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS remoteControllers CASCADE;
DROP TABLE IF EXISTS televisions;
DROP TABLE IF EXISTS cimodules;
DROP TABLE IF EXISTS wallBrackets;

-- Maak een "users" tabel.
CREATE TABLE users (
    username varchar(50),
    wachtwoord varchar(50)
);

-- Maak een remote controller tabel
CREATE TABLE remoteControllers (
	-- We maken hier automatisch gegenereerde ID.
    id int GENERATED ALWAYS AS IDENTITY,
    name text not null unique,
    brand text not null unique,
    price double precision not null,
    currentStock int not null,
    sold int not null,
    compatibleWIth varchar,
    batteryType varchar, 
	-- We zorgen dat de ID daadwerkelijk de (identiteits)sleutel van de tabel is
	PRIMARY KEY(id)
);

-- We creëren de andere tabellen op dezelfde manier
CREATE TABLE cimodules (
	-- Hier staat PRIMARY KEY bij het id zelf vermeld. Dit mag ook op het einde. Het resultaat is hetzelfde.
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE,
    brand text NOT NULL UNIQUE,
    price double precision NOT NULL,
    currentStock int NOT NULL,
    sold int NOT NULL 
);


CREATE TABLE wallBrackets (
	-- hier gebruiken we "bigserial". Dit is van zichzelf al sequentieel, dus kan je daar niet ook nog "GENERATED ALWAYS AS IDENTITY" achter zetten
    id bigserial PRIMARY KEY,
    name text NOT NULL UNIQUE,
    brand text NOT NULL UNIQUE,
    price double precision NOT NULL,
    currentStock int NOT NULL,
    sold int NOT NULL,
    adjustable boolean
);

-- De "televisions" tabel is de tabel waar de foreign keys in zitten. We maken deze tabel als laatste aan, zodat de targets van de foreign keys ook al echt bestaan.
CREATE TABLE televisions (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE,
    brand text NOT NULL UNIQUE,
    price double precision NOT NULL,
    currentStock int NOT NULL,
    sold int NOT NULL,
    typeTV text,
    available double precision,
    refreshRate double precision,
    screenType varchar(100),
	remote_id int,
	ci_module_id int,
	-- Maak een relatie met remotecontrollers
    CONSTRAINT fk_remotecontroller FOREIGN KEY (remote_id) REFERENCES remoteControllers(id),
	-- Maak een relatie met cimodules
	CONSTRAINT fk_cimodule FOREIGN KEY (ci_module_id) REFERENCES cimodules(id)
);

-- We willen nu een relatei maken van meerder televisions met meerdere wallbrackets. We kunnen echter maar 1 waarde in een tabel cel opslaan. Daarom gebruiken we voor een veel-op-veel relatie een tussentabel. Conventie zegt dat we daar een combinatie-naam voor gebruiken zoals.
CREATE TABLE television_wallbracket (
	television_id int;
	-- bigint is de niet-sequentiele variant van bigserial
	wallbracket_id bigint;
	CONSTRAINT fk_television FOREIGN KEY (television_id) REFERENCES
);




SELECT televisions.id AS tvid, remoteControllers.id AS rmid
FROM televisions JOIN remoteControllers
 ON remoteControllers.id = televisions.remote_id;
