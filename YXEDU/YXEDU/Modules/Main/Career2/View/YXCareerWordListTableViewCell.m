//
//  YXCareerWordListTableViewCell.m
//  YXEDU
//
//  Created by yixue on 2019/2/20.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerWordListTableViewCell.h"

@interface YXCareerWordListTableViewCell ()

//@property (nonatomic, strong) UILabel *label;

@end

@implementation YXCareerWordListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupLine];
        [self setupLabel];
    }
    return self;
}

- (void)setWordListModel:(YXCareerWordListModel *)wordListModel {
    _wordListModel = wordListModel;
    _label.text = _wordListModel.bookName;
}

- (void)setupLine {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53.5, SCREEN_WIDTH, 1.5)];
    line.backgroundColor = UIColorOfHex(0xEAF4FC);
    [self addSubview:line];
}

- (void)setupLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 250, 19)];
    label.text = _wordListModel.bookName;
    label.font = [UIFont pfSCRegularFontWithSize:17];
    label.textColor = UIColorOfHex(0x555555);
    [self addSubview:label];
    _label = label;
}

@end
