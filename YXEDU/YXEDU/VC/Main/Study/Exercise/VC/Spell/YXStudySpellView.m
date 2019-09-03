//
//  YXStudySpellVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudySpellView.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "YXCommHeader.h"
#import "YXAnswerModel.h"
#import "YXConfigure.h"

@implementation YXNoPasteTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
    
}
@end


@interface YXStudySpellView () <UITextFieldDelegate>
@property (nonatomic, strong) YXNoPasteTextField *inputTextField;
@property (nonatomic, strong) UIImageView *rightTipImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *chineseLab;
@property (nonatomic, strong) UIButton *affirmBtn;
@property (nonatomic, strong) UIView *affirmBtnMaskView;

@property (nonatomic, strong) UIImageView *singleLine;
@property (nonatomic, strong) UILabel *sentenceLab;
@property (nonatomic, strong) UILabel *translateLab;

@end

@implementation YXStudySpellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    
    }
    return self;
}

- (void)affirmBtnClicked:(id)sender {
    [self.inputTextField resignFirstResponder];
    [self disableAll];
    [self enableAll:sender];
    
    NSString *str = self.inputTextField.text;
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    // 输入答案
    YXAnswerModel *answerModel = [[YXAnswerModel alloc]init];
    answerModel.type = @"4";
    answerModel.answer = str;
    
    [[YXStudyCmdCenter shared]enterAnswer:answerModel];
    if ([YXStudyCmdCenter shared].answerType != YXAnswerWordSpellRight) {
        self.spellType = YXSpellTypeFalse;
    } else {
        self.spellType = YXSpellTypeRight;
    }
}

- (void)disableAll {
    self.inputTextField.userInteractionEnabled = NO;
    self.affirmBtn.userInteractionEnabled = NO;
}

- (void)enableAll:(id)sender {
    __weak YXStudySpellView *weakSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [weakSelf resetAllBtn:sender];
    });
}

- (void)resetAllBtn:(id)sender {
    self.answerType = [YXStudyCmdCenter shared].answerType;
    self.inputTextField.userInteractionEnabled = YES;
    self.affirmBtn.userInteractionEnabled = YES;
    self.spellType = YXSpellTypeNone;
}

- (void)setSpellType:(YXSpellType)spellType {
    _spellType = spellType;
    switch (spellType) {
        case YXSpellTypeNone: {
            self.inputTextField.backgroundColor = [UIColor clearColor];
            self.rightTipImageView.hidden = YES;
        }
            break;
        case YXSpellTypeRight: {
            self.inputTextField.backgroundColor = UIColorOfHex(0xBFF199 );
            self.rightTipImageView.image = [UIImage imageNamed:@"study_word_right"];
            self.rightTipImageView.hidden = NO;
        }
            break;
        case YXSpellTypeFalse: {
            self.inputTextField.backgroundColor = UIColorOfHex(0xFF9797);
            self.rightTipImageView.image = [UIImage imageNamed:@"study_word_wrong"];
            self.rightTipImageView.hidden = NO;
        }
            break;
        default:
            break;
    }
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
    [self inputTextField];
    [self rightTipImageView];
    
    [self lineView];
    
    // 汉语解释
    [self chineseLab];
    
    // 确认
    [self affirmBtn];
    [self affirmBtnMaskView];
    
    // 线条
    [self singleLine];
    
    // 提示例句
    [self sentenceLab];
    [self translateLab];
    
    [self reloadData];
}

- (void)removeAllSubViews {
    RELEASE(_inputTextField);
    RELEASE(_rightTipImageView);
    RELEASE(_lineView);
    RELEASE(_chineseLab);
    RELEASE(_affirmBtn);
    RELEASE(_affirmBtnMaskView);
    RELEASE(_singleLine);
    RELEASE(_sentenceLab);
    RELEASE(_translateLab);
}

