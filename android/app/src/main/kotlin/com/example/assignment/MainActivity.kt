package com.example.assignment

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.imagepicker.ImagePickerPlugin

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SqflitePlugin.registerWith(registrarFor("com.tekartik.sqflite.SqflitePlugin"))

    }

}
