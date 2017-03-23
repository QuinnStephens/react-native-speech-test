//
//  SpeechManagerBridge.m
//  SpeechTest
//
//  Created by Quinn Stephens on 3/23/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(SpeechManager, NSObject)

RCT_EXTERN_METHOD(getPermission:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(toggleRecording:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

@end
