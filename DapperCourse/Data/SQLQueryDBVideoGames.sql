/* =========================================================
   1. CREAR BASE DE DATOS
   ========================================================= */
CREATE DATABASE VideoGameDB_Normalized;
GO

USE VideoGameDB_Normalized;
GO

/* =========================================================
   2. TABLAS MAESTRAS
   ========================================================= */

/* Publishers */
CREATE TABLE dbo.Publishers (
    PublisherId INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName NVARCHAR(100) NOT NULL UNIQUE
);
GO

/* Developers */
CREATE TABLE dbo.Developers (
    DeveloperId INT IDENTITY(1,1) PRIMARY KEY,
    DeveloperName NVARCHAR(100) NOT NULL UNIQUE
);
GO

/* Platforms */
CREATE TABLE dbo.Platforms (
    PlatformId INT IDENTITY(1,1) PRIMARY KEY,
    PlatformName NVARCHAR(50) NOT NULL UNIQUE
);
GO

/* =========================================================
   3. TABLA PRINCIPAL
   ========================================================= */

CREATE TABLE dbo.VideoGames (
    VideoGameId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(150) NOT NULL,
    PublisherId INT NOT NULL,
    DeveloperId INT NOT NULL,
    ReleaseDate DATE NOT NULL,

    CONSTRAINT FK_VideoGames_Publishers
        FOREIGN KEY (PublisherId)
        REFERENCES dbo.Publishers (PublisherId),

    CONSTRAINT FK_VideoGames_Developers
        FOREIGN KEY (DeveloperId)
        REFERENCES dbo.Developers (DeveloperId)
);
GO

/* =========================================================
   4. TABLA RELACIÓN MUCHOS-A-MUCHOS
   ========================================================= */

CREATE TABLE dbo.VideoGamePlatforms (
    VideoGameId INT NOT NULL,
    PlatformId INT NOT NULL,

    CONSTRAINT PK_VideoGamePlatforms
        PRIMARY KEY (VideoGameId, PlatformId),

    CONSTRAINT FK_VGP_VideoGames
        FOREIGN KEY (VideoGameId)
        REFERENCES dbo.VideoGames (VideoGameId)
        ON DELETE CASCADE,

    CONSTRAINT FK_VGP_Platforms
        FOREIGN KEY (PlatformId)
        REFERENCES dbo.Platforms (PlatformId)
);
GO

/* =========================================================
   5. INSERTAR DATOS
   ========================================================= */

/* Platforms */
INSERT INTO dbo.Platforms (PlatformName)
VALUES
('PC'),
('PlayStation 4'),
('PlayStation 5'),
('Xbox One'),
('Xbox Series X'),
('Nintendo Switch');
GO

/* Publishers */
INSERT INTO dbo.Publishers (PublisherName)
VALUES
('Nintendo'),
('Sony Interactive Entertainment'),
('Rockstar Games'),
('CD Projekt'),
('Bandai Namco'),
('Mojang'),
('Xbox Game Studios'),
('Ubisoft'),
('Activision'),
('Capcom'),
('Square Enix');
GO

/* Developers */
INSERT INTO dbo.Developers (DeveloperName)
VALUES
('Nintendo'),
('Santa Monica Studio'),
('Rockstar Studios'),
('CD Projekt Red'),
('FromSoftware'),
('Mojang'),
('Rockstar North'),
('343 Industries'),
('Ubisoft Montreal'),
('Guerrilla Games'),
('Infinity Ward'),
('Capcom'),
('Square Enix');
GO

/* VideoGames */
INSERT INTO dbo.VideoGames (Title, PublisherId, DeveloperId, ReleaseDate)
VALUES
('The Legend of Zelda: Breath of the Wild', 1, 1, '2017-03-03'),
('God of War', 2, 2, '2018-04-20'),
('Red Dead Redemption 2', 3, 3, '2018-10-26'),
('The Witcher 3: Wild Hunt', 4, 4, '2015-05-19'),
('Elden Ring', 5, 5, '2022-02-25'),
('Minecraft', 6, 6, '2011-11-18'),
('Grand Theft Auto V', 3, 7, '2013-09-17'),
('Halo Infinite', 7, 8, '2021-12-08'),
('Cyberpunk 2077', 4, 4, '2020-12-10'),
('Dark Souls III', 5, 5, '2016-04-12'),
('Assassin''s Creed Valhalla', 8, 9, '2020-11-10'),
('Horizon Zero Dawn', 2, 10, '2017-02-28'),
('Call of Duty: Modern Warfare', 9, 11, '2019-10-25'),
('Resident Evil Village', 10, 12, '2021-05-07'),
('Final Fantasy VII Remake', 11, 13, '2020-04-10');
GO

/* =========================================================
   6. RELACIONAR VIDEOJUEGOS CON PLATAFORMAS
   ========================================================= */

INSERT INTO dbo.VideoGamePlatforms (VideoGameId, PlatformId)
VALUES
-- Zelda
(1, 6),

-- God of War
(2, 2),
(2, 3),

-- RDR2
(3, 1),
(3, 4),

-- Witcher 3
(4, 1),
(4, 2),
(4, 6),

-- Elden Ring
(5, 1),
(5, 2),
(5, 4),
(5, 5),

-- Minecraft
(6, 1),
(6, 4),
(6, 6),

-- GTA V
(7, 1),
(7, 4),

-- Halo Infinite
(8, 5),

-- Cyberpunk
(9, 1),
(9, 5),

-- Dark Souls III
(10, 2),

-- Assassin’s Creed Valhalla
(11, 1),

-- Horizon Zero Dawn
(12, 2),

-- COD Modern Warfare
(13, 1),

-- Resident Evil Village
(14, 3),

-- FF VII Remake
(15, 2);
GO

/* =========================================================
   7. CONSULTA FINAL DE VERIFICACIÓN
   ========================================================= */

SELECT
    vg.VideoGameId,
    vg.Title,
    p.PublisherName,
    d.DeveloperName,
    pl.PlatformName,
    vg.ReleaseDate
FROM dbo.VideoGames vg
JOIN dbo.Publishers p ON vg.PublisherId = p.PublisherId
JOIN dbo.Developers d ON vg.DeveloperId = d.DeveloperId
JOIN dbo.VideoGamePlatforms vgp ON vg.VideoGameId = vgp.VideoGameId
JOIN dbo.Platforms pl ON vgp.PlatformId = pl.PlatformId
ORDER BY vg.VideoGameId, pl.PlatformName;
