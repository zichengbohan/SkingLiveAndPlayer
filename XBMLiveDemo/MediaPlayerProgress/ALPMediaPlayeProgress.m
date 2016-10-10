//
//  ALPMediaPlayeProgress.m
//  AllLivePlayer
//
//  Created by 胥佰淼 on 16/8/22.
//  Copyright © 2016年 hzky. All rights reserved.
//

#import "ALPMediaPlayeProgress.h"

@interface ALPMediaPlayeProgress ()

@property (nonatomic, strong) UISlider *mySlider;
@property (nonatomic, strong) UIButton *startBT;
@property (nonatomic, strong) UILabel *timeLabel;
//@property (nonatomic, assign) CGFloat palyCountTime;

@end

@implementation ALPMediaPlayeProgress

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createStartButton];
        [self createSlider];
        [self createTimeLabel];
    }
    
    return self;
}

- (void)setPalyCountTime:(double)palyCountTime {
    _timeLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d", (int)palyCountTime/(60*60), (int)palyCountTime%(60*60)/60, (int)palyCountTime%(60*60)%(60)];
     _mySlider.maximumValue = palyCountTime;
    _startBT.selected = YES;
    
    _palyCountTime = palyCountTime;
}

- (void)setCurrentTime:(double)currentTime {
    _timeLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d", (int)(_palyCountTime - currentTime)/(60*60), (int)(_palyCountTime - currentTime)%(60*60)/60, (int)(_palyCountTime - currentTime)%(60*60)%(60)];
    _mySlider.value = currentTime;
    _currentTime = currentTime;
}

- (void)createStartButton {
    _startBT = [[UIButton alloc] initWithFrame:CGRectMake(9, 0, 30, 24)];
    [_startBT setImage:[UIImage imageNamed:@"backplay-startPlay"] forState:UIControlStateNormal];
    [_startBT setImage:[UIImage imageNamed:@"backplay-pause"] forState:UIControlStateSelected];
    [_startBT addTarget:self action:@selector(viewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_startBT];
}

- (void)createSlider {
    _mySlider = [[UISlider alloc] initWithFrame:CGRectMake(_startBT.frame.origin.x + _startBT.frame.size.width + 15, 0, SCREEN_WIDTH - 110, 25)];
    [_mySlider setThumbImage:[UIImage imageNamed:@"backplay-slider"] forState:UIControlStateNormal];
    _mySlider.minimumValue = 0;
    _mySlider.maximumValue = 0;
    [_mySlider addTarget:self action:@selector(viewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_mySlider];
}


- (void)createTimeLabel {
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mySlider.frame.origin.x + _mySlider.frame.size.width + 5 , 6, 50, 12)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_timeLabel];
}

- (void)viewClicked:(id)sender {
    if (sender == _startBT) {
        _startBT.selected = !_startBT.selected;
        if ([self.delegate respondsToSelector:@selector(didSelectStartButton:)]) {
            [self.delegate didSelectStartButton:!_startBT.selected];
        }
    } else if (sender == _mySlider) {
        if ([self.delegate respondsToSelector:@selector(didChangedPlayTime:)]) {
            [self.delegate didChangedPlayTime:_mySlider.value];
        }
    }
}

- (void)sliderValueChanged:(id)sender {
    if (sender == _mySlider) {
        _timeLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d", (int)(_palyCountTime - _mySlider.value)/(60*60), (int)(_palyCountTime - _mySlider.value)%(60*60)/60, (int)(_palyCountTime - _mySlider.value)%(60*60)%(60)];
    }
}


@end
