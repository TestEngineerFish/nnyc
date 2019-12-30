//
//  YXMyWordBookDetailVC.m
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookDetailVC.h"
#import "YXMyWordDetailCell.h"
#import "YXSelectMyWordHeaderView.h"
#import "YXWordModelManager.h"
#import "YXMyWordListDetailModel.h"
#import "YXBaseWebViewController.h"

@interface YXProgressElementView : UIView
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, weak) UILabel *markLabel;
@property (nonatomic, assign) BOOL hideDotView;
@end

@implementation YXProgressElementView
- (instancetype)initWithMarkText:(NSString *)markText {
    if (self = [super init]) {
        self.markLabel.text = markText;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dotView = [[UIView alloc] init];
        self.dotView.layer.cornerRadius = AdaptSize(3);
        self.dotView.layer.masksToBounds = YES;
        self.dotView.backgroundColor = UIColorOfHex(0x849EC5);
        [self addSubview:self.dotView];
        [self markLabel];
        self.hideDotView = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    
    if (self.hideDotView == NO) {
        CGFloat dotWH = AdaptSize(6);
        self.dotView.frame = CGRectMake(0,(size.height - dotWH) * 0.5, dotWH, dotWH);
        self.markLabel.frame = CGRectMake(self.dotView.right + dotWH, 0, size.width - self.dotView.right - dotWH, size.height);
    }else {
        self.markLabel.frame = CGRectMake(0, 0, size.width, size.height);
    }
    
}

- (UILabel *)markLabel {
    if (!_markLabel) {
        UILabel *markLabel = [[UILabel alloc] init];
        markLabel.preferredMaxLayoutWidth = AdaptSize(200);
        markLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(15)];
        markLabel.textColor = UIColorOfHex(0x849EC5);
        [self addSubview:markLabel];
        _markLabel = markLabel;
    }
    return _markLabel;
}
@end



static NSString *const kYXMyWordDetailCellID = @"YXMyWordDetailCellID";

@interface YXMyWordBookDetailVC ()
@property (nonatomic, weak) UILabel *wordListNameLabel;
@property (nonatomic, weak) UILabel *wordListDateLabel;
@property (nonatomic, weak) YXSpringAnimateButton *studyBtn;
@property (nonatomic, weak) YXSpringAnimateButton *listenBtn;
@property (nonatomic, copy) NSArray *wordsModels;
//@property (nonatomic, weak) YXProgressElementView *elementView;
@property (nonatomic, weak) UIView *crossLine;
@property (nonatomic, strong) YXMyWordListDetailModel *wordListDetailModel;
@property (nonatomic, weak) YXProgressElementView *shareSourceView;
@property (nonatomic, weak) YXSpringAnimateButton *listReportButton;
@property (nonatomic, weak) YXSpringAnimateButton *saveToMyWordList;
@end

@implementation YXMyWordBookDetailVC
-(instancetype)init {
    if (self = [super init]) {
        self.isOwnWordList = YES;
    }
    return self;
}
- (instancetype)initWithMyWordBookModel:(YXMyWordBookModel *)myWordBookModel {
    if (self = [super init]) {
        self.myWordBookModel = myWordBookModel;
        self.isOwnWordList = YES;
    }
    return self;
}
- (NSArray *)rightBarItemImages {
    return @[@"ShareIcon"];
}

- (NSDictionary *)registerCellInfo {
    return @{
             ReuseIdentifierKey : kYXMyWordDetailCellID,
             ReuseClassKey : [YXMyWordDetailCell class]
             };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self refreshData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"词单详情";
    [self.wordListNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wordListTableView);
        make.top.equalTo(self.view).offset(AdaptSize(17));
    }];
    
    if (self.isOwnWordList) {
        [self.changeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wordListNameLabel);
            make.left.equalTo(self.wordListNameLabel.mas_right).offset(7);
            make.size.mas_equalTo(CGSizeMake(50, 44));
        }];
        
        [self.studyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView).offset(kIsIPhoneXSerious ? AdaptSize(10) : AdaptSize(5));
            make.right.equalTo(self.bottomView.mas_centerX).offset(-AdaptSize(15));
            make.size.mas_equalTo(MakeAdaptCGSize(130, 38));
        }];
        
        [self.listenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.centerY.equalTo(self.studyBtn);
            make.left.equalTo(self.bottomView.mas_centerX).offset(AdaptSize(15));
        }];
        
        
        self.rightBarItemBtn.hidden = NO;
    
        
        [self.listReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-AdaptSize(15));
            make.bottom.equalTo(self.wordListTableView.mas_top).offset(-AdaptSize(18));
            make.size.mas_equalTo(MakeAdaptCGSize(58, 65));
        }];
        [self handleData:NO];
        [self handleWordListDetail];
    }else {
        [self.wordListTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(AdaptSize(50));
        }];
        self.wordListNameLabel.text = self.myWordBookModel.wordListName;
        [self.saveToMyWordList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView).offset(kIsIPhoneXSerious ? AdaptSize(10) : AdaptSize(5));
            make.centerX.equalTo(self.bottomView);
            make.size.mas_equalTo(MakeAdaptCGSize(200, 40));
        }];
        
        self.wordListDetailModel = (YXMyWordListDetailModel *)self.myWordBookModel;
        [self quaryWordsInfo];
        self.changeNameBtn.hidden = YES;
        self.rightBarItemBtn.hidden = YES;
        self.wordListTableView.hidden = NO;
        self.bgView.hidden = NO;
        self.bottomView.hidden = NO;
        self.wordListNameLabel.hidden = NO;
    }
}

