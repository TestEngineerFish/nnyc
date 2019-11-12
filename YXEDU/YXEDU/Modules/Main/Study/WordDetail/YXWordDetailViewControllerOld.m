//
//  YXWordDetailViewControllerOld.m
//  YXEDU
//
//  Created by yao on 2018/10/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordDetailViewControllerOld.h"
#import "YXWordDetailSectionHeader.h"
#import "YXWordDetailTextCell.h"
#import "YXReportErrorView.h"
#import "YXWordModelManager.h"
#import "AVAudioPlayerManger.h"
#import "YXAudioAnimations.h"
#import "YXWordDetailAudioCell.h"
#import "YXRemotePlayer.h"
#import "Growing.h"
#import "BSUtils.h"
#import "YXWordDetailMemoryCell.h"
#import "YXWordDetailExamCell.h"
#import "YXWordToolkitModel.h"
#import "YXDataProcessCenter.h"
#import "YXWordDetailToolkitView.h"
#import "YXUserSaveTool.h"
#import "YXUnVipNormalCell.h"

static NSString *const kYXWordDetailSectionHeaderID = @"YXWordDetailSectionHeaderID";
static NSString *const kYXWordDetailTextCellID = @"YXWordDetailTextCellID";
static NSString *const kYXWordDetailAudioCellID = @"YXWordDetailAudioCellID";
static NSString *const kYXWordDetailMemoryCellID = @"YXWordDetailMemoryCellID";
static NSString *const kYXWordDetailExamCellID = @"YXWordDetailExamCellID";
static NSString *const kYXUnVipNormalCellID = @"YXUnVipNormalCellID";


//单词详情
@interface YXWordDetailViewControllerOld ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, weak)UIView *tableHeadView;
@property (nonatomic, weak)UIButton *bottomLeftButton;

@property (nonatomic, strong)UILabel *wordL;
@property (nonatomic, strong)YXAudioAnimations *speakerBtn;
@property (nonatomic, strong)UILabel *phoneticSymbolL;
@property (nonatomic, weak)UIView *playSoundArea;

@property (nonatomic, strong)UILabel *explanL;
@property (nonatomic, weak)UIImageView *wordImage;
@property (nonatomic, strong)YXComNaviView *naviView;
@property (nonatomic, strong)NSMutableArray *wordFormModes;

@property (nonatomic, strong)NSMutableDictionary *wordDetailDic;
@property (nonatomic, copy) void(^backActionBlock)(void) ;

@property (nonatomic, strong)YXRemotePlayer *remotePlayer;
@property (nonatomic, weak) YXAudioAnimations *speakButton;

@property (nonatomic, strong)NSDate *studyStartDate;

@property (nonatomic, strong)NSDictionary *toolkit;
@property (nonatomic, strong)NSDictionary *examKey;
@property (nonatomic, strong)NSDictionary *memoryKey;

@property (nonatomic, strong)YXWordToolkitModel *toolkitModel;

@property (nonatomic , strong) UIImageView *guideView;

@property (nonatomic , strong) UIImageView *noteBGView;

@property (nonatomic, weak) UIButton *toolKitButton ;

@end

@implementation YXWordDetailViewControllerOld
+ (YXWordDetailViewControllerOld *)wordDetailWith:(YXWordDetailModel *)wordDetailModel bookId:(NSString *)bookId {
    return [self wordDetailWith:wordDetailModel bookId:bookId withBackBlock:nil];
}

+ (YXWordDetailViewControllerOld *)wordDetailWith:(YXWordDetailModel *)wordDetailModel bookId:(NSString *)bookId withBackBlock:(void (^)(void))backActionBlock
{
    YXWordDetailViewControllerOld *wordDetailVC = [[self alloc] init];
    wordDetailVC.wordDetailModel = wordDetailModel;
    wordDetailVC.bookId = bookId;
    if (backActionBlock) {
        wordDetailVC.backActionBlock = [backActionBlock copy];
    }
    return wordDetailVC;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.naviView];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    __weak typeof(self) weakSelf = self;
//    [self announcement];
    [self announcementWith:^{ //远程播放器处于unkonw状态无法暂停
//        [weakSelf playSentenceSound];  //自动播放例句
    }];
}

- (void)setCareerWordInfo:(YXCareerWordInfo *)careerWordInfo {
    _careerWordInfo = careerWordInfo;
    self.bookId = careerWordInfo.bookId;
    self.wordDetailModel = careerWordInfo.wordDetail;
}
- (void)setWordDetailModel:(YXWordDetailModel *)wordDetailModel {
    _wordDetailModel = wordDetailModel;
    self.wordDetailDic = [wordDetailModel mj_keyValues];
    self.toolkit =  [BSUtils dictionaryWithJsonString:_wordDetailModel.toolkit];
    self.examKey = [self.toolkit objectForKey:@"examKey"];
    self.memoryKey = [self.toolkit objectForKey:@"memoryKey"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.studyStartDate = [NSDate date];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    YXComNaviView *naviView = [[YXComNaviView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight)];
    naviView.leftButton.hidden = YES;
    naviView.titleLabel.text = @"单词释义";
    [naviView.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"report_error_icon"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(reportError)];
    naviView.rightButtonItem = item;
    //取消nav
//    [self.view addSubview:naviView];
    _naviView = naviView;
    
    [self tableView];
    [self bottomView];
    [self tableHeadView];
    CGFloat bottomSafeMargin = kSafeBottomMargin;
//    if (isIPhoneXSerious()){
//        bottomSafeMargin = kSafeBottomMargin -10.0;
//    }
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.bottom.equalTo(self.view).offset(-bottomSafeMargin);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    if ([NetWorkRechable shared].connected) {
       [self checkWordFavState:self.wordDetailModel.wordid bookId:self.bookId];
    }
    
    [self refreshContent];
    // 统计
    [Growing track:kGrowingTraceWordInfo withVariable:@{@"word_id":self.bookId}];
    
    NSInteger wordToolkitState = [YXConfigure shared].confModel.baseConfig.wordToolkitState;
    
    [self configNoteBGView];
    
    if (wordToolkitState == 1) {
        self.guideView = [[UIImageView alloc]initWithFrame:self.view.frame];
        [self.guideView setImage:[UIImage imageNamed:@"toolkit引导"]];
        self.guideView .userInteractionEnabled = YES;
        [self.guideView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guideViewClicked)]];
        [self.view addSubview:self.guideView];
    }
    else{
        
        NSString *isNoteBGView = [YXUserSaveTool valueForKey:@"noteBGView"];
        
        if ([BSUtils isBlankString:isNoteBGView]) {
            [self.noteBGView setHidden:NO];
        }
        else {
            NSLog(@"已经加载引导");
        }

    }
    
}

