//
//  ALPMediaPlayeProgress.h
//  AllLivePlayer
//  播放器进度条类
//  Created by 胥佰淼 on 16/8/22.
//  Copyright © 2016年 hzky. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@protocol ALPMediaPlayeProgressDelegate <NSObject>
//播放，暂停按钮回调
- (void)didSelectStartButton:(BOOL)isPause;
//手动滑动进度条回调
- (void)didChangedPlayTime:(double)timer;

@end

@interface ALPMediaPlayeProgress : UIView

@property (nonatomic, weak) id<ALPMediaPlayeProgressDelegate> delegate;
//播放总时间
@property (nonatomic, assign) double palyCountTime;
//视频当前播放时间
@property (nonatomic, assign) double currentTime;

@end
