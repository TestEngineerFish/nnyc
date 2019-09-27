//
//  YXQuestionBaseView.h
//  YXEDU
//
//  Created by yao on 2018/11/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXStudyCmdCenter.h"
#import "YXWordQuestionModel.h"
#import "YXCheckButtonsView.h"
#import "YXAudioAnimations.h"
#import "YXAnsweredInfo.h"
#import "YXStudyModulHeader.h"
@class YXQuestionBaseView;
@protocol YXQuestionBaseViewDelegate <NSObject>
@optional
- (void)questionBaseViewNeedAppearWordDetail:(YXQuestionBaseView *)questionBaseView;
- (void)questionBaseViewNeedEnterNextQuestion:(YXQuestionBaseView *)questionBaseView;
- (void)questionBaseViewNeedAppearWordDetailThenEnterNextQuestion:(YXQuestionBaseView *)questionBaseView;

//- (void)questionBaseViewNeedReportResultThenEnterNextQuestion:(YXQuestionBaseView *)questionBaseView;
- (void)questionBaseViewNeedAppearWordDetailThenResetQuestion:(YXQuestionBaseView *)questionBaseView;
- (void)questionBaseViewNeedShowHintsAlert:(YXQuestionBaseView *)questionBaseView;
@end

//问题页面
@interface YXQuestionBaseView : UIView
@property (nonatomic, weak) id<YXQuestionBaseViewDelegate> delegate;
@property (nonatomic, readonly ,strong) UIView *headerView;
@property (nonatomic, assign) YXAnswerType answerType;
@property (nonatomic, readonly ,strong) YXWordQuestionModel *wordQuestionModel;
@property (nonatomic, readonly ,strong) YXWordDetailModel *wordDetailModel;
@property (nonatomic, readonly ,assign) int wrongTimes;
@property (nonatomic, readonly ,strong) YXAnsweredInfo *answerInfo;
@property (nonatomic, assign) BOOL hadAnswerRight;
@property (nonatomic, readonly ,assign) YXExerciseType exerciseType;
@property (nonatomic, readonly ,copy) NSString *bookOrListId;
@property (nonatomic, readonly ,assign) NSInteger maxHints;
@property (nonatomic, readonly ,assign) BOOL canCheckAnswer;

//- (instancetype)initWith
- (instancetype)initWithWordQuestionModel:(YXWordQuestionModel *)wordQuestionModel
                            andAnswerInfo:(YXAnsweredInfo *)answerInfo
                             exerciseType:(YXExerciseType)exerciseType
                             bookOrListId:(NSString *)bookOrListId;

- (BOOL)isReviewOrPickErrorType;

- (NSInteger)maxHints;
- (void)playWordSound;
- (void)wordSoundPlayFinished;


- (void)setUpSubviews;
- (void)reloadData;

- (void)answerRightSound;
- (void)answerRightSoundFinished;
- (void)answerWrongSound;
- (void)answerWrongSoundFinished;

- (void)answerRight;

- (void)answerWorng;
- (void)addAnWrongAnswerRecord;
- (void)showNormalQuestionWrongHints;
- (void)firstTimeAnswerWorng;
- (void)secondTimeAnswerWorng;
- (void)thirdTimeAnswerWorng;

- (void)showWordDetail;
- (void)showWordDetailImmediately;

- (YXPerAnswer *)generatedAnAnswerRecord:(BOOL)isRight;
- (void)markStartDate;
- (void)markEndDate;

- (void)didEndTransAnimated;
- (void)releaseSource;

/** 埋点相关 */
- (void)traceEvent:(NSString *)eventId descributtion:(NSString *)desc;
- (void)tracePlayWordSound;

@end

