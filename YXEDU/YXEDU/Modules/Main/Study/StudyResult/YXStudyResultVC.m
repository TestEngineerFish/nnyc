//
//  YXStudyResultVC.m
//  YXEDU
//
//  Created by Jake To on 11/2/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXStudyResultVC.h"
#import "YXStudyResultCell.h"
#import "YXWordDetailModel.h"

#import "YXComHttpService.h"

#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "YXWordModelManager.h"
#import "YXWordDetailViewControllerOld.h"
#import "YXShareView.h"
#import "YXBadgeView.h"
#import "YXPosterShareView.h"
#import "YXShareLodingView.h"

@interface YXStudyResultVC () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UILabel *wordsCountLabel;
@property (nonatomic, strong) UILabel *timeCountLabel;
@property (nonatomic, strong) UILabel *studiedwordCountLabel;

@property (nonatomic, strong) UIButton *punchButton;
@property (nonatomic, strong) UIButton *goBackButton;
@property (nonatomic, strong) UIImageView *resultTipsImgView;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *blackMask;

@property (nonatomic, strong) NSString *punchShareURL;

@property (nonatomic, strong)YXStudyResultModel *studyResultModel;
@property (nonatomic, copy) NSArray *studiedWords;

@property (nonatomic, strong)UILabel *reviewRightL;
@property (nonatomic, strong)UILabel *reviewTotalL;
@property (nonatomic, assign)NSInteger curShowBadgeIndex;
@property (nonatomic, strong)UILabel *shareCreditsTotalL;
@end

@implementation YXStudyResultVC
- (instancetype)initWithStudyResultType:(YXExerciseType)studyResultType {
    if (self = [super init]) {
        self.studyResultType = studyResultType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // MARK: - Main
    self.view.backgroundColor = UIColorOfHex(0xF6F8FA);

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + 2, 44, 40)];
    [backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(exitWordDetailPage) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"学习结果";
    [titleLabel setFrame:CGRectMake(AdaptSize(150.0), kStatusBarHeight+17, AdaptSize(100.0), 20)];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.image = [UIImage imageNamed:@"头部背景"];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.layer.shadowColor = UIColorOfHex(0x45B2F0).CGColor;
    self.backgroundImageView.layer.shadowRadius = 4;
    self.backgroundImageView.layer.shadowOpacity = 0.4;
    self.backgroundImageView.layer.shadowOffset = CGSizeMake(0, 4);
    [self.backgroundImageView setUserInteractionEnabled:YES];
    
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.image = [UIImage imageNamed:@"学习结果-数据框"];
//    self.resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.backgroundImageView];
//    [self.backgroundImageView addSubview:backButton];
    [self.backgroundImageView addSubview:titleLabel];
    [self.backgroundImageView addSubview:self.resultImageView];
    
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(218);
    }];
    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.backgroundImageView);
