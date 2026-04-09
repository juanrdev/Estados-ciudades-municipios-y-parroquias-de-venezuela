-- ============================================================
-- Script SQL Server - División Político-Territorial de Venezuela
-- Generado automáticamente desde venezuela.js
-- Fecha    : 2026-04-09T18:28:36.546Z
-- Tabla	Total
-- Estados	24
-- Municipios	335
-- Parroquias	1139
-- Ciudades (total)	479
-- Ciudades vinculadas	259
-- Ciudades sin municipio	220
-- Ing. Juan C. Rodríguez
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'VenezuelaDB')
BEGIN
    CREATE DATABASE VenezuelaDB COLLATE Latin1_General_CI_AI;
END
GO

USE VenezuelaDB;
GO

-- ============================================================
-- SECCIÓN 1: Creación de Tablas
-- ============================================================

IF OBJECT_ID('dbo.Parroquias', 'U') IS NOT NULL DROP TABLE dbo.Parroquias;
IF OBJECT_ID('dbo.Ciudades',   'U') IS NOT NULL DROP TABLE dbo.Ciudades;
IF OBJECT_ID('dbo.Municipios', 'U') IS NOT NULL DROP TABLE dbo.Municipios;
IF OBJECT_ID('dbo.Estados',    'U') IS NOT NULL DROP TABLE dbo.Estados;
GO

CREATE TABLE dbo.Estados (
    IdEstado    INT            NOT NULL,
    Iso31662    NVARCHAR(10)   NOT NULL,
    Nombre      NVARCHAR(100)  NOT NULL,
    Capital     NVARCHAR(150)  NOT NULL,
    CONSTRAINT PK_Estados PRIMARY KEY CLUSTERED (IdEstado)
);
GO

CREATE TABLE dbo.Municipios (
    IdMunicipio INT            NOT NULL IDENTITY(1,1),
    IdEstado    INT            NOT NULL,
    Nombre      NVARCHAR(150)  NOT NULL,
    Capital     NVARCHAR(150)  NOT NULL,
    CONSTRAINT PK_Municipios PRIMARY KEY CLUSTERED (IdMunicipio),
    CONSTRAINT FK_Municipios_Estados FOREIGN KEY (IdEstado)
        REFERENCES dbo.Estados (IdEstado)
);
GO

CREATE TABLE dbo.Parroquias (
    IdParroquia INT            NOT NULL IDENTITY(1,1),
    IdMunicipio INT            NOT NULL,
    Nombre      NVARCHAR(200)  NOT NULL,
    CONSTRAINT PK_Parroquias PRIMARY KEY CLUSTERED (IdParroquia),
    CONSTRAINT FK_Parroquias_Municipios FOREIGN KEY (IdMunicipio)
        REFERENCES dbo.Municipios (IdMunicipio)
);
GO

-- IdMunicipio NULL = ciudad que no es capital de ningún municipio
CREATE TABLE dbo.Ciudades (
    IdCiudad    INT            NOT NULL IDENTITY(1,1),
    IdEstado    INT            NOT NULL,
    IdMunicipio INT            NULL,
    Nombre      NVARCHAR(200)  NOT NULL,
    CONSTRAINT PK_Ciudades PRIMARY KEY CLUSTERED (IdCiudad),
    CONSTRAINT FK_Ciudades_Estados    FOREIGN KEY (IdEstado)
        REFERENCES dbo.Estados (IdEstado),
    CONSTRAINT FK_Ciudades_Municipios FOREIGN KEY (IdMunicipio)
        REFERENCES dbo.Municipios (IdMunicipio)
);
GO

-- ============================================================
-- SECCIÓN 2: Índices
-- ============================================================

CREATE NONCLUSTERED INDEX IX_Municipios_IdEstado     ON dbo.Municipios (IdEstado);
CREATE NONCLUSTERED INDEX IX_Parroquias_IdMunicipio  ON dbo.Parroquias (IdMunicipio);
CREATE NONCLUSTERED INDEX IX_Ciudades_IdEstado       ON dbo.Ciudades   (IdEstado);
CREATE NONCLUSTERED INDEX IX_Ciudades_IdMunicipio    ON dbo.Ciudades   (IdMunicipio);
GO

-- ============================================================
-- SECCIÓN 3: Inserción de Datos
-- ============================================================

-- 3.1 Estados (24 registros)
INSERT INTO dbo.Estados (IdEstado, Iso31662, Nombre, Capital) VALUES
    (1, 'VE-X', 'Amazonas', 'Puerto Ayacucho'),
    (2, 'VE-B', 'Anzoátegui', 'Barcelona'),
    (3, 'VE-C', 'Apure', 'San Fernando de Apure'),
    (4, 'VE-D', 'Aragua', 'Maracay'),
    (5, 'VE-E', 'Barinas', 'Barinas'),
    (6, 'VE-F', 'Bolívar', 'Ciudad Bolívar'),
    (7, 'VE-G', 'Carabobo', 'Valencia'),
    (8, 'VE-H', 'Cojedes', 'San Carlos'),
    (9, 'VE-Y', 'Delta Amacuro', 'Tucupita'),
    (10, 'VE-I', 'Falcón', 'Coro'),
    (11, 'VE-J', 'Guárico', 'San Juan de Los Morros'),
    (12, 'VE-K', 'Lara', 'Barquisimeto'),
    (13, 'VE-L', 'Mérida', 'Mérida'),
    (14, 'VE-M', 'Miranda', 'Los Teques'),
    (15, 'VE-N', 'Monagas', 'Maturín'),
    (16, 'VE-O', 'Nueva Esparta', 'La Asunción'),
    (17, 'VE-P', 'Portuguesa', 'Guanare'),
    (18, 'VE-R', 'Sucre', 'Cumaná'),
    (19, 'VE-S', 'Táchira', 'San Cristóbal'),
    (20, 'VE-T', 'Trujillo', 'Trujillo'),
    (21, 'VE-W', 'Vargas', 'La Guaira'),
    (22, 'VE-U', 'Yaracuy', 'San Felipe'),
    (23, 'VE-V', 'Zulia', 'Maracaibo'),
    (24, 'VE-A', 'Distrito Capital', 'Caracas');
GO

-- 3.2 Municipios y Parroquias
-- IdMunicipio asignado por IDENTITY(1,1) — se captura con SCOPE_IDENTITY()

-- Estado: Amazonas (IdEstado=1)
DECLARE @IdMun INT;

-- Municipio #1: Alto Orinoco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (1, 'Alto Orinoco', 'La Esmeralda');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 1
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Alto Orinoco La Esmeralda'),
    (@IdMun, 'Huachamacare Acanaña'),
    (@IdMun, 'Marawaka Toky Shamanaña'),
    (@IdMun, 'Mavaka Mavaka'),
    (@IdMun, 'Sierra Parima Parimabé');

-- Municipio #2: Atabapo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (1, 'Atabapo', 'San Fernando de Atabapo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 2
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ucata Laja Lisa'),
    (@IdMun, 'Yapacana Macuruco'),
    (@IdMun, 'Caname Guarinuma');

-- Municipio #3: Atures
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (1, 'Atures', 'Puerto Ayacucho');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 3
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Fernando Girón Tovar'),
    (@IdMun, 'Luis Alberto Gómez'),
    (@IdMun, 'Pahueña Limón de Parhueña'),
    (@IdMun, 'Platanillal Platanillal');

-- Municipio #4: Autana
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (1, 'Autana', 'Isla Ratón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 4
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Samariapo Samariapo'),
    (@IdMun, 'Sipapo Pendare'),
    (@IdMun, 'Munduapo Munduapo'),
    (@IdMun, 'Guayapo San Pedro del Orinoco');

-- Municipio #5: Manapiare
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (1, 'Manapiare', 'San Juan de Manapiare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 5
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Alto Ventuari Cacurí'),
    (@IdMun, 'Medio Ventuari Manami'),
    (@IdMun, 'Bajo Ventuari Marueta');

-- Municipio #6: Maroa
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (1, 'Maroa', 'Maroa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 6
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Victorino'),
    (@IdMun, 'Comunidad');

-- Municipio #7: Río Negro
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (1, 'Río Negro', 'San Carlos de Río Negro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 7
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Casiquiare Curimacare'),
    (@IdMun, 'Cocuy'),
    (@IdMun, 'San Carlos de Río Negro'),
    (@IdMun, 'Solano Solano');

GO

-- Estado: Anzoátegui (IdEstado=2)
DECLARE @IdMun INT;

-- Municipio #8: Anaco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Anaco', 'Anaco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 8
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Anaco'),
    (@IdMun, 'San Joaquín');

-- Municipio #9: Aragua
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Aragua', 'Aragua de Barcelona');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 9
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cachipo'),
    (@IdMun, 'Aragua de Barcelona');

-- Municipio #10: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Bolívar', 'Barcelona');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 10
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bergatín'),
    (@IdMun, 'Caigua'),
    (@IdMun, 'El Carmen.'),
    (@IdMun, 'El Pilar'),
    (@IdMun, 'Naricual.'),
    (@IdMun, 'San Cristóbal');

-- Municipio #11: Bruzual
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Bruzual', 'Clarines');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 11
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Clarines'),
    (@IdMun, 'Guanape'),
    (@IdMun, 'Sabana de Uchire');

-- Municipio #12: Cajigal
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Cajigal', 'Onoto');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 12
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Onoto'),
    (@IdMun, 'San Pablo');

-- Municipio #13: Carvajal
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Carvajal', 'Valle de Guanape');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 13
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Valle de Guanape'),
    (@IdMun, 'Santa Bárbara');

-- Municipio #14: Diego Bautista Urbaneja
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Diego Bautista Urbaneja', 'Lechería');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 14
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Lechería'),
    (@IdMun, 'El Morro');

-- Municipio #15: Freites
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Freites', 'Cantaura');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 15
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cantaura'),
    (@IdMun, 'Libertador'),
    (@IdMun, 'Santa Rosa'),
    (@IdMun, 'Urica');

-- Municipio #16: Guanipa
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Guanipa', 'San José de Guanipa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 16
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San José de Guanipa');

-- Municipio #17: Guanta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Guanta', 'Guanta');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 17
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guanta'),
    (@IdMun, 'Chorrerón');

-- Municipio #18: Independencia
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Independencia', 'Soledad');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 18
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Mamo'),
    (@IdMun, 'Soledad');

-- Municipio #19: Libertad
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Libertad', 'San Mateo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 19
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Mateo'),
    (@IdMun, 'El Carito'),
    (@IdMun, 'Santa Inés'),
    (@IdMun, 'La Romereña');

-- Municipio #20: McGregor
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'McGregor', 'El Chaparro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 20
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Chaparro'),
    (@IdMun, 'Tomás Alfaro'),
    (@IdMun, 'Calatrava');

-- Municipio #21: Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Miranda', 'Pariaguán');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 21
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Atapirire'),
    (@IdMun, 'Boca del Pao'),
    (@IdMun, 'El Pao'),
    (@IdMun, 'Pariaguán');

-- Municipio #22: Monagas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Monagas', 'Mapire');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 22
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Mapire'),
    (@IdMun, 'Piar'),
    (@IdMun, 'Santa Clara'),
    (@IdMun, 'San Diego de Cabrutica'),
    (@IdMun, 'Uverito'),
    (@IdMun, 'Zuata');

-- Municipio #23: Peñalver
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Peñalver', 'Puerto Píritu');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 23
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Puerto Píritu'),
    (@IdMun, 'San Miguel'),
    (@IdMun, 'Sucre');

-- Municipio #24: Píritu
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Píritu', 'Píritu');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 24
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Píritu'),
    (@IdMun, 'San Francisco');

-- Municipio #25: San Juan de Capistrano
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'San Juan de Capistrano', 'Boca de Uchire');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 25
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Boca de Uchire'),
    (@IdMun, 'Boca de Chávez');

-- Municipio #26: Santa Ana
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Santa Ana', 'Santa Ana');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 26
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Pueblo Nuevo'),
    (@IdMun, 'Santa Ana');

-- Municipio #27: Simón Rodríguez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Simón Rodríguez', 'El Tigre');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 27
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Edmundo Barrios'),
    (@IdMun, 'Miguel Otero Silva');

-- Municipio #28: Sotillo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (2, 'Sotillo', 'Puerto La Cruz');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 28
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Puerto La Cruz'),
    (@IdMun, 'Pozuelos');

GO

-- Estado: Apure (IdEstado=3)
DECLARE @IdMun INT;

-- Municipio #29: Achaguas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (3, 'Achaguas', 'Achaguas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 29
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Achaguas'),
    (@IdMun, 'Apurito'),
    (@IdMun, 'El Yagual'),
    (@IdMun, 'Guachara'),
    (@IdMun, 'Mucuritas'),
    (@IdMun, 'Queseras del medio');

-- Municipio #30: Biruaca
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (3, 'Biruaca', 'Biruaca');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 30
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Biruaca');

-- Municipio #31: Muñoz
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (3, 'Muñoz', 'Bruzual');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 31
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bruzual'),
    (@IdMun, 'Mantecal'),
    (@IdMun, 'Quintero'),
    (@IdMun, 'Rincón Hondo'),
    (@IdMun, 'San Vicente');

-- Municipio #32: Páez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (3, 'Páez', 'Guasdualito');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 32
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guasdualito'),
    (@IdMun, 'Aramendi'),
    (@IdMun, 'El Amparo'),
    (@IdMun, 'San Camilo'),
    (@IdMun, 'Urdaneta');

-- Municipio #33: Pedro Camejo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (3, 'Pedro Camejo', 'San Juan de Payara');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 33
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Juan de Payara'),
    (@IdMun, 'Codazzi'),
    (@IdMun, 'Cunaviche');

-- Municipio #34: Rómulo Gallegos
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (3, 'Rómulo Gallegos', 'Elorza');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 34
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Elorza'),
    (@IdMun, 'La Trinidad');

-- Municipio #35: San Fernando
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (3, 'San Fernando', 'San Fernando de Apure');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 35
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Fernando'),
    (@IdMun, 'El Recreo'),
    (@IdMun, 'Peñalver'),
    (@IdMun, 'San Rafael de Atamaica');

GO

-- Estado: Aragua (IdEstado=4)
DECLARE @IdMun INT;

-- Municipio #36: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Bolívar', 'San Mateo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 36
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bolívar');

-- Municipio #37: Camatagua
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Camatagua', 'Camatagua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 37
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Camatagua'),
    (@IdMun, 'Carmen de Cura');

-- Municipio #38: Francisco Linares Alcántara
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Francisco Linares Alcántara', 'Santa Rita');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 38
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Rita'),
    (@IdMun, 'Francisco de Miranda'),
    (@IdMun, 'Moseñor Feliciano González');

-- Municipio #39: Girardot
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Girardot', 'Maracay');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 39
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Pedro José Ovalles'),
    (@IdMun, 'Joaquín Crespo'),
    (@IdMun, 'José Casanova Godoy'),
    (@IdMun, 'Madre María de San José'),
    (@IdMun, 'Andrés Eloy Blanco'),
    (@IdMun, 'Los Tacarigua'),
    (@IdMun, 'Las Delicias'),
    (@IdMun, 'Choroní');

-- Municipio #40: José Ángel Lamas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'José Ángel Lamas', 'Santa Cruz de Aragua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 40
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Cruz');

-- Municipio #41: José Félix Ribas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'José Félix Ribas', 'La Victoria');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 41
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'José Félix Ribas'),
    (@IdMun, 'Castor Nieves Ríos'),
    (@IdMun, 'Las Guacamayas'),
    (@IdMun, 'Pao de Zárate'),
    (@IdMun, 'Zuata');

-- Municipio #42: José Rafael Revenga
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'José Rafael Revenga', 'El Consejo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 42
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'José Rafael Revenga');

-- Municipio #43: Libertador
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Libertador', 'Palo Negro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 43
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Palo Negro'),
    (@IdMun, 'San Martín de Porres');

-- Municipio #44: Mario Briceño Iragorry
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Mario Briceño Iragorry', 'El Limón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 44
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Limón'),
    (@IdMun, 'Caña de Azúcar');

-- Municipio #45: Ocumare de la Costa de Oro
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Ocumare de la Costa de Oro', 'Ocumare de la Costa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 45
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ocumare de la Costa');

-- Municipio #46: San Casimiro
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'San Casimiro', 'San Casimiro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 46
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Casimiro'),
    (@IdMun, 'Güiripa'),
    (@IdMun, 'Ollas de Caramacate'),
    (@IdMun, 'Valle Morín');

-- Municipio #47: San Sebastián
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'San Sebastián', 'San Sebastián de Los Reyes');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 47
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Sebastián');

