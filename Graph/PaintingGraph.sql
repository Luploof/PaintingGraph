USE master;
GO
DROP DATABASE IF EXISTS PaintingGraph;
GO
CREATE DATABASE PaintingGraph;
GO

USE PaintingGraph;
GO

-- �������� ������ �����
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


-- ������� ������ � ������� �����
INSERT INTO Paintings (ID, Title, YearCreation)
VALUES 
(1, '����������', 1887),
(2, '������ ����', 1888),
(3, '��������������� ����������', 1916),
(4, '������� �����', 1902),
(5, '������� ���', 1912),
(6, '�������', 1937),
(7, '����������� � ���������� ���� � �������', 1889),
(8, '����������� ������', 1931),
(9, '��� �������', 1918),
(10, '����', 1893);

INSERT INTO Authors (ID, NameAuthors, LastNameAuthors, PatronymicAuthors)
VALUES 
(1, '�������', '��� ���', NULL),
(2, '�������', '�������', '�����������'),
(3, '������', '�����', NULL),
(4, '�����', '�������', NULL),
(5, '����', '����', NULL),
(6, '���������', '����', NULL),
(7, '������', '����', NULL),
(8, '�����', '����', NULL),
(9, '����', '�����', NULL),
(10, '�����', '����', NULL);

INSERT INTO Genres (ID, Name)
VALUES 
(1, '��������'),
(2, '���������'),
(3, '�������'),
(4, '������'),
(5, '����������');

INSERT INTO Styles (ID, Name)
VALUES 
(1, '�������������'),
(2, '�����������������'),
(3, '�����������'),
(4, '��������������'),
(5, '����������'),
(6, '������'),
(7, '������'),
(8, '����������'),
(9, '���������'),
(10, '�����������');

-- �������� ������ ����
DROP TABLE IF EXISTS PaintingsOfAuthors;
CREATE TABLE PaintingsOfAuthors AS EDGE;

DROP TABLE IF EXISTS PaintingsOfGenres;
CREATE TABLE PaintingsOfGenres AS EDGE;

DROP TABLE IF EXISTS PaintingsOfStyles;
CREATE TABLE PaintingsOfStyles AS EDGE;


-- ������
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

-- �����
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

-- �����
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

-- 1. ����� ��� �������, ���������� ��������� ��� �����
SELECT P.Title, P.YearCreation
FROM Authors A,
     PaintingsOfAuthors PA,
     Paintings P
WHERE MATCH(P-(PA)->A)
  AND A.NameAuthors = '�������'
  AND A.LastNameAuthors = '��� ���';




-- 2. ����� �������, ���������� ������� � ����� '������'
SELECT DISTINCT A.NameAuthors, A.LastNameAuthors
FROM Authors A,
     PaintingsOfAuthors PA,
     Paintings P,
     PaintingsOfGenres PG,
     Genres G
WHERE MATCH(P-(PA)->A) AND MATCH(P-(PG)->G)
  AND G.Name = '��������';




-- 3. ����� ��� �����, � ������� �������� �������, ��������� ����� 1900 ����
SELECT DISTINCT S.Name
FROM Paintings P,
     PaintingsOfStyles PS,
     Styles S
WHERE MATCH(P-(PS)->S)
  AND P.YearCreation > 1900;




-- 4. ����� �������, ������� �������� �������� � �������� ����� �������
SELECT P.Title
FROM Authors A,
     PaintingsOfAuthors PA,
     Paintings P,
     PaintingsOfStyles PS,
     Styles S
WHERE MATCH(P-(PA)->A) 
  AND MATCH(P-(PS)->S)
  AND A.NameAuthors = '�����'
  AND A.LastNameAuthors = '�������'
  AND S.Name = '������';





-- 5. ����� �������, ����������� � ����� '����������'
SELECT P.Title, P.YearCreation
FROM Paintings P,
     PaintingsOfStyles PS,
     Styles S
WHERE MATCH(P-(PS)->S)
  AND S.Name = '����������';




------------------Shortest_path------------------

SELECT 
    P1.Title AS StartPainting,
    STRING_AGG(CONCAT(A2.NameAuthors, ' ', A2.LastNameAuthors), ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToAuthors
FROM Paintings AS P1,
     PaintingsOfAuthors FOR PATH AS pa,
     Authors FOR PATH AS A2
WHERE MATCH(SHORTEST_PATH(P1(-(pa)->A2)+))
  AND P1.Title = '����������';


  SELECT 
    P1.Title AS StartPainting,
    STRING_AGG(CONCAT(A2.NameAuthors, ' ', A2.LastNameAuthors), ' ->') 
        WITHIN GROUP (GRAPH PATH) AS PathToAuthors
FROM Paintings AS P1,
     PaintingsOfAuthors FOR PATH AS pa,
     Authors FOR PATH AS A2
WHERE MATCH(SHORTEST_PATH(P1(-(pa)->A2){1,3}))
  AND P1.Title = '����������';


----��� Power BI--

SELECT @@servername -- WIN-RFMH2VKLV64\SQLEXPRESS01

--- �������� ���� ������: PaintingGraph

--- https://raw.githubusercontent.com/Luploof/PaintingGraph/refs/heads/main/picture/

-- �������� ��� ������� � �� �������

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

-- �������� ��� ������� � �����
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


-- �������� ��� ������� � �����

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