-(void)configNoteBGView{
    
    UIImageView *noteBGView = [[UIImageView alloc]initWithFrame:CGRectMake(17.0, self.bottomView.frame.origin.y - 91.0, 194.0, 91.0)];
    [noteBGView setImage:[UIImage imageNamed:@"WordDetail提示背景"]];
    noteBGView.userInteractionEnabled = YES;
    [noteBGView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noteBGViewClicked)]];
    
    [self.view addSubview:noteBGView];
    
    self.noteBGView = noteBGView;
    UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150.0, 100.0)];
    [noteLabel setText:@"在这里也可以解锁词汇工具箱~"];
    noteLabel.numberOfLines = 0;
    [noteLabel setFont:[UIFont systemFontOfSize:15.0]];
    [noteLabel setTextColor:UIColorOfHex(0x103B69)];
    [self.noteBGView addSubview:noteLabel];
    
    UILabel *noteOKLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 58.0, 24.0)];
    [noteOKLabel setText:@"好的"];
    [noteOKLabel setTextAlignment:NSTextAlignmentCenter];
    [noteOKLabel setTextColor:UIColorOfHex(0x55A7FD)];
    [noteOKLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [noteOKLabel.layer setCornerRadius:12.0];
    [noteOKLabel.layer setBorderColor:UIColorOfHex(0x55A7FD).CGColor];
    [noteOKLabel.layer setBorderWidth:1.0];
    
    [self.noteBGView addSubview:noteOKLabel];
    
    [self.noteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17.0);
        make.height.mas_equalTo(91.0);
        make.width.mas_equalTo(194.0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(10.0);
    }];
    
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noteBGView).offset(12.0);
        make.top.equalTo(self.noteBGView.mas_top).offset(13.0);
        make.right.equalTo(self.noteBGView).offset(-12.0);
    }];
    
    [noteOKLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.noteBGView.mas_right).offset(-20.0);
        make.top.equalTo(self.noteBGView.mas_top).offset(40.0);
        make.width.mas_equalTo(58.0);
        make.height.mas_equalTo(24.0);
    }];
    [self.noteBGView setHidden:YES];
}

-(void)noteBGViewClicked{
    [self.noteBGView setHidden:YES];
    [YXUserSaveTool setObject:@"BGView" forKey:@"noteBGView"];
}

-(void)guideViewClicked{
    NSLog(@"guideViewClicked");
    [self.guideView  removeFromSuperview];
    [self.noteBGView setHidden:NO];
    [YXUserSaveTool setObject:@"isToolkitView" forKey:@"isToolkitView"];
    [self testVipForThreeDays];
}

//体验开通
-(void)testVipForThreeDays{
    
    //网络请求
    [YXDataProcessCenter POST:DOMAIN_USERWORDHANDLEWORDTOOLKIT parameters:@{@"code":@""} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        
        if (result) {
            [YXUtils showHUD:self.view title:@"体验开通成功！"];
            [YXConfigure shared].confModel.baseConfig.wordToolkitState = 2;
            [self.tableView reloadData];
        }
        else {
            NSString *msg = [response.responseObject objectForKey:@"msg"];
            [YXUtils showHUD:self.view title:msg];
        }
    }];
    
}

- (void)checkWordFavState:(NSString *)wordId bookId:(NSString *)bookId {
    [YXDataProcessCenter GET:DOMAIN_WORDFAVSTATE parameters:@{@"wordId" : wordId,@"bookId" : bookId} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            self.bottomLeftButton.selected = [[response.responseObject objectForKey:@"isFav"] integerValue];
        }
    }];
}

