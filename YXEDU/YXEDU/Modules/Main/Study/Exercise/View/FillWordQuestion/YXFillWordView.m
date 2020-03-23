//
//  YXFillWordView.m
//  YXEDU
//
//  Created by Jake To on 10/31/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXFillWordView.h"
#import "YXPinkProgressView.h"
#import "YXCheckButtonsView.h"

@interface YXFillWordView ()

@property (nonatomic, strong) UILabel     *englishLabel;
@property (nonatomic, strong) UILabel     *chineseLabel;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UIImageView *descriptionImageView;
@property (nonatomic, strong) UILabel     *phoneticLabel;

@end

@implementation YXFillWordView
- (void)setUpSubviews {
    [super setUpSubviews];
    self.englishLabel = [[UILabel alloc] init];
    self.englishLabel.font = [UIFont boldSystemFontOfSize:24];
    self.englishLabel.textAlignment = NSTextAlignmentLeft;
    self.englishLabel.numberOfLines = 0;
    self.englishLabel.textColor = UIColorOfHex(0x485461);
    self.englishLabel.text = @"We have other plans on _____ wednesday afternoon";

    self.chineseLabel = [[UILabel alloc] init];
    self.chineseLabel.textColor = UIColorOfHex(0x485461);
    self.chineseLabel.textAlignment = NSTextAlignmentLeft;
    self.chineseLabel.numberOfLines = 0;
    self.chineseLabel.text = @"你要来一杯咖啡吗？";

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorOfHex(0xE9EFF4);
    
    self.phoneticLabel = [[UILabel alloc] init];
    self.phoneticLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneticLabel.textColor = UIColorOfHex(0x55A7FD);
    self.phoneticLabel.text = @"英[knfi]";
    
    self.descriptionImageView = [[UIImageView alloc] init];
    self.descriptionImageView.layer.cornerRadius = 8;
    self.descriptionImageView.layer.masksToBounds = YES;
    self.descriptionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.headerView addSubview:self.englishLabel];
    [self.headerView addSubview:self.chineseLabel];
    [self.headerView addSubview:self.lineView];
    [self.headerView addSubview:self.descriptionImageView];
    [self.headerView addSubview:self.phoneticLabel];

    self.lineView.alpha = 0;
    self.phoneticLabel.alpha = 0;
    self.descriptionImageView.alpha = 0;
    
    [self.englishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.chineseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.englishLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.englishLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chineseLabel.mas_bottom).offset(16);
        make.left.right.equalTo(self.englishLabel);
        make.height.mas_equalTo(1);
    }];
    
    [self.phoneticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(16);
        make.left.equalTo(self.descriptionImageView.mas_right);
    }];
    
    [self.descriptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneticLabel);
        make.left.equalTo(self).offset(20);
        make.height.width.mas_equalTo(0.1);
    }];
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chineseLabel.mas_bottom).priority(MASLayoutPriorityDefaultLow);
    }];
}


- (void)reloadData {
    [super reloadData];
    self.answerType = start;

    YXWordDetailModel *word = self.wordQuestionModel.wordDetail;

    NSString *filerStr = @"<font ([^\"]*)>(.*?)</font>";
    NSError *error;
    NSString *newStr = word.eng;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:filerStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSTextCheckingResult *match = [regex firstMatchInString:word.eng options:NSMatchingReportProgress range:NSMakeRange(0, word.eng.length)];
        if (match) {
            newStr = [word.eng stringByReplacingCharactersInRange:match.range withString:@"_______"];
        }
    }else {
        YXEventLog(@"%@",error);
    }
    
//    NSRange startRange = [word.eng rangeOfString:@"<font"];
//    NSRange endRange = [word.eng rangeOfString:@"font>"];
//    NSString *prefixString = [word.eng substringToIndex:startRange.location];
//    NSString *suffixString = [word.eng substringFromIndex:endRange.location + endRange.length];
//    NSString *string = [NSString stringWithFormat:@"%@______%@",prefixString,suffixString];
    self.englishLabel.text = newStr;
    self.chineseLabel.text = word.chs;
    
    if ([YXConfigure shared].confModel.baseConfig.speech == 1) {
        self.phoneticLabel.text = word.usphone;
    } else {
        self.phoneticLabel.text = word.ukphone;
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.baseConfig.cdn,word.image];
    [self.descriptionImageView sd_setImageWithURL:[NSURL URLWithString: URLString] placeholderImage:[UIImage imageNamed:@"wordPlaceHolderImage"]];
}

- (void)firstTimeAnswerWorng {
    [super firstTimeAnswerWorng];
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.phoneticLabel.mas_bottom).priority(MASLayoutPriorityDefaultMedium);
        //        make.bottom.equalTo(self.descriptionLabel.mas_bottom).priority(MASLayoutPriorityDefaultMedium);
        //        make.bottom.equalTo(self.descriptionImageView.mas_bottom).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
        self.lineView.alpha = 1;
        self.phoneticLabel.alpha = 1;
    }];
}

