package com.speechtest;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class SpeechModule extends ReactContextBaseJavaModule {

  public SpeechModule(ReactApplicationContext context) {
    super(context);
  }

  @Override
  public String getName() {
    return "SpeechManager";
  }

  @ReactMethod
  public void getPermission(Promise promise) {
    promise.resolve("Klatuu barada nikto");
  }

  @ReactMethod
  public void speak(String text) {
    Log.i("SPEECH", text);
  }

}
