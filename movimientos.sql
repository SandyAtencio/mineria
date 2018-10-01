/* Creación del usiario / Esquema*/
CREATE USER caracteristicasClienteFrecuente IDENTIFIED BY caracteristicasClienteFrecuente;

/*Se asignan los privilegios de administrador*/
GRANT connect, dba TO caracteristicasClienteFrecuente;

/*Dimensiones*/
CREATE TABLE d_producto(
    llave_producto  VARCHAR(10) CONSTRAINT d_pro_llav_pk    PRIMARY KEY,
    numero_producto VARCHAR(10) CONSTRAINT d_pro_num_nn     NOT NULL,
    presentacion    VARCHAR(20) CONSTRAINT d_pro_pre_nn     NOT NULL,
    valorVenta      NUMBER(20) CONSTRAINT d_pro_val_nn     NOT NULL,
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
    valorTotalProductos     NUMBER(20)  CONSTRAINT h_val_tot_pro_nn     NOT NULL     
);

/* Vista Producto */
CREATE VIEW v_d_producto AS 
SELECT DISTINCT p.Numero, p.Presentacion, p.ValorVenta, tp.Descripcion FROM Producto p
INNER JOIN Tipo_producto tp ON p.cod_tip_produc = tp.Codigo;

/* Vista sucursal*/
CREATE VIEW v_d_sucursal    AS 
SELECT DISTINCT id_sucursal, s.descripcion, b.estrato, b.Nombre AS barrio,
c.nombre AS ciudad, d.nombre AS departamento FROM sucursal s 
INNER JOIN barrio b         ON cod_barrio   = b.codigo
INNER JOIN ciudad c         ON b.cod_ciudad = c.codigo
INNER JOIN departamento d   ON c.cod_dpto   = d.codigo;

/* Vista dia */
CREATE VIEW v_d_dia   AS
SELECT DISTINCT 
TO_CHAR(Fecha,'DD')     AS dia, 
TO_CHAR(Fecha,'MM')     AS mes,
TO_CHAR(Fecha,'YYYY')   AS anio, 
TO_CHAR(Fecha,'DAY')    AS nombre_dia,
CASE
WHEN TO_CHAR(Fecha,'MM') < '07' THEN '1'
ELSE '2' 
END AS semestre,
(SELECT COUNT(*) FROM festivo
    WHERE   TO_CHAR(v.Fecha,'DD')   = dia 
    AND     TO_CHAR(v.Fecha,'MM')   = mes
    AND     TO_CHAR(v.Fecha,'YYYY') = anio
) AS festivo
FROM venta v;

/* Vista Cliente */
CREATE VIEW v_d_cliente     AS
SELECT cl.cedula, TRUNC( MONTHS_BETWEEN(v.Fecha,cl.Fecha_nac )/12) AS Edad, b.Estrato, 
cl.genero, cl.estado_civil, ing.Descripcion AS ingresos, cl.trabajo, bc.Nombre AS barrio, c.Nombre AS ciudad, d.Nombre AS departamento,
te.Descripcion AS tipo_empresa, pr.nombre AS profesion, be.Nombre AS Barrio_Empresa FROM Cliente cl
INNER JOIN Venta        v   ON cl.Cedula            = v.Ced_cliente
INNER JOIN Barrio       bc  ON cl.cod_barrio        = bc.Codigo
INNER JOIN Barrio       be  ON cl.cod_barrioEmpr    = be.Codigo
INNER JOIN Ingresos     ing ON cl.cod_ingresos      = ing.Codigo
INNER JOIN Tipo_Empresa te  ON cl.Cod_tipoEmp       = te.Id
INNER JOIN Profesion    pr  ON cl.cod_profesion     = pr.Id
INNER JOIN Ciudad       c   ON bc.Cod_ciudad        = c.Codigo
INNER JOIN Departamento d   ON c.Cod_dpto           = d.Codigo;


/*Insercion de los datos del esquema a la bodega*/
INSERT INTO d_producto 
SELECT seq_producto.NEXTVAL, Numero, Presentacion, ValorVenta, Descripcion
FROM caracteristicasClienteFrecuente.v_d_producto;

INSERT INTO d_sucursal
SELECT seq_sucursal.NEXTVAL, id_sucursal, descripcion, estrato, barrio, ciudad, departamento
FROM caracteristicasClienteFrecuente.v_d_sucursal;

INSERT INTO d_dia
SELECT seq_dia.NEXTVAL, dia, mes, anio, nombre_dia, semestre, festivo
FROM caracteristicasClienteFrecuente.v_d_dia;

