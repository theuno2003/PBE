MainActivity.kt

package com.example.clienteandroid








import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder




class MainActivity : AppCompatActivity() {


   override fun onCreate(savedInstanceState: Bundle?) {
       super.onCreate(savedInstanceState)
       setContentView(R.layout.activity_main)


       val usernameEditText = findViewById<EditText>(R.id.username_edit_text)
       val passwordEditText = findViewById<EditText>(R.id.password_edit_text)
       val loginButton = findViewById<Button>(R.id.login_button)


       loginButton.setOnClickListener {
           iniciarSesion()
       }
   }




   fun iniciarSesion() {
       val thread = Thread {
           try {
               val charset = "UTF-8"
               val ip = "192.168.1.199"
               val edCedula = findViewById<EditText>(R.id.username_edit_text)
               val edContrasena = findViewById<EditText>(R.id.password_edit_text)


               val cedula = edCedula.text.toString()
               val contrasena = edContrasena.text.toString()


               val query = String.format("?cedula=%s&contrasena=%s",
                   URLEncoder.encode(cedula, charset),
                   URLEncoder.encode(contrasena, charset))


               val context = applicationContext


               val url = URL(String.format("http://%s:3001/%s", ip, query))
               val urlConnection = url.openConnection() as HttpURLConnection
               urlConnection.requestMethod = "GET"
               urlConnection.setRequestProperty("Accept-Charset", charset)
               urlConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=$charset")
               val rd = BufferedReader(InputStreamReader(
                   urlConnection.inputStream))


               val jsonResponse = rd.readLine()


               val jsonValue = JSONObject(jsonResponse)
               val code = jsonValue.getInt("code")


               if (code == 200) {
                   val data = jsonValue.getJSONObject("data")
                   val nombre = data.getString("nombre")
                   val apellido = data.getString("apellido")
                   val telefono = data.getString("telefono")


                   runOnUiThread {
                       Toast.makeText(context, "Welcome!", Toast.LENGTH_SHORT).show()
                   }


                   // Passing data to another Activity
                   val i = Intent(this@MainActivity, LoginSuccessActivity::class.java)
                   i.putExtra("cedula", cedula)
                   i.putExtra("contrasena", contrasena)
                   i.putExtra("nombre", nombre)
                   i.putExtra("apellido", apellido)
                   i.putExtra("telefono", telefono)
                   startActivity(i)
               } else {
                   runOnUiThread {
                       Toast.makeText(context, "Wrong credentials!", Toast.LENGTH_SHORT).show()
                   }
               }
           } catch (e: Exception) {
               Log.d("Error on sign up", "Ocurrió un error al intentar iniciar sesión.")
               Log.d("Error on sign up", e.toString())
           }
       }


       if (thread.isAlive) {
           // Ending thread after there was a successful login
           thread.interrupt()
       }


       thread.start()
   }
}



LoginSuccessActivity.kt

package com.example.clienteandroid


import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity


class LoginSuccessActivity : AppCompatActivity() {


   override fun onCreate(savedInstanceState: Bundle?) {
       super.onCreate(savedInstanceState)
       setContentView(R.layout.activity_login_success)
       val nombreTextView = findViewById<TextView>(R.id.nombreTextView)
       val nombre = intent.getStringExtra("nombre")
       nombreTextView.text = "Bienvenido, $nombre!" //
   }
}


Activity_login_success

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
   android:layout_width="match_parent"
   android:layout_height="match_parent">






   <LinearLayout
       android:layout_width="match_parent"
       android:layout_height="wrap_content"
       android:orientation="vertical">


       <TextView
           android:id="@+id/nombreTextView"
           android:layout_width="match_parent"
           android:layout_height="wrap_content"
           android:text="Inicio de sesion correcto"
           android:textSize="30sp" />


   </LinearLayout>


</LinearLayout>

Activity_main


<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
   xmlns:app="http://schemas.android.com/apk/res-auto"
   xmlns:tools="http://schemas.android.com/tools"
   android:id="@+id/linearLayout"
   android:layout_width="match_parent"
   android:orientation="vertical"
   android:layout_height="match_parent">




   <LinearLayout
       android:layout_width="match_parent"
       android:layout_height="wrap_content"
       android:orientation="vertical">


       <TextView
           android:layout_width="384dp"
           android:layout_height="wrap_content"
           android:text="Usuario"
           android:textSize="30sp" />


       <EditText
           android:id="@+id/username_edit_text"
           android:layout_width="384dp"
           android:layout_height="wrap_content"
           android:hint="usuario"
           android:padding="20sp" />


   </LinearLayout>


   <LinearLayout
       android:layout_width="match_parent"
       android:layout_height="wrap_content"
       android:orientation="vertical">
   <TextView
       android:layout_width="392dp"
       android:layout_height="wrap_content"
       android:text="Contraseña"
       android:textSize="30sp" />


   <EditText
       android:id="@+id/password_edit_text"
       android:layout_width="388dp"
       android:layout_height="wrap_content"
       android:hint="contraseña"
       android:padding="20sp" />
   </LinearLayout>
  
   <LinearLayout
       android:layout_width="match_parent"
       android:layout_height="wrap_content"
       android:orientation="vertical">




   </LinearLayout>


   <Button
       android:id="@+id/login_button"
       android:layout_width="wrap_content"
       android:layout_height="wrap_content"
       android:text="Entrar"
       android:onClick="iniciarSesion"/>


</LinearLayout>
