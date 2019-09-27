//
//  YXGraphWordCell.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphWordCell.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "YXStudyCmdCenter.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import "NSString+YX.h"
#import "AVAudioPlayerManger.h"
#import "YXAPI.h"

@interface YXGraphWordCell ()

@property (nonatomic, strong) UIButton *speakBtn;
@end

@implementation YXGraphWordCell

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
        
        self.wordLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, 24, SCREEN_WIDTH-97, 40)];
        self.wordLab.font = [UIFont boldSystemFontOfSize:36];
        self.wordLab.textColor = UIColorOfHex(0x2BB1F3);
        self.wordLab.textAlignment = NSTextAlignmentLeft;
        self.wordLab.text = @"coffee";
        [self.contentView addSubview:self.wordLab];
        
        self.phoneticLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, 72, SCREEN_WIDTH-97, 22)];
        self.phoneticLab.text = @"coffee";
        self.phoneticLab.font = [UIFont boldSystemFontOfSize:18];
        self.phoneticLab.textColor = UIColorOfHex(0x666666);
        self.phoneticLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.phoneticLab];
        
        self.speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.speakBtn setImage:[UIImage imageNamed:@"study_speak"] forState:UIControlStateNormal];
        [self.speakBtn addTarget:self action:@selector(speakButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.speakBtn setFrame:CGRectMake(0, 72, 22, 22)];
        [self.contentView addSubview:self.speakBtn];
        
        
    }
    return self;
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

- (void)reloadData {
    CGFloat phoneticWidth = [self.phoneticLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.phoneticLab.font].width;
    
    self.phoneticLab.frame = CGRectMake(32.5f, 72, phoneticWidth, 22);
    self.speakBtn.frame = CGRectMake(37.5+phoneticWidth, 72, 22, 22);
}

@end
