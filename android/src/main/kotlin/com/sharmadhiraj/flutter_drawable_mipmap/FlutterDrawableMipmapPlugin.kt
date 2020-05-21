package com.sharmadhiraj.flutter_drawable_mipmap

import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat.PNG
import android.graphics.Bitmap.Config.ARGB_8888
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build.VERSION.SDK_INT
import android.os.Build.VERSION_CODES.N_MR1
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.ByteArrayOutputStream

/** FlutterDrawableMipmapPlugin */
class FlutterDrawableMipmapPlugin(private val registrar: PluginRegistry.Registrar) : MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_drawable_mipmap")
            channel.setMethodCallHandler(FlutterDrawableMipmapPlugin(registrar))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "drawableMipmap") {
            val name: String? = call.argument("name")
            val isDrawable: Boolean = call.argument("is_drawable") ?: false
            val id: Int = registrar.context().resources.getIdentifier(
                    name,
                    if (isDrawable) "drawable" else "mipmap",
                    registrar.context().packageName
            )
            val drawable = ContextCompat.getDrawable(registrar.context(), id)
            val byteArray = if (drawable == null) ByteArray(0) else drawableToByteArray(drawable)
            result.success(byteArray)
        } else {
            result.notImplemented()
        }
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val bitmap = drawableToBitmap(drawable)
        val stream = ByteArrayOutputStream()
        bitmap.compress(PNG, 100, stream)
        return stream.toByteArray()
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        if (SDK_INT <= N_MR1) return (drawable as BitmapDrawable).bitmap
        val bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }

}
