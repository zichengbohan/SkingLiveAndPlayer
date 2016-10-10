//
//  ALPBarrageView.m
//  XBMLiveDemo
//
//  Created by 胥佰淼 on 16/8/10.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "ALPBarrageView.h"

@interface ALPBarrageView () <CAAnimationDelegate>
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *level;
@property (nonatomic, strong) UILabel *label;//显示弹幕信息
@property (nonatomic, strong) CABasicAnimation *firstAnim;
@property (nonatomic, strong) CABasicAnimation *secondAnim;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, assign) CGFloat pointY;

@end

@implementation ALPBarrageView

- (id)initWithType:(ViewType)type pointY:(CGFloat)y {
    self = [super init];
    if (self) {
        _pointY = y;
        self.tag = type;
        [self createViews];
    }
    
    return self;
}

- (void)createViews {
    _level = [[UILabel alloc] init];
    _level.font = [UIFont systemFontOfSize:11];
    _level.textAlignment = NSTextAlignmentCenter;
    _level.backgroundColor = [UIColor colorWithRed:100.0/255 green:98.0/255.0 blue:197.0/255.0 alpha:1];
    _level.layer.cornerRadius = 7;
    _level.layer.masksToBounds = YES;
    _level.textColor = [UIColor whiteColor];
    
    _name = [[UILabel alloc] init];
    _name.font = [UIFont systemFontOfSize:15];
    _name.textAlignment = NSTextAlignmentRight;
    _name.textColor = [UIColor colorWithRed:255.0/255 green:220.0/255.0 blue:102.0/255.0 alpha:1];
    
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = [UIColor whiteColor];
    
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _effectView.layer.cornerRadius = 15;
    _effectView.layer.masksToBounds = YES;
    _effectView.layer.borderColor = [UIColor blueColor].CGColor;
    
    [_effectView addSubview:_level];
    [_effectView addSubview:_name];
    [_effectView addSubview:_label];
    
    _firstAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    
    _firstAnim.delegate = self;
    _firstAnim.fillMode = kCAFillModeForwards;
    _firstAnim.removedOnCompletion = NO;
    [_firstAnim setValue:@"firstAnima" forKey:@"animaName"];
    
    _secondAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    _secondAnim.delegate = self;
    _secondAnim.fillMode = kCAFillModeForwards;
    _secondAnim.removedOnCompletion = NO;
    [_secondAnim setValue:@"secondName" forKey:@"animaName"];
    
    
}


- (void)startWithMessasge:(NSDictionary *)dict {
    [self addSubview:_effectView];
    self.isAnimating = YES;
    [self labelSetTitile:dict[@"message"]?:@"" name:dict[@"name"]?:@"" level:dict[@"level"]?:@""];
    if (((NSNumber *)dict[@"type"]).intValue == BarrageTypeSelf) {
        _effectView.layer.borderWidth = 0.5;
    } else {
        _effectView.layer.borderWidth = 0;
    }
    
    _firstAnim.duration = _label.text.length>8? 7 : 6;
    _firstAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, _pointY)];
    _firstAnim.toValue = [NSValue valueWithCGPoint:CGPointMake( _label.frame.size.width > SCREEN_WIDTH? -(_label.frame.size.width - SCREEN_WIDTH) : 0, _pointY)];
    [self.layer addAnimation:_firstAnim forKey:@"positionAnimation"];
   
}

- (void)labelSetTitile:(NSString *)title name:(NSString *)name level:(NSString *)level {
    
    CGSize maximumLabelSize = CGSizeMake(9999, 15);//labelsize的最大值
    CGSize expectSize;
    
    _level.text = level;
    _level.frame = CGRectMake(7.5, 7.5, 35, 15);
    
    _name.text = [NSString stringWithFormat:@"%@:",name];
    expectSize = [_name sizeThatFits:maximumLabelSize];
    _name.frame = CGRectMake(_level.frame.origin.x + _level.frame.size.width + 5, 6, expectSize.width, expectSize.height);
    
    
    _label.text = title;
    //关键语句
    expectSize = [_label sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label
    _label.frame = CGRectMake(_name.frame.origin.x + _name.frame.size.width + 5, 6, expectSize.width, expectSize.height);
    _effectView.frame = CGRectMake(0, 0, _label.frame.origin.x + _label.bounds.size.width + 7.5, 30);
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animaName"] isEqualToString:@"firstAnima"]) {
        _secondAnim.duration = _label.text.length > 8? 3 : 2;
        _secondAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake( _label.frame.size.width > SCREEN_WIDTH? -(_label.frame.size.width - SCREEN_WIDTH) : 0, _pointY)];
        _secondAnim.toValue = [NSValue valueWithCGPoint:CGPointMake( _label.text.length>8 && _label.frame.size.width > SCREEN_WIDTH? -_label.frame.size.width:-SCREEN_WIDTH, _pointY)];
        
        [self.layer addAnimation:_secondAnim forKey:@"positionAnimation"];
        if ([self.delegate respondsToSelector:@selector(animatDidSpeed:)]) {
            self.isSpeed = YES;
            [self.delegate animatDidSpeed:self];
        }
    } else if ([[anim valueForKey:@"animaName"] isEqualToString:@"secondName"]) {
        self.isAnimating = NO;
        self.isSpeed = NO;
    }
}


@end
