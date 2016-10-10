//
//  ViewController.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/8.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//  rtmp://rtmppush.ejucloud.com/ehoush/aaa

#import "ViewController.h"
#import "SkingStreamerViewController.h"
#import "JinNiuViewController.h"
#import "MediaPlayerViewController.h"

@interface ViewController () 


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        
   
}

- (IBAction)skingStreamer:(id)sender {
    SkingStreamerViewController *skingVC = [[SkingStreamerViewController alloc] init];
    [self.navigationController pushViewController:skingVC animated:YES];
}
- (IBAction)qiniuStramer:(id)sender {
    JinNiuViewController *qiniuvc = [[JinNiuViewController alloc] init];
    [self.navigationController pushViewController:qiniuvc animated:YES];
}
- (IBAction)payQiniu:(id)sender {
    MediaPlayerViewController *vc = [[MediaPlayerViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