//        make.centerY.mas_equalTo((kNavHeight + 2 + 40)/2.0);
//    }];
    
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isIPhoneXSerious()) {
            make.top.equalTo(self.backgroundImageView).offset(kNavHeight);
        }
        else{
            make.top.equalTo(self.backgroundImageView).offset(kNavHeight+20.0);
        }
        
        make.height.mas_equalTo(132);
        make.left.equalTo(self.backgroundImageView).offset(7);
        make.right.equalTo(self.backgroundImageView).offset(-7);
    }];
    
    UIView *tableContainerView = [[UIView alloc] init];
    tableContainerView.backgroundColor = UIColor.whiteColor;
    tableContainerView.layer.borderWidth = 1;
    tableContainerView.layer.borderColor = UIColor.whiteColor.CGColor;
    tableContainerView.layer.cornerRadius = 8;
    tableContainerView.layer.masksToBounds = NO;
    tableContainerView.layer.shadowColor = UIColorOfHex(0xAED7E3).CGColor;
    tableContainerView.layer.shadowRadius = 2;
    tableContainerView.layer.shadowOpacity = 1;
    tableContainerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 76;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 8;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30 + 44, 0);
    [self.tableView registerClass:[YXStudyResultCell class] forCellReuseIdentifier:@"StudyResultCell"];
    
    self.punchButton = [YXCustomButton commonBlueWithCornerRadius:22];
    self.punchButton.enabled = YES;
    NSString *title =  self.studyResultType ? @"完成" : @"打卡";
    [self.punchButton setTitle:title forState:UIControlStateNormal];
    [self.punchButton setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
    [self.punchButton addTarget:self action:@selector(showShareOptions:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tableContainerView];
    [tableContainerView addSubview:self.tableView];
    [self.view addSubview:self.punchButton];
    
    
    self.goBackButton = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(14), SCREEN_HEIGHT, AdaptSize(95) , AdaptSize(44))];
    [self.goBackButton setImage:[UIImage imageNamed:@"study_result_back"] forState:UIControlStateNormal];
    [self.goBackButton setImage:[UIImage imageNamed:@"study_result_back"] forState:UIControlStateSelected];
    [self.goBackButton addTarget:self action:@selector(exitWordDetailPage) forControlEvents:UIControlEventTouchUpInside];
    self.goBackButton.enabled = YES;
    if (self.studyResultType == YXExerciseNormal){
        [self.view addSubview:self.goBackButton];
    }
    
    
    self.resultTipsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(14.0), SCREEN_HEIGHT, AdaptSize(127.0), AdaptSize(55.0))];
    
    [self.resultTipsImgView setImage:[UIImage imageNamed:@"study_result_tips"]];
    
    [self.view addSubview:self.resultTipsImgView];
    
    self.shareCreditsTotalL = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(100), AdaptSize(11), AdaptSize(50), AdaptSize(13))];
    
    [self.shareCreditsTotalL setTextColor:UIColorOfHex(485461)];
    [self.shareCreditsTotalL setText:@""];
    [self.shareCreditsTotalL setFont:[UIFont systemFontOfSize:13.0]];
    [self.resultTipsImgView addSubview:self.shareCreditsTotalL];
    
    if (!self.studyResultType){
        [self.resultTipsImgView setHidden:NO];
    }
    else{
        [self.resultTipsImgView setHidden:YES];
    }
    
    [tableContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.view).offset(-36);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableContainerView);
    }];
    
//    self.punchButton.frame = CGRectMake(AdaptSize(122), SCREEN_HEIGHT, AdaptSize(239) , AdaptSize(44));
    if (self.studyResultType == YXExerciseNormal){
        self.punchButton.frame = CGRectMake(AdaptSize(122), SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin, AdaptSize(239), AdaptSize(44));
    }
    else{
        self.punchButton.frame = CGRectMake(16, SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin, SCREEN_WIDTH - 32 , 44);
    }
    [self netConfigShare];
    if (self.studyResultType != YXExerciseNormal) {
        self.reviewRightL = [[UILabel alloc] init];
        self.reviewRightL.textAlignment = NSTextAlignmentCenter;
        self.reviewRightL.textColor = UIColorOfHex(0x849EC5);
        self.reviewRightL.font = [UIFont systemFontOfSize:14];
        [self.resultImageView addSubview:self.reviewRightL];
        
        self.reviewTotalL = [[UILabel alloc] init];
        self.reviewTotalL.textColor = UIColorOfHex(0x60B6F8);
        self.reviewTotalL.font = [UIFont boldSystemFontOfSize:14];
        self.reviewTotalL.textAlignment = NSTextAlignmentCenter;
        [self.resultImageView addSubview:self.reviewTotalL];
        
        [self.reviewTotalL  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.resultImageView).offset(10);
            make.right.equalTo(self.resultImageView).offset(-110);
            make.top.equalTo(self.resultImageView).offset(35);
        }];
        
        [self.reviewRightL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reviewTotalL.mas_bottom).offset(15);
            make.left.right.equalTo(self.reviewTotalL);
        }];
        [self getStudyResult];
        return;
    }
    
    UILabel *wordsCountDescLabel= [[UILabel alloc] init];
    wordsCountDescLabel.text = @"新学单词";
    wordsCountDescLabel.textColor = UIColorOfHex(0x849EC5);
    wordsCountDescLabel.font = [UIFont systemFontOfSize:16];
    
    self.wordsCountLabel = [[UILabel alloc] init];
    self.wordsCountLabel.textColor = UIColorOfHex(0x60B6F8);
    self.wordsCountLabel.font = [UIFont boldSystemFontOfSize:17];
    
    UILabel *timeCountDescLabel= [[UILabel alloc] init];
    timeCountDescLabel.text = @"耗时";
    timeCountDescLabel.textColor = UIColorOfHex(0x849EC5);
    timeCountDescLabel.font = [UIFont systemFontOfSize:16];
    
    self.timeCountLabel = [[UILabel alloc] init];
    self.timeCountLabel.textColor = UIColorOfHex(0x60B6F8);;
    self.timeCountLabel.font = [UIFont boldSystemFontOfSize:17];

    [self.resultImageView addSubview:wordsCountDescLabel];
    [self.resultImageView addSubview:self.wordsCountLabel];
    [self.resultImageView addSubview:timeCountDescLabel];
    [self.resultImageView addSubview:self.timeCountLabel];
