USE master;
GO
DROP DATABASE IF EXISTS PaintingGraph;
GO
CREATE DATABASE PaintingGraph;
GO

USE PaintingGraph;
GO

-- Создание таблиц узлов
USE PaintingGraph;
GO

DROP TABLE IF EXISTS Paintings;
CREATE TABLE Paintings (
    ID INT PRIMARY KEY,
    Title VARCHAR(100),
    YearCreation INT
) AS NODE;

DROP TABLE IF EXISTS Authors;
CREATE TABLE Authors (
    ID INT PRIMARY KEY,
    NameAuthors VARCHAR(100),
    LastNameAuthors VARCHAR(100),
    PatronymicAuthors VARCHAR(100)
) AS NODE;

DROP TABLE IF EXISTS Genres;
CREATE TABLE Genres (
    ID INT PRIMARY KEY,
    Name VARCHAR(100)
) AS NODE;

DROP TABLE IF EXISTS Styles;
CREATE TABLE Styles (
    ID INT PRIMARY KEY,
    Name VARCHAR(100)
) AS NODE;


-- Вставка данных в таблицы узлов
INSERT INTO Paintings (ID, Title, YearCreation)
VALUES 
(1, 'Подсолнухи', 1887),
(2, 'Ночное кафе', 1888),
(3, 'Супрематическая композиция', 1916),
(4, 'Золотые рыбки', 1902),
(5, 'Розовый сад', 1912),
(6, 'Герника', 1937),
(7, 'Автопортрет с отрезанным ухом и трубкой', 1889),
(8, 'Постоянство памяти', 1931),
(9, 'Над городом', 1918),
(10, 'Крик', 1893);

INSERT INTO Authors (ID, NameAuthors, LastNameAuthors, PatronymicAuthors)
VALUES 
(1, 'Винсент', 'Ван Гог', NULL),
(2, 'Казимир', 'Малевич', 'Северинович'),
(3, 'Густав', 'Климт', NULL),
(4, 'Пабло', 'Пикассо', NULL),
(5, 'Клод', 'Моне', NULL),
(6, 'Сальвадор', 'Дали', NULL),
(7, 'Эдвард', 'Мунк', NULL),
(8, 'Фрида', 'Кало', NULL),
(9, 'Марк', 'Шагал', NULL),
(10, 'Эдгар', 'Дега', NULL);

INSERT INTO Genres (ID, Name)
VALUES 
(1, 'Живопись'),
(2, 'Натюрморт'),
(3, 'Портрет'),
(4, 'Пейзаж'),
(5, 'Абстракция');

INSERT INTO Styles (ID, Name)
VALUES 
(1, 'Импрессионизм'),
(2, 'Постимпрессионизм'),
(3, 'Супрематизм'),
(4, 'Экспрессионизм'),
(5, 'Сюрреализм'),
(6, 'Кубизм'),
(7, 'Модерн'),
(8, 'Минимализм'),
(9, 'Романтизм'),
(10, 'Примитивизм');

-- Создание таблиц рёбер
DROP TABLE IF EXISTS PaintingsOfAuthors;
CREATE TABLE PaintingsOfAuthors AS EDGE;

DROP TABLE IF EXISTS PaintingsOfGenres;
CREATE TABLE PaintingsOfGenres AS EDGE;

DROP TABLE IF EXISTS PaintingsOfStyles;
CREATE TABLE PaintingsOfStyles AS EDGE;