INSERT INTO d_cliente
SELECT seq_cliente.NEXTVAL, cedula, Edad, Estrato, genero, estado_civil, ingresos, trabajo, barrio,
ciudad, departamento, tipo_empresa, profesion, Barrio_Empresa
FROM caracteristicasClienteFrecuente.v_d_cliente;

/* Vista del HECHO */
CREATE VIEW v_hecho AS
SELECT p.Numero, p.ValorVenta, s.id AS id_sucursal, bs.Estrato AS Estrato_sucursal, cl.Cedula, 
TRUNC( MONTHS_BETWEEN(v.Fecha,cl.Fecha_nac )/12) AS Edad, bc.Estrato AS Estrato_cliente, c.Nombre, v.Fecha
FROM Venta v 
INNER JOIN Producto p   ON v.Num_producto   = p.Numero
INNER JOIN Sucursal s   ON v.cod_sucursal   = s.id
INNER JOIN Cliente  cl  ON v.Ced_cliente    = cl.Cedula
INNER JOIN Barrio   bs  ON s.cod_barrio     = b.Codigo
INNER JOIN Barrio   bc  ON cl.cod_barrio    = bc.Codigo
INNER JOIN Ciudad   c   ON bc.cod_ciudad    = c.Codigo;

/* Funciones de medida 1*/
CREATE OR REPLACE FUNCTION fun_cantidadTotalProductos(
    v_cedula    cliente.cedula%TYPE,
    v_numero    producto.numero%TYPE,
    v_sucursal  sucursal.id%TYPE,
    v_fecha     Venta.Fecha%TYPE
)
RETURN NUMBER
AS
v_cantidad NUMBER;
BEGIN
  SELECT SUM(v.cantidad) INTO v_cantidad
  FROM  Venta v
  INNER JOIN Sucursal s ON s.id     = v.cod_sucursal
  INNER JOIN Producto p ON p.numero = v.num_producto 
  INNER JOIN Cliente  c ON c.Cedula = v.ced_cliente
  WHERE  c.cedula = v_cedula AND p.numero = v_numero AND s.id = v_sucursal AND v.Fecha = v_fecha;
  RETURN v_cantidad;
END;
/

/* Funciones de medida 2*/
CREATE OR REPLACE FUNCTION fun_ValorTotalProductos(
    v_cedula            Cliente.Cedula%TYPE,
    v_producto          Producto.Numero%TYPE,
    v_venta_producto    Producto.ValorVenta%TYPE,
    v_fecha             Venta.Fecha%TYPE
)
RETURN NUMBER
AS
v_valorTotal NUMBER;
BEGIN
  SELECT SUM( v.Cantidad * v_venta_producto) INTO v_valorTotal
  FROM Venta v 
  INNER JOIN Cliente cl ON cl.Ced_cliente       = v.Ced_cliente
  INNER JOIN Producto p ON p.Numero             = v.Num_producto
  WHERE cl.Ced_cliente  = v_cedula AND p.Numero = v_producto AND v.Fecha = v_fecha;
  RETURN v_valorTotal;
END;
/

/* BLOQUE, ESTO SE HACE EN LA BODEGA DE DATOS*/
DECLARE 

/* SE CREA EL CURSOR QUE ALMACENA LA DATA DE LA VISTA HECHO */
CURSOR c_hecho IS SELECT * FROM MOVIMIENTOS.v_hecho;

/* VARIABLE TIPO RECORD/FILA DE LA TABLA DE HECHO DE LA BODEGA */
r_hecho h_caracteristicas_cliente_frecuente%ROWTYPE;

/* SE DECLARAN LAS VARIABLES EN BASE A LOS VALORES QUE DEVUELVE LA VISTA HECHO */
v_producto          d_producto.Numero%TYPE;
v_venta_producto    d_producto.valorVenta%TYPE;
v_sucursal          d_sucursal.id_sucursal%TYPE;
v_estrato_sucursal  d_sucursal.estrato%TYPE;
v_cliente           d_cliente.cedula%TYPE;
v_edad_cliente      d_cliente.edad%TYPE;
v_estrato_cliente   d_cliente.estrato%TYPE;
v_ciudad_cliente    d_cliente.ciudad%TYPE;
v_fecha             DATE;

