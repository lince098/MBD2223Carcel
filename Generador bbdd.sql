-- Generado por Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   en:        2022-12-08 10:50:08 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE carcel (
    cod_carcel INTEGER NOT NULL,
    nombre     VARCHAR2(20) NOT NULL,
    email      VARCHAR2(30) NOT NULL,
    telefono   INTEGER NOT NULL,
    direccion  VARCHAR2(30) NOT NULL
);

ALTER TABLE carcel ADD CONSTRAINT carcel_pk PRIMARY KEY ( cod_carcel );

CREATE TABLE celda (
    ocupantes_max    INTEGER NOT NULL,
    id_celda         INTEGER NOT NULL,
    planta           INTEGER NOT NULL,
    modulo_id_modulo INTEGER NOT NULL
);

ALTER TABLE celda ADD CONSTRAINT celda_pk PRIMARY KEY ( id_celda );

CREATE TABLE cocinero (
    nif VARCHAR2(9) NOT NULL
);

ALTER TABLE cocinero ADD CONSTRAINT cocinero_pk PRIMARY KEY ( nif );

CREATE TABLE compra (
    recluso_nif          VARCHAR2(9) NOT NULL,
    producto_id_producto INTEGER NOT NULL,
    fecha_de_compra      DATE NOT NULL,
    cantidad             INTEGER NOT NULL
);

ALTER TABLE compra ADD CONSTRAINT compra_pk PRIMARY KEY ( recluso_nif,
                                                          producto_id_producto );

CREATE TABLE economato (
    carcel_cod_carcel INTEGER NOT NULL,
    hora_apertura     VARCHAR2(8),
    hora_cierre       VARCHAR2(8)
);

ALTER TABLE economato ADD CONSTRAINT economato_pk PRIMARY KEY ( carcel_cod_carcel );

CREATE TABLE empleado (
    telefono             INTEGER NOT NULL,
    euros_hora           FLOAT NOT NULL,
    euros_horas_extras   FLOAT NOT NULL,
    euros_horas_noche    FLOAT NOT NULL,
    carcel_cod_carcel    INTEGER NOT NULL,
    fecha_contratacion   DATE NOT NULL,
    persona_nif          VARCHAR2(9) NOT NULL,
    empleado_persona_nif VARCHAR2(9)
);

ALTER TABLE empleado ADD CONSTRAINT empleado_pk PRIMARY KEY ( persona_nif );

CREATE TABLE empresa_externa (
    cif              VARCHAR2(9) NOT NULL,
    nombre           VARCHAR2(30) NOT NULL,
    direccion_fisica VARCHAR2(30)
);

ALTER TABLE empresa_externa ADD CONSTRAINT empresa_externa_pk PRIMARY KEY ( cif );

CREATE TABLE guardia (
    empleado_persona_nif VARCHAR2(9) NOT NULL
);

ALTER TABLE guardia ADD CONSTRAINT guardia_pk PRIMARY KEY ( empleado_persona_nif );

CREATE TABLE limpiador (
    nif VARCHAR2(9) NOT NULL
);

ALTER TABLE limpiador ADD CONSTRAINT limpiador_pk PRIMARY KEY ( nif );

CREATE TABLE medico (
    num_colegiado_medico INTEGER NOT NULL,
    empleado_persona_nif VARCHAR2(9) NOT NULL
);

CREATE UNIQUE INDEX medico__idx ON
    medico (
        empleado_persona_nif
    ASC );

ALTER TABLE medico ADD CONSTRAINT medico_pk PRIMARY KEY ( num_colegiado_medico,
                                                          empleado_persona_nif );

CREATE TABLE modulo (
    id_modulo         INTEGER NOT NULL,
    carcel_cod_carcel INTEGER NOT NULL,
    tipo_modulo       VARCHAR2(11) NOT NULL
);

ALTER TABLE modulo
    ADD CHECK ( tipo_modulo IN ( 'aislamiento', 'ingreso', 'internos' ) );

ALTER TABLE modulo ADD CONSTRAINT modulo_pk PRIMARY KEY ( id_modulo );

CREATE TABLE persona (
    nif              VARCHAR2(9) NOT NULL,
    num_ss           VARCHAR2(12),
    nombre           VARCHAR2(30) NOT NULL,
    apellidos        VARCHAR2(60) NOT NULL,
    email            VARCHAR2(30) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);

