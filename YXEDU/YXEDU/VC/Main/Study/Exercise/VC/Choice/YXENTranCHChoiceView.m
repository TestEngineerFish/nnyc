//
//  YXENTranCHVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/18.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXENTranCHChoiceView.h"
#import "YXGraphSingleBtnView.h"
#import "NSString+YR.h"
#import "BSCommon.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import "NSString+YX.h"
#import "AVAudioPlayerManger.h"
#import "YXCommHeader.h"

@interface YXENTranCHChoiceView ()
@property (nonatomic, strong) UIButton *speakBtn;
@property (nonatomic, strong) UILabel *wordLab;
@property (nonatomic, strong) UILabel *phoneticLab;
@property (nonatomic, strong) UIView *wordView;
@property (nonatomic, strong) UIView *wordSpeakView;

@property (nonatomic, strong) UIImageView *singleLine;
@property (nonatomic, strong) UILabel *sentenceLab;
@property (nonatomic, strong) UILabel *translateLab;

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) YXGraphSingleBtnView *singleOneView;
@property (nonatomic, strong) YXGraphSingleBtnView *singleTwoView;
@property (nonatomic, strong) YXGraphSingleBtnView *singleThreeView;
@property (nonatomic, strong) YXGraphSingleBtnView *singleFourView;
@end

@implementation YXENTranCHChoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)configureAnswerModel {
    self.singleOneView.answerModel.type = @"2";
    self.singleOneView.answerModel.answer = @"0";
    
    self.singleTwoView.answerModel.type = @"2";
    self.singleTwoView.answerModel.answer = @"1";
    
    self.singleThreeView.answerModel.type = @"2";
    self.singleThreeView.answerModel.answer = @"2";
    
    self.singleFourView.answerModel.type = @"2";
    self.singleFourView.answerModel.answer = @"3";
}

- (void)speakBtnClicked:(id)sender {
    YXStudyBookUnitModel *unitModel = [YXConfigure shared].bookUnitModel;
    NSString *name = [[unitModel.bookid DIR:unitModel.unitid]DIR:unitModel.filename];
    NSString *resourcePath = [[YXUtils resourcePath]DIR:name];
    NSURL *voicePath = nil;
    if ([YXConfigure shared].isUSVoice) {
        voicePath = [NSURL fileURLWithPath:[resourcePath DIR:[YXStudyCmdCenter shared].curUnitInfo.ukvoice]];
    } else {
        voicePath = [NSURL fileURLWithPath:[resourcePath DIR:[YXStudyCmdCenter shared].curUnitInfo.usvoice]];
    }
    [[AVAudioPlayerManger shared]startPlay:voicePath];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        [self recreateSubViews];
        if ([YXConfigure shared].isNeedPlayAudio) {
            [self speakBtnClicked:nil];
        }
    } else {
        [self removeAllSubViews];
    }
}

- (void)recreateSubViews {
    // TODO::
    [self wordView];
    
    [self wordSpeakView];
    
    [self speakBtn];
    
    [self wordLab];
    
    [self phoneticLab];
    
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
    RELEASE(_wordView);
    RELEASE(_wordSpeakView);
    RELEASE(_speakBtn);
    RELEASE(_wordLab);
    RELEASE(_phoneticLab);
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
    self.wordLab.text = [YXStudyCmdCenter shared].curUnitInfo.word;
    if ([YXConfigure shared].isUSVoice) {
        self.phoneticLab.text = [YXStudyCmdCenter shared].curUnitInfo.usphone;
    } else {
        self.phoneticLab.text = [YXStudyCmdCenter shared].curUnitInfo.ukphone;
    }
    
    // reset frame
    CGFloat phoneticWidth = [self.phoneticLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.phoneticLab.font].width;
    CGFloat wordWidth = [self.wordLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.wordLab.font].width;
    CGFloat wordViewWidth = wordWidth + 36 + 16;
    self.wordSpeakView.frame = CGRectMake((SCREEN_WIDTH - wordViewWidth)/2.0, 0, wordViewWidth, 62);
    self.wordLab.frame = CGRectMake(36, -5, wordWidth, 40);
    self.phoneticLab.frame = CGRectMake(36+wordWidth/2.0-phoneticWidth/2.0, 36, phoneticWidth, 22);
    
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
    if ([YXStudyCmdCenter shared].answerType != YXAnswerEnglishTranslationChineseRight) {
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
    __weak YXENTranCHChoiceView *weakSelf = self;
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
        case YXAnswerEnglishTranslationChineseState: {
            self.wordView.frame = CGRectMake(0, 48, SCREEN_WIDTH, 62);
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
        case YXAnswerEnglishTranslationChineseWrong1: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = NO;
            self.translateLab.hidden = YES;
            
            [UIView animateWithDuration:duration animations:^{
                self.wordView.frame = CGRectMake(0, 16, SCREEN_WIDTH, 62);
                self.singleLine.frame = CGRectMake(0, 102, SCREEN_WIDTH, 3);
                CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:[UIFont systemFontOfSize:18]];
                self.sentenceLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.singleLine.frame)+24, SCREEN_WIDTH-65, sentenceSize.height);
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case YXAnswerEnglishTranslationChineseWrong2: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = YES;
            self.translateLab.hidden = NO;
            self.wordView.frame = CGRectMake(0, 16, SCREEN_WIDTH, 62);
            self.singleLine.frame = CGRectMake(0, 102, SCREEN_WIDTH, 3);
            [UIView animateWithDuration:duration animations:^{
                CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
                self.translateLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.singleLine.frame)+24, SCREEN_WIDTH-65, translateLabSize.height);
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case YXAnswerEnglishTranslationChineseWrong3:
            
            break;
            
        default:
            break;
    }
}

