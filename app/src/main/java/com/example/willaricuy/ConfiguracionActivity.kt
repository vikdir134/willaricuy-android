package com.example.willaricuy

import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

// Reúne los ajustes del perfil y guarda las preferencias en el teléfono.
class ConfiguracionActivity : AppCompatActivity() {
    private lateinit var preferencias: SharedPreferences
    private lateinit var vistaDiscreta: VistaDiscreta

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_configuracion)
        // Estas preferencias solo viven en el teléfono. No hay conexión con la BBDD.
        preferencias = getSharedPreferences("preferenciasWillaricuy", MODE_PRIVATE)
        vistaDiscreta = VistaDiscreta(this)
        findViewById<ImageButton>(R.id.botonVolver).apply {
            visibility = View.VISIBLE
            setOnClickListener { finish() }
        }
        findViewById<TextView>(R.id.tituloEncabezado).setText(R.string.perfil)
        findViewById<Button>(R.id.botonOcultar).setOnClickListener { vistaDiscreta.mostrar() }
        // finish evita apilar otra pantalla de Inicio cada vez que volvemos.
        findViewById<TextView>(R.id.botonInicio).setOnClickListener { finish() }
        findViewById<TextView>(R.id.botonInicio).setTextColor(ContextCompat.getColor(this, R.color.texto_secundario))
        findViewById<TextView>(R.id.botonPerfil).setTextColor(ContextCompat.getColor(this, R.color.turquesa_oscuro))
        // Estas opciones todavía no tienen su módulo; solo muestran Prueba.
        findViewById<Button>(R.id.botonRegistro).setOnClickListener { mostrarPrueba() }
        findViewById<View>(R.id.filaContactos).setOnClickListener { mostrarPrueba() }
        findViewById<View>(R.id.filaPrivacidad).setOnClickListener { mostrarPrivacidad() }
        findViewById<View>(R.id.filaNotificaciones).setOnClickListener { mostrarNotificaciones() }
        findViewById<View>(R.id.filaIdioma).setOnClickListener { mostrarIdiomas() }
        findViewById<View>(R.id.filaQuickEscape).setOnClickListener { vistaDiscreta.mostrar() }
        findViewById<View>(R.id.filaAcerca).setOnClickListener { mostrarPrueba() }
        findViewById<View>(R.id.filaAyuda).setOnClickListener { mostrarPrueba() }
        actualizarIdioma()
        if (savedInstanceState?.getBoolean("pantallaOculta") == true) vistaDiscreta.mostrar()
    }

    private fun mostrarPrivacidad() {
        // Trabajamos con una copia de la selección; Cancelar no guarda cambios.
        val seleccion = booleanArrayOf(preferencias.getBoolean("compartirUbicacion", true), preferencias.getBoolean("guardarHistorial", true))
        AlertDialog.Builder(this).setTitle(R.string.privacidad)
            .setMultiChoiceItems(R.array.opciones_privacidad, seleccion) { _, posicion, marcada -> seleccion[posicion] = marcada }
            .setPositiveButton(R.string.guardar) { _, _ ->
                preferencias.edit().putBoolean("compartirUbicacion", seleccion[0]).putBoolean("guardarHistorial", seleccion[1]).apply()
            }.setNegativeButton(R.string.cancelar, null).show()
    }

    private fun mostrarNotificaciones() {
        val claves = arrayOf("notificarAlertas", "notificarForo", "notificarBienestar")
        val seleccion = booleanArrayOf(preferencias.getBoolean(claves[0], true), preferencias.getBoolean(claves[1], true), preferencias.getBoolean(claves[2], false))
        AlertDialog.Builder(this).setTitle(R.string.notificaciones)
            .setMultiChoiceItems(R.array.opciones_notificaciones, seleccion) { _, posicion, marcada -> seleccion[posicion] = marcada }
            .setPositiveButton(R.string.guardar) { _, _ ->
                val editor = preferencias.edit()
                for (posicion in claves.indices) editor.putBoolean(claves[posicion], seleccion[posicion])
                editor.apply()
            }.setNegativeButton(R.string.cancelar, null).show()
    }

    private fun mostrarIdiomas() {
        val idiomas = resources.getStringArray(R.array.opciones_idioma)
        var elegido = idiomas.indexOf(preferencias.getString("idioma", idiomas[0])).coerceAtLeast(0)
        AlertDialog.Builder(this).setTitle(R.string.idioma)
            .setSingleChoiceItems(idiomas, elegido) { _, posicion -> elegido = posicion }
            .setPositiveButton(R.string.guardar) { _, _ ->
                preferencias.edit().putString("idioma", idiomas[elegido]).apply()
                actualizarIdioma()
            }.setNegativeButton(R.string.cancelar, null).show()
    }

    private fun actualizarIdioma() {
        val idioma = preferencias.getString("idioma", resources.getStringArray(R.array.opciones_idioma)[0])
        findViewById<TextView>(R.id.textoIdioma).text = getString(R.string.idioma_elegido, idioma)
    }

    private fun mostrarPrueba() {
        AlertDialog.Builder(this).setMessage(R.string.prueba)
            .setPositiveButton(R.string.aceptar, null).show()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        outState.putBoolean("pantallaOculta", vistaDiscreta.estaVisible())
        super.onSaveInstanceState(outState)
    }

    @Deprecated("Se conserva este manejo de Atrás para seguir el ejemplo del curso.")
    override fun onBackPressed() { if (!vistaDiscreta.volverSiEstaVisible()) super.onBackPressed() }
}
