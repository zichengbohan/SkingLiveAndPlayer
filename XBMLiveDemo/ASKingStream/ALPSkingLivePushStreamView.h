//
//  ALPSkingLivePushStreamView.h
//  AllLivePlayer
//  直播推流类
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 hzky. All rights reserved.
//使用说明
//        ALPSkingLivePushStreamView *streamView = [[ALPSkingLivePushStreamView alloc] initWithpushStreamURL:[NSURL URLWithString:@"rtmp://rtmppush.ejucloud.com/ehoush/aaa"]];
//        self.view = streamView;
//        [streamView startCamera];
//    [streamView startBeautiful];
//    [streamView startStream];

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^swicthLightResultBlock)(BOOL result);

@interface ALPSkingLivePushStreamView : UIView

@property (nonatomic, copy) swicthLightResultBlock swichLightResultBlock;
//是否自动重连
@property (nonatomic, assign) BOOL isAutoReconnect;
//闪光灯状态
@property (nonatomic, assign) AVCaptureTorchMode lightStatus;
//
@property (nonatomic, assign) BOOL streamStatus;

@property (nonatomic, assign) BOOL isBeautiful;

/**
 *  开启摄像头
 **/
- (void)startCamera;

/**
 *  开始推流
 **/
- (void)startStreamWithPushStreamURL:(NSURL *)url;

/**
 *  停止推流
 **/
- (void)stopStream;

/**
 *  开启美颜
 **/
- (void)startBeautiful;

/**
 *  开启美颜
 **/
- (void)closeBeautiful;

/**
 *  切换前后摄像头
 **/
- (void)switchCamera;

/**
 *  打开闪光灯
 *  block传值YES切换成功，值为NO则不支持闪光灯
 **/
- (void)startLightMode:(AVCaptureTorchMode)mode resultBlock:(swicthLightResultBlock)block;


@end
