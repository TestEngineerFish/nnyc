//
//  YXPersonalBookVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalBookVC.h"
#import "YXBookTitleHeader.h"
#import "BSCommon.h"
#import "YXPersonalBookViewModel.h"
#import "YXComAlertView.h"
#import "YXBookModel.h"
#import "YRHUDUtils.h"
#import "YXUtils.h"
#import "YXMyBookCell.h"
#import "YXSelectBookVC.h"
#import "UIImageView+WebCache.h"
#import "YXPersonalBookDelModel.h"

@interface YXPersonalBookVC ()<UITableViewDelegate, UITableViewDataSource,YXMyBookCellDelegate>
@property (nonatomic, strong) UITableView *accountTalbe;
@property (nonatomic, strong) YXPersonalBookViewModel *bookViewModel;
@property (nonatomic, strong) UIImageView *singleLine;
@end

@implementation YXPersonalBookVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bookViewModel = [[YXPersonalBookViewModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.title = @"我的词书";
    
    self.view.backgroundColor = UIColorOfHex(0xffffff);
        
    self.accountTalbe = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight) style:UITableViewStyleGrouped];
    self.accountTalbe.delegate = self;
    self.accountTalbe.dataSource = self;
    self.accountTalbe.backgroundColor = [UIColor clearColor];
    self.accountTalbe.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.accountTalbe];
    
    if (SYSTEM_VERSION_LESS_THAN(11)) {
        UIView *titleBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavHeight)];
        titleBackView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:titleBackView];
        
        self.accountTalbe.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } else {
        self.accountTalbe.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    }
    
    [self.accountTalbe registerClass:[YXBookTitleHeader class] forHeaderFooterViewReuseIdentifier:@"YXBookTitleHeader"];
    
    [self.accountTalbe registerClass:[YXMyBookCell class]
              forCellReuseIdentifier:@"YXMyBookCell"];
    
    self.singleLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 1)];
    self.singleLine.backgroundColor = UIColorOfHex(0xe6e6e6);
    [self.view addSubview:self.singleLine];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self reloadNoSignalView];
    [self reload];
}

- (void)refreshBtnClicked {
//    [self reloadNoSignalView];
    [self reload];
}

- (void)reload {
    [YXUtils showHUD:[UIApplication sharedApplication].keyWindow];
    [self getBook:^(id obj, BOOL result) {
        [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.bookViewModel rowCount]>0?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.bookViewModel rowCount];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 126;
    }
    if (indexPath.section == 1) {
        return 126;
    }
    return 126;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXBookTitleHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXBookTitleHeader"];
    if (section == 0) {
        header.nameLab.text = @"正在学习";
    } else if (section == 1) {
        header.nameLab.text = @"学习记录";
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YXMyBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMyBookCell" forIndexPath:indexPath];
        cell.titleLab.text = [self.bookViewModel getLearnBookName];
        cell.totalVocabularyLab.text = [NSString stringWithFormat:@"总词汇:%ld", (long)[self.bookViewModel getAllWord]];
        cell.haveLearnedLab.text = [NSString stringWithFormat:@"已学词汇:%ld", (long)[self.bookViewModel getAllLearned]];
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:[self.bookViewModel getLearnCoverUrl]]];
        cell.delegate = self;
        [cell.manageBtn setBackgroundImage:[UIImage imageNamed:@"personal_book_yellowbtn"] forState:UIControlStateNormal];
        [cell.manageBtn setTitle:@"换本书背" forState:UIControlStateNormal];
        return cell;
    } else if (indexPath.section == 1) {
        YXMyBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMyBookCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.titleLab.text = [self.bookViewModel getBookName:indexPath.row];
        cell.totalVocabularyLab.text = [NSString stringWithFormat:@"总词汇:%ld", (long)[self.bookViewModel getAllOtherWord:indexPath.row]];
        cell.haveLearnedLab.text = [NSString stringWithFormat:@"已学词汇:%ld", (long)[self.bookViewModel getAllOtherLearned:indexPath.row]];
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:[self.bookViewModel getImageUrl:indexPath.row]]];
        [cell.manageBtn setBackgroundImage:[UIImage imageNamed:@"personal_book_graybtn"] forState:UIControlStateNormal];
        [cell.manageBtn setTitle:@"学这本书" forState:UIControlStateNormal];
        return cell;
    }
    YXMyBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMyBookCell" forIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YXPersonalBookDelModel *delModel = [[YXPersonalBookDelModel alloc]init];
        delModel.bookids = [self.bookViewModel getBookId:indexPath.row];
        
        NSInteger question = [self.bookViewModel getAllOtherQuestioCount:indexPath.row];
        if (question) {
            NSInteger learned = [self.bookViewModel getAllOtherLearned:indexPath.row];
            if (learned) {
                NSInteger word = [self.bookViewModel getAllOtherWord:indexPath.row];
                NSString *content = [NSString stringWithFormat:@"该本词书您已学习了 %ld / %ld 个单词，是否需要保留进度？", (long)learned, (long)word];
                [YXComAlertView showAlert:YXAlertManageBook inView:self.view info:@"提示" content:content firstBlock:^(id obj) {
                    delModel.reset = @"1";
                    [self delBook:delModel];
                } secondBlock:^(id obj) {
                    delModel.reset = @"0";
                    [self delBook:delModel];
                }];
            } else {
                delModel.reset = @"1";
                [self delBook:delModel];
            }
            
        } else {
            [self delBook:delModel];
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -YXBookOtherCellDelegate-
- (void)manageBtnDidClicked:(id)sender {
    YXMyBookCell *mybookCell = sender;
    NSIndexPath *indexPath = [self.accountTalbe indexPathForCell:mybookCell];
    if (indexPath.section == 0) {
        YXSelectBookVC *selectVC = [[YXSelectBookVC alloc]init];
        selectVC.transType = TransationPop;
        [self.navigationController pushViewController:selectVC animated:YES];
    } else if (indexPath.section == 1) {
        [self studyBook:[self.bookViewModel getBookId:indexPath.row]];
    }
}

- (void)studyBook:(NSString *)bookids {
    __weak YXPersonalBookVC *weakSelf = self;
    [YXUtils showHUD:[UIApplication sharedApplication].keyWindow];
    [self.bookViewModel setLearning:bookids finish:^(id obj, BOOL result) {
        if (result) {
            [weakSelf getBook:^(id obj, BOOL result) {
                [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
            }];
        } else {
            [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
            [YXUtils showHUD:weakSelf.view title:@"网络错误!"];
        }
    }];
}

- (void)delBook:(id)bookDelModel {
    __weak YXPersonalBookVC *weakSelf = self;
    [YXUtils showHUD:[UIApplication sharedApplication].keyWindow];
    [self.bookViewModel delBook:bookDelModel finish:^(id obj, BOOL result) {
        if (result) {
            [weakSelf getBook:^(id obj, BOOL result) {
                [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
            }];
        } else {
            [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
            [YXUtils showHUD:weakSelf.view title:@"网络错误!"];
        }
    }];
}


- (void)getBook:(finishBlock)block {
    __weak YXPersonalBookVC *weakSelf = self;
    [self.bookViewModel getBookList:^(id obj, BOOL result) {
        block (obj, result);
        if (result) {
            [weakSelf.accountTalbe reloadData];
        } else {
            [YXUtils showHUD:weakSelf.view title:@"网络错误!"];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
