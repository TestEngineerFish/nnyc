//
//  YXSpokenView.h
//  YXEDU
//
//  Created by yao on 2018/11/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXQuestionBaseView.h"
#import "YXTostView.h"

@class YXSpokenView;
@protocol YXSpokenViewDelegate <NSObject, YXQuestionBaseViewDelegate>
@required
- (void)spokenViewSkipCurrentGroupSpokenQuestions:(YXQuestionBaseView *)questionBaseView;
- (void)spokenViewMacrophoneWasDenied:(YXQuestionBaseView *)questionBaseView;
@end

@interface YXSpokenView : YXQuestionBaseView
@property (nonatomic, weak, nullable) id <YXSpokenViewDelegate> delegate;
@end

