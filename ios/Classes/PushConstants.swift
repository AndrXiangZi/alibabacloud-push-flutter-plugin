import Foundation

/// 推送插件常量定义
enum PushConstants {

    // MARK: - 错误码

    /// 成功
    static let codeSuccess = "10000"

    /// 参数非法
    static let codeParamIllegal = "10001"

    /// 失败
    static let codeFailed = "10002"

    /// 仅支持 Android
    static let codeOnlyAndroid = "10003"

    /// 仅支持 iOS
    static let codeOnlyIOS = "10004"

    /// 平台不支持
    static let codeNotSupport = "10005"

    /// 无网络
    static let codeNoNet = "10006"

    // MARK: - 错误消息

    /// 标签为空
    static let msgTagsEmpty = "tags can not be empty"

    /// 账号为空
    static let msgAccountEmpty = "account can not be empty"

    /// 别名为空
    static let msgAliasEmpty = "alias can not be empty"

    /// 手机号为空
    static let msgPhoneEmpty = "phone can not be empty"

    /// 仅支持 Android
    static let msgOnlyAndroid = "Only support Android"

    /// 仅支持 iOS
    static let msgOnlyIOS = "Only support iOS"

    /// 无网络
    static let msgNoNetwork = "no network"

    // MARK: - 回调方法名

    static let methodOnNotification = "onNotification"
    static let methodOnMessage = "onMessage"
    static let methodOnNotificationOpened = "onNotificationOpened"
    static let methodOnNotificationRemoved = "onNotificationRemoved"
    static let methodOnChannelOpened = "onChannelOpened"
    static let methodOnRegisterDeviceTokenSuccess = "onRegisterDeviceTokenSuccess"
    static let methodOnRegisterDeviceTokenFailed = "onRegisterDeviceTokenFailed"

    // MARK: - Map Key 名

    static let keyCode = "code"
    static let keyErrorMsg = "errorMsg"
    static let keyTitle = "title"
    static let keySummary = "summary"
    static let keyMsgId = "msgId"
    static let keyTagsList = "tagsList"
    static let keyAliasList = "aliasList"

    // MARK: - 日志级别

    static let logLevelError = 0
    static let logLevelInfo = 1
    static let logLevelDebug = 2
}