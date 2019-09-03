//
//  YXCHTranENChoiceVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/18.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCHTranENChoiceView.h"
#import "YXGraphSingleBtnView.h"
#import "NSString+YR.h"
#import "BSCommon.h"
#import "YXCommHeader.h"

@interface YXCHTranENChoiceView ()

@property (nonatomic, strong) UIView *chineseView;
@property (nonatomic, strong) UILabel *chineseLab;
@property (nonatomic, strong) UILabel *attributeLab;

@property (nonatomic, strong) UIImageView *singleLine;
@property (nonatomic, strong) UILabel *sentenceLab;
@property (nonatomic, strong) UILabel *translateLab;

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) YXGraphSingleBtnView *singleOneView;
@property (nonatomic, strong) YXGraphSingleBtnView *singleTwoView;
@property (nonatomic, strong) YXGraphSingleBtnView *singleThreeView;
@property (nonatomic, strong) YXGraphSingleBtnView *singleFourView;
@end

@implementation YXCHTranENChoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)configureAnswerModel {
    self.singleOneView.answerModel.type = @"3";
    self.singleOneView.answerModel.answer = @"0";
    
    self.singleTwoView.answerModel.type = @"3";
    self.singleTwoView.answerModel.answer = @"1";
    
    self.singleThreeView.answerModel.type = @"3";
    self.singleThreeView.answerModel.answer = @"2";
    
    self.singleFourView.answerModel.type = @"3";
    self.singleFourView.answerModel.answer = @"3";
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        [self recreateSubViews];
    } else {
        [self removeAllSubViews];
    }
}

- (void)recreateSubViews {
    // TODO::
    [self chineseView];
    [self chineseLab];
    [self attributeLab];
    
    // 线条
    [self singleLine];
    
    // 提示例句
    [self sentenceLab];
    // 翻译
    [self translateLab];
    
    [self selectView];
    
    [self singleOneView];
    
    [self singleTwoView];
    
    [self singleThreeView];
    
    [self singleFourView];
    
    [self configureAnswerModel];
    [self reloadData];
}

- (void)removeAllSubViews {
    RELEASE(_chineseView);
    RELEASE(_chineseLab);
    RELEASE(_attributeLab);
    RELEASE(_singleLine);
    RELEASE(_sentenceLab);
    RELEASE(_translateLab);
    RELEASE(_selectView);
    RELEASE(_singleOneView);
    RELEASE(_singleTwoView);
    RELEASE(_singleThreeView);
    RELEASE(_singleFourView);
}

- (void)reloadData {
    self.chineseLab.text = [YXStudyCmdCenter shared].curUnitInfo.paraphrase;
    self.attributeLab.text = [YXStudyCmdCenter shared].curUnitInfo.property;
    
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
    muParagraph.lineSpacing = 0; // 行距
    muParagraph.paragraphSpacing = 0; // 段距
    muParagraph.firstLineHeadIndent = 0; // 首行缩进
    
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[[YXStudyCmdCenter shared].curUnitInfo.eng dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, attrStr.string.length)];
    // 设置段落样式
    [attrStr addAttribute:NSParagraphStyleAttributeName value:muParagraph range:NSMakeRange(0, attrStr.string.length)];
    self.sentenceLab.attributedText = attrStr;
    CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:[UIFont systemFontOfSize:18]];
    self.sentenceLab.frame = CGRectMake(32.5, 129, SCREEN_WIDTH-65, sentenceSize.height);
    
    self.translateLab.text = [NSString stringWithFormat:@"%@ %@", [YXStudyCmdCenter shared].curUnitInfo.property, [YXStudyCmdCenter shared].curUnitInfo.paraphrase];
    CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
    self.translateLab.frame = CGRectMake(32.5, 129, SCREEN_WIDTH-65, translateLabSize.height);
    
    
    YXStudyBookUnitTopicModel *topic = [[YXStudyCmdCenter shared]curTopic];
    self.singleOneView.titleLab.text = topic.options[0];
    self.singleTwoView.titleLab.text = topic.options[1];
    self.singleThreeView.titleLab.text = topic.options[2];
    self.singleFourView.titleLab.text = topic.options[3];
}


