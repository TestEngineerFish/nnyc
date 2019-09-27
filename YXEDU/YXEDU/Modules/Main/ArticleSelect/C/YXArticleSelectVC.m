//
//  YXArticleSelectVC.m
//  YXEDU
//
//  Created by jukai on 2019/5/24.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleSelectVC.h"
#import "YXASRecommendCell.h"
#import "YXASBookCell.h"
#import "YXASTitleHeader.h"
#import "YXReadHistoryVC.h"
#import "YXArticleUnitView.h"
#import "YXASPushTextModel.h"
#import "YXASTextLibModel.h"
#import "YXBasePickverView.h"
#import "BSUtils.h"
#import "YXArticleDetailViewController.h"

static NSString *const kRemoveDatePickView = @"RemovePickerView";
static NSString *const kYXASRecommendCellID = @"YXASRecommendCellID";
static NSString *const kYXASBookCellID = @"kYXASBookCellID";

@interface YXArticleSelectVC ()<UITableViewDelegate,UITableViewDataSource,YXBasePickverViewDelegate>

@property (nonatomic, strong) UIButton *readHistoryBtn;
@property (nonatomic, strong) UITableView *myArticleTV;
@property (nonatomic, strong) NSMutableArray *pushTextArray;
@property (nonatomic, strong) NSMutableArray *textLibraryArray;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NSMutableArray *bookEditionArray;
@property (nonatomic, strong) YXBasePickverView *pickerView;
@property (nonatomic, strong) UIView *pickerBackgroundView;
@property (nonatomic, copy)   NSArray *filterArray;
@property (nonatomic, assign) NSNumber *learningBookId;

@property (nonatomic, weak) UIButton *bookEditionBtn;
@property (nonatomic, weak) UIButton *classBtn;
@property (nonatomic, copy) NSString *bookEditionStr;
@property (nonatomic, copy) NSString *classStr;

@end

@implementation YXArticleSelectVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.classStr = @"";
    self.bookEditionStr = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickerView:) name:kRemoveDatePickView object:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.pushTextArray = [NSMutableArray array];
    self.textLibraryArray = [NSMutableArray array];
    
    self.classArray = [NSMutableArray array];
    self.bookEditionArray = [NSMutableArray array];
    
    [self.classArray addObject:@"所有年级"];
    [self.bookEditionArray addObject:@"全部教材版本"];
    
    self.navigationItem.title = @"选择课文";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.readHistoryBtn];
    
    [self.myArticleTV reloadData];
    [self netArticleList];
    
}

-(void)netArticleList{
    
    [YXDataProcessCenter GET:DOMAIN_TEXTCHOICE
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result)
     {
         
         if (result) {
             
             if (self.pushTextArray.count>0) {
                 [self.pushTextArray removeAllObjects];
             }
             
             if (self.textLibraryArray.count>0) {
                 [self.textLibraryArray removeAllObjects];
             }
             
             NSArray *pushText = [response.responseObject objectForKey:@"pushText"];
             
             for (NSDictionary *pushTextDict in pushText ) {
                 
                 YXASPushTextModel *model = [YXASPushTextModel mj_objectWithKeyValues:pushTextDict];
                 [self.pushTextArray addObject:model];
                 
             }
             self.learningBookId = [response.responseObject objectForKey:@"learningBookId"];
             NSArray *textLibrary = [response.responseObject objectForKey:@"textLibrary"];
             for (NSDictionary *textLibraryDict in textLibrary ) {
                 
                 YXASTextLibModel *model = [YXASTextLibModel mj_objectWithKeyValues:textLibraryDict];
                 [self.textLibraryArray addObject:model];
                 
                 if (![self.classArray containsObject:model.gradeName]) {
                     [self.classArray addObject:model.gradeName];
                 }
                 if (![self.bookEditionArray containsObject:model.verName]) {
                     [self.bookEditionArray addObject:model.verName];
                 }
             }
             
             self.filterArray = [self.textLibraryArray copy];
             
             [self.myArticleTV reloadData];

         } else {
             __weak typeof(self) weakSelf = self;
             [self showNoNetWorkView:^{
                 [weakSelf netArticleList];
             }];
         }
     }];
}