- (void)saveTomyWordListAction {
    if (![self isOwnWordList]) {
        YXMyWordListDetailModel *wordListDetailModel = (YXMyWordListDetailModel *)self.myWordBookModel;
        NSArray *wordIds = [wordListDetailModel.words valueForKeyPath:@"wordId"];
        NSString *wordIdsStr = [wordIds componentsJoinedByString:@"|"];
        NSDictionary *param = @{
                                @"words" : wordIdsStr,
                                @"wordListName" : self.myWordBookModel.wordListName,
                                @"shareCode"    : self.myWordBookModel.shareCode
                                };
        [YXDataProcessCenter POST:DOMAIN_SAVEWORDLIST
                       parameters:param
                     finshedBlock:^(YRHttpResponse *response, BOOL result) {
                         if (result) {
                             [kNotificationCenter postNotificationName:kSaveWordListSuccessNotify object:nil userInfo:nil];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     }];
    }

}


- (void)rightBarItemClick:(UIButton *)btn {
}

- (void)handleData:(BOOL)success {
    BOOL hidden = !success;
    self.wordListTableView.hidden = hidden;
    self.bgView.hidden = hidden;
    self.bottomView.hidden = hidden;
    self.changeNameBtn.hidden = hidden;
    self.wordListNameLabel.hidden = hidden;
}

- (void)handleWordListDetail {
    NSString *wordListId = self.myWordBookModel.wordListId;
    if (!wordListId) {
        wordListId = @"";
    }
    NSDictionary *param = @{@"wordListId" : self.myWordBookModel.wordListId};
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:DOMAIN_WORDLISTDETAILS
                  parameters:param
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
                    if (result) {
                        [weakSelf hideNoNetWorkView];
                        NSDictionary *info = [response.responseObject objectForKey:@"wordListDetails"];
                        YXMyWordListDetailModel *wordListDetailModel = [YXMyWordListDetailModel mj_objectWithKeyValues:info];
                        [weakSelf refreshViewWith:wordListDetailModel];
                    }else {
                        if (response.error.type == kBADREQUEST_TYPE) {
                            [weakSelf showNoNetWorkView:^{ // tapAction
                                [weakSelf handleWordListDetail];
                            }];
                        }
                    }
                }];
}

- (void)refreshData {
    [self handleWordListDetail];
}


- (void)refreshViewWith:(YXMyWordListDetailModel *)wordListDetailModel {
    self.wordListDetailModel = wordListDetailModel;
    [self setupProgressView];
    
    self.listReportButton.hidden = !wordListDetailModel.learnReportPage.length;
    [self.view bringSubviewToFront:self.listReportButton];

    [self handleData:YES];
    
    self.wordListNameLabel.text = wordListDetailModel.wordListName;
    NSString *studyTitle = [NSString stringWithFormat:@" %@",wordListDetailModel.studyStateString];
    [self.studyBtn setTitle:studyTitle forState:UIControlStateNormal];
    NSString *listenTitle = [NSString stringWithFormat:@" %@",wordListDetailModel.listenStateString];
    [self.listenBtn setTitle:listenTitle forState:UIControlStateNormal];
    
    [self quaryWordsInfo];
}


