-- Primer Paso
CREATE DATABASE todos_a_bordo;

-- Después de python comprobamos que se cargan las tablas
USE todos_a_bordo;
SHOW TABLES;

-- Check
SELECT * FROM clickandboat_barcos LIMIT 5;
SELECT * FROM aemet_clima LIMIT 5;
SELECT * FROM turistas_internacionales_julio LIMIT 5;
SELECT * FROM turistas_nacional_julio LIMIT 5;

