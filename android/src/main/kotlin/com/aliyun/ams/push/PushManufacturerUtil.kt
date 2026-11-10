package com.aliyun.ams.push

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.text.TextUtils
import com.heytap.msp.push.HeytapPushManager
import com.hihonor.push.sdk.HonorPushCallback
import com.hihonor.push.sdk.HonorPushClient
import com.huawei.hms.aaid.HmsInstanceId
import com.meizu.cloud.pushsdk.PushManager
import com.meizu.cloud.pushsdk.utils.MzSystemUtils
import com.vivo.push.PushClient
import com.vivo.push.listener.IPushQueryActionListener
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext

object PushManufacturerUtil {

    fun supportHuaweiPush():Boolean{
        var result = Build.BRAND.equals("huawei", ignoreCase = true)
        if (!result) {
            val emuiVersion = getProp("ro.build.version.emui")
            val harmonyVersion = getProp("hw_sc.build.platform.version")
            result = !TextUtils.isEmpty(emuiVersion) || !TextUtils.isEmpty(harmonyVersion)
        }
        return result && Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1
    }

    private fun getProp(key: String): String {
        var value = ""
        try {
            val cls = Class.forName("android.os.SystemProperties")
            val get = cls.getDeclaredMethod("get", String::class.java)
            value = get.invoke(null as Any?, key) as String
        } catch (ignored: Throwable) {
        }
        return value
    }

    fun supportHonorPush(context: Context): Boolean {
        return HonorPushClient.getInstance().checkSupportHonorPush(context)
    }

    fun supportXIAOMIPush(): Boolean {
        val brand = if (TextUtils.isEmpty(Build.BRAND)) Build.MANUFACTURER else Build.BRAND
        return "xiaomi" == brand.lowercase() || "redmi" == brand.lowercase() || "blackshark" ==brand.lowercase()
    }

    fun supportVIVOPush(context: Context): Boolean{
        return PushClient.getInstance(context).isSupport
    }

    fun supportOPPOPush(context: Context): Boolean {
        return HeytapPushManager.isSupportPush(context)
    }

    fun supportMEIZUPush(): Boolean {
        return try {
            var var1 = getProp("ro.meizu.product.model")
            var flag = (!TextUtils.isEmpty(var1) || "meizu".equals(Build.BRAND, ignoreCase = true)
                    || "22c4185e".equals(Build.BRAND, ignoreCase = true))
            if (!flag) {
                var1 = getProp("ro.product.other.brand")
                flag = var1.equals("Unisoc", ignoreCase = true)
            }
            flag
        } catch (e: Throwable) {
            // 直接调用判断，其内部会起不必要线程发POST请求
            MzSystemUtils.isBrandMeizu()
        }
    }
}