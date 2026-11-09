import Foundation
import CloudPushSDK
import UserNotifications

/// Pigeon Push API Swift 实现
class PigeonPushApi: PushApi {

    // MARK: - Properties

    private weak var plugin: AliyunPushPlugin?

    // MARK: - Initialization

    init(plugin: AliyunPushPlugin) {
        self.plugin = plugin
    }

    // MARK: - 标签方法

    func bindTag(_ request: TagRequest) async throws -> CommonResult {
        guard let tags = request.tags, !tags.isEmpty else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgTagsEmpty
            return result
        }

        return try await withCheckedThrowingContinuation { continuation in
            // iOS SDK 2.1.0: 使用默认值 target=1 (设备标签), alias=nil
            CloudPushSDK.bindTag(1, withTags: tags, withAlias: nil) { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func unbindTag(_ request: TagRequest) async throws -> CommonResult {
        guard let tags = request.tags, !tags.isEmpty else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgTagsEmpty
            return result
        }

        return try await withCheckedThrowingContinuation { continuation in
            // iOS SDK 2.1.0: 使用默认值
            CloudPushSDK.unbindTag(1, withTags: tags, withAlias: nil) { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func listTags() async throws -> TagsResult {
        return try await withCheckedThrowingContinuation { continuation in
            // iOS SDK 2.1.0: 使用默认值 target=1
            CloudPushSDK.listTags(1) { res in
                let result = TagsResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                    result.tagsList = res.data as? String
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    // MARK: - 账号/别名方法

    func bindAccount(_ request: AccountRequest) async throws -> CommonResult {
        guard let account = request.account, !account.isEmpty else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgAccountEmpty
            return result
        }

        return try await withCheckedThrowingContinuation { continuation in
            CloudPushSDK.bindAccount(account) { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func unbindAccount() async throws -> CommonResult {
        return try await withCheckedThrowingContinuation { continuation in
            CloudPushSDK.unbindAccount { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func addAlias(_ request: AliasRequest) async throws -> CommonResult {
        guard let alias = request.alias, !alias.isEmpty else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgAliasEmpty
            return result
        }

        return try await withCheckedThrowingContinuation { continuation in
            CloudPushSDK.addAlias(alias) { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func removeAlias(_ request: AliasRequest) async throws -> CommonResult {
        guard let alias = request.alias, !alias.isEmpty else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgAliasEmpty
            return result
        }

        return try await withCheckedThrowingContinuation { continuation in
            CloudPushSDK.removeAlias(alias) { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func listAlias() async throws -> AliasListResult {
        return try await withCheckedThrowingContinuation { continuation in
            CloudPushSDK.listAliases { res in
                let result = AliasListResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                    result.aliasList = res.data as? String
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    // MARK: - 设备ID

    func getDeviceId() async throws -> DeviceIdResult {
        let result = DeviceIdResult()
        result.deviceId = CloudPushSDK.getDeviceId()
        return result
    }

    // MARK: - iOS 独有方法

    func initPushSdk(_ request: InitPushRequest) async throws -> CommonResult {
        guard let appKey = request.appKey, !appKey.isEmpty else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "appKey can not be empty"
            return result
        }

        guard let appSecret = request.appSecret, !appSecret.isEmpty else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "appSecret can not be empty"
            return result
        }

        CloudPushSDK.turnOnDebug()
        plugin?.registerAPNS()

        return try await withCheckedThrowingContinuation { continuation in
            CloudPushSDK.asyncInit(appKey, appSecret: appSecret) { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func turnOnDebug() async throws -> CommonResult {
        CloudPushSDK.turnOnDebug()
        let result = CommonResult()
        result.code = PushConstants.codeSuccess
        return result
    }

    func showNoticeWhenForeground(_ request: ShowNotificationInForegroundRequest) async throws -> CommonResult {
        guard let enable = request.enable else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "enable can not be null"
            return result
        }

        plugin?.setShowNoticeWhenForeground(enable)

        let result = CommonResult()
        result.code = PushConstants.codeSuccess
        return result
    }

    func setBadgeNum(_ request: BadgeNumberRequest) async throws -> CommonResult {
        guard let badgeNum = request.badgeNum else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "badgeNum can not be null"
            return result
        }

        UIApplication.shared.applicationIconBadgeNumber = badgeNum

        let result = CommonResult()
        result.code = PushConstants.codeSuccess
        return result
    }

    func syncBadgeNum(_ request: BadgeNumberRequest) async throws -> CommonResult {
        guard let badgeNum = request.badgeNum else {
            let result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "badgeNum can not be null"
            return result
        }

        return try await withCheckedThrowingContinuation { continuation in
            CloudPushSDK.syncBadgeNum(badgeNum) { res in
                let result = CommonResult()
                if res.success {
                    result.code = PushConstants.codeSuccess
                } else {
                    result.code = PushConstants.codeFailed
                    result.errorMsg = res.error?.localizedDescription
                }
                continuation.resume(returning: result)
            }
        }
    }

    func getApnsDeviceToken() async throws -> ApnsDeviceTokenResult {
        let result = ApnsDeviceTokenResult()
        result.deviceToken = CloudPushSDK.getApnsDeviceToken()
        return result
    }

    func isChannelOpened() async throws -> ChannelOpenedResult {
        let result = ChannelOpenedResult()
        result.opened = CloudPushSDK.isChannelOpened()
        return result
    }

    func setPluginLogEnabled(_ request: PluginLogRequest) {
        guard let enabled = request.enabled else { return }
        plugin?.setLogEnabled(enabled)
    }

    // MARK: - Android 方法在 iOS 上返回错误

    func initPush() async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func initThirdPush() async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func closePushLog() async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func setLogLevel(_ request: LogLevelRequest) async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func bindPhoneNumber(_ request: PhoneNumberRequest) async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func unbindPhoneNumber() async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func setNotificationInGroup(_ request: NotificationGroupRequest) async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func clearNotifications() async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func createChannel(_ request: NotificationChannelRequest) async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func createGroup(_ request: NotificationChannelGroupRequest) async throws -> CommonResult {
        let result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        return result
    }

    func isNotificationEnabled(_ request: CheckNotificationRequest) async throws -> NotificationEnabledResult {
        let result = NotificationEnabledResult()
        result.enabled = false
        return result
    }

    func jumpToNotificationSettings(_ request: CheckNotificationRequest) {
        // iOS no-op
    }
}