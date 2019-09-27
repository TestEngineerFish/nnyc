//
//  YXPlayAudioControllerView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/31.
//  Copyright © 2019 shiji. All rights reserved.
//


#import "YXPlayAudioControllerView.h"
#import "YXCustomSlider.h"

@interface YXPlayAudioControllerView()

@property (nonatomic, weak) UILabel *startTimeLabel;
@property (nonatomic, weak) YXCustomSlider *slider;
@property (nonatomic, weak) UILabel *endTimeLabel;

@property (nonatomic, weak) UIButton *playBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *sliderAfterTimer;

@end

@implementation YXPlayAudioControllerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI {
    self.backgroundColor = UIColorOfHex(0xF3FAFF);
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider.mas_left).with.offset(-10.f);
        make.centerY.equalTo(self.slider);
        make.size.mas_equalTo(CGSizeMake(50.f, 13.f));
    }];

    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(-20.f);
        make.centerX.equalTo(self);
        make.width.equalTo(self).with.offset(-120.f);
        make.height.mas_equalTo(20.f);
    }];

    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_right).with.offset(10.f);
        make.centerY.equalTo(self.slider);
        make.size.mas_equalTo(CGSizeMake(50.f, 13.f));
    }];

    [self.previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playBtn.mas_left).with.offset(-17.f);
        make.centerY.equalTo(self.playBtn);
        make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
    }];

    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(17.f);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(37.f, 37.f));
    }];

    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).with.offset(17.f);
        make.centerY.equalTo(self.playBtn);
        make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
    }];
    [self bringSubviewToFront:self.slider];
}

#pragma mark - subviews

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        UILabel *startTimeLabel = [[UILabel alloc] init];
        startTimeLabel.text = @"0.00";
        startTimeLabel.textColor = UIColorOfHex(0x8095AB);
        startTimeLabel.font = [UIFont systemFontOfSize:13.f];
        startTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:startTimeLabel];
        _startTimeLabel = startTimeLabel;
    }
    return _startTimeLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        YXCustomSlider *slider = [[YXCustomSlider alloc] init];
        slider.minimumValue = 0.f;
        slider.maximumValue = (float)self.totalUseTime;
        [slider addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
        [slider addGestureRecognizer:tap];
        [self addSubview:slider];
        _slider = slider;
    }
    return _slider;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        UILabel *endTimeLabel = [[UILabel alloc] init];
        endTimeLabel.text = @"1.00";
        endTimeLabel.textColor = UIColorOfHex(0x8095AB);
        endTimeLabel.font = [UIFont systemFontOfSize:13.f];
        endTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:endTimeLabel];
        _endTimeLabel = endTimeLabel;
    }
    return _endTimeLabel;
}

- (UIButton *)previousBtn {
    if (!_previousBtn) {
        UIButton *previousBtn = [[UIButton alloc] init];
        [previousBtn setImage:[UIImage imageNamed:@"previousSentenceUnselect"] forState:UIControlStateNormal];
        [previousBtn setImage:[UIImage imageNamed:@"previousSentenceSelected"] forState:UIControlStateHighlighted];
        [previousBtn addTarget:self action:@selector(playPreviousSentence:) forControlEvents:UIControlEventTouchUpInside];
        [previousBtn setEnabled:NO];
        [self addSubview:previousBtn];
        _previousBtn = previousBtn;
    }
    return _previousBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        UIButton *playBtn = [[UIButton alloc] init];
        [playBtn setImage:[UIImage imageNamed:@"playArticle"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [playBtn addTarget:self action:@selector(playSentence:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playBtn];
        _playBtn = playBtn;
    }
    return _playBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        UIButton *nextBtn = [[UIButton alloc] init];
        [nextBtn setImage:[UIImage imageNamed:@"nextSentenceUnselect"] forState:UIControlStateNormal];
        [nextBtn setImage:[UIImage imageNamed:@"nextSentenceSelected"] forState:UIControlStateHighlighted];
        [nextBtn addTarget:self action:@selector(playNextSenceten:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextBtn];
        _nextBtn = nextBtn;
    }
    return _nextBtn;
}

#pragma mark - event

- (void)playSentenceWith:(float)times isPlay:(BOOL)isPlay {
    if (self.delegate) {
        [self.delegate playSentenceWith:times isPlay:isPlay];
    }
}

- (void)playPreviousSentence:(UIButton *)btn {
    if (self.delegate) {
        [self.delegate playPreviousSentence];
    }
}

- (void)playSentence:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.delegate) {
        if (btn.selected) {
            [self.delegate continueplayArticle];
        } else {
            [self.delegate stopArticleAudio];
        }
    }
}

- (void)playNextSenceten:(UIButton *)btn {
    if (self.delegate) {
        [self.delegate playNextSenceten];
    }
}

- (void)setPlaying:(BOOL)playing {
    _playing = playing;
    [self.playBtn setSelected:playing];
}

- (void)setTotalUseTime:(NSUInteger)totalUseTime {
    _totalUseTime = totalUseTime;
    self.endTimeLabel.text = [NSString stringWithFormat:@"%lu.%02lu", totalUseTime/60, totalUseTime%60];
    self.slider.maximumValue = (float)totalUseTime;
}

- (void)sliderValurChanged:(UISlider*)slider forEvent:(UIEvent*)event  {
    UITouch *touchEvent = [[event allTouches] anyObject];
    if (touchEvent.phase == UITouchPhaseMoved) {
        [self refreshSliderValue];
        [self playSentenceWith:self.slider.value isPlay:NO];
    }
    if (touchEvent.phase == UITouchPhaseEnded) {
        [self refreshSliderValue];
        [self playSentenceWith:self.slider.value isPlay:YES];
    }
}

- (void)startCoundDownFrom:(NSUInteger)index {
    [self stopCoundDown];
    self.slider.value = (float)index;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coundDownAction) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)stopCoundDown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 更新slider view
- (void)refreshSliderValue {
    if (self.slider.value > self.totalUseTime) {
        return;
    }
    //因为用了Mastory,当修改内容是,防止更新移动过的视图,
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *value = [NSString stringWithFormat:@"%d.%02d", (int)self.slider.value/60, (int)self.slider.value % 60];
    self.startTimeLabel.text = value;
    self.translatesAutoresizingMaskIntoConstraints = YES;
}

// 循环修改sliderValue
- (void)coundDownAction {
    self.slider.value += 1;
    [self refreshSliderValue];
}

- (void)sliderTapped:(UITapGestureRecognizer *)tap {
    CGPoint location  = [tap locationInView:self.slider];
    CGFloat percent   = 1.0 * location.x /CGRectGetWidth(self.slider.bounds);
    CGFloat delta     = percent * (self.slider.maximumValue - self.slider.minimumValue);
    CGFloat value     = self.slider.minimumValue + delta;
    self.slider.value = value;
    [self refreshSliderValue];
    [self playSentenceWith:self.slider.value isPlay:YES];
}

@end
