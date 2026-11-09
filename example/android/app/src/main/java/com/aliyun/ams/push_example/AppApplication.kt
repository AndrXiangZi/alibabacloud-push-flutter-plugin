package com.aliyun.ams.push_example

import android.app.Application
import com.alibaba.sdk.android.push.noonesdk.PushInitConfig
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory

class AppApplication: Application() {

    override fun onCreate() {
        super.onCreate()
        val pushInitConfig = PushInitConfig.Builder()
            .application(this)
            .appKey("335621992")    //请填写你自己的appKey
            .appSecret("c88bac49d3d24c4082e255d35c50ba0a")    //请填写你自己的appSecret
            .build()
        PushServiceFactory.init(pushInitConfig)
    }
}