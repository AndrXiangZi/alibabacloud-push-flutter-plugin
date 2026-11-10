import Foundation
import CloudPushSDK
import UserNotifications

/// Pigeon Push API Swift 实现
class PigeonPushApi: PushApi {

    // MARK: - Properties

    private weak var plugin: SwiftAliyunPushPlugin?

    // MARK: - Initialization

    init(plugin: SwiftAliyunPushPlugin) {
        self.plugin = plugin
    }

    // MARK: - 标签方法

    func bindTag(request: TagRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let tags = request.tags, !tags.isEmpty else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgTagsEmpty
            completion(.success(result))
            return
        }

        // iOS SDK 2.1.0: 使用默认值 target=1 (设备标签), alias=nil
        CloudPushSDK.bindTag(1, withTags: tags, withAlias: nil) { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func unbindTag(request: TagRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let tags = request.tags, !tags.isEmpty else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgTagsEmpty
            completion(.success(result))
            return
        }

        // iOS SDK 2.1.0: 使用默认值
        CloudPushSDK.unbindTag(1, withTags: tags, withAlias: nil) { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func listTags(completion: @escaping (Result<TagsResult, Error>) -> Void) {
        // iOS SDK 2.1.0: 使用默认值 target=1
        CloudPushSDK.listTags(1) { res in
            var result = TagsResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
                result.tagsList = res.data as? String
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    // MARK: - 账号/别名方法

    func bindAccount(request: AccountRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let account = request.account, !account.isEmpty else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgAccountEmpty
            completion(.success(result))
            return
        }

        CloudPushSDK.bindAccount(account) { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func unbindAccount(completion: @escaping (Result<CommonResult, Error>) -> Void) {
        CloudPushSDK.unbindAccount { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func addAlias(request: AliasRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let alias = request.alias, !alias.isEmpty else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgAliasEmpty
            completion(.success(result))
            return
        }

        CloudPushSDK.addAlias(alias) { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func removeAlias(request: AliasRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let alias = request.alias, !alias.isEmpty else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = PushConstants.msgAliasEmpty
            completion(.success(result))
            return
        }

        CloudPushSDK.removeAlias(alias) { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func listAlias(completion: @escaping (Result<AliasListResult, Error>) -> Void) {
        CloudPushSDK.listAliases { res in
            var result = AliasListResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
                result.aliasList = res.data as? String
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    // MARK: - 设备ID

    func getDeviceId(completion: @escaping (Result<DeviceIdResult, Error>) -> Void) {
        var result = DeviceIdResult()
        result.deviceId = CloudPushSDK.getDeviceId()
        completion(.success(result))
    }

    // MARK: - iOS 独有方法

    func initPushSdk(request: InitPushRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let appKey = request.appKey, !appKey.isEmpty else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "appKey can not be empty"
            completion(.success(result))
            return
        }

        guard let appSecret = request.appSecret, !appSecret.isEmpty else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "appSecret can not be empty"
            completion(.success(result))
            return
        }

        CloudPushSDK.turnOnDebug()
        plugin?.registerAPNS()

        CloudPushSDK.asyncInit(appKey, appSecret: appSecret) { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func turnOnDebug(completion: @escaping (Result<CommonResult, Error>) -> Void) {
        CloudPushSDK.turnOnDebug()
        var result = CommonResult()
        result.code = PushConstants.codeSuccess
        completion(.success(result))
    }

    func showNoticeWhenForeground(request: ShowNotificationInForegroundRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let enable = request.enable else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "enable can not be null"
            completion(.success(result))
            return
        }

        plugin?.setShowNoticeWhenForeground(enable)

        var result = CommonResult()
        result.code = PushConstants.codeSuccess
        completion(.success(result))
    }

    func setBadgeNum(request: BadgeNumberRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let badgeNum = request.badgeNum else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "badgeNum can not be null"
            completion(.success(result))
            return
        }

        UIApplication.shared.applicationIconBadgeNumber = Int(badgeNum)

        var result = CommonResult()
        result.code = PushConstants.codeSuccess
        completion(.success(result))
    }

    func syncBadgeNum(request: BadgeNumberRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        guard let badgeNum = request.badgeNum else {
            var result = CommonResult()
            result.code = PushConstants.codeParamIllegal
            result.errorMsg = "badgeNum can not be null"
            completion(.success(result))
            return
        }

        CloudPushSDK.syncBadgeNum(UInt(badgeNum)) { res in
            var result = CommonResult()
            if let res = res, res.success {
                result.code = PushConstants.codeSuccess
            } else {
                result.code = PushConstants.codeFailed
                result.errorMsg = res?.error?.localizedDescription
            }
            completion(.success(result))
        }
    }

    func getApnsDeviceToken(completion: @escaping (Result<ApnsDeviceTokenResult, Error>) -> Void) {
        var result = ApnsDeviceTokenResult()
        result.deviceToken = CloudPushSDK.getApnsDeviceToken()
        completion(.success(result))
    }

    func isChannelOpened(completion: @escaping (Result<ChannelOpenedResult, Error>) -> Void) {
        var result = ChannelOpenedResult()
        result.opened = CloudPushSDK.isChannelOpened()
        completion(.success(result))
    }

    func setPluginLogEnabled(request: PluginLogRequest) throws {
        guard let enabled = request.enabled else { return }
        plugin?.setLogEnabled(enabled)
    }

    // MARK: - Android 方法在 iOS 上返回错误

    func initPush(completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func initThirdPush(completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func closePushLog(completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func setLogLevel(request: LogLevelRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func bindPhoneNumber(request: PhoneNumberRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func unbindPhoneNumber(completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func setNotificationInGroup(request: NotificationGroupRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func clearNotifications(completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func createChannel(request: NotificationChannelRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func createGroup(request: NotificationChannelGroupRequest, completion: @escaping (Result<CommonResult, Error>) -> Void) {
        var result = CommonResult()
        result.code = PushConstants.codeOnlyAndroid
        result.errorMsg = PushConstants.msgOnlyAndroid
        completion(.success(result))
    }

    func isNotificationEnabled(request: CheckNotificationRequest, completion: @escaping (Result<NotificationEnabledResult, Error>) -> Void) {
        var result = NotificationEnabledResult()
        result.enabled = false
        completion(.success(result))
    }

    func jumpToNotificationSettings(request: CheckNotificationRequest) throws {
        // iOS no-op
    }
}