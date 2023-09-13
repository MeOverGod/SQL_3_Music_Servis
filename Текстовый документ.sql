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
VALUES('Latimore');

INSERT INTO Artist(name)
VALUES('Hi-Fi');

INSERT INTO Artist(name)
VALUES('alt-J');

INSERT INTO Artist(name)
VALUES('Van Halen');

INSERT INTO Artist(name)
VALUES('IC3PEAK'), ('Хаски');

--Альбом (имя, год)

INSERT INTO Albom(name, year)
VALUES('It Ain''t Where You Been', 1974);

INSERT INTO Albom(name, year)
VALUES('The Best (Легенды Русского Радио)', 2004);

INSERT INTO Albom(name, year)
VALUES('An Awesome Wave', 2012);

INSERT INTO Albom(name, year)
VALUES('Best of Volume 1', 1996);

INSERT INTO Albom(name, year)
VALUES('До свидания', 2020);

--Исполнитель_Альбом (id исполнитель, id альбома)

INSERT INTO Artist_Albom(artist_id, albom_id)
VALUES(1, 1);

INSERT INTO Artist_Albom(artist_id, albom_id)
VALUES(2,2);

INSERT INTO Artist_Albom(artist_id, albom_id)
VALUES(3,3);

INSERT INTO Artist_Albom(artist_id, albom_id)
VALUES(4, 4);

INSERT INTO Artist_Albom(artist_id, albom_id)
VALUES(5, 5), (6, 5);

--Песня (имя, продолжительность, id альбома)

INSERT INTO Song(name, duration, albom_id)
VALUES('Let Me Go', 184, 1);

INSERT INTO Song(name, duration, albom_id)
VALUES('Седьмой лепесток', 191, 2);

INSERT INTO Song(name, duration, albom_id)
VALUES('Breezeblocks', 227, 3);

INSERT INTO Song(name, duration, albom_id)
VALUES('Fitzpleasure', 219, 3);

INSERT INTO Song(name, duration, albom_id)
VALUES('Jump', 239, 4);

INSERT INTO Song(name, duration, albom_id)
VALUES('Eruption', 102, 4);

INSERT INTO Song(name, duration, albom_id)
VALUES('Весело и грустно', 194, 5);

--Сборник (имя, год)

INSERT INTO Collection(name, year)
VALUES('Собрание классики', 2016);

INSERT INTO Collection(name, year)
VALUES('Сборник 1', 2017);

INSERT INTO Collection(name, year)
VALUES('Сборка', 2012);

INSERT INTO Collection(name, year)
VALUES('Песенный набор', 2023);

INSERT INTO Collection(name, year)
VALUES('Песня года', 2019);

--Песня_Сборник (id песни, id сборника)

INSERT INTO Song_Collection(song_id, collection_id)
VALUES(5, 1);

INSERT INTO Song_Collection(song_id, collection_id)
VALUES(7, 1);

INSERT INTO Song_Collection(song_id, collection_id)
VALUES(2, 1);

INSERT INTO Song_Collection(song_id, collection_id)
VALUES(3,2);

INSERT INTO Song_Collection(song_id, collection_id)
VALUES(4,3);

INSERT INTO Song_Collection(song_id, collection_id)
VALUES(6, 4);

INSERT INTO Song_Collection(song_id, collection_id)
VALUES(3, 5);

--Жанр (имя)

INSERT INTO Genre(name)
VALUES('Blues');

INSERT INTO Genre(name)
VALUES('Pop');

INSERT INTO Genre(name)
VALUES('Indie');

INSERT INTO Genre(name)
VALUES('Rock');

INSERT INTO Genre(name)
VALUES('Rap');

--Исполнитель_Жанр (id исполнитель, id жанра)

INSERT INTO Artist_Genre(artist_id, genre_id)
VALUES(1, 1);

INSERT INTO Artist_Genre(artist_id, genre_id)
VALUES(2,2);

INSERT INTO Artist_Genre(artist_id, genre_id)
VALUES(3,3);

INSERT INTO Artist_Genre(artist_id, genre_id)
VALUES(4, 4);

INSERT INTO Artist_Genre(artist_id, genre_id)
VALUES(5, 3);

INSERT INTO Artist_Genre(artist_id, genre_id)
VALUES(6, 5);

--SELECT 1

--Название и продолжительность самого длительного трека
SELECT name, duration FROM Song
ORDER BY duration DESC
LIMIT 1;

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
SELECT t.name FROM artist t
FULL JOIN artist_albom aa ON t.id = aa.artist_id
FULL JOIN albom a ON a.id = aa.albom_id
WHERE year != 2020;

--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
SELECT c.name FROM collection c
FULL JOIN song_collection sc ON c.id = sc.collection_id
FULL JOIN song s ON s.id = sc.song_id
FULL JOIN albom a ON a.id = s.albom_id
FULL JOIN artist_albom aa ON a.id = aa.albom_id
FULL JOIN artist t ON t.id = aa.artist_id
WHERE t.name = 'Hi-Fi'
GROUP BY c.name;