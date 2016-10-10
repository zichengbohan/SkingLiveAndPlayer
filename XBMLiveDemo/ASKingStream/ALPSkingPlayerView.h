//
//  ALPSkingPlayerView.h
//  AllLivePlayer
//  直播拉流、播放器，可自定义带不带进度条
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 hzky. All rights reserved.
//使用说明
//ALPSkingPlayerView *playerView = [[ALPSkingPlayerView alloc] initWithPlayerURL:[NSURL URLWithString:@"rtmp://rtmppush.ejucloud.com/ehoush/aaa"]];
//self.view = playerView;
//

#import <UIKit/UIKit.h>
#import <libksygpulive/KSYMediaPlayer.h>

@protocol ALPSkingPlayerViewDelegate <NSObject>

- (void)playerStatus:(MPMoviePlaybackState)status;

@end

@interface ALPSkingPlayerView : UIView

@property (nonatomic, weak) id<ALPSkingPlayerViewDelegate> delegate;

//url 点播，拉流通用
/**
 *  初始化
 *  @hasSlider 是否有进度条
 **/
- (instancetype)initWithPlayerURL:(NSURL *)url type:(BOOL)hasSlider;

//开始播放
- (void)startPlay;
//停止播放
- (void)stopPlay;
//暂停播放
- (void)pausePlay;
//暂停后再次开始播放
- (void)reStartPlay;

//重新加载
- (void)reload:(NSURL *)url;

@end
