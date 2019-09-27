//
//  YXGameBackgroundView.h
//  YXEDU
//
//  Created by yao on 2018/12/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSquareView.h"
#import "YXGameAnswerModel.h"

@class YXGameBackgroundView;
@protocol YXGameBackgroundViewDelegate <NSObject>
- (void)gameBackgroundViewGameFinished:(YXGameBackgroundView *)gamebgView;
@end

@interface YXGameBackgroundView : UIImageView
@property (nonatomic, weak) id<YXGameBackgroundViewDelegate> delegate;
@property (nonatomic, weak) UILabel *explainLabel;
@property (nonatomic, weak) UILabel *countdownLabel;
@property (nonatomic, weak) UILabel *answerNumLabel;

@property (nonatomic, weak) YXSquareView *squareView;
@property (nonatomic, strong) YXGameContent *gameQuesModel;
@property (nonatomic, strong) YXGameDetailModel *gameDetail;
@property (nonatomic, strong) YXGameAnswerModel *gameAnswerModel;
- (void)gameFinished;
@end