-- Municipio #48: Santiago Mariño
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Santiago Mariño', 'Turmero');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 48
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Turmero'),
    (@IdMun, 'Arevalo Aponte'),
    (@IdMun, 'Chuao'),
    (@IdMun, 'Samán de Güere'),
    (@IdMun, 'Alfredo Pacheco Miranda');

-- Municipio #49: Santos Michelena
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Santos Michelena', 'Las Tejerías');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 49
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santos Michelena'),
    (@IdMun, 'Tiara');

-- Municipio #50: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Sucre', 'Cagua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 50
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cagua'),
    (@IdMun, 'Bella Vista');

-- Municipio #51: Tovar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Tovar', 'Colonia Tovar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 51
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tovar');

-- Municipio #52: Urdaneta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Urdaneta', 'Barbacoas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 52
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Urdaneta'),
    (@IdMun, 'Las Peñitas'),
    (@IdMun, 'San Francisco de Cara'),
    (@IdMun, 'Taguay');

-- Municipio #53: Zamora
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (4, 'Zamora', 'Villa de Cura');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 53
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Zamora'),
    (@IdMun, 'Magdaleno'),
    (@IdMun, 'San Francisco de Asís'),
    (@IdMun, 'Valles de Tucutunemo'),
    (@IdMun, 'Augusto Mijares');

GO

-- Estado: Barinas (IdEstado=5)
DECLARE @IdMun INT;

-- Municipio #54: Alberto Arvelo Torrealba
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Alberto Arvelo Torrealba', 'Sabaneta');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 54
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sabaneta'),
    (@IdMun, 'Juan Antonio Rodríguez Domínguez');

-- Municipio #55: Andrés Eloy Blanco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Andrés Eloy Blanco', 'El Cantón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 55
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Cantón'),
    (@IdMun, 'Santa Cruz de Guacas'),
    (@IdMun, 'Puerto Vivas');

-- Municipio #56: Antonio José de Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Antonio José de Sucre', 'Socopó');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 56
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ticoporo'),
    (@IdMun, 'Nicolás Pulido'),
    (@IdMun, 'Andrés Bello');

-- Municipio #57: Arismendi
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Arismendi', 'Arismendi');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 57
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Arismendi'),
    (@IdMun, 'Guadarrama'),
    (@IdMun, 'La Unión'),
    (@IdMun, 'San Antonio');

-- Municipio #58: Barinas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Barinas', 'Barinas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 58
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Barinas'),
    (@IdMun, 'Alberto Arvelo Larriva'),
    (@IdMun, 'San Silvestre'),
    (@IdMun, 'Santa Inés'),
    (@IdMun, 'Santa Lucía'),
    (@IdMun, 'Torunos'),
    (@IdMun, 'El Carmen'),
    (@IdMun, 'Rómulo Betancourt'),
    (@IdMun, 'Corazón de Jesús'),
    (@IdMun, 'Ramón Ignacio Méndez'),
    (@IdMun, 'Alto Barinas'),
    (@IdMun, 'Manuel Palacio Fajardo'),
    (@IdMun, 'Juan Antonio Rodríguez Domínguez'),
    (@IdMun, 'Dominga Ortiz de Páez');

-- Municipio #59: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Bolívar', 'Barinitas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 59
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Barinitas'),
    (@IdMun, 'Altamira de Cáceres'),
    (@IdMun, 'Calderas');

-- Municipio #60: Cruz Paredes
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Cruz Paredes', 'Barrancas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 60
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Barrancas'),
    (@IdMun, 'El Socorro'),
    (@IdMun, 'Mazparrito');

-- Municipio #61: Ezequiel Zamora
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Ezequiel Zamora', 'Santa Bárbara');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 61
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Bárbara'),
    (@IdMun, 'Pedro Briceño Méndez'),
    (@IdMun, 'Ramón Ignacio Méndez'),
    (@IdMun, 'José Ignacio del Pumar');

-- Municipio #62: Obispos
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Obispos', 'Obispos');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 62
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Obispos'),
    (@IdMun, 'Los Guasimitos'),
    (@IdMun, 'El Real'),
    (@IdMun, 'La Luz');

-- Municipio #63: Pedraza
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Pedraza', 'Ciudad Bolivia');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 63
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ciudad Bolívia'),
    (@IdMun, 'José Ignacio Briceño'),
    (@IdMun, 'José Félix Ribas'),
    (@IdMun, 'Páez');

-- Municipio #64: Rojas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Rojas', 'Libertad');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 64
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Libertad'),
    (@IdMun, 'Dolores'),
    (@IdMun, 'Santa Rosa'),
    (@IdMun, 'Palacio Fajardo'),
    (@IdMun, 'Simón Rodríguez');

-- Municipio #65: Sosa
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (5, 'Sosa', 'Ciudad de Nutrias');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 65
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ciudad de Nutrias'),
    (@IdMun, 'El Regalo'),
    (@IdMun, 'Puerto Nutrias'),
    (@IdMun, 'Santa Catalina'),
    (@IdMun, 'Simón Bolívar');

GO

-- Estado: Bolívar (IdEstado=6)
DECLARE @IdMun INT;

-- Municipio #66: Angostura
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Angostura', 'Ciudad Píar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 66
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Raúl Leoni'),
    (@IdMun, 'Barceloneta'),
    (@IdMun, 'Santa Bárbara'),
    (@IdMun, 'San Francisco');

-- Municipio #67: Caroní
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Caroní', 'Ciudad Guayana');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 67
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cachamay'),
    (@IdMun, 'Chirica'),
    (@IdMun, 'Dalla Costa'),
    (@IdMun, 'Once de Abril'),
    (@IdMun, 'Simón Bolívar'),
    (@IdMun, 'Unare'),
    (@IdMun, 'Universidad'),
    (@IdMun, 'Vista al Sol'),
    (@IdMun, 'Pozo Verde'),
    (@IdMun, 'Yocoima'),
    (@IdMun, '5 de Julio');

-- Municipio #68: Cedeño
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Cedeño', 'Caicara del Orinoco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 68
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cedeño'),
    (@IdMun, 'Altagracia'),
    (@IdMun, 'Ascensión Farreras'),
    (@IdMun, 'Guaniamo'),
    (@IdMun, 'La Urbana'),
    (@IdMun, 'Pijiguaos');

-- Municipio #69: El Callao
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'El Callao', 'El Callao');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 69
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Callao');

-- Municipio #70: Gran Sabana
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Gran Sabana', 'Santa Elena de Uairén');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 70
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Gran Sabana'),
    (@IdMun, 'Ikabarú');

-- Municipio #71: Heres
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Heres', 'Ciudad Bolívar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 71
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Catedral'),
    (@IdMun, 'Zea'),
    (@IdMun, 'Orinoco'),
    (@IdMun, 'José Antonio Páez'),
    (@IdMun, 'Marhuanta'),
    (@IdMun, 'Agua Salada'),
    (@IdMun, 'Vista Hermosa'),
    (@IdMun, 'La Sabanita'),
    (@IdMun, 'Panapana');

-- Municipio #72: Píar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Píar', 'Upata');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 72
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Andrés Eloy Blanco'),
    (@IdMun, 'Pedro Cova');

-- Municipio #73: Roscio
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Roscio', 'Guasipati');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 73
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Roscio'),
    (@IdMun, 'Salóm');

-- Municipio #74: Sifontes
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Sifontes', 'El Dorado');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 74
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sifontes'),
    (@IdMun, 'Dalla Costa'),
    (@IdMun, 'San Isidro');

-- Municipio #75: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Sucre', 'Maripa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 75
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sucre'),
    (@IdMun, 'Aripao'),
    (@IdMun, 'Guarataro'),
    (@IdMun, 'Las Majadas'),
    (@IdMun, 'Moitaco');

-- Municipio #76: Padre Pedro Chien
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (6, 'Padre Pedro Chien', 'El Palmar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 76
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Padre Pedro Chien'),
    (@IdMun, 'Río Grande');

GO

-- Estado: Carabobo (IdEstado=7)
DECLARE @IdMun INT;

-- Municipio #77: Bejuma
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Bejuma', 'Bejuma');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 77
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bejuma'),
    (@IdMun, 'Canoabo'),
    (@IdMun, 'Simón Bolívar');

-- Municipio #78: Carlos Arvelo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Carlos Arvelo', 'Güigüe');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 78
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Güigüe'),
    (@IdMun, 'Carabobo'),
    (@IdMun, 'Tacarigua');

-- Municipio #79: Diego Ibarra
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Diego Ibarra', 'Mariara');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 79
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Mariara'),
    (@IdMun, 'Aguas Calientes');

-- Municipio #80: Guacara
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Guacara', 'Guacara');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 80
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ciudad Alianza'),
    (@IdMun, 'Guacara'),
    (@IdMun, 'Yagua');

-- Municipio #81: Mora
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Mora', 'Morón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 81
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Morón'),
    (@IdMun, 'Urama');

-- Municipio #82: Libertador
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Libertador', 'Tocuyito');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 82
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Valencia'),
    (@IdMun, 'Campo Carabobo');

-- Municipio #83: Los Guayos
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Los Guayos', 'Los Guayos');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 83
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Los Guayos');

-- Municipio #84: Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Miranda', 'Miranda');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 84
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Miranda');

-- Municipio #85: Montalbán
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Montalbán', 'Montalbán');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 85
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Montalbán');

-- Municipio #86: Naguanagua
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Naguanagua', 'Naguanagua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 86
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Naguanagua');

-- Municipio #87: Puerto Cabello
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Puerto Cabello', 'Puerto Cabello');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 87
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bartolomé Salóm'),
    (@IdMun, 'Democracia'),
    (@IdMun, 'Fraternidad'),
    (@IdMun, 'Goaigoaza'),
    (@IdMun, 'Juan José Flores'),
    (@IdMun, 'Unión'),
    (@IdMun, 'Borburata'),
    (@IdMun, 'Patanemo');

-- Municipio #88: San Diego
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'San Diego', 'San Diego');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 88
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Diego');

-- Municipio #89: San Joaquín
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'San Joaquín', 'San Joaquín');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 89
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Joaquín');

-- Municipio #90: Valencia
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (7, 'Valencia', 'Valencia');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 90
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Urbana Candelaria'),
    (@IdMun, 'Urbana Catedral'),
    (@IdMun, 'Urbana El Socorro'),
    (@IdMun, 'Urbana Miguel Peña'),
    (@IdMun, 'Urbana Rafael Urdaneta'),
    (@IdMun, 'Urbana San Blas'),
    (@IdMun, 'Urbana San José'),
    (@IdMun, 'Urbana Santa Rosa'),
    (@IdMun, 'No Urbana Negro Primero');

GO

-- Estado: Cojedes (IdEstado=8)
DECLARE @IdMun INT;

-- Municipio #91: Anzoátegui
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Anzoátegui', 'Cojedes');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 91
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cojedes'),
    (@IdMun, 'Juan de Mata Suárez');

-- Municipio #92: Tinaquillo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Tinaquillo', 'Tinaquillo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 92
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tinaquillo');

