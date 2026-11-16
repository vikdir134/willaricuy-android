# Recorrido del código para explicar el avance

Las rutas de esta guía son relativas a la raíz que se abre en Android Studio. El panel puede mostrarse en vista **Android** o **Project**; en Project verás la estructura física completa.

## 1. Arranque y nombre de la app

Abre [`settings.gradle`](../settings.gradle) y muestra `rootProject.name`. Después abre [`app/build.gradle`](../app/build.gradle): `namespace` organiza los recursos generados y `applicationId` identifica la app instalada. Ambos usan `com.example.willaricuy`.

En [`AndroidManifest.xml`](../app/src/main/AndroidManifest.xml), `android:label` toma el nombre de `strings.xml`, `android:theme` selecciona el tema y el filtro MAIN / LAUNCHER indica que Android debe abrir `MainActivity`.

## 2. Pantalla de Inicio

Abre [`MainActivity.kt`](../app/src/main/java/com/example/willaricuy/MainActivity.kt).

1. `onCreate` carga `activity_main` mediante `setContentView`.
2. `findViewById` obtiene los botones y tarjetas a partir de los IDs escritos en XML.
3. `setOnClickListener` asigna las acciones de cada control.
4. El botón Perfil crea un `Intent` hacia `ConfiguracionActivity`.
5. `mostrarPrueba` muestra el diálogo de las dos tarjetas principales.
6. `onSaveInstanceState` conserva si la vista discreta estaba visible al recrearse la Activity.

Después abre [`activity_main.xml`](../app/src/main/res/layout/activity_main.xml). El contenedor exterior permite colocar la vista discreta sobre el contenido. El contenido normal combina un encabezado, una zona central con desplazamiento y la navegación inferior. Busca `tarjetaEmergencia`, `botonEmergencia`, `tarjetaComunidad` y `botonComunidad` para conectar la vista con sus listeners en Kotlin.

## 3. Perfil y configuración

Abre [`ConfiguracionActivity.kt`](../app/src/main/java/com/example/willaricuy/ConfiguracionActivity.kt) junto con [`activity_configuracion.xml`](../app/src/main/res/layout/activity_configuracion.xml).

| Parte de Kotlin | Qué explicar |
| --- | --- |
| `getSharedPreferences` | Abre el almacenamiento local de preferencias. |
| Listeners de las filas | Relacionan cada opción visual con un diálogo o una acción. |
| `mostrarPrivacidad` | Lee dos valores, permite seleccionarlos y los guarda al aceptar. |
| `mostrarNotificaciones` | Maneja tres valores mediante un arreglo de claves. |
| `mostrarIdiomas` | Guarda una elección y actualiza su texto; no traduce la aplicación. |
| `actualizarIdioma` | Escribe la selección en `textoIdioma`. |
| `mostrarPrueba` | Identifica las opciones que aún son demostrativas. |
| `finish()` | Regresa a Inicio sin crear otra copia de esa Activity. |

Los comentarios de Kotlin señalan la finalidad general de estas partes. No es necesario leer cada instrucción durante la exposición: muestra la relación XML → ID → listener → acción.

## 4. Vista discreta compartida

Abre [`VistaDiscreta.kt`](../app/src/main/java/com/example/willaricuy/VistaDiscreta.kt) y [`vista_discreta.xml`](../app/src/main/res/layout/vista_discreta.xml).

- `mostrar` coloca la hora y fecha actuales, oculta el contenido normal y muestra la vista discreta.
- `estaVisible` consulta su estado.
- `volverSiEstaVisible` restaura el contenido y devuelve si realizó el cambio.
- Las dos Activities llaman ese método al pulsar Atrás. La barra inferior también permite regresar.

Se usa una clase pequeña para compartir este comportamiento sin repetirlo en ambas pantallas. No es una pantalla de bloqueo del sistema y el reloj se actualiza al abrir la vista.

## 5. Diseño y elementos reutilizados

| Archivo o carpeta | Para qué sirve |
| --- | --- |
| [`encabezado.xml`](../app/src/main/res/layout/encabezado.xml) | Logo, título, flecha de regreso y Ocultar. |
| [`pie_navegacion.xml`](../app/src/main/res/layout/pie_navegacion.xml) | Accesos Inicio / Perfil. |
| [`strings.xml`](../app/src/main/res/values/strings.xml) | Textos y listas de opciones. El mensaje Prueba se define una sola vez. |
| [`colors.xml`](../app/src/main/res/values/colors.xml) | Paleta del diseño: turquesa, amarillo de Emergencia y azul de Comunidad. |
| [`themes.xml`](../app/src/main/res/values/themes.xml) | Tema, títulos, cuerpo, botones y filas. |
| `res/drawable` | Iconos vectoriales y fondos redondeados. |
| `res/drawable-nodpi` | Logo original. |
| `res/font` | Inter y Nunito incluidas para no descargarlas al ejecutar la app. |
| `res/values-v23` y `res/values-v27` | Barras del sistema según la versión de Android. |
| `res/xml/data_extraction_rules.xml` | Excluye los datos locales de respaldo y transferencia. |

## 6. Orden recomendado al presentar Android Studio

Muestra primero la app funcionando. Luego abre MainActivity + activity_main, ConfiguracionActivity + activity_configuracion, VistaDiscreta y los archivos de colores/textos. Cierra con el modelo de datos y aclara que todavía es una propuesta independiente del frontend.
