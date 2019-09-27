//
//  YXSetProgressView.m
//  YXEDU
//
//  Created by yao on 2018/11/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSetProgressView.h"
#import "YXCustomSlider.h"

@interface YXSetProgressView ()
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *progressTitleLab;
@property (nonatomic, strong) UILabel *progressValueLab;

@property (nonatomic, strong) UIImageView *gradientImageView;
@property (nonatomic, strong) UIImageView *dotImageView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *consumTimeLab;
@property (nonatomic, strong) UILabel *consumTimeValueLab;
@property (nonatomic, strong) UILabel *completeDayLab;
@property (nonatomic, strong) UILabel *completeDayValueLab;
@property (nonatomic, strong) UIButton *beginReciteBtn;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) NSMutableDictionary *paramsDic;
@property (nonatomic, weak) YXCustomSlider *slider;
@property (nonatomic, assign)BOOL isLearned;
@property (nonatomic, assign)NSInteger planNUm;
@property (nonatomic, weak) UITapGestureRecognizer *tap;
@end

@implementation YXSetProgressView
{
    YXBookPlanModel *_planModel;
}

+ (YXSetProgressView *)setProgressViewWithPlanModel:(YXBookPlanModel *)planModel withDelegate:(id<YXSetProgressViewDelegate>)delegate {
//    planModel.leftWords = 8;
    YXSetProgressView *progressView = [[self alloc] initWithPlanModel:planModel withDelegate:delegate];//CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    return progressView;
}

- (instancetype)initWithPlanModel:(YXBookPlanModel *)planModel withDelegate:(id<YXSetProgressViewDelegate>)delegate {
    if (self = [super init]) {
        _planModel = planModel;
        self.delegate = delegate;
        [self configSlider];
        [self refreshData];
    }
    return self;
}

- (void)configSlider {
    NSInteger leftWords = self.planModel.leftWords;
    NSInteger maxValue = leftWords;
    if(leftWords > 100) {
        maxValue = 100;
    }else {
        maxValue = leftWords;
    }
    self.slider.maximumValue = maxValue;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8.0;
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, SCREEN_WIDTH, 17)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = UIColorOfHex(0x485461);
        self.titleLab.text = @"设置学习计划";
        self.titleLab.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:self.titleLab];
        
        self.progressTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 74, SCREEN_WIDTH-40, 17)];
        self.progressTitleLab.textAlignment = NSTextAlignmentLeft;
        self.progressTitleLab.textColor = UIColorOfHex(0x8095AB);
        self.progressTitleLab.text = @"每日学习单词数";
        self.progressTitleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.progressTitleLab];
        
        self.progressValueLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 74, 60, 17)];
        //        self.progressValueLab.backgroundColor = [UIColor redColor];
        self.progressValueLab.textAlignment = NSTextAlignmentRight;
        self.progressValueLab.textColor = UIColorOfHex(0x485461);
        self.progressValueLab.text = @"25";
        self.progressValueLab.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.progressValueLab];
        
        self.slider.frame = CGRectMake(20, 105, SCREEN_WIDTH-40, 10);
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 141, SCREEN_WIDTH-40, 1)];
        self.lineView.backgroundColor = UIColorOfHex(0xE1EBF0);
        [self addSubview:self.lineView];
        
        self.consumTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 166, SCREEN_WIDTH-40, 17)];
        self.consumTimeLab.textAlignment = NSTextAlignmentLeft;
        self.consumTimeLab.textColor = UIColorOfHex(0x8095AB);
        self.consumTimeLab.text = @"预计每日耗时（分钟）";
        self.consumTimeLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.consumTimeLab];
        
        self.consumTimeValueLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 166, SCREEN_WIDTH-40, 17)];
        self.consumTimeValueLab.textAlignment = NSTextAlignmentRight;
        self.consumTimeValueLab.textColor = UIColorOfHex(0x485461);
        self.consumTimeValueLab.text = @"25";
        self.consumTimeValueLab.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.consumTimeValueLab];
        
        self.completeDayLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH-40, 17)];
        self.completeDayLab.textAlignment = NSTextAlignmentLeft;
        self.completeDayLab.textColor = UIColorOfHex(0x8095AB);
        self.completeDayLab.text = @"完成天数";
        self.completeDayLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.completeDayLab];
        
        self.completeDayValueLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH-40, 17)];
        self.completeDayValueLab.textAlignment = NSTextAlignmentRight;
        self.completeDayValueLab.textColor = UIColorOfHex(0x8095AB);
        self.completeDayValueLab.text = @"计算中...";
        self.completeDayValueLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.completeDayValueLab];
        
        self.beginReciteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.beginReciteBtn addTarget:self action:@selector(affirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.beginReciteBtn setBackgroundImage:[UIImage imageNamed:@"progress_affirm_btn"] forState:UIControlStateNormal];
        [self addSubview:self.beginReciteBtn];
        [self.beginReciteBtn setFrame:CGRectMake((SCREEN_WIDTH-236)/2.0, 247, 236, 56)];
        
        self.tipLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 315, SCREEN_WIDTH-40, 17)];
        self.tipLab.textAlignment = NSTextAlignmentCenter;
        self.tipLab.textColor = UIColorOfHex(0x8095AB);
        self.tipLab.text = @"学习计划的修改将于次日生效";
        self.tipLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.tipLab];
    }
    return self;
}

