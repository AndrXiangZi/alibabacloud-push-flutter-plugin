import Flutter

/// 推送事件通道
///
/// 使用 FlutterMethodChannel 实现事件传递（Native → Flutter）
class PushEventChannel: NSObject {

    // MARK: - Properties

    private var channel: FlutterMethodChannel?

    // MARK: - Singleton

    static let shared = PushEventChannel()

    private override init() {
        super.init()
    }

    // MARK: - Initialization

    /// 初始化事件通道
    func setup(messenger: FlutterBinaryMessenger) {
        if channel != nil { return }
        channel = FlutterMethodChannel(
            name: "com.aliyun.ams.push/event",
            binaryMessenger: messenger
        )
    }

    /// 清理事件通道
    func dispose() {
        channel = nil
    }

    // MARK: - Event Methods

    /// 发送通知到达事件
    func onNotification(userInfo: [String: Any]) {
        var data = userInfo
        sendEvent("onNotification", data)
    }

    /// 发送消息到达事件
    func onMessage(title: String?, body: String?) {
        let data: [String: Any?] = [
            "title": title,
            "content": body
        ]
        sendEvent("onMessage", data)
    }

    /// 发送通知打开事件
    func onNotificationOpened(userInfo: [String: Any]) {
        var data = userInfo
        sendEvent("onNotificationOpened", data)
    }

    /// 发送通知移除事件
    func onNotificationRemoved(userInfo: [String: Any]) {
        var data = userInfo
        sendEvent("onNotificationRemoved", data)
    }

    /// iOS 通道打开事件
    func onChannelOpened() {
        sendEvent("onChannelOpened", nil)
    }

    /// iOS APNs 注册成功事件
    func onRegisterDeviceTokenSuccess(apnsDeviceToken: String) {
        let data: [String: Any?] = [
            "apnsDeviceToken": apnsDeviceToken
        ]
        sendEvent("onRegisterDeviceTokenSuccess", data)
    }

    /// iOS APNs 注册失败事件
    func onRegisterDeviceTokenFailed(error: String) {
        let data: [String: Any?] = [
            "error": error
        ]
        sendEvent("onRegisterDeviceTokenFailed", data)
    }

    // MARK: - Private Methods

    /// 发送事件到 Flutter
    private func sendEvent(_ method: String, _ arguments: [String: Any?]?) {
        if let channel = channel {
            // 移除 nil 值
            let cleanArguments = arguments?.compactMapValues { $0 }
            channel.invokeMethod(method, arguments: cleanArguments)
        } else {
            print("[PushEventChannel] Channel not initialized, skip event: \(method)")
        }
    }
}