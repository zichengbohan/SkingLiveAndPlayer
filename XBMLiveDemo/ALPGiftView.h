//
//  ALPGiftView.h
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/29.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALPGiftViewDelegate <NSObject>
//礼物消失后的回调
- (void)animateComplete;
//礼物向下移动完成的回调
- (void)moveDownComplete:(id)sender;

@end

@interface ALPGiftView : UIView
//显示中
@property (nonatomic, assign) BOOL showing;
//向下移动中
@property (nonatomic, assign) BOOL speeding;
//代理
@property (nonatomic, weak) id<ALPGiftViewDelegate> delegate;

/**
 *  显示礼物view动画
 *  @param giftName 礼物名称
 *  @param userName 用户名称
 *  @param userImgUrl 用户头像url
 *  @param giftImageUrl 礼物图像url
 *  @param num    礼物数量
 *  @param giftID 礼物ID
 */
- (void)showGiftName:(NSString *)giftName userName:(NSString *)userName userIcon:(NSURL *)userImgUrl giftImage:(NSURL *)giftImageUrl giftNum:(NSString *)num giftID:(NSString *)giftID;
/**
 *  向下移动
 */
- (void)moveDown;

@end
