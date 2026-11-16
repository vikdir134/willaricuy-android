-- Willaricuy | Modelo inicial para PostgreSQL 18.
-- Este archivo prepara la estructura; no crea un servidor ni conecta la app Android.
-- Ejecutar una vez en una base vacía o donde todavía no exista el esquema willaricuy.
-- No se borran tablas existentes. La transacción se revierte si hay un error.
BEGIN;
CREATE SCHEMA willaricuy;
SET LOCAL search_path TO willaricuy, public;

-- El invitado es una identidad técnica temporal. No exige correo, DNI ni contraseña.
CREATE TABLE usuario (
    usuario_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tipo_cuenta VARCHAR(12) NOT NULL DEFAULT 'INVITADO'
        CHECK (tipo_cuenta IN ('INVITADO', 'REGISTRADO')),
    rol VARCHAR(12) NOT NULL DEFAULT 'USUARIO'
        CHECK (rol IN ('USUARIO', 'PROFESIONAL', 'MODERADOR')),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    eliminado_en TIMESTAMPTZ,
    CHECK (eliminado_en IS NULL OR eliminado_en >= creado_en)
);

-- El proveedor verificará la identidad en una etapa posterior; no guardamos contraseñas.
CREATE TABLE identidad_acceso (
    identidad_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    proveedor VARCHAR(10) NOT NULL CHECK (proveedor IN ('GOOGLE', 'TELEFONO')),
    identificador_externo TEXT NOT NULL CHECK (btrim(identificador_externo) <> ''),
    verificado_en TIMESTAMPTZ,
    UNIQUE (proveedor, identificador_externo),
    UNIQUE (usuario_id, proveedor)
);

CREATE TABLE preferencia_usuario (
    usuario_id UUID PRIMARY KEY REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    idioma VARCHAR(2) NOT NULL DEFAULT 'es' CHECK (idioma IN ('es', 'qu', 'en')),
    compartir_ubicacion BOOLEAN NOT NULL DEFAULT TRUE,
    guardar_historial BOOLEAN NOT NULL DEFAULT TRUE,
    notificar_alertas BOOLEAN NOT NULL DEFAULT TRUE,
    notificar_foro BOOLEAN NOT NULL DEFAULT TRUE,
    notificar_bienestar BOOLEAN NOT NULL DEFAULT FALSE
);

-- Para invitados, los contactos permanecerán en el teléfono. Esta tabla es para sincronización futura.
CREATE TABLE contacto_emergencia (
    contacto_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    nombre VARCHAR(80) NOT NULL CHECK (btrim(nombre) <> ''),
    telefono VARCHAR(16) NOT NULL CHECK (telefono ~ '^\+?[0-9]{7,15}$'),
    favorito BOOLEAN NOT NULL DEFAULT FALSE,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (usuario_id, telefono),
    UNIQUE (contacto_id, usuario_id)
);

CREATE TABLE distrito (
    distrito_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    provincia VARCHAR(80) NOT NULL DEFAULT 'Lima',
    departamento VARCHAR(80) NOT NULL DEFAULT 'Lima',
    ubigeo CHAR(6) UNIQUE CHECK (ubigeo IS NULL OR ubigeo ~ '^[0-9]{6}$'),
    UNIQUE (departamento, provincia, nombre)
);

CREATE TABLE alerta (
    alerta_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    distrito_id INTEGER REFERENCES distrito(distrito_id) ON DELETE RESTRICT,
    tipo VARCHAR(12) NOT NULL CHECK (tipo IN ('EMERGENCIA', 'UBICACION', 'CONTACTO', 'COMUNITARIA')),
    estado VARCHAR(12) NOT NULL DEFAULT 'ACTIVA' CHECK (estado IN ('ACTIVA', 'FINALIZADA', 'CANCELADA')),
    creada_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finalizada_en TIMESTAMPTZ,
    CHECK ((estado = 'ACTIVA' AND finalizada_en IS NULL)
        OR (estado <> 'ACTIVA' AND finalizada_en IS NOT NULL AND finalizada_en >= creada_en)),
    UNIQUE (alerta_id, usuario_id)
);

-- Las claves compuestas garantizan que el contacto pertenezca a quien emitió la alerta.
CREATE TABLE destinatario_alerta (
    alerta_id UUID NOT NULL,
    contacto_id UUID NOT NULL,
    usuario_id UUID NOT NULL,
    estado VARCHAR(10) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'ENVIADO', 'FALLIDO')),
    enviado_en TIMESTAMPTZ,
    PRIMARY KEY (alerta_id, contacto_id),
    FOREIGN KEY (alerta_id, usuario_id) REFERENCES alerta(alerta_id, usuario_id) ON DELETE CASCADE,
    FOREIGN KEY (contacto_id, usuario_id) REFERENCES contacto_emergencia(contacto_id, usuario_id) ON DELETE CASCADE,
    CHECK ((estado = 'ENVIADO' AND enviado_en IS NOT NULL) OR estado <> 'ENVIADO')
);

