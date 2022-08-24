package com.quellenreiter.quellenreiter_app

import android.app.Application
import com.parse.Parse
import com.parse.ParseInstallation



class App : Application() {
    override fun onCreate() {
        super.onCreate()
        // Parse.enableLocalDatastore(this)
        // ParseObject.registerSubclass(ParseInstallation::class.java)
        Parse.initialize(Parse.Configuration.Builder(this)
                .applicationId(getString(R.string.user_app_id))
                .clientKey(getString(R.string.user_client_key))
                .server(getString(R.string.user_server_url))
                .enableLocalDataStore()
                .build())

        Parse.setLogLevel(Parse.LOG_LEVEL_VERBOSE)
        println("Parse initialized, now uploading installation...")
        val installation = ParseInstallation.getCurrentInstallation()
        installation.put("GCMSenderId", getString(R.string.gms_sender))
        installation.saveInBackground()
    }
}