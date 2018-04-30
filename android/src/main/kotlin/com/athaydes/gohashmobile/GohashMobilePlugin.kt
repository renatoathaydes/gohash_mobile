package com.athaydes.gohashmobile

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import mobileapi.Database
import mobileapi.Mobileapi

class GohashMobilePlugin() : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "gohash_mobile")
            channel.setMethodCallHandler(GohashMobilePlugin())
        }
    }

    private inline fun <reified T> readArgument(args: List<*>, index: Int): T {
        if (index < args.size) {
            val argument = args[index]
            if (argument is T) {
                return argument
            } else {
                throw IllegalArgumentException("Argument at index $index " +
                        "has unexpected type: ${argument?.javaClass?.name}")
            }
        }
        throw IllegalArgumentException("No argument available at index $index")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getDb") {
            val args = call.arguments
            if (args is List<*>) {
                if (args.size == 2) {
                    try {
                        val dbPath = readArgument<String>(args, 0)
                        val password = readArgument<String>(args, 1)
                        val db = Mobileapi.readDatabase(dbPath, password)
                        result.success(androidDatabaseFrom(db))
                    } catch (e: IllegalArgumentException) {
                        result.error("BAD_ARGS", e.message!!, null)
                    } catch (e: Exception) {
                        result.error("NATIVE_ERR", e.message!!, null)
                    }
                } else {
                    result.error("BAD_ARGS",
                            "Wrong arg count (getDb expects 2 args): ${args.size}", null)
                }
            } else {
                result.error("BAD_ARGS", "Wrong argument types", null)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun androidDatabaseFrom(db: Database): Map<String, List<Map<String, Any>>> {
        val result = HashMap<String, List<Map<String, Any>>>()
        val iterator = db.iter()
        do {
            val item = iterator.next()?.apply {
                val entries = mutableListOf<Map<String, Any>>()
                result[group] = entries
                do {
                    val entry = next()?.apply {
                        val loginInfo = mapOf<String, Any>(
                                "name" to name(),
                                "username" to username(),
                                "password" to password(),
                                "url" to url(),
                                "description" to description(),
                                "updatedAt" to updatedAt())
                        entries.add(loginInfo)
                    }
                } while (entry != null)
            }
        } while (item != null)

        return result
    }

}