- (void)refreshContent {
    self.wordL.text = self.wordDetailModel.word;
    self.phoneticSymbolL.text = [YXConfigure shared].confModel.baseConfig.speech ?  self.wordDetailModel.usphone : self.wordDetailModel.ukphone;
    
    if ([BSUtils isBlankString:self.wordDetailModel.meanings]) {
        self.explanL.text = self.wordDetailModel.explainText;
    }
    else{
        
        NSString *content = self.wordDetailModel.meanings;
        
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        
        NSRange range = NSMakeRange(0, attriStr.length);
        // 设置字体大小
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:range];
        
        [self.explanL setAttributedText:attriStr];
    }
    
    
    UIImage *placeholderImage = [UIImage imageNamed:@"wordPlaceHolderImage"];
    if (self.wordDetailModel.hasImage) { // 接口报错判空处理
        NSString *URLString = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.baseConfig.cdn,self.wordDetailModel.image];
        [self.wordImage sd_setImageWithURL:[NSURL URLWithString:URLString]
                          placeholderImage:[UIImage imageNamed:@"wordPlaceHolderImage"]];
    }else {
        self.wordImage.image = placeholderImage;
    }

    CGFloat height = [self.explanL.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName : self.explanL.font}
                                                     context:nil].size.height;
    self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH,height + 196);
    //section
    NSMutableArray *wordFormModes = [YXConfigure shared].confModel.wordFrame;
    self.wordFormModes = [NSMutableArray array];
    
    for (YXWordFormModel *wfModel in wordFormModes) {
        for (YXContentListItem  *item in wfModel.contentList) {
            NSString *content = [self.wordDetailDic objectForKey:item.contentKey];
            if (content.length) {
                [self.wordFormModes addObject:wfModel];
                break;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2+self.wordFormModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.memoryKey) {
            NSArray *content = [self.memoryKey objectForKey:@"content"];
            return content.count;
        }
        return 0;
    }
    
    if (section == 1) {
        if (self.examKey) {
            NSArray *content = [self.examKey objectForKey:@"content"];
            return content.count;
        }
        return 0;
    }
    
    YXWordFormModel *groupFrom = [self.wordFormModes objectAtIndex:(section-2)];
    return groupFrom.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger wordToolkitState = [YXConfigure shared].confModel.baseConfig.wordToolkitState;
    
    if (indexPath.section == 0) {
        
        if (wordToolkitState != 2) {
            
            YXUnVipNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXUnVipNormalCellID forIndexPath:indexPath];
            
            NSMutableAttributedString *vipStr = [[NSMutableAttributedString alloc]initWithString:@"点击解锁【识记方法】"];
            
            UIImage *vipImage = [UIImage imageNamed:@"WordDetailNor解锁"];
            NSTextAttachment *vipImageAttachment = [[NSTextAttachment alloc]init];
            vipImageAttachment.image = vipImage;
            vipImageAttachment.bounds = CGRectMake(3, -2, 13, 15);
            
            NSAttributedString *vipImageAttrStr = [NSAttributedString attributedStringWithAttachment:vipImageAttachment];
            
            [vipStr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
            [vipStr insertAttributedString:vipImageAttrStr atIndex:0];
            [vipStr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
            
            //设置字体和设置字体的范围
            [vipStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, vipStr.length)];
            //添加文字颜色
            [vipStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFDA751) range:NSMakeRange(0, vipStr.length)];
            
            [cell.noteL setAttributedText:vipStr];
            
            return cell;
        }
        
        YXWordDetailMemoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXWordDetailMemoryCellID forIndexPath:indexPath];
        
        cell.titleL.attributedText = [self getTitleMemoryKeyAttributedValueForRow:indexPath.row];
        cell.contentL.attributedText = [self getContentMemoryKeyAttributedValueForRow:indexPath.row];
        
        return cell;
        
    }
    else if (indexPath.section == 1){
        
        if (wordToolkitState != 2) {
            YXUnVipNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXUnVipNormalCellID forIndexPath:indexPath];
            NSMutableAttributedString *vipStr = [[NSMutableAttributedString alloc]initWithString:@"点击解锁【中考考点】"];
            
            UIImage *vipImage = [UIImage imageNamed:@"WordDetailNor解锁"];
            NSTextAttachment *vipImageAttachment = [[NSTextAttachment alloc]init];
            vipImageAttachment.image = vipImage;
            vipImageAttachment.bounds = CGRectMake(3, -2, 13, 15);
            
            NSAttributedString *vipImageAttrStr = [NSAttributedString attributedStringWithAttachment:vipImageAttachment];
            
            [vipStr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
            [vipStr insertAttributedString:vipImageAttrStr atIndex:0];
            [vipStr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
            
            //设置字体和设置字体的范围
            [vipStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, vipStr.length)];
            //添加文字颜色
            [vipStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFDA751) range:NSMakeRange(0, vipStr.length)];
            
            [cell.noteL setAttributedText:vipStr];
            
            return cell;
        }
        
        NSArray *content = [self.examKey objectForKey:@"content"];
        
        NSDictionary *contentDict = content[indexPath.row];
        
        YXWordDetailExamCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXWordDetailExamCellID forIndexPath:indexPath];
        
        cell.titleL.attributedText = [self getTitleExamKeyAttributedValueForRow:indexPath.row];
        
        NSString *contentStr = [contentDict objectForKey:@"content"];
        
        if ([BSUtils isBlankString:contentStr]){
            [cell.openBtn setHidden:YES];
            [cell.contentL setHidden:YES];
        }
        else
        {
            [cell.openBtn setHidden:NO];
            
            NSString *isOpen =  [contentDict objectForKey:@"open"];
            
            if(![BSUtils isBlankString:isOpen]){
                
                cell.contentL.attributedText = [[NSAttributedString alloc] initWithString:@" "];
                cell.contentL.attributedText = [self getContentExamKeyAttributedValueForRow:indexPath.row];
                [cell.contentL setHidden:NO];
                
                NSMutableAttributedString *btnAttrStr = [[NSMutableAttributedString alloc]initWithString:@"收起 "];
                
                UIImage *btnOpenImage = [UIImage imageNamed:@"WordDetail收起"];
                NSTextAttachment *btnOpenAttachment = [[NSTextAttachment alloc]init];
                btnOpenAttachment.image = btnOpenImage;
                btnOpenAttachment.bounds = CGRectMake(0, 0, 12, 7);
                
                NSAttributedString *btnOpenAttrStr = [NSAttributedString attributedStringWithAttachment:btnOpenAttachment];
                [btnAttrStr appendAttributedString:btnOpenAttrStr];
                
                //设置字体和设置字体的范围
                [btnAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, 2)];
                //添加文字颜色
                [btnAttrStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x8095AB) range:NSMakeRange(0, 2)];
                
                [cell.openBtn setAttributedTitle:btnAttrStr forState:UIControlStateNormal];
            }
            else{
                cell.contentL.attributedText = [[NSAttributedString alloc] initWithString:@" "];
                cell.contentL.text = @"";
                [cell.contentL setHidden:YES];
                
                NSMutableAttributedString *btnAttrStr = [[NSMutableAttributedString alloc]initWithString:@"展开 "];
                
                UIImage *btnOpenImage = [UIImage imageNamed:@"WordDetail展开"];
                NSTextAttachment *btnOpenAttachment = [[NSTextAttachment alloc]init];
                btnOpenAttachment.image = btnOpenImage;
                btnOpenAttachment.bounds = CGRectMake(0, 0, 12, 7);
                
                NSAttributedString *btnOpenAttrStr = [NSAttributedString attributedStringWithAttachment:btnOpenAttachment];
                [btnAttrStr appendAttributedString:btnOpenAttrStr];
                
                //设置字体和设置字体的范围
                [btnAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, 2)];
                //添加文字颜色
                [btnAttrStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x8095AB) range:NSMakeRange(0, 2)];
                
                [cell.openBtn setAttributedTitle:btnAttrStr forState:UIControlStateNormal];
                
            }
        }
        
        
        
        long fre = [[contentDict objectForKey:@"fre"]longValue];
        long totalFre = [[contentDict objectForKey:@"totalFre"]longValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"考频: "];
        
        UIImage *grayImage = [UIImage imageNamed:@"WordDetailStarGray"];
        NSTextAttachment *grayAttachment = [[NSTextAttachment alloc]init];
        grayAttachment.image = grayImage;
        grayAttachment.bounds = CGRectMake(0, 0, 14, 13);
        
        NSAttributedString *attrStr1 = [NSAttributedString attributedStringWithAttachment:grayAttachment];
        
        UIImage *whiteImage = [UIImage imageNamed:@"WordDetailStarWhite"];
        NSTextAttachment *whiteAttachment = [[NSTextAttachment alloc]init];
        whiteAttachment.image = whiteImage;
        whiteAttachment.bounds = CGRectMake(0, 0, 14, 13);
        
        NSAttributedString *attrStr2 = [NSAttributedString attributedStringWithAttachment:whiteAttachment];
        
        for (int i=0; i<fre; i++) {
            [attrStr appendAttributedString:attrStr1];
            [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        
        for (int i=0; i<(totalFre-fre); i++) {
            [attrStr appendAttributedString:attrStr2];
            [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        
        [cell.freL setAttributedText:attrStr];
        
        return cell;
    }
    
    YXWordFormModel *groupFrom = [self.wordFormModes objectAtIndex:(indexPath.section-2)];
    YXContentListItem *item = [groupFrom.contentList objectAtIndex:indexPath.row];
    if(item.type == 3) {
        YXWordDetailAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXWordDetailAudioCellID forIndexPath:indexPath];
        NSString *contentKey = item.contentKey;
        cell.titleL.attributedText = [self getAttributedValueForKey:contentKey];
        NSString *speech = [self.wordDetailDic objectForKey:item.urlKey];
        NSString *cdnSpeech = nil;
        if(speech ) {
            cdnSpeech = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.baseConfig.cdn,speech];
        }
        
        cell.urlKey = cdnSpeech;
        self.speakButton = cell.speakButton;
        return cell;
    }else {
        YXWordDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXWordDetailTextCellID forIndexPath:indexPath];
        NSString *contentKey = item.contentKey;
        cell.titleL.attributedText = [self getAttributedValueForKey:contentKey];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXWordDetailSectionHeader *header = (YXWordDetailSectionHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kYXWordDetailSectionHeaderID];
    
    if (section == 0) {
        
        if (!self.memoryKey) {
            [header setHidden:YES];
            return header;
        }
        [header setHidden:NO];
        
        long count = [[self.memoryKey objectForKey:@"star"]longValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"识记方法"];
        
        UIImage *image = [UIImage imageNamed:@"WordDetail旗子"];
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, 12, 14);
        
        NSAttributedString *attrStr1 = [NSAttributedString attributedStringWithAttachment:attachment];
        
        for (int i=0; i<count; i++) {
            [attrStr appendAttributedString:attrStr1];
            [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        [attrStr addAttribute:NSKernAttributeName value:@(8.0f) range:NSMakeRange(3, attrStr.length-3)];
        
        [header.titleL setAttributedText:attrStr];
        
        return header;
    }
    else if (section == 1){
        
        if (!self.examKey) {
            [header setHidden:YES];
            return header;
        }
        [header setHidden:NO];
        
        long count = [[self.examKey objectForKey:@"star"]longValue];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"中考考点"];
        
        UIImage *image = [UIImage imageNamed:@"WordDetail旗子"];
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        attachment.image = image;
        attachment.bounds = CGRectMake(10, -3, 12, 14);
        NSAttributedString *attrStr1 = [NSAttributedString attributedStringWithAttachment:attachment];
        
        for (int i=0; i<count; i++) {
            [attrStr appendAttributedString:attrStr1];
            [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        [attrStr addAttribute:NSKernAttributeName value:@(8.0f) range:NSMakeRange(3, attrStr.length-3)];
        
        [header.titleL setAttributedText:attrStr];
        return header;
    }
    
    YXWordFormModel *groupFrom = [self.wordFormModes objectAtIndex:(section-2)];
    header.title = groupFrom.title;
    [header setHidden:NO];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger wordToolkitState = [YXConfigure shared].confModel.baseConfig.wordToolkitState;
    if (indexPath.section == 0) {
        //默认的 YXUnVipNormalCell
        if (wordToolkitState != 2) {
            return 72.0;
        }
        return [self getTitleMemoryKeyTextHeightForRow:indexPath.row]+[self getContentMemoryKeyTextHeightForRow:indexPath.row]+50.0;
    }
    
    else if (indexPath.section == 1){
        //默认的 YXUnVipNormalCell
        if (wordToolkitState != 2) {
            return 72.0;
        }
        
        NSArray *content = [self.examKey objectForKey:@"content"];
        
        NSDictionary *contentDict = content[indexPath.row];
        
        NSString *isOpen = [contentDict objectForKey:@"open"];
        
        if(![BSUtils isBlankString:isOpen]){
            return [self getTitleExamKeyTextHeightForRow:indexPath.row]+[self getContentExamKeyTextHeightForRow:indexPath.row]+60.0;
        }
        else{
            return [self getTitleExamKeyTextHeightForRow:indexPath.row]+70.0;
        }
    }
    
    
    YXWordFormModel *groupFrom = [self.wordFormModes objectAtIndex:(indexPath.section -2)];
    YXContentListItem *item = [groupFrom.contentList objectAtIndex:indexPath.row];
    NSString *contentKey = item.contentKey;
    return [self getTextHeightForKey:contentKey cellType:item.type];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (!self.memoryKey) {
            return 0.01;
        }
        return 65;
    }
    if (section == 1) {
        if (!self.examKey) {
            return 0.01;
        }
        return 45;
    }
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //最后一个
    if (section == (2+self.wordFormModes.count-1)) {
        
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableViewHeaderFooterView"];
        
        if (!footerView){
            footerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"TableViewHeaderFooterView"];
        }
        
        [footerView setFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 55.0)];
        for (UIView *view in [footerView.contentView subviews]) {
            if (view.tag > 60000) {
                [view removeFromSuperview];
            }
        }
        
        UILabel *reportLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.0, 10.0, 45.0, 21.0)];
        [reportLabel setText:@" 报错 "];
        reportLabel.tag = 60002;
