//
//  YXExerciseVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXExerciseVC.h"
#import "YXLearnProgressView.h"
#import "BSCommon.h"

#import "YXStudySpellView.h"
#import "YXStudyCmdCenter.h"
#import "YXAnswerModel.h"
#import "YXConfigure.h"
#import "YXAnswerModel.h"
#import "YXStudyBookUnitModel.h"
#import "YXConfigure.h"
#import "YXGraphSelectView.h"
#import "YXWordDetailView.h"
#import "YXENTranCHChoiceView.h"
#import "YXCHTranENChoiceView.h"
#import "YXCompleteUnitView.h"
#import "YXCompleteGroupView.h"
#import "YXConfigure.h"
#import "YXComAlertView.h"
#import "YXExerciseSubmitErrorView.h"
#import "YXUtils.h"
#import "YXExerciseFloatView.h"
#import "YXPersonalFeedBackVC.h"
#import "YXStudyRecordCenter.h"
#import "YXBookModel.h"
#import "YXEDU-Swift.h"


#define groupSize 7

@interface YXExerciseVC () <YXCompleteUnitViewDelegate, YXExerciseFloatViewDelegate>
@property (nonatomic, strong) YXLearnProgressView *progressView;

@property (nonatomic, strong) YXGraphSelectView *graphSelectView;
@property (nonatomic, strong) YXCompleteUnitView *completeUnitView;
@property (nonatomic, strong) YXCompleteGroupView *completeGroupView;
@property (nonatomic, strong) YXENTranCHChoiceView *enTranChView;
@property (nonatomic, strong) YXCHTranENChoiceView *chTranEnView;
@property (nonatomic, strong) YXStudySpellView *spellView;
@property (nonatomic, strong) YXWordDetailView *wordDetailView;
@property (nonatomic, strong) YXExerciseSubmitErrorView *submitView;
@property (nonatomic, strong) YXExerciseFloatView *floatView;
@property (nonatomic, strong) UIButton *reportBtn;

@property (nonatomic, strong) YXUnitModel *unitModel;

@end

@implementation YXExerciseVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [YXConfigure shared].firstAppearKeyBoard = YES;
        [self initWithCmd];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    }
    return self;
}

