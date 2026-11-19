package com.sharmadhiraj.flutter_drawable_mipmap

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMethodCodec

class FlutterDrawableMipmapPlugin : FlutterPlugin, MethodCallHandler {
    private var channel: MethodChannel? = null
    private var renderer: DrawableRenderer? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        val messenger = binding.binaryMessenger
        renderer = DrawableRenderer(binding.applicationContext)
        channel = MethodChannel(
            messenger,
            CHANNEL_NAME,
            StandardMethodCodec.INSTANCE,
            messenger.makeBackgroundTaskQueue(),
        ).also { it.setMethodCallHandler(this) }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        renderer = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method != METHOD_LOAD) {
            result.notImplemented()
            return
        }
        val renderer = renderer ?: return result.error(ERROR_UNAVAILABLE, "Plugin is detached", null)
        val request = ImageRequest.fromCall(call)
            ?: return result.error(ERROR_INVALID_ARGUMENT, "Unknown image type: ${call.argument<String>("type")}", null)

        try {
            val bytes = renderer.load(request)
            if (bytes == null) {
                result.error(ERROR_NOT_FOUND, "No ${request.type} named \"${request.name}\"", null)
            } else {
                result.success(bytes)
            }
        } catch (e: Exception) {
            result.error(ERROR_RENDER_FAILED, e.message, null)
        }
    }

    private companion object {
        const val CHANNEL_NAME = "flutter_drawable_mipmap"
        const val METHOD_LOAD = "load"
        const val ERROR_NOT_FOUND = "NOT_FOUND"
        const val ERROR_INVALID_ARGUMENT = "INVALID_ARGUMENT"
        const val ERROR_RENDER_FAILED = "RENDER_FAILED"
        const val ERROR_UNAVAILABLE = "UNAVAILABLE"
    }
}