//
//        [reportLabel setFont:[UIFont systemFontOfSize:13.0]];
//        [reportLabel.layer setCornerRadius:1.0];
//        [reportLabel.layer setBorderWidth:1.0];
//        [reportLabel.layer setBorderColor:UIColorOfHex(0x3A9BFC).CGColor];
//        [reportLabel setTextAlignment:NSTextAlignmentCenter];
//        [footerView.contentView addSubview:reportLabel];
//
        UIButton *reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(17.0, 10.0, 45.0, 21.0)];
        [reportBtn setTitleColor:UIColorOfHex(0x3A9BFC) forState:UIControlStateNormal];
        [reportBtn setTitle:@" 报错 " forState:UIControlStateNormal];
        reportBtn.tag = 60001;
        [reportBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [reportBtn.layer setCornerRadius:1.0];
        [reportBtn.layer setBorderWidth:1.0];
        [reportBtn.layer setBorderColor:UIColorOfHex(0x3A9BFC).CGColor];
        [reportBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [reportBtn addTarget:self action:@selector(reportError) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView.contentView addSubview:reportBtn];
        
        return footerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //最后一个
    if (section == (2+self.wordFormModes.count-1)) {
        return 51.0;
    }
    return 0;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y < 0) {
//        scrollView.contentOffset = CGPointZero;
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger wordToolkitState = [YXConfigure shared].confModel.baseConfig.wordToolkitState;
    
    if (indexPath.section == 0) {
        //默认的 YXUnVipNormalCell
        if (wordToolkitState != 2) {
            [self toolKitButtonAction:self.toolKitButton];
            return;
        }
    }
    
    if (indexPath.section == 1) {
        //默认的 YXUnVipNormalCell
        if (wordToolkitState != 2) {
            [self toolKitButtonAction:self.toolKitButton];
            return;
        }
        
        NSArray *content = [self.examKey objectForKey:@"content"];
        
        NSDictionary *contentDict = content[indexPath.row];
        
        NSString *contentStr = [contentDict objectForKey:@"content"];
        
        if ([BSUtils isBlankString:contentStr]){
            return;
        }
        else
        {
            NSString *isOpen =  [contentDict objectForKey:@"open"];
            if(![BSUtils isBlankString:isOpen]){
                [contentDict setValue:@"" forKey:@"open"];
            }
            else{
                [contentDict setValue:@"1" forKey:@"open"];
            }
            [self.tableView reloadData];
            return;
        }
        
    }
    
    YXWordDetailTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[YXWordDetailAudioCell class]]) {
        [(YXWordDetailAudioCell *)cell playWordSound];
        [self traceEvent:kTraceWordInfo descributtion:@"playScentence"];
    }
}

