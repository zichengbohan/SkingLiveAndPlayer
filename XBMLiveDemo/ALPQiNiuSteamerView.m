//
//  ALPQiNiuSteamerView.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/9/2.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "ALPQiNiuSteamerView.h"
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
#import "Reachability.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

const char *stateNames[] = {
    "Unknow",
    "Connecting",
    "Connected",
    "Disconnecting",
    "Disconnected",
    "Error"
};

const char *networkStatus[] = {
    "Not Reachable",
    "Reachable via WiFi",
    "Reachable via CELL"
};

@interface ALPQiNiuSteamerView ()

@property (nonatomic, strong) PLCameraStreamingSession  *session;
@property (nonatomic, strong) NSArray<PLVideoStreamingConfiguration *>   *videoStreamingConfigurations;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSDate    *keyTime;

@property (nonatomic, strong) NSURL *streamURL;
@property (nonatomic, assign) BOOL audioEffectOn;
//开始推流按钮
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation ALPQiNiuSteamerView

- (id)init {
    self = [super init];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 70, 320, 320)];
        self.textView.backgroundColor = [UIColor clearColor];
        // 预先设定几组编码质量，之后可以切换
        CGSize videoSize = CGSizeMake(480 , 640);
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if (orientation <= AVCaptureVideoOrientationLandscapeLeft) {
            if (orientation > AVCaptureVideoOrientationPortraitUpsideDown) {
                videoSize = CGSizeMake(640 , 480);
            }
        }
        self.videoStreamingConfigurations = @[
                                              [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize expectedSourceVideoFrameRate:30 videoMaxKeyframeInterval:45 averageVideoBitRate:400 * 1000 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                              [[PLVideoStreamingConfiguration alloc] initWithVideoSize:CGSizeMake(800 , 480) expectedSourceVideoFrameRate:30 videoMaxKeyframeInterval:72 averageVideoBitRate:600 * 1000 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                              [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize expectedSourceVideoFrameRate:30 videoMaxKeyframeInterval:90 averageVideoBitRate:800 * 1000 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                              ];
        self.sessionQueue = dispatch_queue_create("pili.queue.streaming", DISPATCH_QUEUE_SERIAL);
        // 网络状态监控
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        
        void (^permissionBlock)(void) = ^{
            dispatch_async(self.sessionQueue, ^{
                PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
                videoCaptureConfiguration.sessionPreset = AVCaptureSessionPresetHigh;
                
                PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
                // 视频编码配置
                PLVideoStreamingConfiguration *videoStreamingConfiguration = [self.videoStreamingConfigurations lastObject];
                // 音频编码配置
                PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
                AVCaptureVideoOrientation orientation = (AVCaptureVideoOrientation)(([[UIDevice currentDevice] orientation] <= UIDeviceOrientationLandscapeRight && [[UIDevice currentDevice] orientation] != UIDeviceOrientationUnknown) ? [[UIDevice currentDevice] orientation]: UIDeviceOrientationPortrait);
                // 推流 session
                self.session = [[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil videoOrientation:orientation];
                self.session.delegate = self;
                self.session.bufferDelegate = self;
                UIImage *waterMark = [UIImage imageNamed:@"qiniu.png"];
                [self.session setWaterMarkWithImage:waterMark position:CGPointMake(100, 300)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *previewView = self.session.previewView;
                    previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
                    [self insertSubview:previewView atIndex:0];
                    
                    NSString *log = [NSString stringWithFormat:@"Zoom Range: [1..%.0f]", self.session.videoActiveFormat.videoMaxZoomFactor];
                    NSLog(@"%@", log);
                    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
                });
            });
        };
        
        void (^noAccessBlock)(void) = ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access", nil)
                                                                message:NSLocalizedString(@"!", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        };
        
        switch ([PLCameraStreamingSession cameraAuthorizationStatus]) {
            case PLAuthorizationStatusAuthorized:
                permissionBlock();
                break;
            case PLAuthorizationStatusNotDetermined: {
                [PLCameraStreamingSession requestCameraAccessWithCompletionHandler:^(BOOL granted) {
                    granted ? permissionBlock() : noAccessBlock();
                }];
            }
                break;
            default:
                noAccessBlock();
                break;
        }


    }
    [self addSubview:self.textView];
    [self createViews];
    return self;
}

- (void)createViews {
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 50, 60, 30)];
    [self.actionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton setTitle:@"开始推流" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"停止推流" forState:UIControlStateSelected];
    [self addSubview:self.actionButton];
}

