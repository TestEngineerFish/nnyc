//
//  YXGraphSelectView.m
//  YXEDU
//
//  Created by shiji on 2018/4/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphSelectView.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import "NSString+YX.h"
#import "UIImageView+WebCache.h"
#import "AVAudioPlayerManger.h"
#import "YXAPI.h"


@interface YXGraphSelectButton ()

@property (nonatomic, strong) UIImageView *resultImage;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation YXGraphSelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.0;
        self.layer.borderWidth = 1.5f;
        self.layer.borderColor = UIColorOfHex(0xDCDCDC).CGColor;
        self.exclusiveTouch = YES;
        
        self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.titleImage];
        
        self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.maskView.backgroundColor = UIColorOfHex(0xffffff);
        self.maskView.alpha = 0.3;
        [self addSubview:self.maskView];
        self.maskView.hidden = YES;
        
        self.resultImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/4.0, frame.size.height/4.0, frame.size.width/2.0, frame.size.height/2.0)];
        [self addSubview:self.resultImage];
        self.resultImage.hidden = YES;
        
        self.answerModel = [[YXAnswerModel alloc]init];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    self.titleImage.image = image;
}

- (void)setSelectType:(YXGraphSelectType)selectType {
    _selectType = selectType;
    switch (_selectType) {
        case YXGraphSelectNone: {
            self.layer.borderColor = UIColorOfHex(0xDCDCDC).CGColor;
            self.resultImage.hidden = YES;
            self.maskView.hidden = YES;
        }
            break;
        case YXGraphSelectRight: {
            self.layer.borderColor = UIColorOfHex(0x7AC70C).CGColor;
            self.resultImage.hidden = NO;
            self.resultImage.image = [UIImage imageNamed:@"study_word_right"];
            self.maskView.hidden = NO;
        }
            break;
        case YXGraphSelectFalse: {
            self.layer.borderColor = UIColorOfHex(0xD33131).CGColor;
            self.resultImage.hidden = NO;
            self.resultImage.image = [UIImage imageNamed:@"study_word_wrong"];
            self.maskView.hidden = NO;
        }
            break;
        default:
            break;
    }
}




@end


@interface YXGraphSelectView ()
@property (nonatomic, strong) UIButton *speakBtn;
@property (nonatomic, strong) UILabel *wordLab;
@property (nonatomic, strong) UILabel *phoneticLab;
@property (nonatomic, strong) UIView *wordView;
@property (nonatomic, strong) UIView *wordSpeakView;

@property (nonatomic, strong) UILabel *sentenceLab;
@property (nonatomic, strong) UIImageView *singleLine;
@property (nonatomic, strong) UILabel *translateLab;

@property (nonatomic, strong) YXGraphSelectButton *leftTopBtn;
@property (nonatomic, strong) YXGraphSelectButton *rightTopBtn;
@property (nonatomic, strong) YXGraphSelectButton *leftBottomBtn;
@property (nonatomic, strong) YXGraphSelectButton *rightBottomBtn;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation YXGraphSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)configureAnswerModel {
    self.leftTopBtn.answerModel.type = @"1";
    self.leftTopBtn.answerModel.answer = @"0";
    
    self.rightTopBtn.answerModel.type = @"1";
    self.rightTopBtn.answerModel.answer = @"1";
    
    self.leftBottomBtn.answerModel.type = @"1";
    self.leftBottomBtn.answerModel.answer = @"2";
    
    self.rightBottomBtn.answerModel.type = @"1";
    self.rightBottomBtn.answerModel.answer = @"3";
}

