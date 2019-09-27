//
//  YXChoiceQuestionBaseView.m
//  YXEDU
//
//  Created by yao on 2018/11/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXChoiceQuestionBaseView.h"
#import "YXAnimatorStarView.h"
@interface YXChoiceQuestionBaseView () <YXCheckButtonsViewDelegate>
@property (nonatomic, assign)NSInteger resultIndex;// 选择题选择的index
@property (nonatomic, strong) UIImageView *encourageImageView;//激励icon
@end
@implementation YXChoiceQuestionBaseView
{
    YXCheckButtonsView *_checkButtonView;
}

- (NSInteger)maxHints {
    return self.wordDetailModel.hasImage ? 3 : 2;
}
- (void)setUpSubviews {
    [super setUpSubviews];
    
    CGFloat ButtonViewHeight = 388 > (SCREEN_HEIGHT * 0.5) ? (SCREEN_HEIGHT * 0.5) : 388;
    [self.checkButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(ButtonViewHeight);
    }];

    [self.encourageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.checkButtonView).with.offset(-20.f);
        make.bottom.equalTo(self.checkButtonView.mas_top).with.offset(-15.f);
        make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
    }];
    
    CGFloat topViewCenterY = (SCREEN_HEIGHT - kNavHeight - ButtonViewHeight) * 0.5;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(topViewCenterY);
        make.left.right.equalTo(self);
    }];
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

- (void)reloadData {
    [super reloadData];
    [self.checkButtonView configureWithTitles:self.wordQuestionModel.question.options];
}

- (YXPerAnswer *)generatedAnAnswerRecord:(BOOL)isRight {
    YXPerAnswer *perAnswer = [super generatedAnAnswerRecord:isRight];
    perAnswer.result = [NSString stringWithFormat:@"%zd",self.resultIndex];
    return perAnswer;
}

- (void)answerWrongSoundFinished {
    [super answerWrongSoundFinished];
    [self.checkButtonView resetAllButtons];
    NSLog(@"-------reset--------");
}
#pragma mark - <YXCheckButtonsViewDelegate>
- (void)CheckButtonView:(YXCheckButtonsView *)checkButtonView checkButton:(YXCheckButton *)checkButton {
    [self.checkButtonView disableAllButtons];
    NSLog(@"-------disable--------");
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        checkButton.transform = CGAffineTransformScale(checkButton.transform, 0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            checkButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            weakSelf.resultIndex = checkButton.tag; // 记录选择的索引
            NSInteger answer = [weakSelf.wordQuestionModel.question.answer integerValue];
            if (answer == checkButton.tag) {
                checkButton.type = CheckTrue;
                [weakSelf answerRight];
                
                CGPoint position = CGPointMake(5, -5);
                YXAnimatorStarView *starView = [[YXAnimatorStarView alloc] initWithRadius:22 position:position];
                [checkButton.checkAnswerImageView addSubview:starView];
                [starView launchAnimations];
                
            } else {
                checkButton.type = CheckFalse;
                if (weakSelf.exerciseType == YXExercisePickError) {
                    YXCheckButton *rightCheckButton = [checkButtonView checkButtonAtIndex:answer];
                    rightCheckButton.type = CheckTrue;
                }
                [weakSelf answerWorng];
            }
        }];
    }];
}

#pragma mark - subviews
- (YXCheckButtonsView *)checkButtonView {
    if (!_checkButtonView) {
        YXCheckButtonsView *checkButtonView = [[YXCheckButtonsView alloc] init];
        checkButtonView.delegate = self;
        [self addSubview:checkButtonView];
        _checkButtonView = checkButtonView;
    }
    return _checkButtonView;
}

- (UIImageView *)encourageImageView {
    if (!_encourageImageView) {
        UIImageView *encourageImageview = [[UIImageView alloc] init];
        encourageImageview.contentMode = UIViewContentModeScaleAspectFit;
        encourageImageview.alpha = 0;
        [self addSubview:encourageImageview];
        _encourageImageView = encourageImageview;
    }
    return _encourageImageView;
}

@end
