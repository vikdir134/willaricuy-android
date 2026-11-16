package com.example.willaricuy

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

// Controla Inicio: las tarjetas principales, Perfil y la vista Ocultar.
class MainActivity : AppCompatActivity() {
    private lateinit var vistaDiscreta: VistaDiscreta

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        vistaDiscreta = VistaDiscreta(this)
        findViewById<Button>(R.id.botonOcultar).setOnClickListener { vistaDiscreta.mostrar() }
        findViewById<TextView>(R.id.botonPerfil).setOnClickListener {
            // La configuración se abre como en los ejemplos del curso: con un Intent.
            startActivity(Intent(this, ConfiguracionActivity::class.java))
        }
        findViewById<TextView>(R.id.botonInicio).setTextColor(ContextCompat.getColor(this, R.color.turquesa_oscuro))
        // Los dos accesos quedan como prueba hasta desarrollar sus pantallas.
        val abrirEmergencia = View.OnClickListener { mostrarPrueba() }
        val abrirComunidad = View.OnClickListener { mostrarPrueba() }
        findViewById<View>(R.id.tarjetaEmergencia).setOnClickListener(abrirEmergencia)
        findViewById<Button>(R.id.botonEmergencia).setOnClickListener(abrirEmergencia)
        findViewById<View>(R.id.tarjetaComunidad).setOnClickListener(abrirComunidad)
        findViewById<Button>(R.id.botonComunidad).setOnClickListener(abrirComunidad)
        if (savedInstanceState?.getBoolean("pantallaOculta") == true) vistaDiscreta.mostrar()
    }

    private fun mostrarPrueba() {
        AlertDialog.Builder(this).setMessage(R.string.prueba)
            .setPositiveButton(R.string.aceptar, null).show()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        // Conservamos Ocultar si Android recrea la Activity, por ejemplo al girar.
        outState.putBoolean("pantallaOculta", vistaDiscreta.estaVisible())
        super.onSaveInstanceState(outState)
    }

    @Deprecated("Se conserva este manejo de Atrás para seguir el ejemplo del curso.")
    override fun onBackPressed() {
        if (!vistaDiscreta.volverSiEstaVisible()) super.onBackPressed()
    }
}
