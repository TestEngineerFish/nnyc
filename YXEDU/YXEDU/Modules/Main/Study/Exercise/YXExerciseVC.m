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
#import "YXWordDetailViewOld.h"
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
#import "YXPinkProgressView.h"
#import "YXStudyViewModel.h"
#import "YXGroupQuestionModel.h"
#import "AVAudioPlayerManger.h"
#import "YXWordDetailViewControllerOld.h"
#import "YXReportErrorView.h"
#import "YXQuestionGenerator.h"
#import "AFHTTPSessionManager.h"
#import "YXSpokenView.h"
#import "YXPersonalFeedBackVC.h"
#import "YXSpellGuideView.h"
#import "YXReviewAccomplishView.h"
#import "YXStudyAccomplishView.h"

static NSString *const kSpellGuidedKey = @"SpellGuidedKey";
#define groupSize 7

@interface YXExerciseVC () <YXCompleteUnitViewDelegate, YXExerciseFloatViewDelegate,YXQuestionBaseViewDelegate,YXSpokenViewDelegate,YXSpellGuideViewDelegate,YXReviewAccomplishViewDelegate>

@property (nonatomic, strong) YXLearnProgressView *progressView;

@property (nonatomic, strong) YXGraphSelectView *graphSelectView;
@property (nonatomic, strong) YXCompleteUnitView *completeUnitView;
@property (nonatomic, strong) YXCompleteGroupView *completeGroupView;
@property (nonatomic, strong) YXENTranCHChoiceView *enTranChView;
@property (nonatomic, strong) YXCHTranENChoiceView *chTranEnView;
@property (nonatomic, strong) YXStudySpellView *spellView;
@property (nonatomic, strong) YXWordDetailViewOld *wordDetailView;
@property (nonatomic, strong) YXExerciseSubmitErrorView *submitView;
@property (nonatomic, strong) YXExerciseFloatView *floatView;
@property (nonatomic, strong) UIButton *reportBtn;
@property (nonatomic, strong) YXUnitModel *unitModel;


@property (nonatomic, weak)YXPinkProgressView *studyProgressView;
@property (nonatomic, weak)UIView *questionAreaView;
//@property (nonatomic, strong)YXGroupQuestionModel *groupQuestionModel;
@property (nonatomic, strong)YXQuestionGenerator *questionGenerator;
@property (nonatomic, weak)UIButton *favButton;
@property (nonatomic, weak)UIButton *reportButton;
@property (nonatomic, weak)YXQuestionBaseView *curShowQuestionView;

@property (nonatomic, strong)NSDate *studyStartDate;

@property (nonatomic, assign) NSInteger currentGroupIndex;
//拼写引导图
@property (nonatomic, weak) YXSpellGuideView *spellGuideView;

@end

@implementation YXExerciseVC
+ (YXExerciseVC *)exerciseVCWithType:(YXExerciseType)exerciseType learningBookId:(NSString *)bookId {
    YXExerciseVC *evc = [[YXExerciseVC alloc] init];
    evc.exerciseType = exerciseType;
    evc.learningBookId = bookId ? bookId : @"";
    return evc;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [YXConfigure shared].firstAppearKeyBoard = YES;
        //注册通知
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(userDidTakeScreenshot:)
//                                                     name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    }
    return self;
}

- (YXQuestionGenerator *)questionGenerator {
    if (!_questionGenerator) {
        _questionGenerator = [[YXQuestionGenerator alloc] init];
    }
    return _questionGenerator;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"com_nav_shadow"]];
    //    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_disperseCloudView removeFromSuperview];
}

- (BOOL)popGestureRecognizerEnabled {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.studyStartDate = [NSDate date];
    [kNotificationCenter addObserver:self selector:@selector(favStateChangeNotify:) name:kWordFavStateChangeNotify object:nil];
    [self.questionAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.studyProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(5);
    }];
    //收藏按钮
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
    [favButton setImage:[UIImage imageNamed:@"question_fav_nor"] forState:UIControlStateNormal];
    [favButton setImage:[UIImage imageNamed:@"question_fav_high"] forState:UIControlStateHighlighted];
    [favButton setImage:[UIImage imageNamed:@"question_fav_sel"] forState:UIControlStateSelected];
    [favButton addTarget:self action:@selector(favouriteWord:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favItem = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    _favButton = favButton;
    
    //反馈报告按钮
    UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 23)];
    [reportButton setImage:[UIImage imageNamed:@"question_error_nor"] forState:UIControlStateNormal];
    [reportButton setImage:[UIImage imageNamed:@"question_error_nor_high"] forState:UIControlStateHighlighted];
    [reportButton addTarget:self action:@selector(reportError:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reporErrItem = [[UIBarButtonItem alloc] initWithCustomView:reportButton];
    _reportButton = reportButton;
    
    self.navigationItem.rightBarButtonItems = @[reporErrItem,favItem];

    //返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"  " forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"back_white"];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 44);// CGSizeMake(80, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if ([self isGroupQuestionType]) {
        [self handleGroupQuestionsDataWithExerciseType:self.exerciseType];
    }else {
        [self handleQuestionDataWithExerciseType:self.exerciseType];
    }
    
    [self disperseCloudView];
}

#pragma mark - 题型归类
- (BOOL)isGroupQuestionType {
    return  self.exerciseType == YXExerciseNormal ||
            self.exerciseType == YXExerciseWordListStudy ||
            self.exerciseType == YXExerciseWordListListen;
}
#pragma mark - 返回逻辑
- (void)back {
    [self releaseCurrentQuestionViewResource];
    BOOL isSpellQuesView = [self.curShowQuestionView isKindOfClass:[YXSpellQuestionView class]];
    if (isSpellQuesView) {
        [self.curShowQuestionView endEditing:YES];
    }
    if(_questionGenerator) { // 初始化了题目生成器
        YXExerciseType groupType = _questionGenerator.groupQuestionModel.groupExeType;
        if(groupType == YXExercisePickError) { // 展示结果页或者直接返回
            if (self.questionGenerator.curQuestionIndex) {
                [self showStudyResultWithType:YXExercisePickError];
            }else {
               [self backToPreviousViewController];
            }
        }else {
            [YXComAlertView showAlert:YXAlertCommon inView:[UIApplication sharedApplication].keyWindow info:@"提示" content:@"是否确认退出本次学习流程？" firstBlock:^(id obj) {
//                groupType ? : [self studyResultReport:NO]; // 常规题返回上报（因为按组上报），复习题返回无需上报（因为按题上报）
                if (groupType != YXExerciseReview) {
                    [self studyResultReport:NO exerciseType:groupType];
                }
                [self backToPreviousViewController];
            } secondBlock:^(id obj) {
                if (isSpellQuesView) {
                    [self.curShowQuestionView didEndTransAnimated];
                }
            }];
        }
    }else {
        [self backToPreviousViewController];
    }
}