- (void)singleBtnClicked:(id)sender {
    [self disableAll];
    [self enableAll:sender];
    YXGraphSingleBtnView *singleView = (YXGraphSingleBtnView *)sender;
    
    // 输入答案
    [[YXStudyCmdCenter shared]enterAnswer:singleView.answerModel];
    if ([YXStudyCmdCenter shared].answerType != YXAnswerChineseTranslationEnglishRight) {
        singleView.selectType = YXSingleSelectFalse;
    } else {
        singleView.selectType = YXSingleSelectRight;
    }
}

- (void)disableAll {
    self.singleOneView.userInteractionEnabled = NO;
    self.singleTwoView.userInteractionEnabled = NO;
    self.singleThreeView.userInteractionEnabled = NO;
    self.singleFourView.userInteractionEnabled = NO;
}

- (void)enableAll:(id)sender {
    __weak YXCHTranENChoiceView *weakSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [weakSelf resetAllBtn:sender];
    });
}

- (void)resetAllBtn:(id)sender {
    self.answerType = [YXStudyCmdCenter shared].answerType;
    
    self.singleOneView.userInteractionEnabled = YES;
    self.singleTwoView.userInteractionEnabled = YES;
    self.singleThreeView.userInteractionEnabled = YES;
    self.singleFourView.userInteractionEnabled = YES;
    
    self.singleOneView.selectType = YXSingleSelectNone;
    self.singleTwoView.selectType = YXSingleSelectNone;
    self.singleThreeView.selectType = YXSingleSelectNone;
    self.singleFourView.selectType = YXSingleSelectNone;
}

- (void)setAnswerType:(YXAnswerType)answerType {
    _answerType = answerType;
    switch (answerType) {
        case YXAnswerChineseTranslationEnglishState: {
            self.chineseView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 62);
            CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:[UIFont systemFontOfSize:18]];
            self.sentenceLab.frame = CGRectMake(32.5, CGRectGetMinY(self.selectView.frame)-sentenceSize.height, SCREEN_WIDTH-65, sentenceSize.height);
            self.singleLine.frame = CGRectMake(0, CGRectGetMinY(self.sentenceLab.frame)-10, SCREEN_WIDTH, 3);
            
            CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
            self.translateLab.frame = CGRectMake(32.5, CGRectGetMinY(self.selectView.frame)-translateLabSize.height, SCREEN_WIDTH-65, translateLabSize.height);
            
            self.singleLine.hidden = YES;
            self.sentenceLab.hidden = YES;
            self.translateLab.hidden = YES;
        }
            break;
        case YXAnswerChineseTranslationEnglishWrong1: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = NO;
            self.translateLab.hidden = YES;
            [UIView animateWithDuration:duration animations:^{
                self.chineseView.frame = CGRectMake(0, 16, SCREEN_WIDTH, 62);
                self.singleLine.frame = CGRectMake(0, 102, SCREEN_WIDTH, 3);
                CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:[UIFont systemFontOfSize:18]];
                self.sentenceLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.singleLine.frame)+24, SCREEN_WIDTH-65, sentenceSize.height);
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case YXAnswerChineseTranslationEnglishWrong2: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = YES;
            self.translateLab.hidden = NO;
            self.chineseView.frame = CGRectMake(0, 16, SCREEN_WIDTH, 62);
            self.singleLine.frame = CGRectMake(0, 102, SCREEN_WIDTH, 3);
            [UIView animateWithDuration:duration animations:^{
                CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
                self.translateLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.singleLine.frame)+24, SCREEN_WIDTH-65, translateLabSize.height);
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case YXAnswerChineseTranslationEnglishWrong3:
            
            break;
        default:
            break;
    }
}

- (UIView *)chineseView {
    if (!_chineseView) {
        _chineseView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 62)];
        _chineseView.backgroundColor = [UIColor clearColor];
        [self addSubview:_chineseView];
    }
    return _chineseView;
}