-- Авторы
INSERT INTO PaintingsOfAuthors
VALUES ((SELECT $node_id FROM Paintings WHERE ID = 1), (SELECT $node_id FROM Authors WHERE ID = 1)),
       ((SELECT $node_id FROM Paintings WHERE ID = 2), (SELECT $node_id FROM Authors WHERE ID = 1)),
       ((SELECT $node_id FROM Paintings WHERE ID = 3), (SELECT $node_id FROM Authors WHERE ID = 2)),
       ((SELECT $node_id FROM Paintings WHERE ID = 4), (SELECT $node_id FROM Authors WHERE ID = 3)),
       ((SELECT $node_id FROM Paintings WHERE ID = 5), (SELECT $node_id FROM Authors WHERE ID = 3)),
       ((SELECT $node_id FROM Paintings WHERE ID = 6), (SELECT $node_id FROM Authors WHERE ID = 4)),
       ((SELECT $node_id FROM Paintings WHERE ID = 7), (SELECT $node_id FROM Authors WHERE ID = 1)),
       ((SELECT $node_id FROM Paintings WHERE ID = 8), (SELECT $node_id FROM Authors WHERE ID = 6)),
       ((SELECT $node_id FROM Paintings WHERE ID = 9), (SELECT $node_id FROM Authors WHERE ID = 9)),
       ((SELECT $node_id FROM Paintings WHERE ID = 10), (SELECT $node_id FROM Authors WHERE ID = 8));

-- Жанры
INSERT INTO PaintingsOfGenres
VALUES ((SELECT $node_id FROM Paintings WHERE ID = 1), (SELECT $node_id FROM Genres WHERE ID = 2)),
       ((SELECT $node_id FROM Paintings WHERE ID = 2), (SELECT $node_id FROM Genres WHERE ID = 1)),
       ((SELECT $node_id FROM Paintings WHERE ID = 3), (SELECT $node_id FROM Genres WHERE ID = 3)),
       ((SELECT $node_id FROM Paintings WHERE ID = 4), (SELECT $node_id FROM Genres WHERE ID = 1)),
       ((SELECT $node_id FROM Paintings WHERE ID = 5), (SELECT $node_id FROM Genres WHERE ID = 4)),
       ((SELECT $node_id FROM Paintings WHERE ID = 6), (SELECT $node_id FROM Genres WHERE ID = 1)),
       ((SELECT $node_id FROM Paintings WHERE ID = 7), (SELECT $node_id FROM Genres WHERE ID = 3)),
       ((SELECT $node_id FROM Paintings WHERE ID = 8), (SELECT $node_id FROM Genres WHERE ID = 4)),
       ((SELECT $node_id FROM Paintings WHERE ID = 9), (SELECT $node_id FROM Genres WHERE ID = 4)),
       ((SELECT $node_id FROM Paintings WHERE ID = 10), (SELECT $node_id FROM Genres WHERE ID = 4));

-- Стили
INSERT INTO PaintingsOfStyles
VALUES ((SELECT $node_id FROM Paintings WHERE ID = 1), (SELECT $node_id FROM Styles WHERE ID = 2)),
       ((SELECT $node_id FROM Paintings WHERE ID = 2), (SELECT $node_id FROM Styles WHERE ID = 1)),
       ((SELECT $node_id FROM Paintings WHERE ID = 3), (SELECT $node_id FROM Styles WHERE ID = 3)),
       ((SELECT $node_id FROM Paintings WHERE ID = 4), (SELECT $node_id FROM Styles WHERE ID = 7)),
       ((SELECT $node_id FROM Paintings WHERE ID = 5), (SELECT $node_id FROM Styles WHERE ID = 7)),
       ((SELECT $node_id FROM Paintings WHERE ID = 6), (SELECT $node_id FROM Styles WHERE ID = 6)),
       ((SELECT $node_id FROM Paintings WHERE ID = 7), (SELECT $node_id FROM Styles WHERE ID = 2)),
       ((SELECT $node_id FROM Paintings WHERE ID = 8), (SELECT $node_id FROM Styles WHERE ID = 5)),
       ((SELECT $node_id FROM Paintings WHERE ID = 9), (SELECT $node_id FROM Styles WHERE ID = 5)),
       ((SELECT $node_id FROM Paintings WHERE ID = 10), (SELECT $node_id FROM Styles WHERE ID = 4));

--------------------------------Match---------------------

-- 1. Найти все картины, написанные Винсентом Ван Гогом
SELECT P.Title, P.YearCreation
FROM Authors A,
     PaintingsOfAuthors PA,
     Paintings P
WHERE MATCH(P-(PA)->A)
  AND A.NameAuthors = 'Винсент'
  AND A.LastNameAuthors = 'Ван Гог';




