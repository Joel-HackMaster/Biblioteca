CREATE DATABASE Biblioteca;

CREATE TABLE IF NOT EXISTS public.tt_tipoUsuario(
	id CHAR(10) PRIMARY KEY,
	descripcion VARCHAR(20) NOT NULL
); /* Superuser Adms Docentes Estudiantes*/

SELECT * FROM tt_tipoUsuario;

CREATE TABLE IF NOT EXISTS public.tt_usuario(
	id CHAR(10) PRIMARY KEY,
	nombre_us VARCHAR(50) NOT NULL,
	apellidos_us VARCHAR(50) NOT NULL,
	email_us VARCHAR(50) NOT NULL,
	dni_us VARCHAR(8) NOT NULL,
    estado_us VARCHAR(12) NOT NULL,
	pass_us VARCHAR(8) NOT NULL,
	id_tipoUsuario CHAR(10) NOT NULL,
    en_linea BOOLEAN DEFAULT FALSE,
	CONSTRAINT fk_tipo FOREIGN KEY(id_tipoUsuario) REFERENCES tt_tipoUsuario(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tt_auditoriaUsuario(
    id INT PRIMARY KEY,
    id_usuario CHAR(10) NOT NULL,
    detalle_au VARCHAR(500) DEFAULT NULL,
    fecha_au DATE DEFAULT CURRENT_DATE,
    hora_au TIME DEFAULT  CURRENT_TIME,
    usuario_cr CHAR(10) DEFAULT NULL,
    usuario_ed CHAR(10) DEFAULT NULL,
    usuario_el CHAR(10) DEFAULT NULL,
    ip_con VARCHAR(50) DEFAULT NULL,
    nav_con VARCHAR(50) DEFAULT NULL,
    CONSTRAINT fk_usuario FOREIGN KEY(id_usuario) REFERENCES tt_usuario(id) ON UPDATE CASCADE ON DELETE CASCADE,
    /** Si se modifica o elimina el campo id de cualquier fila de la tabla tt_usuario hara que tambien
      se actualize automaticamente esta tabla **/
    CONSTRAINT fk_usercreated FOREIGN KEY(usuario_cr) REFERENCES tt_usuario(id) ON UPDATE CASCADE,
    CONSTRAINT fk_userupdate FOREIGN KEY(usuario_ed) REFERENCES tt_usuario(id) ON UPDATE CASCADE,
    CONSTRAINT fk_userdelete FOREIGN KEY(usuario_el) REFERENCES tt_usuario(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tt_atencionUsuario(
    id CHAR(10) PRIMARY KEY,
    id_administracion CHAR(10) NOT NULL,
    id_usuario CHAR(10) NOT NULL,
    fecha_at DATE DEFAULT CURRENT_DATE,
    hora_at TIME DEFAULT CURRENT_TIME,
    CONSTRAINT fk_admin FOREIGN KEY(id_administracion) REFERENCES tt_usuario(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_user FOREIGN KEY(id_usuario) REFERENCES tt_usuario(id) ON UPDATE CASCADE
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
    titulo_li VARCHAR(150) NOT NULL,
    detalle_li VARCHAR(150) NOT NULL,
    idioma_li VARCHAR(20) NOT NULL,
    edicion_li VARCHAR(20) NOT NULL,
    pagina_li INT NOT NULL,
    copias_li INT NOT NULL,
    public_li INT NOT NULL,
    id_estadoLibro INT NOT NULL,
    id_generoLibro INT NOT NULL,
    CONSTRAINT fk_estado FOREIGN KEY(id_estadoLibro) REFERENCES tt_estadoLibro(id) ON UPDATE CASCADE,
    CONSTRAINT fk_genero FOREIGN KEY(id_estadoLibro) REFERENCES tt_generoLibro(id) ON UPDATE CASCADE
);


CREATE OR REPLACE FUNCTION generarCodigo(
	elemento VARCHAR
) RETURNS CHAR(10) AS $$
DECLARE
	codigo CHAR(10);
BEGIN
	SELECT CONCAT(elemento, LPAD((SUBSTRING(MAX(id) FROM 5 FOR 4)::INTEGER + 1)::TEXT,4,'0'))
	INTO codigo FROM tt_usuario;

	RETURN codigo;
END;
$$ LANGUAGE plpgsql;

/** USR-0001 **/
/** USR-0002 ***/

CREATE OR REPLACE PROCEDURE agregarUsuario(
    nombre VARCHAR,
    apellidos VARCHAR,
    email VARCHAR,
    dni VARCHAR,
    password VARCHAR,
    tipo_usuario VARCHAR,
    creado_por VARCHAR,


);

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