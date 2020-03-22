//
//  YXQuestionGenerator.m
//  YXEDU
//
//  Created by yao on 2018/11/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXQuestionGenerator.h"

@implementation YXGeneratedQuestionInfo
- (instancetype)initWithWordQuestionModel:(YXWordQuestionModel *)wordQuestionModel {
    if (self = [super init]) {
        self.answeredInfo = [[YXAnsweredInfo alloc] init];
        self.wordQuestionModel = wordQuestionModel;
        self.questionViewClass = [self questionClass:self.wordQuestionModel.question.type];
//        YXEventLog(@"题型：%ld",self.wordQuestionModel.question.type);
        self.answeredInfo.bookId = wordQuestionModel.bookId;
        self.answeredInfo.wordId = wordQuestionModel.wordId;
        self.answeredInfo.questionId = wordQuestionModel.question.questionId;
        self.answeredInfo.questionType = [NSString stringWithFormat:@"%zd",wordQuestionModel.question.type];
//        self.answeredInfo.isAnswer = !wordQuestionModel.end;
    }
    return self;
}

- (instancetype)initWithSpokenQuestionModel:(YXWordQuestionModel *)wordQuestionModel {
    YXGeneratedQuestionInfo *gqIndfo = [self initWithWordQuestionModel:wordQuestionModel];
    gqIndfo.questionViewClass = [YXSpokenView class];
    return gqIndfo;
}

- (BOOL)isAnswer {
    return self.answeredInfo.isAnswer;
}
- (Class)questionClass:(YXQuestionType )questionType {
    switch (questionType) {
        case YXQuestionEngTransCh:
            return [YXENTranCHChoiceView class];
            break;
        case YXQuestionChTransEng:
            return [YXCHTranENChoiceView class];
            break;
        case YXQuestionChToFullSpell:
        case YXQuestionChToPartSpell:
        case YXQuestionPronuncePartSpell:
        case YXQuestionPronunceFullSpell:
            return [YXSpellQuestionView class];
            break;
        case YXQuestionFillBlankWord:
            return [YXFillWordView class];
            break;
        case YXQuestionSelectPartLetters:
        case YXQuestionSelectFullLetters:
            return [YXSelectLettersQuestionView class];
            break;
        default:
            return nil;
            break;
    }
}

@end


/*-----------------------------------------------------------------------------------------*/

@implementation YXStudyProgressInfo
- (instancetype)initWithTotalCount:(NSInteger)totalCount curIndex:(NSInteger)curIndex {
    if (self = [super init]) {
        self.totalCount = totalCount;
        self.curIndex = curIndex;
    }
    return self;
}

- (CGFloat)progress {
    return 1.0 * _curIndex / _totalCount;
}

- (CGFloat)questionNumber {
    return _curIndex + 1;
}
@end

/*------------------------------------分割线------------------------------------------------*/






#pragma mark - YXQuestionGenerator

@interface YXQuestionGenerator ()
@property (nonatomic, strong)NSMutableArray *trueQuestionInfos;
@property (nonatomic, strong)NSMutableArray *allQuestionInfos;
@property (nonatomic, strong)NSMutableArray *spokenQuestions;
//@property (nonatomic, assign)NSInteger leftSpokenQuestionNum;
@end

@implementation YXQuestionGenerator
{
    YXGeneratedQuestionInfo *_curGeneratedQuestion;
    NSInteger _curQuestionIndex;
    NSInteger _totalQuestionsCount;
    NSArray *_curGroupQuestionIds;
}

- (instancetype)init {
    if (self = [super init]) {
        _curQuestionIndex = -1;
    }
    return self;
}

- (void)skipSpokenQuestion {
    _curQuestionIndex = self.spokenQuestions.count - 1;
}

- (void)resetCurrentQuestion {
    [self.trueQuestionInfos removeObject:_curGeneratedQuestion];
    [self.trueQuestionInfos addObject:_curGeneratedQuestion];
    _curQuestionIndex--;
}

- (void)nextGeneratedQuestion:(GeneratedQuestionBlock)gqBlock {
    _curQuestionIndex ++;
    NSInteger nextNormalQuestionIndex;
    if (_curQuestionIndex < self.spokenQuestions.count) { // 生成口语题
        YXGeneratedQuestionInfo *gqInfo = [self.spokenQuestions objectAtIndex:_curQuestionIndex];
        [self quaryWordWith:gqInfo GQBlock:gqBlock isSpoken:YES questionIndex:_curQuestionIndex];
        return;
    }else { // 口语题做完
        nextNormalQuestionIndex = _curQuestionIndex - self.spokenQuestions.count; // 默认普通题第一题
    }

    if (nextNormalQuestionIndex < self.trueQuestionInfos.count) {
        YXGeneratedQuestionInfo *gqInfo = [self.trueQuestionInfos objectAtIndex:nextNormalQuestionIndex];
        [self quaryWordWith:gqInfo GQBlock:gqBlock isSpoken:NO questionIndex:nextNormalQuestionIndex];
    }else { // 提交该组答题结果
        gqBlock(nil,1);
    }
}

