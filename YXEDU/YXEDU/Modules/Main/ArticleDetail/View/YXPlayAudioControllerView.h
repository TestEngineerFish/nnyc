//
//  YXPlayAudioControllerView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/31.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXArticleBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXPlayAudioControllerView : UIView

@property (nonatomic, weak) id<ArticleDelegate> delegate;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) NSUInteger totalUseTime;
@property (nonatomic, weak) UIButton *previousBtn;
@property (nonatomic, weak) UIButton *nextBtn;

- (void)startCoundDownFrom:(NSUInteger)index;
- (void)stopCoundDown;

@end

NS_ASSUME_NONNULL_END
