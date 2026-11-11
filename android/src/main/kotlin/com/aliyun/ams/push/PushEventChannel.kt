package com.aliyun.ams.push

import android.content.Context
import io.flutter.plugin.common.MethodChannel

/**
 * 推送事件通道
 *
 * 使用 MethodChannel 实现事件传递（Native → Flutter）
 */
object PushEventChannel {
    private var channel: MethodChannel? = null

    /**
     * 初始化事件通道
     */
    fun init(messenger: io.flutter.plugin.common.BinaryMessenger, context: Context) {
        if (channel != null) return
        channel = MethodChannel(messenger, "com.aliyun.ams.push/event")
    }

    /**
     * 清理事件通道
     */
    fun dispose() {
        channel = null
    }

    /**
     * 发送通知到达事件
     */
    fun onNotification(title: String?, summary: String?, extras: Map<String, String>?) {
        val data = mutableMapOf<String, Any?>(
            "title" to title,
            "summary" to summary
        )
        extras?.let { data.putAll(it) }
        sendEvent("onNotification", data)
    }

    /**
     * 发送消息到达事件
     */
    fun onMessage(title: String?, content: String?, messageId: String?, appId: String?, traceInfo: String?) {
        val data = mapOf<String, Any?>(
            "title" to title,
            "content" to content,
            "messageId" to messageId,
            "appId" to appId,
            "traceInfo" to traceInfo
        )
        sendEvent("onMessage", data)
    }

    /**
     * 发送通知打开事件
     */
    fun onNotificationOpened(title: String?, summary: String?, extras: Map<String, String>?) {
        val data = mutableMapOf<String, Any?>(
            "title" to title,
            "summary" to summary
        )
        extras?.let { data.putAll(it) }
        sendEvent("onNotificationOpened", data)
    }

    /**
     * 发送通知移除事件
     */
    fun onNotificationRemoved(messageId: String?) {
        val data = mapOf<String, Any?>(
            "messageId" to messageId
        )
        sendEvent("onNotificationRemoved", data)
    }

    /**
     * iOS 通道打开事件
     */
    fun onChannelOpened() {
        val data = mapOf<String, Any?>(
            "type" to "onChannelOpened"
        )
        sendEvent("onChannelOpened", data)
    }

    /**
     * iOS APNs 注册成功事件
     */
    fun onRegisterDeviceTokenSuccess(apnsDeviceToken: String?) {
        val data = mapOf<String, Any?>(
            "apnsDeviceToken" to apnsDeviceToken
        )
        sendEvent("onRegisterDeviceTokenSuccess", data)
    }

    /**
     * iOS APNs 注册失败事件
     */
    fun onRegisterDeviceTokenFailed(error: String?) {
        val data = mapOf<String, Any?>(
            "error" to error
        )
        sendEvent("onRegisterDeviceTokenFailed", data)
    }

    /**
     * 发送事件到 Flutter
     */
    private fun sendEvent(method: String, arguments: Map<String, Any?>) {
        channel?.invokeMethod(method, arguments)
            ?: AliyunPushLog.e("PushEventChannel", "Channel not initialized, skip event: $method")
    }
}