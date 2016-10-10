//
//  ALPGiftView.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/29.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "ALPGiftView.h"
//#import "UIImageView+WebCache.h"

@interface ALPGiftView ()
//礼物显示总时间（礼物数量乘的时间+显示的时间）
@property (nonatomic, assign) NSTimeInterval showTime;

@property (nonatomic, strong) CAKeyframeAnimation *frameAnimation;

@property (nonatomic, strong) CAAnimationGroup *groupAnimation;
//向下移动的动画
@property (nonatomic, strong) CABasicAnimation *moveDownAnim;
//用户头像
@property (nonatomic, strong) UIImageView *iconImgView;
//用户名
@property (nonatomic, strong) UILabel *nameLB;
//礼物名
@property (nonatomic, strong) UILabel *giftDescribleLB;
//礼物数量显示
@property (nonatomic, strong) UILabel *giftNumLB;
//礼物图片
@property (nonatomic, strong) UIImageView *giftImgView;
//礼物id
@property (nonatomic, copy) NSString *giftID;
//礼物放大缩小动画
@property (nonatomic, strong) CAKeyframeAnimation* transAnimation;
//礼物数量动画
@property (nonatomic, strong) CAAnimationGroup *giftNumAnimat;
//礼物数量
@property (nonatomic, copy) NSString *giftNum;
//礼物数量增加的计时器
@property (nonatomic, strong) NSTimer * playTimer;
//礼物数量增加的计时次数
@property (nonatomic, assign) int countTime;
//上一次显示的礼物数量
@property (nonatomic, assign) int oldNum;
//礼物以指数形式叠加，底数
@property (nonatomic, assign) CGFloat bottomNum;//指数的底数

@end

@implementation ALPGiftView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.layer.cornerRadius = 20;
        self.alpha = 0;
        [self createViews];
        [self createAnimation];
        [self giftImageTransAnimat];
        [self giftNumStansAnimat];
    }
    
    return self;
}

//创建view
- (void)createViews {
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    _iconImgView.backgroundColor = [UIColor redColor];
    _iconImgView.layer.cornerRadius = 15;
    [self addSubview:_iconImgView];
    
    _nameLB = [[UILabel alloc] initWithFrame:CGRectMake(_iconImgView.frame.origin.x + _iconImgView.frame.size.width + 10, 0, 100, 21)];
    _nameLB.textColor = [UIColor whiteColor];
    _nameLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:_nameLB];
    
    _giftDescribleLB = [[UILabel alloc] initWithFrame:CGRectMake(_nameLB.frame.origin.x, _nameLB.frame.origin.y + _nameLB.frame.size.height + 2, 100, 17)];
    _giftDescribleLB.textColor = [UIColor colorWithRed:255.0/255.0 green:220.0/255.0 blue:102.0/255.0 alpha:1];
    _giftDescribleLB.font = [UIFont systemFontOfSize:12];
    [self addSubview:_giftDescribleLB];
    
    _giftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_giftDescribleLB.frame.origin.x + _giftDescribleLB.frame.size.width + 15, -10, 60, 60)];
    _giftImgView.backgroundColor = [UIColor blueColor];
    
    
    _giftNumLB = [[UILabel alloc] initWithFrame:CGRectMake(_giftImgView.frame.origin.x + _giftImgView.frame.size.width + 10, 6, 71, 28)];
    _giftNumLB.textColor = [UIColor colorWithRed:242.0/255.0 green:147.0/255.0 blue:0 alpha:1];
    _giftNumLB.font = [UIFont systemFontOfSize:25];

}

- (void)buttonCLicked:(id)sender {
    NSLog(@"button1");
}

//创建动画，此处暂时不用
- (void)createAnimation {
    _frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(145+15, 20)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(145+15, 20)];
    //        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(125+15, 54)];
    [_frameAnimation setValues:@[value0, value1]];
    [_frameAnimation setKeyTimes:@[@0, @1.0]];
    _frameAnimation.duration = 2.5;
    _frameAnimation.delegate = self;
    _frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//设置动画的节奏
    [_frameAnimation setValue:@"frameAnimation" forKey:@"animationKey"];
    _frameAnimation.removedOnCompletion = NO;
    _frameAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:1.0f];
    anima.toValue = [NSNumber numberWithFloat:0];
    //        anima.duration = 1.0f;
    
    CABasicAnimation *lineAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    lineAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(145 + 15, 20)];
    lineAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(145 + 15, 54)];
    
//    _groupAnimation = [CAAnimationGroup animation];
//    _groupAnimation.animations = [NSArray arrayWithObjects:lineAnim,anima, nil];
//    _groupAnimation.duration = 0.3;
//    _groupAnimation.delegate = self;
//    _groupAnimation.removedOnCompletion = NO;
//    _groupAnimation.fillMode = kCAFillModeForwards;
//    [_groupAnimation setValue:@"groupAnimation" forKey:@"animationKey"];
//    

}