ALTER TABLE persona ADD CONSTRAINT persona_pk PRIMARY KEY ( nif );

ALTER TABLE persona ADD CONSTRAINT persona_num_ss_un UNIQUE ( num_ss );

CREATE TABLE producto (
    id_producto                 INTEGER NOT NULL,
    precio                      FLOAT NOT NULL,
    nombre                      VARCHAR2(20) NOT NULL,
    stock                       INTEGER NOT NULL,
    economato_carcel_cod_carcel INTEGER NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY ( id_producto );

CREATE TABLE provee_economato (
    empresa_externa_cif  VARCHAR2(9) NOT NULL,
    economato_cod_carcel INTEGER NOT NULL
);

ALTER TABLE provee_economato ADD CONSTRAINT provee_economato_pk PRIMARY KEY ( empresa_externa_cif,
                                                                              economato_cod_carcel );

CREATE TABLE recluso (
    nif                  VARCHAR2(9) NOT NULL,
    nis                  INTEGER NOT NULL,
    fecha_inicio_condena DATE NOT NULL,
    fecha_fin_condena    DATE NOT NULL,
    celda_id_celda       INTEGER NOT NULL
);

ALTER TABLE recluso ADD CONSTRAINT recluso_pk PRIMARY KEY ( nif );

ALTER TABLE recluso ADD CONSTRAINT recluso_nis_un UNIQUE ( nis );

CREATE TABLE recluso_permiso_zona (
    recluso_nif              VARCHAR2(9) NOT NULL,
    zona_actividades_id_zona INTEGER NOT NULL
);

ALTER TABLE recluso_permiso_zona ADD CONSTRAINT recluso_permiso_zona_pk PRIMARY KEY ( recluso_nif,
                                                                                      zona_actividades_id_zona );

CREATE TABLE subcontrata (
    empresa_externa_cif  VARCHAR2(9) NOT NULL,
    empleado_persona_nif VARCHAR2(9) NOT NULL
);

ALTER TABLE subcontrata ADD CONSTRAINT subcontrata_pk PRIMARY KEY ( empleado_persona_nif );

CREATE TABLE subcontrata_empleado (
    nif VARCHAR2(9) NOT NULL
);

ALTER TABLE subcontrata_empleado ADD CONSTRAINT subcontrata_empleado_pk PRIMARY KEY ( nif );

CREATE TABLE turno (
    id_turno             INTEGER NOT NULL,
    entrada              DATE NOT NULL,
    salida               DATE,
    empleado_persona_nif VARCHAR2(9) NOT NULL
);

ALTER TABLE turno ADD CONSTRAINT turno_pk PRIMARY KEY ( id_turno );

CREATE TABLE visita (
    recluso_nif       VARCHAR2(9) NOT NULL,
    visitante_nif     VARCHAR2(9) NOT NULL,
    fecha_hora_visita DATE NOT NULL
);

ALTER TABLE visita ADD CONSTRAINT visita_pk PRIMARY KEY ( recluso_nif,
                                                          visitante_nif );

CREATE TABLE visitante (
    nif VARCHAR2(9) NOT NULL
);

ALTER TABLE visitante ADD CONSTRAINT visitante_pk PRIMARY KEY ( nif );

CREATE TABLE zona_actividades (
    id_zona           INTEGER NOT NULL,
    carcel_cod_carcel INTEGER NOT NULL,
    aforo_max         INTEGER NOT NULL,
    tipo              VARCHAR2(10) NOT NULL
);

ALTER TABLE zona_actividades
    ADD CHECK ( tipo IN ( 'BIBLIOTECA', 'GIMNASIO', 'VISITA' ) );

ALTER TABLE zona_actividades ADD CONSTRAINT zona_actividades_pk PRIMARY KEY ( id_zona );

ALTER TABLE celda
    ADD CONSTRAINT celda_modulo_fk FOREIGN KEY ( modulo_id_modulo )
        REFERENCES modulo ( id_modulo );


ALTER TABLE cocinero
    ADD CONSTRAINT cocinero_sub_empleado_fk FOREIGN KEY ( nif )
        REFERENCES subcontrata_empleado ( nif );

ALTER TABLE compra
    ADD CONSTRAINT compra_producto_fk FOREIGN KEY ( producto_id_producto )
        REFERENCES producto ( id_producto );

ALTER TABLE compra
    ADD CONSTRAINT compra_recluso_fk FOREIGN KEY ( recluso_nif )
        REFERENCES recluso ( nif );

ALTER TABLE economato
    ADD CONSTRAINT economato_carcel_fk FOREIGN KEY ( carcel_cod_carcel )
        REFERENCES carcel ( cod_carcel );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_carcel_fk FOREIGN KEY ( carcel_cod_carcel )
        REFERENCES carcel ( cod_carcel );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_empleado_fk FOREIGN KEY ( empleado_persona_nif )
        REFERENCES empleado ( persona_nif );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_persona_fk FOREIGN KEY ( persona_nif )
        REFERENCES persona ( nif );

ALTER TABLE guardia
    ADD CONSTRAINT guardia_empleado_fk FOREIGN KEY ( empleado_persona_nif )
        REFERENCES empleado ( persona_nif );


ALTER TABLE limpiador
    ADD CONSTRAINT limpiador_sub_empleado_fk FOREIGN KEY ( nif )
        REFERENCES subcontrata_empleado ( nif );

ALTER TABLE medico
    ADD CONSTRAINT medico_empleado_fk FOREIGN KEY ( empleado_persona_nif )
        REFERENCES empleado ( persona_nif );

ALTER TABLE modulo
    ADD CONSTRAINT modulo_carcel_fk FOREIGN KEY ( carcel_cod_carcel )
        REFERENCES carcel ( cod_carcel );

ALTER TABLE producto
    ADD CONSTRAINT producto_economato_fk FOREIGN KEY ( economato_carcel_cod_carcel )
        REFERENCES economato ( carcel_cod_carcel );

ALTER TABLE provee_economato
    ADD CONSTRAINT provee_economato_economato_fk FOREIGN KEY ( economato_cod_carcel )
        REFERENCES economato ( carcel_cod_carcel );

 
ALTER TABLE provee_economato
    ADD CONSTRAINT prove_econ_emp_externa_fk FOREIGN KEY ( empresa_externa_cif )
        REFERENCES empresa_externa ( cif );

ALTER TABLE recluso
    ADD CONSTRAINT recluso_celda_fk FOREIGN KEY ( celda_id_celda )
        REFERENCES celda ( id_celda );

 
ALTER TABLE recluso_permiso_zona
    ADD CONSTRAINT recl_perm_zona_recl_fk FOREIGN KEY ( recluso_nif )
        REFERENCES recluso ( nif );

 
ALTER TABLE recluso_permiso_zona
    ADD CONSTRAINT recl_perm_zona_activ_fk FOREIGN KEY ( zona_actividades_id_zona )
        REFERENCES zona_actividades ( id_zona );

ALTER TABLE recluso
    ADD CONSTRAINT recluso_persona_fk FOREIGN KEY ( nif )
        REFERENCES persona ( nif );

ALTER TABLE subcontrata
    ADD CONSTRAINT subcontrata_empleado_fk FOREIGN KEY ( empleado_persona_nif )
        REFERENCES empleado ( persona_nif );

ALTER TABLE subcontrata
    ADD CONSTRAINT subcontrata_empresa_externa_fk FOREIGN KEY ( empresa_externa_cif )
        REFERENCES empresa_externa ( cif );

ALTER TABLE turno
    ADD CONSTRAINT turno_empleado_fk FOREIGN KEY ( empleado_persona_nif )
        REFERENCES empleado ( persona_nif );

ALTER TABLE visita
    ADD CONSTRAINT visita_recluso_fk FOREIGN KEY ( recluso_nif )
        REFERENCES recluso ( nif );

ALTER TABLE visita
    ADD CONSTRAINT visita_visitante_fk FOREIGN KEY ( visitante_nif )
        REFERENCES visitante ( nif );

ALTER TABLE visitante
    ADD CONSTRAINT visitante_persona_fk FOREIGN KEY ( nif )
        REFERENCES persona ( nif );

ALTER TABLE zona_actividades
    ADD CONSTRAINT zona_actividades_carcel_fk FOREIGN KEY ( carcel_cod_carcel )
        REFERENCES carcel ( cod_carcel );





-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            22
-- CREATE INDEX                             1
-- ALTER TABLE                             52
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   9
-- WARNINGS                                 0
