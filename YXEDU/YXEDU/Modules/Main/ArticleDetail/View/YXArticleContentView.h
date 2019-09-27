//
//  YXArticleContentView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXArticleModel.h"
#import "TYAttributedLabel.h"
#import "YXArticleBottomView.h"
#import "YXSentenceTextStorage.h"
#import "YXWordTextStorage.h"
#import "YXArticleDetailAttributionStringModel.h"

@interface YXArticleContentView : UIView
@property (nonatomic, weak) id<ArticleDelegate> delegate;
@property (nonatomic, strong) YXArticleModel *articleModel;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) NSUInteger totalUseTime;
@property (nonatomic, strong) YXArticleDetailAttributionStringModel *selectedAttrModel;
@property (nonatomic, strong) NSArray<YXArticleDetailAttributionStringModel *> *attriStrModelList;

- (void)setContent: (YXArticleModel *)articleModel showTranslate:(BOOL)isShow;
- (void)hideWordPopView;
- (void)selectSentence:(YXArticleDetailAttributionStringModel *)attrModel;
- (void)resetAttributionString;
@end
