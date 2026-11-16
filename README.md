# Willaricuy · Avance Android 1.1

Frontend nativo en Kotlin basado en el HTML final de Willaricuy. Conserva la estructura del ejemplo del profesor: un módulo `app`, Activities, layouts XML, recursos y archivos Gradle en Groovy.

## Guías para entender y exponer el avance

- [Guía del avance](docs/GUIA_DEL_AVANCE.md): propósito, alcance, funcionamiento y modelo de datos.
- [Recorrido del código](docs/RECORRIDO_DEL_CODIGO.md): qué archivo abrir y qué explicar de cada uno.
- [Guion de exposición](docs/GUION_EXPOSICION.md): demostración de unos siete minutos y preguntas frecuentes.
- [Documento para compartir](docs/Guia_del_avance_y_exposicion.pdf): explicación y guion en PDF.
- [Modelo de datos](docs/base-datos/README.md): script, imagen y explicación de la propuesta de PostgreSQL.
- Capturas: [Inicio](docs/capturas/Inicio.png), [Configuración](docs/capturas/Configuracion.png) y [Vista discreta](docs/capturas/Vista-discreta.png).

## Abrir y ejecutar en Android Studio

1. En Android Studio selecciona **File → Open** y elige la carpeta **WillaricuyAndroid**. Es la carpeta que contiene `settings.gradle`; no selecciones solamente `app`.
2. Abre **Settings → Build, Execution, Deployment → Build Tools → Gradle**. En **Gradle JDK** selecciona **JDK 17**. Puedes elegir una instalación existente o usar **Download JDK** y descargar la versión 17.
3. Sincroniza con **Sync Project with Gradle Files**. Si se solicita, instala **Android SDK Platform 32** desde SDK Manager. En otro equipo necesitarás Internet para descargar las herramientas y dependencias que falten.
4. Selecciona la configuración **app**, elige un emulador o un teléfono con depuración USB y pulsa **Run ▶**.

El JDK integrado de una versión reciente de Android Studio puede ser más nuevo; elige explícitamente JDK 17 para este proyecto.

Android Studio administra `local.properties` con la ruta del SDK de cada equipo. Ese archivo y los resultados de compilación se excluyen de la copia ZIP.

## Qué puedes revisar

- **Inicio:** encabezado con logo y Ocultar, tarjetas Emergencia y Guía y comunidad, navegación inferior Inicio / Perfil.
- **Perfil y configuración:** perfil anónimo, tarjeta de registro y opciones de contactos, privacidad, notificaciones, idioma, Quick Escape, información y ayuda. Puedes deslizar para ver las opciones inferiores.
- **Privacidad y notificaciones:** selección y guardado en `SharedPreferences` del teléfono. Se conservan al cerrar y abrir la aplicación.
- **Idioma:** guarda la preferencia y la muestra en la fila. Este avance mantiene sus textos en español.
- **Ocultar:** muestra una vista discreta con fecha y hora. La barra inferior o Atrás restauran la pantalla anterior. Es una vista de la aplicación, no un bloqueo real del teléfono.

Emergencia, comunidad, contactos, registro, Acerca de y Centro de ayuda muestran únicamente **Prueba** al pulsarlos. Quick Escape abre directamente la vista discreta. Guardar preferencias no muestra avisos emergentes adicionales. Esta entrega no envía alertas, no realiza llamadas y no autentica usuarios. No incluye servidor, conexión a PostgreSQL ni permisos de Internet o ubicación.

## Organización del código

```text
WillaricuyAndroid/
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/com/example/willaricuy/
│       │   ├── MainActivity.kt
│       │   ├── ConfiguracionActivity.kt
│       │   └── VistaDiscreta.kt
│       └── res/
│           ├── drawable/         Iconos y fondos XML
│           ├── drawable-nodpi/   Logo original del HTML
│           ├── font/             Inter y Nunito
│           ├── layout/           Pantallas y partes compartidas
│           ├── values/           Textos, colores y estilos
│           ├── values-v23/       Barras del sistema desde API 23
│           ├── values-v27/       Barras del sistema desde API 27
│           ├── values-night/
│           └── xml/              Reglas de respaldo local
├── gradle/wrapper/
├── licencias/
├── build.gradle
├── settings.gradle
└── gradlew.bat
```

El código Kotlin está dentro de `java/com/example/willaricuy`. El paquete, el namespace y el identificador de instalación son `com.example.willaricuy`. El nombre de la app y del proyecto es Willaricuy.

Los elementos se obtienen con `findViewById`. Las Activities controlan la navegación y los diálogos; los XML contienen los diseños. Los textos, colores y estilos están centralizados en `res/values`. Hay comentarios breves en Kotlin para explicar el guardado local y el comportamiento compartido.

## Versiones conservadas del ejemplo

| Componente | Versión |
| --- | --- |
| Android Gradle Plugin | 7.3.1 |
| Gradle Wrapper | 7.4 |
| Kotlin | 1.7.20 |
| compileSdk / targetSdk | 32 / 32 |
| minSdk | 21 |
| JDK para ejecutar Gradle | 17 |
| Nivel de bytecode Java / Kotlin | 1.8 |

Se mantienen estas versiones para continuar el proyecto académico con la misma base. Una actualización de herramientas se puede hacer por separado más adelante.

## Verificación de esta entrega

Se generó el APK de depuración con `assembleDebug` y se ejecutó `lintDebug` sin errores. Se revisaron las dos pantallas en un emulador Android API 37, la navegación, los diálogos, el guardado de preferencias tras reiniciar la app y la vista Ocultar. El APK es una compilación de depuración para revisar el avance.

Para compilar desde PowerShell con JDK 17 seleccionado:

```powershell
.\gradlew.bat assembleDebug lintDebug
```

El resultado aparece en `app/build/outputs/apk/debug/app-debug.apk`.

Consulta `CAMBIOS_RESPECTO_AL_EJEMPLO.md` para ubicar cada modificación. Las licencias de las fuentes están en `licencias/`.
