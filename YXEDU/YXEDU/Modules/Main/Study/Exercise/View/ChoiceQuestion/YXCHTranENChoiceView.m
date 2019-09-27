//
//  YXCHTranENChoiceVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/18.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCHTranENChoiceView.h"
#import "YXCheckButton.h"
#import "NSString+YR.h"
#import "BSCommon.h"
#import "YXAPI.h"

#import "YXPinkProgressView.h"
#import "YXCheckButtonsView.h"

@interface YXCHTranENChoiceView () 

@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UILabel *partOfSpeechLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *englishLabel;
@property (nonatomic, strong) UILabel *chineseLabel;
@end

@implementation YXCHTranENChoiceView

- (void)setUpSubviews {
    [super setUpSubviews];
    self.wordLabel = [[UILabel alloc] init];
    self.wordLabel.font = [UIFont boldSystemFontOfSize:24];
    self.wordLabel.adjustsFontSizeToFitWidth = YES;
    self.wordLabel.textColor = UIColorOfHex(0x485461);
    self.wordLabel.text = @"小船，小艇；轮船";
    
    self.partOfSpeechLabel = [[UILabel alloc] init];
    self.partOfSpeechLabel.textColor = UIColorOfHex(0x485461);
    self.partOfSpeechLabel.textAlignment = NSTextAlignmentLeft;
    self.partOfSpeechLabel.text = @"n.";

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorOfHex(0xE9EFF4);
    
    self.englishLabel = [[UILabel alloc] init];
    self.englishLabel.numberOfLines = 0;
    self.englishLabel.textColor = UIColorOfHex(0x485461);
    self.englishLabel.textAlignment = NSTextAlignmentLeft;
    
    self.chineseLabel = [[UILabel alloc] init];
    self.chineseLabel.numberOfLines = 0;
    self.chineseLabel.textColor = UIColorOfHex(0x485461);
    self.chineseLabel.textAlignment = NSTextAlignmentLeft;
//    self.chineseLabel.text = @"我需要一艘船渡河";

//    [self addSubview:self.wordLabel];
//    [self addSubview:self.partOfSpeechLabel];
//    [self addSubview:self.lineView];
//    [self addSubview:self.englishLabel];
//    [self addSubview:self.chineseLabel];

    [self.headerView addSubview:self.wordLabel];
    [self.headerView addSubview:self.partOfSpeechLabel];
    [self.headerView addSubview:self.lineView];
    [self.headerView addSubview:self.englishLabel];
    [self.headerView addSubview:self.chineseLabel];
    
    self.lineView.alpha = 0;
    self.englishLabel.alpha = 0;
    self.chineseLabel.alpha = 0;
    
    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self.partOfSpeechLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wordLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.partOfSpeechLabel.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.englishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(16);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.chineseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.englishLabel.mas_bottom).offset(8);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.partOfSpeechLabel.mas_bottom).priority(MASLayoutPriorityDefaultLow);
        //        make.bottom.equalTo(self.descriptionLabel.mas_bottom).priority(MASLayoutPriorityDefaultMedium);
        //        make.bottom.equalTo(self.descriptionImageView.mas_bottom).priority(MASLayoutPriorityDefaultHigh);
    }];
}

- (void)reloadData {
    [super reloadData];
    self.answerType = start;

    YXWordDetailModel *word = self.wordQuestionModel.wordDetail;
    self.wordLabel.text = word.paraphrase;
    self.partOfSpeechLabel.text = word.property;
    
    NSRange startRange = [word.eng rangeOfString:@"<font"];
    NSRange endRange = [word.eng rangeOfString:@"font>"];
    NSString *prefixString = [word.eng substringToIndex:startRange.location];
    NSString *suffixString = [word.eng substringFromIndex:endRange.location + endRange.length];
    NSString *string = [NSString stringWithFormat:@"%@______%@",prefixString,suffixString];
    self.englishLabel.text = string;
    self.chineseLabel.text = word.chs;
}

- (void)firstTimeAnswerWorng {
    [super firstTimeAnswerWorng];
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.englishLabel.mas_bottom).priority(MASLayoutPriorityDefaultMedium);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
        self.lineView.alpha = 1;
        self.englishLabel.alpha = 1;
    }];
}

- (void)secondTimeAnswerWorng {
    [super secondTimeAnswerWorng];
    if (self.wordDetailModel.word.length > 1) {
        NSRange range = [self.englishLabel.text rangeOfString:@"______"];
        NSString *firstChar = [self.wordDetailModel.word substringToIndex:1];
        self.englishLabel.text = [self.englishLabel.text stringByReplacingCharactersInRange:NSMakeRange(range.location, 1) withString:firstChar];
        [self.englishLabel sizeToFit];
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.chineseLabel.mas_bottom).priority(MASLayoutPriorityDefaultHigh);
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutIfNeeded];
            self.chineseLabel.alpha = 1;
        }];
    }else {
        [self showWordDetail];
    }
}

- (void)thirdTimeAnswerWorng {
    [super thirdTimeAnswerWorng];
}

- (NSInteger)maxHints {
    return 3;
}