-- 2. Найти авторов, написавших картины в жанре 'Пейзаж'
SELECT DISTINCT A.NameAuthors, A.LastNameAuthors
FROM Authors A,
     PaintingsOfAuthors PA,
     Paintings P,
     PaintingsOfGenres PG,
     Genres G
WHERE MATCH(P-(PA)->A) AND MATCH(P-(PG)->G)
  AND G.Name = 'Живопись';




-- 3. Найти все стили, в которых написаны картины, созданные после 1900 года
SELECT DISTINCT S.Name
FROM Paintings P,
     PaintingsOfStyles PS,
     Styles S
WHERE MATCH(P-(PS)->S)
  AND P.YearCreation > 1900;




-- 4. Найти картины, которые являются кубизмом и написаны Пабло Пикассо
SELECT P.Title
FROM Authors A,
     PaintingsOfAuthors PA,
     Paintings P,
     PaintingsOfStyles PS,
     Styles S
WHERE MATCH(P-(PA)->A) 
  AND MATCH(P-(PS)->S)
  AND A.NameAuthors = 'Пабло'
  AND A.LastNameAuthors = 'Пикассо'
  AND S.Name = 'Кубизм';





-- 5. Найти картины, относящиеся к стилю 'Сюрреализм'
SELECT P.Title, P.YearCreation
FROM Paintings P,
     PaintingsOfStyles PS,
     Styles S
WHERE MATCH(P-(PS)->S)
  AND S.Name = 'Сюрреализм';




------------------Shortest_path------------------

SELECT 
    P1.Title AS StartPainting,
    STRING_AGG(CONCAT(A2.NameAuthors, ' ', A2.LastNameAuthors), ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToAuthors
FROM Paintings AS P1,
     PaintingsOfAuthors FOR PATH AS pa,
     Authors FOR PATH AS A2
WHERE MATCH(SHORTEST_PATH(P1(-(pa)->A2)+))
  AND P1.Title = 'Подсолнухи';


  SELECT 
    P1.Title AS StartPainting,
    STRING_AGG(CONCAT(A2.NameAuthors, ' ', A2.LastNameAuthors), ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToAuthors
FROM Paintings AS P1,
     PaintingsOfAuthors FOR PATH AS pa,
     Authors FOR PATH AS A2
WHERE MATCH(SHORTEST_PATH(P1(-(pa)->A2){1,3}))
  AND P1.Title = 'Подсолнухи';


----Для Power BI--

SELECT @@servername -- WIN-RFMH2VKLV64\SQLEXPRESS01

--- Название базы данных: PaintingGraph

--- https://raw.githubusercontent.com/Luploof/PaintingGraph/refs/heads/main/picture/

-- Получить все картины и их авторов

SELECT 
    P.ID AS IdFirst,
    P.Title AS First,
    CONCAT(N'painting', P.ID) AS [First image name],
    A.ID AS IdSecond,
    CONCAT(A.NameAuthors, ' ', A.LastNameAuthors) AS Second,
    CONCAT(N'author', A.ID) AS [Second image name]
FROM Paintings AS P,
     PaintingsOfAuthors PA,
     Authors A
WHERE MATCH(P-(PA)->A);

-- Получить все картины и жанры
SELECT 
    P.ID AS IdFirst,
    P.Title AS First,
    CONCAT(N'painting', P.ID) AS [First image name],
    G.ID AS IdSecond,
    G.Name AS Second,
    CONCAT(N'genre', G.ID) AS [Second image name]
FROM Paintings AS P,
     PaintingsOfGenres AS PG,
     Genres AS G
WHERE MATCH(P-(PG)->G);


-- Получить все картины и стили

SELECT 
    P.ID AS IdFirst,
    P.Title AS First,
    CONCAT(N'painting', P.ID) AS [First image name],
    S.ID AS IdSecond,
    S.Name AS Second,
    CONCAT(N'style', S.ID) AS [Second image name]
FROM Paintings AS P,
     PaintingsOfStyles AS PS,
     Styles AS S
WHERE MATCH(P-(PS)->S);



--------------------------------------------------------