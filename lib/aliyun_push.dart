import 'dart:io';

import 'pigeon/messages.dart';

/// 成功码
const kAliyunPushSuccessCode = "10000";

/// 参数错误
const kAliyunPushParamsIllegal = "10001";

/// 失败码
const kAliyunPushFailedCode = "10002";

/// 仅支持 Android
const kAliyunPushOnlyAndroid = "10003";

/// 仅支持 iOS
const kAliyunPushOnlyIOS = "10004";

/// 平台不支持
const kAliyunPushNotSupport = "10005";

/// 日志级别
const kAliyunPushLogLevelError = 0;
const kAliyunPushLogLevelInfo = 1;
const kAliyunPushLogLevelDebug = 2;

typedef PushCallback = Future<dynamic> Function(Map<dynamic, dynamic> message);

/// 阿里云推送 Flutter 插件
/// 
/// 基于Pigeon实现，提供类型安全的平台通道通信。
/// SDK 4.x 变更：
/// - 标签接口只支持设备标签
/// - 删除废弃的回调方法
class AliyunPush {
  final _api = PushApi();
  
  AliyunPush._internal();
  
  factory AliyunPush() => _instance;
  
  static final AliyunPush _instance = AliyunPush._internal();
  
  // ==================== 回调 ====================
  
  /// 通知到达回调
  PushCallback? _onNotification;
  
  /// 推送消息回调
  PushCallback? _onMessage;
  
  /// 通知打开回调
  PushCallback? _onNotificationOpened;
  
  /// 通知删除回调
  PushCallback? _onNotificationRemoved;
  
  /// iOS 通道打开回调
  PushCallback? _onIOSChannelOpened;
  
  /// iOS APNs 注册成功回调
  PushCallback? _onIOSRegisterDeviceTokenSuccess;
  
  /// iOS APNs 注册失败回调
  PushCallback? _onIOSRegisterDeviceTokenFailed;
  
  /// 添加消息接收器
  /// 
  /// SDK 4.x 变更：
  /// - 删除 onAndroidNotificationReceivedInApp（已合并到 onNotification）
  /// - 删除 onAndroidNotificationClickedWithNoAction（已合并到 onNotificationOpened）
  void addMessageReceiver({
    PushCallback? onNotification,
    PushCallback? onMessage,
    PushCallback? onNotificationOpened,
    PushCallback? onNotificationRemoved,
    PushCallback? onIOSChannelOpened,
    PushCallback? onIOSRegisterDeviceTokenSuccess,
    PushCallback? onIOSRegisterDeviceTokenFailed,
  }) {
    _onNotification = onNotification;
    _onMessage = onMessage;
    _onNotificationOpened = onNotificationOpened;
    _onNotificationRemoved = onNotificationRemoved;
    _onIOSChannelOpened = onIOSChannelOpened;
    _onIOSRegisterDeviceTokenSuccess = onIOSRegisterDeviceTokenSuccess;
    _onIOSRegisterDeviceTokenFailed = onIOSRegisterDeviceTokenFailed;
    
    // 注册 Pigeon 回调
    PushEventCallback.setUp(_PushEventCallbackHandler(this));
  }
  
  // ==================== 初始化 ====================
  
  /// 初始化推送
  /// 
  /// Android: 无需参数
  /// iOS: 需要提供 appKey 和 appSecret
  Future<Map<dynamic, dynamic>> initPush({String? appKey, String? appSecret}) async {
    if (Platform.isIOS) {
      final request = InitPushRequest()
        ..appKey = appKey
        ..appSecret = appSecret;
      final result = await _api.initPushSdk(request);
      return {'code': result.code, 'errorMsg': result.errorMsg};
    } else {
      final result = await _api.initPush();
      return {'code': result.code, 'errorMsg': result.errorMsg};
    }
  }
  
