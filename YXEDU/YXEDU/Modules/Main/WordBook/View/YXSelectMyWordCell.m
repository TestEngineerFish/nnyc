//
//  YXSelectMyWordCell.m
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSelectMyWordCell.h"
@interface YXSelectMyWordCell ()
//@property (nonatomic, weak) UIButton *manageBtn;
//@property (nonatomic, weak) UILabel *descLabel;
@end

@implementation YXSelectMyWordCell
- (void)setUpSubviews {
    [super setUpSubviews];
    self.explanationL.font = [UIFont pfSCRegularFontWithSize:AdaptSize(12)];
    
    if (self.wordModel.isSearch) {
        
        [self.manageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(AdaptSize(7));
            make.size.mas_equalTo(MakeAdaptCGSize(15, 38));
        }];
        
        [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.manageBtn).offset(-AdaptSize(2));
            make.left.equalTo(self.manageBtn.mas_right).offset(AdaptSize(3));
            make.width.mas_equalTo(AdaptSize(150));
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wordL);
            make.right.equalTo(self.contentView).offset(-AdaptSize(10));
            make.left.equalTo(self.wordL.mas_right).offset(AdaptSize(5));
        }];
        
        [self.explanationL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.descLabel);
            make.left.equalTo(self.wordL);
            make.top.equalTo(self.wordL.mas_bottom);//.offset(AdaptSize(5));
        }];
        
    }
    else{
        
        [self.manageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(AdaptSize(7));
            make.size.mas_equalTo(MakeAdaptCGSize(38, 38));
        }];
        
        [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.manageBtn).offset(-AdaptSize(2));
            make.left.equalTo(self.manageBtn.mas_right).offset(AdaptSize(3));
            make.width.mas_equalTo(AdaptSize(150));
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wordL);
            make.right.equalTo(self.contentView).offset(-AdaptSize(10));
            make.left.equalTo(self.wordL.mas_right).offset(AdaptSize(5));
        }];
        
        [self.explanationL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.descLabel);
            make.left.equalTo(self.wordL);
            make.top.equalTo(self.wordL.mas_bottom);//.offset(AdaptSize(5));
        }];
        
    }
    
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//}

- (void)setWordModel:(YXMyWordCellBaseModel *)wordModel {
    [super setWordModel:wordModel];
    [self refreshContent];
    [self setUpSubviews];
}

- (void)refreshContent {
    if ([self.wordModel isKindOfClass:[YXSelectWordCellModel class]]) {
        YXSelectWordCellModel *selectWordCellModel = (YXSelectWordCellModel *)self.wordModel;
        self.descLabel.text = selectWordCellModel.occorDesc;
        if (selectWordCellModel.isSearch) {
            [self.manageBtn setHidden:YES];
        }
        else{
            self.manageBtn.selected = selectWordCellModel.selected;
        }
    }
}

//- (void)setSelectState:(BOOL)selectState {
//    _selectState = selectState;
//    YXSelectWordCellModel *selectWordCellModel = (YXSelectWordCellModel *)self.wordModel;
//    selectWordCellModel.selected = selectState;
//    self.manageBtn.selected = selectState;
//}


#pragma mark - action
- (void)manageBtnClick:(UIButton *)btn { //模型控制
    if ([self.delegate respondsToSelector:@selector(selectMyWordCellManageBtnClicked:)]) {
        [self.delegate selectMyWordCellManageBtnClicked:self];
    }
}

#pragma mark - subviews
- (UIButton *)manageBtn {
    if (!_manageBtn) {
        UIButton *manageBtn = [[UIButton alloc] init];
        [manageBtn addTarget:self action:@selector(manageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [manageBtn setImage:[UIImage imageNamed:@"manageWordBookNormal"] forState:UIControlStateNormal];
        [manageBtn setImage:[UIImage imageNamed:@"manageWordBookSelected"] forState:UIControlStateSelected];
        [self.contentView addSubview:manageBtn];
        _manageBtn = manageBtn;
    }
    return _manageBtn;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        UILabel *descLabel = [[UILabel alloc] init];
//        descLabel.text = @"在234个词单中";
        descLabel.textAlignment = NSTextAlignmentRight;
        descLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        descLabel.textColor = UIColorOfHex(0x888888);
        [self.contentView addSubview:descLabel];
        _descLabel = descLabel;
    }
    return _descLabel;
}
@end
