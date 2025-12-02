-- Primer Paso
CREATE DATABASE todos_a_bordo;

-- Después de python comprobamos que se cargan las tablas
USE todos_a_bordo;
SHOW TABLES;

-- Check de que las tablas muestran bien los datos
SELECT * FROM clickandboat_barcos LIMIT 5;
SELECT * FROM aemet_clima LIMIT 5;
SELECT * FROM turistas_internacionales_julio LIMIT 5;
SELECT * FROM turistas_nacional_julio LIMIT 5;

-- HIPÓTESIS
-- Precio medio de barcos vs temperatura y viento medio de julio
SELECT
    b.ZONA_PROYECTO,
    ROUND(AVG(b.precio_dia), 2)           AS precio_medio_dia,
    ROUND(AVG(c.temperatura_med), 2)      AS temp_media_julio,
    ROUND(AVG(c.temperatura_max), 2)      AS temp_max_media_julio,
    ROUND(AVG(c.velocidad_med_viento), 2) AS viento_medio_julio
FROM clickandboat_barcos b
JOIN aemet_clima c
    ON b.ZONA_PROYECTO = c.ZONA_PROYECTO
GROUP BY b.ZONA_PROYECTO
ORDER BY precio_medio_dia DESC;

-- Distribución de precios por zona (para ver si una zona es claramente más cara)
SELECT
    ZONA_PROYECTO,
    MIN(precio_dia)                 AS precio_min,
    ROUND(AVG(precio_dia), 2)       AS precio_medio,
    MAX(precio_dia)                 AS precio_max,
    COUNT(*)                        AS num_barcos
FROM clickandboat_barcos
GROUP BY ZONA_PROYECTO
ORDER BY precio_medio DESC;

-- Turistas nacionales + internacionales vs precio medio del barco
SELECT
    b.ZONA_PROYECTO,
    ROUND(AVG(b.precio_dia), 2)          AS precio_medio_dia,
    tn.turistas_nacionales,
    ti.turistas_internacionales,
    (tn.turistas_nacionales 
     + ti.turistas_internacionales)      AS turistas_totales
FROM clickandboat_barcos b
JOIN (
    SELECT 
        ZONA_PROYECTO,
        SUM(TURISTAS_AJUSTADOS) AS turistas_nacionales
    FROM turistas_nacional_julio
    GROUP BY ZONA_PROYECTO
) tn
    ON b.ZONA_PROYECTO = tn.ZONA_PROYECTO
JOIN (
    SELECT 
        ZONA_PROYECTO,
        SUM(TURISTAS_AJUSTADOS) AS turistas_internacionales
    FROM turistas_internacionales_julio
    GROUP BY ZONA_PROYECTO
) ti
    ON b.ZONA_PROYECTO = ti.ZONA_PROYECTO
GROUP BY 
    b.ZONA_PROYECTO,
    tn.turistas_nacionales,
    ti.turistas_internacionales
ORDER BY turistas_totales DESC;

-- Precio por plaza vs presión turística (para controlar por tamaño del barco)

SELECT
    b.ZONA_PROYECTO,
    ROUND(AVG(b.precio_dia / b.capacidad_personas), 2) AS precio_medio_por_plaza,
    (tn.turistas_nacionales 
     + ti.turistas_internacionales)                    AS turistas_totales
FROM clickandboat_barcos b
JOIN (
    SELECT 
        ZONA_PROYECTO,
        SUM(TURISTAS_AJUSTADOS) AS turistas_nacionales
    FROM turistas_nacional_julio
    GROUP BY ZONA_PROYECTO
) tn
    ON b.ZONA_PROYECTO = tn.ZONA_PROYECTO
JOIN (
    SELECT 
        ZONA_PROYECTO,
        SUM(TURISTAS_AJUSTADOS) AS turistas_internacionales
    FROM turistas_internacionales_julio
    GROUP BY ZONA_PROYECTO
) ti
    ON b.ZONA_PROYECTO = ti.ZONA_PROYECTO
GROUP BY 
    b.ZONA_PROYECTO,
    turistas_totales
ORDER BY precio_medio_por_plaza DESC;

-- Clima (más fresco/ventoso) vs tipo de barco

SELECT
    bt.ZONA_PROYECTO,
    bt.total_barcos,
    bt.num_barcos_vela,
    bt.num_barcos_motor,
    ROUND(bt.num_barcos_vela  * 100.0 / bt.total_barcos, 1) AS pct_barcos_vela,
    ROUND(bt.num_barcos_motor * 100.0 / bt.total_barcos, 1) AS pct_barcos_motor,
    cv.temp_media_julio,
    cv.viento_medio_julio