-- Municipio #93: Girardot
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Girardot', 'El Baúl');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 93
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Baúl'),
    (@IdMun, 'Sucre');

-- Municipio #94: Lima Blanco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Lima Blanco', 'Macapo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 94
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'La Aguadita'),
    (@IdMun, 'Macapo');

-- Municipio #95: Pao de San Juan Bautista
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Pao de San Juan Bautista', 'El Pao');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 95
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Pao');

-- Municipio #96: Ricaurte
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Ricaurte', 'Libertad');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 96
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Amparo'),
    (@IdMun, 'Libertad de Cojedes');

-- Municipio #97: Rómulo Gallegos
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Rómulo Gallegos', 'Las Vegas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 97
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Rómulo Gallegos');

-- Municipio #98: San Carlos
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'San Carlos', 'San Carlos');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 98
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Carlos de Austria'),
    (@IdMun, 'Juan Ángel Bravo'),
    (@IdMun, 'Manuel Manrique');

-- Municipio #99: Tinaco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (8, 'Tinaco', 'Tinaco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 99
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'General en Jefe José Laurencio Silva');

GO

-- Estado: Delta Amacuro (IdEstado=9)
DECLARE @IdMun INT;

-- Municipio #100: Antonio Díaz
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (9, 'Antonio Díaz', 'Curiapo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 100
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Curiapo'),
    (@IdMun, 'Almirante Luis Brión'),
    (@IdMun, 'Francisco Aniceto Lugo Boca de Cuyubini'),
    (@IdMun, 'Manuel Renaud'),
    (@IdMun, 'Padre Barral'),
    (@IdMun, 'Santos de Abelgas');

-- Municipio #101: Casacoima
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (9, 'Casacoima', 'Sierra Imataca');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 101
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Imataca Moruca'),
    (@IdMun, 'Cinco de Julio Piacoa'),
    (@IdMun, 'Juan Bautista Arismendi'),
    (@IdMun, 'Manuel Piar Santa Catalina'),
    (@IdMun, 'Rómulo Gallegos');

-- Municipio #102: Pedernales
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (9, 'Pedernales', 'Pedernales');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 102
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Pedernales'),
    (@IdMun, 'Luis Beltrán Prieto Figueroa');

-- Municipio #103: Tucupita
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (9, 'Tucupita', 'Tucupita');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 103
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San José'),
    (@IdMun, 'José Vidal Marcano Caparal de Guara'),
    (@IdMun, 'Juan Millán'),
    (@IdMun, 'Leonardo Ruíz Pineda Paloma'),
    (@IdMun, 'Mariscal Antonio José de Sucre'),
    (@IdMun, 'Monseñor Argimiro García San Rafael'),
    (@IdMun, 'San Rafael'),
    (@IdMun, 'Virgen del Valle');

GO

-- Estado: Falcón (IdEstado=10)
DECLARE @IdMun INT;

-- Municipio #104: Acosta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Acosta', 'San Juan de los Cayos');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 104
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Capadare'),
    (@IdMun, 'La Pastora'),
    (@IdMun, 'Libertador'),
    (@IdMun, 'San Juan de los Cayos');

-- Municipio #105: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Bolívar', 'San Luis');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 105
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Aracua'),
    (@IdMun, 'La Peña'),
    (@IdMun, 'San Luis');

-- Municipio #106: Buchivacoa
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Buchivacoa', 'Capatárida');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 106
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bariro'),
    (@IdMun, 'Borojó'),
    (@IdMun, 'Capatárida'),
    (@IdMun, 'Guajiro'),
    (@IdMun, 'Seque'),
    (@IdMun, 'Zazárida'),
    (@IdMun, 'Valle de Eroa');

-- Municipio #107: Carirubana
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Carirubana', 'Punto Fijo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 107
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Norte'),
    (@IdMun, 'Carirubana'),
    (@IdMun, 'Santa Ana'),
    (@IdMun, 'Urbana Punta Cardón');

-- Municipio #108: Colina
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Colina', 'La Vela de Coro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 108
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'La Vela de Coro'),
    (@IdMun, 'Acurigua'),
    (@IdMun, 'Guaibacoa'),
    (@IdMun, 'Las Calderas'),
    (@IdMun, 'Macoruca');

-- Municipio #109: Dabajuro
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Dabajuro', 'Dabajuro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 109
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Dabajuro');

-- Municipio #110: Democracia
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Democracia', 'Pedregal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 110
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Agua Clara'),
    (@IdMun, 'Avaria'),
    (@IdMun, 'Pedregal'),
    (@IdMun, 'Piedra Grande'),
    (@IdMun, 'Purureche');

-- Municipio #111: Falcón
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Falcón', 'Pueblo Nuevo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 111
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Adaure'),
    (@IdMun, 'Adícora'),
    (@IdMun, 'Baraived'),
    (@IdMun, 'Buena Vista'),
    (@IdMun, 'Jadacaquiva'),
    (@IdMun, 'El Vínculo'),
    (@IdMun, 'El Hato'),
    (@IdMun, 'Moruy'),
    (@IdMun, 'Pueblo Nuevo');

-- Municipio #112: Federación
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Federación', 'Churuguara');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 112
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Agua Larga'),
    (@IdMun, 'Churuguara'),
    (@IdMun, 'El Paují'),
    (@IdMun, 'Independencia'),
    (@IdMun, 'Mapararí');

-- Municipio #113: Jacura
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Jacura', 'Jacura');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 113
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Agua Linda'),
    (@IdMun, 'Araurima'),
    (@IdMun, 'Jacura');

-- Municipio #114: Los Taques
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Los Taques', 'Santa Cruz de Los Taques');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 114
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Los Taques'),
    (@IdMun, 'Judibana');

-- Municipio #115: Manaure
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Manaure', 'Yaracal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 115
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cacique Manaure');

-- Municipio #116: Mauroa
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Mauroa', 'Mene de Mauroa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 116
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Mene de Mauroa'),
    (@IdMun, 'San Félix'),
    (@IdMun, 'Casigua');

-- Municipio #117: Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Miranda', 'Santa Ana de Coro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 117
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guzmán Guillermo'),
    (@IdMun, 'Mitare'),
    (@IdMun, 'Río Seco'),
    (@IdMun, 'Sabaneta'),
    (@IdMun, 'San Antonio'),
    (@IdMun, 'San Gabriel'),
    (@IdMun, 'Santa Ana');

-- Municipio #118: Monseñor Iturriza
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Monseñor Iturriza', 'Chichiriviche');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 118
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Boca del Tocuyo'),
    (@IdMun, 'Chichiriviche'),
    (@IdMun, 'Tocuyo de la Costa');

-- Municipio #119: Palmasola
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Palmasola', 'Palmasola');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 119
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Palmasola');

-- Municipio #120: Petit
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Petit', 'Cabure');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 120
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cabure'),
    (@IdMun, 'Colina'),
    (@IdMun, 'Curimagua');

-- Municipio #121: Píritu
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Píritu', 'Píritu');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 121
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San José de la Costa'),
    (@IdMun, 'Píritu');

-- Municipio #122: San Francisco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'San Francisco', 'Mirimire');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 122
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Capital San Francisco');

-- Municipio #123: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Sucre', 'La Cruz de Taratara');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 123
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sucre'),
    (@IdMun, 'Pecaya');

-- Municipio #124: Silva
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Silva', 'Tucacas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 124
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tucacas'),
    (@IdMun, 'Boca de Aroa');

-- Municipio #125: Tocópero
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Tocópero', 'Tocópero');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 125
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tocópero');

-- Municipio #126: Unión
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Unión', 'Santa Cruz de Bucaral');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 126
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Charal'),
    (@IdMun, 'Las Vegas del Tuy'),
    (@IdMun, 'Santa Cruz de Bucaral');

-- Municipio #127: Urumaco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Urumaco', 'Urumaco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 127
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bruzual'),
    (@IdMun, 'Urumaco');

-- Municipio #128: Zamora
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (10, 'Zamora', 'Puerto Cumarebo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 128
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Puerto Cumarebo'),
    (@IdMun, 'La Ciénaga'),
    (@IdMun, 'La Soledad'),
    (@IdMun, 'Pueblo Cumarebo'),
    (@IdMun, 'Zazárida');

GO

-- Estado: Guárico (IdEstado=11)
DECLARE @IdMun INT;

-- Municipio #129: Camaguán
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Camaguán', 'Camaguán');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 129
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Camaguán'),
    (@IdMun, 'Puerto Miranda'),
    (@IdMun, 'Uverito');

-- Municipio #130: Chaguaramas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Chaguaramas', 'Chaguaramas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 130
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Chaguaramas');

-- Municipio #131: El Socorro
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'El Socorro', 'El Socorro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 131
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Socorro');

-- Municipio #132: Infante
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Infante', 'Valle de La Pascua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 132
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Valle de la Pascua'),
    (@IdMun, 'Espino');

-- Municipio #133: Las Mercedes
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Las Mercedes', 'Las Mercedes');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 133
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Las Mercedes'),
    (@IdMun, 'Cabruta'),
    (@IdMun, 'Santa Rita de Manapire');

-- Municipio #134: Mellado
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Mellado', 'El Sombrero');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 134
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Sombrero'),
    (@IdMun, 'Sosa');

-- Municipio #135: Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Miranda', 'Calabozo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 135
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Calvario'),
    (@IdMun, 'El Rastro'),
    (@IdMun, 'Guardatinajas'),
    (@IdMun, 'Capital Urbana Calabozo');

-- Municipio #136: Monagas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Monagas', 'Altagracia de Orituco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 136
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Altagracia de Orituco'),
    (@IdMun, 'San Rafael de Orituco'),
    (@IdMun, 'San Francisco Javier de Lezama'),
    (@IdMun, 'Paso Real de Macaira'),
    (@IdMun, 'Carlos Soublette'),
    (@IdMun, 'San Francisco de Macaira'),
    (@IdMun, 'Libertad de Orituco');

-- Municipio #137: Ortiz
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Ortiz', 'Ortiz');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 137
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San José de Tiznados'),
    (@IdMun, 'San Francisco de Tiznados'),
    (@IdMun, 'San Lorenzo de Tiznados'),
    (@IdMun, 'Ortiz');

-- Municipio #138: Ribas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Ribas', 'Tucupido');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 138
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tucupido'),
    (@IdMun, 'San Rafael de Laya');

-- Municipio #139: Roscio
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Roscio', 'San Juan de Los Morros');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 139
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cantagallo'),
    (@IdMun, 'San Juan de los Morros'),
    (@IdMun, 'Parapara');

-- Municipio #140: San Gerónimo de Guayabal
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'San Gerónimo de Guayabal', 'Guayabal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 140
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guayabal'),
    (@IdMun, 'Cazorla');

-- Municipio #141: San José de Guaribe
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'San José de Guaribe', 'San José de Guaribe');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 141
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San José de Guaribe'),
    (@IdMun, 'Uveral');

-- Municipio #142: Santa María de Ipire
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Santa María de Ipire', 'Santa María de Ipire');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 142
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa María de Ipire'),
    (@IdMun, 'Altamira');

-- Municipio #143: Zaraza
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (11, 'Zaraza', 'Zaraza');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 143
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Unare'),
    (@IdMun, 'Zaraza');

GO

-- Estado: Lara (IdEstado=12)
DECLARE @IdMun INT;

-- Municipio #144: Andrés Eloy Blanco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Andrés Eloy Blanco', 'Sanare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 144
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Quebrada Honda de Guache'),
    (@IdMun, 'Pío Tamayo'),
    (@IdMun, 'Yacambú');

-- Municipio #145: Crespo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Crespo', 'Duaca');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 145
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Freitez'),
    (@IdMun, 'José María Blanco');

-- Municipio #146: Iribarren
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Iribarren', 'Barquisimeto');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 146
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Catedral'),
    (@IdMun, 'Concepción'),
    (@IdMun, 'El Cují'),
    (@IdMun, 'Juan de Villegas'),
    (@IdMun, 'Santa Rosa'),
    (@IdMun, 'Tamaca'),
    (@IdMun, 'Unión'),
    (@IdMun, 'Aguedo Felipe Alvarado'),
    (@IdMun, 'Buena Vista'),
    (@IdMun, 'Juárez');

-- Municipio #147: Jiménez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Jiménez', 'Quibor');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 147
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Juan Bautista Rodríguez'),
    (@IdMun, 'Cuara'),
    (@IdMun, 'Diego de Lozada'),
    (@IdMun, 'Paraíso de San José'),
    (@IdMun, 'San Miguel'),
    (@IdMun, 'Tintorero'),
    (@IdMun, 'José Bernardo Dorante'),
    (@IdMun, 'Coronel Mariano Peraza');

-- Municipio #148: Morán
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Morán', 'El Tocuyo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 148
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Anzoátegui'),
    (@IdMun, 'Bolívar'),
    (@IdMun, 'Guárico'),
    (@IdMun, 'Hilario Luna y Luna'),
    (@IdMun, 'Humocaro Bajo'),
    (@IdMun, 'Humocaro Alto'),
    (@IdMun, 'La Candelaria'),
    (@IdMun, 'Morán');

-- Municipio #149: Palavecino
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Palavecino', 'Cabudare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 149
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cabudare'),
    (@IdMun, 'José Gregorio Bastidas'),
    (@IdMun, 'Agua Viva');

-- Municipio #150: Simón Planas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Simón Planas', 'Sarare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 150
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Buría'),
    (@IdMun, 'Gustavo Vega'),
    (@IdMun, 'Sarare');

