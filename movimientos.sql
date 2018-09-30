/* Creación del usiario / Esquema*/
CREATE USER caracteristicasClienteFrecuente IDENTIFIED BY caracteristicasClienteFrecuente;

/*Se asignan los privilegios de administrador*/
GRANT connect, dba TO caracteristicasClienteFrecuente;

/*Dimensiones*/
CREATE TABLE d_producto(
    llave_producto  VARCHAR(10) CONSTRAINT d_pro_llav_pk    PRIMARY KEY,
    numero_producto VARCHAR(10) CONSTRAINT d_pro_num_nn     NOT NULL,
    presentacion    VARCHAR(20) CONSTRAINT d_pro_pre_nn     NOT NULL,
    valorVenta      VARCHAR(20) CONSTRAINT d_pro_val_nn     NOT NULL,
    tipoProduto     VARCHAR(10) CONSTRAINT d_pro_tip_nn     NOT NULL,
);

CREATE TABLE d_sucursal(
    llave_sucursal  VARCHAR(10) CONSTRAINT d_sucursal_llav_pk   PRIMARY KEY,
    id_sucursal     VARCHAR(10) CONSTRAINT d_suc_id_nn          NOT NULL,
    sucursal        VARCHAR(30) CONSTRAINT d_suc_suc_nn         NOT NULL,
    estrato         VARCHAR(3)  CONSTRAINT d_suc_est_nn         NOT NULL,
    barrio          VARCHAR(50) CONSTRAINT d_suc_bar_nn         NOT NULL,
    ciudad          VARCHAR(50) CONSTRAINT d_suc_ciu_nn         NOT NULL,
    departamento    VARCHAR(50) CONSTRAINT d_suc_dep_nn         NOT NULL,
);

CREATE TABLE d_cliente(
    llave_cliente   VARCHAR(10) CONSTRAINT d_cli_llav_pk    PRIMARY KEY,
    cedula          VARCHAR(10) CONSTRAINT d_cli_ced_nn     NOT NULL,
    edad            NUMBER(2)   CONSTRAINT d_cli_edad_nn    NOT NULL,
    estrato         VARCHAR(3)  CONSTRAINT d_cli_est_nn     NOT NULL,
    genero          VARCHAR(2)  CONSTRAINT d_cli_gen_nn     NOT NULL,
    estado_civil    VARCHAR(2)  CONSTRAINT d_cli_est_nn     NOT NULL,
    ingresos        VARCHAR(30) CONSTRAINT d_cli_ing_nn     NOT NULL,
    trabajo         VARCHAR(10) CONSTRAINT d_cli_tra_nn     NOT NULL,
    barrio          VARCHAR(50) CONSTRAINT d_cli_bar_nn     NOT NULL,
    ciudad          VARCHAR(50) CONSTRAINT d_cli_ciu_nn     NOT NULL,
    departamento    VARCHAR(50) CONSTRAINT d_cli_dep_nn     NOT NULL,
    tipo_empresa    VARCHAR(50) CONSTRAINT d_cli_temp_nn    NOT NULL,
    profesion       VARCHAR(50) CONSTRAINT d_cli_pro_nn     NOT NULL,
    barrio_empresa  VARCHAR(50) CONSTRAINT d_cli_baremp_nn  NOT NULL,
);

CREATE TABLE d_dia(
    llave_dia       VARCHAR(10) CONSTRAINT d_dia_llav_pk    PRIMARY KEY,
    dd              NUMBER(2)   CONSTRAINT d_dia_dd_nn      NOT NULL,
    mes             NUMBER(2)   CONSTRAINT d_dia_mes_nn     NOT NULL,
    anio            NUMBER(4)   CONSTRAINT d_dia_anio_nn    NOT NULL,
    nombre_dia      VARCHAR(30) CONSTRAINT d_dia_nom_nn     NOT NULL,
    semestre        NUMBER(1)   CONSTRAINT d_dia_sem_nn     NOT NULL,
    festivo         NUMBER(1)   CONSTRAINT d_dia_fes_nn     NOT NULL,
);

/* Sequencias */
CREATE SEQUENCE seq_producto;

CREATE SEQUENCE seq_sucursal;

CREATE SEQUENCE seq_cliente;

CREATE SEQUENCE seq_dia;

/* Tabla de hecho */
CREATE TABLE h_caracteristicas_cliente_frecuente(
    llave_producto          VARCHAR(10) CONSTRAINT h_pro_llav_nn        NOT NULL CONSTRAINT h_pro_llav_fk       REFERENCES d_producto(llave_producto),
    llave_sucursal          VARCHAR(10) CONSTRAINT h_sucursal_llav_nn   NOT NULL CONSTRAINT h_sucursal_llav_fk  REFERENCES d_sucursal(llave_sucursal),
    llave_cliente           VARCHAR(10) CONSTRAINT h_cli_llav_nn        NOT NULL CONSTRAINT h_cli_llav_fk       REFERENCES d_cliente(llave_cliente),
    llave_dia               VARCHAR(10) CONSTRAINT h_dia_llav_nn        NOT NULL CONSTRAINT h_dia_llav_fk       REFERENCES d_dia(llave_dia),
    cantidadTotalProductos  NUMBER(5)   CONSTRAINT h_can_tot_pro_nn     NOT NULL,
    valorTotalProductos     NUMBER(30)  CONSTRAINT h_val_tot_pro_nn     NOT NULL     
);


CREATE VIEW d_producto AS 
SELECT DISTINCT p.Numero, p.Presentacion, p.ValorVenta, tp.Descripcion FROM Producto p
INNER JOIN Tipo_producto tp ON p.cod_tip_produc = tp.Codigo;