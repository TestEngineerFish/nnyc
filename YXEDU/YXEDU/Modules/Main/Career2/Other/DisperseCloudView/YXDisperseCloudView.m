//
//  YXDisperseCloudView.m
//  YXEDU
//
//  Created by yixue on 2019/2/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXDisperseCloudView.h"
#import "YXCycleView.h"

@interface YXDisperseCloudView ()

@property (nonatomic, strong) UIImageView *cloud_left1;
@property (nonatomic, strong) UIImageView *cloud_left2;
@property (nonatomic, strong) UIImageView *cloud_right1;
@property (nonatomic, strong) UIImageView *cloud_right2;

@property (nonatomic, strong) UILabel *startLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, copy) NSString *typeString;
// 需要展示progressView的属性
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) YXCycleView *progressView;

@end

@implementation YXDisperseCloudView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        UIImageView *cloud_left1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_left1"]];
        cloud_left1.frame = CGRectMake(0, 0, AdaptSize(374), AdaptSize(532));
        [self addSubview:cloud_left1];
        _cloud_left1 = cloud_left1;
        
        UIImageView *cloud_left2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_left2"]];
        cloud_left2.frame = CGRectMake(0, SCREEN_HEIGHT - AdaptSize(511), AdaptSize(411), AdaptSize(511));
        [self addSubview:cloud_left2];
        _cloud_left2 = cloud_left2;
        
        UIImageView *cloud_right1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_right1"]];
        cloud_right1.frame = CGRectMake(SCREEN_WIDTH - AdaptSize(411), 0, AdaptSize(411), AdaptSize(582));
        [self addSubview:cloud_right1];
        _cloud_right1 = cloud_right1;

        UIImageView *cloud_right2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud_right2"]];
        cloud_right2.frame = CGRectMake(SCREEN_WIDTH - AdaptSize(341), SCREEN_HEIGHT - AdaptSize(404), AdaptSize(341), AdaptSize(404));
        [self addSubview:cloud_right2];
        _cloud_right2 = cloud_right2;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 67)];
//        titleLbl.text = @"复习";
        titleLbl.font = [UIFont pfSCSemiboldFontWithSize:65];
        titleLbl.textColor = UIColorOfHex(0x0EADFD);
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLbl];
        _titleLbl = titleLbl;
        
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 105, 240, 210, 17)];
//        detailLbl.text = @"本轮共有00个单词需要复习";
        detailLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:detailLbl];
        _detailLbl = detailLbl;

        UILabel *startLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, SCREEN_HEIGHT/2 + 100, 200, 40)];
        startLbl.text = @"start";
        startLbl.textColor = UIColorOfHex(0x434a5d);
        startLbl.textAlignment = NSTextAlignmentCenter;
        startLbl.font = [UIFont pfSCSemiboldFontWithSize:40.f];
        [self addSubview:startLbl];
        _startLbl = startLbl;

        UILabel *statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + 15.f, SCREEN_WIDTH, 22.f)];
        statusLbl.text = @"已学完";
        statusLbl.textColor = UIColorOfHex(0x8D96AF);
        statusLbl.centerX = self.centerX;
        statusLbl.textAlignment = NSTextAlignmentCenter;
        statusLbl.font = [UIFont systemFontOfSize:22];
        statusLbl.alpha = 0;
        [self addSubview:statusLbl];
        _statusLbl = statusLbl;

        UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(statusLbl.frame) + 20.f, SCREEN_WIDTH, 16.f)];
        descLbl.text = @"休息一下,准备下一组的学习~";
        descLbl.textColor = UIColorOfHex(0x434A5D);
        descLbl.centerX = self.centerX;
        descLbl.textAlignment = NSTextAlignmentCenter;
        descLbl.font = [UIFont systemFontOfSize:16];
        descLbl.alpha = 0;
        [self addSubview:descLbl];
        _descLbl = descLbl;

        YXCycleView *progressView = [YXCycleView showCycleViewWith:CGRectMake(0, CGRectGetMaxY(detailLbl.frame) + 100.f, 58.f, 58.f)];
        progressView.centerX = self.centerX;
        progressView.alpha = 0;
        [self addSubview:progressView];
        _progressView = progressView;
    }
    return self;
}

