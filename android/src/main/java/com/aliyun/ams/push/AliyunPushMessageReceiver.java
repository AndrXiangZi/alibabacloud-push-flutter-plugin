package com.aliyun.ams.push;

import java.util.HashMap;
import java.util.Map;

import com.alibaba.sdk.android.push.MessageReceiver;
import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.alibaba.sdk.android.push.notification.NotificationConfigure;
import com.alibaba.sdk.android.push.notification.PushData;

import android.app.Notification;
import android.content.Context;
import android.util.Log;
import androidx.core.app.NotificationCompat;

/**
 * @author wangyun
 * @date 2023/1/12
 * 
 * Updated for SDK 4.x and Pigeon:
 * - onNotificationOpened parameter changed to Map<String, String>
 * - Removed onNotificationClickedWithNoAction (merged into onNotificationOpened)
 * - Removed onNotificationReceivedInApp (merged into onNotification)
 * - Use Pigeon PushEventCallbackHandler for type-safe Flutter callbacks
 */

public class AliyunPushMessageReceiver extends MessageReceiver {

	// 消息接收部分的LOG_TAG
	public static final String REC_TAG = "MPS:receiver";

	@Override
	public NotificationConfigure hookNotificationBuild() {
		return new NotificationConfigure() {
			@Override
			public void configBuilder(Notification.Builder builder, PushData pushData) {
				AliyunPushLog.e(REC_TAG, "configBuilder");
			}

			@Override
			public void configBuilder(NotificationCompat.Builder builder, PushData pushData) {
				AliyunPushLog.e(REC_TAG, "configBuilder");
			}

			@Override
			public void configNotification(Notification notification, PushData pushData) {
				AliyunPushLog.e(REC_TAG, "configNotification");
			}
		};
	}

	@Override
	public boolean showNotificationNow(Context context, Map<String, String> map) {
		for (Map.Entry<String, String> entry : map.entrySet()) {
			AliyunPushLog.e(REC_TAG, "key " + entry.getKey() + " value " + entry.getValue());
		}

		return super.showNotificationNow(context, map);
	}

	/**
	 * 阿里云自有通道通知到达回调
	 * SDK 4.x: 统一通知到达回调
	 *
	 * @param context
	 * @param title
	 * @param summary
	 * @param extraMap
	 */
	@Override
	public void onNotification(Context context, String title, String summary,
							   Map<String, String> extraMap) {
		AliyunPushLog.d(REC_TAG, "onNotification: title=" + title + ", summary=" + summary);

		// 使用 EventChannel 事件回调
		PushEventChannel.INSTANCE.onNotification(title, summary, extraMap);
	}

	/**
	 * 阿里云自有通道消息到达回调
	 *
	 * @param context
	 * @param cPushMessage
	 */
	@Override
	public void onMessage(Context context, CPushMessage cPushMessage) {
		AliyunPushLog.d(REC_TAG, "onMessage: title=" + cPushMessage.getTitle());

		// 使用 EventChannel 事件回调
		PushEventChannel.INSTANCE.onMessage(
			cPushMessage.getTitle(),
			cPushMessage.getContent(),
			cPushMessage.getMessageId(),
			cPushMessage.getAppId(),
			cPushMessage.getTraceInfo()
		);
	}

	/**
	 * 阿里云自有通道和厂商通道通知点击回调
	 * SDK 4.x: 统一处理所有通道的通知点击，包括厂商通道
	 * 
	 * 注意：SDK 4.x 已将 onNotificationClickedWithNoAction 合并到此方法
	 *
	 * @param context
	 * @param title
	 * @param summary
	 * @param extraMap 新版参数类型为 Map<String, String>
	 */
	@Override
	public void onNotificationOpened(Context context, String title, String summary,
									 Map<String, String> extraMap) {
		AliyunPushLog.d(REC_TAG, "onNotificationOpened: title=" + title + ", summary=" + summary);

		// 使用 EventChannel 事件回调
		PushEventChannel.INSTANCE.onNotificationOpened(title, summary, extraMap);
	}

	/**
	 * 阿里云自有通道通知清除回调
	 *
	 * @param context
	 * @param messageId
	 */
	@Override
	public void onNotificationRemoved(Context context, String messageId) {
		AliyunPushLog.d(REC_TAG, "onNotificationRemoved: messageId=" + messageId);

		// 使用 EventChannel 事件回调
		PushEventChannel.INSTANCE.onNotificationRemoved(messageId);
	}
}