- (void)initWithCmd {
    // control commond
    [[YXStudyCmdCenter shared]setNextQuestion:^(id obj) {
        YXStudyBookUnitTopicModel *topicModel = obj;
        if ([topicModel.type isEqualToString:@"1"]) {
            self.graphSelectView.hidden = YES;
            [YXStudyCmdCenter shared].answerType = YXAnswerSelectImageState;
        } else if ([topicModel.type isEqualToString:@"2"]) {
            self.enTranChView.hidden = YES;
            [YXStudyCmdCenter shared].answerType = YXAnswerEnglishTranslationChineseState;
        } else if ([topicModel.type isEqualToString:@"3"]) {
            self.chTranEnView.hidden = YES;
            [YXStudyCmdCenter shared].answerType = YXAnswerChineseTranslationEnglishState;
        } else if ([topicModel.type isEqualToString:@"4"]) {
            self.spellView.hidden = YES;
            [YXStudyCmdCenter shared].answerType = YXAnswerWordSpellState;
        }
    }];
    
    [[YXStudyCmdCenter shared]setNextWord:^(id obj) {
        YXStudyBookUnitTopicModel *topicModel = obj;
        if ([topicModel.type isEqualToString:@"1"]) {
            [YXStudyCmdCenter shared].answerType = YXAnswerSelectImageState;
        } else if ([topicModel.type isEqualToString:@"2"]) {
            [YXStudyCmdCenter shared].answerType = YXAnswerEnglishTranslationChineseState;
        } else if ([topicModel.type isEqualToString:@"3"]) {
            [YXStudyCmdCenter shared].answerType = YXAnswerChineseTranslationEnglishState;
        } else if ([topicModel.type isEqualToString:@"4"]) {
            [YXStudyCmdCenter shared].answerType = YXAnswerWordSpellState;
        }
    }];
    
    [[YXStudyCmdCenter shared]setNextGroup:^(id obj) { // 进入下一组
        [YXStudyCmdCenter shared].answerType = YXAnswerNextGroup;
    }];
    
    [[YXStudyCmdCenter shared]setNextUnit:^(id obj) {
        [YXStudyCmdCenter shared].answerType = YXAnswerNextUnit;
    }];
    
    [[YXStudyCmdCenter shared]setShowTipView:^(id obj) {
        [self showLeftBarButtonItem];
        NSNumber *num = obj;
        switch (num.integerValue) {
            case YXAnswerSelectImageState:
                [self showViewClass:[self.graphSelectView class]];
                break;
            case YXAnswerSelectImageWrong1:
                [self showViewClass:[self.graphSelectView class]];
                break;
            case YXAnswerSelectImageWrong2:
                [self showViewClass:[self.graphSelectView class]];
                break;
            case YXAnswerSelectImageWrong3:
                [self delayShowView:[self.wordDetailView class]];
                break;
            case YXAnswerSelectImageRight:
                [self delayShowView:[self.wordDetailView class]];
                break;
                
                // 英译汉
            case YXAnswerEnglishTranslationChineseState:
                [self showViewClass:[self.enTranChView class]];
                break;
            case YXAnswerEnglishTranslationChineseWrong1:
                [self showViewClass:[self.enTranChView class]];
                break;
            case YXAnswerEnglishTranslationChineseWrong2:
                [self showViewClass:[self.enTranChView class]];
                break;
            case YXAnswerEnglishTranslationChineseWrong3:
                [self delayShowView:[self.wordDetailView class]];
                break;
            case YXAnswerEnglishTranslationChineseRight:
                [self delayShowView:[self.wordDetailView class]];
                break;
                
                // 汉译英
            case YXAnswerChineseTranslationEnglishState:
                [self showViewClass:[self.chTranEnView class]];
                break;
            case YXAnswerChineseTranslationEnglishWrong1:
                [self showViewClass:[self.chTranEnView class]];
                break;
            case YXAnswerChineseTranslationEnglishWrong2:
                [self showViewClass:[self.chTranEnView class]];
                break;
            case YXAnswerChineseTranslationEnglishWrong3:
                [self delayShowView:[self.wordDetailView class]];
                break;
            case YXAnswerChineseTranslationEnglishRight:
                [self delayShowView:[self.wordDetailView class]];
                break;
                
                // 单词拼写
            case YXAnswerWordSpellState:
                [self showViewClass:[self.spellView class]];
                break;
            case YXAnswerWordSpellWrong1:
                [self showViewClass:[self.spellView class]];
                break;
            case YXAnswerWordSpellWrong2:
                [self showViewClass:[self.spellView class]];
                break;
            case YXAnswerWordSpellWrong3:
                [self delayShowView:[self.wordDetailView class]];
                break;
            case YXAnswerWordSpellRight:
                [self delayShowView:[self.wordDetailView class]];
                break;
                
                // 下一组
            case YXAnswerNextGroup:
                [self showViewClass:[self.completeGroupView class]];
                break;
            case YXAnswerNextUnit:
                [self hidenLeftBarButtonItem];
                [self showViewClass:[self.completeUnitView class]];
                break;
            default:
                break;
        }
    }];
    // 初始化数据
    [[YXStudyCmdCenter shared]currentUnitInfo:[YXConfigure shared].bookUnitModel];
}

- (void)showLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
}


