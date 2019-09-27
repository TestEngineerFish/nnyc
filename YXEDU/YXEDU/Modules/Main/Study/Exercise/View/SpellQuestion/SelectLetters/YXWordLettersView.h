//
//  YXWordLettersView.h
//  YXEDU
//
//  Created by yao on 2019/1/23.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXBaseSpellQuestionView.h"
#import "YXSpellQuestionCommon.h"
#import "YXLettersModel.h"

@class YXWordLettersView;
@protocol YXWordLettersViewDelegate <NSObject>
- (void)wordLettersViewReverseSelected:(YXWordLettersView *)wordLettersView;
@end

@interface YXWordLettersView : UIView
@property (nonatomic, weak) id<YXWordLettersViewDelegate> delegate;
@property (nonatomic, readonly, strong) UILabel *lettersLabel;
@property (nonatomic, copy) NSString *curCharacter;
@property (nonatomic, readonly, strong) CALayer *indicator;
@property (nonatomic, strong) YXLettersModel *lettersModel;
@property (nonatomic, assign) YXCharacterType characterType;
- (instancetype)initWithLettersModel:(YXLettersModel *)lettersModel;
@end
