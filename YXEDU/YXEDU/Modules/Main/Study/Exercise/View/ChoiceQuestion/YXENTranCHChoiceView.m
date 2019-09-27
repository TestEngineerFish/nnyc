//
//  YXENTranCHVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/18.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXENTranCHChoiceView.h"
#import "NSString+YR.h"
#import "BSCommon.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import "NSString+YX.h"
#import "AVAudioPlayerManger.h"
#import "YXAPI.h"

#import "YXPinkProgressView.h"
#import "YXCheckButtonsView.h"

@interface YXENTranCHChoiceView ()
@property (nonatomic, weak) UIView *announceBGView;
@property (nonatomic, strong) UILabel *wordLabel;
//@property (nonatomic, strong) UIButton *speakButton;
@property (nonatomic, strong) UILabel *phoneticLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *descriptionImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;
//@property (nonatomic, strong) YXCheckButtonsView *checkButtonView;
@property (nonatomic, strong) YXAudioAnimations *speakButton;
@end

@implementation YXENTranCHChoiceView

- (void)setUpSubviews {
    [super setUpSubviews];

    UIView *announceBGView = [[UIView alloc] init];
    announceBGView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakButtonClicked:)];
    [announceBGView addGestureRecognizer:tap];
    
    
    self.wordLabel = [[UILabel alloc] init];
    self.wordLabel.font = [UIFont boldSystemFontOfSize:24];
    self.wordLabel.textColor = UIColorOfHex(0x485461);
    self.wordLabel.text = @"Coffee";
    
    self.speakButton = [YXAudioAnimations playSpeakerAnimation];
    self.speakButton.backgroundColor = [UIColor clearColor];
    [self.speakButton addTarget:self action:@selector(speakButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneticLabel = [[UILabel alloc] init];
    self.phoneticLabel.textColor = UIColorOfHex(0x55A7FD);
    self.phoneticLabel.text = @"英[knfi]";

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorOfHex(0xE9EFF4);
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = UIColorOfHex(0x485461);
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.text = @"Please give me a cup of coffee";
    
    self.descriptionImageView = [[UIImageView alloc] init];
    self.descriptionImageView.layer.cornerRadius = 8;
    self.descriptionImageView.layer.masksToBounds = YES;
    self.descriptionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.headerView addSubview:announceBGView];
    [self.headerView addSubview:self.wordLabel];
    [self.headerView addSubview:self.speakButton];
    [self.headerView addSubview:self.phoneticLabel];
    [self.headerView addSubview:self.lineView];
    [self.headerView addSubview:self.descriptionImageView];
    [self.headerView addSubview:self.descriptionLabel];
    
    self.lineView.alpha = 0;
    self.descriptionLabel.alpha = 0;
    self.descriptionImageView.alpha = 0;
    
    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.speakButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wordLabel.mas_bottom).offset(8);
        make.height.width.mas_equalTo(20);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.phoneticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speakButton.mas_right).offset(4);
        make.centerY.equalTo(self.speakButton);
    }];
    
    [announceBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.wordLabel);
        make.bottom.equalTo(self.speakButton);
        make.width.mas_equalTo(AdaptSize(150));
    }];
    
    [self lineView];
    [self descriptionLabel];
    [self descriptionImageView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakButton.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.descriptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.descriptionLabel);
        make.left.equalTo(self).offset(20);
        make.height.width.mas_equalTo(0.1);
    }];

    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(16);
        make.left.equalTo(self.descriptionImageView.mas_right);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.speakButton.mas_bottom).priority(MASLayoutPriorityDefaultLow);
    }];
    
//    [self playWordSound];
}

- (void)didEndTransAnimated {
    [super didEndTransAnimated];
    [self playWordSound];
}


- (void)speakButtonClicked:(id)sender {
    [self.speakButton startAnimating];
    [self playWordSound];
}

- (void)wordSoundPlayFinished {
    [self.speakButton stopAnimating];
}

- (void)reloadData {
    [super reloadData];
    self.answerType = start;

    YXWordDetailModel *word = self.wordQuestionModel.wordDetail;
    self.wordLabel.text = word.word;
    if ([YXConfigure shared].isUsStyle) {
        self.phoneticLabel.text = word.usphone;
    } else {
        self.phoneticLabel.text = word.ukphone;
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.baseConfig.cdn,word.image];
    [self.descriptionImageView sd_setImageWithURL:[NSURL URLWithString: URLString] placeholderImage:[UIImage imageNamed:@"wordPlaceHolderImage"]];
    
//    NSString *str = [NSString stringWithFormat:@"%@fsbjfbsbfsfbsfb,sdfns,dnfs,fdshjkfsdfdasdasdsadsagfhsgfjgsdjhgfhjsdgfsjhgfdsgfjshdgfhdsjgfdsjfgshjdgfsdhjfgdhsjgfhdjsfgj",word.eng];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithData:[word.eng dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
    NSRange range = NSMakeRange(0, attriStr.length);
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    
    self.descriptionLabel.attributedText = attriStr;

//    NSArray *answers = self.wordQuestionModel.question.options;
//    [self.checkButtonView configureButtonsWithType:@"2" titles:answers];
}

- (void)firstTimeAnswerWorng {
    [super firstTimeAnswerWorng];
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.descriptionLabel.mas_bottom).priority(MASLayoutPriorityDefaultMedium);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
        self.lineView.alpha = 1;
        self.descriptionLabel.alpha = 1;
    }];
}

- (void)secondTimeAnswerWorng {
    [super secondTimeAnswerWorng];
    if (self.wordDetailModel.hasImage) {
        self.descriptionLabel.alpha = 0;
        
        [self.descriptionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(56);
        }];
        
        [self.descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descriptionImageView.mas_right).offset(16);
            make.centerY.equalTo(self.descriptionImageView);
        }];
        
        CGFloat width = self.frame.size.width - 56 - 16 - 40;
        CGSize size = [self.descriptionLabel.attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                         context:nil].size;
        if (size.height < 56) {
            [self.descriptionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView).offset(16);
            }];
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.descriptionImageView.mas_bottom).priority(MASLayoutPriorityDefaultHigh);
            }];
        }

        [UIView animateWithDuration:0.4 animations:^{
            [self layoutIfNeeded];
            self.descriptionLabel.alpha = 1;
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
