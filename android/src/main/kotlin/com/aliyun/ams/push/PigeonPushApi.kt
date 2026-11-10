package com.aliyun.ams.push

import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.alibaba.sdk.android.push.CloudPushService
import com.alibaba.sdk.android.push.CommonCallback
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory
import java.io.File

/**
 * Pigeon Push API Kotlin 实现
 *
 * 实现所有 Pigeon 定义的推送 API 方法
 * SDK 4.x: 标签接口只支持设备标签
 */
class PigeonPushApi(private val context: Context) : PushApi {

    private val pushService: CloudPushService = PushServiceFactory.getCloudPushService()

    // ==================== 标签方法 ====================

    override fun bindTag(request: TagRequest, callback: (Result<CommonResult>) -> Unit) {
        val tags = request.tags

        if (tags.isNullOrEmpty()) {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_PARAM_ILLEGAL,
                errorMsg = PushConstants.MSG_TAGS_EMPTY
            )))
            return
        }

        val tagsArray = tags.toTypedArray()

        // SDK 4.x: 只支持设备标签，无需 target/alias 参数
        pushService.bindTag(tagsArray, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    override fun unbindTag(request: TagRequest, callback: (Result<CommonResult>) -> Unit) {
        val tags = request.tags

        if (tags.isNullOrEmpty()) {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_PARAM_ILLEGAL,
                errorMsg = PushConstants.MSG_TAGS_EMPTY
            )))
            return
        }

        val tagsArray = tags.toTypedArray()

        pushService.unbindTag(tagsArray, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    override fun listTags(callback: (Result<TagsResult>) -> Unit) {
        pushService.listTags(object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(TagsResult(
                    code = PushConstants.CODE_SUCCESS,
                    tagsList = response
                )))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(TagsResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    // ==================== 账号/别名方法 ====================

    override fun bindAccount(request: AccountRequest, callback: (Result<CommonResult>) -> Unit) {
        val account = request.account

        if (account.isNullOrEmpty()) {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_PARAM_ILLEGAL,
                errorMsg = PushConstants.MSG_ACCOUNT_EMPTY
            )))
            return
        }

        pushService.bindAccount(account, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    override fun unbindAccount(callback: (Result<CommonResult>) -> Unit) {
        pushService.unbindAccount(object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    override fun addAlias(request: AliasRequest, callback: (Result<CommonResult>) -> Unit) {
        val alias = request.alias

        if (alias.isNullOrEmpty()) {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_PARAM_ILLEGAL,
                errorMsg = PushConstants.MSG_ALIAS_EMPTY
            )))
            return
        }

        pushService.addAlias(alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    override fun removeAlias(request: AliasRequest, callback: (Result<CommonResult>) -> Unit) {
        val alias = request.alias

        if (alias.isNullOrEmpty()) {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_PARAM_ILLEGAL,
                errorMsg = PushConstants.MSG_ALIAS_EMPTY
            )))
            return
        }

        pushService.removeAlias(alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    override fun listAlias(callback: (Result<AliasListResult>) -> Unit) {
        pushService.listAliases(object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(AliasListResult(
                    code = PushConstants.CODE_SUCCESS,
                    aliasList = response
                )))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(AliasListResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    // ==================== 设备ID ====================

    override fun getDeviceId(callback: (Result<DeviceIdResult>) -> Unit) {
        val deviceId = pushService.deviceId
        callback(Result.success(DeviceIdResult(deviceId = deviceId)))
    }

    // ==================== 初始化方法 ====================

    override fun initPush(callback: (Result<CommonResult>) -> Unit) {
        PushServiceFactory.init(context)
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.setLogLevel(CloudPushService.LOG_DEBUG)

        pushService.register(context, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })

        pushService.turnOnPushChannel(object : CommonCallback {
            override fun onSuccess(s: String?) {}
            override fun onFailed(s: String?, s1: String?) {}
        })
    }

    override fun initThirdPush(callback: (Result<CommonResult>) -> Unit) {
        val appContext = context.applicationContext

        if (appContext is android.app.Application) {
            when{
                PushManufacturerUtil.supportHuaweiPush() -> AliyunThirdPushUtils.registerHuaweiPush(appContext)
                PushManufacturerUtil.supportHonorPush(appContext) -> AliyunThirdPushUtils.registerHonorPush(appContext)

                PushManufacturerUtil.supportXIAOMIPush() -> AliyunThirdPushUtils.registerXiaoMiPush(appContext)
                PushManufacturerUtil.supportVIVOPush(appContext) -> AliyunThirdPushUtils.registerVivoPush(appContext)
                PushManufacturerUtil.supportOPPOPush(appContext) -> AliyunThirdPushUtils.registerOppoPush(appContext)
                PushManufacturerUtil.supportMEIZUPush() -> AliyunThirdPushUtils.registerMeizuPush(appContext)
                else -> {
                    callback(Result.success(CommonResult(code = PushConstants.CODE_FAILED,"not support BRAND")))
                    return
                }
            }

            callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
        } else {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_FAILED,
                errorMsg = "Context is not Application"
            )))
        }
    }

    // ==================== 日志管理 ====================

    override fun closePushLog(callback: (Result<CommonResult>) -> Unit) {
        pushService.setLogLevel(CloudPushService.LOG_OFF)
        callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
    }

    override fun setLogLevel(request: LogLevelRequest, callback: (Result<CommonResult>) -> Unit) {
        val level = request.level?.toInt() ?: CloudPushService.LOG_ERROR
        pushService.setLogLevel(level)

        callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
    }

    // ==================== 手机号管理 ====================

    override fun bindPhoneNumber(request: PhoneNumberRequest, callback: (Result<CommonResult>) -> Unit) {
        val phone = request.phoneNumber

        if (phone.isNullOrEmpty()) {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_PARAM_ILLEGAL,
                errorMsg = PushConstants.MSG_PHONE_EMPTY
            )))
            return
        }

        pushService.bindPhoneNumber(phone, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    override fun unbindPhoneNumber(callback: (Result<CommonResult>) -> Unit) {
        pushService.unbindPhoneNumber(object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            }

            override fun onFailed(errorCode: String?, errorMsg: String?) {
                callback(Result.success(CommonResult(
                    code = errorCode,
                    errorMsg = errorMsg
                )))
            }
        })
    }

    // ==================== 通知管理 ====================

    override fun setNotificationInGroup(request: NotificationGroupRequest, callback: (Result<CommonResult>) -> Unit) {
        val inGroup = request.inGroup ?: false
        @Suppress("DEPRECATION")
        pushService.setNotificationShowInGroup(inGroup)

        callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
    }

    override fun clearNotifications(callback: (Result<CommonResult>) -> Unit) {
        pushService.clearNotifications()
        callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
    }

    override fun createChannel(request: NotificationChannelRequest, callback: (Result<CommonResult>) -> Unit) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
                    as android.app.NotificationManager

                val importanceValue = request.importance?.toInt()
                    ?: android.app.NotificationManager.IMPORTANCE_DEFAULT

                val channel = android.app.NotificationChannel(
                    request.id,
                    request.name,
                    importanceValue
                ).apply {
                    description = request.description

                    request.groupId?.let { group = it }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        request.allowBubbles?.let { setAllowBubbles(it) }
                    }

                    request.light?.let { enableLights(it) }
                    request.lightColor?.let { setLightColor(it.toInt()) }
                    request.showBadge?.let { setShowBadge(it) }

                    if (!request.soundPath.isNullOrEmpty()) {
                        val file = File(request.soundPath)
                        if (file.exists() && file.canRead() && file.isFile) {
                            val soundUri = Uri.fromFile(file)
                            if (request.soundUsage == null) {
                                setSound(soundUri, null)
                            } else {
                                val builder = AudioAttributes.Builder()
                                    .setUsage(request.soundUsage.toInt())
                                request.soundContentType?.let {
                                    builder.setContentType(it.toInt())
                                }
                                request.soundFlag?.let {
                                    builder.setFlags(it.toInt())
                                }
                                setSound(soundUri, builder.build())
                            }
                        }
                    }

                    request.vibration?.let { enableVibration(it) }

                    request.vibrationPatterns?.let { patterns ->
                        if (patterns.isNotEmpty()) {
                            val pattern = LongArray(patterns.size) { patterns[it].toLong() }
                            setVibrationPattern(pattern)
                        }
                    }
                }

                notificationManager.createNotificationChannel(channel)

                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            } catch (e: Exception) {
                callback(Result.success(CommonResult(
                    code = PushConstants.CODE_FAILED,
                    errorMsg = e.message
                )))
            }
        } else {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_NOT_SUPPORT,
                errorMsg = "Android version is below Android O which is not support create channel"
            )))
        }
    }

    override fun createGroup(request: NotificationChannelGroupRequest, callback: (Result<CommonResult>) -> Unit) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
                    as android.app.NotificationManager

                val group = android.app.NotificationChannelGroup(request.id, request.name).apply {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        description = request.description
                    }
                }

                notificationManager.createNotificationChannelGroup(group)

                callback(Result.success(CommonResult(code = PushConstants.CODE_SUCCESS)))
            } catch (e: Exception) {
                callback(Result.success(CommonResult(
                    code = PushConstants.CODE_FAILED,
                    errorMsg = e.message
                )))
            }
        } else {
            callback(Result.success(CommonResult(
                code = PushConstants.CODE_NOT_SUPPORT,
                errorMsg = "Android version is below Android O which is not support create group"
            )))
        }
    }

    override fun isNotificationEnabled(request: CheckNotificationRequest, callback: (Result<NotificationEnabledResult>) -> Unit) {
        val channelId = request.channelId

        val enabled = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
                as android.app.NotificationManager

            if (!channelId.isNullOrEmpty()) {
                val channel = notificationManager.getNotificationChannel(channelId)
                channel != null && channel.importance != android.app.NotificationManager.IMPORTANCE_NONE
            } else {
                notificationManager.areNotificationsEnabled()
            }
        } else {
            NotificationManagerCompat.from(context).areNotificationsEnabled()
        }

        callback(Result.success(NotificationEnabledResult(enabled = enabled)))
    }

    override fun jumpToNotificationSettings(request: CheckNotificationRequest) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = request.channelId
            val intent = if (!channelId.isNullOrEmpty()) {
                Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS).apply {
                    putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
                    putExtra(Settings.EXTRA_CHANNEL_ID, channelId)
                }
            } else {
                Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                    putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
                }
            }

            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        }
    }

    override fun setPluginLogEnabled(request: PluginLogRequest) {
        request.enabled?.let { enabled ->
            AliyunPushLog.setLogEnabled(enabled)
        }
    }

    // ==================== iOS 方法在 Android 上返回错误 ====================

    override fun initPushSdk(request: InitPushRequest, callback: (Result<CommonResult>) -> Unit) {
        callback(Result.success(CommonResult(
            code = PushConstants.CODE_ONLY_IOS,
            errorMsg = PushConstants.MSG_ONLY_IOS
        )))
    }

    override fun turnOnDebug(callback: (Result<CommonResult>) -> Unit) {
        callback(Result.success(CommonResult(
            code = PushConstants.CODE_ONLY_IOS,
            errorMsg = PushConstants.MSG_ONLY_IOS
        )))
    }

    override fun showNoticeWhenForeground(request: ShowNotificationInForegroundRequest, callback: (Result<CommonResult>) -> Unit) {
        callback(Result.success(CommonResult(
            code = PushConstants.CODE_ONLY_IOS,
            errorMsg = PushConstants.MSG_ONLY_IOS
        )))
    }

    override fun setBadgeNum(request: BadgeNumberRequest, callback: (Result<CommonResult>) -> Unit) {
        callback(Result.success(CommonResult(
            code = PushConstants.CODE_ONLY_IOS,
            errorMsg = PushConstants.MSG_ONLY_IOS
        )))
    }

    override fun syncBadgeNum(request: BadgeNumberRequest, callback: (Result<CommonResult>) -> Unit) {
        callback(Result.success(CommonResult(
            code = PushConstants.CODE_ONLY_IOS,
            errorMsg = PushConstants.MSG_ONLY_IOS
        )))
    }

    override fun getApnsDeviceToken(callback: (Result<ApnsDeviceTokenResult>) -> Unit) {
        callback(Result.success(ApnsDeviceTokenResult(
            deviceToken = PushConstants.MSG_ONLY_IOS
        )))
    }

    override fun isChannelOpened(callback: (Result<ChannelOpenedResult>) -> Unit) {
        callback(Result.success(ChannelOpenedResult(opened = false)))
    }
}