- (NSMutableAttributedString *)getContentMemoryKeyAttributedValueForRow:(NSInteger )row {
    
    NSString *attriKey = [NSString stringWithFormat:@"ContentMemory%ldAttri",row];
    
    NSMutableAttributedString *attriStr = [self.wordDetailDic objectForKey:attriKey];
    
    if (!attriStr) {
        
        NSArray *contents = [self.memoryKey objectForKey:@"content"];
        NSDictionary *contentDict = contents[row];
        NSString *content = [contentDict objectForKey:@"content"];
        attriStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        
        NSRange range = NSMakeRange(0, attriStr.length);
        // 设置字体大小
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:range];
        
        [self.wordDetailDic setObject:attriStr forKey:attriKey];
    }
    return attriStr;
}

- (NSMutableAttributedString *)getTitleMemoryKeyAttributedValueForRow:(NSInteger )row {
    
    NSString *attriKey = [NSString stringWithFormat:@"TitleMemory%ldAttri",row];
    
    NSMutableAttributedString *attriStr = [self.wordDetailDic objectForKey:attriKey];
    
    if (!attriStr) {
        
        NSArray *contents = [self.memoryKey objectForKey:@"content"];
        NSDictionary *contentDict = contents[row];
        NSString *title = [contentDict objectForKey:@"title"];
        attriStr = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        
        NSRange range = NSMakeRange(0, attriStr.length);
        // 设置字体大小
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
        
        [self.wordDetailDic setObject:attriStr forKey:attriKey];
    }
    return attriStr;
}


//中考考点 内容
- (NSMutableAttributedString *)getContentExamKeyAttributedValueForRow:(NSInteger )row {
    
    NSString *attriKey = [NSString stringWithFormat:@"ExamContent%ldAttri",row];
    
    NSMutableAttributedString *attriStr = [self.wordDetailDic objectForKey:attriKey];
    
    if (!attriStr) {
        
        NSArray *contents = [self.examKey objectForKey:@"content"];
        NSDictionary *contentDict = contents[row];
        
        NSString *content = [contentDict objectForKey:@"content"];
        NSString *text = [NSString stringWithFormat:@"%@",content];
        
        attriStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        
        NSRange range = NSMakeRange(0, attriStr.length);
        // 设置字体大小
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        [attriStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x8095AB) range:range];

        [self.wordDetailDic setObject:attriStr forKey:attriKey];
    }
    return attriStr;
}

//中考考点 标题
- (NSMutableAttributedString *)getTitleExamKeyAttributedValueForRow:(NSInteger )row {
    
    NSString *attriKey = [NSString stringWithFormat:@"ExamTitle%ldAttri",row];
    
    NSMutableAttributedString *attriStr = [self.wordDetailDic objectForKey:attriKey];
    
    if (!attriStr) {
        
        NSArray *contents = [self.examKey objectForKey:@"content"];
        NSDictionary *contentDict = contents[row];
        
        NSString *title = [contentDict objectForKey:@"title"];
        NSString *text = [NSString stringWithFormat:@"%@",title];
        
        attriStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        
        NSRange range = NSMakeRange(0, attriStr.length);
        // 设置字体大小
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
        
        [self.wordDetailDic setObject:attriStr forKey:attriKey];
    }
    return attriStr;
}

- (NSMutableAttributedString *)getAttributedValueForKey:(NSString *)key {
    NSString *attriKey = [NSString stringWithFormat:@"%@Attri",key];
    NSMutableAttributedString *attriStr = [self.wordDetailDic objectForKey:attriKey];
    if (!attriStr) {
        NSString *text = [self.wordDetailDic objectForKey:key];
        if (!text) {
            text = @"";
        }
        else {
            if ([key isEqualToString:@"eng"]) {
                //中文的空格 会转码为 uncoide ，这里做一下替换
                text = [text stringByReplacingOccurrencesOfString:@"\U000000a0" withString:@" "];
            }
        }
        attriStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        NSRange range = NSMakeRange(0, attriStr.length);
        // 设置字体大小
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
//        [attriStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x485461) range:range];
        
        [self.wordDetailDic setObject:attriStr forKey:attriKey];
    }
    return attriStr;
}

