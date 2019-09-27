//
//  YXMainItemsView.m
//  YXEDU
//
//  Created by jukai on 2019/6/5.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXMainItemsView.h"

@interface ItemBannerButton ()

@property (nonatomic, strong) UIImageView *btnImageView;
@property (nonatomic, strong) UILabel *btnLabel;

@end


@implementation ItemBannerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        UIImageView *btnImageView = [[UIImageView alloc] init];
        
        [self addSubview:btnImageView];
        
        _btnImageView = btnImageView;
        
        [_btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(AdaptSize(10));
            make.left.equalTo(self).offset(AdaptSize(10.0));
            make.right.equalTo(self).offset(AdaptSize(-10.0));
            make.height.equalTo(self.mas_width).with.offset(-20);
        }];
        
        UILabel *btnLabel = [[UILabel alloc] init];
        [self addSubview:btnLabel];
        btnLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(12)];
        btnLabel.textColor = UIColorOfHex(0x434A5D);
        btnLabel.textAlignment = NSTextAlignmentCenter;
        _btnLabel = btnLabel;
        
        [_btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnImageView.mas_bottom).offset(AdaptSize(10));
            make.left.equalTo(self);
            make.width.mas_equalTo(self);
        }];
        
    }
    return self;
}

@end



@interface YXMainItemsView ()
@property (nonatomic, weak) UIImageView *placeholderIcon;
@property (nonatomic, weak) YXNoHightButton *reportButton;
@property (nonatomic, weak) UILabel *levelL;
@property (nonatomic, strong) UIScrollView *bgScroll;
@property (nonatomic, strong) ItemBannerButton *taskBtn;
@property (nonatomic, strong) ItemBannerButton *readBtn;
@property (nonatomic, strong) ItemBannerButton *choseWordsBtn;

@property (nonatomic, strong) UIImageView *btnImg;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;

@end

@implementation YXMainItemsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _bgScroll = [[UIScrollView alloc]initWithFrame:self.frame];
        [self addSubview:_bgScroll];
        _bgScroll.contentSize = CGSizeMake(SCREEN_WIDTH*1.0,self.frame.size.height);
        _bgScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _taskBtn = [[ItemBannerButton alloc] init];
        [_taskBtn.btnImageView setImage:[UIImage imageNamed:@"MainItemPic5"]];
        [_taskBtn.btnLabel setText:@"任务中心"];
        _taskBtn.btnLabel.textColor = UIColorOfHex(0x434A5D);
        _taskBtn.btnLabel.font = [UIFont systemFontOfSize:12];

        [_bgScroll addSubview:_taskBtn];
        _taskBtn.tag = 0;

        [_taskBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];

        _reportBtn = [[ItemBannerButton alloc] init];

        [_reportBtn.btnImageView setImage:[UIImage imageNamed:@"MainItemPic1"]];
        [_reportBtn.btnLabel setText:@"学习报告"];
        _reportBtn.btnLabel.textColor = UIColorOfHex(0x434A5D);
        _reportBtn.btnLabel.font = [UIFont systemFontOfSize:12];
        [_bgScroll addSubview:_reportBtn];

        _reportBtn.tag = 1;
        [_reportBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];


        _readBtn = [[ItemBannerButton alloc] init];

        [_readBtn.btnImageView setImage:[UIImage imageNamed:@"MainItemPic2"]];
        [_readBtn.btnLabel setText:@"课文读背"];
        _readBtn.btnLabel.textColor = UIColorOfHex(0x434A5D);
        _readBtn.btnLabel.font = [UIFont systemFontOfSize:12];

        [_bgScroll addSubview:_readBtn];

        _readBtn.tag = 2;
        [_readBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];


        _markBtn = [[ItemBannerButton alloc] init];


        [_markBtn.btnImageView setImage:[UIImage imageNamed:@"MainItemPic3"]];
        [_markBtn.btnLabel setText:@"打卡日历"];
        _markBtn.btnLabel.textColor = UIColorOfHex(0x434A5D);
        _markBtn.btnLabel.font = [UIFont systemFontOfSize:12];

        [_bgScroll addSubview:_markBtn];

        _markBtn.tag = 3;
        [_markBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];

        _choseWordsBtn = [[ItemBannerButton alloc] init];

        [_choseWordsBtn.btnImageView setImage:[UIImage imageNamed:@"MainItemPic4"]];
        [_choseWordsBtn.btnLabel setText:@"自选单词"];
        _choseWordsBtn.btnLabel.textColor = UIColorOfHex(0x434A5D);
        _choseWordsBtn.btnLabel.font = [UIFont systemFontOfSize:12];

        [_bgScroll addSubview:_choseWordsBtn];

        _choseWordsBtn.tag = 4;
        [_choseWordsBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];
        [self updateConstraints:NO];
    }
    return self;
}

- (void)updateConstraints:(BOOL)showArticleView {
    if (showArticleView) {
         _itemWidth = (SCREEN_WIDTH - 100)/5.f;
    } else {
         _itemWidth = (SCREEN_WIDTH - 80)/4.f;
    }
    _itemHeight = _itemWidth*1.3333f;

    [_bgScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(self).offset(0.0);
    }];

    [_taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_bgScroll).offset(AdaptSize(10));
        make.width.mas_equalTo(_itemWidth);
        make.height.mas_equalTo(_itemHeight);
    }];

    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taskBtn);
        make.left.equalTo(_taskBtn.mas_right).offset(20);
        make.width.mas_equalTo(_itemWidth);
        make.height.mas_equalTo(_itemHeight);
    }];

    if (showArticleView) {
        [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taskBtn);
            make.left.equalTo(_reportBtn.mas_right).offset(20);
            make.width.mas_equalTo(_itemWidth);
            make.height.mas_equalTo(_itemHeight);
        }];
    } else {
        [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taskBtn);
            make.left.equalTo(_reportBtn.mas_right);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(_itemHeight);
        }];
    }

    [_markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taskBtn);
        make.left.equalTo(_readBtn.mas_right).offset(20.f);
        make.width.mas_equalTo(_itemWidth);
        make.height.mas_equalTo(_itemHeight);

    }];

    [_choseWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taskBtn);
        make.left.equalTo(_markBtn.mas_right).offset(20);
        make.width.mas_equalTo(_itemWidth);
        make.height.mas_equalTo(_itemHeight);
    }];
}

- (void)setIsTodayCheckin:(BOOL)isTodayCheckin {
    _isTodayCheckin = isTodayCheckin;
    if (isTodayCheckin) {
        _btnImg.image = [UIImage imageNamed:@"已签到"];
        _detailLabel.text = @"已签到";
    }
}

- (void)setTaskStatusString:(NSString *)taskStatusString {
    _taskStatusString = taskStatusString;
}

- (void)setHasReport:(BOOL)hasReport {
    _hasReport = hasReport;
    self.placeholderIcon.hidden = hasReport;
    self.reportButton.hidden = !hasReport;
}

- (void)setReportModel:(YXLearnReportModel *)reportModel {
    _reportModel = reportModel;
    
    BOOL hasReport = (reportModel != nil);
    
    self.placeholderIcon.hidden = hasReport;
    self.reportButton.hidden = !hasReport;
    
    [self layoutIfNeeded];
}

- (void)checkReport:(UIButton *)btn {
    if (self.checkReportBlock) {
        self.checkReportBlock(btn.tag);
    }
}


@end
