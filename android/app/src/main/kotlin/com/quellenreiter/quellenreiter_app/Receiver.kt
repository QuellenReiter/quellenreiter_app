package com.quellenreiter.quellenreiter_app
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import android.widget.Toast
import com.parse.ParsePushBroadcastReceiver

private const val TAG = "Receiver"

class Receiver : ParsePushBroadcastReceiver() {

    override fun onPushOpen(context: Context, intent: Intent) {
        Log.d("Push", "Push notification received")
        val pm = context.getPackageManager()
        val intent = pm.getLaunchIntentForPackage(context.getPackageName())
        context.applicationContext.startActivity(intent)
    
    }
}
