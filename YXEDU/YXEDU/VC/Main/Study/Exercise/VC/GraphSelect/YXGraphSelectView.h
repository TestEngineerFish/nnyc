//
//  YXGraphSelectView.h
//  YXEDU
//
//  Created by shiji on 2018/4/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXEnumComm.h"
#import "YXAnswerModel.h"
#import "YXStudyCmdCenter.h"



@interface YXGraphSelectButton : UIControl
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, assign) YXGraphSelectType selectType;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) YXAnswerModel *answerModel;
@end

@interface YXGraphSelectView : UIView
@property (nonatomic, assign) YXAnswerType answerType;

/*
 * 刷新显示的信息
 */
- (void)reloadViewSource;
@end