- (void)setAnswerType:(YXAnswerType)answerType {
    _answerType = answerType;
    switch (answerType) {
        case YXAnswerSelectImageState: {
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
        case YXAnswerSelectImageWrong1: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = NO;
            self.translateLab.hidden = YES;
            CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:[UIFont systemFontOfSize:18]];
            [UIView animateWithDuration:duration animations:^{
                self.wordView.frame = CGRectMake(0, 16, SCREEN_WIDTH, 62);
                self.singleLine.frame = CGRectMake(0, 102, SCREEN_WIDTH, 3);
                self.sentenceLab.frame = CGRectMake(32.5, 129, SCREEN_WIDTH-65, sentenceSize.height);
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case YXAnswerSelectImageWrong2: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = YES;
            self.translateLab.hidden = NO;
            self.wordView.frame = CGRectMake(0, 16, SCREEN_WIDTH, 62);
            self.singleLine.frame = CGRectMake(0, 102, SCREEN_WIDTH, 3);
            CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
            [UIView animateWithDuration:duration animations:^{
                self.translateLab.frame = CGRectMake(32.5, 129, SCREEN_WIDTH-65, translateLabSize.height);
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case YXAnswerSelectImageWrong3:
            break;
            
        default:
            break;
    }
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
    [self wordView];
    
    [self wordSpeakView];
    
    [self speakBtn];
    
    [self wordLab];
    
    [self phoneticLab];
    
    
    // 线条
    [self singleLine];
    
    // 提示例句
    [self sentenceLab];
    [self translateLab];
    
    [self selectView];
    
    [self leftTopBtn];
    
    [self rightTopBtn];
    
    [self leftBottomBtn];
    
    [self rightBottomBtn];
    
    [self configureAnswerModel];
    [self reloadViewSource];
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
    RELEASE(_leftTopBtn);
    RELEASE(_rightTopBtn);
    RELEASE(_leftBottomBtn);
    RELEASE(_rightBottomBtn);
}

- (void)reloadViewSource {
    YXStudyBookUnitModel *unitModel = [YXConfigure shared].bookUnitModel;
    NSString *name = [[unitModel.bookid DIR:unitModel.unitid]DIR:unitModel.filename];
    YXStudyBookUnitTopicModel *topic = [[YXStudyCmdCenter shared]curTopic];
    NSString *resourcePath = [[YXUtils resourcePath]DIR:name];
    // reset
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
    self.wordSpeakView.frame = CGRectMake((SCREEN_WIDTH - wordViewWidth)/2.0, 0, wordViewWidth, 52);
    self.wordLab.frame = CGRectMake(36, -6, wordWidth, 39);
    self.phoneticLab.frame = CGRectMake(36+wordWidth/2.0-phoneticWidth/2.0, 32, phoneticWidth, 22);
    
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
    [self.sentenceLab sizeToFit];
    
    self.translateLab.text = [NSString stringWithFormat:@"%@ %@", [YXStudyCmdCenter shared].curUnitInfo.property, [YXStudyCmdCenter shared].curUnitInfo.paraphrase];
    CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
    self.translateLab.frame = CGRectMake(32.5, 129, SCREEN_WIDTH-65, translateLabSize.height);
    
    [self.leftTopBtn.titleImage sd_setImageWithURL:[NSURL fileURLWithPath:[resourcePath DIR:topic.options[0]]]];
    [self.rightTopBtn.titleImage sd_setImageWithURL:[NSURL fileURLWithPath:[resourcePath DIR:topic.options[1]]]];
    [self.leftBottomBtn.titleImage sd_setImageWithURL:[NSURL fileURLWithPath:[resourcePath DIR:topic.options[2]]]];
    [self.rightBottomBtn.titleImage sd_setImageWithURL:[NSURL fileURLWithPath:[resourcePath DIR:topic.options[3]]]];
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

- (void)leftTopBtnClicked:(id)sender {
    [self disableAll];
    [self enableAll:sender];
    // 输入答案
    [[YXStudyCmdCenter shared]enterAnswer:self.leftTopBtn.answerModel];
    if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageRight) {
        self.leftTopBtn.selectType = YXGraphSelectFalse;
    } else {
        self.leftTopBtn.selectType = YXGraphSelectRight;
    }
}

- (void)rightTopBtnClicked:(id)sender {
    [self disableAll];
    [self enableAll:sender];
    // 输入答案
    [[YXStudyCmdCenter shared]enterAnswer:self.rightTopBtn.answerModel];
    if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageRight) {
        self.rightTopBtn.selectType = YXGraphSelectFalse;
    } else {
        self.rightTopBtn.selectType = YXGraphSelectRight;
    }
}

- (void)leftBottomBtnClicked:(id)sender {
    [self disableAll];
    [self enableAll:sender];
    // 输入答案
    [[YXStudyCmdCenter shared]enterAnswer:self.leftBottomBtn.answerModel];
    if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageRight) {
        self.leftBottomBtn.selectType = YXGraphSelectFalse;
    } else {
        self.leftBottomBtn.selectType = YXGraphSelectRight;
    }
}

- (void)rightBottomBtnClicked:(id)sender {
    
    [self disableAll];
    [self enableAll:sender];
    // 输入答案
    [[YXStudyCmdCenter shared]enterAnswer:self.rightBottomBtn.answerModel];
    if ([YXStudyCmdCenter shared].answerType != YXAnswerSelectImageRight) {
        self.rightBottomBtn.selectType = YXGraphSelectFalse;
    } else {
        self.rightBottomBtn.selectType = YXGraphSelectRight;
    }
}

- (void)disableAll {
    self.leftTopBtn.userInteractionEnabled = NO;
    self.rightTopBtn.userInteractionEnabled = NO;
    self.leftBottomBtn.userInteractionEnabled = NO;
    self.rightBottomBtn.userInteractionEnabled = NO;
}

- (void)enableAll:(id)sender {
    __weak YXGraphSelectView *weakSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [weakSelf resetAllBtn:sender];
    });
}