- (void)backToPreviousViewController {
    if (self.exerciseType == YXExerciseWordListStudy || self.exerciseType == YXExerciseWordListListen || self.exerciseType == YXExerciseReview) {
        [kNotificationCenter postNotificationName:kWordListShouldRefreshDataNotify object:nil userInfo:nil];
    }
    
    BOOL isSpellQuesView = [self.curShowQuestionView isKindOfClass:[YXSpellQuestionView class]];
    if (isSpellQuesView) {
        [self.curShowQuestionView endEditing:YES];
        if (((NSInteger)(self.questionGenerator.curQuestionIndex + 1))>1) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self traceStudyTime]; // 统计时长
}

- (void)traceStudyTime {
    NSTimeInterval intever = [[NSDate date] timeIntervalSinceDate:self.studyStartDate];
    [self traceEvent:kTraceStudyTime descributtion:[NSString stringWithFormat:@"%.f",intever]];
}

- (void)backReport {
    NSString *answerJson = self.questionGenerator.groupAnsweredJson;
    NSDictionary *param = @{
                            @"questions" : answerJson
                            };
    [YXDataProcessCenter POST:DOMAIN_STUDYREPORT
                   modelClass:[YXGroupQuestionModel class]
                   parameters:param
                 finshedBlock:^(YRHttpResponse *response, BOOL result)
    {
    }];
}
#pragma mark - handleData
/** 获取题目组模型 返回题目组模型 */
- (void)handleGroupQuestionsDataWithExerciseType:(YXExerciseType)exerciseType {
    NSString *domain = DOMAIN_QUESTION;
    NSString *paramKey = @"bookId";
    if (exerciseType == YXExerciseWordListStudy) {
        domain = DOMAIN_WORDLISTSTARTLEARN;
        paramKey = @"wordListId";
    }else if (exerciseType == YXExerciseWordListListen) {
        domain = DOMAIN_WORDLISTSTARTLISTEN;
        paramKey = @"wordListId";
    }
    
    NSDictionary *param = @{paramKey : self.learningBookId};
    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
    [YXDataProcessCenter GET:domain
                  modelClass:[YXGroupQuestionModel class]
                  parameters:param
                finshedBlock:^(YRHttpResponse *response, BOOL result)
     {
         if (result) {
             YXGroupQuestionModel *groupQuestionModel = response.responseObject;
             groupQuestionModel.groupExeType = exerciseType;
             [self receivedGroupQuestion:groupQuestionModel];
         }else {
             [self.disperseCloudView doOpenAnimateFinishBlock:^{
                 [self.curShowQuestionView didEndTransAnimated];
             }];
             [self.disperseCloudView removeFromSuperview];
         }
         [YXUtils hideHUD:self.view];
     }];
}

/** 获取其他流程题 返回题目数组 */
- (void)handleQuestionDataWithExerciseType:(YXExerciseType)exerciseType {
    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
    NSString *url = DOMAIN_SPOTCHECK;
    NSString *responseKey = @"spotCheck";
    NSDictionary *param = @{@"bookId" : self.learningBookId};
    
    if (exerciseType == YXExerciseReview) {
        url = DOMAIN_REVIEWDATA;
        responseKey = @"reviewWords";
        param = @{};
    }
    [YXDataProcessCenter GET:url
                  parameters:param
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
        [YXUtils hideHUD:self.view];
        if (result) { // 成功 加载今天学习数据
            NSMutableArray *reviewWords = [YXWordQuestionModel mj_objectArrayWithKeyValuesArray:[response.responseObject objectForKey:responseKey]];
            [self receivedReviewData:reviewWords exerciseType:exerciseType];
        }else {
            [self.disperseCloudView doOpenAnimateFinishBlock:^{
                [self.curShowQuestionView didEndTransAnimated];
            }];
            [self.disperseCloudView removeFromSuperview];
        }
    }];
}

- (void)receivedReviewData:(NSMutableArray *)reviewWords exerciseType:(YXExerciseType)exerciseType {
    YXQuestionsInfo *questionsInfo = [[YXQuestionsInfo alloc] initWith:NO data:reviewWords];
    YXGroupQuestionModel *groupQuestionModel = [[YXGroupQuestionModel alloc] initWith:questionsInfo groupExeType:exerciseType];
    self.questionGenerator.groupQuestionModel = groupQuestionModel;
    
    //放云！
    self.disperseCloudView.type = exerciseType;
    self.disperseCloudView.numberOfWords = self.questionGenerator.trueQuestionsCount;
    [self.disperseCloudView doOpenAnimateWithDelay:1 finishBlock:^{
        [self.curShowQuestionView didEndTransAnimated];
    }];
    [self nextQuestion];
    self.title = [NSString stringWithFormat:@"复习 0/%zd",reviewWords.count];
//    [self nextQuestion];
}

- (void)receivedGroupQuestion:(YXGroupQuestionModel *)groupQuestionModel {
    if (groupQuestionModel.questions.isFinish) { // 答题结束
        NSLog(@"---------今天答题结束---------");
        //先显示完成页,再显示结果页
        NSInteger totalQuestions = self.planRemain;
        YXStudyAccomplishView *studyAccoumplishView = [YXStudyAccomplishView studyAccomplishShowToView:[UIApplication sharedApplication].keyWindow totalQuestionsCount:totalQuestions];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [studyAccoumplishView removeFromSuperview];
            [self showStudyResultWithType:groupQuestionModel.groupExeType];
        });
        return;
    }
    
    self.questionGenerator.groupQuestionModel = groupQuestionModel;
    
    YXGroupInfo *groupInfo = self.questionGenerator.questionGroupInfo; // 刷新组头
    self.title = [NSString stringWithFormat:@"Group %zd/%zd",groupInfo.currentGroup,groupInfo.totalGroup];

    if(self.currentGroupIndex != groupInfo.currentGroup) {
        //一组题答题结束后,放云！
        self.disperseCloudView.type = groupQuestionModel.groupExeType;
        self.disperseCloudView.numberOfWords = self.questionGenerator.trueQuestionsCount;
        if (!self.curShowQuestionView) { // 刚进入学习流程页面
            [self.disperseCloudView doOpenAnimateWithDelay:1 finishBlock:^{
                [self.curShowQuestionView didEndTransAnimated];
            }];
            [self nextQuestion];
        } else {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            // 如果答题页面存在,且当前学习单词组为0,那么就说是从复习之后开始继续学习的流程
            if (self.currentGroupIndex == 0) {

                [self.disperseCloudView doCloseAnimateShowProgress:NO closedFinishBlock:^{
                    [self nextQuestion]; // 切题
                } openFinishBlock:^{
                    [self.curShowQuestionView didEndTransAnimated];
                } doOpenWithDelay:1.f];
            } else {
                self.disperseCloudView.titleLbl.text = [NSString stringWithFormat: @"第%zd组", self.currentGroupIndex];
                [self.disperseCloudView doCloseAnimateShowProgress:YES closedFinishBlock:^{
                    [self nextQuestion]; // 切题
                } openFinishBlock:^{
                    [self.curShowQuestionView didEndTransAnimated];
                } doOpenWithDelay:3.f];
            }
        }
    }else {
         [self nextQuestion]; // 切题
    }

    self.currentGroupIndex = groupInfo.currentGroup;
}

