//
//  YXGraphSingleBtnView.h
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAnswerModel.h"

typedef NS_ENUM(NSInteger, YXSingleSelectType) {
    YXSingleSelectNone,
    YXSingleSelectRight,
    YXSingleSelectFalse,
};

@interface YXGraphSingleBtnView : UIControl
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) YXAnswerModel *answerModel;
@property (nonatomic, assign) YXSingleSelectType selectType;
@end
