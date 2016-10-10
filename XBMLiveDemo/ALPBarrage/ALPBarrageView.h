//
//  ALPBarrageView.h
//  弹幕类
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//  

#import <UIKit/UIKit.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//此枚举现在不用
typedef enum : NSUInteger {
    ViewTypeAboveFirst = 10000,
    ViewTypeAboveSecond,
    ViewTypeFollowFirst,
    ViewTypeFollowSecond
} ViewType;

typedef enum : NSUInteger {
    BarrageTypeSelf = 1,
    BarrageTypeOther,
    
} BarrageType;

typedef void(^StartBlock)(BOOL);

@protocol ALPBarrageViewDelegate <NSObject>
/**
 *  弹幕碰触到屏幕左边框开会加速的回调，此时下一条弹幕出现
 *
 *  @animView 当前加速的弹幕view
 */
- (void)animatDidSpeed:(id)animView;

@end

@interface ALPBarrageView : UIView
//代理属性
@property (nonatomic, weak) id<ALPBarrageViewDelegate> delegate;
//是否正在运动
@property (nonatomic, assign) BOOL isAnimating;
//是否正在加速（弹幕碰到屏幕左边框开始加速）
@property (nonatomic, assign) BOOL isSpeed;

/**
 *  初始化弹幕view
 *  @type 当前弹幕view的位置
 *  @y 当前弹幕view的y坐标
 */
- (instancetype)initWithType:(ViewType)type pointY:(CGFloat)y;

/**
 *  弹幕开始
 *  @dict = @{@"name":name, @"level":level, @"message":message, @"type":type}
 */
- (void)startWithMessasge:(NSDictionary *)dict;

@end