- (void)reloadData {
    self.inputTextField.text = @"";
    self.chineseLab.text = [NSString stringWithFormat:@"%@ %@", [YXStudyCmdCenter shared].curUnitInfo.property, [YXStudyCmdCenter shared].curUnitInfo.paraphrase];
    CGSize chineseLabSize = [self.chineseLab.text sizeWithMaxWidth:141 font:self.chineseLab.font];
    self.chineseLab.frame = CGRectMake(0, 127, SCREEN_WIDTH, chineseLabSize.height);
    [self.affirmBtn setFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, CGRectGetMaxY(self.chineseLab.frame)+32, 200, 54)];
    
    self.singleLine.frame = CGRectMake(0, CGRectGetMaxY(self.affirmBtn.frame)+24, SCREEN_WIDTH, 3);
    
    // 英文句子
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
    self.sentenceLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.singleLine.frame)+16, SCREEN_WIDTH-65, sentenceSize.height);
    
    // 中文翻译提示
    self.translateLab.text = [NSString stringWithFormat:@"%@ %@", [YXStudyCmdCenter shared].curUnitInfo.property, [YXStudyCmdCenter shared].curUnitInfo.paraphrase];
    CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
    self.translateLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.singleLine.frame)+16, SCREEN_WIDTH-65, translateLabSize.height);
}

- (void)setAnswerType:(YXAnswerType)answerType {
    _answerType = answerType;
    switch (answerType) {
        case YXAnswerWordSpellState: {
            CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:[UIFont systemFontOfSize:18]];
            self.sentenceLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.affirmBtn.frame)+sentenceSize.height+43, SCREEN_WIDTH-65, sentenceSize.height);
            self.singleLine.frame = CGRectMake(0, CGRectGetMinY(self.sentenceLab.frame)-10, SCREEN_WIDTH, 3);
            
            CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
            self.translateLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.affirmBtn.frame)+sentenceSize.height+43, SCREEN_WIDTH-65, translateLabSize.height);
            
            self.singleLine.hidden = YES;
            self.sentenceLab.hidden = YES;
            self.translateLab.hidden = YES;
            [UIView animateWithDuration:duration animations:^{
                
            } completion:^(BOOL finished) {
                if ([YXConfigure shared].firstAppearKeyBoard == NO) {
                    [self.inputTextField becomeFirstResponder];
                }
                [YXConfigure shared].firstAppearKeyBoard = NO;
            }];
        }
            break;
        case YXAnswerWordSpellWrong1: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = NO;
            self.translateLab.hidden = YES;
            
            [UIView animateWithDuration:duration animations:^{
                self.singleLine.frame = CGRectMake(0, 262, SCREEN_WIDTH, 3);
                CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:[UIFont systemFontOfSize:18]];
                self.sentenceLab.frame = CGRectMake(32.5, 281, SCREEN_WIDTH-65, sentenceSize.height);
            } completion:^(BOOL finished) {
                [self.inputTextField becomeFirstResponder];
            }];
        }
            break;
        case YXAnswerWordSpellWrong2: {
            self.singleLine.hidden = NO;
            self.sentenceLab.hidden = YES;
            self.translateLab.hidden = NO;
            self.singleLine.frame = CGRectMake(0, 262, SCREEN_WIDTH, 3);
            [UIView animateWithDuration:duration animations:^{
                CGSize translateLabSize = [self.translateLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-65, 1000) font:self.translateLab.font];
                self.translateLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.singleLine.frame)+24, SCREEN_WIDTH-65, translateLabSize.height);
            } completion:^(BOOL finished) {
                [self.inputTextField becomeFirstResponder];
            }];
        }
            break;
        case YXAnswerWordSpellWrong3:
            
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (result.length > 0) {
        self.affirmBtnMaskView.hidden = YES;
    } else {
        self.affirmBtnMaskView.hidden = NO;
    }
    if (result.length > 20) {
        return NO;
    }
    return YES;
}

