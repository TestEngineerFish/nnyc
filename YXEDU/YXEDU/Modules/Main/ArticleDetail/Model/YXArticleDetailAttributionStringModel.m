//
//  YXArticleDetailAttributionStringModel.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/28.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleDetailAttributionStringModel.h"

@implementation YXArticleDetailAttributionStringModel
+ (YXArticleDetailAttributionStringModel *)createArticleDetailAttributionStringModel: (TYAttributedLabel *)attributedLabel sentenceTextStorage:(YXSentenceTextStorage *)sentence {
    YXArticleDetailAttributionStringModel *model = [[YXArticleDetailAttributionStringModel alloc] init];
    model.attributedLabel = attributedLabel;
    model.sentenceTextStorage = sentence;
    return model;
}
@end