- (void)resetAllBtn:(id)sender {
    self.answerType = [YXStudyCmdCenter shared].answerType;
    
    self.leftTopBtn.userInteractionEnabled = YES;
    self.rightTopBtn.userInteractionEnabled = YES;
    self.leftBottomBtn.userInteractionEnabled = YES;
    self.rightBottomBtn.userInteractionEnabled = YES;
    
    self.leftTopBtn.selectType = YXGraphSelectNone;
    self.rightTopBtn.selectType = YXGraphSelectNone;
    self.leftBottomBtn.selectType = YXGraphSelectNone;
    self.rightBottomBtn.selectType = YXGraphSelectNone;
}

#pragma mark -lazy load view-
- (UIButton *)speakBtn {
    if (!_speakBtn) {
        _speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speakBtn setImage:[UIImage imageNamed:@"study_speak"] forState:UIControlStateNormal];
        [_speakBtn addTarget:self action:@selector(speakButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_speakBtn setFrame:CGRectMake(0, 1, 28, 28)];
        [self.wordSpeakView addSubview:_speakBtn];
    }
    return _speakBtn;
}

- (UIView *)wordView {
    if (!_wordView) {
        _wordView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 62)];
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

- (UILabel *)wordLab {
    if (!_wordLab) {
        _wordLab = [[UILabel alloc]init];
        _wordLab.text = @"coffee";
        _wordLab.font = [UIFont boldSystemFontOfSize:36];
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
        _sentenceLab.font = [UIFont systemFontOfSize:18];
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
            _selectView.frame = CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH-20, SCREEN_WIDTH, SCREEN_WIDTH-40);
        } else if (iPhone5) {
            _selectView.frame = CGRectMake(0, SCREEN_HEIGHT-kSafeBottomMargin-SCREEN_WIDTH-40, SCREEN_WIDTH, SCREEN_WIDTH-40);
        } else {
            _selectView.frame = CGRectMake(0, SCREEN_HEIGHT-kSafeBottomMargin-SCREEN_WIDTH-40-kNavHeight, SCREEN_WIDTH, SCREEN_WIDTH-40);
        }
        [self addSubview:_selectView];
    }
    return _selectView;
}

- (YXGraphSelectButton *)leftTopBtn {
    if (!_leftTopBtn) {
        _leftTopBtn = [[YXGraphSelectButton alloc]initWithFrame:CGRectMake(20, 0, (SCREEN_WIDTH-56)/2.0, (SCREEN_WIDTH-56)/2.0)];
        _leftTopBtn.selectType = YXGraphSelectNone;
        [_leftTopBtn addTarget:self action:@selector(leftTopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:_leftTopBtn];
    }
    return _leftTopBtn;
}

- (YXGraphSelectButton *)rightTopBtn {
    if (!_rightTopBtn) {
        _rightTopBtn = [[YXGraphSelectButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH+16)/2.0, 0, (SCREEN_WIDTH-56)/2.0, (SCREEN_WIDTH-56)/2.0)];
        _rightTopBtn.selectType = YXGraphSelectNone;
        [_rightTopBtn addTarget:self action:@selector(rightTopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:_rightTopBtn];
    }
    return _rightTopBtn;
}

- (YXGraphSelectButton *)leftBottomBtn {
    if (!_leftBottomBtn) {
        _leftBottomBtn = [[YXGraphSelectButton alloc]initWithFrame:CGRectMake(20, (SCREEN_WIDTH-24)/2.0, (SCREEN_WIDTH-56)/2.0, (SCREEN_WIDTH-56)/2.0)];
        _leftBottomBtn.selectType = YXGraphSelectNone;
        [_leftBottomBtn addTarget:self action:@selector(leftBottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:_leftBottomBtn];
    }
    return _leftBottomBtn;
}

- (YXGraphSelectButton *)rightBottomBtn {
    if (!_rightBottomBtn) {
        _rightBottomBtn = [[YXGraphSelectButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH+16)/2.0, (SCREEN_WIDTH-24)/2.0, (SCREEN_WIDTH-56)/2.0, (SCREEN_WIDTH-56)/2.0)];
        _rightBottomBtn.selectType = YXGraphSelectNone;
        [_rightBottomBtn addTarget:self action:@selector(rightBottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:_rightBottomBtn];
    }
    return _rightBottomBtn;
}

@end
