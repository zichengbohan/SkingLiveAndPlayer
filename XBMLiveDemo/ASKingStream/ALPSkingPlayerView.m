//
//  ALPSkingPlayerView.m
//  AllLivePlayer
//
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 hzky. All rights reserved.
//

#import "ALPSkingPlayerView.h"
#import "ALPMediaPlayeProgress.h"

//rtmp://rtmppush.ejucloud.com/ehoush/aaa

@interface ALPSkingPlayerView () <ALPMediaPlayeProgressDelegate>

//金山播放器
@property (nonatomic, strong) KSYMoviePlayerController *player;

@property (nonatomic, strong) ALPMediaPlayeProgress *slider;

@property (nonatomic, strong) NSTimer * playTimer;

@property (nonatomic, assign) BOOL *isHasSlider;

@end

@implementation ALPSkingPlayerView

- (instancetype)initWithPlayerURL:(NSURL *)url type:(BOOL)showSlider {
    self = [super init];
    if (self) {
        self.isHasSlider = &(showSlider);
//        url = [NSURL URLWithString:@"http://downmp413.ffxia.com/mp413/%E9%BB%91%E9%BE%99_%E7%8E%8B%E7%92%90%E5%B2%A2-YouAreMyBaby[68mtv.com].mp4"];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _player = [[KSYMoviePlayerController alloc] initWithContentURL:url];
        _player.controlStyle = MPMovieControlStyleNone;
        [_player.view setFrame:self.bounds];
        [self addSubview:_player.view];
        self.autoresizesSubviews = YES;
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _player.shouldAutoplay = TRUE;
        _player.scalingMode = MPMovieScalingModeAspectFit;
        //播放器完成对视频文件的初始化时发送此通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                                  object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerPlaybackDidFinishNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                                  object:nil];
        [self playSlider];
    }
    
    return self;
}


- (void)playSlider {
    _slider = [[ALPMediaPlayeProgress alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 105, SCREEN_WIDTH, 25)];
    _slider.delegate = self;
    if (_isHasSlider) {
      [_player.view addSubview:_slider];
    }
}

- (void)startPlay {
    [_player prepareToPlay];
}

- (void)stopPlay {
    [_player stop];
}

- (void)reStartPlay {
    [_player play];
}

- (void)pausePlay {
    [_player pause];
}

- (void)handlePlayerNotify:(NSNotification *)notify {
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {//播放结束（正常结束，异常结束）
        if ([self.delegate respondsToSelector:@selector(playerStatus:)]) {
            [self.delegate playerStatus:_player.playbackState];
        }
        NSLog(@"player finish state: %ld", (long)_player.playbackState);
        NSLog(@"fkmd");
        int reason = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
        if (reason ==  MPMovieFinishReasonPlaybackEnded) {
            
        }else if (reason == MPMovieFinishReasonPlaybackError){
            NSLog(@"errorCode:%@", notify.userInfo[@"error"]);
            NSLog(@"错误原因:%@", [self codeErrorStr:notify.userInfo[@"error"]]);
            
        }else if (reason == MPMovieFinishReasonUserExited){
            NSLog(@"fkmd");
        }
    } else if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {//播放状态改变
        if ([self.delegate respondsToSelector:@selector(playerStatus:)]) {
            [self.delegate playerStatus:_player.playbackState];
        }
        NSLog(@"------------------------");
        NSLog(@"player playback state: %ld", (long)_player.playbackState);
        NSLog(@"------------------------");
    } else if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification == notify.name) {
        if (_isHasSlider) {
            _slider.palyCountTime = _player.duration;
            _playTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playMove) userInfo:nil repeats:YES];
        }
        
    }
}

- (void)playMove {
    if (_player.duration - _player.currentPlaybackTime < 1) {
        [_playTimer setFireDate:[NSDate distantFuture]];
    }
    _slider.currentTime = _player.currentPlaybackTime;
}

- (NSString *)codeErrorStr:(NSString *)code {
    NSString *errorStr = @"";
    switch (code.intValue) {
        case 1:
            errorStr = @"未知的播放器错误";
            break;
        case -1004:
            errorStr = @"文件或网络相关操作错误";
            break;
        case -10001:
            errorStr = @"不支持的流媒体协议";
            break;
        case -10002:
            errorStr = @"DNS解析失败";
            break;
        case -10003:
            errorStr = @"创建socket失败";
            break;
        case -10004:
            errorStr = @"连接服务器失败";
            break;
        case -10005:
            errorStr = @"http请求返回400";
            break;
        case -10006:
            errorStr = @"http请求返回401";
            break;
        case -10007:
            errorStr = @"http请求返回403";
            break;
        case -10008:
            errorStr = @"http请求返回404";
            break;
        case -10009:
            errorStr = @"http请求返回4xx";
            break;
        case -10010:
            errorStr = @"http请求返回5xx";
            break;
        case -10011:
            errorStr = @"无效的媒体数据";
            break;
        case -10012:
            errorStr = @"不支持的视频编码类型";
            break;
        case -10013:
            errorStr = @"不支持的音频编码类型";
            break;
        case -10016:
            errorStr = @"视频解码失败";
            break;
        case -10017:
            errorStr = @"音频解码失败";
            break;
        case -10018:
            errorStr = @"多次3xx跳转";
            break;
            
        default:
            break;
    }
    return errorStr;
}

- (void)reload:(NSURL *)url {
    [_player reload:url is_flush:YES];
}

#pragma mark 点击暂停、播放切换的代理方法ALPMediaPlayeProgressDelegate
- (void)didSelectStartButton:(BOOL)isPause {
    if (isPause) {
        [_playTimer setFireDate:[NSDate distantFuture]];
        [self pausePlay];
    } else {
        [_playTimer setFireDate:[NSDate date]];
        [self reStartPlay];
    }
}

- (void)didChangedPlayTime:(double)timer {
    [_playTimer setFireDate:[NSDate date]];
    _player.currentPlaybackTime = timer;
    [self reStartPlay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_player stop];
    [_playTimer invalidate];
    _playTimer = nil;

}

@end
