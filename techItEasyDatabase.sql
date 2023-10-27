-- Als eerste zorgen we dat we geen conflict met een bestaande tabel krijgen door alle bestaande tabellen met dezelfde naam als onze nieuwe tabellen te droppen.
-- We gebruiken cascade op het eind, omdat we relaties hebben gelegd tussen de tabellen. De ene tabel is afhankelijk van de ander, dus kun je die niet zomaar droppen. Cascade lost dit op.
-- De television tabel is de tabel met de relaties, als we die als eerst droppen, hoeven we geen cascade te gebruiken. Je ziet ook dat we geen cascade voor cimodules hoeven te gebruiken, terwijl de televisions tabel daar wel een relatie mee heeft.
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS television_wall_brackets;
DROP TABLE IF EXISTS remote_controllers CASCADE;
DROP TABLE IF EXISTS televisions;
DROP TABLE IF EXISTS cimodules;
DROP TABLE IF EXISTS wall_brackets;

-- Maak een "users" tabel.
CREATE TABLE users (
    username varchar(50),
    password varchar(255),
	-- het verschil tussen "text" en "varchar" is dat je van varchar de lengte kan limiteren en van text niet.
	email text
);

-- Maak een remote controller tabel
CREATE TABLE remote_controllers (
	-- We maken hier automatisch gegenereerde ID.
    id int GENERATED ALWAYS AS IDENTITY,
    name text not null unique,
    brand text not null unique,
    price double precision not null,
    original_stock int not null,
	-- sql kent geen camelcase, dus gebruiken we snakecase
    compatible_with varchar,
    battery_type varchar, 
	-- We zorgen dat de ID daadwerkelijk de (identiteits)sleutel van de tabel is
	PRIMARY KEY(id)
);

-- We creëren de andere tabellen op dezelfde manier
CREATE TABLE cimodules (
	-- Hier staat PRIMARY KEY bij het id zelf vermeld. Dit mag ook op het einde. Het resultaat is hetzelfde.
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE,
    type text NOT NULL UNIQUE,
    price double precision NOT NULL
);


CREATE TABLE wall_brackets (
	-- hier gebruiken we "bigserial". Dit is van zichzelf al sequentieel, dus kan je daar niet ook nog "GENERATED ALWAYS AS IDENTITY" achter zetten
    id bigserial PRIMARY KEY,
    name text NOT NULL UNIQUE,
	size text,
    price double precision NOT NULL,
	adjustable boolean NOT NULL,
	brand text
);

-- De "televisions" tabel is de tabel waar de foreign keys in zitten. We maken deze tabel als laatste aan, zodat de targets van de foreign keys ook al echt bestaan.
CREATE TABLE televisions (
    id serial PRIMARY KEY,
    name text NOT NULL UNIQUE,
    brand text NOT NULL ,
    price double precision NOT NULL,
    original_stock int NOT NULL,
    sold int NOT NULL,
    type text,
    available_size int,
    refresh_rate double precision,
    screen_type varchar(100),
	screen_quality varchar(100),
	smart_tv boolean,
	wifi boolean,
	voice_control boolean,
	hdr boolean,
	bluetooth boolean,
	ambi_light boolean,
	remote_id int,
	ci_module_id int,
	-- Maak een relatie met remotecontrollers
    CONSTRAINT fk_remotecontroller FOREIGN KEY (remote_id) REFERENCES remote_controllers(id),
	-- Maak een relatie met cimodules
	CONSTRAINT fk_cimodule FOREIGN KEY (ci_module_id) REFERENCES cimodules(id)
);

-- We willen nu een relatie maken van meerder televisions met meerdere wallbrackets. We kunnen echter maar 1 waarde in een tabel cel opslaan. Daarom gebruiken we voor een veel-op-veel relatie een tussentabel. Conventie zegt dat we daar een combinatie-naam voor gebruiken zoals.
CREATE TABLE television_wall_brackets (
	-- int is de niet-sequentiele variant van serial
	television_id int,
	-- bigint is de niet-sequentiele variant van bigserial
	wall_bracket_id bigint,
	CONSTRAINT fk_television FOREIGN KEY (television_id) REFERENCES televisions(id),
	CONSTRAINT fk_wallbracket FOREIGN KEY (wall_bracket_id) REFERENCES wall_brackets(id)
);

-- Hieronder volgen een aantal INSERT statements om de database te vullen
INSERT INTO wall_brackets (id, name, size, adjustable, brand, price) VALUES (1001, 'LG small', '25X32', false, 'LG bracket', 32.23);
INSERT INTO wall_brackets (id, name, size, adjustable, brand, price) VALUES (1002, 'LG big', '25X32/32X40', true, 'LG bracket', 32.23);
INSERT INTO wall_brackets (id, name, size, adjustable, brand, price) VALUES (1003, 'Philips small', '25X25', false, 'Philips bracket', 32.23);
INSERT INTO wall_brackets (id, name, size, adjustable, brand, price) VALUES (1004, 'Nikkei big', '25X32/32X40', true, 'Nikkei bracket', 32.23);
INSERT INTO wall_brackets (id, name, size, adjustable, brand, price) VALUES (1005, 'Nikkei small', '25X32', false, 'Nikkei bracket', 32.23);