#pragma mark - To Open

- (void)doOpenAnimate {
    [self doOpenAnimateWithDelay:0 finishBlock:nil];
}

- (void)doOpenAnimateFinishBlock:(void(^)(void))finishBlock {
    [self doOpenAnimateWithDelay:0 finishBlock:finishBlock];
}

- (void)doOpenAnimateWithDelay:(NSInteger)delay finishBlock:(void(^)(void))finishBlock {
    [self doOpenAnimateWithBeforAction:nil delay:delay duration:1.f closedFinishBlock:finishBlock];
}

/**
 * beforAction: 动画之前执行函数
 * delay: 动画延迟执行时间 单位:s
 * duration: 动画持续时间 单位:s
 * closedFinishBlock: 动画结束后执行函数
 **/

- (void)doOpenAnimateWithBeforAction:(nullable void(^)(void))beforeAction delay:(NSInteger)delay duration:(NSInteger)duration closedFinishBlock:(void(^)(void))finishBlock {

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
        if (beforeAction) {
            beforeAction();
        }
        _cloud_left1.frame = CGRectMake(-AdaptSize(374), 0, AdaptSize(374), AdaptSize(532));
        _cloud_left2.frame = CGRectMake(-AdaptSize(411), SCREEN_HEIGHT - AdaptSize(511), AdaptSize(411), AdaptSize(511));
        _cloud_right1.frame = CGRectMake(SCREEN_WIDTH, 0, AdaptSize(411), AdaptSize(582));
        _cloud_right2.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - AdaptSize(404), AdaptSize(341), AdaptSize(404));
        _titleLbl.alpha      = 0;
        _detailLbl.alpha     = 0;
        _startLbl.alpha      = 0;
        _statusLbl.alpha     = 0;
        _descLbl.alpha       = 0;
        _progressView.alpha  = 0;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.isShowView = NO;
        if (finishBlock) {
            finishBlock();
        }
    }];
}

#pragma mark - To Close

- (void)doCloseAnimate {
    [self doCloseAnimateWithDelay:0.f duration:1.f showProgress:NO closedFinishBlock:nil beforeOpeningBlock:nil doOpenWithDelay:3.f openFinishBlock:nil];
}

- (void)doCloseAnimateShowProgress:(BOOL)show closedFinishBlock:(nullable void(^)(void))finishBlock openFinishBlock:(nullable void(^)(void))openFinishBlock doOpenWithDelay:(NSInteger)openDelay {
    [self doCloseAnimateWithDelay:0.f duration:1.0 showProgress:show closedFinishBlock:finishBlock beforeOpeningBlock:nil doOpenWithDelay:openDelay openFinishBlock:openFinishBlock];
}

/**
 * delay: 动画延迟执行时间 单位:s
 * duration: 动画持续时间 单位:s
 * showProgress: 是否显示圆形进度条动画
 * closedFinishBlock: 动画结束后执行的函数
 * beforeOpeningBlock: 打开动画前执行的函数
 * doOpenWithDelay: 动画结束后,延迟多久执行打开云动画 单位:s
 * openFinishBlock: 打开动画结束后执行函数
 **/

