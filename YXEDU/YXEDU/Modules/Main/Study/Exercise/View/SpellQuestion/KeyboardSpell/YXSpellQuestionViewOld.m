//
//  YXSpellQuestionView.m
//  YXEDU
//
//  Created by yao on 2018/11/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSpellQuestionView.h"
#import "YXSpellViewOld.h"
#import "YXResultView.h"
#import "YXAudioAnimations.h"

@interface YXSpellQuestionView ()<YXSpellViewOldDelegate>
@property (nonatomic, weak)YXSpellViewOld *spellView;
@property (nonatomic, weak)YXAudioAnimations *audioButton;
@property (nonatomic, weak)UIView *topView;
@property (nonatomic, assign) BOOL isFullSpellQues;
@end

@implementation YXSpellQuestionView
- (void)setUpSubviews {
    [super setUpSubviews];
    YXQuestionType type = self.wordQuestionModel.question.type;
    self.isFullSpellQues = (type == YXQuestionPronunceFullSpell || type == YXQuestionChToFullSpell);
    [self topView];
    if (type == YXQuestionPronuncePartSpell) { // 听发音部分拼写
        YXAudioAnimations *audioButton = [YXAudioAnimations playAudioAnimation];
        [audioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _audioButton = audioButton;
        [self.topView addSubview:audioButton];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.resultView);
            make.height.mas_equalTo(90.f);
        }];
        
        [audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.resultView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.bottom.equalTo(self.topView);
        }];
        
//        [self playWordSound];// 默认播放一次发音
    }else if (type == YXQuestionChToPartSpell) {
        [self.topView addSubview: self.explainL];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.resultView);
            make.height.mas_equalTo(65.f);
        }];
        
        [self.explainL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.resultView).offset(10);
            make.right.equalTo(self.resultView).offset(-10);
            make.bottom.equalTo(self.topView);
        }];
    }else { //全拼题(听发音/词义)统一成一种题型
        YXAudioAnimations *audioButton = [YXAudioAnimations playAudioAnimation];
        [audioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _audioButton = audioButton;
        
        [self.topView addSubview:audioButton];
        [audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.resultView);
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.top.equalTo(self.topView).offset(40);
        }];
        
        [self.topView addSubview:self.explainL];
        
        [self.explainL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.resultView).offset(10);
            make.right.equalTo(self.resultView).offset(-10);
            make.top.equalTo(audioButton.mas_bottom).offset(12);
        }];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.resultView);
            make.height.mas_equalTo(125.f);
        }];
        
//        [self playWordSound];// 默认播放一次发音
    }
    
    NSString *blankLocs = self.wordQuestionModel.question.options.firstObject;
    YXSpellViewOld *spellView = [YXSpellViewOld spellViewWithOriWord:self.wordDetailModel.word andBlankLocs:blankLocs];
    spellView.delegate = self;
    [self.resultView addSubview:spellView];
    _spellView = spellView;
    [self.spellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(8);
        make.left.equalTo(self.resultView).offset(5);
        make.right.equalTo(self.resultView).offset(-5);
        make.height.mas_equalTo(35);
    }];
    
    [self.pronceSymbolL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.resultView);
        make.top.equalTo(self.spellView.mas_bottom).offset(50);
    }];
}


- (CGFloat)resultViewHeight {
    YXQuestionType type = self.wordQuestionModel.question.type;
    if (type == YXQuestionPronuncePartSpell) {
        return 177;
    }else if (type == YXQuestionChToPartSpell) {
        return 155;
    }else { // 全拼大类
        return 207;
    }
}

//- (NSInteger)maxHints {
//    return 2;
//}

#pragma mark - check
- (void)checkSpellResult {
    if ([self.spellView result]) { // 答对
        [self answerRight];
        self.resultView.resultType = YXReultStateCorrect;
    }else { // 打错
        [self answerWorng];
        self.resultView.resultType = YXReultStateWrong;
    }
}

- (void)firstTimeAnswerWorng {
    [super firstTimeAnswerWorng];
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultView).offset(-15);
    }];
    
    [self.pronceSymbolL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spellView.mas_bottom).offset(20);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.resultView layoutIfNeeded];
        self.pronceSymbolL.alpha = 1;
    } completion:^(BOOL finished) {
//        [self didEndTransAnimated];
    }];
}

- (void)secondTimeAnswerWorng {
    [super secondTimeAnswerWorng];
    [self showWordDetail]; // 展示详情页
}

- (void)thirdTimeAnswerWorng {
    [super thirdTimeAnswerWorng];
}

//- (void)answerWrongSoundFinished {
//    [super answerWrongSoundFinished];
//    [self.spellView beginEditing];
//}

//- (void)checkHints {
//    [super checkHints];
//    if (self.wrongTimes == 1) {
//        [self firstTimeAnswerWorng];
//    }else {
//        [self showWordDetailImmediately];
//    }
//}

- (YXPerAnswer *)generatedAnAnswerRecord:(BOOL)isRight { // 修改每条答题记录的result
    YXPerAnswer *pAnswer = [super generatedAnAnswerRecord:isRight];
    pAnswer.result = self.spellView.resultWord;
    return pAnswer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint locP = [touches.anyObject locationInView:self];
    
    if (!CGRectContainsPoint(self.resultView.frame, locP)) {
        [self endEditing:YES];
    }
}

#pragma mark -sound animation
- (void)audioButtonClicked:(id)sender {
    [self.audioButton startAnimating];
    [self playWordSound];
}