-- Municipio #151: Torres
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Torres', 'Carora');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 151
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Altagracia'),
    (@IdMun, 'Antonio Díaz'),
    (@IdMun, 'Camacaro'),
    (@IdMun, 'Castañeda'),
    (@IdMun, 'Cecilio Zubillaga'),
    (@IdMun, 'Chiquinquira'),
    (@IdMun, 'El Blanco'),
    (@IdMun, 'Espinoza de los Monteros'),
    (@IdMun, 'Heriberto Arrollo'),
    (@IdMun, 'Lara'),
    (@IdMun, 'Las Mercedes'),
    (@IdMun, 'Manuel Morillo'),
    (@IdMun, 'Montaña Verde'),
    (@IdMun, 'Montes de Oca'),
    (@IdMun, 'Reyes de Vargas'),
    (@IdMun, 'Torres'),
    (@IdMun, 'Trinidad Samuel');

-- Municipio #152: Urdaneta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (12, 'Urdaneta', 'Siquisique');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 152
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Siquisique'),
    (@IdMun, 'San Miguel'),
    (@IdMun, 'Moroturo'),
    (@IdMun, 'Xaguas');

GO

-- Estado: Mérida (IdEstado=13)
DECLARE @IdMun INT;

-- Municipio #153: Alberto Adriani
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Alberto Adriani', 'El Vigía');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 153
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Presidente Betancourt'),
    (@IdMun, 'Presidente Páez'),
    (@IdMun, 'Presidente Rómulo Gallegos'),
    (@IdMun, 'Gabriel Picón González'),
    (@IdMun, 'Héctor Amable Mora'),
    (@IdMun, 'José Nucete Sardi'),
    (@IdMun, 'Pulido Méndez');

-- Municipio #154: Andrés Bello
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Andrés Bello', 'La Azulita');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 154
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'La Azulita');

-- Municipio #155: Antonio Pinto Salinas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Antonio Pinto Salinas', 'Santa Cruz de Mora');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 155
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Cruz de Mora'),
    (@IdMun, 'Mesa Bolívar'),
    (@IdMun, 'Mesa de Las Palmas');

-- Municipio #156: Aricagua
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Aricagua', 'Aricagua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 156
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Aricagua'),
    (@IdMun, 'San Antonio');

-- Municipio #157: Arzobispo Chacón
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Arzobispo Chacón', 'Canaguá');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 157
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Canagua'),
    (@IdMun, 'Capurí'),
    (@IdMun, 'Chacantá'),
    (@IdMun, 'El Molino'),
    (@IdMun, 'Guaimaral'),
    (@IdMun, 'Mucutuy'),
    (@IdMun, 'Mucuchachí');

-- Municipio #158: Campo Elías
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Campo Elías', 'Ejido');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 158
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Fernández Peña'),
    (@IdMun, 'Matriz'),
    (@IdMun, 'Montalbán'),
    (@IdMun, 'Acequias'),
    (@IdMun, 'Jají'),
    (@IdMun, 'La Mesa'),
    (@IdMun, 'San José del Sur');

-- Municipio #159: Caracciolo Parra Olmedo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Caracciolo Parra Olmedo', 'Tucaní');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 159
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tucaní'),
    (@IdMun, 'Florencio Ramírez');

-- Municipio #160: Cardenal Quintero
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Cardenal Quintero', 'Santo Domingo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 160
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santo Domingo'),
    (@IdMun, 'Las Piedras');

-- Municipio #161: Guaraque
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Guaraque', 'Guaraque');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 161
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guaraque'),
    (@IdMun, 'Mesa de Quintero'),
    (@IdMun, 'Río Negro');

-- Municipio #162: Julio César Salas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Julio César Salas', 'Arapuey');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 162
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Arapuey'),
    (@IdMun, 'Palmira');

-- Municipio #163: Justo Briceño
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Justo Briceño', 'Torondoy');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 163
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Cristóbal de Torondoy'),
    (@IdMun, 'Torondoy');

-- Municipio #164: Libertador
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Libertador', 'Mérida');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 164
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Antonio Spinetti Dini'),
    (@IdMun, 'Arias'),
    (@IdMun, 'Caracciolo Parra Pérez'),
    (@IdMun, 'Domingo Peña'),
    (@IdMun, 'El Llano'),
    (@IdMun, 'Gonzalo Picón Febres'),
    (@IdMun, 'Jacinto Plaza'),
    (@IdMun, 'Juan Rodríguez Suárez'),
    (@IdMun, 'Lasso de la Vega'),
    (@IdMun, 'Mariano Picón Salas'),
    (@IdMun, 'Milla'),
    (@IdMun, 'Osuna Rodríguez'),
    (@IdMun, 'Sagrario'),
    (@IdMun, 'El Morro'),
    (@IdMun, 'Los Nevados');

-- Municipio #165: Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Miranda', 'Timotes');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 165
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Andrés Eloy Blanco'),
    (@IdMun, 'La Venta'),
    (@IdMun, 'Piñango'),
    (@IdMun, 'Timotes');

-- Municipio #166: Obispo Ramos de Lora
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Obispo Ramos de Lora', 'Santa Elena de Arenales');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 166
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Eloy Paredes'),
    (@IdMun, 'San Rafael de Alcázar'),
    (@IdMun, 'Santa Elena de Arenales');

-- Municipio #167: Padre Noguera
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Padre Noguera', 'Santa María de Caparo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 167
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa María de Caparo');

-- Municipio #168: Pueblo Llano
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Pueblo Llano', 'Pueblo Llano');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 168
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Pueblo Llano');

-- Municipio #169: Rangel
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Rangel', 'Mucuchíes');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 169
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cacute'),
    (@IdMun, 'La Toma'),
    (@IdMun, 'Mucuchíes'),
    (@IdMun, 'Mucurubá'),
    (@IdMun, 'San Rafael');

-- Municipio #170: Rivas Dávila
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Rivas Dávila', 'Bailadores');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 170
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Gerónimo Maldonado'),
    (@IdMun, 'Bailadores');

-- Municipio #171: Santos Marquina
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Santos Marquina', 'Tabay');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 171
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tabay');

-- Municipio #172: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Sucre', 'Lagunillas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 172
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Chiguará'),
    (@IdMun, 'Estánquez'),
    (@IdMun, 'Lagunillas'),
    (@IdMun, 'La Trampa'),
    (@IdMun, 'Pueblo Nuevo del Sur'),
    (@IdMun, 'San Juan');

-- Municipio #173: Tovar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Tovar', 'Tovar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 173
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Amparo'),
    (@IdMun, 'El Llano'),
    (@IdMun, 'San Francisco'),
    (@IdMun, 'Tovar');

-- Municipio #174: Tulio Febres Cordero
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Tulio Febres Cordero', 'Nueva Bolivia');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 174
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Independencia'),
    (@IdMun, 'María de la Concepción Palacios Blanco'),
    (@IdMun, 'Nueva Bolivia'),
    (@IdMun, 'Santa Apolonia');

-- Municipio #175: Zea
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (13, 'Zea', 'Zea');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 175
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Caño El Tigre'),
    (@IdMun, 'Zea');

GO

-- Estado: Miranda (IdEstado=14)
DECLARE @IdMun INT;

-- Municipio #176: Acevedo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Acevedo', 'Caucagua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 176
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Aragüita'),
    (@IdMun, 'Arévalo González'),
    (@IdMun, 'Capaya'),
    (@IdMun, 'Caucagua'),
    (@IdMun, 'Panaquire'),
    (@IdMun, 'Ribas'),
    (@IdMun, 'El Café'),
    (@IdMun, 'Marizapa');

-- Municipio #177: Andrés Bello
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Andrés Bello', 'San José de Barlovento');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 177
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cumbo'),
    (@IdMun, 'San José de Barlovento');

-- Municipio #178: Baruta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Baruta', 'Baruta');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 178
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Cafetal'),
    (@IdMun, 'Las Minas'),
    (@IdMun, 'Nuestra Señora del Rosario');

-- Municipio #179: Brión
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Brión', 'Higuerote');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 179
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Higuerote'),
    (@IdMun, 'Curiepe'),
    (@IdMun, 'Tacarigua de Brión');

-- Municipio #180: Buroz
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Buroz', 'Mamporal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 180
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Mamporal');

-- Municipio #181: Carrizal
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Carrizal', 'Carrizal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 181
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Carrizal');

-- Municipio #182: Chacao
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Chacao', 'Chacao');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 182
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Chacao');

-- Municipio #183: Cristóbal Rojas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Cristóbal Rojas', 'Charallave');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 183
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Charallave'),
    (@IdMun, 'Las Brisas');

-- Municipio #184: El Hatillo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'El Hatillo', 'Santa Rosalía de Palermo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 184
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Hatillo');

-- Municipio #185: Guaicaipuro
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Guaicaipuro', 'Los Teques');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 185
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Altagracia de la Montaña'),
    (@IdMun, 'Cecilio Acosta'),
    (@IdMun, 'Los Teques'),
    (@IdMun, 'El Jarillo'),
    (@IdMun, 'San Pedro.'),
    (@IdMun, 'Tácata'),
    (@IdMun, 'Paracotos');

-- Municipio #186: Independencia
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Independencia', 'Santa Teresa del Tuy');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 186
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cartanal'),
    (@IdMun, 'Santa Teresa del Tuy');

-- Municipio #187: Lander
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Lander', 'Ocumare del Tuy');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 187
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'La Democracia'),
    (@IdMun, 'Ocumare del Tuy'),
    (@IdMun, 'Santa Bárbara');

-- Municipio #188: Los Salias
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Los Salias', 'San Antonio de los Altos');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 188
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Antonio de los Altos');

-- Municipio #189: Páez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Páez', 'Río Chico');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 189
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Río Chico'),
    (@IdMun, 'El Guapo'),
    (@IdMun, 'Tacarigua de la Laguna'),
    (@IdMun, 'Paparo'),
    (@IdMun, 'San Fernando del Guapo');

-- Municipio #190: Paz Castillo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Paz Castillo', 'Santa Lucía');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 190
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Lucía del Tuy');

-- Municipio #191: Pedro Gual
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Pedro Gual', 'Cúpira');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 191
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cúpira'),
    (@IdMun, 'Machurucuto');

-- Municipio #192: Plaza
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Plaza', 'Guarenas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 192
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guarenas');

-- Municipio #193: Simón Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Simón Bolívar', 'San Francisco de Yare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 193
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Antonio de Yare'),
    (@IdMun, 'San Francisco de Yare');

-- Municipio #194: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Sucre', 'Petare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 194
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Leoncio Martínez'),
    (@IdMun, 'Petare'),
    (@IdMun, 'Caucagüita'),
    (@IdMun, 'Filas de Mariche'),
    (@IdMun, 'La Dolorita');

-- Municipio #195: Urdaneta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Urdaneta', 'Cúa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 195
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cúa'),
    (@IdMun, 'Nueva Cúa');

-- Municipio #196: Zamora
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (14, 'Zamora', 'Guatire');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 196
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guatire'),
    (@IdMun, 'Bolívar');

GO

-- Estado: Monagas (IdEstado=15)
DECLARE @IdMun INT;

-- Municipio #197: Acosta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Acosta', 'San Antonio de Capayacuar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 197
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Antonio de Maturín'),
    (@IdMun, 'San Francisco de Maturín');

-- Municipio #198: Aguasay
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Aguasay', 'Aguasay');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 198
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Aguasay');

-- Municipio #199: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Bolívar', 'Caripito');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 199
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Caripito');

-- Municipio #200: Caripe
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Caripe', 'Caripe');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 200
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Guácharo'),
    (@IdMun, 'La Guanota'),
    (@IdMun, 'Sabana de Piedra'),
    (@IdMun, 'San Agustín'),
    (@IdMun, 'Teresen'),
    (@IdMun, 'Caripe');

-- Municipio #201: Cedeño
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Cedeño', 'Caicara de Maturín');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 201
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Areo'),
    (@IdMun, 'Capital Cedeño'),
    (@IdMun, 'San Félix de Cantalicio'),
    (@IdMun, 'Viento Fresco');

-- Municipio #202: Ezequiel Zamora
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Ezequiel Zamora', 'Punta de Mata');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 202
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Tejero'),
    (@IdMun, 'Punta de Mata');

-- Municipio #203: Libertador
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Libertador', 'Temblador');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 203
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Chaguaramas'),
    (@IdMun, 'Las Alhuacas'),
    (@IdMun, 'Tabasca'),
    (@IdMun, 'Temblador');

-- Municipio #204: Maturín
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Maturín', 'Maturín');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 204
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Alto de los Godos'),
    (@IdMun, 'Boquerón'),
    (@IdMun, 'Las Cocuizas'),
    (@IdMun, 'La Cruz'),
    (@IdMun, 'San Simón'),
    (@IdMun, 'El Corozo'),
    (@IdMun, 'El Furrial'),
    (@IdMun, 'Jusepín'),
    (@IdMun, 'La Pica'),
    (@IdMun, 'San Vicente');

-- Municipio #205: Piar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Piar', 'Aragua de Maturín');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 205
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Aparicio'),
    (@IdMun, 'Aragua de Maturín'),
    (@IdMun, 'Chaguamal'),
    (@IdMun, 'El Pinto'),
    (@IdMun, 'Guanaguana'),
    (@IdMun, 'La Toscana'),
    (@IdMun, 'Taguaya');

-- Municipio #206: Punceres
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Punceres', 'Quiriquire');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 206
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cachipo'),
    (@IdMun, 'Quiriquire');

-- Municipio #207: Santa Bárbara
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Santa Bárbara', 'Santa Bárbara');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 207
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Bárbara');

-- Municipio #208: Sotillo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Sotillo', 'Barrancas del Orinoco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 208
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Barrancas'),
    (@IdMun, 'Los Barrancos de Fajardo');