//    [self.backgroundImageView addSubview:self.studiedwordCountLabel];

    [wordsCountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultImageView).offset(31.0);
        make.top.mas_equalTo(self.resultImageView).offset(33.0);
//        make.centerX.equalTo(self.resultImageView).offset(-100);
//        make.bottom.equalTo(self.resultImageView.mas_centerY).offset(-8);
    }];
    
    [self.wordsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultImageView.mas_centerY).offset(8);
        make.centerX.equalTo(wordsCountDescLabel);
    }];
    
    [timeCountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultImageView).offset(127.0);
        make.top.mas_equalTo(wordsCountDescLabel);
//        make.bottom.equalTo(self.resultImageView.mas_centerY).offset(-8);
//        make.centerX.equalTo(self.resultImageView).offset((self.resultImageView.size.width)/2);
    }];
    
    [self.timeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultImageView.mas_centerY).offset(8);
        make.centerX.equalTo(timeCountDescLabel);
    }];
    
//    [self.studiedwordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.backgroundImageView).offset(-16);
//        make.left.equalTo(self.backgroundImageView).offset(16);
//    }];
    
    [self getStudyResult];
    
    if (self.studyResultType == YXExerciseWordListStudy || self.studyResultType == YXExerciseWordListStudy) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *wordListId = [defaults objectForKey:kCurrentLearnWordListIdKey];
        if ([wordListId isEqualToString:self.wordListId]) {
            [defaults removeObjectForKey:kCurrentLearnWordListIdKey];
            [defaults setObject:kDefaultWordListName forKey:kUnfinishedWordListNameKey];
        }
    }
    
}

- (BOOL)isPickErrorType {
    return (self.studyResultType == YXExercisePickError);
}
- (void)getStudyResult {
    YXExerciseType studyResultType = self.studyResultType;
    NSString *url = [self resultDomain];//studyResultType ? DOMAIN_SPOTCHECKRESULT : DOMAIN_RESULT;
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [self resultparam];
    NSLog(@"-----------开始上报结果--------");
    [YXDataProcessCenter GET:url
                  modelClass:[YXStudyResultModel class]
                  parameters:param
                finshedBlock:^(YRHttpResponse *response, BOOL result)
    {
        if (result) { //成功
            weakSelf.studyResultModel = response.responseObject;
            [weakSelf refreshView];
            
            if (studyResultType == YXExercisePickError) { // 刷新错词本
                [kNotificationCenter postNotificationName:kCareerErrorWordsChangeNotify object:nil userInfo:nil];
            }else {
                [kNotificationCenter postNotificationName:kWordListShouldRefreshDataNotify object:nil userInfo:nil];
            }
            if (studyResultType == YXExerciseNormal && weakSelf.studyResultModel.badgeIds.count) {
                [weakSelf getShareInfo];
            }
        }
    }];
}

- (NSDictionary *)resultparam {
    NSDictionary *param = @{};
    if(self.studyResultType == YXExerciseWordListStudy) {
        param = @{@"wordListId" : self.wordListId};
    }else if(self.studyResultType == YXExerciseWordListListen) {
        param = @{@"wordListId" : self.wordListId};;
    }
    return param;
}

- (NSString *)resultDomain {
    NSString *domain = DOMAIN_SPOTCHECKRESULT;
    if (self.studyResultType == YXExerciseNormal) {
        domain = DOMAIN_RESULT;
    }else if(self.studyResultType == YXExerciseWordListStudy) {
        domain = DOMAIN_WORDLISTLEARNRESULT;
    }else if(self.studyResultType == YXExerciseWordListListen) {
        domain = DOMAIN_WORDLISTLISTENRESULT;
    }
    return domain;
}


