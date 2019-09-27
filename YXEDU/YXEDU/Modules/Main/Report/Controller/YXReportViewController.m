//
//  YXReportViewController.m
//  YXEDU
//
//  Created by yao on 2018/12/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReportViewController.h"
#import "YXVocabularyView.h"
#import "YXDataSituationView.h"
#import "YXStudySpeedView.h"
#import "YXCompositeView.h"
#import "YXReportIndexView.h"
#import "YXReportAblityView.h"

#import "YXReportDetailInfo.h"
@interface YXReportViewController ()<UIScrollViewDelegate,YXReportIndexViewDelegate>
@property (nonatomic, weak)UIImageView *headImageView;
@property (nonatomic, weak)YXComNaviView *naview;
@property (nonatomic, weak)UIScrollView *contentScroll;
@property (nonatomic, weak)YXReoprtEleView *userView;
@property (nonatomic, weak)UILabel *userNameL;
@property (nonatomic, weak)UIImageView *userIcon;
@property (nonatomic, weak)YXVocabularyView *vocabularyView;
@property (nonatomic, weak)YXDataSituationView *dataView;
@property (nonatomic, weak)YXStudySpeedView *speedView;
@property (nonatomic, weak)YXReportIndexView *indexView;
@property (nonatomic, weak)YXCompositeView *compositeView;
@property (nonatomic, weak)YXReportAblityView *abilityView;
@property (nonatomic, strong)YXReportDetailInfo *reportData;

@property (nonatomic, weak)UIView *tipsView;
@property (nonatomic, weak)UIVisualEffectView *blurView;
@end

@implementation YXReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentScroll.contentInset = UIEdgeInsetsMake(0, 0, kSafeBottomMargin, 0);
    self.naview.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReportHeadImage"]];
    [self.contentScroll addSubview:headImageView];
    headImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, AdaptSize(headImageView.height));
    self.headImageView = headImageView;
    CGFloat margin = AdaptSize(10);
    CGFloat lrMargin = AdaptSize(15);
    CGFloat width = SCREEN_WIDTH - 2 * lrMargin;
    self.userView.frame = CGRectMake(lrMargin, headImageView.bottom + margin, width, AdaptSize(70));
    self.vocabularyView.frame = CGRectMake(lrMargin, self.userView.bottom + lrMargin, width, AdaptSize(177));
    self.dataView.frame = CGRectMake(lrMargin, self.vocabularyView.bottom + AdaptSize(38), width, AdaptSize(207));
    self.speedView.frame = CGRectMake(lrMargin, self.dataView.bottom + lrMargin, width, AdaptSize(206));
    self.indexView.frame = CGRectMake(lrMargin, self.speedView.bottom + lrMargin, width, AdaptSize(191));
    self.compositeView.frame = CGRectMake(lrMargin, self.indexView.bottom + lrMargin, width, AdaptSize(329));
    self.abilityView.frame = CGRectMake(lrMargin, self.compositeView.bottom + lrMargin, width, AdaptSize(227));
    self.contentScroll.contentSize = CGSizeMake(0, self.abilityView.bottom + AdaptSize(27));
    
    [self getReports];
}

- (void)setReportData:(YXReportDetailInfo *)reportData {
    [reportData dataSetup];
    _reportData = reportData;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - datas
- (void)getReports {
    [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:DOMAIN_DETAILLEARNREPORT parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            YXReportDetailInfo *reportData = [YXReportDetailInfo mj_objectWithKeyValues:response.responseObject];
            weakSelf.reportData = reportData;
            [weakSelf refreshReport];
            [weakSelf hideLoadingView];
            [weakSelf hideNoNetWorkView];
        }else {
            if (response.error.type == kBADREQUEST_TYPE) {
                [weakSelf showNoNetWorkView:^{
                    [weakSelf getReports];
                }];
            }
            [weakSelf hideLoadingView];
        }
    }];
}

- (void)showNoNetWorkView:(YXTouchBlock)touchBlock {
    [super showNoNetWorkView:touchBlock];
    [self.view bringSubviewToFront:self.naview];
    if (self.blurView.hidden) {
        self.blurView.hidden = NO;
    }
}

- (void)hideNoNetWorkView {
    [super hideNoNetWorkView];
    self.blurView.hidden = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > self.headImageView.height - kNavHeight) {
//        self.naview.backgroundColor = [UIColor whiteColor];
        self.blurView.hidden = NO;
    }else {
//        self.naview.backgroundColor = [UIColor clearColor];
        self.blurView.hidden = YES;
    }
    
    if (offsetY < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark - refresh view
- (void)refreshReport {
    YXReportUserInfo *user = self.reportData.userInfo;
    if (user.avatar.length) {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    self.userNameL.text = user.nick;

    self.vocabularyView.myLearnedL.text = self.reportData.userReport.learned;
    self.vocabularyView.averageL.text = self.reportData.nationReport.learned;
    [self.dataView refreshWith:self.reportData.answersQues
               correctPercents:self.reportData.correctPercents
                     learnDays:self.reportData.learnedDays];
    
    self.speedView.avatar = user.avatar;
    [self.speedView refreshWith:self.reportData.userReport.learnSpeed
                       platform:self.reportData.nationReport.learnSpeed];
    self.compositeView.overall = self.reportData.userReport.overall;
    
    self.indexView.learnIndex = self.reportData.userReport.learnIndex;
    self.abilityView.ability = self.reportData.userReport.ability;
}

#pragma mark - YXReportIndexViewDelegate
- (void)reportIndexViewClikShowTips:(YXReportIndexView *)reportIndexView {
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidTipsView)];
    [tipsView addGestureRecognizer:tap];
    tipsView.backgroundColor = [UIColor clearColor];
    
    UIImageView *tipsIcon = [[UIImageView alloc] init];
    tipsIcon.userInteractionEnabled = YES;
    tipsIcon.image = [UIImage imageNamed:@"reportIndexAlertImage"];
    [tipsView addSubview:tipsIcon];
    
    CGRect tipsBtnTransRect = [reportIndexView convertRect:reportIndexView.tipsButton.frame toView:nil];
    CGFloat y = CGRectGetMaxY(tipsBtnTransRect) - AdaptSize(15);
    CGFloat x = tipsBtnTransRect.origin.x - AdaptSize(15);
    tipsIcon.frame = CGRectMake(x, y, AdaptSize(239), AdaptSize(157));
    
    [self.navigationController.view addSubview:tipsView];
    _tipsView = tipsView;
}