/**
 *    普通题目按组批量上传
 *    @param isContinue 上报结果是否是中途退出，如果是中途退出不必再拉接受生成的题目
 */
- (void)studyResultReport:(BOOL)isContinue exerciseType:(YXExerciseType)exerciseType {
    if (!self.questionGenerator.isGroupHadAnsweredQuestion) { // 一题未答不上报
        return;
    }
    NSString *answerJson = self.questionGenerator.groupAnsweredJson;
    NSDictionary *param = @{ @"questions" : answerJson };
    NSString *donmain = DOMAIN_STUDYREPORT;
    
    if (exerciseType == YXExerciseWordListStudy) {
        donmain = DOMAIN_WORDLISTLEARNREPORT;
        param = @{@"questions" : answerJson , @"wordListId" : self.learningBookId};
    }else if(exerciseType == YXExerciseWordListListen) {
        donmain = DOMAIN_WORDLISTLISTENREPORT;
        param = @{@"questions" : answerJson , @"wordListId" : self.learningBookId};
    }
    
    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
    [kNotificationCenter postNotificationName:kUploadExericiseResultNotify object:nil userInfo:@{@"uploadState" : @"1"}]; // 正在上传答题结果
    [YXDataProcessCenter POST:donmain
                   modelClass:[YXGroupQuestionModel class]
                   parameters:param
                 finshedBlock:^(YRHttpResponse *response, BOOL result)
     {
        if (result && isContinue) { // 上报成功
            
            YXGroupQuestionModel *groupQuestionModel = response.responseObject;
            groupQuestionModel.groupExeType = exerciseType;
            [self receivedGroupQuestion:groupQuestionModel];
        }else {
            [self.disperseCloudView doOpenAnimate];
            [self.disperseCloudView removeFromSuperview];
        }
        [kNotificationCenter postNotificationName:kUploadExericiseResultNotify object:nil userInfo:@{@"uploadState" : @"0"}];//答题结果已上传无论网络成功失败
        [YXUtils hideHUD:self.view];
    }];
}

/** 复习题大类上报-每题上报
 *  复习题答对或打错三次及以上需上报
 *  抽查复习无论对错都要上报
 *  废弃借口
 */
//- (void)reviewResultReportWithGroupType:(YXExerciseType)groupType {
//    NSString *answerJson = self.questionGenerator.groupAnsweredJson;
//    NSDictionary *param = @{
//                            @"questions" : answerJson
//                            };
//    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
//    NSString *url = (groupType == YXExerciseReview) ? DOMAIN_REVIEWREPORT : DOMAIN_SPOTCHECKREPORT;
//    [YXDataProcessCenter POST:url
//                   parameters:param
//                 finshedBlock:^(YRHttpResponse *response, BOOL result)
//    {
//        [YXUtils hideHUD:self.view];
//        if (result) { // 复习题上报成功，学习今天单词
//            if (groupType == YXExerciseReview) {
//                [self handleGroupQuestionsDataWithExerciseType:YXExerciseNormal];
//            }else { // 抽查复习结果页
//                [self showStudyResultWithType:groupType];
//            }
//        }
//    }];
//}

/** 展示流程结果页 */
- (void)showStudyResultWithType:(YXExerciseType)studyResultType {
}

- (void)checkWordFavState:(YXWordDetailModel *)wordDetailModel {
    self.favButton.userInteractionEnabled = NO;
    if (!wordDetailModel.bookId) {
        return;
    }
    [YXDataProcessCenter GET:DOMAIN_WORDFAVSTATE parameters:@{@"wordId" : wordDetailModel.wordid,@"bookId":wordDetailModel.bookId} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            [self refreshFavState:[[response.responseObject objectForKey:@"isFav"] integerValue]];
        }
        self.favButton.userInteractionEnabled = YES;
    }];
}

- (void)releaseCurrentQuestionViewResource {
    if (self.curShowQuestionView) { // 释放上一个试图资源
        [self.curShowQuestionView releaseSource];
    }
}

