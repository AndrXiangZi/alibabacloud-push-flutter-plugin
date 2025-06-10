package com.aliyun.ams.push;

import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class AliyunPushHandler {
    //创建单例
    public static AliyunPushHandler instance = new AliyunPushHandler();

    private AliyunPushHandler() {
    }

    MethodChannel channel;

    public void init(BinaryMessenger binaryMessenger) {
        channel = new MethodChannel(binaryMessenger, "aliyun_push");
    }

    public void callFlutterMethod(String method, Map<String, Object> arguments) {
        if (channel == null) return;
        if (TextUtils.isEmpty(method)) {
            return;
        }

        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> channel.invokeMethod(method, arguments));
    }
}
