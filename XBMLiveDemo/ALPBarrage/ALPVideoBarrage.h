//
//  ALPVideoBarrage.h
//
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//  frame的高>=

#import <UIKit/UIKit.h>
#import "ALPBarrageView.h"

@protocol ALPVideoBarrageDelegate <NSObject>

/**
 *  点击弹幕的回调协议方法
 *  @usrID 发送弹幕的用户ID
 */
- (void)touchMessage:(NSString *)usrID;


/**
 弹幕完成
 */
- (void)videoBarrageDidComplete;

@end

@interface ALPVideoBarrage : UIView

@property (nonatomic, weak) id<ALPVideoBarrageDelegate> delegate;

/**
 *  弹幕开始
 *  @message 弹幕信息
 *  @name 发送弹幕的用户名（昵称）
 *  @level 发送弹幕的用户等级
 *  @usrID 发送弹幕的用户ID
 */
- (void)startWithMessasge:(NSString *)message
                     name:(NSString *)name
                    level:(NSString *)level
                   userID:(NSString *)usrID;

/**
 *  弹幕开始
 *  @message 弹幕信息
 *  @name 发送弹幕的用户名（昵称）
 *  @level 发送弹幕的用户等级
 *  @usrID 发送弹幕的用户ID
 *  @type 弹幕发送者：BarrageTypeSelf 自己，BarrageTypeOther 对方
 */

- (void)startWithMessasge:(NSString *)message
                     name:(NSString *)name
                    level:(NSString *)level
                   userID:(NSString *)usrID
                     type:(BarrageType)type;
/**
 *  弹幕开始
 *  @dict = @{@"name":name, @"level":level, @"message":message, @"type":type}
 *  @message 弹幕信息
 *  @name 发送弹幕的用户名（昵称）
 *  @level 发送弹幕的用户等级
 *  @usrID 发送弹幕的用户ID
 *  @type 弹幕发送者：BarrageTypeSelf 自己，BarrageTypeOther 对方
 */
- (void)startWithBarrageDict:(NSDictionary *)barrageDict;

@end