-- Municipio #209: Uracoa
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (15, 'Uracoa', 'Uracoa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 209
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Uracoa');

GO

-- Estado: Nueva Esparta (IdEstado=16)
DECLARE @IdMun INT;

-- Municipio #210: Antolín del Campo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Antolín del Campo', 'Paraguachí');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 210
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Antolín del Campo');

-- Municipio #211: Arismendi
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Arismendi', 'La Asunción');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 211
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Arismendi');

-- Municipio #212: Díaz
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Díaz', 'San Juan Bautista');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 212
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Juan Bautista'),
    (@IdMun, 'Zabala');

-- Municipio #213: García
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'García', 'El Valle');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 213
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'García'),
    (@IdMun, 'Francisco Fajardo');

-- Municipio #214: Gómez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Gómez', 'Santa Ana');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 214
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bolívar'),
    (@IdMun, 'Guevara'),
    (@IdMun, 'Cerro de Matasiete'),
    (@IdMun, 'Santa Ana'),
    (@IdMun, 'Sucre');

-- Municipio #215: Maneiro
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Maneiro', 'Pampatar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 215
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Aguirre'),
    (@IdMun, 'Maneiro');

-- Municipio #216: Marcano
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Marcano', 'Juan Griego');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 216
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Adrián'),
    (@IdMun, 'Juan Griego'),
    (@IdMun, 'Yaguaraparo');

-- Municipio #217: Mariño
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Mariño', 'Porlamar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 217
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Porlamar');

-- Municipio #218: Península de Macanao
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Península de Macanao', 'Boca de Río');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 218
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Francisco de Macanao'),
    (@IdMun, 'Boca de Río');

-- Municipio #219: Tubores
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Tubores', 'Punta de Piedras');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 219
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tubores'),
    (@IdMun, 'Los Barales');

-- Municipio #220: Villalba
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (16, 'Villalba', 'San Pedro de Coche');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 220
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Vicente Fuentes'),
    (@IdMun, 'Villalba');

GO

-- Estado: Portuguesa (IdEstado=17)
DECLARE @IdMun INT;

-- Municipio #221: Agua Blanca
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Agua Blanca', 'Agua Blanca');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 221
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Agua Blanca');

-- Municipio #222: Araure
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Araure', 'Araure');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 222
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Araure'),
    (@IdMun, 'Río Acarigua');

-- Municipio #223: Esteller
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Esteller', 'Píritu');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 223
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Píritu'),
    (@IdMun, 'Uveral');

-- Municipio #224: Guanare
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Guanare', 'Guanare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 224
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cordova'),
    (@IdMun, 'Guanare'),
    (@IdMun, 'San José de la Montaña'),
    (@IdMun, 'San Juan de Guanaguanare'),
    (@IdMun, 'Virgen de Coromoto');

-- Municipio #225: Guanarito
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Guanarito', 'Guanarito');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 225
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guanarito'),
    (@IdMun, 'Trinidad de la Capilla'),
    (@IdMun, 'Divina Pastora');

-- Municipio #226: Monseñor José Vicente de Unda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Monseñor José Vicente de Unda', 'Paraíso de Chabasquén');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 226
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Peña Blanca');

-- Municipio #227: Ospino
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Ospino', 'Ospino');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 227
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Aparición'),
    (@IdMun, 'La Estación'),
    (@IdMun, 'Ospino');

-- Municipio #228: Páez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Páez', 'Acarigua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 228
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Acarigua'),
    (@IdMun, 'Payara'),
    (@IdMun, 'Pimpinela'),
    (@IdMun, 'Ramón Peraza');

-- Municipio #229: Papelón
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Papelón', 'Papelón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 229
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Caño Delgadito'),
    (@IdMun, 'Papelón');

-- Municipio #230: San Genaro de Boconoíto
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'San Genaro de Boconoíto', 'Boconoíto');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 230
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Antolín Tovar Anquino'),
    (@IdMun, 'Boconoíto');

-- Municipio #231: San Rafael de Onoto
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'San Rafael de Onoto', 'San Rafael de Onoto');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 231
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Fé'),
    (@IdMun, 'San Rafael de Onoto'),
    (@IdMun, 'Thermo Morales');

-- Municipio #232: Santa Rosalía
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Santa Rosalía', 'El Playón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 232
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Florida'),
    (@IdMun, 'El Playón');

-- Municipio #233: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Sucre', 'Biscucuy');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 233
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Biscucuy'),
    (@IdMun, 'Concepción'),
    (@IdMun, 'San José de Saguaz'),
    (@IdMun, 'San Rafael de Palo Alzado'),
    (@IdMun, 'Uvencio Antonio Velásquez'),
    (@IdMun, 'Villa Rosa');

-- Municipio #234: Turén
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (17, 'Turén', 'Villa Bruzual');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 234
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Canelones'),
    (@IdMun, 'Santa Cruz'),
    (@IdMun, 'San Isidro Labrador');

GO

-- Estado: Sucre (IdEstado=18)
DECLARE @IdMun INT;

-- Municipio #235: Andrés Eloy Blanco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Andrés Eloy Blanco', 'Casanay');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 235
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Mariño'),
    (@IdMun, 'Rómulo Gallegos');

-- Municipio #236: Andrés Mata
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Andrés Mata', 'San José de Aerocuar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 236
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San José de Aerocuar'),
    (@IdMun, 'Tavera Acosta');

-- Municipio #237: Arismendi
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Arismendi', 'Río Caribe');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 237
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Río Caribe'),
    (@IdMun, 'Antonio José de Sucre'),
    (@IdMun, 'El Morro de Puerto Santo'),
    (@IdMun, 'Puerto Santo'),
    (@IdMun, 'San Juan de las Galdonas');

-- Municipio #238: Benítez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Benítez', 'El Pilar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 238
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Pilar'),
    (@IdMun, 'El Rincón'),
    (@IdMun, 'General Francisco Antonio Váquez'),
    (@IdMun, 'Guaraúnos'),
    (@IdMun, 'Tunapuicito'),
    (@IdMun, 'Unión');

-- Municipio #239: Bermúdez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Bermúdez', 'Carúpano');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 239
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Catalina'),
    (@IdMun, 'Santa Rosa'),
    (@IdMun, 'Santa Teresa'),
    (@IdMun, 'Bolívar'),
    (@IdMun, 'Maracapana');

-- Municipio #240: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Bolívar', 'Marigüitar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 240

-- Municipio #241: Cajigal
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Cajigal', 'Yaguaraparo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 241
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Libertad'),
    (@IdMun, 'El Paujil'),
    (@IdMun, 'Yaguaraparo');

-- Municipio #242: Cruz Salmerón Acosta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Cruz Salmerón Acosta', 'Araya');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 242
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cruz Salmerón Acosta'),
    (@IdMun, 'Chacopata'),
    (@IdMun, 'Manicuare');

-- Municipio #243: Libertador
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Libertador', 'Tunapuy');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 243
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Tunapuy'),
    (@IdMun, 'Campo Elías');

-- Municipio #244: Mariño
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Mariño', 'Irapa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 244
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Irapa'),
    (@IdMun, 'Campo Claro'),
    (@IdMun, 'Maraval'),
    (@IdMun, 'San Antonio de Irapa'),
    (@IdMun, 'Soro');

-- Municipio #245: Mejía
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Mejía', 'San Antonio del Golfo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 245
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Mejía');

-- Municipio #246: Montes
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Montes', 'Cumanacoa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 246
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cumanacoa'),
    (@IdMun, 'Arenas'),
    (@IdMun, 'Aricagua'),
    (@IdMun, 'Cocollar'),
    (@IdMun, 'San Fernando'),
    (@IdMun, 'San Lorenzo');

-- Municipio #247: Ribero
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Ribero', 'Cariaco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 247
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Villa Frontado (Muelle de Cariaco)'),
    (@IdMun, 'Catuaro'),
    (@IdMun, 'Rendón'),
    (@IdMun, 'San Cruz'),
    (@IdMun, 'Santa María');

-- Municipio #248: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Sucre', 'Cumaná');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 248
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Altagracia Cumaná'),
    (@IdMun, 'Santa Inés Cumaná'),
    (@IdMun, 'Valentín Valiente Cumaná'),
    (@IdMun, 'Ayacucho Cumaná'),
    (@IdMun, 'San Juan'),
    (@IdMun, 'Raúl Leoni'),
    (@IdMun, 'Gran Mariscal');

-- Municipio #249: Valdez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (18, 'Valdez', 'Güiria');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 249
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cristóbal Colón'),
    (@IdMun, 'Bideau'),
    (@IdMun, 'Punta de Piedras'),
    (@IdMun, 'Güiria');

GO

-- Estado: Táchira (IdEstado=19)
DECLARE @IdMun INT;

-- Municipio #250: Andrés Bello
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Andrés Bello', 'Cordero');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 250
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Andrés Bello');

-- Municipio #251: Antonio Rómulo Costa
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Antonio Rómulo Costa', 'Las Mesas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 251
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Antonio Rómulo Costa');

-- Municipio #252: Ayacucho
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Ayacucho', 'Colón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 252
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ayacucho'),
    (@IdMun, 'Rivas Berti'),
    (@IdMun, 'San Pedro del Río');

-- Municipio #253: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Bolívar', 'San Antonio del Táchira');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 253
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bolívar'),
    (@IdMun, 'Palotal'),
    (@IdMun, 'General Juan Vicente Gómez'),
    (@IdMun, 'Isaías Medina Angarita');

-- Municipio #254: Cárdenas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Cárdenas', 'Táriba');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 254
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cárdenas'),
    (@IdMun, 'Amenodoro Rangel Lamus'),
    (@IdMun, 'La Florida');

-- Municipio #255: Córdoba
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Córdoba', 'Santa Ana de Táchira');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 255
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Córdoba');

-- Municipio #256: Fernández Feo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Fernández Feo', 'San Rafael del Piñal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 256
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Fernández Feo'),
    (@IdMun, 'Alberto Adriani'),
    (@IdMun, 'Santo Domingo');

-- Municipio #257: Francisco de Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Francisco de Miranda', 'San José de Bolívar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 257
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Francisco de Miranda');

-- Municipio #258: García de Hevia
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'García de Hevia', 'La Fría');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 258
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'García de Hevia'),
    (@IdMun, 'Boca de Grita'),
    (@IdMun, 'José Antonio Páez');

-- Municipio #259: Guásimos
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Guásimos', 'Palmira');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 259
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Guásimos');

-- Municipio #260: Independencia
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Independencia', 'Capacho Nuevo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 260
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Independencia'),
    (@IdMun, 'Juan Germán Roscio'),
    (@IdMun, 'Román Cárdenas');

-- Municipio #261: Jáuregui
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Jáuregui', 'La Grita');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 261
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Jáuregui'),
    (@IdMun, 'Emilio Constantino Guerrero'),
    (@IdMun, 'Monseñor Miguel Antonio Salas');

-- Municipio #262: José María Vargas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'José María Vargas', 'El Cobre');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 262
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'José María Vargas');

-- Municipio #263: Junín
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Junín', 'Rubio');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 263
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Junín'),
    (@IdMun, 'La Petrólea'),
    (@IdMun, 'Quinimarí'),
    (@IdMun, 'Bramón');

-- Municipio #264: Libertad
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Libertad', 'Capacho Viejo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 264
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Libertad'),
    (@IdMun, 'Cipriano Castro'),
    (@IdMun, 'Manuel Felipe Rugeles');

-- Municipio #265: Libertador
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Libertador', 'Abejales');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 265
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Capital Libertador'),
    (@IdMun, 'Doradas'),
    (@IdMun, 'Emeterio Ochoa'),
    (@IdMun, 'San Joaquín de Navay');

-- Municipio #266: Lobatera
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Lobatera', 'Lobatera');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 266
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Lobatera'),
    (@IdMun, 'Constitución');

-- Municipio #267: Michelena
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Michelena', 'Michelena');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 267
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Michelena');

-- Municipio #268: Panamericano
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Panamericano', 'Coloncito');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 268
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Panamericano'),
    (@IdMun, 'La Palmita');

-- Municipio #269: Pedro María Ureña
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Pedro María Ureña', 'Ureña');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 269
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Pedro María Ureña'),
    (@IdMun, 'Nueva Arcadia');

-- Municipio #270: Rafael Urdaneta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Rafael Urdaneta', 'Delicias');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 270
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Delicias'),
    (@IdMun, 'Pecaya');

-- Municipio #271: Samuel Darío Maldonado
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Samuel Darío Maldonado', 'La Tendida');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 271
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Samuel Darío Maldonado'),
    (@IdMun, 'Boconó'),
    (@IdMun, 'Hernández');

-- Municipio #272: San Cristóbal
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'San Cristóbal', 'San Cristóbal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 272
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'La Concordia'),
    (@IdMun, 'San Juan Bautista'),
    (@IdMun, 'Pedro María Morantes'),
    (@IdMun, 'San Sebastián'),
    (@IdMun, 'Dr. Francisco Romero Lobo');

-- Municipio #273: Seboruco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Seboruco', 'Seboruco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 273
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Seboruco');

-- Municipio #274: Simón Rodríguez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Simón Rodríguez', 'San Simón');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 274
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Simón Rodríguez');

-- Municipio #275: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Sucre', 'Queniquea');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 275
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sucre'),
    (@IdMun, 'Eleazar López Contreras'),
    (@IdMun, 'San Pablo');

-- Municipio #276: Torbes
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Torbes', 'San Josecito');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 276
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San José Obrero'),
    (@IdMun, 'San Juan Eudes');

-- Municipio #277: Uribante
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'Uribante', 'Pregonero');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 277
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Uribante'),
    (@IdMun, 'Cárdenas'),
    (@IdMun, 'Juan Pablo Peñalosa'),
    (@IdMun, 'Potosí');

-- Municipio #278: San Judas Tadeo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (19, 'San Judas Tadeo', 'Umuquena');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 278
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Judas Tadeo');

GO

-- Estado: Trujillo (IdEstado=20)
DECLARE @IdMun INT;

-- Municipio #279: Andrés Bello
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Andrés Bello', 'Santa Isabel');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 279
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Araguaney'),
    (@IdMun, 'El Jaguito'),
    (@IdMun, 'La Esperanza'),
    (@IdMun, 'Santa Isabel');