- (void)setupProgressView {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[YXProgressElementView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [_crossLine removeFromSuperview];
    _crossLine = nil;
    CGFloat topMargin = AdaptSize(45);
    CGFloat elementH = AdaptSize(25);
//    self.wordListDetailModel.wordListDetails.sharingPerson = @"Taylor Swift";
    if (self.wordListDetailModel.sharingPerson.length) {
        YXProgressElementView *elementView = [[YXProgressElementView alloc] initWithMarkText:self.wordListDetailModel.sharingPersonDesc];
        elementView.hideDotView = YES;
        [self.view addSubview:elementView];
        [elementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wordListNameLabel);
            make.right.equalTo(self.wordListTableView);
            make.top.equalTo(self.view).offset(topMargin);
            make.height.mas_equalTo(elementH);
        }];
        topMargin += elementH;
    }

    NSArray *markTexts = self.wordListDetailModel.markTexts;
    NSMutableArray *elementViews = [NSMutableArray array];
    for (NSString * markText in markTexts) {
        YXProgressElementView *elementView = [[YXProgressElementView alloc] initWithMarkText:markText];
        [elementViews addObject:elementView];
        [self.view addSubview:elementView];
        [elementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wordListNameLabel);
            make.right.equalTo(self.wordListTableView);
            make.top.equalTo(self.view).offset(topMargin);
            make.height.mas_equalTo(elementH);
        }];
        topMargin += elementH;
    }
    
    if (markTexts.count > 1) {
        YXProgressElementView *firstElementView = elementViews.firstObject;
        YXProgressElementView *lastElementView = elementViews.lastObject;
        [self.crossLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstElementView.mas_centerY);
            make.left.equalTo(firstElementView.dotView.mas_centerX).offset(- 0.5);
            make.width.mas_equalTo(1);
            make.bottom.equalTo(lastElementView.mas_centerY);
        }];
    }
    
    [self.wordListTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topMargin + AdaptSize(12));
    }];
}

#pragma mark - handleData
- (void)quaryWordsInfo {
    for (YXMyWordListCellModel *cellModel in self.wordListDetailModel.words) {
        [YXWordModelManager quardWithWordId:cellModel.wordId completeBlock:^(id obj, BOOL result) {
            cellModel.wordDetail = obj;
        }];
    }
    [self.wordListTableView reloadData];
    return;
}
#pragma mark - actions
- (void)studyAction {
    [self myWordBookEnterProcess:self.wordListDetailModel
                    exerciseType:YXExerciseWordListStudy];
}

- (void)listenAction {
    [self myWordBookEnterProcess:self.wordListDetailModel
                    exerciseType:YXExerciseWordListListen];
}

- (void)checkReport {
    YXBaseWebViewController *webVC = [[YXBaseWebViewController alloc] initWithLink:self.wordListDetailModel.learnReportPage
                                                                             title:@"学习报告"];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordListDetailModel.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMyWordDetailCell *cell = (YXMyWordDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.wordModel = [self.wordListDetailModel.words objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXMyWordBaseHeaderView *header = (YXMyWordBaseHeaderView *)[super tableView:tableView viewForHeaderInSection:section];
    header.titleLabel.text = [NSString stringWithFormat:@"共%zd个单词",self.wordListDetailModel.total];//@"共32个单词";
    if (self.isOwnWordList) {
        header.progressLabel.text = [NSString stringWithFormat:@"(已学习%zd个 已听写%zd个)",self.wordListDetailModel.learn,self.wordListDetailModel.listen];// @"(已学习6个 已听写3个)";
    }
    
    return header;
}

- (void)changeWordListName {
    [self showChangeNameViewWithDefaultName:self.myWordBookModel.wordListName];
}

- (void)wordBookBaseManageView:(YXWordBookBaseManageView *)wordBookBaseManageView clickedButonAtIndex:(NSInteger)idnex {
    if (idnex == 1) {
        NSString *name = wordBookBaseManageView.currentText;
        if (name.length) {
            NSDictionary *param = @{
                                    @"wordListId" : self.myWordBookModel.wordListId,
                                    @"wordListName" : name
                                    };
            [YXDataProcessCenter POST:DOMAIN_UPDATEWORDLIST
                           parameters:param
                         finshedBlock:^(YRHttpResponse *response, BOOL result)
            {
                if (result) {
                    [kNotificationCenter postNotificationName:kWordListShouldRefreshDataNotify object:nil userInfo:nil];
                }
            }];
        }
    }
}
#pragma mark - subviews
- (UILabel *)wordListNameLabel {
    if (!_wordListNameLabel) {
        UILabel *wordListNameLabel = [[UILabel alloc] init];
        if (self.isOwnWordList) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeWordListName)];
            [wordListNameLabel addGestureRecognizer:tap];
        }
        wordListNameLabel.userInteractionEnabled = YES;
        wordListNameLabel.preferredMaxLayoutWidth = AdaptSize(250);
        wordListNameLabel.textColor = UIColorOfHex(0x485461);
        wordListNameLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(16)];
        [self.view addSubview:wordListNameLabel];
        _wordListNameLabel = wordListNameLabel;
    }
    return _wordListNameLabel;
}

