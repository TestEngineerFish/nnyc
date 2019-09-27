//
//  YXStudyProgressView.m
//  YXEDU
//
//  Created by shiji on 2018/9/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyProgressView.h"
#import "BSCommon.h"
#import "BSUtils.h"
#import "YXUtils.h"
#import "YXHttpService.h"
#import "YXAPI.h"
#import "YXCustomSlider.h"

@interface YXStudyProgressView ()
@property (nonatomic, weak) YXSetProgressView *progressView;
@end

@implementation YXStudyProgressView {
    YXSetProgressView *_setProgressView;
}

- (YXBookPlanModel *)planModel {
    return self.progressView.planModel;
}

- (void)maskViewWasTapped {
    [super maskViewWasTapped];
    [self hide];
}

- (void)hide {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        self.progressView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 420);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (YXSetProgressView *)setProgressView {
    return self.progressView;
}

+ (YXStudyProgressView *)showProgressInView:(UIView *)view
                              withPlanModel:(YXBookPlanModel *)planModel
                               WithDelegate:(id<YXSetProgressViewDelegate>)delegate
{
    YXStudyProgressView *studyProgressView = [[YXStudyProgressView alloc] initWithFrame:view.bounds];
    YXSetProgressView *progressView = [YXSetProgressView setProgressViewWithPlanModel:planModel withDelegate:delegate];
    progressView.setPlanResultBlock = ^{
        [studyProgressView removeFromSuperview];
    };
    progressView.frame = CGRectMake(0, studyProgressView.bottom, SCREEN_WIDTH, 420);
    studyProgressView.maskView.alpha = 0.0f;
    [studyProgressView addSubview:progressView];
    studyProgressView.progressView = progressView;
    [view addSubview:studyProgressView];
    [UIView animateWithDuration:0.25 animations:^{
        studyProgressView.maskView.alpha = 0.4;
        progressView.frame = CGRectMake(0, studyProgressView.height - 352 - kSafeBottomMargin, SCREEN_WIDTH, 420);
    }];
    return studyProgressView;
}
@end



//    NSInteger leftWords = 0;
//    if (self.pModel.hasPlan) {
//        leftWords = self.pModel.leftWords;
//    }else {
//        leftWords = self.pModel.wordCount;
//    }

//+ (YXStudyProgressView *)showProgressInView:(UIView *)view withParams:(NSDictionary *)dic{
//    YXStudyProgressView *progressView = [[YXStudyProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    progressView.paramsDic = [dic mutableCopy];
//    BOOL isLearned = [dic[@"isLearned"] boolValue];
//    progressView.isLearned = YES;
//    if (isLearned) {
//        [progressView insertDic:dic];
//    }else {// 没有正在学习中的书籍
//        progressView.isLearned = NO;
//        [progressView setSliderValue:20];
//    }
//    [view addSubview:progressView];
//    return progressView;
//}


//- (void)insertDic:(NSDictionary *)dic {
//    self.paramsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    self.progressValueLab.text = self.paramsDic[@"plan_num"];
//    int plan_num = ((NSString *)self.paramsDic[@"plan_num"]).intValue;
//    int word_left = ((NSString *)self.paramsDic[@"word_left"]).intValue;
//    int word_plan = ((NSString *)self.paramsDic[@"word_plan"]).intValue;
//    self.consumTimeValueLab.text = [NSString stringWithFormat:@"%.0f", ceil(plan_num * 0.8)];
//    int leftDay = ceil((word_left-word_plan)/(CGFloat)plan_num);
//    self.completeDayValueLab.text = [NSString stringWithFormat:@"%d", leftDay];
//    CGFloat len = SCREEN_WIDTH-40;
//    CGFloat space = len/100.0;
//    self.gradientImageView.frame = CGRectMake(0, 0, plan_num * space, 10);
//    self.dotImageView.frame = CGRectMake( plan_num * space-10.0, -3.25, 17.5, 17.5);
//}


//- (void)setSliderValue:(int)value {
//    if (value <= 10) {
//        value = 10;
//    }
//    int resetValue = (value)/ 5 * 5;
//    self.planNUm = resetValue;
//    NSLog(@"ori %d fixxxxxx slider  %d",(int)self.slider.value,resetValue);
//    self.slider.value = resetValue;
//    self.progressValueLab.text = [NSString stringWithFormat:@"%.f",self.slider.value];
//    
//    if (self.isLearned) {
//        //        NSInteger total = 1000;
//    }else {
//        NSInteger totalWords = [self.paramsDic[@"wordCount"] integerValue];
//        self.consumTimeValueLab.text = [NSString stringWithFormat:@"%.0f", ceil(resetValue * 0.8)];
//        int leftDay = ceil(1.0 * totalWords/ resetValue);
//        self.completeDayValueLab.text = [NSString stringWithFormat:@"%d", leftDay];
//    }
//}


//    NSLog(@"scrollto slider  %.f",slider.value);
//    if (slider.value <= 10) {
//        slider.value = 10;
//    }
//    int value = ((int)slider.value)/ 5 * 5;
//    NSLog(@"ori %d fixxxxxx slider  %d",(int)slider.value,value);
//    slider.value = value;
//
//    self.progressValueLab.text = [NSString stringWithFormat:@"%d",value];
//[self setSliderValue:slider.value];