-- Municipio #280: Boconó
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Boconó', 'Boconó');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 280
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Boconó'),
    (@IdMun, 'El Carmen'),
    (@IdMun, 'Mosquey'),
    (@IdMun, 'Ayacucho'),
    (@IdMun, 'Burbusay'),
    (@IdMun, 'General Ribas'),
    (@IdMun, 'Guaramacal'),
    (@IdMun, 'Vega de Guaramacal'),
    (@IdMun, 'Monseñor Jáuregui'),
    (@IdMun, 'Rafael Rangel'),
    (@IdMun, 'San Miguel'),
    (@IdMun, 'San José');

-- Municipio #281: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Bolívar', 'Sabana Grande');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 281
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sabana Grande'),
    (@IdMun, 'Cheregüé'),
    (@IdMun, 'Granados');

-- Municipio #282: Candelaria
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Candelaria', 'Chejendé');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 282
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Arnoldo Gabaldón'),
    (@IdMun, 'Bolivia'),
    (@IdMun, 'Carrillo'),
    (@IdMun, 'Cegarra'),
    (@IdMun, 'Chejendé'),
    (@IdMun, 'Manuel Salvador Ulloa'),
    (@IdMun, 'San José');

-- Municipio #283: Carache
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Carache', 'Carache');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 283
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Carache'),
    (@IdMun, 'La Concepción'),
    (@IdMun, 'Cuicas'),
    (@IdMun, 'Panamericana'),
    (@IdMun, 'Santa Cruz');

-- Municipio #284: Escuque
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Escuque', 'Escuque');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 284
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Escuque'),
    (@IdMun, 'La Unión (El Alto Escuque)'),
    (@IdMun, 'Santa Rita'),
    (@IdMun, 'Sabana Libre');

-- Municipio #285: José Felipe Márquez Cañizalez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'José Felipe Márquez Cañizalez', 'El Paradero');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 285
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Socorro'),
    (@IdMun, 'Los Caprichos'),
    (@IdMun, 'Antonio José de Sucre');

-- Municipio #286: Juan Vicente Campos Elías
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Juan Vicente Campos Elías', 'Campo Elías');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 286
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Campo Elías'),
    (@IdMun, 'Arnoldo Gabaldón');

-- Municipio #287: La Ceiba
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'La Ceiba', 'Santa Apolonia');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 287
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Apolonia'),
    (@IdMun, 'El Progreso'),
    (@IdMun, 'La Ceiba'),
    (@IdMun, 'Tres de Febrero');

-- Municipio #288: Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Miranda', 'El Dividive');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 288
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Dividive'),
    (@IdMun, 'Agua Santa'),
    (@IdMun, 'Agua Caliente'),
    (@IdMun, 'El Cenizo'),
    (@IdMun, 'Valerita');

-- Municipio #289: Monte Carmelo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Monte Carmelo', 'Monte Carmelo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 289
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Monte Carmelo'),
    (@IdMun, 'Buena Vista'),
    (@IdMun, 'Santa María del Horcón');

-- Municipio #290: Motatán
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Motatán', 'Motatán');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 290
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Motatán'),
    (@IdMun, 'El Baño'),
    (@IdMun, 'Jalisco');

-- Municipio #291: Pampán
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Pampán', 'Pampán');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 291
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Pampán'),
    (@IdMun, 'Flor de Patria'),
    (@IdMun, 'La Paz'),
    (@IdMun, 'Santa Ana');

-- Municipio #292: Pampanito
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Pampanito', 'Pampanito');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 292
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Pampanito'),
    (@IdMun, 'La Concepción'),
    (@IdMun, 'Pampanito II');

-- Municipio #293: Rafael Rangel
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Rafael Rangel', 'Betijoque');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 293
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Betijoque'),
    (@IdMun, 'José Gregorio Hernández'),
    (@IdMun, 'La Pueblita'),
    (@IdMun, 'Los Cedros');

-- Municipio #294: San Rafael de Carvajal
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'San Rafael de Carvajal', 'Carvajal');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 294
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Carvajal'),
    (@IdMun, 'Campo Alegre'),
    (@IdMun, 'Antonio Nicolás Briceño'),
    (@IdMun, 'José Leonardo Suárez');

-- Municipio #295: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Sucre', 'Sabana de Mendoza');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 295
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sabana de Mendoza'),
    (@IdMun, 'Junín'),
    (@IdMun, 'Valmore Rodríguez'),
    (@IdMun, 'El Paraíso');

-- Municipio #296: Trujillo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Trujillo', 'Trujillo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 296
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Andrés Linares'),
    (@IdMun, 'Chiquinquirá'),
    (@IdMun, 'Cristóbal Mendoza'),
    (@IdMun, 'Cruz Carrillo'),
    (@IdMun, 'Matriz'),
    (@IdMun, 'Monseñor Carrillo'),
    (@IdMun, 'Tres Esquinas');

-- Municipio #297: Urdaneta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Urdaneta', 'La Quebrada');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 297
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cabimbú'),
    (@IdMun, 'Jajó'),
    (@IdMun, 'La Mesa de Esnujaque'),
    (@IdMun, 'Santiago'),
    (@IdMun, 'Tuñame'),
    (@IdMun, 'La Quebrada');

-- Municipio #298: Valera
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (20, 'Valera', 'Valera');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 298
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Juan Ignacio Montilla'),
    (@IdMun, 'La Beatriz'),
    (@IdMun, 'La Puerta'),
    (@IdMun, 'Mendoza del Valle de Momboy'),
    (@IdMun, 'Mercedes Díaz'),
    (@IdMun, 'San Luis');

GO

-- Estado: Vargas (IdEstado=21)
DECLARE @IdMun INT;

-- Municipio #299: Vargas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (21, 'Vargas', 'Vargas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 299
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Caraballeda'),
    (@IdMun, 'Carayaca'),
    (@IdMun, 'Carlos Soublette'),
    (@IdMun, 'Caruao Chuspa'),
    (@IdMun, 'Catia La Mar'),
    (@IdMun, 'El Junko'),
    (@IdMun, 'La Guaira'),
    (@IdMun, 'Macuto'),
    (@IdMun, 'Maiquetía'),
    (@IdMun, 'Naiguatá'),
    (@IdMun, 'Urimare');

GO

-- Estado: Yaracuy (IdEstado=22)
DECLARE @IdMun INT;

-- Municipio #300: Arístides Bastidas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Arístides Bastidas', 'San Pablo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 300
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Arístides Bastidas');

-- Municipio #301: Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Bolívar', 'Aroa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 301
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bolívar');

-- Municipio #302: Bruzual
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Bruzual', 'Chivacoa');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 302
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Chivacoa'),
    (@IdMun, 'Campo Elías');

-- Municipio #303: Cocorote
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Cocorote', 'Cocorote');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 303
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Cocorote');

-- Municipio #304: Independencia
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Independencia', 'Independencia');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 304
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Independencia');

-- Municipio #305: José Antonio Páez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'José Antonio Páez', 'Sabana de Parra');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 305
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'José Antonio Páez');

-- Municipio #306: La Trinidad
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'La Trinidad', 'Boraure');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 306
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'La Trinidad');

-- Municipio #307: Manuel Monge
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Manuel Monge', 'Yumare');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 307
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Manuel Monge');

-- Municipio #308: Nirgua
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Nirgua', 'Nirgua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 308
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Salóm'),
    (@IdMun, 'Temerla'),
    (@IdMun, 'Nirgua');

-- Municipio #309: Peña
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Peña', 'Yaritagua');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 309
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Andrés'),
    (@IdMun, 'Yaritagua');

-- Municipio #310: San Felipe
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'San Felipe', 'San Felipe');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 310
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Javier'),
    (@IdMun, 'Albarico'),
    (@IdMun, 'San Felipe');

-- Municipio #311: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Sucre', 'Guama');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 311
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sucre');

-- Municipio #312: Urachiche
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Urachiche', 'Urachiche');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 312
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Urachiche');

-- Municipio #313: Veroes
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (22, 'Veroes', 'Farriar');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 313
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'El Guayabo'),
    (@IdMun, 'Farriar');

GO

-- Estado: Zulia (IdEstado=23)
DECLARE @IdMun INT;

-- Municipio #314: Almirante Padilla
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Almirante Padilla', 'El Toro');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 314
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Isla de Toas'),
    (@IdMun, 'Monagas');

-- Municipio #315: Baralt
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Baralt', 'San Timoteo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 315
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'General Urdaneta'),
    (@IdMun, 'Libertador'),
    (@IdMun, 'Marcelino Briceño'),
    (@IdMun, 'Pueblo Nuevo'),
    (@IdMun, 'Manuel Guanipa Matos');

-- Municipio #316: Cabimas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Cabimas', 'Cabimas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 316
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Ambrosio'),
    (@IdMun, 'Carmen Herrera'),
    (@IdMun, 'La Rosa'),
    (@IdMun, 'Germán Ríos Linares'),
    (@IdMun, 'San Benito'),
    (@IdMun, 'Rómulo Betancourt'),
    (@IdMun, 'Jorge Hernández'),
    (@IdMun, 'Punta Gorda'),
    (@IdMun, 'Arístides Calvani');

-- Municipio #317: Catatumbo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Catatumbo', 'Encontrados');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 317
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Encontrados'),
    (@IdMun, 'Udón Pérez');

-- Municipio #318: Colón
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Colón', 'San Carlos del Zulia');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 318
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Moralito'),
    (@IdMun, 'San Carlos del Zulia'),
    (@IdMun, 'Santa Cruz del Zulia'),
    (@IdMun, 'Santa Bárbara'),
    (@IdMun, 'Urribarrí');

-- Municipio #319: Francisco Javier Pulgar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Francisco Javier Pulgar', 'Pueblo Nuevo - El Chivo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 319
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Carlos Quevedo'),
    (@IdMun, 'Francisco Javier Pulgar'),
    (@IdMun, 'Simón Rodríguez'),
    (@IdMun, 'Guamo-Gavilanes');

-- Municipio #320: Páez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Páez', 'Sinamaica');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 320
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Sinamaica'),
    (@IdMun, 'Alta Guajira'),
    (@IdMun, 'Elías Sánchez Rubio'),
    (@IdMun, 'Guajira');

-- Municipio #321: Jesús Enrique Lossada
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Jesús Enrique Lossada', 'La Concepción');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 321
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'La Concepción'),
    (@IdMun, 'San José'),
    (@IdMun, 'Mariano Parra León'),
    (@IdMun, 'José Ramón Yépez');

-- Municipio #322: Jesús María Semprún
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Jesús María Semprún', 'Casigua - El Cubo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 322
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Jesús María Semprún'),
    (@IdMun, 'Barí');

-- Municipio #323: La Cañada de Urdaneta
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'La Cañada de Urdaneta', 'La Concepción');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 323
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Concepción'),
    (@IdMun, 'Andrés Bello'),
    (@IdMun, 'Chiquinquirá'),
    (@IdMun, 'El Carmelo'),
    (@IdMun, 'Potreritos');

-- Municipio #324: Lagunillas
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Lagunillas', 'Ciudad Ojeda');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 324
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Libertad'),
    (@IdMun, 'Alonso de Ojeda'),
    (@IdMun, 'Venezuela'),
    (@IdMun, 'Eleazar López Contreras'),
    (@IdMun, 'Campo Lara');

-- Municipio #325: Machiques de Perijá
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Machiques de Perijá', 'Machiques');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 325
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bartolomé de las Casas'),
    (@IdMun, 'Libertad'),
    (@IdMun, 'Río Negro'),
    (@IdMun, 'San José de Perijá');

-- Municipio #326: Mara
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Mara', 'San Rafael de El Moján');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 326
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Rafael'),
    (@IdMun, 'La Sierrita'),
    (@IdMun, 'Las Parcelas'),
    (@IdMun, 'Luis de Vicente'),
    (@IdMun, 'Monseñor Marcos Sergio Godoy'),
    (@IdMun, 'Ricaurte'),
    (@IdMun, 'Tamare');

-- Municipio #327: Maracaibo
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Maracaibo', 'Maracaibo');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 327
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Antonio Borjas Romero'),
    (@IdMun, 'Bolívar'),
    (@IdMun, 'Cacique Mara'),
    (@IdMun, 'Carracciolo Parra Pérez'),
    (@IdMun, 'Cecilio Acosta'),
    (@IdMun, 'Cristo de Aranza'),
    (@IdMun, 'Coquivacoa'),
    (@IdMun, 'Chiquinquirá'),
    (@IdMun, 'Francisco Eugenio Bustamante'),
    (@IdMun, 'Idelfonzo Vásquez'),
    (@IdMun, 'Juana de Ávila'),
    (@IdMun, 'Luis Hurtado Higuera'),
    (@IdMun, 'Manuel Dagnino'),
    (@IdMun, 'Olegario Villalobos.'),
    (@IdMun, 'Raúl Leoni'),
    (@IdMun, 'Santa Lucía'),
    (@IdMun, 'Venancio Pulgar'),
    (@IdMun, 'San Isidro');

-- Municipio #328: Miranda
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Miranda', 'Los Puertos de Altagracia');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 328
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Altagracia'),
    (@IdMun, 'Faría'),
    (@IdMun, 'Ana María Campos'),
    (@IdMun, 'San Antonio'),
    (@IdMun, 'San José');

-- Municipio #329: Rosario de Perijá
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Rosario de Perijá', 'La Villa del Rosario');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 329
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Donaldo García'),
    (@IdMun, 'El Rosario'),
    (@IdMun, 'Sixto Zambrano');

-- Municipio #330: San Francisco
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'San Francisco', 'San Francisco');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 330
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'San Francisco'),
    (@IdMun, 'El Bajo'),
    (@IdMun, 'Domitila Flores'),
    (@IdMun, 'Francisco Ochoa'),
    (@IdMun, 'Los Cortijos'),
    (@IdMun, 'Marcial Hernández');

