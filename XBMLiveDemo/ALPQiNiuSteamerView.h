//
//  ALPQiNiuSteamerView.h
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/9/2.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALPQiNiuSteamerView : UIView

- (void)startSessionWithPushStreamerURL:(NSURL *)streamerURL;

- (void)stopSession;

- (void)startBeautful;

@end
