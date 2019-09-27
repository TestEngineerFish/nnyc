//
//  YXCheckButtonsView.m
//  YXEDU
//
//  Created by Jake To on 10/30/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXCheckButtonsView.h"
#import "YXStudyCmdCenter.h"

@interface YXCheckButtonsView()

@property (nonatomic, strong) YXCheckButton *firstButton;
@property (nonatomic, strong) YXCheckButton *secondButton;
@property (nonatomic, strong) YXCheckButton *thirdButton;
@property (nonatomic, strong) YXCheckButton *fourthButton;

@property(nonatomic, copy) NSArray *buttons;

@end

@implementation YXCheckButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (NSInteger i = 0; i < 4; i ++) {
            YXCheckButton *button = [[YXCheckButton alloc] init];
            [self addSubview: button];
            [button addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.buttons = [self.subviews copy];//@[self.firstButton, self.secondButton, self.thirdButton, self.fourthButton];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:self.buttons];
        stackView.spacing = 16;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFillEqually;
        [self addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self).offset(-44);
        }];
    }
    return self;
}

- (void)configureButtonsWithType:(NSString *)type titles:(NSArray *)titles {
    for (int index = 0; index < self.buttons.count; index++) {
        YXCheckButton *button = self.buttons[index];
        button.tag = index;
        button.answerModel.type = type;
        button.answerModel.answer = [NSString stringWithFormat:@"%d", index];
        button.titleLable.text = titles[index];
    }
}

- (void)configureWithTitles:(NSArray *)titles {
    for (int index = 0; index < self.buttons.count; index++) {
        YXCheckButton *button = self.buttons[index];
        button.tag = index;
        button.titleLable.text = titles[index];
    }
}
- (void)disableAllButtons {
    for (YXCheckButton *button in self.buttons) {
        button.userInteractionEnabled = NO;
    }
}

- (void)resetAllButtons {
    for (YXCheckButton *button in self.buttons) {
        button.userInteractionEnabled = YES;
        button.type = CheckNone;
    }
}

- (void)checkButtonClicked:(YXCheckButton *)button {
    if ([self.delegate respondsToSelector:@selector(CheckButtonView:checkButton:)]) {
        [self.delegate CheckButtonView:self checkButton:button];
    }
}

- (YXCheckButton *)checkButtonAtIndex:(NSInteger)index {
    if (index < self.buttons.count) {
        return [self.buttons objectAtIndex:index];
    }
    return nil;
}

@end