#pragma mark - 答题流程
- (void)nextQuestion {
    [self releaseCurrentQuestionViewResource];

    __weak typeof(self) weakSelf = self;
    YXExerciseType groupExeType = self.questionGenerator.groupQuestionModel.groupExeType;
    [self.questionGenerator nextGeneratedQuestion:^(YXGeneratedQuestionInfo *gqInfo, CGFloat studiedProgress) {
        if (gqInfo) { // 下一题
            weakSelf.studyProgressView.progress = studiedProgress;
            if (groupExeType == YXExerciseReview || groupExeType == YXExercisePickError) { // 复习题
                self.title = [NSString stringWithFormat:@"复习 %zd/%zd",(NSInteger)(self.questionGenerator.curQuestionIndex + 1),self.questionGenerator.totalQuestionsCount];
            }
            [weakSelf refreshFavState:NO];// 切换单词重制单词状态
            [weakSelf checkWordFavState:gqInfo.wordQuestionModel.wordDetail];
            [weakSelf showQuestionView:gqInfo];
        }else { // 答题结束
            NSLog(@"----该组答题结束---------");
            weakSelf.studyProgressView.progress = 1;
            [self.curShowQuestionView endEditing:YES];
            if (groupExeType != YXExerciseReview && groupExeType != YXExercisePickError) { // 普通题目  groupExeType == YXExerciseNormal
                [weakSelf studyResultReport:YES exerciseType:groupExeType];
            }else if (groupExeType == YXExerciseReview){ // 复习题，学习普通题题目
                [self.curShowQuestionView endEditing:YES];
                
                YXReviewAccomplishView *accomplishView = [[YXReviewAccomplishView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                accomplishView.delegate = self;
                accomplishView.totalQuestionsCount = self.questionGenerator.totalQuestionsCount;
                if (self.planRemain) {
                    [accomplishView.goOnBtn setTitle:@"继 续" forState:UIControlStateNormal];
                }
                else{
                    [accomplishView.goOnBtn setTitle:@"完 成" forState:UIControlStateNormal];
                }
                [[UIApplication sharedApplication].keyWindow addSubview:accomplishView];
            }else { // 抽查复习结束，展示结果页
                [weakSelf showStudyResultWithType:YXExercisePickError];
            }
        }
    }];
}

#pragma mark -YXReviewAccomplishViewDelegate
- (void)reviewAccomplishViewBtn{
    NSLog(@"reviewAccomplishViewBtn");
    if (self.planRemain) {
        __weak typeof(self) weakSelf = self;
        [weakSelf handleGroupQuestionsDataWithExerciseType:YXExerciseNormal];
    }
    else{
        [self backToPreviousViewController];
    }
}


//显示单词页面
- (void)showQuestionView:(YXGeneratedQuestionInfo *)gqInfo {
    CGRect questionFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight);
    YXExerciseType exerciseType = self.questionGenerator.groupQuestionModel.groupExeType;
    YXQuestionBaseView *questionView = [[gqInfo.questionViewClass alloc] initWithWordQuestionModel:gqInfo.wordQuestionModel
                                                                                     andAnswerInfo:gqInfo.answeredInfo
                                                                                      exerciseType:exerciseType
                                                                                      bookOrListId:self.learningBookId];
    
    self.curShowQuestionView = questionView;
    questionView.delegate = self;
    if (!self.questionAreaView.subviews.count) {
        questionView.frame = questionFrame;
//        [questionView markStartDate];
        [self.questionAreaView addSubview:questionView];
        [questionView markStartDate]; // 显示答题界面开始计时
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.1 + 1.8) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [questionView didEndTransAnimated];
//        });
    }else {
        UIView *lastShowView = self.questionAreaView.subviews.firstObject;
        lastShowView.userInteractionEnabled = NO;
        questionView.frame = CGRectMake(SCREEN_WIDTH, 0,SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight);
        [self.questionAreaView addSubview:questionView];
        
        BOOL showMarkEndTransAnimated = YES;
        if (self.currentGroupIndex != self.questionGenerator.questionGroupInfo.currentGroup) {
            showMarkEndTransAnimated = NO;
        }
        [UIView animateWithDuration:0.25 animations:^{
            questionView.frame = questionFrame;
        } completion:^(BOOL finished) {
            [lastShowView removeFromSuperview];
            if (showMarkEndTransAnimated && !self.disperseCloudView.isShowView) {
                 [questionView didEndTransAnimated];
            }
            [questionView markStartDate]; // 显示答题界面开始计时
        }];
    }
    //V2.2  拼写题添加引导页面
    if ((gqInfo.wordQuestionModel.question.type == YXQuestionSelectPartLetters)||(gqInfo.wordQuestionModel.question.type == YXQuestionSelectFullLetters)) {
        if ([YXSpellGuideView isspellGuideShowedWith:kSpellGuidedKey]) {
            
        }else {
            if (self.questionGenerator.curQuestionIndex == 0) {
                [self performSelector:@selector(delayMethods) withObject:nil afterDelay:2.0];
            }
            else{
                [self performSelector:@selector(delayMethods) withObject:nil afterDelay:0.5];
            }
        }
    }
}

- (void)delayMethods{
    self.spellGuideView = [YXSpellGuideView spellGuideShowToView:[UIApplication sharedApplication].keyWindow delegate:self];
    self.spellGuideView.spellGuideKey = kSpellGuidedKey;
}
#pragma mark - refreshFravState
- (void)refreshFavState:(BOOL)isFav {
    self.favButton.selected = isFav;
    self.questionGenerator.curShowWordDetail.isFav = self.favButton.selected;
}

#pragma mark - <YXQuestionBaseViewDelegate ,YXSpokenViewDelegate>
- (void)spokenViewMacrophoneWasDenied:(YXQuestionBaseView *)questionBaseView {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"无法使用麦克风"
                                                                            message:@"请在iPhone的\"设置-隐私-麦克风\"中允许访问麦克风"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    
    [alerController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alerController animated:YES completion:nil];
}

- (void)spokenViewSkipCurrentGroupSpokenQuestions:(YXQuestionBaseView *)questionBaseView { // 覆盖弹框
    [self.questionGenerator skipSpokenQuestion];
    [self nextQuestion];
}

- (void)questionBaseViewNeedEnterNextQuestion:(YXQuestionBaseView *)questionBaseView {
    [self nextQuestion];
}

- (void)questionBaseViewNeedAppearWordDetailThenEnterNextQuestion:(YXQuestionBaseView *)questionBaseView {
    [self showWordDetailWithBackNextQuestion:questionBaseView.wordQuestionModel];
}

- (void)questionBaseViewNeedAppearWordDetail:(YXQuestionBaseView *)questionBaseView {
    [self showWordDetailWith:questionBaseView.wordQuestionModel withBackBlock:^{
        if ([questionBaseView isKindOfClass:[YXSpellQuestionView class]]) {
            [questionBaseView didEndTransAnimated];
        }
        else {
            [questionBaseView didEndTransAnimated];
        }
    }];
}

- (void)questionBaseViewNeedAppearWordDetailThenResetQuestion:(YXQuestionBaseView *)questionBaseView {
    __weak typeof(self) weakSelf = self;
    [self showWordDetailWith:questionBaseView.wordQuestionModel withBackBlock:^{ // 重置题目
        [weakSelf.questionGenerator resetCurrentQuestion];
        [weakSelf nextQuestion];
    }];
}

- (void)questionBaseViewNeedShowHintsAlert:(YXQuestionBaseView *)questionBaseView {
    NSString *message = @"主动查看提示会影响你对该单词的“熟练度”，AI老师推荐的学习路径也会不同！";
    UIAlertController *hintsAlert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    [hintsAlert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:hintsAlert animated:YES completion:nil];
}

#pragma mark - show word detail
- (void)showWordDetailWithBackNextQuestion:(YXWordQuestionModel *)wordQuestion {
    __weak typeof(self) weakSelf = self;
    [self showWordDetailWith:wordQuestion withBackBlock:^{
        [weakSelf nextQuestion];
    }];
}

- (void)showWordDetailWith:(YXWordQuestionModel *)wordQuestion withBackBlock:(void(^)(void))backActionBlock {
    YXWordDetailViewControllerOld *wordDetailVC = [YXWordDetailViewControllerOld wordDetailWith:wordQuestion.wordDetail
                                                                                   bookId:wordQuestion.bookId
                                                                            withBackBlock:backActionBlock];
    wordDetailVC.isFavWord = wordQuestion.wordDetail.isFav;
    wordDetailVC.isExercise = YES;
    wordDetailVC.backTitle = @"继续学习";
    [self presentViewController:wordDetailVC animated:YES completion:nil];
}

//截屏响应
//- (void)userDidTakeScreenshot:(NSNotification *)notification {
//    self.floatView.snapShoptImage = [YXUtils screenShot];
//}

#pragma mark -YXExerciseFloatViewDelegate-
- (void)exerciseFloatViewSubmmit:(YXExerciseFloatView *)floatView {
    YXPersonalFeedBackVC *pfbVC = [[YXPersonalFeedBackVC alloc] init];
    pfbVC.screenShotImage = floatView.snapShoptImage;
    [self.navigationController pushViewController:pfbVC animated:YES];
}