- (void)hidTipsView {
    [self.tipsView removeFromSuperview];
}
#pragma mark - subViews
- (UIScrollView *)contentScroll {
    if (!_contentScroll) {
        UIScrollView *contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        contentScroll.showsVerticalScrollIndicator = NO;
        contentScroll.delegate = self;
        contentScroll.backgroundColor = UIColorOfHex(0xF3F8FB);
        [self.view addSubview:contentScroll];
        _contentScroll = contentScroll;
    }
    return _contentScroll;
}

- (YXReoprtEleView *)userView {
    if (!_userView) {
        YXReoprtEleView *userView = [[YXReoprtEleView alloc] init];
        userView.bgImage = [UIImage imageNamed:@"reportUserBGImage"];
        [self.contentScroll addSubview:userView];
        _userView = userView;
        
        UIView *continer = [[UIView alloc] init];
        continer.backgroundColor = [UIColor whiteColor];
        continer.layer.shadowColor = UIColorOfHex(0xD0E0EF).CGColor;
        continer.layer.shadowRadius = 2;
        continer.layer.shadowOffset = CGSizeMake(0, 2);
        continer.layer.shadowOpacity = 0.6;
        continer.layer.cornerRadius = AdaptSize(8.0);
        [userView addSubview:continer];
        CGFloat margin = AdaptSize(10);
        [continer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(userView).offset(-margin);
            make.left.equalTo(userView).offset(margin);
            make.width.height.mas_equalTo(AdaptSize(75));
        }];
        
        UIImageView *userIcon = [[UIImageView alloc] init];
        userIcon.contentMode = UIViewContentModeScaleAspectFill;
        userIcon.layer.cornerRadius = continer.layer.cornerRadius;
        userIcon.layer.masksToBounds = YES;
        
        userIcon.image = [UIImage imageNamed:@"placeholder"];
        [continer addSubview:userIcon];
        _userIcon = userIcon;
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(continer).insets(UIEdgeInsetsMake(3, 3, 3, 3));
        }];
        
        UILabel *userNameL = [[UILabel alloc] init];
        userNameL.textColor = [UIColor mainTitleColor];
        userNameL.font = [UIFont boldSystemFontOfSize:AdaptSize(17)];
        [userView addSubview:userNameL];
        _userNameL = userNameL;
        
        [userNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userView);
            make.left.equalTo(userIcon.mas_right).offset(AdaptSize(16));
            make.right.equalTo(userView).offset(-AdaptSize(16));
        }];
    }
    return _userView;
}

- (YXVocabularyView *)vocabularyView {
    if (!_vocabularyView) {
        YXVocabularyView *vocabularyView = [[YXVocabularyView alloc] init];
        [self.contentScroll addSubview:vocabularyView];
        _vocabularyView = vocabularyView;
    }
    return _vocabularyView;
}

- (YXDataSituationView *)dataView {
    if (!_dataView) {
        YXDataSituationView *dataView = [[YXDataSituationView alloc] init];
        [self.contentScroll addSubview:dataView];
        _dataView = dataView;
    }
    return _dataView;
}

- (YXStudySpeedView *)speedView {
    if (!_speedView) {
        YXStudySpeedView *speedView = [[YXStudySpeedView alloc] init];
        [self.contentScroll addSubview:speedView];
        _speedView = speedView;
    }
    return _speedView;
}

- (YXReportIndexView *)indexView {
    if (!_indexView) {
        YXReportIndexView *indexView = [[YXReportIndexView alloc] init];
        indexView.delegate = self;
        [self.contentScroll addSubview:indexView];
        _indexView = indexView;
    }
    return _indexView;
}

- (YXCompositeView *)compositeView {
    if (!_compositeView) {
        YXCompositeView *compositeView = [[YXCompositeView alloc] init];
        [self.contentScroll addSubview:compositeView];
        _compositeView = compositeView;
    }
    return _compositeView;
}

- (YXReportAblityView *)abilityView {
    if (!_abilityView) {
        YXReportAblityView *abilityView = [[YXReportAblityView alloc] init];
        [self.contentScroll addSubview:abilityView];
        _abilityView = abilityView;
    }
    return _abilityView;
}

- (YXComNaviView *)naview {
    if (!_naview) {
        YXComNaviView *naview = [YXComNaviView comNaviViewWithLeftButtonType:YXNaviviewLeftButtonGray];
        naview.backgroundColor = [UIColor clearColor];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        blurView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
        [naview insertSubview:blurView atIndex:0];
        _blurView = blurView;
        
        [naview.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        naview.backgroundColor = [UIColor clearColor];
        naview.titleLabel.textColor = UIColorOfHex(0x485562);
        naview.title = @"学习报告";
        [self.view addSubview:naview];
        _naview = naview;
    }
    return _naview;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
