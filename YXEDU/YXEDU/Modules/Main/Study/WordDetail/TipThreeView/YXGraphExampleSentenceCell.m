//
//  YXGraphExampleSentenceCell.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphExampleSentenceCell.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "YXStudyCmdCenter.h"
#import "YXUtils.h"
#import "YXAPI.h"

@interface YXGraphExampleSentenceCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *sentenceLab;
//@property (nonatomic, strong) UIButton *speakBtn;
@property (nonatomic, strong) UILabel *translateLab;
@end

@implementation YXGraphExampleSentenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, 0, 45, 23)];
        self.titleLab.font = [UIFont boldSystemFontOfSize:13];
        self.titleLab.textColor = UIColorOfHex(0xffffff);
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = @"例句";
        self.titleLab.clipsToBounds = YES;
        self.titleLab.layer.cornerRadius = 11.5f;
        self.titleLab.backgroundColor = UIColorOfHex(0xBBBBBB);
        [self.contentView addSubview:self.titleLab];
        
        self.sentenceLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, CGRectGetMaxY(self.titleLab.frame)+8, SCREEN_WIDTH-97, 22)];
        self.sentenceLab.font = [UIFont systemFontOfSize:16];
        self.sentenceLab.numberOfLines = 0;
        self.sentenceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.sentenceLab];
        
        
        self.translateLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, CGRectGetMaxY(self.sentenceLab.frame), SCREEN_WIDTH-97, 40)];
        self.translateLab.text = @"你想喝一杯咖啡吗？";
        self.translateLab.font = [UIFont systemFontOfSize:16];
        self.translateLab.textColor = UIColorOfHex(0x666666);
        self.translateLab.textAlignment = NSTextAlignmentLeft;
        self.translateLab.numberOfLines = 0;
        [self.contentView addSubview:self.translateLab];
        
    }
    return self;
}

- (void)refreshModelInfo {
//    [self.speakBtn setFrame:CGRectMake(32.5f, CGRectGetMaxY(self.titleLab.frame)+8, 22, 22)];
    
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
    muParagraph.lineSpacing = -5; // 行距
    muParagraph.paragraphSpacing = 0; // 段距
    muParagraph.firstLineHeadIndent = 0; // 首行缩进
    muParagraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *strEng = [[[YXStudyCmdCenter shared].curUnitInfo.eng stringByReplacingOccurrencesOfString:@" " withString:@" "]stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
//    NSString *resultStr = nil;
//    NSString *hightLightStr = nil;
//    [YXUtils scanString:strEng resultString:&resultStr hightlightStr:&hightLightStr];
//    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]initWithString:resultStr];
//    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, attrString.string.length)];
//    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attrString.string.length)];
//    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x1CB0F6) range:[resultStr rangeOfString:hightLightStr]];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[strEng dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSLog(@"%@", [YXStudyCmdCenter shared].curUnitInfo.eng);
    // 设置段落样式
    [attrStr addAttribute:NSParagraphStyleAttributeName value:muParagraph range:NSMakeRange(0, attrStr.string.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, attrStr.string.length)];
    self.sentenceLab.attributedText = attrStr;
    
    CGSize sentenceSize = [self.sentenceLab.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH-97, 1000) font:[UIFont systemFontOfSize:18]];
    self.sentenceLab.frame = CGRectMake(32.5, CGRectGetMaxY(self.titleLab.frame)+8, SCREEN_WIDTH-97, sentenceSize.height);
    [self.sentenceLab sizeToFit];
    self.translateLab.text = [YXStudyCmdCenter shared].curUnitInfo.chs;
    
    CGSize tranSize = [[YXStudyCmdCenter shared].curUnitInfo.chs sizeWithMaxWidth:SCREEN_WIDTH-97 font:[UIFont systemFontOfSize:16]];
    
    self.translateLab.frame = CGRectMake(32.5f, CGRectGetMaxY(self.sentenceLab.frame), SCREEN_WIDTH-97, tranSize.height);
}

- (void)speakBtnClicked:(id)sender {
    
}

@end