- (UIButton *)readHistoryBtn {
    if (!_readHistoryBtn) {
        UIButton *readHistoryBtn = [[UIButton alloc] init];
        readHistoryBtn.frame = CGRectMake(0, 0, 60, 44);
        [readHistoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [readHistoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        readHistoryBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:15];
        [readHistoryBtn setTitle:@"读背历史" forState:UIControlStateNormal];
        [readHistoryBtn addTarget:self action:@selector(readHistoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _readHistoryBtn = readHistoryBtn;
    }
    return _readHistoryBtn;
}


-(void)readHistoryBtnAction:(UIButton *)btn{
    NSLog(@"readHistoryBtnAction");
    YXReadHistoryVC *vc = [[YXReadHistoryVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UITableView *)myArticleTV {
    
    if (!_myArticleTV) { //UITableViewStylePlain 悬停
        
        CGFloat leftMargin = iPhone5 ? 0 : 0;
       
        _myArticleTV = [[UITableView alloc] initWithFrame:CGRectMake(leftMargin,0, SCREEN_WIDTH - 2 * leftMargin, SCREEN_HEIGHT-kNavHeight) style:UITableViewStyleGrouped];
        
        [_myArticleTV registerClass:[YXASRecommendCell class] forCellReuseIdentifier:kYXASRecommendCellID];
        
        [_myArticleTV registerClass:[YXASBookCell class] forCellReuseIdentifier:kYXASBookCellID];
        
        [_myArticleTV registerClass:[YXASTitleHeader class] forHeaderFooterViewReuseIdentifier:@"YXASTitleHeader"];
        
        
        _myArticleTV.delegate = self;
        _myArticleTV.dataSource = self;
        
        _myArticleTV.backgroundColor = [UIColor whiteColor];
        
        _myArticleTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myArticleTV.rowHeight =  AdaptSize(119);
        [self.view addSubview:_myArticleTV];
        
    }
    return _myArticleTV;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.pushTextArray.count;
    }
    else if (section == 1) {
        return self.filterArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        YXASRecommendCell *cell =  [tableView dequeueReusableCellWithIdentifier:kYXASRecommendCellID forIndexPath:indexPath];
        
        YXASPushTextModel *pushTextModel = self.pushTextArray[indexPath.row];
        [cell.titleL setText:pushTextModel.textTitle];
        [cell.bookL setText:pushTextModel.from];
        [cell.progressL setText:[NSString stringWithFormat:@"已跟读:%ld%%   已背诵%ld%%",pushTextModel.followRank,pushTextModel.reciteRank]];
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        
        YXASBookCell *cell =  [tableView dequeueReusableCellWithIdentifier:kYXASBookCellID forIndexPath:indexPath];
        
        YXASTextLibModel *textLibModel = self.filterArray[indexPath.row];
        
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:textLibModel.cover]placeholderImage:[UIImage imageNamed:@"placeholder"]];
        if (textLibModel.bookId == self.learningBookId.integerValue) {
            [cell.studyFlag setHidden:NO];
        } else {
            [cell.studyFlag setHidden:YES];
        }
        [cell.titleLab setText:textLibModel.bookName];
        [cell.totalArticleLab setText:[NSString stringWithFormat:@"共 %ld 篇课文",textLibModel.textCount]];
        
        return cell;
    }
    
    YXASRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXASRecommendCellID forIndexPath:indexPath];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.pushTextArray.count == 0) {
            return 0.01;
        }
    }
    
    if (section == 1) {
        if (self.textLibraryArray.count == 0) {
            return 0.01;
        }
    }
    
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YXASTitleHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXASTitleHeader"];
    [header.nameLab setTextColor:UIColorOfHex(0x434A5D)];
    header.nameLab.font = [UIFont pfSCRegularFontWithSize:15.f];
    for (UIView *tempView in [header subviews]) {
        if (tempView.tag > 60000) {
            [tempView removeFromSuperview];
        }
    }
    
    if (section == 0) {
        [header.nameLab setText:@"推荐课文:"];
        if (self.pushTextArray.count == 0) {
            [header setHidden:YES];
        }
        else{
            [header setHidden:NO];
        }
    }
    else if (section == 1) {
        
        [header.nameLab setText:@"词书库:"];
        
        UIButton *bookEditionBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-134.0,13.0, 117.0, 25.0)];
        bookEditionBtn.titleLabel.font = [UIFont iconFontWithSize:13.f];

        bookEditionBtn.layer.cornerRadius = 12.5;
        bookEditionBtn.layer.masksToBounds = YES;
        bookEditionBtn.layer.borderWidth = 1.0;
        bookEditionBtn.tag = 60005;

        if ([BSUtils isBlankString:self.bookEditionStr]) {
            [bookEditionBtn setTitle:[NSString stringWithFormat:@"全部教材版本 %@", kIconFont_arrowDown] forState:UIControlStateNormal];
            [bookEditionBtn setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
            bookEditionBtn.layer.borderColor = UIColorOfHex(0x849EC5).CGColor;
        } else {
            [bookEditionBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.bookEditionStr, kIconFont_arrowDown] forState:UIControlStateNormal];
            [bookEditionBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
            bookEditionBtn.layer.borderColor = UIColorOfHex(0x55A7FD).CGColor;
        }

        [bookEditionBtn addTarget:self action:@selector(bookEditionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        


        UIButton *classBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-134.0-8.0-92.0,13.0, 92.0, 25.0)];
        classBtn.titleLabel.font = [UIFont iconFontWithSize:13.f];
        classBtn.layer.cornerRadius = 12.5;
        classBtn.layer.masksToBounds = YES;
        classBtn.layer.borderWidth = 1.0;

        if ([BSUtils isBlankString:self.classStr]) {
            [classBtn setTitle:[NSString stringWithFormat:@"所有年级 %@", kIconFont_arrowDown] forState:UIControlStateNormal];
            [classBtn setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
            classBtn.layer.borderColor = UIColorOfHex(0x849EC5).CGColor;
        } else {
            [classBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.classStr, kIconFont_arrowDown] forState:UIControlStateNormal];
            [classBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
            classBtn.layer.borderColor = UIColorOfHex(0x55A7FD).CGColor;
        }
        
        classBtn.tag = 60006;

        [classBtn addTarget:self action:@selector(classBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        
        [classBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -classBtn.imageView.image.size.width - 1,
                                                            0, classBtn.imageView.image.size.width + 1)];
        
        [classBtn setImageEdgeInsets:UIEdgeInsetsMake(0, classBtn.titleLabel.intrinsicContentSize.width + 1,
                                                            0, -classBtn.titleLabel.intrinsicContentSize.width - 1)];

        [header addSubview:bookEditionBtn];
        [header addSubview:classBtn];
        
        self.bookEditionBtn = bookEditionBtn;
        self.classBtn = classBtn;
        
        if (self.textLibraryArray.count == 0) {
            [header setHidden:YES];
        }
        else{
            [header setHidden:NO];
        }
    }
    
    return header;
}

-(void)classBtnAction:(UIButton *)btn {
    //设置按钮选中状态

    NSString *titleStr = @"未设置";
    if (![BSUtils isBlankString:self.classStr])
    {
        titleStr = self.classStr;
    }
    
    self.pickerView = [YXBasePickverView showClassTypeViewOn:titleStr withDelegate:self dataArray:self.classArray];
    
    if (self.pickerView) {
        
        self.pickerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.pickerBackgroundView.backgroundColor = UIColor.blackColor;
        //        [self.pickerBackgroundView setUserInteractionEnabled:YES];
        self.view.userInteractionEnabled = NO;
        self.pickerBackgroundView.userInteractionEnabled = NO;
        [self.pickerBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePickerView:)]];
        self.pickerBackgroundView.alpha = 0.5;
        
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 272);
        self.pickerView.backgroundColor = UIColor.clearColor;
        
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:self.pickerBackgroundView];
        [currentWindow addSubview:self.pickerView];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 272, SCREEN_WIDTH, 272);
            self.pickerBackgroundView.alpha = 0.5;
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            self.pickerBackgroundView.userInteractionEnabled = YES;
        }];
    }
    
}