- (YXSpringAnimateButton *)studyBtn {
    if (!_studyBtn) {
        YXSpringAnimateButton *studyBtn = [self bottomBtn];
        [studyBtn addTarget:self action:@selector(studyAction) forControlEvents:UIControlEventTouchUpInside];
        [studyBtn setImage:[UIImage imageNamed:@"penIcon_doing"] forState:UIControlStateNormal];
        _studyBtn = studyBtn;
    }
    return _studyBtn;
}


- (YXSpringAnimateButton *)listenBtn {
    if (!_listenBtn) {
        YXSpringAnimateButton *listenBtn = [self bottomBtn];
        [listenBtn addTarget:self action:@selector(listenAction) forControlEvents:UIControlEventTouchUpInside];
        [listenBtn setImage:[UIImage imageNamed:@"headphoneIcon_doing"] forState:UIControlStateNormal];
        _listenBtn = listenBtn;
    }
    return _listenBtn;
}

- (YXSpringAnimateButton *)saveToMyWordList {
    if (!_saveToMyWordList) {
        YXSpringAnimateButton *saveToMyWordList = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        [saveToMyWordList setTitle:@"保存到我的词单" forState:UIControlStateNormal];
        [saveToMyWordList setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        saveToMyWordList.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [saveToMyWordList setBackgroundImage:[UIImage imageNamed:@"saveToMywordListIcon"] forState:UIControlStateNormal];
        [saveToMyWordList addTarget:self action:@selector(saveTomyWordListAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:saveToMyWordList];
        _saveToMyWordList = saveToMyWordList;
    }
    return _saveToMyWordList;
}

- (YXSpringAnimateButton *)bottomBtn {
    YXSpringAnimateButton *bottomBtn = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
    [bottomBtn setTitleColor:UIColor.blueTextColor forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"bottomBtnGrayIcon"] forState:UIControlStateNormal];
    [self.view addSubview:bottomBtn];
    return bottomBtn;
}


- (YXSpringAnimateButton *)listReportButton {
    if (!_listReportButton) {
        YXSpringAnimateButton *listReportButton = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        listReportButton.hidden = YES;
        [self.view addSubview:listReportButton];
        [listReportButton addTarget:self action:@selector(checkReport) forControlEvents:UIControlEventTouchUpInside];
        [listReportButton setBackgroundImage:[UIImage imageNamed:@"listReportIcon"] forState:UIControlStateNormal];
        _listReportButton = listReportButton;
    }
    return _listReportButton;
}


- (UIView *)crossLine {
    if (!_crossLine) {
        UIView *crossLine = [[UIView alloc] init];
        crossLine.backgroundColor = UIColorOfHex(0x849EC5);//[UIColor redColor];
        [self.view addSubview:crossLine];
        _crossLine = crossLine;
    }
    return _crossLine;
}


- (UILabel *)wordListDateLabel {
    if (!_wordListDateLabel) {
        UILabel *wordListDateLabel = [[UILabel alloc] init];
        wordListDateLabel.preferredMaxLayoutWidth = AdaptSize(200);
        NSMutableAttributedString *point = [[NSMutableAttributedString alloc] initWithString:@"● "
                                                                                  attributes:@{NSForegroundColorAttributeName : UIColorOfHex(0x849EC5),
                                                                                               NSFontAttributeName: [UIFont pfSCRegularFontWithSize:AdaptSize(10)],
                                                                                               NSBaselineOffsetAttributeName : @(AdaptSize(1))
                                                                                               }];
        NSString *createDate = [NSString stringWithFormat:@"%@ 创建",self.myWordBookModel.createDateDesc];
        NSAttributedString  *detail = [[NSAttributedString alloc] initWithString:createDate//@"2018-12-01 09:23 创建"
                                                                      attributes:@{NSForegroundColorAttributeName : UIColorOfHex(0x849EC5),
                                                                                   NSFontAttributeName: [UIFont pfSCRegularFontWithSize:AdaptSize(15)]
                                                                                   }];
        [point appendAttributedString:detail];
        wordListDateLabel.attributedText = point;
        [self.view addSubview:wordListDateLabel];
        _wordListDateLabel = wordListDateLabel;
    }
    return _wordListDateLabel;
}
@end