- (void)getShareInfo {
    NSArray *badgeIds = self.studyResultModel.badgeIds;
    NSLog(@"-------badgeIds-------%@",badgeIds);
    if (_curShowBadgeIndex < badgeIds.count) {
        NSString *currentBadgeId = [NSString stringWithFormat:@"%@",[badgeIds objectAtIndex:_curShowBadgeIndex]];
        YXBadgeModelOld *badgeModel = [[YXConfigure shared] badgeModelWith:currentBadgeId];
        [self popBadges:badgeModel shareModel:nil];
//        NSDictionary *param = @{@"badgeId" : badgeModel.badgeId};
//        [YXDataProcessCenter GET:DOMAIN_BADGESHARE parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
//            if (result) { // 注意此处wiki文档有问题多包了一层"share"
//                NSDictionary *shareDic = [response.responseObject objectForKey:@"share"]; //
//                YXShareLinkModel *shareLinkModel = [YXShareLinkModel mj_objectWithKeyValues:shareDic];
//                [self popBadges:badgeModel shareModel:shareLinkModel];
//            }
//        }];
    }else {
        _curShowBadgeIndex = 0;
    }
}
- (void)popBadges:(YXBadgeModelOld *)badgeModel shareModel:(YXShareLinkModel *)shareModel {
    __weak typeof(self) weakSelf = self;
    UIView *view = self.navigationController.view;
    [YXBadgeView showBadgeViewTo:view
                       WithModel:badgeModel shareModel:shareModel finishBlock:^{
                           _curShowBadgeIndex ++;
                           [weakSelf getShareInfo];
                       }];

}

//获取打卡积分配置
- (void)netConfigShare{
    __weak typeof (self) weakself = self;
    [YXDataProcessCenter GET:DOMAIN_CONFIGSHARE parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            if (response.responseObject) {
                NSLog(@"%@",response.responseObject);
                NSDictionary *userShareConfigDict = [response.responseObject objectForKey:@"userShareConfig"];
                NSInteger shareCredits =  [[userShareConfigDict objectForKey:@"shareCredits"]longValue];
                [weakself.shareCreditsTotalL setText:[NSString stringWithFormat:@"%ld",(long)shareCredits]];
                [weakself.shareCreditsTotalL setHidden:YES];
                if (shareCredits == 0){
                    [weakself.resultTipsImgView setHidden:YES];
                }
            }
        } else {
            //请求失败
            if (response.error.type == kBADREQUEST_TYPE) {
            }
        }
    }];
}


