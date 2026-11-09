package com.aliyun.ams.push_example;

import android.content.Intent;
import android.os.Bundle;

import com.alibaba.sdk.android.push.popup.PopupNotifyClick;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

    private final PopupNotifyClick popupNotifyClick = new PopupNotifyClick();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        popupNotifyClick.onCreate(this, getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        popupNotifyClick.onNewIntent(intent);
    }
}