- (void)wordSoundPlayFinished {
    [super wordSoundPlayFinished];
    [self.audioButton stopAnimating];
}

#pragma mark - <YXSpellViewOldDelegate>
- (void)spellView:(YXSpellViewOld *)spellView complate:(BOOL)complate {
    self.confirmButton.enabled = complate;
}

- (void)spellView:(YXSpellViewOld *)spellView canCheck:(BOOL)canCheck {
    if (self.canCheckAnswer) { //self.userInteractionEnabled
        if (canCheck) {
            [self checkSpellResult];
        }else {
            [YXUtils showHUD:self title:@"请输入完整的单词"];
        }
    }
}

- (void)didEndTransAnimated {
    [super didEndTransAnimated];
    [self.spellView beginEditing];
    
    YXQuestionType type = self.wordQuestionModel.question.type;
    if (type != YXQuestionChToPartSpell) {
        [self playWordSound];
    }
}

- (void)dealloc {
    
}

- (UIView *)topView {
    if (!_topView) {
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor clearColor];
        [self.resultView addSubview:topView];
        _topView = topView;
    }
    return _topView;
}

@end



/*
 - (void)setUpSubviews {
 [super setUpSubviews];
 
 YXQuestionType type = self.wordQuestionModel.question.type;
 BOOL isPronunceSpell = (type == YXQuestionPronuncePartSpell || type == YXQuestionPronunceFullSpell);
 CGFloat resultH = isPronunceSpell ? 177 : 155;
 [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(self).offset(15);
 make.right.equalTo(self).offset(-15);
 make.top.equalTo(self).offset(30);
 make.height.mas_equalTo(resultH);
 }];
 
 [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.equalTo(self.resultView.mas_bottom).offset(30);
 make.centerX.equalTo(self);
 make.size.mas_equalTo(CGSizeMake(206, 56));
 }];
 
 if (isPronunceSpell) { // 发音拼单词
 YXAudioAnimations *audioButton = [YXAudioAnimations playAudioAnimation];
 [audioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 [self.resultView addSubview:audioButton];
 _audioButton = audioButton;
 self.topView = audioButton;
 
 [audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
 make.centerX.equalTo(self.resultView);
 make.size.mas_equalTo(CGSizeMake(50, 50));
 make.top.equalTo(self.resultView).offset(40);
 }];
 
 [self playWordSound];// 默认播放一次发音
 }else if (type == YXQuestionChToFullSpell || type == YXQuestionChToPartSpell) {
 UILabel *explainL = [[UILabel alloc] init];
 explainL.textAlignment = NSTextAlignmentCenter;
 explainL.textColor = UIColorOfHex(0x485461);
 explainL.font = [UIFont boldSystemFontOfSize:17];
 [self.resultView addSubview:explainL];
 _explainL = explainL;
 self.topView = explainL;
 
 [self.explainL mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(self.resultView).offset(10);
 make.right.equalTo(self.resultView).offset(-10);
 make.top.equalTo(self.resultView).offset(40);
 }];
 }
 
 NSString *blankLocs = self.wordQuestionModel.question.options.firstObject;
 YXSpellViewOld *spellView = [YXSpellViewOld spellViewWithOriWord:self.wordDetailModel.word andBlankLocs:blankLocs];
 spellView.delegate = self;
 [self.resultView addSubview:spellView];
 _spellView = spellView;
 [self.spellView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.equalTo(self.topView.mas_bottom).offset(10);
 make.left.equalTo(self.resultView).offset(5);
 make.right.equalTo(self.resultView).offset(-5);
 make.height.mas_equalTo(35);
 }];
 
 [self.pronceSymbolL mas_makeConstraints:^(MASConstraintMaker *make) {
 make.centerX.equalTo(self.resultView);
 make.top.equalTo(self.spellView.mas_bottom).offset(50);
 }];
 }
 
 
 
 
 
 - (UIView *)spellCardView {
 if (!_spellCardView) {
 UIView *spellCardView = [[UIView alloc] init];
 spellCardView.backgroundColor = [UIColor whiteColor];
 [self addSubview:spellCardView];
 _spellCardView = spellCardView;
 }
 return _spellCardView;
 }
 
 - (UILabel *)pronceSymbolL {
 if (!_pronceSymbolL) {
 UILabel *pronceSymbolL = [[UILabel alloc] init];
 pronceSymbolL.alpha = 0.0f;
 pronceSymbolL.textAlignment = NSTextAlignmentCenter;
 pronceSymbolL.textColor = UIColorOfHex(0x849EC5);
 pronceSymbolL.font = [UIFont systemFontOfSize:15];
 pronceSymbolL.backgroundColor = [UIColor whiteColor];
 [self.resultView addSubview:pronceSymbolL];
 _pronceSymbolL = pronceSymbolL;
 }
 return _pronceSymbolL;
 }
 
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
 
 - (YXResultView *)resultView {
 if (!_resultView) {
 YXResultView *resultView = [[YXResultView alloc] init];
 [self addSubview:resultView];
 _resultView = resultView;
 }
 return _resultView;
 }*/





//        self.confirmButton.enabled = NO;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.resultView.resultType = YXReultStateNone;
//            self.confirmButton.enabled = YES;
//        });




//        self.confirmButton.userInteractionEnabled = NO;
//        if (self.audioButton) {
//            self.audioButton.userInteractionEnabled = NO;
//        }
