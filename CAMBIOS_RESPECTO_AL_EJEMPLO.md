# Cambios del avance Willaricuy

La organización principal del ejemplo se conserva. El avance se entrega en una carpeta diferente y no modifica el proyecto original del profesor.

| Archivo o carpeta | Cambio y motivo |
| --- | --- |
| `settings.gradle` | Nombre del proyecto: Willaricuy. |
| `app/build.gradle` | Namespace e identificador de instalación `com.example.willaricuy`, versión 1.1. Conserva las herramientas del ejemplo. Se usan AppCompat y ConstraintLayout, sin librerías de backend. |
| `app/src/main/AndroidManifest.xml` | Nombre, logo y tema de la aplicación. Declara Inicio y Configuración; desactiva el respaldo automático. |
| `app/src/main/java/com/example/willaricuy/MainActivity.kt` | Inicio y sus acciones de navegación. Los accesos pendientes muestran Prueba. |
| `app/src/main/java/com/example/willaricuy/ConfiguracionActivity.kt` | Perfil, diálogos de ajustes y preferencias locales. Se quitaron los avisos largos y los Toast de guardado. |
| `app/src/main/java/com/example/willaricuy/VistaDiscreta.kt` | Comparte el comportamiento de Ocultar entre las dos Activities. |
| `app/src/main/res/layout/activity_main.xml` | Diseño de Inicio con las dos tarjetas principales. |
| `app/src/main/res/layout/activity_configuracion.xml` | Diseño de Perfil y lista de configuración. |
| `app/src/main/res/layout/encabezado.xml` | Encabezado reutilizado con logo, título, regreso y Ocultar. |
| `app/src/main/res/layout/pie_navegacion.xml` | Navegación inferior reutilizada. |
| `app/src/main/res/layout/vista_discreta.xml` | Pantalla discreta superpuesta al contenido. |
| `app/src/main/res/values/strings.xml` | Textos visibles y opciones de los diálogos. |
| `app/src/main/res/values/colors.xml` | Paleta tomada del HTML final. |
| `app/src/main/res/values/themes.xml` | Tipografía, botones, filas y tema común. |
| `app/src/main/res/values-v23/` y `values-v27/` | Adaptaciones de las barras del sistema según la versión de Android. |
| `app/src/main/res/drawable/` | Fondos redondeados e iconos vectoriales. |
| `app/src/main/res/drawable-nodpi/` | Logo original del HTML. |
| `app/src/main/res/xml/data_extraction_rules.xml` | Mantiene las preferencias fuera del respaldo y de la transferencia a otro dispositivo. |
| `app/src/main/res/font/` | Fuentes Inter y Nunito incluidas para funcionar sin red. |
| `licencias/` | Licencias abiertas de ambas familias de fuentes. |
| `docs/` | Explicación del avance, recorrido del código, guion de exposición, capturas y propuesta de base de datos. |

El wrapper, los archivos Gradle en Groovy y las carpetas `app/src/main/java`, `res/layout` y `res/values` continúan cumpliendo la misma función que en el ejemplo. No se han agregado capas de repositorio, API ni persistencia de base de datos.
