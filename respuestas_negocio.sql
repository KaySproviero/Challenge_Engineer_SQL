/*Para la resolucion usamos Bigquery como interfaz de desarrollo.
  Cabe aclarar que el nombre de las tablas esta sin el proyecto 
  ni el conjunto de datos a donde estan alojadas.
*/

-- ******************************************************
-- Usuarios que cumplen años hoy y vendieron más de 1500 unidades en enero 2020
-- ******************************************************

SELECT
  c.customer_id,
  c.nombre,
  c.apellido,
  COUNT(o.orden_id) AS cantidad_ventas
FROM
  `customer` c
JOIN
  `item` i ON c.customer_id = i.customer_id
JOIN
  `orden` o ON o.item_id = i.item_id
WHERE
  EXTRACT(MONTH FROM c.fecha_nacimiento) = EXTRACT(MONTH FROM CURRENT_DATE())
  AND EXTRACT(DAY FROM c.fecha_nacimiento) = EXTRACT(DAY FROM CURRENT_DATE())
  AND o.fecha_orden BETWEEN '2020-01-01' AND '2020-01-31'
GROUP BY
  c.customer_id, c.nombre, c.apellido
HAVING
  COUNT(o.orden_id) > 1500;
  
  
  
-- ******************************************************  
-- Top 5 vendedores mensuales en categoría “Celulares” en 2020
-- ******************************************************  


WITH ventas_celulares AS (
  SELECT
    EXTRACT(YEAR FROM o.fecha_orden) AS anio,
    EXTRACT(MONTH FROM o.fecha_orden) AS mes,
    c.customer_id,
    c.nombre,
    c.apellido,
    COUNT(o.orden_id) AS cantidad_ventas,
    SUM(o.cantidad) AS productos_vendidos,
    SUM(o.cantidad * o.precio) AS monto_total,
    ROW_NUMBER() OVER (
      PARTITION BY EXTRACT(YEAR FROM o.fecha_orden), EXTRACT(MONTH FROM o.fecha_orden)
      ORDER BY SUM(o.cantidad * o.precio) DESC
    ) AS posicion
  FROM
    `orden` o
  JOIN
    `item` i ON o.item_id = i.item_id
  JOIN
    `customer` c ON i.customer_id = c.customer_id
  JOIN
    `category` cat ON i.categoria_id = cat.categoria_id
  WHERE
    UPPER(cat.nombre_categoria) LIKE '%CELULARES%'
    AND o.fecha_orden BETWEEN '2020-01-01' AND '2020-12-31'
  GROUP BY
    anio, mes, c.customer_id, c.nombre, c.apellido
)

SELECT
  anio,
  mes,
  customer_id,
  nombre,
  apellido,
  cantidad_ventas,
  productos_vendidos,
  monto_total
FROM
  ventas_celulares
WHERE
  posicion <= 5
ORDER BY
  anio, mes, monto_total DESC;

-- ******************************************************  
-- Creamos un SP para poblar tabla historico_item con el estado del ítems al día
-- ****************************************************** 
CREATE OR REPLACE PROCEDURE `Actualiza_historico_item_diario`()
BEGIN

DELETE FROM `historico_item` 
WHERE fecha_lectura = CURRENT_DATE ()
;

INSERT INTO `historico_item` (fecha_lectura, item_id, precio, estado)
SELECT
  CURRENT_DATE() AS fecha_lectura ,
  item_id,
  precio,
  estado
FROM
  `item`
WHERE
  estado IS NOT NULL;
  
end;  



