//
//  YXWordsChallengeCell.h
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoverBaseCell.h"
#import "YXGameModel.h"
#import "YXMyGradeModel.h"

typedef NS_ENUM(NSInteger, YXGameState) {
    YXGameStateFirstTime,
    YXGameStateDoItAgain,
    YXGameStateCanChallenge,
    YXGameStateCannotChallenge
};


@class YXWordsChallengeCell;
@protocol YXWordsChallengeCellDelegate <YXDescoverBaseCellDelegate>
- (void)wordsChallengeCellTapChallenge:(YXWordsChallengeCell *)cell;
@end

@interface YXWordsChallengeCell : YXDescoverBaseCell
@property (nonatomic,readonly,assign) YXGameState gameState;
@property (nonatomic, weak) id<YXWordsChallengeCellDelegate> delegate;
- (void)configWithGameModel:(YXGameModel *)gameModel gradeMode:(YXMyGradeModel *)myGradeModel;
@end