FROM (
    SELECT
        ZONA_PROYECTO,
        COUNT(*) AS total_barcos,
        SUM(CASE 
                WHEN tipo_barco IN ('Velero','Catamarán','Goleta') 
                THEN 1 ELSE 0 
            END) AS num_barcos_vela,
        SUM(CASE 
                WHEN tipo_barco IN ('Lancha','Neumática','Yate','Moto de agua') 
                THEN 1 ELSE 0 
            END) AS num_barcos_motor
    FROM clickandboat_barcos
    GROUP BY ZONA_PROYECTO
) bt
JOIN (
    SELECT
        ZONA_PROYECTO,
        ROUND(AVG(temperatura_med), 2)      AS temp_media_julio,
        ROUND(AVG(velocidad_med_viento), 2) AS viento_medio_julio
    FROM aemet_clima
    GROUP BY ZONA_PROYECTO
) cv
    ON bt.ZONA_PROYECTO = cv.ZONA_PROYECTO
ORDER BY pct_barcos_vela DESC;

-- Comparar directamente Velero vs Lancha dentro de cada zona

SELECT
    ZONA_PROYECTO,
    tipo_barco,
    COUNT(*)                  AS num_barcos,
    ROUND(AVG(precio_dia),2)  AS precio_medio
FROM clickandboat_barcos
WHERE tipo_barco IN ('Velero','Lancha')
GROUP BY ZONA_PROYECTO, tipo_barco
ORDER BY ZONA_PROYECTO, tipo_barco;
)

-- Tabla resumen:
SELECT
    b.ZONA_PROYECTO,
    ROUND(AVG(b.precio_dia),2) AS precio_medio,
    ROUND(AVG(c.temperatura_med),2) AS temp_media_julio,
    (tn.turistas_nacionales + ti.turistas_internacionales) AS turistas_totales
FROM clickandboat_barcos b
JOIN aemet_clima c 
    ON b.ZONA_PROYECTO = c.ZONA_PROYECTO
JOIN (
    SELECT ZONA_PROYECTO, SUM(TURISTAS_AJUSTADOS) AS turistas_nacionales
    FROM turistas_nacional_julio
    GROUP BY ZONA_PROYECTO
) tn 
    ON b.ZONA_PROYECTO = tn.ZONA_PROYECTO
JOIN (
    SELECT ZONA_PROYECTO, SUM(TURISTAS_AJUSTADOS) AS turistas_internacionales
    FROM turistas_internacionales_julio
    GROUP BY ZONA_PROYECTO
) ti 
    ON b.ZONA_PROYECTO = ti.ZONA_PROYECTO
GROUP BY 
    b.ZONA_PROYECTO,
    turistas_totales
ORDER BY precio_medio DESC;

-- 1️⃣ Mix de producto completo por zona (todos los tipos de barco)
SELECT
    ZONA_PROYECTO,
    tipo_barco,
    COUNT(*) AS num_barcos,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY ZONA_PROYECTO), 1) AS pct_sobre_zona
FROM clickandboat_barcos
GROUP BY ZONA_PROYECTO, tipo_barco
ORDER BY ZONA_PROYECTO, pct_sobre_zona DESC;

-- 2️⃣ Segmentación de precios: ¿cuánto “mercado premium” tiene cada zona?

SELECT
    ZONA_PROYECTO,
    CASE
        WHEN precio_dia < 200 THEN 'Budget (<200€)'
        WHEN precio_dia BETWEEN 200 AND 500 THEN 'Mid (200–500€)'
        ELSE 'Premium (>500€)'
    END AS rango_precio,
    COUNT(*) AS num_barcos
FROM clickandboat_barcos
GROUP BY ZONA_PROYECTO, rango_precio
ORDER BY ZONA_PROYECTO, rango_precio;

-- Top barcos más caros por zona

SELECT
    ZONA_PROYECTO,
    tipo_barco,
    nombre_barco,
    precio_dia
FROM clickandboat_barcos
ORDER BY precio_dia DESC
LIMIT 10;

-- ¿En qué zona hay barcos más grandes? (capacidad media y eslora media)
SELECT
    ZONA_PROYECTO,
    ROUND(AVG(capacidad_personas), 1) AS capacidad_media,
    ROUND(AVG(eslora_m), 1)          AS eslora_media,
    ROUND(AVG(precio_dia), 2)        AS precio_medio,
    COUNT(*)                         AS num_barcos
FROM clickandboat_barcos
GROUP BY ZONA_PROYECTO
ORDER BY capacidad_media DESC;