- (void)doCloseAnimateWithDelay:(NSInteger)delay duration:(NSInteger)duration showProgress:(BOOL)show closedFinishBlock:(nullable void(^)(void))finishBlock beforeOpeningBlock:(nullable void(^)(void))beforeOpenBlock doOpenWithDelay:(NSInteger)openDelay openFinishBlock:(void(^)(void))openFinishBlock {

    // 过场动画时，可能需要做一些事情
    self.isShowView = YES;
    self.hidden = NO;

    if (show) {
        self.progressView.shapeLayer.strokeEnd = 0.f;
        [self.progressView startProgressAnimate:openDelay + duration finishBlock:^{
            self.progressView.alpha = 0;
        }];
    }

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
        _cloud_left1.frame  = CGRectMake(0, 0, AdaptSize(374), AdaptSize(532));
        _cloud_left2.frame  = CGRectMake(0, SCREEN_HEIGHT - AdaptSize(511), AdaptSize(411), AdaptSize(511));
        _cloud_right1.frame = CGRectMake(SCREEN_WIDTH - AdaptSize(411), 0, AdaptSize(411), AdaptSize(582));
        _cloud_right2.frame = CGRectMake(SCREEN_WIDTH - AdaptSize(341), SCREEN_HEIGHT - AdaptSize(404), AdaptSize(341), AdaptSize(404));
        if (show) {
            _titleLbl.alpha      = 1;
            _detailLbl.alpha     = 0;
            _startLbl.alpha      = 0;
            _statusLbl.alpha     = 1;
            _descLbl.alpha       = 1;
            _progressView.alpha  = 1;
        } else {
            _titleLbl.alpha      = 1;
            _detailLbl.alpha     = 1;
            _startLbl.alpha      = 1;
            _statusLbl.alpha     = 0;
            _descLbl.alpha       = 0;
            _progressView.alpha  = 0;
        }
        self.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        if (finishBlock) {
            finishBlock();
        }
        [self doOpenAnimateWithBeforAction:beforeOpenBlock delay:openDelay duration:1.0f closedFinishBlock:openFinishBlock];
    }];

}

- (void)setType:(YXExerciseType)type {
    _type = type;
    switch (type) {
        case YXExerciseReview:
        {
            _titleLbl.text = @"复习";
            _typeString = @"复习";
        }
            break;
        case YXExercisePickError:
        {
            _titleLbl.text = @"抽查复习";
            _typeString = @"复习";
            break;
        }
        default:
            _titleLbl.text = @"学习";
             _typeString = @"学习";
            break;
    }
}

- (void)setNumberOfWords:(NSInteger)numberOfWords {
    _numberOfWords = numberOfWords;
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]
                                       initWithString:@"本轮共有"
                                       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],
                                                    NSForegroundColorAttributeName: UIColorOfHex(0x434A5D)}];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]
                                       initWithString:[NSString stringWithFormat:@"%zd",_numberOfWords]
                                       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18],
                                                    NSForegroundColorAttributeName: UIColorOfHex(0x0EADFD)}];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc]
                                       initWithString:[NSString stringWithFormat:@"个单词需要%@",_typeString]
                                       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],
                                                    NSForegroundColorAttributeName: UIColorOfHex(0x434A5D)}];
    [str1 appendAttributedString:str2];
    [str1 appendAttributedString:str3];
    _detailLbl.attributedText = str1;
}

- (void)setNumberOfSection:(NSInteger)numberOfSection {
    _numberOfSection = numberOfSection;
    NSMutableString *str = [NSMutableString stringWithString:@"学习第组"];
    [str insertString:[NSString stringWithFormat:@"%zd",numberOfSection] atIndex:3];
    _titleLbl.text = str;
}

@end



@implementation YXCloudWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.windowLevel = UIWindowLevelStatusBar;
        UIViewController *rootVC = [[UIViewController alloc] init];
        rootVC.view.backgroundColor = [UIColor clearColor];
        self.rootViewController = rootVC;
        self.backgroundColor = [UIColor whiteColor];
        
        YXDisperseCloudView *disperseCloudView = [[YXDisperseCloudView alloc] initWithFrame:self.frame];
        [self addSubview:disperseCloudView];
        _cloudView = disperseCloudView;
        self.hidden = NO;
    }
    return self;
}

- (void)doCloseAnimate {
    [self.cloudView doCloseAnimate];
}

- (void)doCloseAnimateShowProgress:(BOOL)show closedFinishBlock:(nullable void(^)(void))finishBlock openFinishBlock:(nullable void(^)(void))openFinishBlock {
    [self.cloudView doCloseAnimateShowProgress:show closedFinishBlock:finishBlock openFinishBlock:openFinishBlock doOpenWithDelay:3.f];
}

- (void)doOpenAnimate {
    [self.cloudView doOpenAnimate];
}

- (void)setType:(YXExerciseType)type {
    self.cloudView.type = type;
}

- (void)setNumberOfWords:(NSInteger)numberOfWords {
    self.cloudView.numberOfWords = numberOfWords;
}
@end