-- Het id van cimodules en remote_controllers is "GENERATED ALWAYS", daarom hoeven we dat hier niet mee te geven. Dat wordt automatisch gedaan.
INSERT INTO cimodules (name, type, price) VALUES ('universal CI-module', '23JI12', 32.5);

INSERT INTO remote_controllers (compatible_with, battery_type, name, brand, price, original_stock) VALUES ('NH3216SMART', 'AAA', 'Nikkei HD smart TV controller', 'Nikkei', 12.99, 235885);
INSERT INTO remote_controllers (compatible_with, battery_type, name, brand, price, original_stock) VALUES ('43PUS6504/12/L', 'AA', 'Philips smart TV controller', 'Philips', 12.99, 235885);
INSERT INTO remote_controllers (compatible_with, battery_type, name, brand, price, original_stock) VALUES ('OLED55C16LA', 'AAA', 'OLED55C16LA TV controller', 'LG', 12.99, 235885);

INSERT INTO televisions (id, type, brand, name, price, available_size, refresh_rate, screen_type, screen_quality, smart_tv, wifi, voice_control, hdr, bluetooth, ambi_light, original_stock, sold)
VALUES       (1001, 'NH3216SMART', 'Nikkei', 'HD smart TV', 159, 32, 100, 'LED', 'HD ready',  true, true, false, false, false, false, 235885, 45896);
INSERT INTO televisions (id, type, brand, name, price, available_size, refresh_rate, screen_type, screen_quality, smart_tv, wifi, voice_control, hdr, bluetooth, ambi_light, original_stock, sold) VALUES (1002, '43PUS6504/12/L', 'Philips', '4K UHD LED Smart Tv L', 379, 43, 60, 'LED', 'Ultra HD',  true, true, false, true, false, false, 8569452, 5685489);
INSERT INTO televisions (id, type, brand, name, price, available_size, refresh_rate, screen_type, screen_quality, smart_tv, wifi, voice_control, hdr, bluetooth, ambi_light, original_stock, sold) VALUES (1003, '43PUS6504/12/M', 'Philips', '4K UHD LED Smart Tv M', 379, 50, 60, 'LED', 'Ultra HD',  true, true, false, true, false, false, 345549, 244486);
INSERT INTO televisions (id, type, brand, name, price, available_size, refresh_rate, screen_type, screen_quality, smart_tv, wifi, voice_control, hdr, bluetooth, ambi_light, original_stock, sold) VALUES (1004, '43PUS6504/12/S', 'Philips', '4K UHD LED Smart Tv S', 379, 58, 60, 'LED', 'Ultra HD',  true, true, false, true, false, false, 6548945, 4485741);
INSERT INTO televisions (id, type, brand, name, price, available_size, refresh_rate, screen_type, screen_quality, smart_tv, wifi, voice_control, hdr, bluetooth, ambi_light, original_stock, sold) VALUES (1005, 'OLED55C16LA', 'LG', 'LG OLED55C16LA', 989, 55, 100, 'OLED', 'ULTRA HD',  true, true, true, true, true, false, 50000, 20500);

INSERT INTO television_wall_brackets(television_id, wall_bracket_id) values (1005, 1001);
INSERT INTO television_wall_brackets(television_id, wall_bracket_id) values (1005, 1002);
INSERT INTO television_wall_brackets(television_id, wall_bracket_id) values (1002, 1003);
INSERT INTO television_wall_brackets(television_id, wall_bracket_id) values (1003, 1003);
INSERT INTO television_wall_brackets(television_id, wall_bracket_id) values (1004, 1003);
INSERT INTO television_wall_brackets(television_id, wall_bracket_id) values (1001, 1004);
INSERT INTO television_wall_brackets(television_id, wall_bracket_id) values (1001, 1005);


INSERT INTO users (username, password, email) VALUES ('user', '$2a$12$7obBbnHFUkg9AaOUQ/mc5OzseFypWMg2pyB49c.3XAqKPYS.z3rHy','user@test.nl');
INSERT INTO users (username, password, email) VALUES ('admin', '$2a$10$wPHxwfsfTnOJAdgYcerBt.utdAvC24B/DWfuXfzKBSDHO0etB1ica', 'admin@test.nl');


UPDATE televisions SET remote_id = 1 WHERE id = 1001;

-- Als laatste maken we nog een SELECT statement om de data uit de database te bekijken

SELECT televisions.id AS tvid, remote_controllers.id AS rmid
FROM televisions JOIN remote_controllers
 ON remote_controllers.id = televisions.remote_id;
