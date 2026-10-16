-- Tarea 3: importe total y número de ventas de los 3 cuatrimestres de 2025 (MySQL 8)

-- Tabla intermedia: aquí se cargan las filas tal cual vienen, incluidos los duplicados
DROP TABLE IF EXISTS vendas_t3_carga;

CREATE TABLE vendas_t3_carga (
    fila            INT AUTO_INCREMENT PRIMARY KEY,   -- orden de lectura
    periodo         TINYINT,
    id_venda        INT,
    data            DATE,
    tenda           VARCHAR(50),
    produto         VARCHAR(50),
    unidades        INT,
    prezo_unitario  DECIMAL(10,2),
    importe         DECIMAL(12,2)
) CHARACTER SET utf8mb4;

-- Carga de los 3 CSV (decimales con coma -> se cambian por punto)
LOAD DATA INFILE '/var/lib/mysql-files/tarefa1/vendas_2025_cuadrimestre1.csv'
INTO TABLE vendas_t3_carga CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_venda, data, tenda, produto, unidades, @prezo, @importe)
SET periodo = 1,
    prezo_unitario = REPLACE(@prezo,   ',', '.'),
    importe        = REPLACE(@importe, ',', '.');

LOAD DATA INFILE '/var/lib/mysql-files/tarefa1/vendas_2025_cuadrimestre2.csv'
INTO TABLE vendas_t3_carga CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_venda, data, tenda, produto, unidades, @prezo, @importe)
SET periodo = 2,
    prezo_unitario = REPLACE(@prezo,   ',', '.'),
    importe        = REPLACE(@importe, ',', '.');

LOAD DATA INFILE '/var/lib/mysql-files/tarefa1/vendas_2025_cuadrimestre3.csv'
INTO TABLE vendas_t3_carga CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_venda, data, tenda, produto, unidades, @prezo, @importe)
SET periodo = 3,
    prezo_unitario = REPLACE(@prezo,   ',', '.'),
    importe        = REPLACE(@importe, ',', '.');

-- Tabla final sin duplicados: id_venda es clave primaria e INSERT IGNORE
-- se queda con la primera aparición (igual que drop_duplicates en pandas)
DROP TABLE IF EXISTS vendas_t3;

CREATE TABLE vendas_t3 (
    id_venda        INT PRIMARY KEY,
    periodo         TINYINT,
    data            DATE,
    tenda           VARCHAR(50),
    produto         VARCHAR(50),
    unidades        INT,
    prezo_unitario  DECIMAL(10,2),
    importe         DECIMAL(12,2)
) CHARACTER SET utf8mb4;

INSERT IGNORE INTO vendas_t3
SELECT id_venda, periodo, data, tenda, produto, unidades, prezo_unitario, importe
FROM vendas_t3_carga
ORDER BY fila;

-- Filas cargadas vs. ventas únicas
SELECT (SELECT COUNT(*) FROM vendas_t3_carga) AS filas_cargadas,
       (SELECT COUNT(*) FROM vendas_t3)       AS ventas_unicas;

-- Resultado por cuatrimestre
SELECT periodo       AS cuatrimestre,
       COUNT(*)      AS num_ventas,
       SUM(importe)  AS importe_total
FROM vendas_t3
GROUP BY periodo
ORDER BY periodo;

-- Total acumulado 2025
SELECT COUNT(*)      AS num_ventas,
       SUM(importe)  AS importe_total
FROM vendas_t3;
