//
//  YXMyWordBookCell.m
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookCell.h"
@interface YXMyWordBookCell ()
@property (nonatomic, weak) UIImageView *contentBGView;
@property (nonatomic, weak) UILabel *sourceTitleLabel;
@property (nonatomic, weak) UILabel *createDateLabel;
@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, strong) UIImageView *studyCompleteIcon;
@property (nonatomic, strong) UIImageView *listenCompleteIcon;
@property (nonatomic, weak) UIButton *manageBtn;
@end

@implementation YXMyWordBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
//            make.size.mas_equalTo(MakeAdaptCGSize(28, 28));
            make.width.mas_equalTo(AdaptSize(28));
            make.height.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(AdaptSize(10));
        }];
        
        UIImageView *contentBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myWordBookBGIcon"]];
        contentBGView.userInteractionEnabled = YES;
        [self.contentView addSubview:contentBGView];
        _contentBGView = contentBGView;
        
        CGFloat bgMargin = AdaptSize(12);
        [contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, bgMargin, 0, bgMargin));
        }];
        
        CGFloat margin = AdaptSize(10);
        CGFloat ltMargin = AdaptSize(15);
        [self.sourceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentBGView).offset(AdaptSize(13));
            make.right.equalTo(contentBGView).offset(-AdaptSize(13));
            make.top.equalTo(contentBGView).offset(ltMargin);
        }];
        [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.sourceTitleLabel);
            make.top.equalTo(self.sourceTitleLabel.mas_bottom).offset(margin);
        }];

        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.sourceTitleLabel);
            make.top.equalTo(self.createDateLabel.mas_bottom).offset(margin);
        }];
        
        UIView *verLine = [[UIView alloc] init];
        verLine.backgroundColor = UIColorOfHex(0x849EC5);
        [self.contentBGView addSubview:verLine];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentBGView);
            make.top.equalTo(self.descLabel.mas_bottom).offset(AdaptSize(22));
            make.size.mas_equalTo(CGSizeMake(1, AdaptSize(17)));
        }];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentBGView);
            make.centerY.right.equalTo(verLine);
            make.height.mas_equalTo(AdaptSize(25));
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentBGView);
            make.centerY.left.equalTo(verLine);
            make.height.mas_equalTo(AdaptSize(25));
        }];
        
        [self.studyCompleteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentBGView).offset(AdaptSize(12));
            make.right.equalTo(self.contentBGView).offset(AdaptSize(4));
            make.size.mas_equalTo(MakeAdaptCGSize(65, 26));
        }];
        
        [self.listenCompleteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.left.equalTo(self.studyCompleteIcon);
            make.top.equalTo(self.studyCompleteIcon.mas_bottom).offset(AdaptSize(3));
        }];
    }
    return self;
}

- (void)setMyWordBookModel:(YXMyWordBookModel *)myWordBookModel {
    _myWordBookModel = myWordBookModel;
    self.sourceTitleLabel.text = myWordBookModel.wordListName;
    
    NSString *dateStr =  myWordBookModel.createDateDesc;
    if (myWordBookModel.sharingPerson.length) {
        dateStr = [NSString stringWithFormat:@"%@(%@)",dateStr,myWordBookModel.sharingPersonDesc];
    }
    self.createDateLabel.text = dateStr;
    self.descLabel.text = myWordBookModel.descString;
    [self.leftBtn setTitle:myWordBookModel.studyStateString forState:UIControlStateNormal];
    [self.rightBtn setTitle:myWordBookModel.listenStateString forState:UIControlStateNormal];
    
    //词单 在编辑时候 灰掉
    if (myWordBookModel.isEditing) {
        [self.leftBtn setTitleColor:UIColorOfHex(0xBBCEE2)
                           forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:UIColorOfHex(0xBBCEE2)
                            forState:UIControlStateNormal];
    }
    else
    {
        [self.leftBtn setTitleColor:UIColorOfHex(0x55A7FD)
                           forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:UIColorOfHex(0x55A7FD)
                            forState:UIControlStateNormal];
    }
    
    self.studyCompleteIcon.hidden = (myWordBookModel.learnState != 3);
    self.listenCompleteIcon.hidden = (myWordBookModel.listenState != 3);
}

