# Base de datos propuesta para Willaricuy

Esta entrega contiene el diseño preparado para PostgreSQL 18. No se ha ejecutado en un servidor ni se ha conectado al proyecto Android.

- **01_modelo_willaricuy.sql:** script transaccional con 23 tablas, 34 claves foráneas, restricciones, índices, tres vistas y catálogos de ejemplo.
- **02_modelo_relacional.png:** imagen de alta resolución con tablas, campos, claves y relaciones por módulo. Amplíala para leer el detalle.
- **02_modelo_relacional.svg:** la misma lámina en formato vectorial.
- **03_explicacion_modelo.pdf:** documento de siete páginas que justifica las entidades, relaciones y decisiones de privacidad y describe los puntos que requieren desarrollo posterior.
- **validacion_script.json:** resultado de la comprobación de sintaxis y referencias. Esta comprobación no sustituye la ejecución en PostgreSQL.
- **diccionario_modelo.json:** inventario de columnas y claves obtenido del script.

El HTML final y el informe de IHC son las referencias funcionales. El modelo distingue las publicaciones de la comunidad, los incidentes del mapa, las alertas personales y la ubicación precisa compartida con contactos autorizados.

Cuando se decida desplegar la base, el script debe ejecutarse completo en una base PostgreSQL vacía. Crea el esquema `willaricuy` y no contiene `DROP`; si el esquema ya existe, la transacción fallará sin reemplazarlo. Las modificaciones posteriores deben hacerse mediante migraciones.

En este avance la aplicación solo guarda preferencias locales mediante `SharedPreferences`.
