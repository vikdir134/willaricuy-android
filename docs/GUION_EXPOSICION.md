# Guion de exposición y demostración

Duración sugerida: siete minutos. Puedes repartir los bloques entre los integrantes sin cambiar el orden.

## Antes de presentar

Abre el proyecto con JDK 17, sincroniza y ejecuta la app. Deja visible Inicio. Ten preparados los XML y las clases del recorrido del código, la imagen del modelo de datos y esta guía.

## 0:00 a 0:45 · Problema y objetivo

**Qué mostrar:** Inicio.

**Qué decir:** «Willaricuy es una propuesta de ayuda y acompañamiento que desarrollamos primero como prototipo de IHC. En este avance trasladamos su diseño a una aplicación Android nativa. Buscamos dejar lista una base visual y una navegación sencilla para continuar el desarrollo en Kotlin».

## 0:45 a 1:45 · Diseño principal

**Qué hacer:** señalar el encabezado, las dos tarjetas y la navegación inferior. Pulsar una tarjeta y cerrar el diálogo Prueba.

**Qué decir:** «Conservamos los colores y la organización del HTML: amarillo para Emergencia, azul para Guía y comunidad y turquesa en los elementos comunes. El encabezado y la barra inferior se reutilizan. Las acciones pendientes muestran Prueba; todavía no envían alertas ni acceden a servicios externos».

## 1:45 a 3:00 · Configuración y preferencias

**Qué hacer:** tocar Perfil, abrir Privacidad, cambiar una opción y Guardar. Volver a abrirla para mostrar el valor. Abrir Notificaciones e Idioma y deslizar para ver las filas inferiores.

**Qué decir:** «La pantalla de configuración ya permite interactuar con algunas preferencias. Se guardan en SharedPreferences del dispositivo. Guardar conserva la selección y Cancelar la descarta. Idioma registra una elección, pero la traducción de todo el contenido queda pendiente».

Si quieres mostrar persistencia al reiniciar, cierra y abre la app antes de presentar o reserva unos segundos adicionales. No borres sus datos ni la reinstales durante esa demostración.

## 3:00 a 3:40 · Ocultar

**Qué hacer:** tocar Ocultar o Quick Escape; regresar con la barra inferior o Atrás.

**Qué decir:** «Las dos pantallas comparten una vista discreta. Una clase llamada VistaDiscreta cambia la visibilidad del contenido y muestra hora y fecha. La vista permite regresar a la aplicación; no bloquea el teléfono».

## 3:40 a 5:10 · Código y organización

**Qué mostrar:** MainActivity junto con activity_main; después ConfiguracionActivity y colors.xml.

**Qué decir:** «Seguimos la estructura del ejemplo de clase: un módulo app, Activities en Kotlin y layouts XML. Los IDs del XML se obtienen con findViewById y sus listeners ejecutan las acciones. Un Intent abre Configuración y finish regresa a Inicio. Los colores, textos y estilos están centralizados para evitar repetirlos por toda la aplicación».

Señala un caso concreto: `botonPerfil` en el XML y su listener en MainActivity. Después muestra `mostrarPrivacidad` como ejemplo de lectura y guardado local.

## 5:10 a 6:20 · Modelo de datos

**Qué mostrar:** `base-datos/02_modelo_relacional.png`; ampliar un módulo para que sus campos se lean.

**Qué decir:** «También preparamos el script PostgreSQL y la justificación del modelo. Hay 23 tablas y 34 claves foráneas. Separamos usuarios y contactos, alertas y ubicación privada, profesionales y mensajes, comunidad y moderación, e incidentes por distrito. Una publicación del foro no equivale automáticamente a un incidente del mapa. El script se validó de forma estática, pero no se ha desplegado ni conectado a Android».

## 6:20 a 7:00 · Alcance y continuidad

**Qué decir:** «El resultado actual es un frontend ejecutable, con Inicio, Configuración, navegación, preferencias locales y vista discreta. Se preparó una propuesta de datos y se organizó el código en un repositorio. Los siguientes avances incorporarán los módulos pendientes y, cuando corresponda, backend y base de datos. En esta versión las opciones pendientes se identifican con Prueba».

## Preguntas que pueden hacer

| Pregunta | Respuesta concreta |
| --- | --- |
| ¿La app envía una alerta real? | Todavía no. La tarjeta muestra Prueba y no ejecuta comunicaciones. |
| ¿Dónde están guardados los ajustes? | En SharedPreferences del dispositivo. |
| ¿La base de datos está en la nube? | No. Se prepararon el script, el modelo y su explicación. |
| ¿Por qué Kotlin y XML? | Es la base del proyecto académico y permite relacionar la lógica con los diseños del ejemplo. |
| ¿La opción de idioma traduce todo? | No. Guarda la preferencia y actualiza su etiqueta. |
| ¿Quick Escape bloquea el teléfono? | No. Cambia la vista dentro de la aplicación. |
| ¿Por qué separar publicaciones e incidentes? | Una publicación puede ser una pregunta o un agradecimiento; no debe contarse siempre como un caso. |
| ¿Qué cambió en esta revisión? | Se unificó el nombre Willaricuy, se simplificaron los mensajes y se documentó el código. |
