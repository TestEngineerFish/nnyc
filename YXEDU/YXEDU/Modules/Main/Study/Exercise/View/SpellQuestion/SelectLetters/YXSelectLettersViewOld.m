//
//  YXSelectLettersViewOld.m
//  YXEDU
//
//  Created by yao on 2019/1/23.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSelectLettersViewOld.h"
#import "YXWordLettersView.h"

#define kLetterDefaultWith 
@interface YXSelectLettersViewOld ()<YXWordLettersViewDelegate>
@property (nonatomic, strong) YXQuestionModel *quesModel;
@property (nonatomic, copy) NSArray *wordLetters;
@property (nonatomic, strong) NSArray *blankWordLettersView;
@property (nonatomic, weak) YXWordLettersView *lastHightlight;
@end

@implementation YXSelectLettersViewOld

- (instancetype)initWithQuestionModel:(YXQuestionModel *)quesModel {
    if (self = [super init]) {
        self.quesModel = quesModel;
        self.wordLetters = [quesModel.answer componentsSeparatedByString:@","];
    
        NSString *options = [NSString stringWithFormat:@"%@",quesModel.options.firstObject];
        NSArray *blankLetterIndexs = [options componentsSeparatedByString:@","];
        NSMutableArray *blankWordLettersView = [NSMutableArray array];
        for (NSInteger i = 0; i < self.wordLetters.count; i ++ ) {
            NSString *indexStr = [NSString stringWithFormat:@"%zd",i];
            BOOL isContain = [blankLetterIndexs containsObject:indexStr];
            YXLettersModel *lettersModel = [[YXLettersModel alloc] init];
            lettersModel.blank = isContain;
            lettersModel.oriCharacter = [self.wordLetters objectAtIndex:i];
            lettersModel.curCharacters = isContain ? @"" : lettersModel.oriCharacter;
            YXWordLettersView *wordLettersView = [[YXWordLettersView alloc] initWithLettersModel:lettersModel];
            wordLettersView.delegate = self;
            if (isContain) {
                [blankWordLettersView addObject:wordLettersView];
            }
            [self addSubview:wordLettersView];
        }
        self.blankWordLettersView = [blankWordLettersView copy];
        [self setNeedsLayout];
        
        [self refreshSubViews];
    }
    return self;
}

- (void)insertLetters:(NSString *)letters atIndex:(NSInteger)index {
    if (index != NSNotFound && index < self.blankWordLettersView.count) {
        YXWordLettersView *wlv = [self.blankWordLettersView objectAtIndex:index];
        wlv.curCharacter = letters;
        [UIView animateWithDuration:0.25 animations:^{
            [self refreshSubViews];
        }];
    }
    
    BOOL findLeftBlankLetter = NO;
    for (YXWordLettersView *wlv in self.blankWordLettersView) {
        if (wlv.curCharacter.length == 0 && !findLeftBlankLetter) {
            wlv.characterType = YXCharacterHighlight;
            findLeftBlankLetter = YES;
        }else {
            wlv.characterType = YXCharacterNormal;
        }
    }
}


- (BOOL)checkResult {
    BOOL isCorrect = YES;
    //全拼
    if (self.quesModel.type == YXQuestionSelectFullLetters){
        NSString *curString = @"";
        for (YXWordLettersView *wlv in self.blankWordLettersView) {
            
            //        if (!wlv.lettersModel.isCorrect) {
            //            wlv.characterType = YXCharacterError;
            //            isCorrect = NO;
            //        }
            curString = [NSString stringWithFormat:@"%@%@",curString,wlv.lettersModel.curCharacters];
            
        }
        NSString *tureString = [self.quesModel.answer stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if (![tureString isEqualToString:curString]) {
            isCorrect = NO;
        }
        else{
            for (YXWordLettersView *wlv in self.blankWordLettersView) {
                curString = [NSString stringWithFormat:@"%@%@",curString,wlv.lettersModel.curCharacters];
                wlv.characterType = YXCharacterNormal;
                wlv.lettersModel.isCorrect = YES;
            }
        }
    }
    else {
        for (YXWordLettersView *wlv in self.blankWordLettersView) {
            
            if (!wlv.lettersModel.isCorrect) {
                wlv.characterType = YXCharacterError;
                isCorrect = NO;
            }
        }
    }
    
    return isCorrect;
}


- (void)refreshSubViews {
    CGSize size = CGSizeMake(kMaxSpellViewWith, AdaptSize(35));
    //    NSInteger count = self.subviews.count;
    
    CGFloat contentW = 0;
    for (YXWordLettersView *wlv in self.subviews) {
        contentW += wlv.lettersModel.contentWidth;
    }
    
    CGFloat lrMargin = (size.width - contentW) * 0.5;
    
    CGFloat x = lrMargin;
    for (NSInteger i = 0; i < self.subviews.count; i ++) {
        YXWordLettersView *wlv = [self.subviews objectAtIndex:i];
        wlv.frame = CGRectMake(x, 0, wlv.lettersModel.contentWidth, size.height);
        x += wlv.lettersModel.contentWidth;
    }
}

#pragma mark - <YXWordLettersViewDelegate>
- (void)wordLettersViewReverseSelected:(YXWordLettersView *)wordLettersView {
    NSInteger reverseIndex = [self.blankWordLettersView indexOfObject:wordLettersView];
    if (self.reverseLettersViewBlock) {
        self.reverseLettersViewBlock(reverseIndex);
    }
}

@end
