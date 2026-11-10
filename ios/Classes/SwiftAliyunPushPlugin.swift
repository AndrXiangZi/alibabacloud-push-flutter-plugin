import Flutter
import UIKit
import CloudPushSDK
import UserNotifications

/// 阿里云推送 Flutter 插件 - Swift 实现
public class SwiftAliyunPushPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {

    // MARK: - Properties

    private var channel: FlutterMethodChannel?
    private var notificationCenter: UNUserNotificationCenter?
    private var showNoticeWhenForeground: Bool = false
    private var deviceToken: Data?
    private var remoteNotification: [AnyHashable: Any]?
    private var pigeonApi: PigeonPushApi?
    private var logEnabled: Bool = false

    // MARK: - FlutterPlugin

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "aliyun_push", binaryMessenger: registrar.messenger())

        let instance = SwiftAliyunPushPlugin()
        instance.channel = channel
        instance.pigeonApi = PigeonPushApi(plugin: instance)

        // 注册 Pigeon API
        PushApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance.pigeonApi)

        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // MARK: - Method Call Handler (保留用于事件回调)

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Pigeon 已处理所有方法，这里只处理事件回调
        result(FlutterMethodNotImplemented)
    }

    // MARK: - AppDelegate Methods

   public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let notification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            remoteNotification = notification
        }
        return true
    }

    // MARK: - APNs Registration

     func registerAPNS() {
        // 现代 iOS (iOS 10+) 使用 UserNotifications framework
        notificationCenter = UNUserNotificationCenter.current()
        notificationCenter?.delegate = self

        notificationCenter?.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken

        CloudPushSDK.registerDevice(deviceToken) { result in
            if let result = result, result.success {
                let apnsToken = CloudPushSDK.getApnsDeviceToken()
                self.sendEvent("onRegisterDeviceTokenSuccess", ["apnsDeviceToken": apnsToken])
            } else {
                self.sendEvent("onRegisterDeviceTokenFailed", ["error": result?.error?.localizedDescription ?? "Unknown error"])
            }
        }
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        sendEvent("onRegisterDeviceTokenFailed", ["error": error.localizedDescription])
    }

    // MARK: - Remote Notification Handling

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        CloudPushSDK.sendNotificationAck(userInfo)
        sendEvent("onNotification", userInfo as? [String: Any] ?? [:])

        // 处理冷启动的通知点击
        if let remoteNotification = remoteNotification {
            if let msgId = userInfo["m"] as? String,
               let remoteMsgId = remoteNotification["m"] as? String,
               msgId == remoteMsgId {
                CloudPushSDK.sendNotificationAck(remoteNotification)
                sendEvent("onNotificationOpened", remoteNotification as? [String: Any] ?? [:])
                self.remoteNotification = nil
            }
        }

        completionHandler(.newData)
    }

    // MARK: - UNUserNotificationCenterDelegate

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        if showNoticeWhenForeground {
            completionHandler([.sound, .alert, .badge])
        } else {
            handleiOS10Notification(notification)
            completionHandler([])
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        let userAction = response.actionIdentifier

        if userAction == UNNotificationDefaultActionIdentifier {
            // 点击通知
            CloudPushSDK.sendNotificationAck(userInfo)
            sendEvent("onNotificationOpened", userInfo as? [String: Any] ?? [:])
        } else if userAction == UNNotificationDismissActionIdentifier {
            // 通知被删除
            CloudPushSDK.sendDeleteNotificationAck(userInfo)
            sendEvent("onNotificationRemoved", userInfo as? [String: Any] ?? [:])
        }

        completionHandler()
    }

    // MARK: - Helper Methods

    private func handleiOS10Notification(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo

        // 清除角标
        UIApplication.shared.applicationIconBadgeNumber = 0
        syncBadgeNum(0)

        // 上报通知到达
        CloudPushSDK.sendNotificationAck(userInfo)
        sendEvent("onNotification", userInfo as? [String: Any] ?? [:])
    }

    private func syncBadgeNum(_ num: Int) {
        CloudPushSDK.syncBadgeNum(UInt(num)) { _ in }
    }

    private func sendEvent(_ method: String, _ arguments: [String: Any] = [:]) {
        channel?.invokeMethod(method, arguments: arguments)
    }

    func setShowNoticeWhenForeground(_ enable: Bool) {
        showNoticeWhenForeground = enable
    }

    func setLogEnabled(_ enabled: Bool) {
        logEnabled = enabled
    }

    // MARK: - Channel Opened Listener

   public func listenChannelOpened() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onChannelOpened),
            name: NSNotification.Name("CCPDidChannelConnectedSuccess"),
            object: nil
        )
    }

    @objc private func onChannelOpened() {
        sendEvent("onChannelOpened")
    }

    // MARK: - Message Receiver

   public func registerMessageReceive() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onMessageReceived),
            name: NSNotification.Name("CCPDidReceiveMessageNotification"),
            object: nil
        )
    }

    @objc private func onMessageReceived(_ notification: Notification) {
        if let message = notification.object as? CCPSysMessage {
            sendEvent("onMessage", [
                "title": message.title ?? "",
                "body": message.body ?? ""
            ])
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}