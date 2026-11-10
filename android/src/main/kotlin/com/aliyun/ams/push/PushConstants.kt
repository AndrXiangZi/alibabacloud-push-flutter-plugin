package com.aliyun.ams.push

/**
 * 推送插件常量定义
 */
object PushConstants {
    
    // ==================== 错误码 ====================
    
    /** 成功 */
    const val CODE_SUCCESS = "10000"
    
    /** 参数非法 */
    const val CODE_PARAM_ILLEGAL = "10001"
    
    /** 失败 */
    const val CODE_FAILED = "10002"
    
    /** 仅支持 Android */
    const val CODE_ONLY_ANDROID = "10003"
    
    /** 仅支持 iOS */
    const val CODE_ONLY_IOS = "10004"
    
    /** 平台不支持 */
    const val CODE_NOT_SUPPORT = "10005"
    
    /** 无网络 */
    const val CODE_NO_NET = "10006"
    
    // ==================== 错误消息 ====================
    
    /** 标签为空 */
    const val MSG_TAGS_EMPTY = "tags can not be empty"
    
    /** 账号为空 */
    const val MSG_ACCOUNT_EMPTY = "account can not be empty"
    
    /** 别名为空 */
    const val MSG_ALIAS_EMPTY = "alias can not be empty"
    
    /** 手机号为空 */
    const val MSG_PHONE_EMPTY = "phone can not be empty"
    
    /** 仅支持 Android */
    const val MSG_ONLY_ANDROID = "Only support Android"
    
    /** 仅支持 iOS */
    const val MSG_ONLY_IOS = "Only support iOS"
    
    /** 无网络 */
    const val MSG_NO_NETWORK = "no network"

}