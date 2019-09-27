//
//  YXMyWordBaseCell.m
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBaseCell.h"
@interface YXMyWordBaseCell ()

@property (nonatomic, weak)UILabel *wordL;
@property (nonatomic, weak)UILabel *explanationL;
@end

@implementation YXMyWordBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUpSubviews];
    }
    return self;
}

- (void)setWordModel:(YXMyWordCellBaseModel *)wordModel {
    _wordModel = wordModel;
    self.wordL.text = wordModel.wordDetail.word;
    self.explanationL.text = wordModel.wordDetail.explainText;
}

- (void)setUpSubviews {
    
}
#pragma mark - subviews

- (UILabel *)wordL {
    if (!_wordL) {
        UILabel *wordL = [[UILabel alloc] init];
        wordL.adjustsFontSizeToFitWidth=YES;
//        wordL.text = @"franddaughter";
        wordL.textColor = UIColorOfHex(0x485461);
        wordL.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [self.contentView addSubview:wordL];
        _wordL = wordL;
    }
    return _wordL;
}

- (UILabel *)explanationL {
    if (!_explanationL) {
        UILabel *explanationL = [[UILabel alloc] init];
//        explanationL.text = @"n. 咖啡豆; 咖啡粉; ";
        explanationL.textColor = UIColorOfHex(0x849EC5);
        explanationL.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        [self.contentView addSubview:explanationL];
        _explanationL = explanationL;
    }
    return _explanationL;
}

@end
