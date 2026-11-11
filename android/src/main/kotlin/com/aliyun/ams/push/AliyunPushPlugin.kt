package com.aliyun.ams.push

import android.content.Context
import androidx.annotation.NonNull
import com.alibaba.sdk.android.push.noonesdk.PushInitConfig
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger

/**
 * 阿里云推送 Flutter 插件 - Kotlin 实现
 *
 * 基于 Pigeon 实现，提供类型安全的平台通道通信。
 * SDK 4.x 变更：
 * - 标签接口只支持设备标签
 * - 删除废弃的回调方法
 */
class AliyunPushPlugin : FlutterPlugin {

    companion object {
        @Volatile
        private var instance: AliyunPushPlugin? = null

        /**
         * 获取插件实例
         */
        fun getInstance(): AliyunPushPlugin? = instance
    }

    private var context: Context? = null
    private var pigeonApi: PigeonPushApi? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        instance = this
        this.context = binding.applicationContext

        // 初始化推送服务
        PushServiceFactory.init(context!!)

        // 创建并注册 Pigeon API (Flutter call Native)
        pigeonApi = PigeonPushApi(context!!)
        PushApi.setUp(binding.binaryMessenger, pigeonApi)

        // 初始化事件通道 (Native call Flutter)
        PushEventChannel.init(binding.binaryMessenger, context!!)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }
}