- (void)hidenLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.progressView = [[YXLearnProgressView alloc]initWithFrame:CGRectMake(50, StatusBarHeight + 15, SCREEN_WIDTH-60, 20)];
    [self.view addSubview:self.progressView];
    
    self.progressView.unitGroupTotal = [[YXStudyCmdCenter shared]groupNum];//2
    self.progressView.unitGroupIdx = 0;
    self.progressView.unitGroupQuestionCount = [[YXStudyCmdCenter shared]groupQuestionCount]; //2
    self.progressView.unitGroupQuestionLearnCount = 0;
    
//    NSLog(@"%lu", (unsigned long)[YXConfigure shared].loginModel.learning.unit.count);
//    NSLog(@"%ld", (long)self.mainToStudy.unitNum);
//    NSLog(@"%ld", (long)self.mainToStudy.unit.word.integerValue);
//    NSLog(@"%ld", (long)self.mainToStudy.unit.learned.integerValue);
    
    // 单词详情页面
    self.wordDetailView = [[YXWordDetailView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    [self.view addSubview:self.wordDetailView];
    self.wordDetailView.hidden = YES;
    
    
    // 图片选择页面
    self.graphSelectView = [[YXGraphSelectView alloc]init];
    self.graphSelectView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    [self.view addSubview:self.graphSelectView];
    self.graphSelectView.hidden = YES;
    
    // 完成单元
    self.completeUnitView = [[YXCompleteUnitView alloc]init];
    self.completeUnitView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    [self.view addSubview:self.completeUnitView];
    self.completeUnitView.delegate = self;
    self.completeUnitView.hidden = YES;
    
    // 完成组
    self.completeGroupView = [[YXCompleteGroupView alloc]init];
    self.completeGroupView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    [self.view addSubview:self.completeGroupView];
    self.completeGroupView.hidden = YES;
    
    // 英译汉，
    self.enTranChView = [[YXENTranCHChoiceView alloc]init];
    self.enTranChView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    [self.view addSubview:self.enTranChView];
    self.enTranChView.hidden = YES;
    
    // 汉译英
    self.chTranEnView = [[YXCHTranENChoiceView alloc]init];
    self.chTranEnView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    [self.view addSubview:self.chTranEnView];
    self.chTranEnView.hidden = YES;
    
    // 拼写
    self.spellView = [[YXStudySpellView alloc]init];
    self.spellView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    [self.view addSubview:self.spellView];
    self.spellView.hidden = YES;
    
    [self.view bringSubviewToFront:self.completeGroupView];
    [self.view bringSubviewToFront:self.completeUnitView];
    [self.view bringSubviewToFront:self.wordDetailView];
    
    if ((self.unitModel.learned.integerValue != self.unitModel.word.integerValue && self.unitModel.q_idx.integerValue > 0) || (self.unitModel.learn_status.integerValue && self.unitModel.q_idx.integerValue == 0)) {
        [YXConfigure shared].isNeedPlayAudio = NO;
        [[YXStudyCmdCenter shared]lastStudyPosition];
        [YXConfigure shared].isNeedPlayAudio = YES;
        [YXComAlertView showAlert:YXAlertStudySelect inView:[UIApplication sharedApplication].keyWindow info:[NSString stringWithFormat:@"上次已学到本单元第%ld组是否继续学习?",(long)[YXStudyCmdCenter shared].groupIndex+1] content:nil firstBlock:^(id obj) { // 重新开始
            [[YXStudyCmdCenter shared]startTopic];
            [self resetProgressView];
        } secondBlock:^(id obj) { // 继续学习
            [[YXStudyCmdCenter shared]startContinue];
            [self resetProgressView];
        }];
    } else { // 重新开始
        [YXConfigure shared].isNeedPlayAudio = YES;
        [[YXStudyCmdCenter shared]startTopic];
    }
    
    self.reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reportBtn setExclusiveTouch:YES];
    [self.reportBtn setFrame:CGRectMake(SCREEN_WIDTH-42, NavHeight, 26, 26)];
    [self.reportBtn setBackgroundColor:[UIColor clearColor]];
    [self.reportBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.reportBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.reportBtn setBackgroundImage:[UIImage imageNamed:@"study_feed_btn"] forState:UIControlStateNormal];
    [self.view addSubview:self.reportBtn];
    
    // 提交View
    self.submitView = [[YXExerciseSubmitErrorView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.submitView.hidden = YES;
    [self.view addSubview:self.submitView];
    
    // 漂浮窗口
    self.floatView = [[YXExerciseFloatView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.floatView.hidden = YES;
    self.floatView.delegate = self;
    [self.view addSubview:self.floatView];
    
}

//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification {
    [YXUtils screenShot:self.view];
    self.floatView.hidden = NO;
}

#pragma mark -YXExerciseFloatViewDelegate-
- (void)submitBtnClicked:(id)sender {
    [self.view endEditing:YES];
    YXPersonalFeedBackVC *submitVC = [[YXPersonalFeedBackVC alloc]init];
    [self.navigationController pushViewController:submitVC animated:YES];
}

- (void)back {
    [super back];
    [[YXStudyRecordCenter shared]createPackage:^(id obj, BOOL result) {}]; // 点击返回打包
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)reportBtnClicked:(id)sender {
    [YXUtils screenShot:self.view];
    if (self.submitView.hidden == YES) {
        [self.submitView showSubmitView:^(id obj, BOOL result) {
            self.submitView.userInteractionEnabled = YES;
        }];
    }
}


- (void)insertModel:(id)model {
    self.unitModel = model;
}

- (void)delayShowView:(Class)cls {
    __weak YXExerciseVC *weakSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [weakSelf showViewClass:cls];
    });
}

- (void)animateShowWordDetailView {
    [UIView animateWithDuration:duration animations:^{
        self.wordDetailView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    } completion:^(BOOL finished) {
        if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageWrong3) {
            self.graphSelectView.hidden = YES;
        }
        if ([YXStudyCmdCenter shared].answerType != YXAnswerEnglishTranslationChineseWrong3) {
            self.enTranChView.hidden = YES;
        }
        if ([YXStudyCmdCenter shared].answerType != YXAnswerChineseTranslationEnglishWrong3) {
            self.chTranEnView.hidden = YES;
        }
        if ([YXStudyCmdCenter shared].answerType != YXAnswerWordSpellWrong3) {
            self.spellView.hidden = YES;
        }
        self.completeUnitView.hidden = YES;
        self.completeGroupView.hidden = YES;
        self.reportBtn.hidden = NO;
    }];
}

