//
//  ALPBarrageLineView.h
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/10/9.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALPBarrageLineViewDelegate <NSObject>
//弹幕加速
- (void)animateSpeed;
//点击弹幕
- (void)touchLineMessage:(NSString *)userID;

@end

@interface ALPBarrageLineView : UIView

@property (nonatomic, weak) id<ALPBarrageLineViewDelegate> delegate;

//正常弹幕：有正在以正常速度运动的弹幕，未触到左边框加速
- (BOOL)startNomal;

- (void)startBarrageWithMessageDict:(NSDictionary *)messageDic;

@end