BEGIN
    /* SE ABRE EL CURSOR PARA TRABAJAR CON LA DATA QUE EL ALMACENA*/
    OPEN c_hecho;
    /* SE CREA EL CICLO PARA RECORRER LOS DATOS CURSOR */
    LOOP
        /* SE OBTIENE LA PRIMER FILA DEL CURSOR Y SUS DATA SE ALMACENA EN CADA VARIABLE DECLARADA*/
        FETCH c_hecho INTO v_producto, v_venta_producto, v_sucursal, v_estrato_sucursal, v_cliente,  v_edad_cliente, v_estrato_cliente, v_ciudad_cliente;
        /* SE VERIFICA QUE EL CURSOR TENGA DATOS DE LO CONTRARIO SE SALE DEL CICLO*/
        EXIT WHEN c_hecho%NOTFOUND;

        /* Tabla de hecho */
        CREATE TABLE h_caracteristicas_cliente_frecuente(
            llave_producto          VARCHAR(10) CONSTRAINT h_pro_llav_nn        NOT NULL CONSTRAINT h_pro_llav_fk       REFERENCES d_producto(llave_producto),
            llave_sucursal          VARCHAR(10) CONSTRAINT h_sucursal_llav_nn   NOT NULL CONSTRAINT h_sucursal_llav_fk  REFERENCES d_sucursal(llave_sucursal),
            llave_cliente           VARCHAR(10) CONSTRAINT h_cli_llav_nn        NOT NULL CONSTRAINT h_cli_llav_fk       REFERENCES d_cliente(llave_cliente),
            llave_dia               VARCHAR(10) CONSTRAINT h_dia_llav_nn        NOT NULL CONSTRAINT h_dia_llav_fk       REFERENCES d_dia(llave_dia),
            cantidadTotalProductos  NUMBER(5)   CONSTRAINT h_can_tot_pro_nn     NOT NULL,
            valorTotalProductos     NUMBER(20)  CONSTRAINT h_val_tot_pro_nn     NOT NULL     
        );

        /* SE SELECCIONA LA LLAVE DE LA DIMENSION PRODUCTO Y SE ALMACENA EN LA VARIABLE RECORD EN LA POSICION DE llave_producto*/
        SELECT llave_producto INTO r_hecho.llave_producto FROM d_producto
        WHERE  numero_producto = v_producto AND valorVenta = v_venta_producto;
        /* SE SELECCIONA LA LLAVE DE LA DIMENSION SUCURSAL Y SE ALMACENA EN LA VARIABLE RECORD EN LA POSICION DE llave_sucursal*/
        SELECT llave_sucursal INTO r_hecho.llave_sucursal FROM d_sucursal
        WHERE  id_sucursal = v_sucursal AND estrato = v_estrato_sucursal;
        /* SE SELECCIONA LA LLAVE DE LA DIMENSION CLIENTE Y SE ALMACENA EN LA VARIABLE RECORD EN LA POSICION DE llave_cliente*/
        SELECT llave_cliente INTO r_hecho.llave_cliente FROM d_cliente
        WHERE  cedula = v_cliente AND edad = v_edad_cliente AND estrato = v_estrato_cliente AND ciudad v_ciudad_cliente;
        /* SE SELECCIONA LA LLAVE DE LA DIMENSION DIA Y SE ALMACENA EN LA VARIABLE RECORD EN LA POSICION DE Llave_dia*/
        SELECT Llave_dia INTO r_hecho.Llave_dia FROM d_dia
        WHERE  dd = TO_CHAR(v_fecha, 'dd') AND mes = TO_CHAR(v_fecha, 'MM') AND anio = TO_CHAR(v_fecha, 'YYYY');

        /* Se Almacenan el valor de las medidas en la variable RECORD/FILA llamando a las fuciones*/
        r_hecho.cantidadTotalProductos  := MOVIMIENTOS.fun_cantidadTotalProductos(v_cliente, v_producto, v_sucursal,  v_fecha);
        r_hecho.valorTotalProductos     := MOVIMIENTOS.fun_ValorTotalProductos(v_cliente, v_producto, v_venta_producto, v_fecha);

        /* SE INSERTA EL RECORD/FILA EN LA TABLA DE HECHO */
        INSERT INTO h_caracteristicas_cliente_frecuente VALUES r_hecho;
    
    /* SE CIERRA EL CICLO*/
    END LOOP;
    /* SE CIERRA EL CURSOR CUANDO YA SE HA RECORRIDO TODAS LAS FILAS*/
    CLOSE c_hecho;
    /* SE GUARDA PERMANENTEMENTE LOS CAMBIOS */
    COMMIT;
/* FIN DE LAS INSTRUCCIONES*/
END;
/



