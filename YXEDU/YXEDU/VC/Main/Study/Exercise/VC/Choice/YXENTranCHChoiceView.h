//
//  YXENTranCHVC.h
//  YXEDU
//
//  Created by shiji on 2018/4/18.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXStudyCmdCenter.h"
@interface YXENTranCHChoiceView : UIView
@property (nonatomic, assign) YXAnswerType answerType;
- (void)reloadData;
@end
