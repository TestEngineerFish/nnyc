//
//  YXReporAreaView.m
//  YXEDU
//
//  Created by yao on 2018/11/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReporAreaView.h"

@interface BannerButton : YXNoHightButton

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, assign) BOOL isBig;

@end

@implementation BannerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        [self addSubview:title];
        title.font = [UIFont pfSCMediumFontWithSize:AdaptSize(15)];
        title.textColor = UIColorOfHex(0x3899E0);
        _topLabel = title;
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(AdaptSize(18));
            make.left.equalTo(self).offset(AdaptSize(90));
        }];
        
        UILabel *detail = [[UILabel alloc] init];
        [self addSubview:detail];
        detail.font = [UIFont pfSCRegularFontWithSize:AdaptSize(12)];
        detail.textColor = UIColorOfHex(0x3899E0);
        _bottomLabel = detail;
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topLabel.mas_bottom).offset(AdaptSize(4));
            make.left.equalTo(_topLabel);
        }];
    }
    return self;
}

- (void)setIsBig:(BOOL)isBig {
    _isBig = isBig;
    [_topLabel removeFromSuperview];
    [_bottomLabel removeFromSuperview];
    [self addSubview:_topLabel];
    [self addSubview:_bottomLabel];
    if (isBig) {
        _topLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(18)];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(AdaptSize(18));
            make.left.equalTo(self).offset(AdaptSize(90));
        }];
        _bottomLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(12)];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topLabel.mas_bottom).offset(AdaptSize(4));
            make.left.equalTo(_topLabel);
        }];
    } else {
        _topLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(14)];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(AdaptSize(20));
            make.left.equalTo(self).offset(AdaptSize(80));
        }];
        _bottomLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(11)];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topLabel.mas_bottom).offset(AdaptSize(4));
            make.left.equalTo(_topLabel);
        }];
    }
}

@end



@interface YXReporAreaView ()
@property (nonatomic, weak) UIImageView *placeholderIcon;
@property (nonatomic, weak) YXNoHightButton *reportButton;
@property (nonatomic, weak) UILabel *levelL;
@property (nonatomic, strong) UIScrollView *bgScroll;
@property (nonatomic, strong) BannerButton *taskBtn;
@property (nonatomic, strong) BannerButton *reportBtn;
@property (nonatomic, strong) BannerButton *readBtn;
@property (nonatomic, strong) UIImageView *btnImg;
@property (nonatomic, strong) UILabel *detailLabel;
@end
@implementation YXReporAreaView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _bgScroll = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:_bgScroll];
        
         _bgScroll.contentSize = CGSizeMake(SCREEN_WIDTH*1.5,frame.size.height);
        
        _bgScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _taskBtn = [[BannerButton alloc] init];
        [_taskBtn setBackgroundImage:[UIImage imageNamed:@"Main_missionCenter"] forState:UIControlStateNormal];
        _taskBtn.topLabel.text = @"任务中心";
        _taskBtn.bottomLabel.text = @"0/0";
        [_bgScroll addSubview:_taskBtn];
        _taskBtn.tag = 0;
        [_taskBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];
        
        _reportBtn = [[BannerButton alloc] init];
        [_reportBtn setBackgroundImage:[UIImage imageNamed:@"Main_studyReport"] forState:UIControlStateNormal];
        _reportBtn.topLabel.text = @"学习报告";
        _reportBtn.topLabel.textColor = UIColorOfHex(0xDB95B0);
        _reportBtn.bottomLabel.text = @"今日学习评分:?";
        _reportBtn.bottomLabel.textColor = UIColorOfHex(0xDB95B0);
        _reportBtn.hidden = YES;
        [_bgScroll addSubview:_reportBtn];
        
        _reportBtn.tag = 1;
        [_reportBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];
        
        _reportBtn.isBig = NO;
        
        
        _readBtn = [[BannerButton alloc] init];
        [_readBtn setBackgroundImage:[UIImage imageNamed:@"Main_studyReport"] forState:UIControlStateNormal];
        _readBtn.topLabel.text = @"学习报告";
        _readBtn.topLabel.textColor = UIColorOfHex(0xDB95B0);
        _readBtn.bottomLabel.text = @"今日学习评分:?";
        _readBtn.bottomLabel.textColor = UIColorOfHex(0xDB95B0);
        _readBtn.hidden = NO;
        [_bgScroll addSubview:_readBtn];
        
        _readBtn.tag = 2;
        [_readBtn addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];
        _readBtn.isBig = NO;
        
        
        
        _btnImg  = [[UIImageView alloc] init];
        _btnImg.image = [UIImage imageNamed:@"Mission_toCheckinBtn"];
        [_taskBtn addSubview:_btnImg];
        [_btnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(MakeAdaptCGSize(91, 36));
            make.centerY.equalTo(_taskBtn);
            make.right.equalTo(_taskBtn).offset(-20);
        }];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(11)];
        detailLabel.text = @"未签到";
        detailLabel.textColor =  UIColorOfHex(0x3899E0);
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.layer.cornerRadius = AdaptSize(10);
        detailLabel.layer.borderColor = UIColorOfHex(0x3899E0).CGColor;
        detailLabel.layer.borderWidth = 0.5;
        [_taskBtn addSubview:detailLabel];
        _detailLabel = detailLabel;
        
        [_bgScroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.left.mas_equalTo(self).offset(0.0);
        }];
        
        [_taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_bgScroll).offset(AdaptSize(10));
            make.width.mas_equalTo(AdaptSize(354));
            make.height.mas_equalTo(AdaptSize(88));
        }];
        
        [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taskBtn);
            make.left.equalTo(_taskBtn.mas_right).offset(AdaptSize(10));