  /// 初始化厂商通道（仅 Android）
  Future<Map<dynamic, dynamic>> initAndroidThirdPush() async {
    final result = await _api.initThirdPush();
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  // ==================== 设备ID ====================
  
  /// 获取设备ID
  Future<String> getDeviceId() async {
    final result = await _api.getDeviceId();
    return result.deviceId ?? '';
  }
  
  // ==================== 账号管理 ====================
  
  /// 绑定账号
  Future<Map<dynamic, dynamic>> bindAccount(String account) async {
    final request = AccountRequest()..account = account;
    final result = await _api.bindAccount(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 解绑账号
  Future<Map<dynamic, dynamic>> unbindAccount() async {
    final result = await _api.unbindAccount();
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  // ==================== 别名管理 ====================
  
  /// 添加别名
  Future<Map<dynamic, dynamic>> addAlias(String alias) async {
    final request = AliasRequest()..alias = alias;
    final result = await _api.addAlias(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 删除别名
  Future<Map<dynamic, dynamic>> removeAlias(String alias) async {
    final request = AliasRequest()..alias = alias;
    final result = await _api.removeAlias(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 查询别名列表
  Future<Map<dynamic, dynamic>> listAlias() async {
    final result = await _api.listAlias();
    return {
      'code': result.code,
      'errorMsg': result.errorMsg,
      'aliasList': result.aliasList,
    };
  }
  
  // ==================== 标签管理 ====================
  
  /// 绑定设备标签
  /// 
  /// SDK 4.x: 只支持设备标签，删除 target/alias 参数
  Future<Map<dynamic, dynamic>> bindTag(List<String> tags) async {
    final request = TagRequest()..tags = tags;
    final result = await _api.bindTag(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 解绑设备标签
  /// 
  /// SDK 4.x: 只支持设备标签，删除 target/alias 参数
  Future<Map<dynamic, dynamic>> unbindTag(List<String> tags) async {
    final request = TagRequest()..tags = tags;
    final result = await _api.unbindTag(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 查询设备标签列表
  /// 
  /// SDK 4.x: 只支持设备标签，删除 target 参数
  Future<Map<dynamic, dynamic>> listTags() async {
    final result = await _api.listTags();
    return {
      'code': result.code,
      'errorMsg': result.errorMsg,
      'tagsList': result.tagsList,
    };
  }
  
  // ==================== 手机号管理（仅 Android）====================
  
  /// 绑定手机号
  Future<Map<dynamic, dynamic>> bindPhoneNumber(String phone) async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    final request = PhoneNumberRequest()..phoneNumber = phone;
    final result = await _api.bindPhoneNumber(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 解绑手机号
  Future<Map<dynamic, dynamic>> unbindPhoneNumber() async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    final result = await _api.unbindPhoneNumber();
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  // ==================== 日志管理 ====================
  
  /// 关闭推送日志（仅 Android）
  Future<Map<dynamic, dynamic>> closeAndroidPushLog() async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    final result = await _api.closePushLog();
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 设置日志级别（仅 Android）
  Future<Map<dynamic, dynamic>> setAndroidLogLevel(int level) async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    final request = LogLevelRequest()..level = level;
    final result = await _api.setLogLevel(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 设置插件日志启用状态
  void setPluginLogEnabled(bool enabled) {
    final request = PluginLogRequest()..enabled = enabled;
    _api.setPluginLogEnabled(request);
  }
  
  // ==================== 通知管理（仅 Android）====================
  
  /// 设置通知分组展示
  Future<Map<dynamic, dynamic>> setNotificationInGroup(bool inGroup) async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    final request = NotificationGroupRequest()..inGroup = inGroup;
    final result = await _api.setNotificationInGroup(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 清除所有通知
  Future<Map<dynamic, dynamic>> clearNotifications() async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    final result = await _api.clearNotifications();
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 创建通知通道
  Future<Map<dynamic, dynamic>> createAndroidChannel(
    String id,
    String name,
    int importance,
    String description, {
    String? groupId,
    bool? allowBubbles,
    bool? light,
    int? lightColor,
    bool? showBadge,
    String? soundPath,
    int? soundUsage,
    int? soundContentType,
    int? soundFlag,
    bool? vibration,
    List<int>? vibrationPatterns,
  }) async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    
    final request = NotificationChannelRequest()
      ..id = id
      ..name = name
      ..importance = importance
      ..description = description
      ..groupId = groupId
      ..allowBubbles = allowBubbles
      ..light = light
      ..lightColor = lightColor
      ..showBadge = showBadge
      ..soundPath = soundPath
      ..soundUsage = soundUsage
      ..soundContentType = soundContentType
      ..soundFlag = soundFlag
      ..vibration = vibration
      ..vibrationPatterns = vibrationPatterns;
    
    final result = await _api.createChannel(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 创建通知通道分组
  Future<Map<dynamic, dynamic>> createAndroidChannelGroup(
    String id,
    String name,
    String desc,
  ) async {
    if (!Platform.isAndroid) {
      return {'code': kAliyunPushOnlyAndroid, 'errorMsg': 'Only support Android'};
    }
    
    final request = NotificationChannelGroupRequest()
      ..id = id
      ..name = name
      ..description = desc;
    
    final result = await _api.createGroup(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 检查通知是否启用
  Future<bool> isAndroidNotificationEnabled({String? id}) async {
    if (!Platform.isAndroid) {
      return false;
    }
    
    final request = CheckNotificationRequest()..channelId = id;
    final result = await _api.isNotificationEnabled(request);
    return result.enabled ?? false;
  }
  
  /// 跳转到通知设置页面
  void jumpToAndroidNotificationSettings({String? id}) {
    if (!Platform.isAndroid) {
      return;
    }
    
    final request = CheckNotificationRequest()..channelId = id;
    _api.jumpToNotificationSettings(request);
  }
  
  // ==================== iOS 独有方法 ====================
  
  /// 开启 iOS 调试日志
  Future<Map<dynamic, dynamic>> turnOnIOSDebug() async {
    if (!Platform.isIOS) {
      return {'code': kAliyunPushOnlyIOS, 'errorMsg': 'Only support iOS'};
    }
    final result = await _api.turnOnDebug();
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 前台显示通知（仅 iOS）
  Future<Map<dynamic, dynamic>> showIOSNoticeWhenForeground(bool enable) async {
    if (!Platform.isIOS) {
      return {'code': kAliyunPushOnlyIOS, 'errorMsg': 'Only support iOS'};
    }
    final request = ShowNotificationInForegroundRequest()..enable = enable;
    final result = await _api.showNoticeWhenForeground(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 设置角标数（仅 iOS）
  Future<Map<dynamic, dynamic>> setIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      return {'code': kAliyunPushOnlyIOS, 'errorMsg': 'Only support iOS'};
    }
    final request = BadgeNumberRequest()..badgeNum = num;
    final result = await _api.setBadgeNum(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 同步角标数到服务端（仅 iOS）
  Future<Map<dynamic, dynamic>> syncIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      return {'code': kAliyunPushOnlyIOS, 'errorMsg': 'Only support iOS'};
    }
    final request = BadgeNumberRequest()..badgeNum = num;
    final result = await _api.syncBadgeNum(request);
    return {'code': result.code, 'errorMsg': result.errorMsg};
  }
  
  /// 获取 APNs 设备 Token（仅 iOS）
  Future<String> getApnsDeviceToken() async {
    if (!Platform.isIOS) {
      return 'Only support iOS';
    }
    final result = await _api.getApnsDeviceToken();
    return result.deviceToken ?? '';
  }
  
  /// 检查通道是否打开（仅 iOS）
  Future<bool> isIOSChannelOpened() async {
    if (!Platform.isIOS) {
      return false;
    }
    final result = await _api.isChannelOpened();
    return result.opened ?? false;
  }
}

/// Pigeon 事件回调处理器
class _PushEventCallbackHandler extends PushEventCallback {
  final AliyunPush _push;
  
  _PushEventCallbackHandler(this._push);
  
  @override
  void onNotification(NotificationData notification) async {
    await _push._onNotification?.call(_notificationToMap(notification));
  }
  
  @override
  void onMessage(MessageData message) async {
    await _push._onMessage?.call(_messageToMap(message));
  }
  
  @override
  void onNotificationOpened(NotificationData notification) async {
    await _push._onNotificationOpened?.call(_notificationToMap(notification));
  }
  
  @override
  void onNotificationRemoved(NotificationData notification) async {
    await _push._onNotificationRemoved?.call(_notificationToMap(notification));
  }
  
  @override
  void onChannelOpened() async {
    await _push._onIOSChannelOpened?.call({});
  }
  
  @override
  void onRegisterDeviceTokenSuccess(DeviceTokenData result) async {
    await _push._onIOSRegisterDeviceTokenSuccess?.call(_deviceTokenToMap(result));
  }
  
  @override
  void onRegisterDeviceTokenFailed(DeviceTokenData result) async {
    await _push._onIOSRegisterDeviceTokenFailed?.call(_deviceTokenToMap(result));
  }
  
  // 辅助方法：将 NotificationData 转换为 Map
  Map<dynamic, dynamic> _notificationToMap(NotificationData data) {
    final map = <String, dynamic>{};
    if (data.title != null) map['title'] = data.title;
    if (data.summary != null) map['summary'] = data.summary;
    if (data.messageId != null) map['messageId'] = data.messageId;
    if (data.extras != null) map.addAll(data.extras!);
    return map;
  }
  
  // 辅助方法：将 MessageData 转换为 Map
  Map<dynamic, dynamic> _messageToMap(MessageData data) {
    final map = <String, dynamic>{};
    if (data.title != null) map['title'] = data.title;
    if (data.content != null) map['content'] = data.content;
    if (data.messageId != null) map['messageId'] = data.messageId;
    if (data.appId != null) map['appId'] = data.appId;
    if (data.traceInfo != null) map['traceInfo'] = data.traceInfo;
    return map;
  }
  
  // 辅助方法：将 DeviceTokenData 转换为 Map
  Map<dynamic, dynamic> _deviceTokenToMap(DeviceTokenData data) {
    final map = <String, dynamic>{};
    if (data.apnsDeviceToken != null) map['apnsDeviceToken'] = data.apnsDeviceToken;
    if (data.error != null) map['error'] = data.error;
    return map;
  }
}