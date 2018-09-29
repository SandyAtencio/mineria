/*SQL Dimensiones*/

CREATE TABLE d_producto(
    llave_producto VARCHAR(10),
    numero_producto VARCHAR(10) CONSTRAINT d_pro_num NOT NULL,
    presentacion VARCHAR(20) CONSTRAINT d_pro_pre NOT NULL,
    valorVenta VARCHAR(20) CONSTRAINT d_pro_val NOT NULL,
    tipoProduto VARCHAR(10) CONSTRAINT d_pro_tip NOT NULL,
    CONSTRAINT pk_d_pro PRIMARY KEY (llave_producto)
)

CREATE TABLE d_sucursal(
    llave_sucursal VARCHAR(10),
    id_sucursal VARCHAR(10) CONSTRAINT d_suc_id NOT NULL,
    sucursal VARCHAR(30) CONSTRAINT d_suc_suc NOT NULL,
    estrato VARCHAR(3) CONSTRAINT d_suc_est NOT NULL,
    barrio VARCHAR(50) CONSTRAINT d_suc_bar NOT NULL,
    ciudad VARCHAR(50) CONSTRAINT d_suc_ciu NOT NULL,
    departamento VARCHAR(50) CONSTRAINT d_suc_dep NOT NULL,
    CONSTRAINT pk_d_sucursal PRIMARY KEY (llave_sucursal)
)

CREATE TABLE d_cliente(
    llave_cliente VARCHAR(10) CONSTRAINT d_cli_llav_pk PRIMARY KEY,
    cedula VARCHAR(10) CONSTRAINT d_cli_ced NOT NULL,
    edad NUMBER(2) CONSTRAINT d_cli_edad NOT NULL,
    estrato VARCHAR(3) CONSTRAINT d_cli_est NOT NULL,
    genero VARCHAR(2) CONSTRAINT d_cli_gen NOT NULL,
    estado_civil VARCHAR(2) CONSTRAINT d_cli_est NOT NULL,
    ingresos  VARCHAR(30) CONSTRAINT d_cli_ing NOT NULL,
    trabajo  VARCHAR(10) CONSTRAINT d_cli_tra NOT NULL,
    barrio VARCHAR(50) CONSTRAINT d_cli_bar NOT NULL,
    ciudad VARCHAR(50) CONSTRAINT d_cli_ciu NOT NULL,
    departamento VARCHAR(50) CONSTRAINT d_cli_dep NOT NULL,
    tipo_empresa VARCHAR(50) CONSTRAINT d_cli_temp NOT NULL,
    profesion VARCHAR(50) CONSTRAINT d_cli_pro NOT NULL,
    barrio_empresa VARCHAR(50) CONSTRAINT d_cli_baremp NOT NULL,
    CONSTRAINT pk_d_cliente PRIMARY KEY (llave_cliente)
)

CREATE TABLE d_dia(
    llave_dia VARCHAR(10) CONSTRAINT d_dia_llav_pk PRIMARY KEY,
    dd NUMBER(2) CONSTRAINT d_dia_dd  NOT NULL,
    mes NUMBER(2) CONSTRAINT d_dia_mes  NOT NULL,
    anio NUMBER(4) CONSTRAINT d_dia_anio NOT NULL,
    nombre_dia VARCHAR(30) CONSTRAINT d_dia_nom NOT NULL,
    semestre NUMBER(1) CONSTRAINT d_dia_sem NOT NULL,
    festivo NUMBER(1) CONSTRAINT d_dia_fes NOT NULL,
    CONSTRAINT pk_d_dia PRIMARY KEY (llave_dia)
)