CREATE TABLE sesion_ubicacion (
    sesion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alerta_id UUID NOT NULL UNIQUE REFERENCES alerta(alerta_id) ON DELETE CASCADE,
    iniciada_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expira_en TIMESTAMPTZ NOT NULL,
    detenida_en TIMESTAMPTZ,
    CHECK (expira_en > iniciada_en AND expira_en <= iniciada_en + INTERVAL '24 hours'),
    CHECK (detenida_en IS NULL OR detenida_en >= iniciada_en)
);

-- Las coordenadas precisas son privadas. No se usan como puntos públicos del mapa de calor.
CREATE TABLE posicion_ubicacion (
    posicion_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sesion_id UUID NOT NULL REFERENCES sesion_ubicacion(sesion_id) ON DELETE CASCADE,
    latitud NUMERIC(9,6) NOT NULL CHECK (latitud BETWEEN -90 AND 90),
    longitud NUMERIC(9,6) NOT NULL CHECK (longitud BETWEEN -180 AND 180),
    registrada_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (sesion_id, registrada_en)
);

CREATE TABLE especialidad (
    especialidad_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE CHECK (btrim(nombre) <> '')
);

CREATE TABLE profesional (
    profesional_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL UNIQUE REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    especialidad_id SMALLINT NOT NULL REFERENCES especialidad(especialidad_id) ON DELETE RESTRICT,
    nombre_publico VARCHAR(120) NOT NULL CHECK (btrim(nombre_publico) <> ''),
    descripcion VARCHAR(250) NOT NULL DEFAULT '',
    disponibilidad VARCHAR(120) NOT NULL DEFAULT '',
    estado VARCHAR(12) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'VERIFICADO', 'SUSPENDIDO'))
);

CREATE TABLE conversacion (
    conversacion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    profesional_id UUID NOT NULL REFERENCES profesional(profesional_id) ON DELETE CASCADE,
    estado VARCHAR(8) NOT NULL DEFAULT 'ABIERTA' CHECK (estado IN ('ABIERTA', 'CERRADA')),
    creada_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cerrada_en TIMESTAMPTZ,
    CHECK ((estado = 'ABIERTA' AND cerrada_en IS NULL)
        OR (estado = 'CERRADA' AND cerrada_en IS NOT NULL AND cerrada_en >= creada_en))
);
CREATE UNIQUE INDEX una_conversacion_abierta ON conversacion(usuario_id, profesional_id) WHERE estado = 'ABIERTA';