- (void)showViewClass:(Class)cls {
    if (cls == [self.wordDetailView class]) {
        self.wordDetailView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
        self.wordDetailView.hidden = NO;
        __weak YXExerciseVC *weakSelf = self;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [weakSelf animateShowWordDetailView];
        });
    } else if (cls == [self.graphSelectView class]) {
        if (self.graphSelectView.hidden == YES) {
            self.graphSelectView.hidden = NO;
        }
        self.enTranChView.hidden = YES;
        self.chTranEnView.hidden = YES;
        self.spellView.hidden = YES;
        self.reportBtn.hidden = NO;
        [self hidenCompleteUnitView];
        [self hidenCompleteGroupView];
        [self hidenWordDetailView];
        if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageWrong2) {
            self.graphSelectView.answerType = [YXStudyCmdCenter shared].answerType;
        }
        [YXConfigure shared].firstAppearKeyBoard = NO;
    } else if (cls == [self.completeGroupView class]) {
        self.completeGroupView.hidden = NO;
        self.graphSelectView.hidden = YES;
        self.enTranChView.hidden = YES;
        self.chTranEnView.hidden = YES;
        self.spellView.hidden = YES;
        self.reportBtn.hidden = YES;
        [self hidenCompleteUnitView];
        [self hidenWordDetailView];
    } else if (cls == [self.completeUnitView class] ) {
        self.completeUnitView.hidden = NO;
        self.graphSelectView.hidden = YES;
        self.enTranChView.hidden = YES;
        self.chTranEnView.hidden = YES;
        self.spellView.hidden = YES;
        self.reportBtn.hidden = YES;
        [self hidenCompleteGroupView];
        [self hidenWordDetailView];
    } else if (cls == [self.enTranChView class]) {
        if (self.enTranChView.hidden == YES) {
            self.enTranChView.hidden = NO;
        }
        self.graphSelectView.hidden = YES;
        self.chTranEnView.hidden = YES;
        self.spellView.hidden = YES;
        self.reportBtn.hidden = NO;
        [self hidenCompleteUnitView];
        [self hidenCompleteGroupView];
        [self hidenWordDetailView];
        if ([YXStudyCmdCenter shared].answerType != YXAnswerEnglishTranslationChineseWrong2) {
            self.enTranChView.answerType = [YXStudyCmdCenter shared].answerType;
        }
        [YXConfigure shared].firstAppearKeyBoard = NO;
    }  else if (cls == [self.chTranEnView class]) {
        if (self.chTranEnView.hidden == YES) {
            self.chTranEnView.hidden = NO;
        }
        self.graphSelectView.hidden = YES;
        self.enTranChView.hidden = YES;
        self.spellView.hidden = YES;
        self.reportBtn.hidden = NO;
        [self hidenCompleteUnitView];
        [self hidenCompleteGroupView];
        [self hidenWordDetailView];
        if ([YXStudyCmdCenter shared].answerType != YXAnswerChineseTranslationEnglishWrong2) {
            self.chTranEnView.answerType = [YXStudyCmdCenter shared].answerType;
        }
        [YXConfigure shared].firstAppearKeyBoard = NO;
    } else if (cls == [self.spellView class]) {
        if (self.spellView.hidden == YES) {
            self.spellView.hidden = NO;
        }
        self.graphSelectView.hidden = YES;
        self.enTranChView.hidden = YES;
        self.chTranEnView.hidden = YES;
        self.reportBtn.hidden = NO;
        [self hidenCompleteUnitView];
        [self hidenCompleteGroupView];
        [self hidenWordDetailView];
        self.spellView.answerType = [YXStudyCmdCenter shared].answerType;
    }
}