-- Municipio #331: Santa Rita
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Santa Rita', 'Santa Rita');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 331
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Santa Rita'),
    (@IdMun, 'El Mene'),
    (@IdMun, 'Pedro Lucas Urribarrí'),
    (@IdMun, 'José Cenobio Urribarrí');

-- Municipio #332: Simón Bolívar
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Simón Bolívar', 'Tía Juana');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 332
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Rafael Maria Baralt'),
    (@IdMun, 'Manuel Manrique'),
    (@IdMun, 'Rafael Urdaneta');

-- Municipio #333: Sucre
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Sucre', 'Bobures');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 333
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Bobures'),
    (@IdMun, 'Gibraltar'),
    (@IdMun, 'Heras'),
    (@IdMun, 'Monseñor Arturo Álvarez'),
    (@IdMun, 'Rómulo Gallegos'),
    (@IdMun, 'El Batey');

-- Municipio #334: Valmore Rodríguez
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (23, 'Valmore Rodríguez', 'Bachaquero');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 334
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, 'Rafael Urdaneta'),
    (@IdMun, 'La Victoria'),
    (@IdMun, 'Raúl Cuenca');

GO

-- Estado: Distrito Capital (IdEstado=24)
DECLARE @IdMun INT;

-- Municipio #335: Libertador
INSERT INTO dbo.Municipios (IdEstado, Nombre, Capital)
VALUES (24, 'Libertador', 'Caracas');
SET @IdMun = SCOPE_IDENTITY(); -- @IdMun = 335
INSERT INTO dbo.Parroquias (IdMunicipio, Nombre) VALUES
    (@IdMun, '23 de enero'),
    (@IdMun, 'Altagracia'),
    (@IdMun, 'Antímano'),
    (@IdMun, 'Caricuao'),
    (@IdMun, 'Catedral'),
    (@IdMun, 'Coche'),
    (@IdMun, 'El Junquito'),
    (@IdMun, 'El Paraíso'),
    (@IdMun, 'El Recreo'),
    (@IdMun, 'El Valle'),
    (@IdMun, 'Candelaria'),
    (@IdMun, 'La Pastora'),
    (@IdMun, 'La Vega'),
    (@IdMun, 'Macarao'),
    (@IdMun, 'San Agustín'),
    (@IdMun, 'San Bernardino'),
    (@IdMun, 'San José'),
    (@IdMun, 'San Juan'),
    (@IdMun, 'San Pedro'),
    (@IdMun, 'Santa Rosalía'),
    (@IdMun, 'Santa Teresa'),
    (@IdMun, 'Sucre (Catia)');

GO

-- 3.3 Ciudades
-- IdMunicipio pre-calculado: coincidencia por capital o nombre del municipio
-- (NULL = ciudad sin municipio asignado)

-- Ciudades de Amazonas (IdEstado=1)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (1, 6, 'Maroa'),
    (1, 3, 'Puerto Ayacucho'),
    (1, 2, 'San Fernando de Atabapo');

-- Ciudades de Anzoátegui (IdEstado=2)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (2, 8, 'Anaco'),
    (2, 9, 'Aragua de Barcelona'),
    (2, 10, 'Barcelona'),
    (2, 25, 'Boca de Uchire'),
    (2, 15, 'Cantaura'),
    (2, 11, 'Clarines'),
    (2, 20, 'El Chaparro'),
    (2, NULL, 'El Pao Anzoátegui'),
    (2, 27, 'El Tigre'),
    (2, NULL, 'El Tigrito'),
    (2, NULL, 'Guanape'),
    (2, 17, 'Guanta'),
    (2, 14, 'Lechería'),
    (2, 12, 'Onoto'),
    (2, 21, 'Pariaguán'),
    (2, 24, 'Píritu'),
    (2, 28, 'Puerto La Cruz'),
    (2, 23, 'Puerto Píritu'),
    (2, NULL, 'Sabana de Uchire'),
    (2, NULL, 'San Mateo Anzoátegui'),
    (2, NULL, 'San Pablo Anzoátegui'),
    (2, NULL, 'San Tomé'),
    (2, NULL, 'Santa Ana de Anzoátegui'),
    (2, NULL, 'Santa Fe Anzoátegui'),
    (2, NULL, 'Santa Rosa'),
    (2, 18, 'Soledad'),
    (2, NULL, 'Urica'),
    (2, 13, 'Valle de Guanape');

-- Ciudades de Apure (IdEstado=3)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (3, 29, 'Achaguas'),
    (3, 30, 'Biruaca'),
    (3, 31, 'Bruzual'),
    (3, NULL, 'El Amparo'),
    (3, NULL, 'El Nula'),
    (3, 34, 'Elorza'),
    (3, 32, 'Guasdualito'),
    (3, NULL, 'Mantecal'),
    (3, NULL, 'Puerto Páez'),
    (3, 35, 'San Fernando de Apure'),
    (3, 33, 'San Juan de Payara');

-- Ciudades de Aragua (IdEstado=4)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (4, 52, 'Barbacoas'),
    (4, 50, 'Cagua'),
    (4, 37, 'Camatagua'),
    (4, NULL, 'Choroní'),
    (4, 51, 'Colonia Tovar'),
    (4, 42, 'El Consejo'),
    (4, 41, 'La Victoria'),
    (4, 49, 'Las Tejerías'),
    (4, NULL, 'Magdaleno'),
    (4, 39, 'Maracay'),
    (4, 45, 'Ocumare de La Costa'),
    (4, 43, 'Palo Negro'),
    (4, 46, 'San Casimiro'),
    (4, 36, 'San Mateo'),
    (4, 47, 'San Sebastián'),
    (4, 40, 'Santa Cruz de Aragua'),
    (4, NULL, 'Tocorón'),
    (4, 48, 'Turmero'),
    (4, 53, 'Villa de Cura'),
    (4, NULL, 'Zuata');

-- Ciudades de Barinas (IdEstado=5)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (5, 58, 'Barinas'),
    (5, 59, 'Barinitas'),
    (5, 60, 'Barrancas'),
    (5, NULL, 'Calderas'),
    (5, NULL, 'Capitanejo'),
    (5, 63, 'Ciudad Bolivia'),
    (5, 55, 'El Cantón'),
    (5, NULL, 'Las Veguitas'),
    (5, NULL, 'Libertad de Barinas'),
    (5, 54, 'Sabaneta'),
    (5, NULL, 'Santa Bárbara de Barinas'),
    (5, 56, 'Socopó');

-- Ciudades de Bolívar (IdEstado=6)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (6, 68, 'Caicara del Orinoco'),
    (6, NULL, 'Canaima'),
    (6, 71, 'Ciudad Bolívar'),
    (6, NULL, 'Ciudad Piar'),
    (6, 69, 'El Callao'),
    (6, 74, 'El Dorado'),
    (6, NULL, 'El Manteco'),
    (6, 76, 'El Palmar'),
    (6, NULL, 'El Pao'),
    (6, 73, 'Guasipati'),
    (6, NULL, 'Guri'),
    (6, NULL, 'La Paragua'),
    (6, NULL, 'Matanzas'),
    (6, NULL, 'Puerto Ordaz'),
    (6, NULL, 'San Félix'),
    (6, 70, 'Santa Elena de Uairén'),
    (6, NULL, 'Tumeremo'),
    (6, NULL, 'Unare'),
    (6, 72, 'Upata');

-- Ciudades de Carabobo (IdEstado=7)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (7, 77, 'Bejuma'),
    (7, NULL, 'Belén'),
    (7, NULL, 'Campo de Carabobo'),
    (7, NULL, 'Canoabo'),
    (7, NULL, 'Central Tacarigua'),
    (7, NULL, 'Chirgua'),
    (7, NULL, 'Ciudad Alianza'),
    (7, NULL, 'El Palito'),
    (7, 80, 'Guacara'),
    (7, NULL, 'Guigue'),
    (7, NULL, 'Las Trincheras'),
    (7, 83, 'Los Guayos'),
    (7, 79, 'Mariara'),
    (7, 84, 'Miranda'),
    (7, 85, 'Montalbán'),
    (7, 81, 'Morón'),
    (7, 86, 'Naguanagua'),
    (7, 87, 'Puerto Cabello'),
    (7, 89, 'San Joaquín'),
    (7, 82, 'Tocuyito'),
    (7, NULL, 'Urama'),
    (7, 90, 'Valencia'),
    (7, NULL, 'Vigirimita');

-- Ciudades de Cojedes (IdEstado=8)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (8, NULL, 'Aguirre'),
    (8, NULL, 'Apartaderos Cojedes'),
    (8, NULL, 'Arismendi'),
    (8, NULL, 'Camuriquito'),
    (8, 93, 'El Baúl'),
    (8, NULL, 'El Limón'),
    (8, NULL, 'El Pao Cojedes'),
    (8, NULL, 'El Socorro'),
    (8, NULL, 'La Aguadita'),
    (8, 97, 'Las Vegas'),
    (8, NULL, 'Libertad de Cojedes'),
    (8, NULL, 'Mapuey'),
    (8, NULL, 'Piñedo'),
    (8, NULL, 'Samancito'),
    (8, 98, 'San Carlos'),
    (8, NULL, 'Sucre'),
    (8, 99, 'Tinaco'),
    (8, 92, 'Tinaquillo'),
    (8, NULL, 'Vallecito');

-- Ciudades de Delta Amacuro (IdEstado=9)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (9, 103, 'Tucupita');

-- Ciudades de Falcón (IdEstado=10)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (10, NULL, 'Adícora'),
    (10, NULL, 'Boca de Aroa'),
    (10, 120, 'Cabure'),
    (10, NULL, 'Capadare'),
    (10, 106, 'Capatárida'),
    (10, 118, 'Chichiriviche'),
    (10, 112, 'Churuguara'),
    (10, NULL, 'Coro'),
    (10, NULL, 'Cumarebo'),
    (10, 109, 'Dabajuro'),
    (10, NULL, 'Judibana'),
    (10, 123, 'La Cruz de Taratara'),
    (10, 108, 'La Vela de Coro'),
    (10, 114, 'Los Taques'),
    (10, NULL, 'Maparari'),
    (10, 116, 'Mene de Mauroa'),
    (10, 122, 'Mirimire'),
    (10, 110, 'Pedregal'),
    (10, NULL, 'Píritu Falcón'),
    (10, NULL, 'Pueblo Nuevo Falcón'),
    (10, 128, 'Puerto Cumarebo'),
    (10, NULL, 'Punta Cardón'),
    (10, 107, 'Punto Fijo'),
    (10, 104, 'San Juan de Los Cayos'),
    (10, 105, 'San Luis'),
    (10, NULL, 'Santa Ana Falcón'),
    (10, 126, 'Santa Cruz De Bucaral'),
    (10, NULL, 'Tocopero'),
    (10, NULL, 'Tocuyo de La Costa'),
    (10, 124, 'Tucacas'),
    (10, 115, 'Yaracal');

-- Ciudades de Guárico (IdEstado=11)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (11, 136, 'Altagracia de Orituco'),
    (11, NULL, 'Cabruta'),
    (11, 135, 'Calabozo'),
    (11, 129, 'Camaguán'),
    (11, NULL, 'Chaguaramas Guárico'),
    (11, 131, 'El Socorro'),
    (11, 134, 'El Sombrero'),
    (11, NULL, 'Las Mercedes de Los Llanos'),
    (11, NULL, 'Lezama'),
    (11, NULL, 'Onoto'),
    (11, NULL, 'Ortíz'),
    (11, 141, 'San José de Guaribe'),
    (11, 139, 'San Juan de Los Morros'),
    (11, NULL, 'San Rafael de Laya'),
    (11, 142, 'Santa María de Ipire'),
    (11, 138, 'Tucupido'),
    (11, 132, 'Valle de La Pascua'),
    (11, 143, 'Zaraza');

-- Ciudades de Lara (IdEstado=12)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (12, NULL, 'Aguada Grande'),
    (12, NULL, 'Atarigua'),
    (12, 146, 'Barquisimeto'),
    (12, NULL, 'Bobare'),
    (12, 149, 'Cabudare'),
    (12, 151, 'Carora'),
    (12, NULL, 'Cubiro'),
    (12, NULL, 'Cují'),
    (12, 145, 'Duaca'),
    (12, NULL, 'El Manzano'),
    (12, 148, 'El Tocuyo'),
    (12, NULL, 'Guaríco'),
    (12, NULL, 'Humocaro Alto'),
    (12, NULL, 'Humocaro Bajo'),
    (12, NULL, 'La Miel'),
    (12, NULL, 'Moroturo'),
    (12, NULL, 'Quíbor'),
    (12, NULL, 'Río Claro'),
    (12, 144, 'Sanare'),
    (12, NULL, 'Santa Inés'),
    (12, 150, 'Sarare'),
    (12, 152, 'Siquisique'),
    (12, NULL, 'Tintorero');

-- Ciudades de Mérida (IdEstado=13)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (13, NULL, 'Apartaderos Mérida'),
    (13, 162, 'Arapuey'),
    (13, 170, 'Bailadores'),
    (13, NULL, 'Caja Seca'),
    (13, 157, 'Canaguá'),
    (13, NULL, 'Chachopo'),
    (13, NULL, 'Chiguara'),
    (13, 158, 'Ejido'),
    (13, 153, 'El Vigía'),
    (13, 154, 'La Azulita'),
    (13, NULL, 'La Playa'),
    (13, NULL, 'Lagunillas Mérida'),
    (13, 164, 'Mérida'),
    (13, NULL, 'Mesa de Bolívar'),
    (13, 169, 'Mucuchíes'),
    (13, NULL, 'Mucujepe'),
    (13, NULL, 'Mucuruba'),
    (13, 174, 'Nueva Bolivia'),
    (13, NULL, 'Palmarito'),
    (13, 168, 'Pueblo Llano'),
    (13, 155, 'Santa Cruz de Mora'),
    (13, 166, 'Santa Elena de Arenales'),
    (13, 160, 'Santo Domingo'),
    (13, NULL, 'Tabáy'),
    (13, 165, 'Timotes'),
    (13, 163, 'Torondoy'),
    (13, 173, 'Tovar'),
    (13, NULL, 'Tucani'),
    (13, 175, 'Zea');

