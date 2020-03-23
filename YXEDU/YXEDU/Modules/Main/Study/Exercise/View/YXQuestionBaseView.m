//
//  YXQuestionBaseView.m
//  YXEDU
//
//  Created by yao on 2018/11/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXQuestionBaseView.h"
#import "AVAudioPlayerManger.h"
#import "YXRemotePlayer.h"
@interface YXQuestionBaseView ()
@property (nonatomic, strong)NSDate *startDate;
@property (nonatomic, strong)NSDate *endDate;
@property (nonatomic, strong)NSDate *lastAnswerDate;

@property (nonatomic, strong)NSDate *watchWordDetailStartDate;
@property (nonatomic, strong)NSDate *watchWordDetailEndDate;
@property (nonatomic, assign)NSInteger scantime;

@property (nonatomic, strong)YXRemotePlayer *remotePlayer;
@property (nonatomic ,copy) NSString *bookOrListId;
@end

@implementation YXQuestionBaseView
{
    YXWordQuestionModel *_wordQuestionModel;
    int _wrongTimes;
    YXAnsweredInfo *_answerInfo;
    YXExerciseType _exerciseType;
    UIView *_headerView;
    BOOL _canCheckAnswer;
}

#pragma mark - 题型归类
- (BOOL)isGroupQuestionType {
    return  self.exerciseType == YXExerciseNormal ||
            self.exerciseType == YXExerciseWordListStudy ||
            self.exerciseType == YXExerciseWordListListen;
}

- (BOOL)isReviewOrPickErrorType {
    return ((self.exerciseType == YXExerciseReview) || (self.exerciseType == YXExercisePickError));
}

-  (instancetype)initWithWordQuestionModel:(YXWordQuestionModel *)wordQuestionModel
                             andAnswerInfo:(YXAnsweredInfo *)answerInfo
                                exerciseType:(YXExerciseType)exerciseType
                              bookOrListId:(NSString *)bookOrListId
{
    if (self = [super init]) {
        _scantime = 0;
        _canCheckAnswer = YES;
        self.backgroundColor = [UIColor whiteColor];
        _wordQuestionModel = wordQuestionModel;
        _answerInfo = answerInfo;
        _exerciseType = exerciseType;
        self.bookOrListId = bookOrListId;
        [self setUpSubviews];
        [self reloadData];
    }
    return self;
}

- (void)setUpSubviews {
    self.backgroundColor = UIColorOfHex(0xf6f8fa);
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_headerView];
    }
    return _headerView;
}

-(void)reloadData {
    
}

- (YXWordDetailModel *)wordDetailModel {
    return self.wordQuestionModel.wordDetail;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.canCheckAnswer) {
        return [super hitTest:point withEvent:event];
    }else {
        return nil;
    }
}
#pragma mark - answer question
- (void)answerRight {
    [self markEndDate]; // 答对结束
    _canCheckAnswer = NO;
    [self addAnswerRecord:YES]; //答题记录
    [self answerRightSound];
    if([self isReviewOrPickErrorType]) { // 复习题上报 //self.exerciseType != YXExerciseNormal
        [self currentReviewQuestionShouldReport];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AVAudioPlayerManger shared] stopPlayTipsSoundType:TipsSoundRight
         ];
        [self answerRightSoundFinished];

        _canCheckAnswer = YES;
        if (![self isReviewOrPickErrorType]) {
            [self normalQuestionAnswerRight];
        }else {
            [self reviewQuestionAnswerRight];
        }
    });
    
    [self traceEvent:kTraceAnswerQuestion descributtion:nil];
}

- (void)normalQuestionAnswerRight {
    if (self.wrongTimes) { // 打错过
        if (self.wrongTimes + 1 <= self.maxHints) { //在最大提示次数之内答对题目要进详情页
            if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedAppearWordDetailThenEnterNextQuestion:)]) {
                [self.delegate questionBaseViewNeedAppearWordDetailThenEnterNextQuestion:self];
            }
            return;
        }
    }
    
    // 一次答对 & 超过最大提示次数答对
    if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedEnterNextQuestion:)]) {
        [self.delegate questionBaseViewNeedEnterNextQuestion:self];
    }
}

- (void)reviewQuestionAnswerRight { // 复习题主要用来切题,只要是复习题答对直接进入下一题
    if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedEnterNextQuestion:)]) {
        [self.delegate questionBaseViewNeedEnterNextQuestion:self];
    }
}

