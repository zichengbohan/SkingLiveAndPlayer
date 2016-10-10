//
//  ALPSpringAnimationView.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/29.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "ALPSpringAnimationView.h"
#import "ALPGiftView.h"

@interface ALPSpringAnimationView () <ALPGiftViewDelegate>
//第一个礼物view
@property (nonatomic, strong) ALPGiftView *firstView;
//第二个礼物view
@property (nonatomic, strong) ALPGiftView *secondView;
//礼物存储数组
@property (nonatomic, strong) NSMutableArray *giftsArray;
//第一个礼物对应的信息Dict
@property (nonatomic, strong) NSDictionary *firstDic;
//第二个礼物对应的信息Dict
@property (nonatomic, strong) NSDictionary *secondDic;
//礼物点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation ALPSpringAnimationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _giftsArray = [[NSMutableArray alloc] init];
        
        _firstView = [[ALPGiftView alloc] initWithFrame:CGRectMake(15, 0, 290, 40)];
        _firstView.delegate = self;
        _firstView.tag = 20001;
        
        _secondView = [[ALPGiftView alloc] initWithFrame:CGRectMake(15, 0, 290, 40)];
        _secondView.delegate = self;
        _secondView.tag = 20002;
        
        [self addSubview:_firstView];
        [self addSubview:_secondView];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchClick:)];
        [self addGestureRecognizer:self.tapGesture];
        
}
    
    return self;
}

- (void)showGiftName:(NSString *)giftName userName:(NSString *)userName userIcon:(NSURL *)userImgUrl giftImage:(NSURL *)giftImageUrl giftNum:(NSString *)num giftID:(NSString *)giftID {

}

- (void)showGiftName:(NSString *)giftName userName:(NSString *)userName userIcon:(NSURL *)userImgUrl giftImage:(NSURL *)giftImageUrl giftNum:(NSString *)num giftID:(NSString *)giftID userID:(NSString *)userID {
    NSDictionary *giftDict = @{@"giftName":giftName?:@"", @"userName":userName?:@"", @"userImgUrl":userImgUrl?:[NSURL URLWithString:@""], @"giftImageUrl":giftImageUrl?:[NSURL URLWithString:@""], @"num":num?:@"", @"giftID":giftID?:@"", @"userID":userID?:@""};
    [_giftsArray addObject:giftDict];
    [self startGitftAnimat];
    
}

#pragma mark ALPGiftViewDelegate method
- (void)animateComplete {
    if (_giftsArray.count > 0) {
        [self startGitftAnimat];
    }
}

- (void)moveDownComplete:(id)sender {
    NSDictionary *dict = _giftsArray.firstObject;
    if (_firstView.showing && !_secondView.showing ) {
        [_secondView showGiftName:dict[@"giftName"] userName:dict[@"userName"] userIcon:dict[@"userImgUrl"] giftImage:dict[@"giftImageUrl"] giftNum:dict[@"num"] giftID:dict[@"giftID"]];
        _secondDic = dict;
        [_giftsArray removeObjectAtIndex:0];
    }else if (!_firstView.showing && _secondView.showing) {
        [_firstView showGiftName:dict[@"giftName"] userName:dict[@"userName"] userIcon:dict[@"userImgUrl"] giftImage:dict[@"giftImageUrl"] giftNum:dict[@"num"] giftID:dict[@"giftID"]];
        _firstDic = dict;
        [_giftsArray removeObjectAtIndex:0];
    }
}

#pragma mark private method
- (void)startGitftAnimat {
    NSDictionary *dict = _giftsArray.firstObject;
    
    if (!_firstView.showing && !_secondView.showing) {
        [_firstView showGiftName:dict[@"giftName"] userName:dict[@"userName"] userIcon:dict[@"userImgUrl"] giftImage:dict[@"giftImageUrl"] giftNum:dict[@"num"] giftID:dict[@"giftID"]];
        _firstDic = dict;
        [_giftsArray removeObjectAtIndex:0];
    } else if (_firstView.showing && !_firstView.speeding && !_secondView.showing) {
        [_firstView moveDown];
        
        
    } else if (!_firstView.showing && _secondView.showing && !_secondView.speeding) {
        [_secondView moveDown];
        
    }
}

#pragma mark 点击弹幕手势事件
- (void)touchClick:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self];
    if ([self.firstView.layer.presentationLayer hitTest:touchPoint]) {
        if ([self.delegate respondsToSelector:@selector(touchMessage:)]) {
            [self.delegate touchMessage:_firstDic[@"userID"]];
        }
        NSLog(@"touch1");
    }
    if ([self.secondView.layer.presentationLayer hitTest:touchPoint]) {
        if ([self.delegate respondsToSelector:@selector(touchMessage:)]) {
            [self.delegate touchMessage:_secondDic[@"userID"]];
        }
        NSLog(@"touch2");
    }
   
}


@end