//礼物展示
- (void)showGiftName:(NSString *)giftName userName:(NSString *)userName userIcon:(NSURL *)userImgUrl giftImage:(NSURL *)giftImageUrl giftNum:(NSString *)num giftID:(NSString *)giftID {
    _countTime = 1;
    _oldNum = 1;
    _giftNum = num;
    _giftDescribleLB.text = [NSString stringWithFormat:@"送了：%@", giftName];
    _nameLB.text = userName;
    
//        [_iconImgView sd_setImageWithURL:userImgUrl];
//        [_giftImgView sd_setImageWithURL:giftImageUrl];
    
    _giftID = giftID;
    
    switch (num.integerValue) {
        case 1:
            _showTime = 3.0;
            break;
        case 99:
            _bottomNum = 1.59;
            _showTime = 15.0;
            break;
        case 298:
            _bottomNum = 1.47;
            _showTime = 25.0;
            break;
        case 520:
            _bottomNum = 1.366;
            _showTime = 35;
            break;
            
        default:
            break;
    }
    self.showing = YES;
    __weak typeof(self) weakSelf = self;
    [_giftNumLB removeFromSuperview];
    [_giftImgView removeFromSuperview];
    [self performSelector:@selector(giftImgViewAnimate) withObject:self afterDelay:0.2];
    [self performSelector:@selector(giftNumAnimate) withObject:self afterDelay:0.4];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        weakSelf.alpha = 1.0;
        weakSelf.center = CGPointMake(145 + 15, 20);
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(disShow) withObject:weakSelf afterDelay:_showTime];
        
    }];
    
}

- (void)disShow {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
        weakSelf.center = CGPointMake(145 + 15, weakSelf.center.y + 34);
        NSLog(@"start");

    } completion:^(BOOL finished) {
        NSLog(@"520lal");
        weakSelf.center = CGPointMake(145, 20);
        if ([weakSelf.delegate respondsToSelector:@selector(animateComplete)]) {
            weakSelf.showing = NO;
            [weakSelf.delegate animateComplete];
        }
    }];
}

#pragma mark CAAnimationDelegate method
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

}

#pragma mark private method
//礼物下移
- (void)moveDown {
    self.speeding = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.7 animations:^{
        weakSelf.center = CGPointMake(145 + 15, 20 + 25 + 40);
    } completion:^(BOOL finished) {
        if ([weakSelf.delegate respondsToSelector:@selector(moveDownComplete:)]) {
            weakSelf.speeding = NO;
            [weakSelf.delegate moveDownComplete:self];
            
        }
    }];
}

//礼物图片动画
- (void)giftImgViewAnimate {
    [self addSubview:_giftImgView];
    [_giftImgView.layer addAnimation:_groupAnimation forKey:nil];
}

- (void)giftImageTransAnimat {
    _transAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.32, 1.52, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
   _transAnimation.values = values;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:0];
    anima.toValue = [NSNumber numberWithFloat:1.0];
    
    _groupAnimation = [CAAnimationGroup animation];
    _groupAnimation.animations = [NSArray arrayWithObjects:_transAnimation,anima, nil];
    _groupAnimation.duration = 0.12;
    _groupAnimation.delegate = self;
    _groupAnimation.removedOnCompletion = NO;
    _groupAnimation.fillMode = kCAFillModeForwards;
    [_groupAnimation setValue:@"giftImageAnimation" forKey:@"animationKey"];
    
}
//礼物数字动画
- (void)giftNumAnimate {
    if (_giftNum.intValue > 1) {
        _playTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playfireNum:) userInfo:nil repeats:YES];
    }
    

    _giftNumLB.text = [NSString stringWithFormat:@"×%d", 1];
    [self addSubview:_giftNumLB];
    [_giftNumLB.layer addAnimation:_giftNumAnimat forKey:nil];
    
}

- (void)playfireNum:(NSTimer *)time {

    _countTime ++;
    int num = (int)pow(_bottomNum, _countTime);
    
    if (num > _giftNum.intValue) {
        NSLog(@"520la");
        [_playTimer setFireDate:[NSDate distantFuture]];
        num = _giftNum.intValue;
    }
    
    if (_oldNum == num) {
        num ++;
       
    }
    _oldNum = num;
    _giftNumLB.text = [NSString stringWithFormat:@"×%d", num];
    [_giftNumLB.layer addAnimation:_giftNumAnimat forKey:nil];
}

- (void)giftNumStansAnimat {
    CAKeyframeAnimation *transAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //    _transAnimation.duration = 0.12;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.62, 0.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.14, 1.25, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    transAnimation.values = values;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:0.13];
    anima.toValue = [NSNumber numberWithFloat:1.0];
    anima.duration = 0.1;
    
    _giftNumAnimat = [CAAnimationGroup animation];
    _giftNumAnimat.animations = [NSArray arrayWithObjects:transAnimation,anima, nil];
    _giftNumAnimat.duration = 0.26;
    _giftNumAnimat.delegate = self;
    _giftNumAnimat.removedOnCompletion = NO;
    _giftNumAnimat.fillMode = kCAFillModeForwards;
    [_giftNumAnimat setValue:@"giftNumAnimation" forKey:@"animationKey"];
}


@end
