//
//  YXQuestionGenerator.h
//  YXEDU
//
//  Created by yao on 2018/11/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXGroupQuestionModel.h"
#import "YXQuestionBaseView.h"
#import "YXENTranCHChoiceView.h"
#import "YXCHTranENChoiceView.h"
#import "YXFillWordView.h"
#import "YXWordModelManager.h"
#import "YXAnsweredInfo.h"
#import "YXSpellQuestionView.h"
#import "YXSpokenView.h"
#import "YXSelectLettersQuestionView.h"

@class YXGeneratedQuestionInfo;
@class YXStudyProgressInfo;
typedef void(^GeneratedQuestionBlock)(YXGeneratedQuestionInfo *gqInfo,CGFloat studiedProgress);

@interface YXGeneratedQuestionInfo : NSObject
@property (nonatomic, strong)Class questionViewClass;
@property (nonatomic, strong)YXWordQuestionModel *wordQuestionModel;
@property (nonatomic, strong)YXAnsweredInfo *answeredInfo;
@property (nonatomic, assign)BOOL isAnswer;
- (instancetype)initWithWordQuestionModel:(YXWordQuestionModel *)wordQuestionModel;
- (instancetype)initWithSpokenQuestionModel:(YXWordQuestionModel *)wordQuestionModel;
@end



@interface YXStudyProgressInfo : NSObject
@property (nonatomic, assign)NSInteger curIndex;
@property (nonatomic, assign)NSInteger totalCount;
@property (nonatomic, readonly,assign)CGFloat answeredProgress;
@property (nonatomic, readonly,assign)CGFloat questionNumber;
- (instancetype)initWithTotalCount:(NSInteger)totalCount curIndex:(NSInteger) curIndex;
@end




@interface YXQuestionGenerator : NSObject
@property (nonatomic, strong) YXGroupQuestionModel *groupQuestionModel;

@property (nonatomic, readonly, strong)YXGeneratedQuestionInfo *curGeneratedQuestion;
@property (nonatomic, readonly, strong)YXWordDetailModel *curShowWordDetail;
@property (nonatomic, readonly, strong)YXGroupInfo *questionGroupInfo;
@property (nonatomic, readonly, assign)NSInteger curQuestionIndex;
@property (nonatomic, readonly, assign)NSInteger totalQuestionsCount;

@property (nonatomic, readonly, assign)NSInteger trueQuestionsCount;

@property (nonatomic, readonly, strong)NSMutableArray *groupAnsweredInfos;
@property (nonatomic, readonly, strong)NSString *groupAnsweredJson;

@property (nonatomic, readonly,assign , getter = isGroupHadAnsweredQuestion)BOOL groupHadAnsweredQuestion;
//- (YXGeneratedQuestionInfo *)nextGeneratedQuestion;
- (void)nextGeneratedQuestion:(_Nonnull GeneratedQuestionBlock)gqBlock;

//- (void)answeredAQuestion:(NSDictionary *)answerInfo;
- (void)skipSpokenQuestion;
- (void)resetCurrentQuestion;// 主要对复习题
@end

