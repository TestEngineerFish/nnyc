//
//  YXBaseSpellQuestionView.h
//  YXEDU
//
//  Created by yao on 2019/1/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXQuestionBaseView.h"
#import "YXResultView.h"
@interface YXBaseSpellQuestionView : YXQuestionBaseView
@property (nonatomic, weak)UIButton *confirmButton;
@property (nonatomic, weak)YXResultView *resultView;
@property (nonatomic, weak)UILabel *pronceSymbolL;
@property (nonatomic, weak)UILabel *explainL;
- (void)checkSpellResult;
- (void)checkHints;
- (CGFloat)resultViewHeight;

@end

