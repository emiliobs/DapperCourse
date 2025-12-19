/* =====================================================
   1. CREAR BASE DE DATOS
   ===================================================== */
CREATE DATABASE VideoGameDB_Normalizada;
GO
USE VideoGameDB_Normalizada;
GO

/* =====================================================
   2. TABLAS MAESTRAS
   ===================================================== */

/* Developers */
CREATE TABLE dbo.Developers (
    DeveloperId INT IDENTITY PRIMARY KEY,
    DeveloperName NVARCHAR(100) NOT NULL UNIQUE
);

/* Publishers */
CREATE TABLE dbo.Publishers (
    PublisherId INT IDENTITY PRIMARY KEY,
    PublisherName NVARCHAR(100) NOT NULL UNIQUE
);

/* Platforms */
CREATE TABLE dbo.Platforms (
    PlatformId INT IDENTITY PRIMARY KEY,
    PlatformName NVARCHAR(50) NOT NULL UNIQUE
);

/* =====================================================
   3. TABLA PRINCIPAL
   ===================================================== */

CREATE TABLE dbo.VideoGames (
    VideoGameId INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(150) NOT NULL,
    PublisherId INT NOT NULL,
    DeveloperId INT NOT NULL,
    ReleaseDate DATE NOT NULL,
    CONSTRAINT FK_VideoGames_Publishers
        FOREIGN KEY (PublisherId) REFERENCES dbo.Publishers(PublisherId),
    CONSTRAINT FK_VideoGames_Developers
        FOREIGN KEY (DeveloperId) REFERENCES dbo.Developers(DeveloperId)
);

/* =====================================================
   4. TABLA RELACIÓN JUEGO–PLATAFORMA
   ===================================================== */

CREATE TABLE dbo.GameDetails (
    GameDetailId INT IDENTITY PRIMARY KEY,
    VideoGameId INT NOT NULL,
    PlatformId INT NOT NULL,
    CONSTRAINT FK_GameDetails_VideoGames
        FOREIGN KEY (VideoGameId) REFERENCES dbo.VideoGames(VideoGameId)
        ON DELETE CASCADE,
    CONSTRAINT FK_GameDetails_Platforms
        FOREIGN KEY (PlatformId) REFERENCES dbo.Platforms(PlatformId),
    CONSTRAINT UQ_Game_Platform UNIQUE (VideoGameId, PlatformId)
);

/* =====================================================
   5. REVIEWS
   ===================================================== */

CREATE TABLE dbo.Reviews (
    ReviewId INT IDENTITY PRIMARY KEY,
    VideoGameId INT NOT NULL,
    Score DECIMAL(3,1) NOT NULL CHECK (Score BETWEEN 0 AND 10),
    Comment NVARCHAR(500),
    ReviewDate DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reviews_VideoGames
        FOREIGN KEY (VideoGameId) REFERENCES dbo.VideoGames(VideoGameId)
        ON DELETE CASCADE
);
GO

/* =====================================================
   6. INSERTAR RECORDS
   ===================================================== */

/* Platforms */
INSERT INTO dbo.Platforms (PlatformName) VALUES
('PC'), ('PlayStation 4'), ('PlayStation 5'),
('Xbox One'), ('Xbox Series X'), ('Nintendo Switch');

/* Publishers */
INSERT INTO dbo.Publishers (PublisherName) VALUES
('Nintendo'), ('Sony Interactive Entertainment'),
('Rockstar Games'), ('CD Projekt'),
('Bandai Namco'), ('Mojang'),
('Xbox Game Studios'), ('Ubisoft'),
('Activision'), ('Capcom'), ('Square Enix');

/* Developers */
INSERT INTO dbo.Developers (DeveloperName) VALUES
('Nintendo'), ('Santa Monica Studio'),
('Rockstar Studios'), ('CD Projekt Red'),
('FromSoftware'), ('Mojang'),
('Rockstar North'), ('343 Industries'),
('Ubisoft Montreal'), ('Guerrilla Games'),
('Infinity Ward'), ('Capcom'), ('Square Enix');

/* VideoGames */
INSERT INTO dbo.VideoGames (Title, PublisherId, DeveloperId, ReleaseDate) VALUES
('The Legend of Zelda: Breath of the Wild',1,1,'2017-03-03'),
('God of War',2,2,'2018-04-20'),
('Red Dead Redemption 2',3,3,'2018-10-26'),
('The Witcher 3: Wild Hunt',4,4,'2015-05-19'),
('Elden Ring',5,5,'2022-02-25'),
('Minecraft',6,6,'2011-11-18'),
('Grand Theft Auto V',3,7,'2013-09-17'),
('Halo Infinite',7,8,'2021-12-08'),
('Cyberpunk 2077',4,4,'2020-12-10'),
('Dark Souls III',5,5,'2016-04-12'),
('Assassin''s Creed Valhalla',8,9,'2020-11-10'),
('Horizon Zero Dawn',2,10,'2017-02-28'),
('Call of Duty: Modern Warfare',9,11,'2019-10-25'),
('Resident Evil Village',10,12,'2021-05-07'),
('Final Fantasy VII Remake',11,13,'2020-04-10');

/* GameDetails (Juego–Plataforma) */
INSERT INTO dbo.GameDetails (VideoGameId, PlatformId) VALUES
(1,6),
(2,2),(2,3),
(3,1),(3,4),
(4,1),(4,6),
(5,1),(5,3),(5,5),
(6,1),(6,6),
(7,1),(7,4),
(8,5),
(9,1),
(10,2),
(11,1),
(12,2),
(13,1),
(14,3),
(15,2);

/* Reviews */
INSERT INTO dbo.Reviews (VideoGameId, Score, Comment) VALUES
(1,9.9,'Obra maestra'),
(2,9.8,'Narrativa sobresaliente'),
(3,9.7,'Mundo abierto impresionante'),
(4,9.8,'RPG legendario'),
(5,9.6,'Diseño desafiante'),
(6,9.5,'Creatividad infinita'),
(7,9.6,'Clásico moderno'),
(8,8.9,'Buen regreso'),
(9,8.5,'Ambicioso'),
(10,9.2,'Combate refinado'),
(11,8.8,'Gran ambientación'),
(12,9.4,'Historia emotiva'),
(13,8.7,'Multiplayer sólido'),
(14,9.0,'Terror bien logrado'),
(15,9.3,'Remake excelente');
GO

SELECT
    vg.Title,
    pub.PublisherName,
    dev.DeveloperName,
    pl.PlatformName,
    r.Score
FROM dbo.VideoGames vg
JOIN dbo.Publishers pub ON vg.PublisherId = pub.PublisherId
JOIN dbo.Developers dev ON vg.DeveloperId = dev.DeveloperId
JOIN dbo.GameDetails gd ON vg.VideoGameId = gd.VideoGameId
JOIN dbo.Platforms pl ON gd.PlatformId = pl.PlatformId
LEFT JOIN dbo.Reviews r ON vg.VideoGameId = r.VideoGameId
ORDER BY vg.VideoGameId;


Select * from VideoGames