- (void)answerWorng {
    [self addAnWrongAnswerRecord];
    _canCheckAnswer = NO;
    [self answerWrongSound];
    
    if ([self isReviewOrPickErrorType]) {// 复习题上报
        if (self.wordQuestionModel.answeredCount > 2 || self.exerciseType == YXExercisePickError) {
            [self currentReviewQuestionShouldReport];
        }
    }
    
    if (![self isReviewOrPickErrorType]) { //  常规类型题目
        [self showNormalQuestionWrongHints];
    }
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AVAudioPlayerManger shared] stopPlayTipsSoundType:TipsSoundWrong];
        _canCheckAnswer = YES;
        [self answerWrongSoundFinished];
        if ([self isReviewOrPickErrorType]) { //复习题答错
            [self reviewQuestionAnswerWrong];
        }
    });
}

- (void)addAnWrongAnswerRecord {
//    if (_wrongTimes < 3) {
    _wrongTimes ++;
//    }
    [self addAnswerRecord:NO];
}

- (void)showNormalQuestionWrongHints {
    if (_wrongTimes == 1) {
        [self firstTimeAnswerWorng];
    }else if(_wrongTimes == 2) {
        [self secondTimeAnswerWorng];
    }else if(_wrongTimes == 3) {
        [self thirdTimeAnswerWorng];
    }
    
    if (_wrongTimes > 2) {
        [self showWordDetail];
    }
}

- (void)reviewQuestionAnswerWrong { // 抽查复习答错直接进入下一题,复习题答对或打错三次
    if (self.exerciseType == YXExercisePickError || self.wordQuestionModel.answeredCount > 3 ) {//修复缺陷 ID1007069
        if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedEnterNextQuestion:)]) {
            [self.delegate questionBaseViewNeedEnterNextQuestion:self];
        }
    }else { // 复习题答错不超过两次
        if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedAppearWordDetailThenResetQuestion:)]) {
            [self.delegate questionBaseViewNeedAppearWordDetailThenResetQuestion:self];
        }
    }
}

- (void)addAnswerRecord:(BOOL)isRight {
    YXPerAnswer *pAnswer = [self generatedAnAnswerRecord:isRight];
    [self.answerInfo.question addObject:pAnswer];
    self.answerInfo.isAnswer = YES;
    self.wordQuestionModel.answeredCount = self.answerInfo.question.count;
//    self.answerInfo.answeredCount = self.answerInfo.question.count;
    _lastAnswerDate = [NSDate date];
}

- (YXPerAnswer *)generatedAnAnswerRecord:(BOOL)isRight {
    NSInteger learnTime = [[NSDate date] timeIntervalSinceDate:_lastAnswerDate];
    YXPerAnswer *pAnswer = [YXPerAnswer anwerWithQuestionTip:_wrongTimes learnTime:learnTime scanTime:_scantime isRight:isRight];
//    YXPerAnswer *pAnswer = [YXPerAnswer anwerWithQuestionTip:_wrongTimes learnTime:learnTime scisRight:isRight];
    return pAnswer;
}

- (void)firstTimeAnswerWorng {
    
}

- (void)secondTimeAnswerWorng {

}

- (void)thirdTimeAnswerWorng {
    
}

- (void)showWordDetail {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showWordDetailImmediately];
    });
}

- (void)showWordDetailImmediately {
    YXEventLog(@"进入单词详情");
    self.watchWordDetailStartDate = [NSDate date];
    if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedAppearWordDetail:)]) {
        [self.delegate questionBaseViewNeedAppearWordDetail:self];
    }
}

- (NSInteger)maxHints {
    return 3;
}
#pragma mark - 释放播放器
- (void)releaseSource {
    if (self.remotePlayer) {
        [self.remotePlayer releaseSource];
        self.remotePlayer = nil;
    }
}
#pragma mark -  播放音频
- (void)playWordSound {
    NSString *subpath = [self.wordQuestionModel.bookId stringByAppendingPathComponent:self.wordQuestionModel.wordDetail.curMaterialSubPath];
    NSString *fullPath = [[YXUtils resourcePath] DIR:subpath];
    __weak typeof(self) weakSelf = self;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [[AVAudioPlayerManger shared] startPlay:[NSURL fileURLWithPath:fullPath] finish:^(BOOL isSuccess) {
            [weakSelf wordSoundPlayFinished];
        }];
    }else { // 没有本地资源，只能播放远程音频
        [self playRemoteVoice];
    }
    
    [self tracePlayWordSound];
}

