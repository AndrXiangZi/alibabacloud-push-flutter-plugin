package com.aliyun.ams.push

import io.flutter.plugin.common.BinaryMessenger

/**
 * Pigeon 事件回调处理器
 *
 * 负责将原生推送事件回调到 Flutter 端
 * 使用 Pigeon 的 PushEventCallback 实现类型安全的通信
 */
object PushEventCallbackHandler {

    private var eventCallback: PushEventCallback? = null

    /**
     * 初始化事件回调
     *
     * @param messenger Flutter BinaryMessenger
     */
    fun init(messenger: BinaryMessenger) {
        eventCallback = PushEventCallback(messenger)
    }

    /**
     * 清理事件回调
     */
    fun dispose() {
        eventCallback = null
    }

    /**
     * 通知到达回调
     *
     * @param title 通知标题
     * @param summary 通知摘要
     * @param extras 额外参数
     */
    fun onNotification(title: String?, summary: String?, extras: Map<String, String>?) {
        eventCallback?.let { callback ->
            val notification = NotificationData(
                title = title,
                summary = summary,
                extras = extras
            )
            callback.onNotification(notification) { result ->
                result.onSuccess {
                    AliyunPushLog.d("PushEventCallback", "onNotification success")
                }.onFailure { error ->
                    AliyunPushLog.e("PushEventCallback", "onNotification failed: $error")
                }
            }
        }
    }

    /**
     * 消息到达回调
     *
     * @param title 消息标题
     * @param content 消息内容
     * @param messageId 消息ID
     * @param appId 应用ID
     * @param traceInfo 追踪信息
     */
    fun onMessage(title: String?, content: String?, messageId: String?, appId: String?, traceInfo: String?) {
        eventCallback?.let { callback ->
            val message = MessageData(
                title = title,
                content = content,
                messageId = messageId,
                appId = appId,
                traceInfo = traceInfo
            )
            callback.onMessage(message) { result ->
                result.onSuccess {
                    AliyunPushLog.d("PushEventCallback", "onMessage success")
                }.onFailure { error ->
                    AliyunPushLog.e("PushEventCallback", "onMessage failed: $error")
                }
            }
        }
    }

    /**
     * 通知打开回调
     *
     * @param title 通知标题
     * @param summary 通知摘要
     * @param extras 额外参数
     */
    fun onNotificationOpened(title: String?, summary: String?, extras: Map<String, String>?) {
        eventCallback?.let { callback ->
            val notification = NotificationData(
                title = title,
                summary = summary,
                extras = extras
            )
            callback.onNotificationOpened(notification) { result ->
                result.onSuccess {
                    AliyunPushLog.d("PushEventCallback", "onNotificationOpened success")
                }.onFailure { error ->
                    AliyunPushLog.e("PushEventCallback", "onNotificationOpened failed: $error")
                }
            }
        }
    }

    /**
     * 通知移除回调
     *
     * @param messageId 消息ID
     */
    fun onNotificationRemoved(messageId: String?) {
        eventCallback?.let { callback ->
            val notification = NotificationData(messageId = messageId)
            callback.onNotificationRemoved(notification) { result ->
                result.onSuccess {
                    AliyunPushLog.d("PushEventCallback", "onNotificationRemoved success")
                }.onFailure { error ->
                    AliyunPushLog.e("PushEventCallback", "onNotificationRemoved failed: $error")
                }
            }
        }
    }

    /**
     * 通道打开回调
     */
    fun onChannelOpened() {
        eventCallback?.let { callback ->
            callback.onChannelOpened { result ->
                result.onSuccess {
                    AliyunPushLog.d("PushEventCallback", "onChannelOpened success")
                }.onFailure { error ->
                    AliyunPushLog.e("PushEventCallback", "onChannelOpened failed: $error")
                }
            }
        }
    }

    /**
     * 设备Token注册成功回调
     *
     * @param apnsDeviceToken APNs设备Token (iOS)
     */
    fun onRegisterDeviceTokenSuccess(apnsDeviceToken: String?) {
        eventCallback?.let { callback ->
            val result = DeviceTokenData(apnsDeviceToken = apnsDeviceToken)
            callback.onRegisterDeviceTokenSuccess(result) { callbackResult ->
                callbackResult.onSuccess {
                    AliyunPushLog.d("PushEventCallback", "onRegisterDeviceTokenSuccess success")
                }.onFailure { error ->
                    AliyunPushLog.e("PushEventCallback", "onRegisterDeviceTokenSuccess failed: $error")
                }
            }
        }
    }

    /**
     * 设备Token注册失败回调
     *
     * @param error 错误信息
     */
    fun onRegisterDeviceTokenFailed(error: String?) {
        eventCallback?.let { callback ->
            val result = DeviceTokenData(error = error)
            callback.onRegisterDeviceTokenFailed(result) { callbackResult ->
                callbackResult.onSuccess {
                    AliyunPushLog.d("PushEventCallback", "onRegisterDeviceTokenFailed success")
                }.onFailure { err ->
                    AliyunPushLog.e("PushEventCallback", "onRegisterDeviceTokenFailed failed: $err")
                }
            }
        }
    }
}