//
//  YXStudySpellVC.h
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXStudyCmdCenter.h"

typedef NS_ENUM(NSInteger, YXSpellType) {
    YXSpellTypeNone,
    YXSpellTypeRight,
    YXSpellTypeFalse,
};

@interface YXNoPasteTextField : UITextField
@end

@interface YXStudySpellView : UIView
@property (nonatomic, assign) YXAnswerType answerType;
@property (nonatomic, assign) YXSpellType spellType;
- (void)reloadData;
@end
