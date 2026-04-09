-- ============================================================
-- Script SELECT - División Político-Territorial de Venezuela
-- Base de datos: VenezuelaDB
-- Ing. Juan C. Rodríguez
-- ============================================================

USE VenezuelaDB;
GO

-- ============================================================
-- 1. CONTEO GENERAL
-- ============================================================
SELECT 'Estados'              AS Tabla, COUNT(*) AS Total FROM dbo.Estados
UNION ALL
SELECT 'Municipios'           AS Tabla, COUNT(*) AS Total FROM dbo.Municipios
UNION ALL
SELECT 'Parroquias'           AS Tabla, COUNT(*) AS Total FROM dbo.Parroquias
UNION ALL
SELECT 'Ciudades (total)'     AS Tabla, COUNT(*) AS Total FROM dbo.Ciudades
UNION ALL
SELECT 'Ciudades vinculadas'  AS Tabla, COUNT(*) AS Total FROM dbo.Ciudades WHERE IdMunicipio IS NOT NULL
UNION ALL
SELECT 'Ciudades sin municipio' AS Tabla, COUNT(*) AS Total FROM dbo.Ciudades WHERE IdMunicipio IS NULL;
GO

-- ============================================================
-- 2. TODOS LOS ESTADOS
-- ============================================================
SELECT
    IdEstado,
    Iso31662,
    Nombre   AS Estado,
    Capital
FROM dbo.Estados
ORDER BY IdEstado;
GO

-- ============================================================
-- 3. TODOS LOS MUNICIPIOS (con su estado y ciudad vinculada)
-- ============================================================
SELECT
    m.IdMunicipio,
    e.IdEstado,
    e.Nombre        AS Estado,
    m.Nombre        AS Municipio,
    m.Capital       AS CapitalMunicipio,
    c.IdCiudad,
    c.Nombre        AS CiudadVinculada   -- NULL si ninguna ciudad del estado coincide
FROM dbo.Municipios m
INNER JOIN dbo.Estados  e ON e.IdEstado  = m.IdEstado
LEFT  JOIN dbo.Ciudades c ON c.IdMunicipio = m.IdMunicipio
ORDER BY e.IdEstado, m.IdMunicipio;
GO

-- ============================================================
-- 4. CIUDADES AGRUPADAS POR MUNICIPIO
--    Muestra el municipio al que pertenece cada ciudad.
--    Las ciudades sin municipio aparecen con NULL.
-- ============================================================
SELECT
    e.Nombre        AS Estado,
    m.Nombre        AS Municipio,
    m.Capital       AS CapitalMunicipio,
    c.Nombre        AS Ciudad,
    CASE
        WHEN c.IdMunicipio IS NOT NULL THEN 'Vinculada'
        ELSE 'Sin municipio asignado'
    END             AS Estatus
FROM dbo.Ciudades c
INNER JOIN dbo.Estados   e ON e.IdEstado   = c.IdEstado
LEFT  JOIN dbo.Municipios m ON m.IdMunicipio = c.IdMunicipio
ORDER BY e.IdEstado, m.IdMunicipio, c.Nombre;
GO

-- ============================================================
-- 5. CIUDADES VINCULADAS A SU MUNICIPIO (Con Parroquias)
--    Muestra el listado jerárquico completo: 
--    Estado > Municipio > Ciudad > Parroquia.
-- ============================================================
SELECT
    e.Nombre            AS Estado,
    m.Nombre            AS Municipio,
    c.Nombre            AS Ciudad,
    p.Nombre            AS Parroquia,
    m.Capital           AS CapitalDeMunicipio,
    CASE 
        WHEN c.Nombre = m.Capital THEN 'SÍ' 
        ELSE 'NO' 
    END                 AS EsCapital
FROM dbo.Ciudades c
INNER JOIN dbo.Municipios m ON c.IdMunicipio = m.IdMunicipio
INNER JOIN dbo.Estados    e ON c.IdEstado    = e.IdEstado
INNER JOIN dbo.Parroquias p ON p.IdMunicipio = m.IdMunicipio
ORDER BY Estado, Municipio, Ciudad, Parroquia;
GO

-- ============================================================
-- 6. MUNICIPIOS SIN CIUDAD VINCULADA
-- ============================================================
SELECT
    e.Nombre        AS Estado,
    m.IdMunicipio,
    m.Nombre        AS Municipio,
    m.Capital       AS CapitalMunicipio
FROM dbo.Municipios m
INNER JOIN dbo.Estados  e ON e.IdEstado    = m.IdEstado
LEFT  JOIN dbo.Ciudades c ON c.IdMunicipio = m.IdMunicipio
WHERE c.IdCiudad IS NULL
ORDER BY e.IdEstado, m.Nombre;
GO

-- ============================================================
-- 7. CIUDADES SIN MUNICIPIO ASIGNADO
-- ============================================================
SELECT
    e.Nombre        AS Estado,
    c.IdCiudad,
    c.Nombre        AS Ciudad
