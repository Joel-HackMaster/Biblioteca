CREATE DATABASE Biblioteca;

CREATE TABLE IF NOT EXISTS public.tt_tipoUsuario(
	id SERIAL PRIMARY KEY,
	descripcion VARCHAR(20) NOT NULL
); /* Superuser Adms Docentes Estudiantes*/

SELECT * FROM tt_tipoUsuario;

CREATE TABLE IF NOT EXISTS public.tt_usuario(
	id CHAR(10) PRIMARY KEY,
    id_tipoUsuario INT NOT NULL,
    nombre_us VARCHAR(50) NOT NULL,
	apellidos_us VARCHAR(50) NOT NULL,
	email_us VARCHAR(50) NOT NULL UNIQUE,
	dni_us VARCHAR(8) NOT NULL,
	estado_us BOOLEAN DEFAULT TRUE,
	pass_us VARCHAR(8) NOT NULL,
    reestablecer_us BOOLEAN DEFAULT FALSE,
    en_linea BOOLEAN DEFAULT FALSE,
	CONSTRAINT fk_tipo FOREIGN KEY(id_tipoUsuario) REFERENCES tt_tipoUsuario(id) ON UPDATE CASCADE ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS public.tt_auditoriaUsuario(
    id INT PRIMARY KEY,
    id_usuario CHAR(10) NOT NULL,
    id_bibliotecario CHAR(10) DEFAULT NULL,
    id_accion INT DEFAULT NULL,
    detalle_au VARCHAR(500) DEFAULT NULL,
    fecha_au DATE DEFAULT CURRENT_DATE,
    hora_au TIME DEFAULT  CURRENT_TIME,
    ip_con VARCHAR(50) DEFAULT NULL,
    nav_con VARCHAR(50) DEFAULT NULL,
    disp_con VARCHAR(50) DEFAULT NULL,
    os_con VARCHAR(50) DEFAULT NULL,
    CONSTRAINT fk_bibliotecario FOREIGN KEY(id_bibliotecario) REFERENCES tt_bibliotecario(id) ON UPDATE CASCADE ON DELETE CASCADE,
    /** Si se modifica o elimina el campo id de cualquier fila de la tabla tt_usuario hara que tambien
      se actualize automaticamente esta tabla **/
    CONSTRAINT fk_accion FOREIGN KEY(id_accion) REFERENCES tt_accionUsuario(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tt_accionUsuario(
    id INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

select * from tt_auditoriaUsuario;

CREATE TABLE IF NOT EXISTS public.tt_bibliotecario(
    id CHAR(10) PRIMARY KEY,
    nombre_bi VARCHAR(50),
    apellidos_bi VARCHAR(50),
    email_bi VARCHAR(50),
    dni_bi VARCHAR(20) NOT NULL,
    estado_bi BOOLEAN DEFAULT TRUE,
    pass_bi VARCHAR(45),
    super_bi BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS public.tt_estadoLibro(
    id INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS public.tt_generoLibro(
    id INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS public.tt_libro(
    id CHAR(10) PRIMARY KEY,
    id_estadoLibro INT NOT NULL,
    id_generoLibro INT NOT NULL,
    titulo_li VARCHAR(150) NOT NULL,
    autor_li VARCHAR(150) NOT NULL,
    detalle_li VARCHAR(150) NOT NULL,
    idioma_li VARCHAR(20) NOT NULL,
    edicion_li VARCHAR(20) NOT NULL,
    pagina_li INT NOT NULL,
    copias_li INT NOT NULL,
    public_li INT NOT NULL,
    CONSTRAINT fk_estado FOREIGN KEY(id_estadoLibro) REFERENCES tt_estadoLibro(id) ON UPDATE CASCADE,
    CONSTRAINT fk_genero FOREIGN KEY(id_estadoLibro) REFERENCES tt_generoLibro(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tt_prestamoLibro (
    id CHAR(10) PRIMARY KEY,
    id_atencion CHAR(10) NOT NULL ,
    id_bibliotecario CHAR(10) NOT NULL,
    fecha_pr DATE DEFAULT CURRENT_DATE,
    hora_pr TIME DEFAULT  CURRENT_TIME,
    fecha_dv DATE DEFAULT CURRENT_DATE,
    hora_dv TIME DEFAULT  CURRENT_TIME,
    estado_pr VARCHAR(20) DEFAULT 'EN PROCESO',
    CONSTRAINT fk_atencion FOREIGN KEY(id_atencion) REFERENCES tt_atencionUsuario(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tt_estadoPrestamo(
    id INT PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.tt_auditoriaLibro (
    id INT PRIMARY KEY,
    id_libro CHAR(10) NOT NULL,
    id_accion INT DEFAULT NULL,
    fecha_au DATE DEFAULT CURRENT_DATE,
    hora_au TIME DEFAULT CURRENT_TIME,
    detalle_au VARCHAR(45) DEFAULT NULL,
    usuario_au CHAR(10) NOT NULL,
    CONSTRAINT fk_libro FOREIGN KEY (id_libro) REFERENCES tt_libro(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_accion FOREIGN KEY (id_accion) REFERENCES tt_accionUsuario(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tt_detallePrestamo (
    id_prestamo CHAR(10) NOT NULL,
    id_libro CHAR(10) NOT NULL,
    detalle_prestamo VARCHAR(100) DEFAULT NULL,
    CONSTRAINT fk_prestamo FOREIGN KEY (id_prestamo) REFERENCES tt_prestamoLibro(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_libro FOREIGN KEY (id_libro) REFERENCES tt_libro(id) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE OR REPLACE FUNCTION generarCodigo(
	elemento VARCHAR
)RETURNS CHAR(10) AS $$
DECLARE
	codigo CHAR(10);
BEGIN
	SELECT CONCAT(elemento, LPAD((SUBSTRING(MAX(id) FROM 5 FOR 6)::INTEGER + 1)::TEXT,6,'0'))
	INTO codigo FROM tt_usuario;

	RETURN codigo;
END;
$$ LANGUAGE plpgsql;

/** USR-0001 **/
/** USR-0002 ***/

/*

*/

/*
CREATE TABLE IF NOT EXISTS public.tt_tipoUsuario(
	id INT PRIMARY KEY,
	descripcion VARCHAR(20) NOT NULL
);
*/
select * from tt_tipoUsuario;
insert into tt_tipoUsuario(descripcion) values ( 'Alumno');
insert into tt_tipoUsuario(descripcion) values ( 'Docente');


CREATE OR REPLACE PROCEDURE agregarUsuario(
    tipo int,
    nombre VARCHAR,
    apellidos VARCHAR,
    email VARCHAR,
    dni VARCHAR,
    password VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    nuevo_id CHAR(10);
BEGIN
    nuevo_id := generarCodigo('USR-');
    INSERT INTO tt_usuario(id, id_tipoUsuario, nombre_us, apellidos_us, email_us, dni_us, pass_us) VALUES
    (nuevo_id, tipo, nombre, apellidos, email, dni, password);
    RAISE NOTICE 'Usuario creado con ID: %', nuevo_id;
END
$$;

INSERT INTO tt_usuario(id, id_tipoUsuario, nombre_us, apellidos_us, email_us, dni_us, pass_us) VALUES
('USR-000001', 1, 'Juan Pablo', 'Ezequiel Ramirez', 'wsanchez.1502@gmail.com', '87895626', '******');

SELECT * FROM tt_usuario;
DELETE FROM tt_usuario WHERE id = 'USR-0002';

CALL agregarUsuario(1, 'Akita', 'Kingiori Otama', 'joelwsanchezb.1995@gmail.com', '85203658', '*******');

/**
  id CHAR(10) PRIMARY KEY,
	nombre_us VARCHAR(50) NOT NULL,
	apellidos_us VARCHAR(50) NOT NULL,
	email_us VARCHAR(50) NOT NULL,
	dni_us VARCHAR(8) NOT NULL,
    estado_us VARCHAR(8) NOT NULL,
	pass_us VARCHAR(8) NOT NULL,
	id_tipoUsuario CHAR(10) NOT NULL,
  **/