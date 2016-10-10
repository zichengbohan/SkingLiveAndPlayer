//
//  JinNiuViewController.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/9/1.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "JinNiuViewController.h"
//#import <PLCameraStreamingKit/PLCameraStreamingKit.h>
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>

#import "ALPQiNiuSteamerView.h"

@interface JinNiuViewController ()

@property (nonatomic, strong) PLCameraStreamingSession *session;
@property (nonatomic, strong) NSURL *streamURL;

@end

@implementation JinNiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    [PLStreamingEnv initEnv];
    ALPQiNiuSteamerView *view = [[ALPQiNiuSteamerView alloc] init];
    self.view = view;
    [view startSessionWithPushStreamerURL:[NSURL URLWithString:@"rtmp://pili-publish.pilitest.qiniucdn.com/pilitest/demo_test?key=6eeee8a82246636e"]];
//
//    PLStream *stream = [PLStream streamWithJSON:nil];
//    
//    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
//    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
//    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
//    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
//    
//    self.session = [[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:stream videoOrientation:AVCaptureVideoOrientationPortrait];
//    
//    [self.view addSubview:self.session.previewView];
//    
////    [self.session startWithCompleted:^(BOOL success) {
////        if (success) {
////            NSLog(@"Streaming started.");
////        } else {
////            NSLog(@"Oops.");
////        }
////    }];
//    
//    self.streamURL = [NSURL URLWithString:@"rtmp://pili-publish.pilitest.qiniucdn.com/pilitest/demo_test?key=6eeee8a82246636e"];
//    [self.session startWithPushURL:self.streamURL feedback:^(PLStreamStartStateFeedback feedback) {
//        dispatch_async(dispatch_get_main_queue(), ^{
////            self.actionButton.enabled = YES;
//        });
//    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