- (void)buttonClicked:(id)sender {
    if (sender == self.actionButton) {
        if (self.actionButton.selected) {
            [self stopSession];
        } else {
            [self startSessionWithPushStreamerURL:self.streamURL];
        }
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    dispatch_sync(self.sessionQueue, ^{
        [self.session destroy];
    });
    self.session = nil;
    self.sessionQueue = nil;
}

#pragma mark - Notification Handler

- (void)reachabilityChanged:(NSNotification *)notif{
    Reachability *curReach = [notif object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (NotReachable == status) {
        // 对断网情况做处理
        [self stopSession];
    }
    
    NSString *log = [NSString stringWithFormat:@"Networkt Status: %s", networkStatus[status]];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
}

#pragma mark - <PLStreamingSendingBufferDelegate>

- (void)streamingSessionSendingBufferDidFull:(id)session {
    NSString *log = @"Buffer is full";
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
}

- (void)streamingSession:(id)session sendingBufferDidDropItems:(NSArray *)items {
    NSString *log = @"Frame dropped";
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
}

#pragma mark - <PLCameraStreamingSessionDelegate>

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSString *log = [NSString stringWithFormat:@"Stream State: %s", stateNames[state]];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
    
    // 除 PLStreamStateError 外的其余状态会回调在这个方法
    // 这个回调会确保在主线程，所以可以直接对 UI 做操作
    if (PLStreamStateConnected == state) {
        [self.actionButton setTitle:NSLocalizedString(@"停止推流", nil) forState:UIControlStateNormal];
        self.actionButton.selected = YES;
    } else if (PLStreamStateDisconnected == state) {
        [self.actionButton setTitle:NSLocalizedString(@"开始推流", nil) forState:UIControlStateNormal];
        self.actionButton.selected = NO;
    }
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSString *log = [NSString stringWithFormat:@"Stream State: Error. %@", error];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
    // PLStreamStateError 都会回调在这个方法
    // 尝试重连，注意这里需要你自己来处理重连尝试的次数以及重连的时间间隔
    [self.actionButton setTitle:NSLocalizedString(@"Reconnecting", nil) forState:UIControlStateNormal];
    [self startSessionWithPushStreamerURL:self.streamURL];
}

- (CVPixelBufferRef)cameraStreamingSession:(PLCameraStreamingSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    NSLog(@"get frame");
    return pixelBuffer;
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status {
    NSString *log = [NSString stringWithFormat:@"%@", status];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
    
#if kReloadConfigurationEnable
    NSDate *now = [NSDate date];
    if (!self.keyTime) {
        self.keyTime = now;
    }
    
    double expectedVideoFPS = (double)self.session.videoConfiguration.videoFrameRate;
    double realtimeVideoFPS = status.videoFPS;
    if (realtimeVideoFPS < expectedVideoFPS * (1 - kMaxVideoFPSPercent)) {
        // 当得到的 status 中 video fps 比设定的 fps 的 50% 还小时，触发降低推流质量的操作
        self.keyTime = now;
        
        [self lowerQuality];
    } else if (realtimeVideoFPS >= expectedVideoFPS * (1 - kMinVideoFPSPercent)) {
        if (-[self.keyTime timeIntervalSinceNow] > kHigherQualityTimeInterval) {
            self.keyTime = now;
            
            [self higherQuality];
        }
    }
#endif  // #if kReloadConfigurationEnable
}

#pragma mark -

- (void)higherQuality {
    NSUInteger idx = [self.videoStreamingConfigurations indexOfObject:self.session.videoStreamingConfiguration];
    NSAssert(idx != NSNotFound, @"Oops");
    
    if (idx >= self.videoStreamingConfigurations.count - 1) {
        return;
    }
    PLVideoStreamingConfiguration *newStreamingConfiguration = self.videoStreamingConfigurations[idx + 1];
    [self.session reloadVideoStreamingConfiguration:newStreamingConfiguration videoCaptureConfiguration:nil];
}

- (void)lowerQuality {
    NSUInteger idx = [self.videoStreamingConfigurations indexOfObject:self.session.videoStreamingConfiguration];
    NSAssert(idx != NSNotFound, @"Oops");
    
    if (0 == idx) {
        return;
    }
    PLVideoStreamingConfiguration *newStreamingConfiguration = self.videoStreamingConfigurations[idx - 1];
    [self.session reloadVideoStreamingConfiguration:newStreamingConfiguration videoCaptureConfiguration:nil];
}

#pragma mark - Operation

- (void)stopSession {
    dispatch_async(self.sessionQueue, ^{
        self.keyTime = nil;
        [self.session stop];
    });
}

- (void)startSessionWithPushStreamerURL:(NSURL *)streamerURL {
    
    self.keyTime = nil;
    self.actionButton.enabled = NO;
    dispatch_async(self.sessionQueue, ^{
        // 在开始直播之前请确保已经从业务服务器获取到了 streamURL，streamURL 的格式为 "rtmp://"
//        self.streamURL = [NSURL URLWithString:@"rtmp://pili-publish.pilitest.qiniucdn.com/pilitest/demo_test?key=6eeee8a82246636e"];
        self.streamURL = streamerURL;
        [self.session startWithPushURL:self.streamURL feedback:^(PLStreamStartStateFeedback feedback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.actionButton.enabled = YES;
            });
        }];
    });
}

- (void)startBeautful {
    [self.session setBeautifyModeOn:YES];
    [self.session setBeautify:1];
    [self.session setWhiten:0.5];
    [self.session setRedden:0.5];
}

@end
