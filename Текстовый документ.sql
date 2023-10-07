CREATE TABLE IF NOT EXISTS Albom (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL,
	year INTEGER NOT NULL,
		CHECK (year<=2023)
);

CREATE TABLE IF NOT EXISTS Song (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL,
	duration INTEGER NOT NULL,
    albom_id INTEGER NOT NULL REFERENCES Albom(id)
);

CREATE TABLE IF NOT EXISTS Collection (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL,
    year INTEGER NOT NULL,
		CHECK (year<=2023)
);

CREATE TABLE IF NOT EXISTS Artist (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS Genre (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS Artist_Albom (
	artist_id INTEGER NOT NULL REFERENCES Artist(id),
    albom_id INTEGER NOT NULL REFERENCES Albom(id),
		CONSTRAINT artist_albom_pk PRIMARY KEY (artist_id, albom_id)
);

CREATE TABLE IF NOT EXISTS Artist_Genre (
	artist_id INTEGER NOT NULL REFERENCES Artist(id),
    genre_id INTEGER NOT NULL REFERENCES Genre(id),
		CONSTRAINT artist_genre_pk PRIMARY KEY (artist_id, genre_id)
);

CREATE TABLE IF NOT EXISTS Song_Collection (
	song_id INTEGER NOT NULL REFERENCES Song(id),
    collection_id INTEGER NOT NULL REFERENCES Collection(id),
		CONSTRAINT song_collection_pk PRIMARY KEY (song_id, collection_id)
);

--INSERT

--Исполнитель (имя)

INSERT INTO Artist(name)
VALUES
	('Latimore'),
	('Hi-Fi'),
	('alt-J'),
	('Van Halen'),
	('IC3PEAK'),
	('Хаски');

--Альбом (имя, год)

INSERT INTO Albom(name, year)
VALUES
	('It Ain''t Where You Been', 1974),
	('The Best (Легенды Русского Радио)', 2004),
	('An Awesome Wave', 2012),
	('Best of Volume 1', 1996),
	('До свидания', 2020);

--Исполнитель_Альбом (id исполнитель, id альбома)

INSERT INTO Artist_Albom(artist_id, albom_id)
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 5);

--Песня (имя, продолжительность, id альбома)

INSERT INTO Song(name, duration, albom_id)
VALUES
	('Let Me Go', 184, 1),
	('Седьмой лепесток', 191, 2),
	('Breezeblocks', 227, 3),
	('Fitzpleasure', 219, 3),
	('Jump', 239, 4);

INSERT INTO Song(name, duration, albom_id)
VALUES('Eruption', 102, 4);

INSERT INTO Song(name, duration, albom_id)
VALUES('Весело и грустно', 194, 5);

--Сборник (имя, год)

INSERT INTO Collection(name, year)
VALUES
	('Собрание классики', 2016),
	('Сборник 1', 2017),
	('Сборка', 2012),
	('Песенный набор', 2023),
	('Песня года', 2019);

--Песня_Сборник (id песни, id сборника)

INSERT INTO Song_Collection(song_id, collection_id)
VALUES
	(5, 1), 
	(7, 1),
	(2, 1),
	(3, 2),
	(4, 3),
	(6, 4),
	(3, 5);

--Жанр (имя)

INSERT INTO Genre(name)
VALUES
	('Blues'),
	('Pop'),
	('Indie'),
	('Rock'),
	('Rap');

--Исполнитель_Жанр (id исполнитель, id жанра)

INSERT INTO Artist_Genre(artist_id, genre_id)
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 3),
	(6, 5);

--SELECT 1

--Название и продолжительность самого длительного трека
SELECT name, duration FROM Song
WHERE duration = (SELECT MAX(duration) FROM Song);

--Название треков, продолжительность которых не менее 3,5 минут
SELECT name FROM Song
WHERE duration >= 210;

--Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT name FROM Collection
WHERE year BETWEEN 2018 AND 2020;

--Исполнители, чьё имя состоит из одного слова
SELECT name FROM Artist
WHERE name NOT LIKE '% %';

--Название треков, которые содержат слово «мой» или «my»
SELECT name FROM Song
WHERE name LIKE '%мой%' or name LIKE '%my%';

--SELECT 2

--Количество исполнителей в каждом жанре
SELECT COUNT(artist_id), genre_id FROM Artist_Genre
GROUP BY genre_id;

--Количество треков, вошедших в альбомы 2019–2020 годов
SELECT COUNT(albom_id) FROM Song s
FULL JOIN albom a ON a.id = s.albom_id
WHERE year BETWEEN 2019 AND 2020;

--Средняя продолжительность треков по каждому альбому
SELECT AVG(duration), a.name FROM Song s
FULL JOIN albom a ON a.id = s.albom_id
GROUP BY a.name;

--Все исполнители, которые не выпустили альбомы в 2020 году
SELECT t.name, a.year FROM artist t
FULL JOIN artist_albom aa ON t.id = aa.artist_id
FULL JOIN albom a ON a.id = aa.albom_id
WHERE t.name NOT IN (SELECT t.name FROM artist_albom WHERE a.year = 2020);

--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
SELECT DISTINCT c.name FROM collection c
JOIN song_collection sc ON c.id = sc.collection_id
JOIN song s ON s.id = sc.song_id
JOIN albom a ON a.id = s.albom_id
JOIN artist_albom aa ON a.id = aa.albom_id
JOIN artist t ON t.id = aa.artist_id
WHERE t.name = 'Hi-Fi';