- (void)quaryWordWith:(YXGeneratedQuestionInfo *)gqInfo
              GQBlock:(GeneratedQuestionBlock)gqBlock
             isSpoken:(BOOL)isSpoken
        questionIndex:(NSInteger)questionIndex
{
    [YXWordModelManager quardWithWordId:gqInfo.wordQuestionModel.wordId completeBlock:^(id obj, BOOL result) {
        if (result) {
            gqInfo.wordQuestionModel.wordDetail = obj;
        }
        
        _curGeneratedQuestion = gqInfo;
        NSInteger totalCount = isSpoken ? self.spokenQuestions.count : self.trueQuestionInfos.count;
        _totalQuestionsCount = totalCount;
        CGFloat answeredProgress = 1.0 * (questionIndex) / totalCount;
        gqBlock(gqInfo , answeredProgress);
    }];
}

- (BOOL)isGroupHadAnsweredQuestion { // 判断当前组是否答过题
    return self.curGeneratedQuestion.isAnswer || self.curQuestionIndex > 0;
}

- (YXGroupInfo *)questionGroupInfo {
    return self.groupQuestionModel.groupInfo;
}

- (NSInteger)trueQuestionsCount {
    return self.trueQuestionInfos.count;
}

- (void)setGroupQuestionModel:(YXGroupQuestionModel *)groupQuestionModel {
    _groupQuestionModel = groupQuestionModel;
    [self filterQuestions];
    _curGeneratedQuestion = nil;
    _curQuestionIndex = -1;
}

- (void)filterQuestions {
    if (self.trueQuestionInfos.count) {
        [self.trueQuestionInfos removeAllObjects];
    }
    
    if (self.allQuestionInfos.count) {
        [self.allQuestionInfos removeAllObjects];
    }
    
    if (self.spokenQuestions.count) {
        [self.spokenQuestions removeAllObjects];
    }
    // 生成口语题，和普通题目
//    YXExerciseType groupExeType = self.groupQuestionModel.groupExeType;

    for (YXWordQuestionModel *wqm in self.groupQuestionModel.questions.data) {
        if ([wqm.speakStatus integerValue] == 1 ) {  //&& groupExeType == YXExerciseNormal (此条件可以不加)  // 口语题未完成，先生成口语题
            YXGeneratedQuestionInfo *questionsInfo = [[YXGeneratedQuestionInfo alloc] initWithSpokenQuestionModel:wqm];
            [self.spokenQuestions addObject:questionsInfo];
        }
        /*  测试题目UI开关
         wqm.question.type = YXQuestionPronuncePartSpell;
         */
        YXGeneratedQuestionInfo *questionsInfo = [[YXGeneratedQuestionInfo alloc] initWithWordQuestionModel:wqm];
        [self.allQuestionInfos addObject:questionsInfo]; // 所有题目信息
        if (!wqm.end) { // 真题 // 复习题默未结束
            [self.trueQuestionInfos addObject:questionsInfo];
        }
    }
}

- (NSString *)groupAnsweredJson {
    return [[self groupAnsweredInfos] mj_JSONString];
}
- (NSMutableArray *)groupAnsweredInfos {
    NSMutableArray *groupAnsweredInfos = [NSMutableArray array];
    for (YXGeneratedQuestionInfo *gqInfo in self.allQuestionInfos) {
        NSDictionary *ansersDic = [gqInfo.answeredInfo answerInfoDic];
        [groupAnsweredInfos addObject:ansersDic];
    }
    return groupAnsweredInfos;
}

- (YXWordDetailModel *)curShowWordDetail {
    return _curGeneratedQuestion.wordQuestionModel.wordDetail;
}

- (NSMutableArray *)allQuestionInfos {
    if (!_allQuestionInfos) {
        _allQuestionInfos = [NSMutableArray array];
    }
    return _allQuestionInfos;
}

- (NSMutableArray *)trueQuestionInfos {
    if (!_trueQuestionInfos) {
        _trueQuestionInfos = [NSMutableArray array];
    }
    return _trueQuestionInfos;
}

- (NSMutableArray *)spokenQuestions {
    if (!_spokenQuestions) {
        _spokenQuestions = [NSMutableArray array];
    }
    return _spokenQuestions;
}

@end