- (void)refreshView {
    NSArray *wordBrifInfoDics = self.studyResultModel.words;
    NSArray *wordBrifInfoModels = [[YXStudiedWordBrefInfo mj_objectArrayWithKeyValuesArray:wordBrifInfoDics] copy];
    NSArray *wordIds = [wordBrifInfoDics valueForKey:@"wordId"];
    NSString *idStr = [wordIds componentsJoinedByString:@","];
    wordIds = [idStr componentsSeparatedByString:@","];
    if (self.studyResultType) {
        if (self.studyResultType == YXExercisePickError) {
            self.reviewTotalL.text = [NSString stringWithFormat:@"成功复习了%@个单词",self.studyResultModel.sum];
            self.reviewRightL.text = [NSString stringWithFormat:@"已将%@个单词从错词本中移除",self.studyResultModel.right];
        }else {
            self.reviewTotalL.text = [NSString stringWithFormat:@"已完成%zd个单词的听写/学习",wordIds.count];
            self.reviewRightL.text = [NSString stringWithFormat:@"已听写/学习%zd个单词",wordIds.count];
        }
        [self.reviewRightL setAdjustsFontSizeToFitWidth:YES];
    }else {
        NSInteger time = [self.studyResultModel.learnTime integerValue];
        NSInteger minute = time / 60;
        NSInteger second = time % 60;
        self.timeCountLabel.text = [NSString stringWithFormat:@"%zd分%zd秒",minute,second];
        self.wordsCountLabel.text = [NSString stringWithFormat:@"%zd",wordIds.count];
    }
    [YXWordModelManager quardWithWordIds:wordIds completeBlock:^(id obj, BOOL result) {
        if (result) {
            NSArray *words = obj;
            for (YXWordDetailModel *wdm in words) {
                NSInteger index = [wordIds indexOfObject:wdm.wordid];
                YXStudiedWordBrefInfo *swbInfo = [wordBrifInfoModels objectAtIndex:index];
                swbInfo.wordDetailModel = wdm;
            }
            self.studiedWords = wordBrifInfoModels;
            [self.tableView reloadData];
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.punchButton.frame = CGRectMake(16, SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin, SCREEN_WIDTH - 32 , 44);
//        self.punchButton.frame = CGRectMake(AdaptSize(122), SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin, AdaptSize(239), AdaptSize(44));
        
        if (self.studyResultType == YXExerciseNormal){
            self.punchButton.frame = CGRectMake(AdaptSize(122), SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin, AdaptSize(239), AdaptSize(44));
        }
        else{
            self.punchButton.frame = CGRectMake(16, SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin, SCREEN_WIDTH - 32 , 44);
        }
        
        
        self.goBackButton.frame = CGRectMake(AdaptSize(14), SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin, AdaptSize(95), AdaptSize(44));
        
        self.resultTipsImgView.frame = CGRectMake(SCREEN_WIDTH - AdaptSize(145+18), SCREEN_HEIGHT - 36 - 22 - kSafeBottomMargin - AdaptSize(55) -5, AdaptSize(127.0), AdaptSize(55));
        
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (self.studyResultType) { // 左滑返回
//        [kNotificationCenter postNotificationName:kCareerErrorWordsChangeNotify object:nil userInfo:nil];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.studiedWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXStudyResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyResultCell" forIndexPath:indexPath];
    YXStudiedWordBrefInfo *swbInfo = [self.studiedWords objectAtIndex:indexPath.row];
    cell.swbInfo = swbInfo;
    cell.markLabel.hidden = (self.studyResultType != YXExercisePickError);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXStudiedWordBrefInfo *swbInfo = [self.studiedWords objectAtIndex:indexPath.row];
    YXWordDetailViewControllerOld *wordDetailVC = [YXWordDetailViewControllerOld wordDetailWith:swbInfo.wordDetailModel
                                                                                   bookId:swbInfo.bookId
                                                                            withBackBlock:nil];
    [self.navigationController pushViewController:wordDetailVC animated:YES];
    [self traceEvent:kTraceWordInfo descributtion:nil];
}

- (void)showShareOptions:(UIButton *)sender {
    if (self.studyResultType) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self.view title:@"网络不给力"];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    YXShareLodingView *shareLodingView  = [[YXShareLodingView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:shareLodingView];
    [[YXComHttpService shared] requestPunchShareURL:^(id obj, BOOL result) {
        if (result) {
            NSDictionary *info = [obj objectForKey:@"form"];
            YXPunchModel *punchMode = [YXPunchModel mj_objectWithKeyValues:info];
//            [YXShareView showShareInView:self.view punchModel:punchMode];
            [shareLodingView hideLoading];
            [YXPosterShareView showShareInView:self.view punchModel:punchMode block:^(id  _Nonnull obj) {
                    [weakSelf.resultTipsImgView setHidden:YES];
                    [weakSelf.shareCreditsTotalL setHidden:YES];
            }];
        }
        else{
            [shareLodingView hideLoading];
        }
        
        sender.userInteractionEnabled = YES;
    }];
    [self traceEvent:kTracePunchCardTime descributtion:nil];
}

- (void)cancleShare {
    [UIView animateWithDuration:0.3 animations:^{
        self.blackMask.alpha = 0;
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    }];
}

- (void)exitWordDetailPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareWithWeChat:(id)sender {
    WXWebpageObject *object = [WXWebpageObject object];
    object.webpageUrl = self.punchShareURL;
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    message.title = @"单词量up！今日份的单词打卡~【念念有词】";
    message.description = @"跟着念念学英语，考试提分不用愁。";
    message.mediaObject = object;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    sentMsg.scene = WXSceneSession;
    
    [WXApi sendReq:sentMsg];
}

- (void)shareWithMoment:(id)sender {
    WXWebpageObject *object = [WXWebpageObject object];
    object.webpageUrl = self.punchShareURL;
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    message.title = @"单词量up！今日份的单词打卡~【念念有词】";
    message.description = @"跟着念念学英语，考试提分不用愁。";
    message.mediaObject = object;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    
    sentMsg.scene = WXSceneTimeline;
    
    [WXApi sendReq:sentMsg];
}

- (void)shareWithQQ:(id)sender {
    QQApiNewsObject *object = [QQApiNewsObject
                               objectWithURL:[NSURL URLWithString:self.punchShareURL]
                               title:@"单词量up！今日份的单词打卡~【念念有词】"
                               description:@"跟着念念学英语，考试提分不用愁。"
                               previewImageURL:nil];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
    
    [QQApiInterface sendReq:req];
    //    [QQApiInterface SendReqToQZone:req];
    
}

@end



//// MARK: - Share
//self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
//self.shareView.backgroundColor = UIColor.whiteColor;
//
//self.blackMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//self.blackMask.backgroundColor = UIColor.blackColor;
//self.blackMask.alpha = 0;
//
//UILabel *wechatLabel = [[UILabel alloc] init];
//wechatLabel.textColor = UIColorOfHex(0x485461);
//wechatLabel.font = [UIFont systemFontOfSize:14];
//wechatLabel.text = @"微信";
//
//UILabel *momentLabel = [[UILabel alloc] init];
//momentLabel.textColor = UIColorOfHex(0x485461);
//momentLabel.font = [UIFont systemFontOfSize:14];
//momentLabel.text = @"朋友圈";
//
//UILabel *qqLabel = [[UILabel alloc] init];
//qqLabel.textColor = UIColorOfHex(0x485461);
//qqLabel.font = [UIFont systemFontOfSize:14];
//qqLabel.text = @"QQ";
//
//UIButton *wechatButton = [[UIButton alloc] init];
//[wechatButton setImage:[UIImage imageNamed:@"学习结果页的微信"] forState:UIControlStateNormal];
//[wechatButton addTarget:self action:@selector(shareWithWeChat:) forControlEvents:UIControlEventTouchUpInside];
//
//UIButton *momentButton = [[UIButton alloc] init];
//[momentButton setImage:[UIImage imageNamed:@"学习结果页的朋友圈"] forState:UIControlStateNormal];
//[momentButton addTarget:self action:@selector(shareWithMoment:) forControlEvents:UIControlEventTouchUpInside];
//
//UIButton *qqButton = [[UIButton alloc] init];
//[qqButton setImage:[UIImage imageNamed:@"学习结果页的QQ"] forState:UIControlStateNormal];
//[qqButton addTarget:self action:@selector(shareWithQQ:) forControlEvents:UIControlEventTouchUpInside];
//
//UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 136, SCREEN_WIDTH, 10)];
//lineView.backgroundColor = UIColorOfHex(0xEFF4F7);
//
//UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 146, SCREEN_WIDTH, 54)];
//[cancleButton setTitle:@"取消" forState:UIControlStateNormal];
//[cancleButton setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
//[cancleButton addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
//
//[self.view addSubview:self.blackMask];
//[self.view addSubview:self.shareView];
//[self.shareView addSubview:wechatLabel];
//[self.shareView addSubview:momentLabel];
//[self.shareView addSubview:qqLabel];
//[self.shareView addSubview:wechatButton];
//[self.shareView addSubview:momentButton];
//[self.shareView addSubview:qqButton];
//[self.shareView addSubview:lineView];
//[self.shareView addSubview:cancleButton];
//
//[momentButton mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.shareView).offset(30);
//    make.height.width.mas_equalTo(54);
//    make.centerX.equalTo(self.shareView);
//}];
//
//[momentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerX.equalTo(momentButton);
//    make.top.equalTo(momentButton.mas_bottom).offset(10);
//}];
//
//[wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerY.equalTo(momentButton);
//    make.centerX.equalTo(self.shareView).offset( - (SCREEN_WIDTH / 4));
//    make.height.width.mas_equalTo(54);
//}];
//
//[wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerX.equalTo(wechatButton);
//    make.bottom.equalTo(momentLabel);
//}];
//
//[qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerY.equalTo(momentButton);
//    make.centerX.equalTo(self.shareView).offset(SCREEN_WIDTH / 4);
//    make.height.width.mas_equalTo(54);
//}];
//
//[qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerX.equalTo(qqButton);
//    make.bottom.equalTo(momentLabel);
//    }];