#pragma mark -lazy load view-
- (UIView *)wordView {
    if (!_wordView) {
        _wordView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 52)];
        _wordView.backgroundColor = [UIColor clearColor];
        [self addSubview:_wordView];
    }
    return _wordView;
}

- (UIView *)wordSpeakView {
    if (!_wordSpeakView) {
        _wordSpeakView = [[UIView alloc]init];
        [self.wordView addSubview:_wordSpeakView];
    }
    return _wordSpeakView;
}

- (UIButton *)speakBtn {
    if (!_speakBtn) {
        _speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speakBtn setImage:[UIImage imageNamed:@"study_speak"] forState:UIControlStateNormal];
        [_speakBtn addTarget:self action:@selector(speakBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_speakBtn setFrame:CGRectMake(0, 2, 28, 28)];
        [self.wordSpeakView addSubview:_speakBtn];
    }
    return _speakBtn;
}

- (UILabel *)wordLab {
    if (!_wordLab) {
        _wordLab = [[UILabel alloc]init];
        _wordLab.text = @"coffee";
        _wordLab.font = [UIFont boldSystemFontOfSize:36];;
        _wordLab.textColor = UIColorOfHex(0x2BB1F3);
        _wordLab.textAlignment = NSTextAlignmentCenter;
        [self.wordSpeakView addSubview:_wordLab];
    }
    return _wordLab;
}

- (UILabel *)phoneticLab {
    if (!_phoneticLab) {
        _phoneticLab = [[UILabel alloc]init];
        _phoneticLab.text = @"coffee";
        _phoneticLab.font = [UIFont boldSystemFontOfSize:18];
        _phoneticLab.textColor = UIColorOfHex(0x666666);
        _phoneticLab.textAlignment = NSTextAlignmentCenter;
        [self.wordSpeakView addSubview:_phoneticLab];
    }
    return _phoneticLab;
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
        [self.selectView addSubview:_singleOneView];
    }
    return _singleOneView;
}

- (YXGraphSingleBtnView *)singleTwoView {
    if (!_singleTwoView) {
        _singleTwoView = [[YXGraphSingleBtnView alloc]initWithFrame:CGRectMake(16, 70, SCREEN_WIDTH-32, 54)];
        [_singleTwoView addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:_singleTwoView];
    }
    return _singleTwoView;
}

- (YXGraphSingleBtnView *)singleThreeView {
    if (!_singleThreeView) {
        _singleThreeView = [[YXGraphSingleBtnView alloc]initWithFrame:CGRectMake(16, 140, SCREEN_WIDTH-32, 54)];
        [_singleThreeView addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:_singleThreeView];
    }
    return _singleThreeView;
}

- (YXGraphSingleBtnView *)singleFourView {
    if (!_singleFourView) {
        _singleFourView = [[YXGraphSingleBtnView alloc]initWithFrame:CGRectMake(16, 210, SCREEN_WIDTH-32, 54)];
        [_singleFourView addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:_singleFourView];
    }
    return _singleFourView;
}

@end
