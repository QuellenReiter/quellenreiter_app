package com.quellenreiter.quellenreiter_app
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.parse.ParseInstallation
import android.app.NotificationManager
import android.content.Context


class MainActivity: FlutterActivity()  {
    private val CHANNEL = "com.quellenreiter.quellenreiter_app/deviceToken"


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
            call, result ->
            if (call.method == "getDeviceToken") {
                val deviceToken = getDeviceToken()

                if (deviceToken != null) {
                    result.success(deviceToken)
                } else {
                    result.error("UNAVAILABLE", "DeviceToken not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceToken(): String {

        val deviceToken: String

        deviceToken = ParseInstallation.getCurrentInstallation().deviceToken

        return deviceToken
    }

    override fun onResume() {
        super.onResume()
        closeAllNotifications();
    }

    private fun closeAllNotifications() {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()
    }
}