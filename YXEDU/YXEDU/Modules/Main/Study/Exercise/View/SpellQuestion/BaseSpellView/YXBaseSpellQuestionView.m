

//
//  YXBaseSpellQuestionView.m
//  YXEDU
//
//  Created by yao on 2019/1/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXBaseSpellQuestionView.h"

static CGFloat const kCheckHintsBtnHeight = 30;
static CGFloat const kCheckHintsBtnWidth = 86;
static CGFloat const kCheckHintsTimeInterver = 3.0;

@interface YXBaseSpellQuestionView ()
@property (nonatomic, weak) UIButton *checkHintsBtn;
@property (nonatomic, weak) UIImageView *encourageImageView;//激励icon
@end

@implementation YXBaseSpellQuestionView
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self layoutIfNeeded];
    
}

- (NSInteger)maxHints {
    return 2;
}

- (void)setUpSubviews {
    [super setUpSubviews];
    CGFloat resultViewTopMargin = 30;
    
    if (![self isReviewOrPickErrorType]) { // 普通题包含看提示 self.exerciseType == YXExerciseNormal
        self.checkHintsBtn.frame = CGRectMake(kSCREEN_WIDTH, 15, kCheckHintsBtnWidth, kCheckHintsBtnHeight);
        resultViewTopMargin = 55;
    }
    
    CGFloat resultH = [self resultViewHeight];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(resultViewTopMargin);
        make.height.mas_equalTo(resultH);
    }];

    [self.encourageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.resultView).with.offset(-5.f);
        make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultView.mas_bottom).offset(25);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(MakeAdaptCGSize(206, 56));//CGSizeMake(206, 56)
    }];
    
//    [self pronceSymbolL];
//    [self explainL];
}

- (CGFloat)resultViewHeight {
    return 0;
}

- (void)reloadData {
    [super reloadData];
    _explainL.text = [NSString stringWithFormat:@"%@%@",self.wordDetailModel.property,self.wordDetailModel.paraphrase];
    NSString *pronceSymbol = [YXConfigure shared].isUsStyle ? self.wordDetailModel.usphone : self.wordDetailModel.ukphone;
    self.pronceSymbolL.text = pronceSymbol; //[NSString stringWithFormat:@"%@%@",self.wordDetailModel.synonym,pronceSymbol];
}


- (void)didEndTransAnimated {
    [super didEndTransAnimated];
    // 显示右上角的b【查看提示】按钮
    if (![self isReviewOrPickErrorType] && self.checkHintsBtn.frame.origin.x >= SCREEN_WIDTH) { //self.exerciseType == YXExerciseNormal
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kCheckHintsTimeInterver * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.checkHintsBtn.userInteractionEnabled = NO;
            CGFloat offsetX = kCheckHintsBtnWidth; //CGRectOffset(self.checkHintsBtn.frame, -offsetX, 0);
            CGRect desRect = CGRectMake(kSCREEN_WIDTH - offsetX, 15, kCheckHintsBtnWidth, kCheckHintsBtnHeight);
            [UIView animateWithDuration:0.25 animations:^{
                self.checkHintsBtn.frame = desRect;
            } completion:^(BOOL finished) {
                self.checkHintsBtn.userInteractionEnabled = YES;
            }];
        });
    }
}

- (void)answerRight {
    [super answerRight];
    //显示激励icon
    NSArray *imagesArray = @[@"encourage_first", @"encourage_second", @"encourage_third"];
    //如果是抽查复习,只要答对,就显示第一个激励icon
    if (self.exerciseType == YXExercisePickError) {
        self.encourageImageView.image = [UIImage imageNamed:imagesArray[0]];
    } else {
        NSInteger times = self.wordQuestionModel.answeredCount > imagesArray.count ? imagesArray.count : self.wordQuestionModel.answeredCount;
        self.encourageImageView.image = [UIImage imageNamed:imagesArray[times - 1]];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.encourageImageView.alpha = 1.f;
    }];
}