- (void)favStateChangeNotify:(NSNotification *)notify {
    if ([notify.object isEqual:self]) { // 自己发的通知
        return;
    }
    YXWordQuestionModel *wordQuestionModel = self.questionGenerator.curGeneratedQuestion.wordQuestionModel;
    if ([wordQuestionModel.wordId isEqualToString:[notify.userInfo objectForKey:@"wordId"]]) {
        [self refreshFavState:[[notify.userInfo objectForKey:@"fav"] integerValue]];
    }
}

- (void)favouriteWord:(UIButton *)btn {
    YXWordQuestionModel *wordQuestionModel = self.questionGenerator.curGeneratedQuestion.wordQuestionModel;
    [YXWordModelManager keepWordId:wordQuestionModel.wordId bookId:wordQuestionModel.bookId isFav:!btn.selected completeBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSDictionary *wordFavState = [response.responseObject objectForKey:@"modFav"];
            if ([wordQuestionModel.wordId isEqualToString:[wordFavState objectForKey:@"wordId"]]) {
                [self refreshFavState:[[wordFavState objectForKey:@"fav"] integerValue]];
            }
            [kNotificationCenter postNotificationName:kWordFavStateChangeNotify object: self userInfo:nil];
        }
    }];
}

- (void)reportError:(UIButton *)btn {
    NSString *questionID = self.questionGenerator.curGeneratedQuestion.wordQuestionModel.question.questionId;
//    [YXReportErrorView showToView:self.navigationController.view withQuestionId:questionID];
    [self traceEvent:kTraceQuestionReportError descributtion:questionID];
}

