/*
   Para optimizar el rendimiento de las consultas, se aplicó particionamiento por fecha en las tablas Item, orden e historico_item, 
   justamente por que en el enunciado se destaca el gran volumen de las tablas de orden e items. De esta manera se reduce el 
   volumen de datos escaneados en análisis temporales.
   A su vez, se definió clustering por campos clave (item_id, customer_id, categoria_id) para acelerar búsquedas y joins en grandes volúmenes de datos.
*/

CREATE TABLE customer (
  customer_id        INT64,          
  email              STRING,
  nombre             STRING,
  apellido           STRING,
  numero_documento   INT64,
  sexo               STRING,
  direccion          STRING,
  fecha_nacimiento   DATE,
  telefono           INT64
);


CREATE TABLE category (
  categoria_id       INT64,          
  nombre_categoria   STRING
);


CREATE TABLE item 
PARTITION BY DATE(fecha_alta)
CLUSTER BY item_id, customer_id 
as(
  item_id            INT64,          
  descripcion        STRING,
  precio             float64,
  categoria_id       INT64,          
  customer_id        INT64,         
  estado             STRING,        
  fecha_alta         DATE,
  fecha_baja         DATE
);


CREATE TABLE orden 
PARTITION BY DATE(fecha_orden)
CLUSTER BY item_id, customer_id 
as(
  orden_id           INT64,          
  item_id            INT64,         
  customer_id        INT64,          
  cantidad           INT64,
  precio             float64,        
  fecha_orden        DATE
);


CREATE TABLE historico_item
PARTITION BY DATE(fecha_lectura)
CLUSTER BY item_id (
  fecha_lectura    DATE,          
  item_id            INT64,         
  precio             float64,
  estado             STRING
);