- (void)setSelectState:(BOOL)selectState {
    _selectState = selectState;
    self.manageBtn.selected = selectState;
}
#pragma mark - action
- (void)clickManageBtn {
    [self manageBtnClick:self.manageBtn];
}

- (void)manageBtnClick:(UIButton *)btn { //模型控制
    if ([self.delegate respondsToSelector:@selector(myWordBookCellManageBtnClicked:)]) {
        [self.delegate myWordBookCellManageBtnClicked:self];
    }
}

- (void)leftAction {
    if ([self.delegate respondsToSelector:@selector(myWordBookCellStudyBtnClicked:)]) {
        [self.delegate myWordBookCellStudyBtnClicked:self];
    }
}

- (void)rightAction {
    if ([self.delegate respondsToSelector:@selector(myWordBookCellListenBtnClicked:)]) {
        [self.delegate myWordBookCellListenBtnClicked:self];
    }
}

- (void)setSwitchToManage:(BOOL)switchToManage {
    if (_switchToManage != switchToManage) {
        _switchToManage = switchToManage;
        CGFloat lrMargin = switchToManage ? AdaptSize(40) : AdaptSize(12);
        [self.contentBGView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(lrMargin);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
            self.manageBtn.alpha = switchToManage;
        }];
    }else {
        _switchToManage = switchToManage;
    }
    self.leftBtn.enabled = !switchToManage;
    self.rightBtn.enabled = !switchToManage;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (self.switchToManage) {
//        return self;
//    }else {
//        return view;
//    }
//}


#pragma mark - subviews
- (UILabel *)sourceTitleLabel {
    if (!_sourceTitleLabel) {
        UILabel *sourceTitleLabel = [[UILabel alloc] init];
        sourceTitleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(15)];
        sourceTitleLabel.textColor = UIColorOfHex(0x485461);
        [self.contentBGView addSubview:sourceTitleLabel];
        _sourceTitleLabel = sourceTitleLabel;
    }
    return _sourceTitleLabel;
}

- (UILabel *)createDateLabel {
    if (!_createDateLabel) {
        UILabel *createDateLabel = [[UILabel alloc] init];
        createDateLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        createDateLabel.textColor = [UIColor secondTitleColor];
        [self.contentBGView addSubview:createDateLabel];
        _createDateLabel = createDateLabel;
    }
    return _createDateLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        descLabel.textColor = [UIColor secondTitleColor];
        [self.contentBGView addSubview:descLabel];
        _descLabel = descLabel;
    }
    return _descLabel;
}


- (UIButton *)leftBtn {
    if (!_leftBtn) {
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [self.contentBGView addSubview:leftBtn];
        _leftBtn = leftBtn;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [self.contentBGView addSubview:rightBtn];
        _rightBtn = rightBtn;
    }
    return _rightBtn;
}

- (UIButton *)manageBtn {
    if (!_manageBtn) {
        UIButton *manageBtn = [[UIButton alloc] init];
        manageBtn.alpha = 0;
        [manageBtn addTarget:self action:@selector(manageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [manageBtn setImage:[UIImage imageNamed:@"manageWordBookNormal"] forState:UIControlStateNormal];
        [manageBtn setImage:[UIImage imageNamed:@"manageWordBookSelected"] forState:UIControlStateSelected];
        [self.contentView addSubview:manageBtn];
        _manageBtn = manageBtn;
    }
    return _manageBtn;
}

- (UIImageView *)studyCompleteIcon {
    if (!_studyCompleteIcon) {
        _studyCompleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listenCompleteIcon"]];//
        [self.contentBGView addSubview:_studyCompleteIcon];
    }
    return _studyCompleteIcon;
}

- (UIImageView *)listenCompleteIcon {
    if (!_listenCompleteIcon) {
        _listenCompleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"studyCompleteIcon"]];
        [self.contentBGView addSubview:_listenCompleteIcon];
    }
    return _listenCompleteIcon;
}
@end