//        self.progressGrayView = [[YXProgressView alloc]initWithFrame:CGRectMake(20, 105, SCREEN_WIDTH-40, 10)];
//        self.progressGrayView.layer.cornerRadius = 5.0;
//        self.progressGrayView.userInteractionEnabled = YES;
//        [self.bottomView addSubview:self.progressGrayView];
//
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
//        [self.progressGrayView addGestureRecognizer:pan];

//        self.gradientImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
//        self.gradientImageView.image = [UIImage imageNamed:@"gradient_layer_view"];//
//        self.gradientImageView.clipsToBounds = YES;
//        self.gradientImageView.layer.cornerRadius = 5.0;
//        [self.progressGrayView addSubview:self.gradientImageView];
//
//        self.dotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -3.25, 17.5, 17.5)];
//        self.dotImageView.image = [UIImage imageNamed:@"progress_dot_view"];
//        [self.progressGrayView addSubview:self.dotImageView];

//- (void)panGesture:(UIPanGestureRecognizer *)gesture {
//    switch (gesture.state) {
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateFailed:
//        {
//            CGFloat len = SCREEN_WIDTH-40;
//            CGFloat space = len/100.0;
//            CGFloat dis = [gesture locationInView:self].x-20.0;
//            if (dis <= 10 * space) {
//                self.gradientImageView.frame = CGRectMake(0, 0, 10 * space, 10);
//                self.dotImageView.frame = CGRectMake(10 * space-10.0, -3.25, 17.5, 17.5);
//                [self.paramsDic setValue:@"10" forKey:@"plan_num"];
//                self.consumTimeValueLab.text = [NSString stringWithFormat:@"%.0f", 10 * 0.8];
//                int word_left = ((NSString *)self.paramsDic[@"word_left"]).intValue;
//                int word_plan = ((NSString *)self.paramsDic[@"word_plan"]).intValue;
//                int leftDay = ceil((word_left-word_plan)/10.0);
//                self.completeDayValueLab.text = [NSString stringWithFormat:@"%d", leftDay];
//
//            } else if (dis >= 100*space) {
//                self.gradientImageView.frame = CGRectMake(0, 0, 100 * space, 10);
//                self.dotImageView.frame = CGRectMake(100 * space-10.0, -3.25, 17.5, 17.5);
//                [self.paramsDic setValue:@"100" forKey:@"plan_num"];
//                self.consumTimeValueLab.text = [NSString stringWithFormat:@"%.0f", 100 * 0.8];
//
//                int word_left = ((NSString *)self.paramsDic[@"word_left"]).intValue;
//                int word_plan = ((NSString *)self.paramsDic[@"word_plan"]).intValue;
//                int leftDay = ceil((word_left-word_plan)/100.0);
//                self.completeDayValueLab.text = [NSString stringWithFormat:@"%d", leftDay];
//            } else {
//                CGFloat fiveMutil = dis / (space * 5);
//                self.gradientImageView.frame = CGRectMake(0, 0, round(fiveMutil) * 5 * space, 10);
//                self.dotImageView.frame = CGRectMake(round(fiveMutil) * 5 * space-10.0, -3.25, 17.5, 17.5);
//                self.progressValueLab.text = [NSString stringWithFormat:@"%3.0f", round(fiveMutil) * 5];
//                [self.paramsDic setValue:[NSString stringWithFormat:@"%.0f", round(fiveMutil) * 5] forKey:@"plan_num"];
//                self.consumTimeValueLab.text = [NSString stringWithFormat:@"%.0f", ceil(round(fiveMutil) * 5 * 0.8)];
//
//                int word_left = ((NSString *)self.paramsDic[@"word_left"]).intValue;
//                int word_plan = ((NSString *)self.paramsDic[@"word_plan"]).intValue;
//                int leftDay = ceil((word_left-word_plan)/(CGFloat)round(fiveMutil) * 5);
//                self.completeDayValueLab.text = [NSString stringWithFormat:@"%d", leftDay];
//            }
//        }
//            break;
//        case UIGestureRecognizerStateBegan:
//        case UIGestureRecognizerStateChanged: {
//
//            CGFloat len = SCREEN_WIDTH-40;
//            CGFloat space = len/100.0;
//            CGFloat dis = [gesture locationInView:self].x-20.0;
//            if ( dis < 10*space) {
//                self.gradientImageView.frame = CGRectMake(0, 0, 10*space, 10);
//                self.dotImageView.frame = CGRectMake(10*space-10.0, -3.25, 17.5, 17.5);
//                return;
//            } else if ( dis > len) {
//                self.gradientImageView.frame = CGRectMake(0, 0, 100 * space, 10);
//                self.dotImageView.frame = CGRectMake(100 * space-10.0, -3.25, 17.5, 17.5);
//                return;
//            }
//
//            self.gradientImageView.frame = CGRectMake(0, 0, [gesture locationInView:self].x-20.0, 10);
//            self.dotImageView.frame = CGRectMake([gesture locationInView:self].x-30.0, -3.25, 17.5, 17.5);
//            self.progressValueLab.text = [NSString stringWithFormat:@"%3.0f", round(dis/space)];
//
//            self.completeDayValueLab.text = @"计算中...";
//        }
//            break;
//
//        default:
//            break;
//    }
//}