- (YXCustomSlider *)slider {
    if (!_slider) {
        YXCustomSlider *slider = [[YXCustomSlider alloc] init];
        slider.minimumValue = 0.0;
        slider.maximumValue = 100.0;
        slider.value = 20;
        [slider setContinuous:YES];
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
        [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
        [slider addGestureRecognizer:tap];
        _tap = tap;
        [self addSubview:slider];
        _slider = slider;
    }
    return _slider;
}

/*
    以上的操作先是按照UISlider的常规操作进行, 即滑动操作. 然后因为手指非常迅速地离开屏幕, 可能会识别为UITapGesture手势, 调用点击手势的响应方法. 
    TouchDown: 当UISlider被按下时调用.
    TouchUpInside/TouchUpOutside: 松开时调用.
 */
- (void)sliderTouchDown:(UISlider *)slider {
    _tap.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)slider {
    _tap.enabled = YES;
}

- (void)sliderTapped:(UITapGestureRecognizer *)tap {
//    if (tap.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
    CGPoint loc = [tap locationInView:self.slider];
    CGFloat percent = 1.0 * loc.x / CGRectGetWidth(self.slider.bounds);
    CGFloat delta = percent * (self.slider.maximumValue - self.slider.minimumValue);
    CGFloat value = self.slider.minimumValue + delta;
    self.slider.value = value;
    [self sliderValueChanged:self.slider];
}

- (void)affirmBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setProgressViewAffirmBtn:)]) {
        [self.delegate setProgressViewAffirmBtn:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(setProgressViewSetPlan:withHttpResponse:)]) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *param = @{
                                @"bookId" : self.planModel.bookId,
                                @"planNum" : @(self.planModel.planNum)
                                };
        [YXDataProcessCenter POST:DOMAIN_STUDYPLAN parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
            if (weakSelf.setPlanResultBlock) {
                weakSelf.setPlanResultBlock();
            }
            [weakSelf.delegate setProgressViewSetPlan:self withHttpResponse:response];
        }];
    }
}

- (void)sliderValueChanged:(UISlider *)slider {
    NSInteger value = slider.value;
    NSInteger resetValue = 0;
    if (value < 10) {
        if (self.planModel.leftWords < 10) {
            value = self.planModel.leftWords;
            resetValue = self.planModel.leftWords;
        }else {
            value = 10;
            resetValue = (value)/ 5 * 5;
        }
    }else {
        if (value == self.planModel.leftWords && (value % 5) ) {
            resetValue = value;
        }else {
            resetValue = (value)/ 5 * 5;
        }
    }
    
    self.planModel.planNum = resetValue;
    [self refreshData];
}


- (void)refreshData {
    NSInteger leftWords = self.planModel.leftWords;
    NSInteger planNum = self.planModel.planNum;
    self.slider.value = planNum;
    self.progressValueLab.text = [NSString stringWithFormat:@"%zd",planNum];
    
    self.consumTimeValueLab.text = [NSString stringWithFormat:@"%.0f", ceil(planNum * 0.8)];
    
    NSInteger leftDay = 0;
    if(self.planModel.todayLeftWords) {
        leftDay = ceil(1.0 * (leftWords - self.planModel.todayLeftWords) / planNum) + 1;
    }else {
        leftDay = ceil(1.0 * leftWords / planNum);
    }
    
    self.completeDayValueLab.text = [NSString stringWithFormat:@"%zd", leftDay];
    self.tipLab.hidden = self.planModel.theNewBook;
}

- (void)hideTipsLabel {
    self.tipLab.hidden = YES;
}
@end
