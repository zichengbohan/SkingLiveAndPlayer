//
//  ALPVideoBarrage.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "ALPVideoBarrage.h"
#import "ALPBarrageLineView.h"

@interface ALPVideoBarrage () <ALPBarrageLineViewDelegate>

@property (nonatomic, strong) ALPBarrageLineView *firstLineView;
@property (nonatomic, strong) ALPBarrageLineView *secondLineView;

//待弹幕信息Array
@property (nonatomic, strong) NSMutableArray *titleArray;



@property (nonatomic, assign) BOOL firstISEnd;

@property (nonatomic, assign) BOOL secondISEnd;
//弹幕点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation ALPVideoBarrage

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        _titleArray = [[NSMutableArray alloc] init];
        
        _firstLineView = [[ALPBarrageLineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _firstLineView.delegate = self;
        
        _secondLineView = [[ALPBarrageLineView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 30)];
        _secondLineView.delegate = self;
        
        [self addSubview:_firstLineView];
        [self addSubview:_secondLineView];
        
    }
    
    return self;
}

//- (BOOL)isFirstLineStart {
//    return (_aboveViewFirst.isAnimating &&!_aboveViewFirst.isSpeed) || (_aboveViewSecond.isAnimating && !_aboveViewSecond.isSpeed);
//}
//
//- (BOOL)firstISEnd {
//    return (!_aboveViewFirst.isAnimating &&!_aboveViewFirst.isSpeed) && (!_aboveViewSecond.isAnimating && !_aboveViewSecond.isSpeed);
//}
//
//- (BOOL)secondISEnd {
//    return (!_followViewFirst.isAnimating && !_followViewFirst.isSpeed) && (!_followViewSecond.isAnimating && !_followViewSecond.isSpeed);
//}
//
//- (BOOL)isSecondLineStart {
//    return (_followViewFirst.isAnimating && !_followViewFirst.isSpeed) || (_followViewSecond.isAnimating && !_followViewSecond.isSpeed);
//}

- (void)startWithMessasge:(NSString *)message name:(NSString *)name level:(NSString *)level userID:(NSString *)usrID {
    NSDictionary *dict = @{@"name":name?:@"", @"level":level?:@"", @"message":message?:@"", @"userID":usrID?:@""};
    [_titleArray addObject:dict];
    if (_titleArray.count > 0) {
        [self animateStart];
    }
}

- (void)startWithMessasge:(NSString *)message name:(NSString *)name level:(NSString *)level userID:(NSString *)usrID type:(BarrageType)type {
    NSDictionary *dict = @{@"name":name?:@"", @"level":level?:@"", @"message":message?:@"", @"userID":usrID?:@"", @"type":[NSNumber numberWithInt:type]};
    [_titleArray addObject:dict];
    if (_titleArray.count > 0) {
        [self animateStart];
    }
}

- (void)startWithBarrageDict:(NSDictionary *)barrageDict {
    [_titleArray addObject:barrageDict];
    if (_titleArray.count > 0) {
        [self animateStart];
    }
}

- (void)animateStart {
    NSLog(@"弹幕开始");
    
    if ([_firstLineView startNomal] && ![_secondLineView startNomal]) {
        
        [_secondLineView startBarrageWithMessageDict:_titleArray.firstObject];
        
    } else if (![_firstLineView startNomal] && [_secondLineView startNomal]) {
        
        [_firstLineView startBarrageWithMessageDict:_titleArray.firstObject];
        
    } else if (![_firstLineView startNomal] && ![_secondLineView startNomal]) {
        
        [_firstLineView startBarrageWithMessageDict:_titleArray.firstObject];
        
    } else if ([_firstLineView startNomal] && [_secondLineView startNomal]) {
        return;
    }
    
    [_titleArray removeObjectAtIndex:0];
    
}

#pragma mrak ALPBarrageDelegate
- (void)animateSpeed {
    if (_titleArray.count > 0) {
        [self animateStart];
    }
}

- (void)animationDidCompelete {
    if ([_titleArray count] == 0 && self.firstISEnd && self.secondISEnd) {
        if ([self.delegate respondsToSelector:@selector(videoBarrageDidComplete)]) {
            [self.delegate videoBarrageDidComplete];
        }
    }
}

#pragma mark 点击弹幕手势事件
- (void)touchLineMessage:(NSString *)userID {
        if ([self.delegate respondsToSelector:@selector(touchMessage:)]) {
            [self.delegate touchMessage:userID];
        }
}

@end