- (UILabel *)chineseLab {
    if (!_chineseLab) {
        _chineseLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _chineseLab.textColor =UIColorOfHex(0x2BB1F3);
        _chineseLab.font = [UIFont systemFontOfSize:32];
        _chineseLab.textAlignment = NSTextAlignmentCenter;
        _chineseLab.text = @"小船，艇";
        [self.chineseView addSubview:_chineseLab];
    }
    return _chineseLab;
}

- (UILabel *)attributeLab {
    if (!_attributeLab) {
        _attributeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 22)];
        _attributeLab.textColor =UIColorOfHex(0x666666);
        _attributeLab.font = [UIFont systemFontOfSize:18];
        _attributeLab.textAlignment = NSTextAlignmentCenter;
        _attributeLab.text = @"n.";
        [self.chineseView addSubview:_attributeLab];
    }
    return _attributeLab;
}

- (UIImageView *)singleLine {
    if (!_singleLine) {
        _singleLine = [[UIImageView alloc]init];
        _singleLine.image = [UIImage imageNamed:@"single_line"];
        [self addSubview:_singleLine];
    }
    return _singleLine;
}

- (UILabel *)sentenceLab {
    if (!_sentenceLab) {
        _sentenceLab = [[UILabel alloc]init];
        _sentenceLab.font = [UIFont systemFontOfSize:18];
        _sentenceLab.numberOfLines = 0;
        [self addSubview:_sentenceLab];
    }
    return _sentenceLab;
}

- (UILabel *)translateLab {
    if (!_translateLab) {
        _translateLab = [[UILabel alloc]init];
        _translateLab.font = [UIFont systemFontOfSize:16];
        _translateLab.textColor = UIColorOfHex(0x333333);
        _translateLab.textAlignment = NSTextAlignmentCenter;
        _translateLab.lineBreakMode = NSLineBreakByWordWrapping;
        _translateLab.text = @"n.一种交通工具;\nvi.沉船\nvt.用船运输;";
        _translateLab.numberOfLines = 0;
        [self addSubview:_translateLab];
    }
    return _translateLab;
}

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        if (iPhone4) {
            _selectView.frame = CGRectMake(0, SCREEN_HEIGHT-264-NavHeight, SCREEN_WIDTH, 264);
        } else if (iPhone5) {
            _selectView.frame = CGRectMake(0, 198, SCREEN_WIDTH, 264);
        } else {
            _selectView.frame = CGRectMake(0, SCREEN_HEIGHT-NavHeight-SafeBottomMargin-264-130, SCREEN_WIDTH, 264);
        }
        [self addSubview:_selectView];
    }
    return _selectView;
}

- (YXGraphSingleBtnView *)singleOneView {
    if (!_singleOneView) {
        _singleOneView = [[YXGraphSingleBtnView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 54)];
        [_singleOneView addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _singleOneView.titleLab.font = [UIFont systemFontOfSize:18];
        [self.selectView addSubview:_singleOneView];
    }
    return _singleOneView;
}

- (YXGraphSingleBtnView *)singleTwoView {
    if (!_singleTwoView) {
        _singleTwoView = [[YXGraphSingleBtnView alloc]initWithFrame:CGRectMake(16, 70, SCREEN_WIDTH-32, 54)];
        [_singleTwoView addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _singleTwoView.titleLab.font = [UIFont systemFontOfSize:18];
        [self.selectView addSubview:_singleTwoView];
    }
    return _singleTwoView;
}

- (YXGraphSingleBtnView *)singleThreeView {
    if (!_singleThreeView) {
        _singleThreeView = [[YXGraphSingleBtnView alloc]initWithFrame:CGRectMake(16, 140, SCREEN_WIDTH-32, 54)];
        [_singleThreeView addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _singleThreeView.titleLab.font = [UIFont systemFontOfSize:18];
        [self.selectView addSubview:_singleThreeView];
    }
    return _singleThreeView;
}

- (YXGraphSingleBtnView *)singleFourView {
    if (!_singleFourView) {
        _singleFourView = [[YXGraphSingleBtnView alloc]initWithFrame:CGRectMake(16, 210, SCREEN_WIDTH-32, 54)];
        [_singleFourView addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _singleFourView.titleLab.font = [UIFont systemFontOfSize:18];
        [self.selectView addSubview:_singleFourView];
    }
    return _singleFourView;
}

@end
