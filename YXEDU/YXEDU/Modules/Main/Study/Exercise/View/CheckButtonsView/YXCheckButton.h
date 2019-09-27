//
//  YXGraphSingleBtnView.h
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAnswerModel.h"

typedef NS_ENUM(NSInteger, YXCheckButtonType) {
    CheckNone,
    CheckTrue,
    CheckFalse,
};

@interface YXCheckButton : UIControl
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) YXAnswerModel *answerModel;
@property (nonatomic, assign) YXCheckButtonType type;
@property (nonatomic, strong) UIImageView *checkAnswerImageView;
@end