@end
















//- (void)setAnswerType:(YXAnswerType)answerType {
//    _answerType = answerType;
//    switch (answerType) {
//        case start:
//            self.lineView.alpha = 0;
//            self.englishLabel.alpha = 0;
//            self.chineseLabel.alpha = 0;
//            break;
//
//        case wrongOnce: {
//            [self.wordLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self).offset(20);
//            }];
//
//            [UIView animateWithDuration:0.4 animations:^{
//
//                [self layoutIfNeeded];
//
//                self.lineView.alpha = 1;
//                self.englishLabel.alpha = 1;
//            }];
//        }
//            break;
//
//        case wrongTwice: {
//            [UIView animateWithDuration:0.4 animations:^{
//                self.chineseLabel.alpha = 1;
//            }];
//        }
//            break;
//
//        case wrongThreeTime:
//            break;
//
//        default:
//            break;
//    }
//}

//- (void)CheckButtonView:(YXCheckButtonsView *)checkButtonView checkButton:(YXCheckButton *)checkButton {
//
//    [self.checkButtonView disableAllButtons];
//
//    if (self.wordQuestionModel.question.answer == checkButton.tag) {
//        checkButton.type = CheckTrue;
//    } else {
//        checkButton.type = CheckFalse;
//
//        switch (self.answerType) {
//            case start:
//                self.answerType = wrongOnce;
//                break;
//
//            case wrongOnce:
//                self.answerType = wrongTwice;
//                break;
//
//            case wrongTwice:
//                self.answerType = wrongThreeTime;
//                break;
//
//            case wrongThreeTime:
//                self.answerType = wrongThreeTime;
//                break;
//
//            default:
//                break;
//        }
//
//        __weak typeof(self) weakSelf = self;
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//            [weakSelf.checkButtonView resetAllButtons];
//        });
//    }
//}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        //        self.backgroundColor = UIColorOfHex(0xF6F8FA);
//        self.backgroundColor = UIColor.whiteColor;
//
//        self.wordLabel = [[UILabel alloc] init];
//        self.wordLabel.font = [UIFont boldSystemFontOfSize:24];
//        self.wordLabel.textColor = UIColorOfHex(0x485461);
//        self.wordLabel.text = @"小船，小艇；轮船";
//
//        self.partOfSpeechLabel = [[UILabel alloc] init];
//        self.partOfSpeechLabel.textColor = UIColorOfHex(0x485461);
//        self.partOfSpeechLabel.textAlignment = NSTextAlignmentLeft;
//        self.partOfSpeechLabel.text = @"n.";
//
//        self.lineView = [[UIView alloc] init];
//        self.lineView.backgroundColor = UIColorOfHex(0xE9EFF4);
//
//        self.englishLabel = [[UILabel alloc] init];
//        self.englishLabel.numberOfLines = 0;
//        self.englishLabel.textColor = UIColorOfHex(0x485461);
//        self.englishLabel.textAlignment = NSTextAlignmentLeft;
//        self.englishLabel.text = @"I need a ______ to cross the river.";
//
//        self.chineseLabel = [[UILabel alloc] init];
//        self.chineseLabel.numberOfLines = 0;
//        self.chineseLabel.textColor = UIColorOfHex(0x485461);
//        self.chineseLabel.textAlignment = NSTextAlignmentLeft;
//        self.chineseLabel.text = @"我需要一艘船渡河";
//
//        //        self.checkButtonView = [[YXCheckButtonsView alloc] init];
//        //        self.checkButtonView.delegate = self;
//
//        [self addSubview:self.wordLabel];
//        [self addSubview:self.partOfSpeechLabel];
//        [self addSubview:self.lineView];
//        [self addSubview:self.englishLabel];
//        [self addSubview:self.chineseLabel];
//        [self addSubview:self.checkButtonView];
//
//        self.lineView.alpha = 0;
//        self.englishLabel.alpha = 0;
//        self.chineseLabel.alpha = 0;
//
//        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(40);
//            make.left.equalTo(self).offset(20);
//        }];
//
//        [self.partOfSpeechLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.wordLabel.mas_bottom).offset(16);
//            make.left.equalTo(self).offset(20);
//        }];
//
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.partOfSpeechLabel.mas_bottom).offset(16);
//            make.left.equalTo(self).offset(20);
//            make.right.equalTo(self).offset(-20);
//            make.height.mas_equalTo(1);
//        }];
//
//        [self.englishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).offset(16);
//            make.right.equalTo(self).offset(-20);
//            make.left.equalTo(self).offset(20);
//        }];
//
//        [self.chineseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.englishLabel.mas_bottom).offset(8);
//            make.right.equalTo(self).offset(-20);
//            make.left.equalTo(self).offset(20);
//        }];
//
//        //        [self.checkButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //            make.bottom.equalTo(self);
//        //            make.left.equalTo(self);
//        //            make.right.equalTo(self);
//        //            make.height.mas_equalTo(388 > (SCREEN_HEIGHT * 0.5) ? (SCREEN_HEIGHT * 0.5) : 388);
//        //        }];
//    }
//    return self;
//}
