//
//  YXSelectBookContentVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSelectBookContentVC.h"
#import "BSCommon.h"
#import "YXSelectBookCell.h"
#import "YXConfigure3Model.h"
#import "YXUtils.h"
#import "UIImageView+WebCache.h"
#import "YXConfigure.h"
#import "YXMediator.h"
#import "YXBookListViewModel.h"

@interface YXSelectBookContentVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *bookTalbe;
@property (nonatomic, strong) YXConfigure3GradeModel *gradeModel;
@property (nonatomic, strong) YXBookListViewModel *bookViewModel;
@end

@implementation YXSelectBookContentVC


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.gradeModel = [[YXConfigure3GradeModel alloc]init];
//        self.bookViewModel = [[YXBookListViewModel alloc]init];
//    }
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = UIColorOfHex(0xffffff);
//    self.bookTalbe = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight-44) style:UITableViewStylePlain];
//    self.bookTalbe.delegate = self;
//    self.bookTalbe.dataSource = self;
//    self.bookTalbe.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.bookTalbe.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.bookTalbe];
//    
//    [self.bookTalbe registerClass:[YXSelectBookCell class] forCellReuseIdentifier:@"YXSelectBookCell"];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.gradeModel.options.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 126;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    YXSelectBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSelectBookCell" forIndexPath:indexPath];
//    YXConfigure3BookModel *bookModel = self.gradeModel.options[indexPath.row];
//    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.cover]];
//    cell.totalVocabularyLab.text = [NSString stringWithFormat:@"总词汇：%@",bookModel.word_count];
//    cell.titleLab.text = bookModel.name;
//    if ([[YXConfigure shared].loginModel.learning.bookid isEqualToString:bookModel.book_id]) {
//        cell.resultLab.hidden = NO;
//    } else {
//        cell.resultLab.hidden = YES;
//    }
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    YXConfigure3BookModel *bookModel = self.gradeModel.options[indexPath.row];
//    if ([[YXConfigure shared].loginModel.learning.bookid isEqualToString:bookModel.book_id]) {
//        return;
//    }
//    YXSelectBookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selectIconImageView.hidden = NO;
//    [self setLearning:bookModel.book_id
//             complete:^(id obj, BOOL result) {
//                 if (!result) {
//                     cell.selectIconImageView.hidden = YES;
//                 }
//             }];
//}
//
//- (void)insertGradeModel:(id)model {
//    self.gradeModel = model;
//    [self.bookTalbe reloadData];
//}
//
//- (void)addBook:(NSString *)bookids complete:(finishBlock)block {
//    __weak YXSelectBookContentVC *weakSelf = self;
//    [YXUtils showHUD:self.view];
//    [self.bookViewModel addBook:bookids finish:^(id obj, BOOL result) {
//        block(obj, result);
//        [YXUtils hideHUD:weakSelf.view];
//        if (result) {
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        } else {
//            [YXUtils showHUD:weakSelf.navigationController.view
//                       title:@"网络错误"];
//        }
//    }];
//}
//
//- (void)setLearning:(NSString *)bookids complete:(finishBlock)block{
//    __weak YXSelectBookContentVC *weakSelf = self;
//    [YXUtils showHUD:self.view];
//    [self.bookViewModel setLearning:bookids finish:^(id obj, BOOL result) {
//        block(obj, result);
//        [YXUtils hideHUD:weakSelf.view];
//        if (result) {
//            if (weakSelf.transType == TransationPresent) {
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//            } else if (weakSelf.transType == TransationPop) {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            } else if (weakSelf.transType == TransationNone) {
////                [[YXMediator shared]showMainVC];
//            }
//        } else {
//            [YXUtils showHUD:weakSelf.navigationController.view title:@"网络错误"];
//        }
//    }];
//}
//
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//

@end
