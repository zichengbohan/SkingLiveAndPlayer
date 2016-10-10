//
//  SkingStreamerViewController.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/9/1.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "SkingStreamerViewController.h"
#import "ALPSkingLivePushStreamView.h"
#import "ALPVideoBarrage.h"
#import <GT/GT.h>
#import "MediaPlayerViewController.h"
#import "ALPSpringAnimationView.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface SkingStreamerViewController () <ALPVideoBarrageDelegate>

@property (nonatomic, strong) ALPVideoBarrage *bar;

@property (nonatomic, strong) ALPSkingLivePushStreamView *sview;

@property (nonatomic, strong) ALPSpringAnimationView *myView;


@end

@implementation SkingStreamerViewController

- (id)init {
    self = [UIStoryboard storyboardWithName:@"SKingStreamerViewController" bundle:nil].instantiateInitialViewController;
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgView = self.view;
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    _sview = [[ALPSkingLivePushStreamView alloc] init];
    _sview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.view = _sview;
    [self.view addSubview:bgView];
    [_sview startCamera];
    
    [_sview startStreamWithPushStreamURL:[NSURL URLWithString:@"rtmp://pili-publish.qdtong.net/leju-live-2/b98003?key=0e6fd69a402d9c3e&token=ejutest"]];
    
    _bar = [[ALPVideoBarrage alloc] init];
    _bar.frame = CGRectMake(0, 70, SCREEN_HEIGHT, 80);
    [self.view addSubview:_bar];
    [_bar startWithMessasge:@"我是弹幕我是" name:@"name" level:@"lv12" userID:@"123"];
    
    _myView = [[ALPSpringAnimationView alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 205)];
    //    _myView.frame = CGRectMake(0, 250, 60, 105);
    [self.view addSubview:_myView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    for (int i = 0; i < 1; i ++) {
        //        [_bar startBarrageWithMessage:@"我是弹幕我是弹幕我是弹幕我是弹幕我是弹幕1"];
    }
    MediaPlayerViewController *vc = [[MediaPlayerViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)danmu:(id)sender {
    NSMutableArray *ar = [[NSMutableArray alloc] init];
    [_bar startWithMessasge:@"我是弹幕弹幕弹幕" name:@"Name" level:@"lv2" userID:@"4321" type:BarrageTypeSelf];
    for (int i = 0; i<100; i ++) {
        [ar addObject:[NSString stringWithFormat:@"i am a %d", i]];
    }
    //    [_bar startBarrages:ar];
    //     [_sview switchCamera];
    
}

- (IBAction)danmuOther:(id)sender {
    NSMutableArray *ar = [[NSMutableArray alloc] init];
    NSDictionary *dic = @{@"name":@"Name", @"level":@"lv2", @"message":@"我是弹幕弹幕弹幕", @"type":[NSNumber numberWithInt:BarrageTypeOther]};
    [_bar startWithBarrageDict:dic];
    for (int i = 0; i<100; i ++) {
        [ar addObject:[NSString stringWithFormat:@"i am a %d", i]];
    }
}

- (IBAction)giftClicked:(id)sender {
    [_myView showGiftName:@"大力丸" userName:@"李死" userIcon:[NSURL new] giftImage:[NSURL new] giftNum:@"298" giftID:@"111" userID:@"123"];
}

@end
