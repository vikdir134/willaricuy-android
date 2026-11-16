package com.example.willaricuy

import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

// Inicio y Configuración comparten esta vista para no repetir el comportamiento de Ocultar.
class VistaDiscreta(actividad: AppCompatActivity) {
    private val contenido = actividad.findViewById<View>(R.id.contenidoPantalla)
    private val vista = actividad.findViewById<View>(R.id.vistaDiscreta)
    private val reloj = actividad.findViewById<TextView>(R.id.relojDiscreto)
    private val fecha = actividad.findViewById<TextView>(R.id.fechaDiscreta)

    init {
        actividad.findViewById<TextView>(R.id.botonSalirDiscreto).setOnClickListener { volverSiEstaVisible() }
    }

    fun mostrar() {
        val ahora = Date()
        reloj.text = SimpleDateFormat("HH:mm", Locale.getDefault()).format(ahora)
        fecha.text = DateFormat.getDateInstance(DateFormat.FULL, Locale.getDefault()).format(ahora)
        contenido.visibility = View.INVISIBLE
        vista.visibility = View.VISIBLE
    }

    fun estaVisible(): Boolean = vista.visibility == View.VISIBLE

    fun volverSiEstaVisible(): Boolean {
        if (!estaVisible()) return false
        vista.visibility = View.GONE
        contenido.visibility = View.VISIBLE
        return true
    }
}