-(void)bookEditionBtnAction:(UIButton *)btn {
    NSLog(@"bookEditionBtnAction");

    NSString *titleStr = @"未设置";
    if (![BSUtils isBlankString:self.bookEditionStr])
    {
        titleStr = self.bookEditionStr;
    }
    
    
    self.pickerView = [YXBasePickverView showBookEditionViewOn:titleStr withDelegate:self dataArray:self.bookEditionArray];
    
    if (self.pickerView) {
        
        self.pickerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.pickerBackgroundView.backgroundColor = UIColor.blackColor;
        //        [self.pickerBackgroundView setUserInteractionEnabled:YES];
        self.view.userInteractionEnabled = NO;
        self.pickerBackgroundView.userInteractionEnabled = NO;
        [self.pickerBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePickerView:)]];
        self.pickerBackgroundView.alpha = 0.5;
        
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 272);
        self.pickerView.backgroundColor = UIColor.clearColor;
        
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:self.pickerBackgroundView];
        [currentWindow addSubview:self.pickerView];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 272, SCREEN_WIDTH, 272);
            self.pickerBackgroundView.alpha = 0.5;
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            self.pickerBackgroundView.userInteractionEnabled = YES;
        }];
    }
}

// MARK: Tap Gesture
- (void)removePickerView:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBackgroundView.alpha = 0;
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 272);
    } completion:^(BOOL finished) {
        [self.pickerBackgroundView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        
        self.pickerBackgroundView = nil;
        self.pickerView = nil;
    }];
    
}