-- Ciudades de Miranda (IdEstado=14)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (14, NULL, 'Araguita'),
    (14, 181, 'Carrizal'),
    (14, 176, 'Caucagua'),
    (14, NULL, 'Chaguaramas Miranda'),
    (14, 183, 'Charallave'),
    (14, NULL, 'Chirimena'),
    (14, NULL, 'Chuspa'),
    (14, 195, 'Cúa'),
    (14, NULL, 'Cupira'),
    (14, NULL, 'Curiepe'),
    (14, NULL, 'El Guapo'),
    (14, NULL, 'El Jarillo'),
    (14, NULL, 'Filas de Mariche'),
    (14, 192, 'Guarenas'),
    (14, 196, 'Guatire'),
    (14, 179, 'Higuerote'),
    (14, NULL, 'Los Anaucos'),
    (14, 185, 'Los Teques'),
    (14, 187, 'Ocumare del Tuy'),
    (14, NULL, 'Panaquire'),
    (14, NULL, 'Paracotos'),
    (14, 189, 'Río Chico'),
    (14, 188, 'San Antonio de Los Altos'),
    (14, NULL, 'San Diego de Los Altos'),
    (14, NULL, 'San Fernando del Guapo'),
    (14, 193, 'San Francisco de Yare'),
    (14, NULL, 'San José de Los Altos'),
    (14, NULL, 'San José de Río Chico'),
    (14, NULL, 'San Pedro de Los Altos'),
    (14, 190, 'Santa Lucía'),
    (14, NULL, 'Santa Teresa'),
    (14, NULL, 'Tacarigua de La Laguna'),
    (14, NULL, 'Tacarigua de Mamporal'),
    (14, NULL, 'Tácata'),
    (14, NULL, 'Turumo');

-- Ciudades de Monagas (IdEstado=15)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (15, 198, 'Aguasay'),
    (15, 205, 'Aragua de Maturín'),
    (15, 208, 'Barrancas del Orinoco'),
    (15, 201, 'Caicara de Maturín'),
    (15, 200, 'Caripe'),
    (15, 199, 'Caripito'),
    (15, NULL, 'Chaguaramal'),
    (15, NULL, 'Chaguaramas Monagas'),
    (15, NULL, 'El Furrial'),
    (15, NULL, 'El Tejero'),
    (15, NULL, 'Jusepín'),
    (15, NULL, 'La Toscana'),
    (15, 204, 'Maturín'),
    (15, NULL, 'Miraflores'),
    (15, 202, 'Punta de Mata'),
    (15, 206, 'Quiriquire'),
    (15, NULL, 'San Antonio de Maturín'),
    (15, NULL, 'San Vicente Monagas'),
    (15, 207, 'Santa Bárbara'),
    (15, 203, 'Temblador'),
    (15, NULL, 'Teresen'),
    (15, 209, 'Uracoa');

-- Ciudades de Nueva Esparta (IdEstado=16)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (16, NULL, 'Altagracia'),
    (16, NULL, 'Boca de Pozo'),
    (16, 218, 'Boca de Río'),
    (16, NULL, 'El Espinal'),
    (16, NULL, 'El Valle del Espíritu Santo'),
    (16, NULL, 'El Yaque'),
    (16, NULL, 'Juangriego'),
    (16, 211, 'La Asunción'),
    (16, NULL, 'La Guardia'),
    (16, 215, 'Pampatar'),
    (16, 217, 'Porlamar'),
    (16, NULL, 'Puerto Fermín'),
    (16, 219, 'Punta de Piedras'),
    (16, NULL, 'San Francisco de Macanao'),
    (16, 212, 'San Juan Bautista'),
    (16, 220, 'San Pedro de Coche'),
    (16, NULL, 'Santa Ana de Nueva Esparta'),
    (16, NULL, 'Villa Rosa');

-- Ciudades de Portuguesa (IdEstado=17)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (17, 228, 'Acarigua'),
    (17, 221, 'Agua Blanca'),
    (17, 222, 'Araure'),
    (17, 233, 'Biscucuy'),
    (17, NULL, 'Boconoito'),
    (17, NULL, 'Campo Elías'),
    (17, NULL, 'Chabasquén'),
    (17, 224, 'Guanare'),
    (17, 225, 'Guanarito'),
    (17, NULL, 'La Aparición'),
    (17, NULL, 'La Misión'),
    (17, NULL, 'Mesa de Cavacas'),
    (17, 227, 'Ospino'),
    (17, 229, 'Papelón'),
    (17, NULL, 'Payara'),
    (17, NULL, 'Pimpinela'),
    (17, NULL, 'Píritu de Portuguesa'),
    (17, 231, 'San Rafael de Onoto'),
    (17, 232, 'Santa Rosalía'),
    (17, 234, 'Turén');

-- Ciudades de Sucre (IdEstado=18)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (18, NULL, 'Altos de Sucre'),
    (18, 242, 'Araya'),
    (18, 247, 'Cariaco'),
    (18, 239, 'Carúpano'),
    (18, 235, 'Casanay'),
    (18, 248, 'Cumaná'),
    (18, 246, 'Cumanacoa'),
    (18, NULL, 'El Morro Puerto Santo'),
    (18, 238, 'El Pilar'),
    (18, NULL, 'El Poblado'),
    (18, NULL, 'Guaca'),
    (18, NULL, 'Guiria'),
    (18, 244, 'Irapa'),
    (18, NULL, 'Manicuare'),
    (18, NULL, 'Mariguitar'),
    (18, 237, 'Río Caribe'),
    (18, 245, 'San Antonio del Golfo'),
    (18, 236, 'San José de Aerocuar'),
    (18, NULL, 'San Vicente de Sucre'),
    (18, NULL, 'Santa Fe de Sucre'),
    (18, 243, 'Tunapuy'),
    (18, 241, 'Yaguaraparo'),
    (18, NULL, 'Yoco');

-- Ciudades de Táchira (IdEstado=19)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (19, 265, 'Abejales'),
    (19, NULL, 'Borota'),
    (19, NULL, 'Bramon'),
    (19, NULL, 'Capacho'),
    (19, 252, 'Colón'),
    (19, 268, 'Coloncito'),
    (19, 250, 'Cordero'),
    (19, 262, 'El Cobre'),
    (19, NULL, 'El Pinal'),
    (19, 260, 'Independencia'),
    (19, 258, 'La Fría'),
    (19, 261, 'La Grita'),
    (19, NULL, 'La Pedrera'),
    (19, 271, 'La Tendida'),
    (19, NULL, 'Las Delicias'),
    (19, NULL, 'Las Hernández'),
    (19, 266, 'Lobatera'),
    (19, 267, 'Michelena'),
    (19, 259, 'Palmira'),
    (19, 277, 'Pregonero'),
    (19, 275, 'Queniquea'),
    (19, 263, 'Rubio'),
    (19, NULL, 'San Antonio del Tachira'),
    (19, NULL, 'San Cristobal'),
    (19, 257, 'San José de Bolívar'),
    (19, 276, 'San Josecito'),
    (19, NULL, 'San Pedro del Río'),
    (19, NULL, 'Santa Ana Táchira'),
    (19, 273, 'Seboruco'),
    (19, 254, 'Táriba'),
    (19, 278, 'Umuquena');

-- Ciudades de Trujillo (IdEstado=20)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (20, NULL, 'Batatal'),
    (20, 293, 'Betijoque'),
    (20, 280, 'Boconó'),
    (20, 283, 'Carache'),
    (20, NULL, 'Chejende'),
    (20, NULL, 'Cuicas'),
    (20, 288, 'El Dividive'),
    (20, NULL, 'El Jaguito'),
    (20, 284, 'Escuque'),
    (20, NULL, 'Isnotú'),
    (20, NULL, 'Jajó'),
    (20, 287, 'La Ceiba'),
    (20, NULL, 'La Concepción de Trujllo'),
    (20, NULL, 'La Mesa de Esnujaque'),
    (20, NULL, 'La Puerta'),
    (20, 297, 'La Quebrada'),
    (20, NULL, 'Mendoza Fría'),
    (20, NULL, 'Meseta de Chimpire'),
    (20, NULL, 'Monay'),
    (20, 290, 'Motatán'),
    (20, 291, 'Pampán'),
    (20, 292, 'Pampanito'),
    (20, 295, 'Sabana de Mendoza'),
    (20, NULL, 'San Lázaro'),
    (20, NULL, 'Santa Ana de Trujillo'),
    (20, NULL, 'Tostós'),
    (20, 296, 'Trujillo'),
    (20, 298, 'Valera');

-- Ciudades de Vargas (IdEstado=21)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (21, NULL, 'Carayaca'),
    (21, NULL, 'Litoral');

-- Ciudades de Yaracuy (IdEstado=22)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (22, 301, 'Aroa'),
    (22, 306, 'Boraure'),
    (22, NULL, 'Campo Elías de Yaracuy'),
    (22, 302, 'Chivacoa'),
    (22, 303, 'Cocorote'),
    (22, 313, 'Farriar'),
    (22, 311, 'Guama'),
    (22, NULL, 'Marín'),
    (22, 308, 'Nirgua'),
    (22, 305, 'Sabana de Parra'),
    (22, NULL, 'Salom'),
    (22, 310, 'San Felipe'),
    (22, NULL, 'San Pablo de Yaracuy'),
    (22, 312, 'Urachiche'),
    (22, 309, 'Yaritagua'),
    (22, 307, 'Yumare');

-- Ciudades de Zulia (IdEstado=23)
INSERT INTO dbo.Ciudades (IdEstado, IdMunicipio, Nombre) VALUES
    (23, 334, 'Bachaquero'),
    (23, 333, 'Bobures'),
    (23, 316, 'Cabimas'),
    (23, NULL, 'Campo Concepción'),
    (23, NULL, 'Campo Mara'),
    (23, NULL, 'Campo Rojo'),
    (23, NULL, 'Carrasquero'),
    (23, NULL, 'Casigua'),
    (23, NULL, 'Chiquinquirá'),
    (23, 324, 'Ciudad Ojeda'),
    (23, NULL, 'El Batey'),
    (23, NULL, 'El Carmelo'),
    (23, NULL, 'El Chivo'),
    (23, NULL, 'El Guayabo'),
    (23, NULL, 'El Mene'),
    (23, NULL, 'El Venado'),
    (23, 317, 'Encontrados'),
    (23, NULL, 'Gibraltar'),
    (23, NULL, 'Isla de Toas'),
    (23, 323, 'La Concepción'),
    (23, NULL, 'La Paz'),
    (23, NULL, 'La Sierrita'),
    (23, 324, 'Lagunillas'),
    (23, NULL, 'Las Piedras'),
    (23, NULL, 'Los Cortijos'),
    (23, 325, 'Machiques'),
    (23, 327, 'Maracaibo'),
    (23, NULL, 'Mene Grande'),
    (23, NULL, 'Palmarejo'),
    (23, NULL, 'Paraguaipoa'),
    (23, NULL, 'Potrerito'),
    (23, NULL, 'Pueblo Nuevo'),
    (23, NULL, 'Puertos de Altagracia'),
    (23, NULL, 'Punta Gorda'),
    (23, NULL, 'Sabaneta de Palma'),
    (23, 330, 'San Francisco'),
    (23, NULL, 'San José de Perijá'),
    (23, NULL, 'San Rafael del Moján'),
    (23, 315, 'San Timoteo'),
    (23, NULL, 'Santa Bárbara del Zulia'),
    (23, NULL, 'Santa Cruz de Mara'),
    (23, NULL, 'Santa Cruz del Zulia'),
    (23, 331, 'Santa Rita'),
    (23, 320, 'Sinamaica'),
    (23, NULL, 'Tamare'),
    (23, 332, 'Tía Juana'),
    (23, NULL, 'Villa Rosario');

GO

-- ============================================================
-- SECCIÓN 4: Verificación final
-- ============================================================

SELECT 'Estados'               AS Tabla, COUNT(*) AS Total FROM dbo.Estados
UNION ALL
SELECT 'Municipios'            AS Tabla, COUNT(*) AS Total FROM dbo.Municipios
UNION ALL
SELECT 'Parroquias'            AS Tabla, COUNT(*) AS Total FROM dbo.Parroquias
UNION ALL
SELECT 'Ciudades (total)'      AS Tabla, COUNT(*) AS Total FROM dbo.Ciudades
UNION ALL
SELECT 'Ciudades vinculadas'   AS Tabla, COUNT(*) AS Total FROM dbo.Ciudades WHERE IdMunicipio IS NOT NULL
UNION ALL
SELECT 'Ciudades sin municipio' AS Tabla, COUNT(*) AS Total FROM dbo.Ciudades WHERE IdMunicipio IS NULL;
GO

-- Municipios con su ciudad vinculada (todos los municipios)
SELECT
    e.IdEstado,
    e.Nombre            AS Estado,
    m.IdMunicipio,
    m.Nombre            AS Municipio,
    m.Capital           AS CapitalMunicipio,
    c.IdCiudad,
    c.Nombre            AS CiudadVinculada
FROM dbo.Municipios m
INNER JOIN dbo.Estados  e ON e.IdEstado    = m.IdEstado
LEFT  JOIN dbo.Ciudades c ON c.IdMunicipio = m.IdMunicipio
ORDER BY e.IdEstado, m.IdMunicipio;
GO