//考点内容 的高度
- (CGFloat)getContentExamKeyTextHeightForRow:(NSInteger )row{
    
    NSString *attriHeightKey = [NSString stringWithFormat:@"ContentExam%ld_height",row];
    CGFloat height = [[self.wordDetailDic objectForKey:attriHeightKey] floatValue];
    
    if (!height) {
        
        NSMutableAttributedString *attriStr = [self getContentExamKeyAttributedValueForRow:row];
        CGFloat width = (SCREEN_WIDTH-50.0);
        
        CGSize size = [attriStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        height = size.height + 5.0 + 12.0;
        [self.wordDetailDic setObject:@(height) forKey:attriHeightKey];
    }
    return height;
}

//考点标题 的高度
- (CGFloat)getTitleExamKeyTextHeightForRow:(NSInteger )row{
    
    NSString *attriHeightKey = [NSString stringWithFormat:@"TitleExam%ld_height",row];
    CGFloat height = [[self.wordDetailDic objectForKey:attriHeightKey] floatValue];
    
    if (!height) {
        
        NSMutableAttributedString *attriStr = [self getTitleExamKeyAttributedValueForRow:row];
        CGFloat width = (SCREEN_WIDTH-50.0);
        
        CGSize size = [attriStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        height = size.height + 5;
        [self.wordDetailDic setObject:@(height) forKey:attriHeightKey];
    }
    return height;
}


- (CGFloat)getContentMemoryKeyTextHeightForRow:(NSInteger )row{
    if (!self.memoryKey){
        return 0.001;
    }
    NSString *attriHeightKey = [NSString stringWithFormat:@"ContentMemory%ld_height",row];
    CGFloat height = [[self.wordDetailDic objectForKey:attriHeightKey] floatValue];
    if (!height) {
        
        //getTitleMemoryKeyAttributedValueForRow
        NSMutableAttributedString *attriStr = [self getContentMemoryKeyAttributedValueForRow:row];
        CGFloat width = (SCREEN_WIDTH - 15 - 40);
        
        CGSize size = [attriStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        height = size.height + 5;
        [self.wordDetailDic setObject:@(height) forKey:attriHeightKey];
        
    }
    return height;
}

- (CGFloat)getTitleMemoryKeyTextHeightForRow:(NSInteger )row{
    if (!self.memoryKey){
        return 0.001;
    }
    NSString *attriHeightKey = [NSString stringWithFormat:@"TitleMemory%ld_height",row];
    CGFloat height = [[self.wordDetailDic objectForKey:attriHeightKey] floatValue];
    if (!height) {
        
        //getTitleMemoryKeyAttributedValueForRow
        NSMutableAttributedString *attriStr = [self getTitleMemoryKeyAttributedValueForRow:row];
        CGFloat width = (SCREEN_WIDTH - 15 - 40);
        
        CGSize size = [attriStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        height = size.height + 5;
        [self.wordDetailDic setObject:@(height) forKey:attriHeightKey];
        
    }
    return height;
}

- (CGFloat)getTextHeightForKey:(NSString *)key cellType:(NSInteger)type {
    NSString *attriHeightKey = [NSString stringWithFormat:@"%@_height",key];
    CGFloat height = [[self.wordDetailDic objectForKey:attriHeightKey] floatValue];
    if (!height) {
        NSMutableAttributedString *attriStr = [self getAttributedValueForKey:key];
        CGFloat width = (type == 3) ?  (SCREEN_WIDTH - 15 - 40): (SCREEN_WIDTH - 30);
        CGSize size = [attriStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        height = size.height + 5;
        [self.wordDetailDic setObject:@(height) forKey:attriHeightKey];
    }
    return height;
}

#pragma mark - subviews
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [tableView registerClass:[YXWordDetailTextCell class] forCellReuseIdentifier:kYXWordDetailTextCellID];
        [tableView registerClass:[YXWordDetailAudioCell class] forCellReuseIdentifier:kYXWordDetailAudioCellID];
        [tableView registerClass:[YXWordDetailMemoryCell class] forCellReuseIdentifier:kYXWordDetailMemoryCellID];
        [tableView registerClass:[YXWordDetailExamCell class] forCellReuseIdentifier:kYXWordDetailExamCellID];
        
        [tableView registerClass:[YXUnVipNormalCell class] forCellReuseIdentifier:kYXUnVipNormalCellID];
        
        
        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TableViewHeaderFooterView"];
        
        
        [tableView registerClass:[YXWordDetailSectionHeader class] forHeaderFooterViewReuseIdentifier:kYXWordDetailSectionHeaderID];
        tableView.contentInset = UIEdgeInsetsMake(5, 0, kSafeBottomMargin, 0);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
//        tableView.rowHeight = 25;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


- (UIView *)tableHeadView {
    if (!_tableHeadView) {
        UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
        tableHeadView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableHeaderView = tableHeadView;
        _tableHeadView = tableHeadView;
        
        [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableHeadView).offset(15);
            make.top.equalTo(tableHeadView).offset(30);
        }];
        
        UIImageView *wordImage = [[UIImageView alloc] init];
        wordImage.layer.cornerRadius = 6;
        wordImage.layer.masksToBounds = YES;
        [tableHeadView addSubview:wordImage];
        _wordImage = wordImage;
        [wordImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableHeadView).offset(20);
            make.right.equalTo(tableHeadView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        [self.phoneticSymbolL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableHeadView).offset(46);
            make.top.equalTo(self.wordL.mas_bottom).offset(24);
        }];
        
        [self.speakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 60));
            make.right.equalTo(self.phoneticSymbolL.mas_left);//.offset(-5);
            make.centerY.equalTo(self.phoneticSymbolL);
        }];
        
        UIView *playSoundArea = [[UIView alloc] init];
        playSoundArea.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(announcement)];
        [playSoundArea addGestureRecognizer:tap];
        [tableHeadView addSubview:playSoundArea];
        _playSoundArea = playSoundArea;
        [playSoundArea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.wordL);
            make.bottom.right.equalTo(self.phoneticSymbolL);
        }];
        
        UIView *sepLine = [[UIView alloc] init];
        sepLine.backgroundColor = UIColorOfHex(0xE9EFF4);
        [tableHeadView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableHeadView).offset(15);
            make.right.equalTo(tableHeadView).offset(-15).priorityHigh();
            make.top.equalTo(self.phoneticSymbolL.mas_bottom).offset(40);
            make.height.mas_equalTo(1.0);
        }];
        
        [self.explanL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableHeadView).offset(15);
            make.right.equalTo(tableHeadView).offset(-15).priorityHigh();
            make.top.equalTo(sepLine.mas_bottom).offset(15);
        }];
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = UIColorOfHex(0xE9EFF4);
        [tableHeadView addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(tableHeadView);
            make.height.mas_equalTo(8.0);
        }];
    }
    return _tableHeadView;
}

