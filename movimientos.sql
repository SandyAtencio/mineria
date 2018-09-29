/*SQL Dimensiones*/

CREATE TABLE d_producto(
    llave_producto VARCHAR(10)
    numero_producto VARCHAR(10) CONSTRAINT d_pro_num NOT NULL,
    presentacion VARCHAR(20) CONSTRAINT d_pro_pre NOT NULL,
    valorVenta VARCHAR(20) CONSTRAINT d_pro_val NOT NULL,
    tipoProduto VARCHAR(10) CONSTRAINT d_pro_tip NOT NULL,
    CONSTRAINT d_pro_llav_pk PRIMARY KEY (),
)

CREATE TABLE d_sucursal(
    llave_sucursal VARCHAR(10) CONSTRAINT d_suc_llav_pk PRIMARY KEY,
    id_sucursal VARCHAR(10) CONSTRAINT d_suc_id NOT NULL,
    sucursal VARCHAR(30) CONSTRAINT d_suc_suc NOT NULL,
    estrato VARCHAR(3) CONSTRAINT d_suc_est NOT NULL,
    barrio VARCHAR(50) CONSTRAINT d_suc_bar NOT NULL,
    ciudad VARCHAR(50) CONSTRAINT d_suc_ciu NOT NULL,
    departamento VARCHAR(50) CONSTRAINT d_suc_dep NOT NULL
)

CREATE TABLE d_cliente(
    llave_cliente VARCHAR(10) CONSTRAINT d_cli_llav_pk PRIMARY KEY,
    cedula VARCHAR(10) CONSTRAINT d_cli_ced NOT NULL,
    edad NUMBER(2) CONSTRAINT d_cli_edad NOT NULL,
    estrato VARCHAR(3) CONSTRAINT d_cli_est NOT NULL,
    genero VARCHAR(2) CONSTRAINT d_cli_gen NOT NULL,
    estado_civil VARCHAR(2) CONSTRAINT d_cli_gen NOT NULL,
    ingresos
    trabajo
    barrio
    ciudad
    departamento
    tipo_empresa
    profesion
    barrio_empresa
)

CREATE TABLE d_dia(
    llave_dia VARCHAR(10) CONSTRAINT d_dia_llav_pk PRIMARY KEY,
    dd
    mes
    año
    nombre_dia
    semestre
    festivo
)
