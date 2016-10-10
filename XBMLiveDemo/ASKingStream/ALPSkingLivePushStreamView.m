//
//  ALPSkingLivePushStreamView.m
//  AllLivePlayer
//
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 hzky. All rights reserved.
//

#import "ALPSkingLivePushStreamView.h"
//金山推流SDK
#import <GPUImage/GPUImage.h>
#import <libksygpulive/libksygpulive.h>
#import <libksygpulive/libksygpuimage.h>
#import <libksygpulive/KSYGPUBeautifyPlusFilter.h> //金山美颜类
#import <libksygpulive/KSYGPUSkinWhiteFilter.h>
#import <libksygpulive/KSYGPUBeautifyFilter.h>

@interface ALPSkingLivePushStreamView ()

//推流地址@"rtmp://rtmppush.ejucloud.com/ehoush/aaa"
@property (nonatomic, strong) NSURL *streamURL;
//金山推流集成工具
@property (nonatomic, strong) KSYGPUStreamerKit *kit;
//金山美颜
@property (nonatomic, strong) KSYGPUBeautifyPlusFilter *filter;
@property (nonatomic, strong) KSYGPUBeautifyFilter *breatfilter;
//@property (nonatomic, strong) KSYSkinWhiteFilter *proWhitenFilter;

@end

@implementation ALPSkingLivePushStreamView

- (instancetype)init {
    self = [super init];
    if (self) {
        _isAutoReconnect = YES;
        //        _streamURL = url;
        
        _kit = [[KSYGPUStreamerKit alloc] initWithDefaultCfg];
        NSLog(@"%@", [_kit getKSYVersion]);
        _kit.streamerBase.audiokBPS = 48;
        _kit.streamerBase.videoCodec = KSYVideoCodec_AUTO;
        _kit.streamerBase.enAutoApplyEstimateBW = YES;
        _kit.streamerBase.videoInitBitrate = 700;
        _kit.streamerBase.videoMaxBitrate  = 1000; // k bit ps
        _kit.streamerBase.videoMinBitrate  = 200; // k bit ps
        _kit.videoDimension = KSYVideoDimension_UserDefine_Crop;
        _kit.videoDimensionUserDefine = CGSizeMake(640, 360);
        _kit.videoFPS = 24;
        
        [self setNotificationForStreamer];
       
        
        _filter = [[KSYGPUBeautifyPlusFilter alloc] init];
    }
    
    return self;
}

- (void)setNotificationForStreamer {
    
    //启停采集和消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCaptureStateChange:)
                                                 name:KSYCaptureStateDidChangeNotification
                                               object:nil];
    
    //推流状态变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStreamStateChange:)
                                                 name:KSYStreamStateDidChangeNotification
                                               object:nil];
    //当码率调整时，会有相应的事件通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetStateEvent:)
                                                 name:KSYNetStateEventNotification
                                               object:nil];
   
}

#pragma mark 金山推流操作

- (void)startCamera {
    
    [_kit startPreview:self];
    
}

- (void)startStreamWithPushStreamURL:(NSURL *)url {
    
    [_kit.streamerBase startStream:url];
    
}

- (void)stopStream {
    
    [_kit.streamerBase stopStream];
    
}

- (void)switchCamera {
    
    [_kit switchCamera];
    
}

- (void)startBeautiful {
    self.isBeautiful = YES;
    _breatfilter = [[KSYGPUBeautifyFilter alloc] init];
    [_breatfilter setBeautylevel:3];
    [_kit setupFilter:_breatfilter];
//    [_kit setupFilter:_filter];

}

- (void)closeBeautiful {
    self.isBeautiful = NO;
    [_kit setupFilter:nil];
}

- (void)startLightMode:(AVCaptureTorchMode)mode resultBlock:(swicthLightResultBlock)resultBlock {
    if ([_kit isTorchSupported]) {//是否支持闪光灯
        [_kit setTorchMode:mode];
        _lightStatus = mode;
        if (resultBlock) {
            resultBlock(YES);
        }
        
    } else {//不支持闪光灯
        _lightStatus = AVCaptureTorchModeOff;
        if (resultBlock) {
            resultBlock(NO);
        }
        
    }
    
}

- (BOOL)streamStatus {
    return [_kit.streamerBase isStreaming];
}

# pragma mark 推流通知响应事件
//启停采集和消息通知
- (void) onCaptureStateChange:(NSNotification *)notification {
    if ( _kit.captureState == KSYCaptureStateIdle){
        NSLog(@"idle");
    }
    else if (_kit.captureState == KSYCaptureStateCapturing ) {
        NSLog(@"capturing");
    }
    else if (_kit.captureState == KSYCaptureStateClosingCapture ) {
        NSLog(@"closing capture");
    }
    else if (_kit.captureState == KSYCaptureStateDevAuthDenied ) {
        NSLog(@"camera/mic Authorization Denied");
    }
    else if (_kit.captureState == KSYCaptureStateParameterError ) {
        NSLog(@"capture devices ParameterErro");
    }
    else if (_kit.captureState == KSYCaptureStateDevBusy ) {
        NSLog(@"device busy, try later");
    }
}

- (void) onStreamStateChange:(NSNotification *)notification {
    if ( _kit.streamerBase.streamState == KSYStreamStateIdle) {//空闲
        NSLog(@"idle");
    }
    else if ( _kit.streamerBase.streamState == KSYStreamStateConnected){//已连接
        NSLog(@"connected");
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateConnecting ) {//连接中
        NSLog(@"kit connecting");
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateDisconnecting ) {//断开连接中
        NSLog(@"disconnecting");
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateError ) {//推流出错
        [self onStreamError];
    }
}

- (void) onNetStateEvent:(NSNotification *)notification {
    KSYNetStateCode netEvent = _kit.streamerBase.netStateCode;
    if ( netEvent == KSYNetStateCode_SEND_PACKET_SLOW ) {
        NSLog(@"bad network" );
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_RAISE ) {
        NSLog(@"bitrate raising" );
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_DROP ) {
        NSLog(@"bitrate dropping" );
    }
}

- (void) onStreamError {
    KSYStreamErrorCode err = _kit.streamerBase.streamErrorCode;
    if ( KSYStreamErrorCode_KSYAUTHFAILED == err ) {
        NSLog(@"SDK auth failed, \npls check ak/sk");
    }
    else if ( KSYStreamErrorCode_CODEC_OPEN_FAILED == err) {
        NSLog(@"无法打开配置指示的CODEC");
    }
    else if ( KSYStreamErrorCode_CONNECT_FAILED == err) {//链接出错检查地址
        NSLog(@"链接出错检查地址");
    }
    else if ( KSYStreamErrorCode_CONNECT_BREAK == err) {// 网络连接中断
        NSLog( @"网络连接中断");
    }
    else {
//        _stat.text = [_kit getKSYStreamErrorCodeName:err];
    }
    // 断网重连
    if ( KSYStreamErrorCode_CONNECT_BREAK == err && _isAutoReconnect ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_kit.streamerBase stopStream];
            [_kit.streamerBase startStream:_streamURL];
//            [self initStatData];
        });
    }
}

- (NSString *)getCodeStr:(NSNumber *)code {
    NSDictionary *dict = @{
                           @"":@""
                           };
    return dict[@""];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