- (void)playRemoteVoice {
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self title:@"网络错误"];
//        return;
    }
    
    if (self.remotePlayer) {
        [self.remotePlayer play];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *dir = [YXConfigure shared].isUsStyle ? self.wordDetailModel.usvoice : self.wordDetailModel.ukvoice;
    NSString *remoteSource = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.cdn,dir];
    self.remotePlayer = [[YXRemotePlayer alloc] init];
    [self.remotePlayer startPlay:[NSURL URLWithString:remoteSource] finish:^(BOOL isSuccess) {
        [weakSelf wordSoundPlayFinished];// 结束播放
    }];
    YXEventLog(@"本地不存在音频文件，播放链接");
}


- (void)wordSoundPlayFinished {
    
}

- (void)answerRightSound {
    [self answerRightSound:nil];
}

- (void)answerRightSound:(void (^)(BOOL isFinish))playFinishBlock {
    [[AVAudioPlayerManger shared] playTipsSoundType:TipsSoundRight playFinishBlock:nil];
}

- (void)answerWrongSound {  //    [self answerWrongSoundfinish:nil];
//    YXEventLog(@">>>开始播放单词->%@的错误提示音",self.wordQuestionModel.wordDetail.word);
    [self answerWrongSoundfinish:nil];
}

- (void)answerWrongSoundfinish:(void (^)(BOOL isFinish))playFinishBlock {
    [[AVAudioPlayerManger shared] playTipsSoundType:TipsSoundWrong playFinishBlock:nil];
}

- (void)answerRightSoundFinished {
    
}

-(void)answerWrongSoundFinished {
    
}

#pragma mark - 计时
- (void)markStartDate {
    self.startDate = [NSDate date];
    self.lastAnswerDate = self.startDate;
    self.answerInfo.learnStart = [NSString stringWithFormat:@"%.f",[self.startDate timeIntervalSince1970]];
}

- (void)markEndDate {
    self.endDate = [NSDate date];
    self.answerInfo.learnFinish = [NSString stringWithFormat:@"%.f",[self.endDate timeIntervalSince1970]];
}

- (void)didEndTransAnimated {
    
    if (self.watchWordDetailStartDate){
        self.watchWordDetailEndDate = [NSDate date];
        _scantime = _scantime + [self.watchWordDetailEndDate timeIntervalSinceDate:self.watchWordDetailStartDate];
        self.watchWordDetailStartDate = nil;
        self.watchWordDetailEndDate = nil;
    }
    
}


#pragma mark - 复习题上报
/** 复习题大类上报-每题上报 <注意上报和切题逻辑不相关并行>
 *  复习题答对或打错三次及以上需上报
 *  抽查复习无论对错都要上报
 */
- (void)currentReviewQuestionShouldReport { // 复习题
    NSArray *ansers = @[[self.answerInfo answerInfoDic]];
    NSString *answerJson = [ansers mj_JSONString];
    NSDictionary *param = @{ @"questions" : answerJson };
    NSString *url = (self.exerciseType == YXExerciseReview) ? DOMAIN_REVIEWREPORT : DOMAIN_SPOTCHECKREPORT;
    [YXDataProcessCenter POST:url parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 成功失败都进入下一题
        }
    }];
}


#pragma mark - 埋点
- (void)traceEvent:(NSString *)eventId descributtion:(NSString *)desc {
    if (!desc) {
        desc = @"";
    }
    NSString *questionID = self.wordQuestionModel.question.questionId;
    NSString *quesViewName = NSStringFromClass([self class]);
    [MobClick event:eventId attributes:@{
                                         kTraceQuestionViewNameKey   : quesViewName,
                                         kTraceExerciseKey           : [self exerciseTypeStr],
                                         kTraceDescKey               : desc,
                                         kTraceQuestionIDKey         : questionID
                                         }];
}

- (void)tracePlayWordSound {
    [self traceEvent:kTracePlayWordSound descributtion:kPlayWordVoiceDesc];
}


- (NSString *)exerciseTypeStr {
    NSString *type = @"";
    if (self.exerciseType == YXExerciseNormal) {
        type = kExerciseNormal;
    }else if(self.exerciseType == YXExerciseReview) {
        type = kExerciseReview;
    }else if(self.exerciseType == YXExercisePickError) {
        type = kExercisePickError;
    }else if(self.exerciseType == YXExerciseWordListStudy) {
        type = kExerciseWordListStudy;
    }else  {
        type = kExerciseWordListListen;
    }
    return type;
}

- (void)dealloc {
    
}
@end



