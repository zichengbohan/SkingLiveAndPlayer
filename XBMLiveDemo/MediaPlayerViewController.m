//
//  MediaPlayerViewController.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/8.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import "ALPSkingPlayerView.h"
#import <GT/GT.h>


#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MediaPlayerViewController ()

@property (nonatomic, strong) ALPSkingPlayerView *player;
@property (nonatomic, strong) UIView *videoView;

@end

@implementation MediaPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.view.backgroundColor = [UIColor whiteColor];
    _videoView = [[UIView alloc] init];
    _videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _videoView.backgroundColor = [UIColor lightGrayColor];
    
    _player = [[ALPSkingPlayerView alloc] initWithPlayerURL:[NSURL URLWithString:@"?key=6eeee8a82246636"] type:YES];
    [_player startPlay];
    
    [_videoView addSubview:_player];
    _videoView.autoresizesSubviews = TRUE;
    self.view = _videoView;
    
    [self createCloseButton];
}

- (void)createCloseButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 60, 30)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cliked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)cliked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
