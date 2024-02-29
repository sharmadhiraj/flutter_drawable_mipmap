package com.sharmadhiraj.flutter_drawable_mipmap

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream

/** FlutterDrawableMipmapPlugin  */
class FlutterDrawableMipmapPlugin : FlutterPlugin, MethodCallHandler {
    private var channel: MethodChannel? = null
    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_drawable_mipmap")
        channel?.setMethodCallHandler(this)
    }


    override
    fun onMethodCall(call: MethodCall, result: Result) {
        if (context == null) return
        if (call.method.equals("drawableMipmap")) {
            val name: String? = call.argument("name")
            val isDrawable: Boolean = call.argument("is_drawable") ?: false
            val id: Int? = context?.resources?.getIdentifier(
                name,
                if (isDrawable) "drawable" else "mipmap",
                context?.packageName
            )
            val drawable: Drawable? = ContextCompat.getDrawable(context!!, id!!)
            val byteArray = drawableToByteArray(drawable)
            result.success(byteArray)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    private fun drawableToByteArray(drawable: Drawable?): ByteArray {
        if (drawable == null) {
            Log.e("FlutterDrawableMipmap", "Drawable is null")
            return ByteArray(0)
        }
        val bitmap: Bitmap = (drawable as BitmapDrawable).bitmap
        val stream = ByteArrayOutputStream()
        bitmap.compress(CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

}