- (void)hidenCompleteUnitView {
    if (self.completeUnitView.hidden == NO) {
        [self resetProgressView];
        [UIView animateWithDuration:duration animations:^{
            self.completeUnitView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
        } completion:^(BOOL finished) {
            self.completeUnitView.hidden = YES;
            self.completeUnitView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
        }];
    } else {
        self.completeUnitView.hidden = YES;
    }
}

- (void)hidenCompleteGroupView {
    if (self.completeGroupView.hidden == NO) {
        [self resetProgressView];
        [UIView animateWithDuration:duration animations:^{
            self.completeGroupView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
        } completion:^(BOOL finished) {
            self.completeGroupView.hidden = YES;
            self.completeGroupView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
        }];
    } else {
        self.completeGroupView.hidden = YES;
    }
}

- (void)hidenWordDetailView {
    if (self.wordDetailView.hidden == NO) {
        [self resetProgressView];
        self.wordDetailView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
        self.wordDetailView.hidden = YES;
    } else {
        self.wordDetailView.hidden = YES;
    }
}

- (void)resetProgressView {
    self.progressView.unitGroupTotal = [[YXStudyCmdCenter shared]groupNum];
    self.progressView.unitGroupIdx = [[YXStudyCmdCenter shared]groupIndex];
    self.progressView.unitGroupQuestionCount = [[YXStudyCmdCenter shared]groupQuestionCount]; //2
    self.progressView.unitGroupQuestionLearnCount = [[YXStudyCmdCenter shared]groupQuestionLearnCount];
}

#pragma mark -YXCompleteUnitViewDelegate-
- (void)backToMainPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
