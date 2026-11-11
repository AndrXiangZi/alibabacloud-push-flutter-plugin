## 0.3.0

**重大架构改造：Native → Flutter 通信方式优化**

### 破坏性变更
- **Native → Flutter 事件通信从 Pigeon Native Interop 改为 EventChannel**
  - 解决多引擎场景下的覆盖问题（[Flutter issue #195877](https://github.com/flutter/flutter/issues/195877)）
  - 避免 channel-error 错误
  - 更好的监听器生命周期管理

### 改进
- **Android**: 新增 `PushEventChannel.kt`，使用 `EventChannel` 发送事件
- **iOS**: 新增 `PushEventChannel.swift`，使用 `FlutterEventChannel` 发送事件
- **Flutter**: 使用 `EventChannel` 监听推送事件
- **向后兼容**: Flutter API 无变化，现有代码无需修改

### 注意事项
- 如果你的项目中使用了多个 FlutterEngine，建议升级到此版本
- 推送事件回调更加稳定可靠

---

## 0.2.0

* Android 升级到 SDK 4.x 版本
* iOS 代码优化
* Pigeon 重构

---

## 0.1.1

* 回调参数类型转换错误修复
* Android 小米通道升级至3.8.6.1版本

---

## 0.1.0

* Android升级到3.8.6版本

---

## 0.0.9

* 优化代码

---

## 0.0.8

* Android升级到3.8.5版本

---

## 0.0.7

* ios初始化时增加网络判断

---

## 0.0.6

* android代码增加保护机制

---

## 0.0.5

* 修复Android创建Channel时desc字段key值不一致问题

---

## 0.0.4

* README优化
* 代码优化
* 增加控制插件日志是否开启的API

---

## 0.0.3

* 内部代码优化

---

## 0.0.2

* 更新LICENSE

---

## 0.0.1

* 集成Android推送 3.8.2版本，iOS推送1.9.9.7版本