- (void)secondTimeAnswerWorng {
    [super secondTimeAnswerWorng];
    if (self.wordDetailModel.hasImage) {
        self.phoneticLabel.alpha = 0;
        
        [self.descriptionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(16);
            make.width.height.mas_equalTo(56);
        }];
        
        [self.phoneticLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descriptionImageView.mas_right).offset(16);
//            make.centerY.equalTo(self.descriptionImageView);
        }];
    
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.descriptionImageView.mas_bottom).priority(MASLayoutPriorityDefaultHigh);
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutIfNeeded];
            self.phoneticLabel.alpha = 1;
            self.descriptionImageView.alpha = 1;
        }];
    }else {
        [self showWordDetail];
    }

}

- (void)thirdTimeAnswerWorng {
    [super thirdTimeAnswerWorng];
}


@end

















//- (void)setAnswerType:(YXAnswerType)answerType {
//    _answerType = answerType;
//    switch (answerType) {
//        case start:
//            self.lineView.alpha = 0;
//            self.phoneticLabel.alpha = 0;
//            self.descriptionImageView.alpha = 0;
//
//            break;
//
//        case wrongOnce: {
//            [self.englishLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self).offset(20);
//            }];
//
//            [UIView animateWithDuration:0.4 animations:^{
//
//                [self layoutIfNeeded];
//
//                self.lineView.alpha = 1;
//                self.phoneticLabel.alpha = 1;
//            }];
//        }
//            break;
//
//        case wrongTwice: {
//            self.phoneticLabel.alpha = 0;
//
//            [self.phoneticLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self).offset(20 + 56 + 16);
//                make.right.equalTo(self).offset(-20);
//                make.centerY.equalTo(self.descriptionImageView);
//            }];
//
//            [self layoutIfNeeded];
//
//            [UIView animateWithDuration:0.4 animations:^{
//                self.phoneticLabel.alpha = 1;
//                self.descriptionImageView.alpha = 1;
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
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = UIColor.whiteColor;
//
//        self.englishLabel = [[UILabel alloc] init];
//        self.englishLabel.font = [UIFont boldSystemFontOfSize:24];
//        self.englishLabel.textAlignment = NSTextAlignmentLeft;
//        self.englishLabel.numberOfLines = 0;
//        self.englishLabel.textColor = UIColorOfHex(0x485461);
//        self.englishLabel.text = @"We have other plans on _____ wednesday afternoon";
//
//        self.chineseLabel = [[UILabel alloc] init];
//        self.chineseLabel.textColor = UIColorOfHex(0x485461);
//        self.chineseLabel.textAlignment = NSTextAlignmentLeft;
//        self.chineseLabel.numberOfLines = 0;
//        self.chineseLabel.text = @"你要来一杯咖啡吗？";
//
//        self.lineView = [[UIView alloc] init];
//        self.lineView.backgroundColor = UIColorOfHex(0xE9EFF4);
//
//        self.phoneticLabel = [[UILabel alloc] init];
//        self.phoneticLabel.textAlignment = NSTextAlignmentLeft;
//        self.phoneticLabel.textColor = UIColorOfHex(0x55A7FD);
//        self.phoneticLabel.text = @"英[knfi]";
//
//        self.descriptionImageView = [[UIImageView alloc] init];
//        self.descriptionImageView.layer.cornerRadius = 8;
//        self.descriptionImageView.layer.masksToBounds = YES;
//        self.descriptionImageView.contentMode = UIViewContentModeScaleAspectFit;
//
//        //        self.checkButtonView = [[YXCheckButtonsView alloc] init];
//        //        self.checkButtonView.delegate = self;
//
//        [self addSubview:self.englishLabel];
//        [self addSubview:self.chineseLabel];
//        [self addSubview:self.lineView];
//        [self addSubview:self.descriptionImageView];
//        [self addSubview:self.phoneticLabel];
//        //        [self addSubview:self.checkButtonView];
//
//        [self.englishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(40);
//            make.right.equalTo(self).offset(-20);
//            make.left.equalTo(self).offset(20);
//        }];
//
//        [self.chineseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.englishLabel.mas_bottom).offset(6);
//            make.right.equalTo(self).offset(-20);
//            make.left.equalTo(self).offset(20);
//        }];
//
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.chineseLabel.mas_bottom).offset(16);
//            make.left.equalTo(self).offset(20);
//            make.right.equalTo(self).offset(-20);
//            make.height.mas_equalTo(1);
//        }];
//
//        [self.phoneticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).offset(16);
//            make.left.equalTo(self).offset(20);
//        }];
//
//        [self.descriptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).offset(16);
//            make.left.equalTo(self).offset(20);
//            make.height.width.mas_equalTo(56);
//        }];
//
//        //        [self.checkButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //            make.bottom.equalTo(self);
//        //            make.left.equalTo(self);
//        //            make.right.equalTo(self);
//        //            make.height.mas_equalTo(388 > (SCREEN_HEIGHT * 0.5) ? (SCREEN_HEIGHT * 0.5) : 388);
//        //        }];
//
//    }
//    return self;
//}
//
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
