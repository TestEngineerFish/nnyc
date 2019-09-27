//
//  YXChallengeUserCell.h
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXChallengeUserBaseView.h"
#import "YXUserRankModel.h"

static CGFloat const kScoreViewWidth = 60.0;

typedef NS_ENUM(NSInteger, YXChallengeUserViewType) {
    YXChallengeUserViewOther,
    YXChallengeUserViewMe
};

@interface YXChallengeCellUserView : YXChallengeUserBaseView
@property (nonatomic, assign) YXChallengeUserViewType challengeUserViewType;
@end










@interface YXChallengeUserCell : UITableViewCell
@property (nonatomic, weak)YXChallengeCellUserView *userView;
@property (nonatomic, weak)UIView *line;
@property (nonatomic, strong) YXUserRankModel *userRankModel;
- (void)setupSubViews;
@end