- (YXAudioAnimations *)speakerBtn {
    if (!_speakerBtn) {
        YXAudioAnimations *speakerBtn = [YXAudioAnimations playSpeakerAnimation:NO];
//        [speakerBtn addTarget:self action:@selector(announcement) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeadView addSubview:speakerBtn];
        _speakerBtn = speakerBtn;
    }
    return _speakerBtn;
}


- (UILabel *)explanL {
    if (!_explanL) {
        UILabel *explanL = [[UILabel alloc] init];
        explanL.textColor = UIColorOfHex(0x485461);
        explanL.font = [UIFont boldSystemFontOfSize:15];
        explanL.numberOfLines = 0;
        [self.tableHeadView addSubview:explanL];
        _explanL = explanL;
    }
    return _explanL;
}

- (UILabel *)phoneticSymbolL {
    if (!_phoneticSymbolL) {
        UILabel *phoneticSymbolL = [[UILabel alloc] init];
        phoneticSymbolL.textColor = UIColorOfHex(0x55A7FD);
        phoneticSymbolL.font = [UIFont systemFontOfSize:15];
        phoneticSymbolL.text = @"英[bəʊt]";
        [self.tableHeadView addSubview:phoneticSymbolL];
        _phoneticSymbolL = phoneticSymbolL;
    }
    return _phoneticSymbolL;
}


- (UILabel *)wordL {
    if (!_wordL) {
        UILabel *wordL = [[UILabel alloc] init];
        wordL.textColor = UIColorOfHex(0x485461);
        wordL.font = [UIFont boldSystemFontOfSize:25];
        wordL.text = @"congratulate";
        [self.tableHeadView addSubview:wordL];
        _wordL = wordL;
    }
    return _wordL;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];

        UIView *sepLine = [[UIView alloc] init];
        sepLine.backgroundColor = UIColorOfHex(0xE9EFF4);
        [_bottomView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bottomView);
            make.height.mas_equalTo(2.0);
        }];
        
        UIButton *leftButton = [self customBottomButton];
        [leftButton setImage:[UIImage imageNamed:@"collection_nor"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"collection_Sel"] forState:UIControlStateSelected];
        [leftButton setTitle:@"" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.selected = self.isFavWord;
        [_bottomView addSubview:leftButton];
        _bottomLeftButton = leftButton;
        
        UIButton *toolKitButton = [self customBottomButton];
        [toolKitButton setImage:[UIImage imageNamed:@"WordDetail工具箱"] forState:UIControlStateNormal];
        [toolKitButton setTitle:@"" forState:UIControlStateNormal];
        [toolKitButton addTarget:self action:@selector(toolKitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.toolKitButton = toolKitButton;
        
        [_bottomView addSubview:toolKitButton];
        
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView).offset(80.0);
            make.bottom.equalTo(_bottomView);
            make.top.mas_equalTo(sepLine.mas_bottom).offset(3.0);
            make.width.mas_equalTo(50.0);
        }];

        [toolKitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView).offset(15.0);
            make.bottom.equalTo(_bottomView);
            make.top.mas_equalTo(sepLine.mas_bottom).offset(3.0);
            make.width.mas_equalTo(50.0);
        }];
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130-12,6,130,38)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"WordDetailBtn背景"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"WordDetailBtn背景"] forState:UIControlStateSelected];
        
        NSString *title = self.backTitle?self.backTitle:@"返回";
        
        [backBtn setTitle:title forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [backBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        
        [backBtn setClipsToBounds:YES];
        [backBtn.layer setCornerRadius:19.0];
        
        [backBtn addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:backBtn];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bottomView).offset(-12.0);
            make.bottom.equalTo(_bottomView).offset(-6.0);
            make.top.mas_equalTo(sepLine.mas_bottom).offset(6.0);
            make.width.mas_equalTo(130.0);
        }];
        
    }
    return _bottomView;
}

- (UIButton *)customBottomButton {
    UIButton *button = [[UIButton alloc] init];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
    return button;
}

- (void)announcementWith:(void(^)(void))playFinishBlock {
    [self.speakerBtn startAnimating];
    self.playSoundArea.userInteractionEnabled = NO;
    NSString *subpath = [self.bookId stringByAppendingPathComponent:self.wordDetailModel.curMaterialSubPath];
    NSString *fullPath = [[YXUtils resourcePath] DIR:subpath];
    __weak typeof(self) weakSelf = self;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) { //本地播放
        [[AVAudioPlayerManger shared] startPlay:[NSURL fileURLWithPath:fullPath] finish:^(BOOL isSuccess) {
//            [weakSelf.speakerBtn stopAnimating];
//            weakSelf.playSoundArea.userInteractionEnabled = YES;
//            [weakSelf playSentenceSound];
            [weakSelf playWordSoundFinishedWith:playFinishBlock];
        }];
    }else {
        //        [self.speakerBtn stopAnimating];
        //        NSLog(@"音频文件不存在");
        [self playRemoteVoice:playFinishBlock];
    }
    [self traceEvent:kTracePlayWordSound descributtion:self.wordDetailModel.wordid];
}

- (void)announcement {
    [self announcementWith:nil];

}

- (void)playRemoteVoice:(void(^)(void))playFinishBlock {
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self.view title:@"网络不给力"];
        [self.speakerBtn stopAnimating];
        self.playSoundArea.userInteractionEnabled = YES;
        return;
    }
    