- (void)answerWrongSoundFinished {
    [super answerWrongSoundFinished];
    self.resultView.resultType = YXReultStateNone;
    if (self.wrongTimes == 1) { // 拼写题(大类)第一次打错要播放音效
//        [self playWordSound];
        [self spellQuestionFirstAnswerWrong];
    }
}

#pragma mark - actions
- (void)checkSpellResult {
    
}

- (void)checkHints {
    [self addAnWrongAnswerRecord];
//    [self showNormalQuestionWrongHints];
    
    if (self.wrongTimes == 1) {
        [self firstTimeAnswerWorng];
        [self spellQuestionFirstAnswerWrong];
    }else {
        [self showWordDetailImmediately];
    }
}


- (void)spellQuestionFirstAnswerWrong { // 拼写题(大类)第一次打错要播放音效
    if (self.exerciseType == YXExerciseNormal) { // 常规答题流程拼写题打错播放单词音频
        [self playWordSound];
    }
}

- (void)checkHintsAction { // 生成一次错误记录
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kHadShowQuestionHintsAlertKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kHadShowQuestionHintsAlertKey];
        if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedShowHintsAlert:)]) {
            [self.delegate questionBaseViewNeedShowHintsAlert:self];
        }
    }else { // 已经显示过
        [self checkHints];
    }
}
#pragma mark - subviews
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        UIButton *confirmButton = [[UIButton alloc] init];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"spell_confirm_able"] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"spell_confirm_unable"] forState:UIControlStateDisabled];
        [confirmButton addTarget:self action:@selector(checkSpellResult) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.enabled = NO;
        [self addSubview:confirmButton];
        _confirmButton = confirmButton;
    }
    return _confirmButton;
}

- (UIButton *)checkHintsBtn {
    if (!_checkHintsBtn) {
        UIButton *checkHintsBtn = [[UIButton alloc] init];
//        checkHintsBtn.titleLabel.font = [UIFont iconFontWithSize:13];
//        [checkHintsBtn setTitle:@"\U0000e71c  查看提示" forState:UIControlStateNormal];
//        checkHintsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [checkHintsBtn setBackgroundImage:[UIImage imageNamed:@"showHintsNormal"] forState:UIControlStateNormal];
        [checkHintsBtn setBackgroundImage:[UIImage imageNamed:@"showHintsHightlight"] forState:UIControlStateHighlighted];
        [checkHintsBtn addTarget:self action:@selector(checkHintsAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkHintsBtn];
        _checkHintsBtn = checkHintsBtn;
    }
    return _checkHintsBtn;
}

- (YXResultView *)resultView {
    if (!_resultView) {
        YXResultView *resultView = [[YXResultView alloc] init];
        [self addSubview:resultView];
        _resultView = resultView;
    }
    return _resultView;
}

- (UIImageView *)encourageImageView {
    if (!_encourageImageView) {
        UIImageView *encourageImageView = [[UIImageView alloc] init];
        encourageImageView.alpha = 0.f;
        [self addSubview:encourageImageView];
        _encourageImageView = encourageImageView;
    }
    return _encourageImageView;
}

- (UILabel *)pronceSymbolL {
    if (!_pronceSymbolL) {
        UILabel *pronceSymbolL = [[UILabel alloc] init];
        pronceSymbolL.alpha = 0.0f;
        pronceSymbolL.textAlignment = NSTextAlignmentCenter;
        pronceSymbolL.userInteractionEnabled = YES;
        pronceSymbolL.textColor = UIColorOfHex(0x849EC5);
        pronceSymbolL.font = [UIFont systemFontOfSize:15];
        pronceSymbolL.backgroundColor = [UIColor whiteColor];
        [self.resultView addSubview:pronceSymbolL];
        _pronceSymbolL = pronceSymbolL;
    }
    return _pronceSymbolL;
}

- (UILabel *)explainL {
    if (!_explainL) {
        UILabel *explainL = [[UILabel alloc] init];
        explainL.textAlignment = NSTextAlignmentCenter;
        explainL.textColor = UIColorOfHex(0x485461);
        explainL.font = [UIFont boldSystemFontOfSize:17];
        [self.resultView addSubview:explainL];
        _explainL = explainL;
    }
    return _explainL;
}

@end