//            make.right.equalTo(_bgScroll).offset(AdaptSize(-10));
            make.width.mas_equalTo(AdaptSize(178));
            make.height.mas_equalTo(AdaptSize(88));
        }];
        
        [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taskBtn);
            make.left.equalTo(_reportBtn.mas_right).offset(AdaptSize(10));
            //            make.right.equalTo(_bgScroll).offset(AdaptSize(-10));
            make.width.mas_equalTo(AdaptSize(178));
            make.height.mas_equalTo(AdaptSize(88));
        }];
        
    }
    return self;
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
    [self updateTaskStatusString];
//    BOOL hasReport = (self.reportModel != nil);
//    if (hasReport) {
//        _taskBtn.bottomLabel.text = taskStatusString;
//    } else {
//        _taskBtn.bottomLabel.text = [NSString stringWithFormat:@"任务进度状况 %@",taskStatusString];
//    }
}

- (void)updateTaskStatusString {
    BOOL hasReport = (self.reportModel != nil);
    if (hasReport) {
        _taskBtn.bottomLabel.text = _taskStatusString;
    } else {
        _taskBtn.bottomLabel.text = [NSString stringWithFormat:@"任务进度状况 %@",_taskStatusString];
    }
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
    if (hasReport) {
        self.levelL.text = reportModel.level;
        _reportBtn.bottomLabel.text = [NSString stringWithFormat:@"今日学习评分:%@",reportModel.level];
        _reportBtn.hidden = NO;
        _taskBtn.isBig = NO;
        [_taskBtn setBackgroundImage:[UIImage imageNamed:@"Mission_missionCenter_small"] forState:UIControlStateNormal];
        [_taskBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(AdaptSize(178));
        }];
        _btnImg.hidden = YES;
        [_detailLabel removeFromSuperview];
        [_taskBtn addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(MakeAdaptCGSize(48, 20));
            make.centerY.equalTo(_taskBtn.bottomLabel);
            make.left.equalTo(_taskBtn.bottomLabel.mas_right).offset(AdaptSize(5));
        }];
    }else {
        _reportBtn.hidden = YES;
        _taskBtn.isBig = YES;
        [_taskBtn setBackgroundImage:[UIImage imageNamed:@"Main_missionCenter"] forState:UIControlStateNormal];
        [_taskBtn mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.mas_equalTo(AdaptSize(354));
        }];
        _btnImg.hidden = NO;
        [_detailLabel removeFromSuperview];
    }
    [self updateTaskStatusString];
    [self layoutIfNeeded];
}

- (void)checkReport:(UIButton *)btn {
    if (self.checkReportBlock) {
        self.checkReportBlock(btn.tag);
    }
}

