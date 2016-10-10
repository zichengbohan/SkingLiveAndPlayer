//
//  ALPBarrageLineView.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/10/9.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "ALPBarrageLineView.h"
#import "ALPBarrageView.h"

@interface ALPBarrageLineView () <ALPBarrageViewDelegate>

//第一行弹幕view
@property (nonatomic, strong) ALPBarrageView *barrageViewFirst;
//第二行弹幕view
@property (nonatomic, strong) ALPBarrageView *barrageViewSecond;

@property (nonatomic, strong) NSDictionary *firstBarrageMessageDict;
@property (nonatomic, strong) NSDictionary *secondBarrageMessageDict;

//弹幕点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation ALPBarrageLineView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        _barrageViewFirst = [[ALPBarrageView alloc] initWithType:ViewTypeAboveFirst pointY:0];
        _barrageViewFirst.delegate = self;
        
        _barrageViewSecond = [[ALPBarrageView alloc] initWithType:ViewTypeAboveSecond pointY:0];
        _barrageViewSecond.delegate = self;
        
        [self addSubview:_barrageViewFirst];
        [self addSubview:_barrageViewSecond];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchClick:)];
        [self addGestureRecognizer:self.tapGesture];

    }
    
    return self;
}

- (BOOL)startNomal {
    
    return (_barrageViewFirst.isAnimating &&!_barrageViewFirst.isSpeed) || (_barrageViewSecond.isAnimating && !_barrageViewSecond.isSpeed);
    
}

- (void)startBarrageWithMessageDict:(NSDictionary *)messageDic {
    if (!_barrageViewFirst.isAnimating) {
        _firstBarrageMessageDict = messageDic;
        [_barrageViewFirst startWithMessasge:messageDic];
    } else if (!_barrageViewSecond.isAnimating) {
        _secondBarrageMessageDict = messageDic;
        [_barrageViewSecond startWithMessasge:messageDic];
    }
}

#pragma mrak ALPBarrageDelegate
- (void)animatDidSpeed:(id)animView {
    if ([self.delegate respondsToSelector:@selector(animateSpeed)]) {
        [self.delegate animateSpeed];
    }
}

#pragma mark 点击弹幕手势事件
- (void)touchClick:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self];
    NSLog(@"点击");
    if ([self.barrageViewFirst.layer.presentationLayer hitTest:touchPoint]) {
         NSLog(@"点击1");
        if ([self.delegate respondsToSelector:@selector(touchLineMessage:)]) {
            [self.delegate touchLineMessage:_firstBarrageMessageDict[@"userID"]];
        }
    }
    if ([self.barrageViewSecond.layer.presentationLayer hitTest:touchPoint]) {
         NSLog(@"点击2");
        if ([self.delegate respondsToSelector:@selector(touchLineMessage:)]) {
            [self.delegate touchLineMessage:_secondBarrageMessageDict[@"userID"]];
        }
    }
    
}

@end
