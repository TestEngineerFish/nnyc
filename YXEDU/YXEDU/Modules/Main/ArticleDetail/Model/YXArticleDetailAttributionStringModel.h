//
//  YXArticleDetailAttributionStringModel.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/28.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYAttributedLabel.h"
#import "YXSentenceTextStorage.h"
#import "YXWordTextStorage.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXArticleDetailAttributionStringModel : NSObject

@property (nonatomic, strong) TYAttributedLabel *attributedLabel;
@property (nonatomic, strong) YXSentenceTextStorage *sentenceTextStorage;

+ (YXArticleDetailAttributionStringModel *)createArticleDetailAttributionStringModel: (TYAttributedLabel *)attributedLabel sentenceTextStorage:(YXSentenceTextStorage *)sentence;

@end

NS_ASSUME_NONNULL_END