//- (UIImageView *)placeholderIcon {
//    if (!_placeholderIcon) {
//        UIImageView *placeholderIcon = [[UIImageView alloc] init];
//        placeholderIcon.contentMode = UIViewContentModeScaleAspectFit;
//        placeholderIcon.image = [UIImage imageNamed:@"reportPlaceholderImage"];
//        [self addSubview:placeholderIcon];
//        _placeholderIcon = placeholderIcon;
//    }
//    return _placeholderIcon;
//}
//
//- (YXNoHightButton *)reportButton {
//    if (!_reportButton) {
//        YXNoHightButton *reportButton = [[YXNoHightButton alloc] init];
//        reportButton.hidden = YES;
//        [reportButton addTarget:self action:@selector(checkReport:) forControlEvents:UIControlEventTouchUpInside];
//        [reportButton setBackgroundImage:[UIImage imageNamed:@"reportBGImage"] forState:UIControlStateNormal];
//        [self addSubview:reportButton];
//        _reportButton = reportButton;
//
//        UIImageView *paperaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reportPaperImage"]];
//        [reportButton addSubview:paperaImageView];
//        [paperaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.reportButton).offset(AdaptSize(15));
//            make.top.equalTo(self.reportButton).offset(AdaptSize(11));
//            make.size.mas_equalTo(MakeAdaptCGSize(66.5, 56));
//        }];
//
//        UIImageView *tipsImageView = [[UIImageView alloc] init];
//        tipsImageView.image = [UIImage imageNamed:@"reportTipsImage"];
//        [reportButton addSubview:tipsImageView];
//        CGFloat tipsMargin = AdaptSize(5);
//        [tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(paperaImageView.mas_right).offset(tipsMargin);
//            make.bottom.equalTo(paperaImageView).offset(-tipsMargin);
//            make.size.mas_equalTo(MakeAdaptCGSize(196, 34.5));
//        }];
//
//        UIImageView *postmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postmarkImage"]];
//        [reportButton addSubview:postmark];
//        [postmark mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.reportButton).offset(AdaptSize(-8));
//            make.top.equalTo(self.reportButton).offset(AdaptSize(6));
//            make.size.mas_equalTo(MakeAdaptCGSize(51.5, 43.5));
//        }];
//
//        UILabel *levelL = [[UILabel alloc] init];
//        levelL.font = [UIFont boldSystemFontOfSize:AdaptSize(16)];
//        levelL.textColor = UIColorOfHex(0xc6dcf2);//[UIColor blackColor];
//        levelL.textAlignment = NSTextAlignmentCenter;
//        [postmark addSubview:levelL];
//        _levelL = levelL;
//        levelL.transform = CGAffineTransformMakeRotation(M_PI_4);
//        CGFloat offset = AdaptSize(10);
//        [levelL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(postmark).offset(offset);
//            make.bottom.equalTo(postmark).offset(-offset);
//            make.size.mas_equalTo(MakeAdaptCGSize(18, 18));
//        }];
//    }
//    return _reportButton;
//}

