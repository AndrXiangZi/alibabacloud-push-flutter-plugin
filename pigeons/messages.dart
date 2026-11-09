import 'package:pigeon/pigeon.dart';

// ==================== 数据类 ====================

/// 通用结果
class CommonResult {
  String? code;
  String? errorMsg;
}

/// 设备ID结果
class DeviceIdResult {
  String? deviceId;
}

/// 初始化参数
class InitPushRequest {
  String? appKey;
  String? appSecret;
}

/// 标签请求（SDK 4.x: 只支持设备标签）
class TagRequest {
  List<String>? tags;
}

/// 标签列表结果
class TagsResult {
  String? code;
  String? errorMsg;
  String? tagsList;
}

/// 别名请求
class AliasRequest {
  String? alias;
}

/// 别名列表结果
class AliasListResult {
  String? code;
  String? errorMsg;
  String? aliasList;
}

/// 账号请求
class AccountRequest {
  String? account;
}

/// 手机号请求
class PhoneNumberRequest {
  String? phoneNumber;
}

/// 日志级别请求
class LogLevelRequest {
  int? level;
}

/// 通知分组请求
class NotificationGroupRequest {
  bool? inGroup;
}

/// 通知通道请求
class NotificationChannelRequest {
  String? id;
  String? name;
  int? importance;
  String? description;
  String? groupId;
  bool? allowBubbles;
  bool? light;
  int? lightColor;
  bool? showBadge;
  String? soundPath;
  int? soundUsage;
  int? soundContentType;
  int? soundFlag;
  bool? vibration;
  List<int>? vibrationPatterns;
}

/// 通知通道分组请求
class NotificationChannelGroupRequest {
  String? id;
  String? name;
  String? description;
}

/// 检查通知请求
class CheckNotificationRequest {
  String? channelId;
}

/// 通知启用结果
class NotificationEnabledResult {
  bool? enabled;
}

/// APNs 设备Token结果
class ApnsDeviceTokenResult {
  String? deviceToken;
}

/// 通道状态结果
class ChannelOpenedResult {
  bool? opened;
}

/// 角标数请求
class BadgeNumberRequest {
  int? badgeNum;
}

/// 前台显示通知请求
class ShowNotificationInForegroundRequest {
  bool? enable;
}

/// 插件日志请求
class PluginLogRequest {
  bool? enabled;
}

/// 通知数据
class NotificationData {
  String? title;
  String? summary;
  String? messageId;
  Map<String, String>? extras;
}

/// 消息数据
class MessageData {
  String? title;
  String? content;
  String? messageId;
  String? appId;
  String? traceInfo;
}

/// 设备Token数据
class DeviceTokenData {
  String? apnsDeviceToken;
  String? error;
}

// ==================== API 定义 ====================

/// 推送 API
@HostApi()
abstract class PushApi {
  // ===== 通用方法 =====
  
  /// 绑定账号
  @async
  CommonResult bindAccount(AccountRequest request);
  
  /// 解绑账号
  @async
  CommonResult unbindAccount();
  
  /// 添加别名
  @async
  CommonResult addAlias(AliasRequest request);
  
  /// 删除别名
  @async
  CommonResult removeAlias(AliasRequest request);
  
  /// 查询别名列表
  @async
  AliasListResult listAlias();
  
  /// 绑定设备标签
  /// SDK 4.x: 只支持设备标签，删除 target/alias 参数
  @async
  CommonResult bindTag(TagRequest request);
  
  /// 解绑设备标签
  /// SDK 4.x: 只支持设备标签，删除 target/alias 参数
  @async
  CommonResult unbindTag(TagRequest request);
  
  /// 查询设备标签列表
  /// SDK 4.x: 只支持设备标签，删除 target 参数
  @async
  TagsResult listTags();
  
  /// 获取设备ID
  @async
  DeviceIdResult getDeviceId();
  
  /// 设置插件日志启用状态
  void setPluginLogEnabled(PluginLogRequest request);
  
  // ===== Android 独有方法 =====
  
  /// 初始化推送
  @async
  CommonResult initPush();
  
  /// 初始化厂商通道
  @async
  CommonResult initThirdPush();
  
  /// 关闭推送日志
  @async
  CommonResult closePushLog();
  
  /// 设置日志级别
  @async
  CommonResult setLogLevel(LogLevelRequest request);
  
  /// 绑定手机号
  @async
  CommonResult bindPhoneNumber(PhoneNumberRequest request);
  
  /// 解绑手机号
  @async
  CommonResult unbindPhoneNumber();
  
  /// 设置通知分组
  @async
  CommonResult setNotificationInGroup(NotificationGroupRequest request);
  
  /// 清除所有通知
  @async
  CommonResult clearNotifications();
  
  /// 创建通知通道
  @async
  CommonResult createChannel(NotificationChannelRequest request);
  
  /// 创建通知通道分组
  @async
  CommonResult createGroup(NotificationChannelGroupRequest request);
  
  /// 检查通知是否启用
  @async
  NotificationEnabledResult isNotificationEnabled(CheckNotificationRequest request);
  
  /// 跳转到通知设置
  void jumpToNotificationSettings(CheckNotificationRequest request);
  
  // ===== iOS 独有方法 =====
  
  /// 初始化推送SDK (iOS)
  @async
  CommonResult initPushSdk(InitPushRequest request);
  
  /// 开启调试
  @async
  CommonResult turnOnDebug();
  
  /// 前台显示通知
  @async
  CommonResult showNoticeWhenForeground(ShowNotificationInForegroundRequest request);
  
  /// 设置角标数
  @async
  CommonResult setBadgeNum(BadgeNumberRequest request);
  
  /// 同步角标数到服务端
  @async
  CommonResult syncBadgeNum(BadgeNumberRequest request);
  
  /// 获取 APNs 设备Token
  @async
  ApnsDeviceTokenResult getApnsDeviceToken();
  
  /// 检查通道是否打开
  @async
  ChannelOpenedResult isChannelOpened();
}

/// 推送事件回调（Native -> Flutter）
@FlutterApi()
abstract class PushEventCallback {
  /// 通知到达回调
  void onNotification(NotificationData notification);
  
  /// 推送消息到达回调
  void onMessage(MessageData message);
  
  /// 通知打开回调
  void onNotificationOpened(NotificationData notification);
  
  /// 通知删除回调
  void onNotificationRemoved(NotificationData notification);
  
  /// iOS 通道打开回调
  void onChannelOpened();
  
  /// iOS APNs 注册成功回调
  void onRegisterDeviceTokenSuccess(DeviceTokenData result);
  
  /// iOS APNs 注册失败回调
  void onRegisterDeviceTokenFailed(DeviceTokenData result);
}