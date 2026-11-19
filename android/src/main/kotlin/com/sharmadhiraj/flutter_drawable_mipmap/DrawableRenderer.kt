package com.sharmadhiraj.flutter_drawable_mipmap

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.toBitmap
import io.flutter.plugin.common.MethodCall
import java.io.ByteArrayOutputStream
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

internal enum class ImageType(val key: String) {
    DRAWABLE("drawable"),
    MIPMAP("mipmap"),
    SYSTEM("system"),
    APP_ICON("appIcon");

    companion object {
        fun fromKey(key: String?): ImageType? = entries.firstOrNull { it.key == key }
    }
}

/** Sizes are in logical pixels; [scale] converts them to physical pixels. */
internal data class ImageRequest(
    val type: ImageType,
    val name: String,
    val width: Double?,
    val height: Double?,
    val scale: Double,
    val dark: Boolean?,
) {
    companion object {
        fun fromCall(call: MethodCall): ImageRequest? {
            val type = ImageType.fromKey(call.argument("type")) ?: return null
            return ImageRequest(
                type = type,
                name = call.argument("name") ?: "",
                width = call.argument("width"),
                height = call.argument("height"),
                scale = call.argument("scale") ?: 1.0,
                dark = call.argument("dark"),
            )
        }
    }
}

internal class DrawableRenderer(private val context: Context) {

    /** Returns PNG bytes, or null when the resource does not exist. */
    fun load(request: ImageRequest): ByteArray? {
        val themedContext = themedContext(request.dark)
        val drawable = resolveDrawable(themedContext, request) ?: return null
        return encodePng(render(drawable, request))
    }

    private fun themedContext(dark: Boolean?): Context {
        if (dark == null) return context
        val config = Configuration(context.resources.configuration)
        val nightMode = if (dark) Configuration.UI_MODE_NIGHT_YES else Configuration.UI_MODE_NIGHT_NO
        config.uiMode = (config.uiMode and Configuration.UI_MODE_NIGHT_MASK.inv()) or nightMode
        return context.createConfigurationContext(config)
    }

    private fun resolveDrawable(context: Context, request: ImageRequest): Drawable? {
        val resourceId = when (request.type) {
            ImageType.DRAWABLE -> findResource(context, request.name, "drawable", context.packageName)
            ImageType.MIPMAP -> findResource(context, request.name, "mipmap", context.packageName)
            ImageType.SYSTEM -> findResource(context, request.name, "drawable", "android")
            ImageType.APP_ICON -> context.applicationInfo.icon
        }
        if (resourceId == 0) return null
        return try {
            ContextCompat.getDrawable(context, resourceId)
        } catch (_: Resources.NotFoundException) {
            null
        }
    }

    @SuppressLint("DiscouragedApi")
    private fun findResource(context: Context, name: String, type: String, packageName: String): Int {
        if (name.isEmpty()) return 0
        return context.resources.getIdentifier(name, type, packageName)
    }

    private fun render(drawable: Drawable, request: ImageRequest): Bitmap {
        val density = context.resources.displayMetrics.density
        val intrinsicWidth = drawable.intrinsicWidth.takeIf { it > 0 }?.div(density.toDouble())
        val intrinsicHeight = drawable.intrinsicHeight.takeIf { it > 0 }?.div(density.toDouble())
        val (width, height) = targetSize(intrinsicWidth, intrinsicHeight, request.width, request.height)
        return drawable.toBitmap(
            width = toPixels(width, request.scale),
            height = toPixels(height, request.scale),
            config = Bitmap.Config.ARGB_8888,
        )
    }

    /** Fits the intrinsic aspect ratio inside the requested box, like BoxFit.contain. */
    private fun targetSize(
        intrinsicWidth: Double?,
        intrinsicHeight: Double?,
        requestedWidth: Double?,
        requestedHeight: Double?,
    ): Pair<Double, Double> {
        val sourceWidth = intrinsicWidth ?: requestedWidth ?: requestedHeight ?: DEFAULT_SIZE
        val sourceHeight = intrinsicHeight ?: requestedHeight ?: requestedWidth ?: DEFAULT_SIZE
        val ratio = when {
            requestedWidth != null && requestedHeight != null ->
                min(requestedWidth / sourceWidth, requestedHeight / sourceHeight)
            requestedWidth != null -> requestedWidth / sourceWidth
            requestedHeight != null -> requestedHeight / sourceHeight
            else -> 1.0
        }
        return Pair(sourceWidth * ratio, sourceHeight * ratio)
    }

    private fun toPixels(logical: Double, scale: Double): Int = max(1, (logical * scale).roundToInt())

    private fun encodePng(bitmap: Bitmap): ByteArray {
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

    private companion object {
        const val DEFAULT_SIZE = 48.0
    }
}