FROM dbo.Ciudades c
INNER JOIN dbo.Estados e ON e.IdEstado = c.IdEstado
WHERE c.IdMunicipio IS NULL
ORDER BY e.IdEstado, c.Nombre;
GO

-- ============================================================
-- 8. TODAS LAS PARROQUIAS (con municipio y estado)
-- ============================================================
SELECT
    p.IdParroquia,
    e.IdEstado,
    e.Nombre        AS Estado,
    m.IdMunicipio,
    m.Nombre        AS Municipio,
    p.Nombre        AS Parroquia
FROM dbo.Parroquias p
INNER JOIN dbo.Municipios m ON m.IdMunicipio = p.IdMunicipio
INNER JOIN dbo.Estados    e ON e.IdEstado    = m.IdEstado
ORDER BY e.IdEstado, m.IdMunicipio, p.IdParroquia;
GO

-- ============================================================
-- 9. VISTA JERÁRQUICA COMPLETA
--    Estado > Municipio > Ciudad > Parroquia
-- ============================================================
SELECT
    e.IdEstado,
    e.Iso31662,
    e.Nombre            AS Estado,
    e.Capital           AS CapitalEstado,
    m.IdMunicipio,
    m.Nombre            AS Municipio,
    m.Capital           AS CapitalMunicipio,
    c.Nombre            AS CiudadMunicipio,
    p.IdParroquia,
    p.Nombre            AS Parroquia
FROM dbo.Estados e
INNER JOIN dbo.Municipios m ON m.IdEstado     = e.IdEstado
INNER JOIN dbo.Parroquias p ON p.IdMunicipio  = m.IdMunicipio
LEFT  JOIN dbo.Ciudades   c ON c.IdMunicipio  = m.IdMunicipio
ORDER BY e.IdEstado, m.IdMunicipio, p.IdParroquia;
GO

-- ============================================================
-- 10. RESUMEN POR ESTADO
--     (municipios, parroquias, ciudades totales y vinculadas)
-- ============================================================
SELECT
    e.IdEstado,
    e.Nombre                                                AS Estado,
    e.Capital                                               AS CapitalEstado,
    COUNT(DISTINCT m.IdMunicipio)                           AS TotalMunicipios,
    COUNT(DISTINCT p.IdParroquia)                           AS TotalParroquias,
    COUNT(DISTINCT c_all.IdCiudad)                          AS TotalCiudades,
    COUNT(DISTINCT c_vin.IdCiudad)                          AS CiudadesVinculadas,
    COUNT(DISTINCT c_all.IdCiudad)
        - COUNT(DISTINCT c_vin.IdCiudad)                    AS CiudadesSinMunicipio
FROM dbo.Estados e
LEFT JOIN dbo.Municipios m
    ON m.IdEstado    = e.IdEstado
LEFT JOIN dbo.Parroquias p
    ON p.IdMunicipio = m.IdMunicipio
LEFT JOIN dbo.Ciudades c_all
    ON c_all.IdEstado    = e.IdEstado
LEFT JOIN dbo.Ciudades c_vin
    ON c_vin.IdEstado    = e.IdEstado
    AND c_vin.IdMunicipio IS NOT NULL
GROUP BY e.IdEstado, e.Nombre, e.Capital
ORDER BY e.IdEstado;
GO

-- ============================================================
-- 11. BÚSQUEDA POR ESTADO (reemplaza el valor de @Estado)
-- ============================================================
DECLARE @Estado NVARCHAR(100) = N'Miranda'; -- << Cambia aquí

SELECT
    e.Nombre            AS Estado,
    m.Nombre            AS Municipio,
    m.Capital           AS CapitalMunicipio,
    c.Nombre            AS CiudadVinculada,
    p.Nombre            AS Parroquia
FROM dbo.Estados e
INNER JOIN dbo.Municipios m ON m.IdEstado    = e.IdEstado
INNER JOIN dbo.Parroquias p ON p.IdMunicipio = m.IdMunicipio
LEFT  JOIN dbo.Ciudades   c ON c.IdMunicipio = m.IdMunicipio
WHERE e.Nombre = @Estado
ORDER BY m.Nombre, p.Nombre;
GO

-- ============================================================
-- 12. MUNICIPIOS Y SUS CIUDADES POR ID DE ESTADO
-- ============================================================
DECLARE @IdEstado INT = 14; -- << Cambia aquí (14 = Miranda)

SELECT
    m.IdMunicipio,
    m.Nombre            AS Municipio,
    m.Capital           AS CapitalMunicipio,
    c.Nombre            AS CiudadVinculada,
    COUNT(p.IdParroquia) AS TotalParroquias
FROM dbo.Municipios m
LEFT JOIN dbo.Parroquias p ON p.IdMunicipio  = m.IdMunicipio
LEFT JOIN dbo.Ciudades   c ON c.IdMunicipio  = m.IdMunicipio
WHERE m.IdEstado = @IdEstado
GROUP BY m.IdMunicipio, m.Nombre, m.Capital, c.Nombre
ORDER BY m.Nombre;
GO
