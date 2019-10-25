//
//  YXSelectLettersQuestionView.m
//  YXEDU
//
//  Created by yao on 2019/1/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSelectLettersQuestionView.h"
#import "YXNinePalaceKeyBoardView.h"
#import "YXSelectLettersViewOld.h"

@interface YXSelectLettersQuestionView ()<YXNinePalaceKeyBoardViewDelegate>
@property (nonatomic, strong) YXNinePalaceKeyBoardView *customKeyBoard;
@property (nonatomic, strong) YXSelectLettersViewOld *spellView;
@end
@implementation YXSelectLettersQuestionView
- (void)setUpSubviews {
    [super setUpSubviews];
    
    [self.explainL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resultView).offset(10);
        make.right.equalTo(self.resultView).offset(-10);
        make.top.equalTo(self.resultView).offset(AdaptSize(45));
    }];

    [self setKeyboardView];
    
    __weak typeof(self) weakSelf = self;
    self.spellView = [[YXSelectLettersViewOld alloc] initWithQuestionModel:self.wordQuestionModel.question];
    self.spellView.reverseLettersViewBlock = ^(NSInteger index) {
        [weakSelf.customKeyBoard reverseKeyButtonAtIndex:index];
    };
    [self.resultView addSubview:self.spellView];
    [self.spellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explainL.mas_bottom).offset(AdaptSize(5));
        make.left.equalTo(self.resultView).offset(5);
        make.right.equalTo(self.resultView).offset(-5);
        make.height.mas_equalTo(AdaptSize(35));
    }];
    
    [self.pronceSymbolL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.resultView);
        make.top.equalTo(self.spellView.mas_bottom).offset(50);
    }];
    
   
}

- (void)checkSpellResult {
    [super checkSpellResult];
    
    if ([self.spellView checkResult]) { // 答对
        self.customKeyBoard.isCorrect = YES;
        [self answerRight];
        self.resultView.resultType = YXReultStateCorrect;
    }else { // 打错
        [self answerWorng];
        self.resultView.resultType = YXReultStateWrong;
    }
    [self.customKeyBoard checkAnswer];
}

- (void)setKeyboardView {
    CGFloat lrMargin = AdaptSize(70);
    CGFloat bottoMargin = AdaptSize(40);
    YXQuestionModel *quesModel = self.wordQuestionModel.question;
    NSString *options = [NSString stringWithFormat:@"%@",quesModel.options.firstObject];
    self.customKeyBoard = [[YXNinePalaceKeyBoardView alloc] initWithFrame:CGRectZero
                                                               allOptions:quesModel.allOptions.firstObject
                                                                   answer:quesModel.answer
                                                                  options:options];
    self.customKeyBoard.delegate = self;
    [self addSubview:self.customKeyBoard];
    [self.customKeyBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(lrMargin);
        make.right.equalTo(self).offset(-lrMargin);
        make.bottom.equalTo(self).offset(-bottoMargin - kSafeBottomMargin);
        make.height.mas_equalTo(kSCREEN_WIDTH - 2 * lrMargin);
    }];
}
- (CGFloat)resultViewHeight {
    return AdaptSize(152);
}

- (void)firstTimeAnswerWorng {
    [super firstTimeAnswerWorng];
    [self.explainL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultView).offset(AdaptSize(30));
    }];
    
    [self.pronceSymbolL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spellView.mas_bottom).offset(AdaptSize(17));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.resultView layoutIfNeeded];
        self.pronceSymbolL.alpha = 1;
    } completion:nil];
}

- (void)secondTimeAnswerWorng {
    [super secondTimeAnswerWorng];
    [self showWordDetail];
}
#pragma mark - <YXNinePalaceKeyBoardViewDelegate>
- (void)ninePalaceKeyBoardButtonDidClicked:(YXNinePalaceKeyBoardView *)ninePalaceKeyBoardView
                               clickButton:(YXNinePalaceKeyBoardButton *)clickedButton
                                isFinished:(BOOL)isFinished
                          indexInAnswerArr:(NSInteger)indexInAnswerArr
{
    NSString *letters = (clickedButton.status == Normal) ? @"" : clickedButton.letters;
//    NSLog(@"------%zd",indexInAnswerArr);
    [self.spellView insertLetters:letters atIndex:indexInAnswerArr];
    self.confirmButton.enabled = isFinished;
}

@end