//    if (self.remotePlayer) {
//        [self.remotePlayer play];
//        return;
//    }
    __weak typeof(self) weakSelf = self;
    NSString *dir = [YXConfigure shared].isUsStyle ? self.wordDetailModel.usvoice : self.wordDetailModel.ukvoice;
    NSString *remoteSource = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.cdn,dir];
    self.remotePlayer = [[YXRemotePlayer alloc] init];
    [self.remotePlayer startPlay:[NSURL URLWithString:remoteSource] finish:^(BOOL isSuccess) {
//        [weakSelf.speakerBtn stopAnimating];// 结束播放
//        weakSelf.playSoundArea.userInteractionEnabled = YES;
//        [weakSelf playSentenceSound];
        [weakSelf playWordSoundFinishedWith:playFinishBlock];
    }];
    NSLog(@"本地不存在音频文件，播放链接");
}


- (void)playRemoteVoice {
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self.view title:@"网络不给力"];
        [self.speakerBtn stopAnimating];
        self.playSoundArea.userInteractionEnabled = YES;
        return;
    }
    
    if (self.remotePlayer) {
        [self.remotePlayer play];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *dir = [YXConfigure shared].isUsStyle ? self.wordDetailModel.usvoice : self.wordDetailModel.ukvoice;
    NSString *remoteSource = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.cdn,dir];
    self.remotePlayer = [[YXRemotePlayer alloc] init];
    [self.remotePlayer startPlay:[NSURL URLWithString:remoteSource] finish:^(BOOL isSuccess) {
        [weakSelf.speakerBtn stopAnimating];// 结束播放
        weakSelf.playSoundArea.userInteractionEnabled = YES;
        [weakSelf playSentenceSound];
    }];
    NSLog(@"本地不存在音频文件，播放链接");
}

- (void)playWordSoundFinishedWith:(void(^)(void))playFinishBlock {
    [self.speakerBtn stopAnimating];// 结束播放
    self.playSoundArea.userInteractionEnabled = YES;
    
    if (playFinishBlock) {
        playFinishBlock();
    }
}
//播放例句
- (void)playSentenceSound {
    NSString *speech = self.wordDetailModel.speech;
    NSString *cdnSpeech = nil;
    if(speech ) {
        cdnSpeech = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.baseConfig.cdn,speech];
//        [[AVAudioPlayerManger shared] startPlay:[NSURL URLWithString:cdnSpeech]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.speakButton startAnimating];
        });
        //修复喇叭不播放
        __weak __typeof(self)weakSelf = self;
        [[AVAudioPlayerManger shared] startPlay:[NSURL URLWithString:cdnSpeech] finish:^(BOOL isSuccess) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.speakButton stopAnimating];
            });
        }];
    }
}

- (void)collectAction:(UIButton *)btn {
    [YXWordModelManager keepWordId:self.wordDetailModel.wordid bookId:self.bookId isFav:!btn.selected completeBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            btn.selected = !btn.selected;
//            [kNotificationCenter postNotificationName:kWordFavStateChangeNotify object:@(btn.state)];
            NSDictionary *userInfo = [response.responseObject objectForKey:@"modFav"];
            [kNotificationCenter postNotificationName:kWordFavStateChangeNotify object: nil userInfo:userInfo];
        }
    }];
}

//工具包
- (void)toolKitButtonAction:(UIButton *)btn{
    
    btn.userInteractionEnabled = NO;
    __weak __typeof(self)weakSelf = self;
    //网络请求
    [YXDataProcessCenter GET:DOMAIN_USERWORDTOOLKITINFO parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        
        if (result) {
            NSDictionary *wordToolkit = [response.responseObject objectForKey:@"wordToolkit"];
            weakSelf.toolkitModel =  [YXWordToolkitModel mj_objectWithKeyValues:wordToolkit];
            //[UIApplication sharedApplication].keyWindow.bounds]
            YXWordDetailToolkitView *toolkitView = [[YXWordDetailToolkitView alloc]initWithFrame:weakSelf.view.frame];
            toolkitView.toolkitBlock = ^(id  _Nonnull obj) {
                [YXConfigure shared].confModel.baseConfig.wordToolkitState = 2;
                [weakSelf.tableView reloadData];
            };
            //[UIApplication sharedApplication].keyWindow
            [weakSelf.view addSubview:toolkitView];
            [toolkitView setToolkitModelodel:weakSelf.toolkitModel];
        }
        
        btn.userInteractionEnabled = YES;
        
     }];
    
}

- (void)continueAction {
    [self back];
}

- (void)back {
    if (self.remotePlayer) {
        [self.remotePlayer releaseSource];
    }
    
    [[AVAudioPlayerManger shared] cancleFinishActionAndStopPlaying];
    
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.backActionBlock) {
        self.backActionBlock();
    }
    [self traceTraceWordDetailTime]; // 统计时长
}

- (void)traceTraceWordDetailTime {
    NSTimeInterval intever = [[NSDate date] timeIntervalSinceDate:self.studyStartDate];
    [self traceEvent:kTraceWordDetailTime descributtion:[NSString stringWithFormat:@"%.f",intever]];
}


- (void)dealloc {
    if (self.remotePlayer) {
        [self.remotePlayer releaseSource];
    }
}

- (void)reportError {
    [YXReportErrorView showToView:self.view];
    [self traceEvent:kTraceReportError descributtion:self.wordDetailModel.wordid];
}
@end



/**
 //    [self.speakerBtn startAnimating];
 //    self.playSoundArea.userInteractionEnabled = NO;
 //    NSString *subpath = [self.bookId stringByAppendingPathComponent:self.wordDetailModel.curMaterialSubPath];
 //    NSString *fullPath = [[YXUtils resourcePath] DIR:subpath];
 //    __weak typeof(self) weakSelf = self;
 //    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
 //        [[AVAudioPlayerManger shared] startPlay:[NSURL fileURLWithPath:fullPath] finish:^(BOOL isSuccess) {
 //            [weakSelf.speakerBtn stopAnimating];
 //            weakSelf.playSoundArea.userInteractionEnabled = YES;
 //            [weakSelf playSentenceSound];
 //        }];
 //    }else {
 ////        [self.speakerBtn stopAnimating];
 ////        NSLog(@"音频文件不存在");
 //        [self playRemoteVoice];
 //    }
 //    [self traceEvent:kTracePlayWordSound descributtion:self.wordDetailModel.wordid];
 */
