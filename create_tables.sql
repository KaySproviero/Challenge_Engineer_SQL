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


CREATE TABLE item (
  item_id            INT64,          
  descripcion        STRING,
  precio             float64,
  categoria_id       INT64,          
  customer_id        INT64,         
  estado             STRING,        
  fecha_alta         DATE,
  fecha_baja         DATE
);


CREATE TABLE orden (
  orden_id           INT64,          
  item_id            INT64,         
  customer_id        INT64,          
  cantidad           INT64,
  precio             float64,        
  fecha_orden        DATE
);


CREATE TABLE historico_item (
  fecha_lectura    DATE,          
  item_id            INT64,         
  precio             float64,
  estado             STRING
);