// MARK: YXBasePickverViewDelegate
- (void)basePickverView:(YXBasePickverView *)pickverView withSelectedTitle:(NSString *)title
{
    NSString *propertyName = @"";
    NSPredicate *predicate;
    if (pickverView.type == ClassType) {
        propertyName = @"gradeName";
        if([title hasPrefix:@"所有年级"]){
            self.classStr = @"";
            [self.classBtn setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
        }
        else{
            self.classStr = title;
            [self.classBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        }
        [self.classBtn setTitle:title forState:UIControlStateNormal];
    }
    else if (pickverView.type == BookEditionType) {
        propertyName = @"verName";
        if([title hasPrefix:@"全部教材版本"]){
            self.bookEditionStr = @"";
            [self.bookEditionBtn setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
        }
        else{
            self.bookEditionStr = title;
            [self.bookEditionBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        }

        [self.bookEditionBtn setTitle:title forState:UIControlStateNormal];
    }
    
    if ([BSUtils isBlankString:self.classStr]) {
        predicate = [NSPredicate predicateWithFormat:@"verName = %@",self.bookEditionStr];
    }
    else if ([BSUtils isBlankString:self.bookEditionStr]) {
        predicate = [NSPredicate predicateWithFormat:@"gradeName = %@",self.classStr];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"gradeName = %@ && verName = %@",self.classStr,self.bookEditionStr];
    }
    
    
    self.filterArray = [self.textLibraryArray filteredArrayUsingPredicate:predicate];
    
    if (self.filterArray.count == 0) {
        self.filterArray = [self.textLibraryArray copy];
    }
    
    [self.myArticleTV reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveDatePickView object:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0){
        if (self.pushTextArray.count == 0) {
            return 0.01;
        }
    }
    
    if (section == 0){
        if (self.textLibraryArray.count == 0) {
            return 0.01;
        }
    }
    return 6.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6.0)];
    [footerView setBackgroundColor:UIColorOfHex(0xE9EFF4)];

    if (section == 0) {
        
        if (self.pushTextArray.count == 0) {
            [footerView setHidden:YES];
        }
        else {
            [footerView setHidden:NO];
        }
    }
    
    else if (section == 1) {
        
        if (self.textLibraryArray.count == 0) {
            [footerView setHidden:YES];
        }
        else {
            [footerView setHidden:NO];
        }
    }
    
    else{
        [footerView setHidden:NO];
    }
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        YXASPushTextModel *pushTextModel = self.pushTextArray[indexPath.row];
        //跳转到文章详情
        YXArticleDetailViewController *articleDetailViewController = [YXArticleDetailViewController alloc];
        
        articleDetailViewController.jsonUrl = pushTextModel.textJson;
        
        [self.navigationController pushViewController:articleDetailViewController animated:YES];
        
    }
    
    else if (indexPath.section == 1) {
     
        YXASTextLibModel *textLibModel = self.textLibraryArray[indexPath.row];
        YXArticleUnitView *articleUnitView  = [[YXArticleUnitView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        articleUnitView.bookID = textLibModel.bookId;
        [[UIApplication sharedApplication].keyWindow addSubview:articleUnitView];
        
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
