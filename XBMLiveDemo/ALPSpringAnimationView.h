//
//  ALPSpringAnimationView.h
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/29.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALPSpringAnimationViewDelegate <NSObject>

/**
 *  点击礼物的回调协议方法
 *  @usrID 发送弹幕的用户ID
 */
- (void)touchMessage:(NSString *)usrID;

@end

@interface ALPSpringAnimationView : UIView

@property (nonatomic, weak) id<ALPSpringAnimationViewDelegate> delegate;

/**
 *  展示礼物传参
 *
 *  @param giftName 礼物名称
 *  @param userName  发送礼物用户名称
 *  @param userImgUrl 用户头像Url
 *  @param giftImageUrl  礼物图片URl
 *  @param num 礼物数量
 *  @param giftID  礼物ID标识是否同一个礼物
 *
 *  @return 
 */

- (void)showGiftName:(NSString *)giftName
            userName:(NSString *)userName
            userIcon:(NSURL *)userImgUrl
           giftImage:(NSURL *)giftImageUrl
             giftNum:(NSString *)num
              giftID:(NSString *)giftID;

/**
 *  展示礼物传参
 *
 *  @param giftName 礼物名称
 *  @param userName  发送礼物用户名称
 *  @param userImgUrl 用户头像Url
 *  @param giftImageUrl  礼物图片URl
 *  @param num 礼物数量
 *  @param giftID  礼物ID标识是否同一个礼物
 *  @param userID  用户ID标识是否同一个人发送礼物
 *
 *  @return 实例对象
 */

- (void)showGiftName:(NSString *)giftName
            userName:(NSString *)userName
            userIcon:(NSURL *)userImgUrl
           giftImage:(NSURL *)giftImageUrl
             giftNum:(NSString *)num
              giftID:(NSString *)giftID
              userID:(NSString *)userID;


@end