CREATE TABLE mensaje (
    mensaje_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    conversacion_id UUID NOT NULL REFERENCES conversacion(conversacion_id) ON DELETE CASCADE,
    remitente_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    contenido TEXT NOT NULL CHECK (char_length(btrim(contenido)) BETWEEN 1 AND 4000),
    enviado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- La autoría es interna; la interfaz pública no mostrará estos identificadores.
CREATE TABLE publicacion (
    publicacion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    autor_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    distrito_id INTEGER REFERENCES distrito(distrito_id) ON DELETE RESTRICT,
    contenido TEXT NOT NULL CHECK (char_length(btrim(contenido)) BETWEEN 1 AND 2000),
    estado VARCHAR(12) NOT NULL DEFAULT 'EN_REVISION' CHECK (estado IN ('EN_REVISION', 'APROBADO', 'RECHAZADO', 'RETIRADO')),
    creada_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Las fotos estarán en almacenamiento de objetos; aquí solo guardamos su referencia.
CREATE TABLE imagen_publicacion (
    imagen_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    publicacion_id UUID NOT NULL REFERENCES publicacion(publicacion_id) ON DELETE CASCADE,
    clave_objeto TEXT NOT NULL UNIQUE CHECK (btrim(clave_objeto) <> ''),
    orden SMALLINT NOT NULL CHECK (orden BETWEEN 1 AND 3),
    UNIQUE (publicacion_id, orden)
);

CREATE TABLE comentario (
    comentario_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    publicacion_id UUID NOT NULL REFERENCES publicacion(publicacion_id) ON DELETE CASCADE,
    autor_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    contenido TEXT NOT NULL CHECK (char_length(btrim(contenido)) BETWEEN 1 AND 1000),
    estado VARCHAR(12) NOT NULL DEFAULT 'EN_REVISION' CHECK (estado IN ('EN_REVISION', 'APROBADO', 'RECHAZADO', 'RETIRADO')),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- La presencia de una fila representa un abrazo. La clave evita abrazos duplicados.
CREATE TABLE reaccion (
    publicacion_id UUID NOT NULL REFERENCES publicacion(publicacion_id) ON DELETE CASCADE,
    usuario_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    creada_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (publicacion_id, usuario_id)
);

CREATE TABLE reporte_contenido (
    reporte_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reportante_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    publicacion_id UUID REFERENCES publicacion(publicacion_id) ON DELETE CASCADE,
    comentario_id UUID REFERENCES comentario(comentario_id) ON DELETE CASCADE,
    motivo TEXT NOT NULL CHECK (char_length(btrim(motivo)) BETWEEN 1 AND 1000),
    estado VARCHAR(10) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'REVISADO', 'DESCARTADO')),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (num_nonnulls(publicacion_id, comentario_id) = 1)
);
CREATE UNIQUE INDEX un_reporte_pendiente_publicacion ON reporte_contenido(reportante_id, publicacion_id) WHERE estado = 'PENDIENTE' AND publicacion_id IS NOT NULL;
CREATE UNIQUE INDEX un_reporte_pendiente_comentario ON reporte_contenido(reportante_id, comentario_id) WHERE estado = 'PENDIENTE' AND comentario_id IS NOT NULL;

CREATE TABLE revision_moderacion (
    revision_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    moderador_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE RESTRICT,
    publicacion_id UUID REFERENCES publicacion(publicacion_id) ON DELETE CASCADE,
    comentario_id UUID REFERENCES comentario(comentario_id) ON DELETE CASCADE,
    decision VARCHAR(8) NOT NULL CHECK (decision IN ('APROBAR', 'RECHAZAR', 'RETIRAR')),
    observacion TEXT NOT NULL DEFAULT '',
    revisado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (num_nonnulls(publicacion_id, comentario_id) = 1)
);

-- Un incidente del mapa es un registro distinto de una publicación del foro.
-- Solo se expone su distrito, nunca una ubicación precisa de la persona.
CREATE TABLE incidente (
    incidente_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reportante_id UUID REFERENCES usuario(usuario_id) ON DELETE SET NULL,
    distrito_id INTEGER NOT NULL REFERENCES distrito(distrito_id) ON DELETE RESTRICT,
    descripcion TEXT NOT NULL CHECK (char_length(btrim(descripcion)) BETWEEN 1 AND 1000),
    fecha_aproximada DATE NOT NULL,
    nivel_reportado VARCHAR(8) NOT NULL CHECK (nivel_reportado IN ('BAJO', 'MODERADO', 'ALTO')),
    estado VARCHAR(12) NOT NULL DEFAULT 'EN_REVISION' CHECK (estado IN ('EN_REVISION', 'VALIDADO', 'DESCARTADO')),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE recurso_ayuda (
    recurso_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo VARCHAR(12) NOT NULL CHECK (tipo IN ('LINEA', 'GUIA', 'FAQ', 'ENLACE', 'INFORMACION')),
    titulo VARCHAR(160) NOT NULL CHECK (btrim(titulo) <> ''),
    descripcion TEXT NOT NULL DEFAULT '',
    telefono VARCHAR(20),
    url TEXT CHECK (url IS NULL OR url ~ '^https://'),
    orden SMALLINT NOT NULL DEFAULT 0 CHECK (orden >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE paso_guia (
    paso_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recurso_id INTEGER NOT NULL REFERENCES recurso_ayuda(recurso_id) ON DELETE CASCADE,
    numero SMALLINT NOT NULL CHECK (numero > 0),
    titulo VARCHAR(120) NOT NULL CHECK (btrim(titulo) <> ''),
    instrucciones TEXT NOT NULL CHECK (btrim(instrucciones) <> ''),
    UNIQUE (recurso_id, numero)
);

CREATE TABLE notificacion (
    notificacion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    destinatario_id UUID NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    alerta_id UUID REFERENCES alerta(alerta_id) ON DELETE CASCADE,
    publicacion_id UUID REFERENCES publicacion(publicacion_id) ON DELETE CASCADE,
    tipo VARCHAR(12) NOT NULL CHECK (tipo IN ('ALERTA', 'FORO', 'BIENESTAR')),
    mensaje VARCHAR(250) NOT NULL CHECK (btrim(mensaje) <> ''),
    creada_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    leida_en TIMESTAMPTZ,
    CHECK (leida_en IS NULL OR leida_en >= creada_en),
    CHECK ((tipo = 'ALERTA' AND alerta_id IS NOT NULL AND publicacion_id IS NULL)
        OR (tipo = 'FORO' AND publicacion_id IS NOT NULL AND alerta_id IS NULL)
        OR (tipo = 'BIENESTAR' AND alerta_id IS NULL AND publicacion_id IS NULL))
);

-- Índices para las consultas que aparecen en el prototipo.
CREATE INDEX contactos_por_usuario ON contacto_emergencia(usuario_id, favorito DESC);
CREATE INDEX alertas_por_usuario ON alerta(usuario_id, creada_en DESC);
CREATE INDEX posiciones_por_sesion ON posicion_ubicacion(sesion_id, registrada_en DESC);
CREATE INDEX profesionales_por_especialidad ON profesional(especialidad_id, estado);
CREATE INDEX conversaciones_por_profesional ON conversacion(profesional_id, creada_en DESC);
CREATE INDEX mensajes_por_conversacion ON mensaje(conversacion_id, enviado_en);
CREATE INDEX publicaciones_por_estado ON publicacion(estado, creada_en DESC);
CREATE INDEX publicaciones_por_autor ON publicacion(autor_id, creada_en DESC);
CREATE INDEX publicaciones_por_distrito ON publicacion(distrito_id, creada_en DESC);
CREATE INDEX comentarios_por_publicacion ON comentario(publicacion_id, estado, creado_en);
CREATE INDEX reacciones_por_usuario ON reaccion(usuario_id);
CREATE INDEX reportes_por_estado ON reporte_contenido(estado, creado_en);
CREATE INDEX revisiones_por_publicacion ON revision_moderacion(publicacion_id, revisado_en DESC);
CREATE INDEX revisiones_por_comentario ON revision_moderacion(comentario_id, revisado_en DESC);
CREATE INDEX incidentes_por_distrito ON incidente(distrito_id, estado, fecha_aproximada);
CREATE INDEX notificaciones_por_destinatario ON notificacion(destinatario_id, leida_en, creada_en DESC);

-- Estas vistas omiten la identidad de autores. No sustituyen permisos o políticas de acceso.
CREATE VIEW publicaciones_aprobadas AS
SELECT p.publicacion_id, p.distrito_id, p.contenido, p.creada_en,
       (SELECT count(*) FROM reaccion r WHERE r.publicacion_id = p.publicacion_id) AS abrazos,
       (SELECT count(*) FROM comentario c WHERE c.publicacion_id = p.publicacion_id AND c.estado = 'APROBADO') AS comentarios
FROM publicacion p WHERE p.estado = 'APROBADO';

CREATE VIEW comentarios_aprobados AS
SELECT c.comentario_id, c.publicacion_id, c.contenido, c.creado_en
FROM comentario c JOIN publicacion p ON p.publicacion_id = c.publicacion_id
WHERE c.estado = 'APROBADO' AND p.estado = 'APROBADO';

CREATE VIEW resumen_incidentes_distrito AS
SELECT d.distrito_id, d.nombre, count(i.incidente_id) AS reportes_validados
FROM distrito d LEFT JOIN incidente i ON i.distrito_id = d.distrito_id
    AND i.estado = 'VALIDADO' AND i.fecha_aproximada >= CURRENT_DATE - 30
GROUP BY d.distrito_id, d.nombre;

-- Catálogos de ejemplo. No se incluyen identidades, teléfonos privados ni incidentes reales.
INSERT INTO especialidad(nombre) VALUES ('Psicología'), ('Asesoría legal'), ('Trabajo social');
INSERT INTO distrito(nombre) VALUES ('San Isidro'), ('Miraflores'), ('Surco'), ('Barranco'), ('San Borja');
INSERT INTO recurso_ayuda(tipo, titulo, descripcion, orden)
VALUES ('GUIA', 'Cómo denunciar', 'Guía de orientación que deberá ser revisada antes de una publicación real.', 1),
       ('FAQ', '¿Puedo usar la aplicación sin crear una cuenta?', 'Las funciones de ayuda y orientación se plantean con acceso sin registro.', 2);

COMMENT ON SCHEMA willaricuy IS 'Modelo académico inicial; no incluye backend, autenticación activa ni políticas de autorización.';
COMMENT ON TABLE posicion_ubicacion IS 'Datos precisos y privados. Su expiración y eliminación requieren una tarea posterior; un CHECK no elimina filas.';
COMMENT ON TABLE mensaje IS 'Contenido de ejemplo del modelo. Esta estructura por sí sola no proporciona cifrado de extremo a extremo.';
COMMENT ON TABLE incidente IS 'Reportes agregados por distrito; no equivalen a denuncias oficiales ni determinan automáticamente la peligrosidad de una zona.';
COMMIT;