#pragma mark -lazy load view-
- (YXNoPasteTextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[YXNoPasteTextField alloc]initWithFrame:CGRectMake(48, 40, SCREEN_WIDTH-96, 54)];
        _inputTextField.font = [UIFont systemFontOfSize:34];
        _inputTextField.textColor = UIColorOfHex(0x333333);
        _inputTextField.text = @"";
        _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.keyboardType = UIKeyboardTypeAlphabet;
        _inputTextField.delegate = self;
        [self addSubview:_inputTextField];
    }
    return _inputTextField;
}

- (UIImageView *)rightTipImageView {
    if (!_rightTipImageView) {
        _rightTipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.inputTextField.frame.size.width-44, 13, 28, 28)];
        _rightTipImageView.image = [UIImage imageNamed:@"study_word_right"];
        [self.inputTextField addSubview:_rightTipImageView];
        _rightTipImageView.hidden = YES;
    }
    return _rightTipImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(48, 94, SCREEN_WIDTH-96, 1.0)];
        _lineView.backgroundColor = UIColorOfHex(0xDDDDDD);
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)chineseLab {
    if (!_chineseLab) {
        // 汉语解释
        _chineseLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 272, 24)];
        _chineseLab.font = [UIFont systemFontOfSize:18];
        _chineseLab.textColor = UIColorOfHex(0x666666);
        _chineseLab.text = @"n.一种交通工具;\nvi.沉船\nvt.用船运输;";
        _chineseLab.numberOfLines = 1;
        _chineseLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_chineseLab];
    }
    return _chineseLab;
}

- (UIButton *)affirmBtn {
    if (!_affirmBtn) {
        // 确认
        _affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_affirmBtn setFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, 184, 200, 54)];
        [_affirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_affirmBtn setBackgroundImage:[UIImage imageNamed:@"study_continue_btn"] forState:UIControlStateNormal];
        [_affirmBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
        [_affirmBtn setBackgroundColor:[UIColor clearColor]];
        [_affirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_affirmBtn addTarget:self action:@selector(affirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _affirmBtn.layer.cornerRadius = 27.0f;
        [self addSubview:_affirmBtn];
    }
    return _affirmBtn;
}

- (UIView *)affirmBtnMaskView {
    if (!_affirmBtnMaskView) {
        _affirmBtnMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 54)];
        _affirmBtnMaskView.layer.cornerRadius = 27.0f;
        _affirmBtnMaskView.backgroundColor = [UIColor whiteColor];
        _affirmBtnMaskView.alpha = 0.4;
        [self.affirmBtn addSubview:_affirmBtnMaskView];
    }
    return _affirmBtnMaskView;
}

- (UIImageView *)singleLine {
    if (!_singleLine) {
        _singleLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 262, SCREEN_WIDTH, 3)];
        _singleLine.image = [UIImage imageNamed:@"single_line"];
        [self addSubview:_singleLine];
    }
    return _singleLine;
}

- (UILabel *)sentenceLab {
    if (!_sentenceLab) {
        _sentenceLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5, 281, SCREEN_WIDTH-65, 40)];
        _sentenceLab.font = [UIFont systemFontOfSize:18];
        _sentenceLab.numberOfLines = 0;
        [self addSubview:_sentenceLab];
    }
    return _sentenceLab;
}

- (UILabel *)translateLab {
    if (!_translateLab) {
        _translateLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, 281, SCREEN_WIDTH-65, 40)];
        _translateLab.font = [UIFont systemFontOfSize:18];
        _translateLab.textColor = UIColorOfHex(0x333333);
        _translateLab.textAlignment = NSTextAlignmentCenter;
        _translateLab.lineBreakMode = NSLineBreakByWordWrapping;
        _translateLab.text = @"n.一种交通工具;\nvi.沉船\nvt.用船运输;";
        _translateLab.numberOfLines = 0;
        [self addSubview:_translateLab];
    }
    return _translateLab;
}

@end