- (void)dealloc {
    [self releaseCurrentQuestionViewResource];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - subviews
//截屏浮动view
- (YXExerciseFloatView *)floatView {
    if (!_floatView) {
        _floatView = [[YXExerciseFloatView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _floatView.hidden = YES;
        _floatView.delegate = self;
        [self.view addSubview:self.floatView];
    }
    return _floatView;
}

- (UIView *)questionAreaView {
    if (!_questionAreaView) {
        UIView *questionAreaView = [[UIView alloc] init];
        questionAreaView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:questionAreaView];
        _questionAreaView = questionAreaView;
    }
    return _questionAreaView;
}

- (YXPinkProgressView *)studyProgressView {
    if (!_studyProgressView) {
        YXPinkProgressView *studyProgressView = [[YXPinkProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        studyProgressView.layer.shadowColor = UIColorOfHex(0x8DADD7).CGColor;
        studyProgressView.layer.shadowOffset = CGSizeMake(0, 2.5);
        studyProgressView.layer.shadowOpacity = 0.5;
        studyProgressView.layer.shadowRadius = 2.5;
        studyProgressView.progress = 0;
        [self.view addSubview:studyProgressView];
        _studyProgressView = studyProgressView;
    }
    return _studyProgressView;
}

- (void)setProgress:(CGFloat)progress {
    self.studyProgressView.progress = progress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (YXDisperseCloudView *)disperseCloudView {
    if (!_disperseCloudView) {
        CGRect frame =  [UIScreen mainScreen].bounds;
        YXDisperseCloudView *disperseCloudView = [[YXDisperseCloudView alloc] initWithFrame:frame];
        [[UIApplication sharedApplication].delegate.window addSubview:disperseCloudView];
        [[UIApplication sharedApplication].delegate.window bringSubviewToFront:disperseCloudView];
        _disperseCloudView = disperseCloudView;
    }
    return _disperseCloudView;
}









#pragma mark - XXXXXXXXXXXX before version no need to
- (void)showLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
}
 
- (void)hidenLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
}

- (void)submitBtnClicked:(id)sender {
    [self.view endEditing:YES];
    YXPersonalFeedBackVC *submitVC = [[YXPersonalFeedBackVC alloc]init];
    [self.navigationController pushViewController:submitVC animated:YES];
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

//- (void)delayShowView:(Class)cls {
//    __weak YXExerciseVC *weakSelf = self;
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [weakSelf showViewClass:cls];
//    });
//}

//- (void)animateShowWordDetailView {
//    [UIView animateWithDuration:duration animations:^{
//        self.wordDetailView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//    } completion:^(BOOL finished) {
//        if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageWrong3) {
//            self.graphSelectView.hidden = YES;
//        }
//        if ([YXStudyCmdCenter shared].answerType != wrongThreeTime) {
//            self.enTranChView.hidden = YES;
//        }
//        if ([YXStudyCmdCenter shared].answerType != YXAnswerChineseTranslationEnglishWrong3) {
//            self.chTranEnView.hidden = YES;
//        }
//        if ([YXStudyCmdCenter shared].answerType != YXAnswerWordSpellWrong3) {
//            self.spellView.hidden = YES;
//        }
//        self.completeUnitView.hidden = YES;
//        self.completeGroupView.hidden = YES;
//        self.reportBtn.hidden = NO;
//    }];
//}

//- (void)showViewClass:(Class)cls {
//    if (cls == [self.wordDetailView class]) {
//        self.wordDetailView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//        self.wordDetailView.hidden = NO;
//        __weak YXExerciseVC *weakSelf = self;
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//            [weakSelf animateShowWordDetailView];
//        });
//    } else if (cls == [self.graphSelectView class]) {
//        if (self.graphSelectView.hidden == YES) {
//            self.graphSelectView.hidden = NO;
//        }
//        self.enTranChView.hidden = YES;
//        self.chTranEnView.hidden = YES;
//        self.spellView.hidden = YES;
//        self.reportBtn.hidden = NO;
//        [self hidenCompleteUnitView];
//        [self hidenCompleteGroupView];
//        [self hidenWordDetailView];
//        if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageWrong2) {
//            self.graphSelectView.answerType = [YXStudyCmdCenter shared].answerType;
//        }
//        [YXConfigure shared].firstAppearKeyBoard = NO;
//    } else if (cls == [self.completeGroupView class]) {
//        self.completeGroupView.hidden = NO;
//        self.graphSelectView.hidden = YES;
//        self.enTranChView.hidden = YES;
//        self.chTranEnView.hidden = YES;
//        self.spellView.hidden = YES;
//        self.reportBtn.hidden = YES;
//        [self hidenCompleteUnitView];
//        [self hidenWordDetailView];
//    } else if (cls == [self.completeUnitView class] ) {
//        self.completeUnitView.hidden = NO;
//        self.graphSelectView.hidden = YES;
//        self.enTranChView.hidden = YES;
//        self.chTranEnView.hidden = YES;
//        self.spellView.hidden = YES;
//        self.reportBtn.hidden = YES;
//        [self hidenCompleteGroupView];
//        [self hidenWordDetailView];
//    } else if (cls == [self.enTranChView class]) {
//        if (self.enTranChView.hidden == YES) {
//            self.enTranChView.hidden = NO;
//        }
//        self.graphSelectView.hidden = YES;
//        self.chTranEnView.hidden = YES;
//        self.spellView.hidden = YES;
//        self.reportBtn.hidden = NO;
//        [self hidenCompleteUnitView];
//        [self hidenCompleteGroupView];
//        [self hidenWordDetailView];
//        if ([YXStudyCmdCenter shared].answerType != wrongTwice) {
//            self.enTranChView.answerType = [YXStudyCmdCenter shared].answerType;
//        }
//        [YXConfigure shared].firstAppearKeyBoard = NO;
//    }  else if (cls == [self.chTranEnView class]) {
//        if (self.chTranEnView.hidden == YES) {
//            self.chTranEnView.hidden = NO;
//        }
//        self.graphSelectView.hidden = YES;
//        self.enTranChView.hidden = YES;
//        self.spellView.hidden = YES;
//        self.reportBtn.hidden = NO;
//        [self hidenCompleteUnitView];
//        [self hidenCompleteGroupView];
//        [self hidenWordDetailView];
//        if ([YXStudyCmdCenter shared].answerType != YXAnswerChineseTranslationEnglishWrong2) {
//            self.chTranEnView.answerType = [YXStudyCmdCenter shared].answerType;
//        }
//        [YXConfigure shared].firstAppearKeyBoard = NO;
//    } else if (cls == [self.spellView class]) {
//        if (self.spellView.hidden == YES) {
//            self.spellView.hidden = NO;
//        }
//        self.graphSelectView.hidden = YES;
//        self.enTranChView.hidden = YES;
//        self.chTranEnView.hidden = YES;
//        self.reportBtn.hidden = NO;
//        [self hidenCompleteUnitView];
//        [self hidenCompleteGroupView];
//        [self hidenWordDetailView];
//        self.spellView.answerType = [YXStudyCmdCenter shared].answerType;
//    }
//}

//- (void)hidenCompleteUnitView {
//    if (self.completeUnitView.hidden == NO) {
//        [self resetProgressView];
//        [UIView animateWithDuration:duration animations:^{
//            self.completeUnitView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//        } completion:^(BOOL finished) {
//            self.completeUnitView.hidden = YES;
//            self.completeUnitView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//        }];
//    } else {
//        self.completeUnitView.hidden = YES;
//    }
//}

//- (void)hidenCompleteGroupView {
//    if (self.completeGroupView.hidden == NO) {
//        [self resetProgressView];
//        [UIView animateWithDuration:duration animations:^{
//            self.completeGroupView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//        } completion:^(BOOL finished) {
//            self.completeGroupView.hidden = YES;
//            self.completeGroupView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//        }];
//    } else {
//        self.completeGroupView.hidden = YES;
//    }
//}

//- (void)hidenWordDetailView {
//    if (self.wordDetailView.hidden == NO) {
//        [self resetProgressView];
//        self.wordDetailView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//        self.wordDetailView.hidden = YES;
//    } else {
//        self.wordDetailView.hidden = YES;
//    }
//}

//- (void)resetProgressView {
//    self.progressView.unitGroupTotal = [[YXStudyCmdCenter shared]groupNum];
//    self.progressView.unitGroupIdx = [[YXStudyCmdCenter shared]groupIndex];
//    self.progressView.unitGroupQuestionCount = [[YXStudyCmdCenter shared]groupQuestionCount]; //2
//    self.progressView.unitGroupQuestionLearnCount = [[YXStudyCmdCenter shared]groupQuestionLearnCount];
//}

#pragma mark -YXCompleteUnitViewDelegate-
- (void)backToMainPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - YXSpellGuideViewDelegate
- (void)spellGuideView:(YXSpellGuideView *)spellGuider guideStep:(NSInteger)step{
    NSLog(@"spellGuideView %ld",step);
    if (step == 3) {
        self.spellView.hidden = NO;
    }
}

@end























//- (void)showQuestionView:(YXWordQuestionModel *)wordQuestion {
//
//    YXQuestionType questionType = wordQuestion.question.type;
//
//    CGRect questionFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight);
//
//    if ([questionType isEqualToString:@"2"]) { // 根据单词选词义
//
//        YXENTranCHChoiceView *view = [[YXENTranCHChoiceView alloc] initWithFrame:questionFrame];
//        [self.questionAreaView addSubview:view];
//
//        view.wordQuestionModel = wordQuestion;
//
//        [view reloadData];
//
//    } else if ([questionType isEqualToString:@"3"]) { // 根据词义选单词
//
//        YXCHTranENChoiceView *view = [[YXCHTranENChoiceView alloc] initWithFrame:questionFrame];
//        [self.questionAreaView addSubview:view];
//
//        view.wordQuestionModel = wordQuestion;
//
//        [view reloadData];
//
//    } else if ([questionType isEqualToString:@"4"]) { // 根据词义全拼
//
//    } else if ([questionType isEqualToString:@"5"]) { // 单词的部分拼写
//
//    } else if ([questionType isEqualToString:@"6"]) { // 听发音部分拼写
//
//    } else if ([questionType isEqualToString:@"7"]) { // 听发音全拼
//
//    } else if ([questionType isEqualToString:@"8"]) { // 例句挖空
//        YXFillWordView *view = [[YXFillWordView alloc] initWithFrame:questionFrame];
//        [self.questionAreaView addSubview:view];
//
//        view.wordQuestionModel = wordQuestion;
//
//        [view reloadData];
//    }
//
//}

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView = [[YXLearnProgressView alloc]initWithFrame:CGRectMake(50, kStatusBarHeight + 15, SCREEN_WIDTH-60, 20)];
    [self.view addSubview:self.progressView];
    
    self.progressView.unitGroupTotal = [[YXStudyCmdCenter shared]groupNum];//2
    self.progressView.unitGroupIdx = 0;
    self.progressView.unitGroupQuestionCount = [[YXStudyCmdCenter shared]groupQuestionCount]; //2
    //    self.progressView.unitGroupQuestionLearnCount = 0;
    
    //    NSLog(@"%lu", (unsigned long)[YXConfigure shared].loginModel.learning.unit.count);
    //    NSLog(@"%ld", (long)self.mainToStudy.unitNum);
    //    NSLog(@"%ld", (long)self.mainToStudy.unit.word.integerValue);
    //    NSLog(@"%ld", (long)self.mainToStudy.unit.learned.integerValue);
    
    // 单词详情页面
    self.wordDetailView = [[YXWordDetailView alloc]initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight)];
    [self.view addSubview:self.wordDetailView];
    self.wordDetailView.hidden = YES;
    
    
    // 图片选择页面
    self.graphSelectView = [[YXGraphSelectView alloc]init];
    self.graphSelectView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    [self.view addSubview:self.graphSelectView];
    self.graphSelectView.hidden = YES;
    
    // 完成单元
    self.completeUnitView = [[YXCompleteUnitView alloc]init];
    self.completeUnitView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    [self.view addSubview:self.completeUnitView];
    self.completeUnitView.delegate = self;
    self.completeUnitView.hidden = YES;
    
    // 完成组
    self.completeGroupView = [[YXCompleteGroupView alloc]init];
    self.completeGroupView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    [self.view addSubview:self.completeGroupView];
    self.completeGroupView.hidden = YES;
    
    // 英译汉，
    self.enTranChView = [[YXENTranCHChoiceView alloc]init];
    self.enTranChView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    [self.view addSubview:self.enTranChView];
    self.enTranChView.hidden = YES;
    
    // 汉译英
    self.chTranEnView = [[YXCHTranENChoiceView alloc]init];
    self.chTranEnView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
    [self.view addSubview:self.chTranEnView];
    self.chTranEnView.hidden = YES;
    
    // 拼写
    self.spellView = [[YXStudySpellView alloc]init];
    self.spellView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
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
    [self.reportBtn setFrame:CGRectMake(SCREEN_WIDTH-42, kNavHeight, 26, 26)];
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
 */


//- (void)showQuestionView:(YXWordQuestionModel *)wordQuestion {
//    CGRect questionFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight);
//
//    YXQuestionBaseView *questionView = [[[self questionClass:wordQuestion] alloc] initWithWordQuestionModel:wordQuestion];
//    questionView.delegate = self;
//    [self.questionAreaView addSubview:questionView];
//    if (self.questionAreaView.subviews.count) {
//        questionView.frame = questionFrame;
//    }else {
//        questionView.frame = CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight);;
//        [UIView animateWithDuration:0.25 animations:^{
//            questionView.frame = questionFrame;
//        }];
//    }
//}
//
//- (void)createQuestionView:(YXWordQuestionModel *)wordQuestion {
//    [YXWordModelManager quardWithWordId:wordQuestion.wordId completeBlock:^(id obj, BOOL result) {
//        if (result) {
//            wordQuestion.wordDetail = obj;
//
//            [self showQuestionView:wordQuestion];
//            //            NSString *subpath = [self.learningBookId stringByAppendingPathComponent:word.curMaterialSubPath];
//            //            NSString *fullPath = [[YXUtils resourcePath] DIR:subpath];
//            //            BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
//            //            [[AVAudioPlayerManger shared] startPlay:[NSURL fileURLWithPath:fullPath]];
//        }
//    }];
//}
//
//- (Class)questionClass:(YXWordQuestionModel *)wordQuestion {
//    YXQuestionType questionType = wordQuestion.question.type;
//    switch (questionType) {
//        case YXQuestionEngTransCh:
//            return [YXENTranCHChoiceView class];
//            break;
//        case YXQuestionChTransEng:
//            return [YXCHTranENChoiceView class];
//            break;
//        case YXQuestionChToFullSpell:
//        case YXQuestionChToPartSpell:
//        case YXQuestionPronuncePartSpell:
//        case YXQuestionPronunceFullSpell:
//            return [YXENTranCHChoiceView class];
//            break;
//        case YXQuestionFillBlankWord:
//            return [YXFillWordView class];
//            break;
//        default:
//            return nil;
//            break;
//    }
//}


//- (void)initWithCmd {
//    // control commond
//    [[YXStudyCmdCenter shared]setNextQuestion:^(id obj) {
//        YXStudyBookUnitTopicModel *topicModel = obj;
//        if ([topicModel.type isEqualToString:@"1"]) {
//            self.graphSelectView.hidden = YES;
//            [YXStudyCmdCenter shared].answerType = YXAnswerSelectImageState;
//        } else if ([topicModel.type isEqualToString:@"2"]) {
//            self.enTranChView.hidden = YES;
//            [YXStudyCmdCenter shared].answerType = start;
//        } else if ([topicModel.type isEqualToString:@"3"]) {
//            self.chTranEnView.hidden = YES;
//            [YXStudyCmdCenter shared].answerType = YXAnswerChineseTranslationEnglishState;
//        } else if ([topicModel.type isEqualToString:@"4"]) {
//            self.spellView.hidden = YES;
//            [YXStudyCmdCenter shared].answerType = YXAnswerWordSpellState;
//        }
//    }];
//
//    [[YXStudyCmdCenter shared]setNextWord:^(id obj) {
//        YXStudyBookUnitTopicModel *topicModel = obj;
//        if ([topicModel.type isEqualToString:@"1"]) {
//            [YXStudyCmdCenter shared].answerType = YXAnswerSelectImageState;
//        } else if ([topicModel.type isEqualToString:@"2"]) {
//            [YXStudyCmdCenter shared].answerType = start;
//        } else if ([topicModel.type isEqualToString:@"3"]) {
//            [YXStudyCmdCenter shared].answerType = YXAnswerChineseTranslationEnglishState;
//        } else if ([topicModel.type isEqualToString:@"4"]) {
//            [YXStudyCmdCenter shared].answerType = YXAnswerWordSpellState;
//        }
//    }];
//
//    [[YXStudyCmdCenter shared]setNextGroup:^(id obj) { // 进入下一组
//        [YXStudyCmdCenter shared].answerType = YXAnswerNextGroup;
//    }];
//
//    [[YXStudyCmdCenter shared]setNextUnit:^(id obj) {
//        [YXStudyCmdCenter shared].answerType = YXAnswerNextUnit;
//    }];
//
//    [[YXStudyCmdCenter shared]setShowTipView:^(id obj) {
//        [self showLeftBarButtonItem];
//        NSNumber *num = obj;
//        switch (num.integerValue) {
//            case YXAnswerSelectImageState:
//                [self showViewClass:[self.graphSelectView class]];
//                break;
//            case YXAnswerSelectImageWrong1:
//                [self showViewClass:[self.graphSelectView class]];
//                break;
//            case YXAnswerSelectImageWrong2:
//                [self showViewClass:[self.graphSelectView class]];
//                break;
//            case YXAnswerSelectImageWrong3:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//            case YXAnswerSelectImageRight:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//
//                // 英译汉
//            case start:
//                [self showViewClass:[self.enTranChView class]];
//                break;
//            case wrongOnce:
//                [self showViewClass:[self.enTranChView class]];
//                break;
//            case wrongTwice:
//                [self showViewClass:[self.enTranChView class]];
//                break;
//            case wrongThreeTime:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//            case right:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//
//                // 汉译英
//            case YXAnswerChineseTranslationEnglishState:
//                [self showViewClass:[self.chTranEnView class]];
//                break;
//            case YXAnswerChineseTranslationEnglishWrong1:
//                [self showViewClass:[self.chTranEnView class]];
//                break;
//            case YXAnswerChineseTranslationEnglishWrong2:
//                [self showViewClass:[self.chTranEnView class]];
//                break;
//            case YXAnswerChineseTranslationEnglishWrong3:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//            case YXAnswerChineseTranslationEnglishRight:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//
//                // 单词拼写
//            case YXAnswerWordSpellState:
//                [self showViewClass:[self.spellView class]];
//                break;
//            case YXAnswerWordSpellWrong1:
//                [self showViewClass:[self.spellView class]];
//                break;
//            case YXAnswerWordSpellWrong2:
//                [self showViewClass:[self.spellView class]];
//                break;
//            case YXAnswerWordSpellWrong3:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//            case YXAnswerWordSpellRight:
//                [self delayShowView:[self.wordDetailView class]];
//                break;
//
//                // 下一组
//            case YXAnswerNextGroup:
//                [self showViewClass:[self.completeGroupView class]];
//                break;
//            case YXAnswerNextUnit:
//                [self hidenLeftBarButtonItem];
//                [self showViewClass:[self.completeUnitView class]];
//                break;
//            default:
//                break;
//        }
//    }];
//    // 初始化数据
//    [[YXStudyCmdCenter shared]currentUnitInfo:[YXConfigure shared].bookUnitModel];
//}


//[self.view bringSubviewToFront:self.completeGroupView];
//[self.view bringSubviewToFront:self.completeUnitView];
//[self.view bringSubviewToFront:self.wordDetailView];
//
//if ((self.unitModel.learned.integerValue != self.unitModel.word.integerValue && self.unitModel.q_idx.integerValue > 0) || (self.unitModel.learn_status.integerValue && self.unitModel.q_idx.integerValue == 0)) {
//    [YXConfigure shared].isNeedPlayAudio = NO;
//    [[YXStudyCmdCenter shared]lastStudyPosition];
//    [YXConfigure shared].isNeedPlayAudio = YES;
//    [YXComAlertView showAlert:YXAlertStudySelect inView:[UIApplication sharedApplication].keyWindow info:[NSString stringWithFormat:@"上次已学到本单元第%ld组是否继续学习?",(long)[YXStudyCmdCenter shared].groupIndex+1] content:nil firstBlock:^(id obj) { // 重新开始
//        [[YXStudyCmdCenter shared]startTopic];
//        [self resetProgressView];
//    } secondBlock:^(id obj) { // 继续学习
//        [[YXStudyCmdCenter shared]startContinue];
//        [self resetProgressView];
//    }];
//} else { // 重新开始
//    [YXConfigure shared].isNeedPlayAudio = YES;
//    [[YXStudyCmdCenter shared]startTopic];
//}
//
//self.reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//[self.reportBtn setExclusiveTouch:YES];
//[self.reportBtn setFrame:CGRectMake(SCREEN_WIDTH-42, kNavHeight, 26, 26)];
//[self.reportBtn setBackgroundColor:[UIColor clearColor]];
//[self.reportBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
//[self.reportBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//[self.reportBtn setBackgroundImage:[UIImage imageNamed:@"study_feed_btn"] forState:UIControlStateNormal];
//[self.view addSubview:self.reportBtn];
//
//// 提交View
//self.submitView = [[YXExerciseSubmitErrorView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//self.submitView.hidden = YES;
//[self.view addSubview:self.submitView];
//
//// 漂浮窗口
//self.floatView = [[YXExerciseFloatView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//self.floatView.hidden = YES;
//self.floatView.delegate = self;
//[self.view addSubview:self.floatView];


//AFHTTPSessionManager *afmanager =  [AFHTTPSessionManager manager];
//afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json",@"audio/x-wav", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
//[afmanager POST:@"https://test-en2.171xue.com/index.php/Lemur/uploadFileV2" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.filePath] name:@"pic" error:nil];
//} progress:^(NSProgress * _Nonnull uploadProgress) {
//    NSLog(@".......%@",uploadProgress);
//} success:^(NSURLSessionDataTask *task, id responseObject) {
//    NSString *callbackMessage = [NSString stringWithFormat:@"%@('%@')", self.callback,  [self stringWithDict:responseObject]];
//    [self.jsBridge.webView evaluateJavaScript:callbackMessage completionHandler:^(id _Nullable tmp, NSError * _Nullable error) {
//        NSLog(@"回调函数结果: %@, %@", error, tmp);
//    }];
//    NSLog(@"上传成功.%@",responseObject);
//} failure:^(NSURLSessionDataTask *task, NSError *error) {
//    NSLog(@"上传失败.%@",error.userInfo);
//}];

//    AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager POST:DOMAIN_STUDYREPORT parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];



//- (void)back {
//    [super back];
//    [[YXStudyRecordCenter shared]createPackage:^(id obj, BOOL result) {}]; // 点击返回打包
//}


//- (void)getPickErrorQuestion {
//    [YXDataProcessCenter GET:DOMAIN_SPOTCHECK parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
//        if (result) { // 成功 加载今天学习数据
//            NSMutableArray *reviewWords = [YXWordQuestionModel mj_objectArrayWithKeyValuesArray:[response.responseObject objectForKey:@"spotCheck"]];
//            [self receivedReviewData:reviewWords];
//        }
//    }];
//}
//
//- (void)getReviewData {
//    [YXDataProcessCenter GET:DOMAIN_REVIEWDATA parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
//        if (result) { // 成功 加载今天学习数据
//            NSMutableArray *reviewWords = [YXWordQuestionModel mj_objectArrayWithKeyValuesArray:[response.responseObject objectForKey:@"reviewWords"]];
//            [self receivedReviewData:reviewWords];
//        }
//    }];
//}


//- (void)reviewResultReport {
//    NSString *answerJson = self.questionGenerator.groupAnsweredJson;
//    NSDictionary *param = @{
//                            @"questions" : answerJson
//                            };
//    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
//    [YXDataProcessCenter POST:DOMAIN_REVIEWREPORT parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
//        if (result) { // 复习题上报成功，学习今天单词
//            [self getLearningquestion];
//        }
//        [YXUtils hideHUD:self.view];
//    }];
//}

//- (void)back {
//    if(_questionGenerator) { // 为初始化题目生成器
//        YXExerciseType groupType = _questionGenerator.groupQuestionModel.groupExeType;
//        if(groupType == YXExercisePickError) {
//            [self reviewResultReportWithGroupType:YXExercisePickError];
//        }else {
//            [YXComAlertView showAlert:YXAlertCommon inView:self.navigationController.view info:@"提示" content:@"是否确认退出本次学习流程？" firstBlock:^(id obj) {
//                groupType ? [self reviewResultReportWithGroupType:YXExerciseReview] : [self studyResultReport];
//                [self.navigationController popViewControllerAnimated:YES];
//            } secondBlock:^(id obj) {
//            }];
//        }
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