//// TODO: 两个setupView方法
//
//- (UIButton *)setMissionBtn {
//
//}
//
//- (void)setupMissionAndReportView {
//    UIView *missionAndReportView = [[UIView alloc] init];
////    missionAndReportView.frame = self.frame;
//    missionAndReportView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:missionAndReportView];
//    [missionAndReportView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(10);
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(AdaptSize(78));
//    }];
//
//    UIButton *missionBtn = [[YXNoHightButton alloc] init];
//    missionBtn.frame = CGRectMake(AdaptSize(14), AdaptSize(10), AdaptSize(169), AdaptSize(78));
//    missionBtn.backgroundColor = UIColorOfHex(0xFBE2E9);
//    [missionBtn setImage:[UIImage imageNamed:@"Main_studyReport"] forState:UIControlStateNormal];
//    missionBtn.layer.cornerRadius = 10;
//    [missionAndReportView addSubview:missionBtn];
//
//    UILabel *missionLbl = [[UILabel alloc] init];
//    missionLbl.frame = CGRectMake(AdaptSize(78), AdaptSize(21), AdaptSize(65), AdaptSize(16));
//    NSMutableAttributedString *missionString = [[NSMutableAttributedString alloc] initWithString:@"任务中心" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(15)],NSForegroundColorAttributeName: UIColorOfHex(0xDB95B0)}];
//    missionLbl.attributedText = missionString;
//    [missionBtn addSubview:missionLbl];
//
//    UILabel *missiondetailLbl = [[UILabel alloc] init];
//    missiondetailLbl.frame = CGRectMake(AdaptSize(78), AdaptSize(42), AdaptSize(30), AdaptSize(16));
//    NSMutableAttributedString *missiondetailString = [[NSMutableAttributedString alloc] initWithString:@"0/3" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: AdaptSize(12)],NSForegroundColorAttributeName: UIColorOfHex(0xDB95B0)}];
//    missiondetailLbl.attributedText = missiondetailString;
//    [missionBtn addSubview:missiondetailLbl];
//
//    UILabel *missiondetailLbl2 = [[UILabel alloc] init];
//    missiondetailLbl2.frame = CGRectMake(AdaptSize(105), AdaptSize(40), AdaptSize(48), AdaptSize(20));
//    NSMutableAttributedString *missiondetail2String = [[NSMutableAttributedString alloc] initWithString:@"未签到" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: AdaptSize(12)],NSForegroundColorAttributeName: UIColorOfHex(0xDB95B0)}];
//    missiondetailLbl2.textAlignment = NSTextAlignmentCenter;
//    missiondetailLbl2.attributedText = missiondetail2String;
//    missiondetailLbl2.layer.cornerRadius = AdaptSize(10);
//    missiondetailLbl2.layer.borderColor = UIColorOfHex(0xDB95B0).CGColor;
//    missiondetailLbl2.layer.borderWidth = 1;
//    [missionBtn addSubview:missiondetailLbl2];
//
//    UIButton *reportBtn = [[UIButton alloc] init];
//    reportBtn.frame = CGRectMake(AdaptSize(191), AdaptSize(10), AdaptSize(169), AdaptSize(78));
//    reportBtn.backgroundColor = UIColorOfHex(0xFBE2E9);
//    [reportBtn setImage:[UIImage imageNamed:@"Main_studyReport"] forState:UIControlStateNormal];
//    reportBtn.layer.cornerRadius = 10;
//    [missionAndReportView addSubview:reportBtn];
//
//    UILabel *reportLbl = [[UILabel alloc] init];
//    reportLbl.frame = CGRectMake(AdaptSize(78), AdaptSize(21), AdaptSize(65), AdaptSize(16));
//    NSMutableAttributedString *reportString = [[NSMutableAttributedString alloc] initWithString:@"学习报告" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(15)],NSForegroundColorAttributeName: UIColorOfHex(0xDB95B0)}];
//    reportLbl.attributedText = reportString;
//    [reportBtn addSubview:reportLbl];
//
//    UILabel *reportdetailLbl = [[UILabel alloc] init];
//    reportdetailLbl.frame = CGRectMake(AdaptSize(78), AdaptSize(42), AdaptSize(90), AdaptSize(16));
//    NSMutableAttributedString *reportdetailString = [[NSMutableAttributedString alloc] initWithString:@"今日学习评分:S" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: AdaptSize(12)],NSForegroundColorAttributeName: UIColorOfHex(0xDB95B0)}];
//    reportdetailLbl.attributedText = reportdetailString;
//    [reportBtn addSubview:reportdetailLbl];
//}
//
//- (void)setupOnlyMissionView {
//    UIView *missionAndReportView = [[UIView alloc] init];
//    missionAndReportView.frame = self.reportAreaView.frame;
//    missionAndReportView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:missionAndReportView];
//
//    UIButton *missionBtn = [[UIButton alloc] init];
//    missionBtn.frame = CGRectMake(AdaptSize(0), AdaptSize(10), AdaptSize(375), AdaptSize(90));
//    //missionBtn.backgroundColor = UIColorOfHex(0xFBE2E9);
//    [missionBtn setImage:[UIImage imageNamed:@"Main_missionCenter"] forState:UIControlStateNormal];
//    missionBtn.layer.cornerRadius = 10;
//    [missionAndReportView addSubview:missionBtn];
//
//    UILabel *title = [[UILabel alloc] init];
//    title.frame = CGRectMake(AdaptSize(115),AdaptSize(20),AdaptSize(73),AdaptSize(18));
//    [missionBtn addSubview:title];
//    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"任务中心" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(17)],NSForegroundColorAttributeName: [UIColor colorWithRed:56/255.0 green:153/255.0 blue:224/255.0 alpha:1.0]}];
//    title.attributedText = titleString;
//
//    UILabel *detail = [[UILabel alloc] init];
//    detail.frame = CGRectMake(AdaptSize(115),AdaptSize(43),AdaptSize(200),AdaptSize(18));
//    [missionBtn addSubview:detail];
//    NSMutableAttributedString *detailString = [[NSMutableAttributedString alloc] initWithString:@"任务进度状况 0/3" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: AdaptSize(13)],NSForegroundColorAttributeName: [UIColor colorWithRed:56/255.0 green:153/255.0 blue:224/255.0 alpha:1.0]}];
//    detail.attributedText = detailString;
//
//    //Mission_toCheckinBtn
//    UIButton *toCheckBtn = [[UIButton alloc] init];
//    toCheckBtn.frame = CGRectMake(AdaptSize(255),AdaptSize(28),AdaptSize(75),AdaptSize(30));
//    [toCheckBtn setImage:[UIImage imageNamed:@"Mission_toCheckinBtn"] forState:UIControlStateNormal];
//    [missionBtn addSubview:toCheckBtn];
//}
@end
