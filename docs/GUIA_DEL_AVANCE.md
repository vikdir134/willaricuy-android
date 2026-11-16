# Willaricuy: guía del avance

Versión 1.1 · 16 de noviembre de 2026

## 1. Qué estamos construyendo

Willaricuy es una propuesta de acompañamiento y ayuda ante situaciones de violencia. El prototipo HTML y los entregables de IHC definen dos accesos principales: Emergencia y Guía y comunidad. El trabajo actual lleva ese diseño a una aplicación nativa para Android.

El objetivo de esta entrega es mostrar una base que se pueda abrir, ejecutar, estudiar y continuar en Android Studio. El código usa Kotlin y layouts XML, siguiendo la organización del ejemplo académico.

## 2. Qué está implementado

| Elemento | Qué hace ahora |
| --- | --- |
| Identidad visual | Nombre Willaricuy, logo, colores, tipografía Inter/Nunito y tarjetas redondeadas. |
| Inicio | Muestra las tarjetas Emergencia y Guía y comunidad. Sus accesos abren un diálogo con el texto Prueba. |
| Encabezado | Muestra logo, título y Ocultar. En Perfil incluye una flecha para regresar. |
| Navegación inferior | Perfil abre Configuración; Inicio vuelve a la pantalla principal. |
| Perfil y configuración | Presenta el perfil anónimo, registro opcional y las filas de ajustes. El contenido se desplaza verticalmente. |
| Privacidad | Permite elegir compartir ubicación y guardar historial como preferencias locales. No activa servicios de ubicación. |
| Notificaciones | Guarda tres preferencias. No envía ni recibe notificaciones reales. |
| Idioma | Guarda la elección y actualiza la fila. El contenido sigue en español. |
| Ocultar / Quick Escape | Muestra una vista discreta con hora y fecha; la barra inferior o Atrás restauran el contenido. |
| Opciones pendientes | Registro, contactos, Acerca de y Centro de ayuda muestran Prueba. |

No hay backend, inicio de sesión real, llamadas, alertas enviadas ni conexión a una base de datos. La vista discreta pertenece a la aplicación; no bloquea el teléfono.

## 3. Cómo está organizado Android

La raíz del proyecto contiene `settings.gradle`, los archivos Gradle y la carpeta `app`. Dentro de `app/src/main` hay tres partes importantes:

- `AndroidManifest.xml` declara las pantallas y la Activity de arranque.
- `java/com/example/willaricuy` contiene los archivos Kotlin. Android admite Kotlin dentro de la carpeta llamada `java`.
- `res` contiene layouts XML, textos, colores, temas, fuentes, logo e iconos.

El paquete Kotlin, el namespace y el identificador de instalación son `com.example.willaricuy`. El nombre visible y el nombre del proyecto son Willaricuy.

El flujo principal es: Android abre `MainActivity`; al tocar Perfil se crea un `Intent` para `ConfiguracionActivity`; al volver, `finish()` cierra esa pantalla y muestra Inicio. Ambas Activities usan `VistaDiscreta` para compartir el comportamiento de Ocultar.

## 4. Cómo se guarda una preferencia

`ConfiguracionActivity` abre `SharedPreferences` con el nombre `preferenciasWillaricuy`. Al abrir un diálogo se leen los valores guardados. Mientras la persona selecciona opciones se trabaja con una copia; Guardar aplica los cambios y Cancelar descarta esa selección.

El almacenamiento es local al dispositivo y a esta instalación. El guardado no consulta una API ni PostgreSQL. La preferencia de idioma tampoco traduce automáticamente los textos: solo registra la elección.

## 5. Qué se preparó de la base de datos

La carpeta `docs/base-datos` contiene el script PostgreSQL, la lámina del modelo en PNG/SVG y el documento con su justificación. La propuesta incluye 23 tablas, 34 claves foráneas y tres vistas de consulta.

Los módulos son usuarios y preferencias; contactos y alertas; ubicación privada; profesionales y conversaciones; comunidad y moderación; distritos, incidentes y recursos de ayuda.

Tres decisiones ayudan a explicar el modelo:

1. Una publicación del foro se separa de un incidente: no todo relato debe contarse como un caso en el mapa.
2. La autoría se conserva internamente para gestionar contenido, mientras las vistas públicas propuestas omiten el identificador del autor.
3. La ubicación precisa se separa de la información territorial del foro y de los incidentes agregados.

La sintaxis y las referencias de las claves fueron verificadas de forma estática. El script no se ha ejecutado en un servidor. Autenticación, autorización, conservación de datos y envío de alertas requieren trabajo posterior.

## 6. Qué cambió en la versión 1.1

- Se unificaron el paquete y el namespace bajo el nombre Willaricuy.
- Los accesos pendientes muestran solamente Prueba.
- Se quitaron los avisos emergentes al guardar preferencias y elegir idioma.
- Quick Escape abre directamente la vista discreta.
- Se agregaron comentarios breves, un recorrido del código y un guion para presentar el avance.

## 7. Cómo revisarlo

Abre la raíz del proyecto en Android Studio y selecciona Gradle JDK 17. Sincroniza, elige un emulador o teléfono y ejecuta `app`. La guía principal de apertura está en el README de la raíz.

Para estudiar el código sigue [Recorrido del código](RECORRIDO_DEL_CODIGO.md). Para preparar la presentación usa [Guion de exposición](GUION_EXPOSICION.md). Las capturas están en `capturas` y el informe de comprobación en `verificacion.json`.
