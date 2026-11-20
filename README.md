# Willaricuy

Aplicación Android de acompañamiento y ayuda ante situaciones de violencia, desarrollada en Kotlin con interfaces XML.

## Funciones actuales

- Pantalla de inicio con accesos a Emergencia y Guía y comunidad.
- Perfil y configuración de privacidad, notificaciones e idioma, con preferencias guardadas en el teléfono.
- Opción **Ocultar**, que muestra una vista discreta con fecha y hora.

El proyecto está en desarrollo. Emergencia, comunidad, registro y contactos muestran un mensaje de prueba. Las preferencias se guardan localmente; el idioma de la interfaz sigue siendo español. La conexión con un servidor, las alertas y la autenticación están pendientes.

## Tecnologías

Kotlin, layouts XML, AppCompat y SharedPreferences. Compatible con Android 5.0 (API 21) o superior.

## Ejecutar el proyecto

1. Abre la carpeta `WillaricuyAndroid` en Android Studio.
2. Selecciona **JDK 17** en la configuración de Gradle e instala **Android SDK Platform 32**.
3. Sincroniza el proyecto con Gradle.
4. Selecciona un emulador o teléfono y pulsa **Run**.

Para generar el APK de depuración desde PowerShell con JDK 17 configurado:

```powershell
.\gradlew.bat assembleDebug
```

El APK se genera en `app/build/outputs/apk/debug/app-debug.apk`.

## Estructura

- `app/src/main/java/com/example/willaricuy/`: pantallas y comportamiento de la aplicación.
- `app/src/main/res/`: diseños, textos, colores, imágenes y fuentes.
- `gradle/`: configuración del Gradle Wrapper.
- `licencias/`: licencias de las fuentes Inter y Nunito.
