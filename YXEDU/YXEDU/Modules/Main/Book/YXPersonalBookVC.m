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
#import "YXMyBooksInfo.h"
#import "YXStudyProgressView.h"
#import "YXBookMaterialManager.h"

#import "YXFileDBManager.h"
#import "YXBookMaterialModel.h"
#import "Growing.h"


static NSString *const kProgressValueKeyPath = @"progressValue";

@interface YXPersonalBookVC ()<UITableViewDelegate, UITableViewDataSource,YXMyBookCellDelegate,YXSetProgressViewDelegate>
@property (nonatomic, strong) UITableView *accountTalbe;
@property (nonatomic, strong) YXPersonalBookViewModel *bookViewModel;
@property (nonatomic, strong) UIImageView *singleLine;
@property (nonatomic, strong)YXMyBooksInfo *myBooksInfo;
@property (nonatomic, strong)NSMutableArray *myBooks;
@property (nonatomic, weak)YXStudyProgressView *progressView;

@property (nonatomic, strong)YXStudyBookModel *currentDownLoadBookModel;
@property (nonatomic, strong)NSIndexPath *curDownLoadIndexPath;

@property (nonatomic, strong)YRHttpTask *curBookTask;
@end

@implementation YXPersonalBookVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bookViewModel = [[YXPersonalBookViewModel alloc]init];
    }
    return self;
}

-(BOOL)popGestureRecognizerEnabled {
    return NO;
}
- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"我的词书";
    self.view.backgroundColor = UIColorOfHex(0xF3F8FB);
    [self accountTalbe];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"  " forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"back_white"];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 44);// CGSizeMake(80, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)back {
    if (self.curBookTask) {
        YXComAlertView *alertView = [YXComAlertView showAlert:YXAlertCommon inView:[UIApplication sharedApplication].keyWindow info:@"提示" content:@"当前有素材包正在下载中，是否放弃下载并退出？" firstBlock:^(id obj) {
            [self.navigationController popViewControllerAnimated:YES];
        } secondBlock:^(id obj) {
        }];
        
        [alertView.firstBtn setTitle:@"确认退出" forState:UIControlStateNormal];
        [alertView.secondBtn setTitle:@"点错了" forState:UIControlStateNormal];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.textColorType = TextColorWhite;
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self reload];
}

- (void)refreshBtnClicked {
    [self reload];
}

- (void)dealloc {
//    [self.currentDownLoadBookModel removeObserver:self forKeyPath:kProgressValueKeyPath];
    
}
#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.myBooks.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= 2) {
        return 20;
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 190;
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXBookTitleHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXBookTitleHeader"];
    if (section == 0) {
        header.nameLab.text = @"正在学习";
    } else if (section == 1) {
        header.nameLab.text = @"学习记录";
    }else {
        header.nameLab.text = nil;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMyBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMyBookCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.studyBookModel = self.myBooks[indexPath.section];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

// iOS 9~11
- (NSArray <UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self tipsDeleteBookWith:indexPath];
    }];
    deleteRowAction.backgroundColor = UIColorOfHex(0xFC7D8B);
    //重学
    UITableViewRowAction *resetRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重学" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self tipsResetBookWith:indexPath];
    }];
    resetRowAction.backgroundColor = UIColorOfHex(0xA6B3C1);
    if (indexPath.section == 0) {
        return @[resetRowAction];
    } else {
        return @[resetRowAction,deleteRowAction];
    }
}

// iOS 11.0之后
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    if (@available(iOS 11.0, *)) {
            UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                                       title:@"删除"
                                                                                     handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                                                                                         [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                                                                         [self tipsDeleteBookWith:indexPath];
//                                                                                         completionHandler(NO);
                                                                                     }];
        deleteAction.backgroundColor = UIColorOfHex(0xFC7D8B);
        deleteAction.image = [UIImage imageNamed:@"delete_icon"];
        UIContextualAction *resetAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                                   title:@"重学"
                                                                                 handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                                                                                     [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                                                                     [self tipsResetBookWith:indexPath];
                                                                                     //                                                                                         completionHandler(NO);
                                                                                 }];
        resetAction.backgroundColor = UIColorOfHex(0xA6B3C1);
        resetAction.image = [UIImage imageNamed:@"reset_icon"];
        NSArray *actionArray = @[];
        if (indexPath.section == 0) {
            actionArray = @[resetAction];
        } else {
            actionArray = @[deleteAction ,resetAction];
        }
        UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:actionArray];
        actions.performsFirstActionWithFullSwipe = NO;
        
        return actions;
    }
    return nil;
}

- (void)tipsDeleteBookWith:(NSIndexPath *)indexPath {
    YXStudyBookModel *sbModel = self.myBooks[indexPath.section];
    NSString *tips = [NSString stringWithFormat:@"您确定要删除《%@》吗？",sbModel.bookName];
    [YXComAlertView showAlert:YXAlertCommon inView:[UIApplication sharedApplication].keyWindow info:@"提示" content:tips firstBlock:^(id obj) {
        [self deleteStudyBooks:sbModel];
    } secondBlock:^(id obj) {
    }];
}

- (void)tipsResetBookWith:(NSIndexPath *)indexPath {
    YXStudyBookModel *sbModel = self.myBooks[indexPath.section];
    NSString *tips = [NSString stringWithFormat:@"您确定要重学《%@》吗?",sbModel.bookName];
    [YXComAlertView showAlert:YXAlertCommon inView:self.navigationController.view info:@"提示" content:tips firstBlock:^(id obj) {
        [self resetStudyBooks:sbModel];
    } secondBlock:^(id obj) {
    }];
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        YXPersonalBookDelModel *delModel = [[YXPersonalBookDelModel alloc]init];
////        delModel.bookids = [self.bookViewModel getBookId:indexPath.row];
////        NSInteger question = [self.bookViewModel getAllOtherQuestioCount:indexPath.row];
////        if (question) {
////            NSInteger learned = [self.bookViewModel getAllOtherLearned:indexPath.row];
////            if (learned) {
////                NSInteger word = [self.bookViewModel getAllOtherWord:indexPath.row];
////                NSString *content = [NSString stringWithFormat:@"该本词书您已学习了 %ld / %ld 个单词，是否需要保留进度？", (long)learned, (long)word];
////                [YXComAlertView showAlert:YXAlertManageBook inView:self.view info:@"提示" content:content firstBlock:^(id obj) {
////                    delModel.reset = @"1";
////                    [self delBook:delModel];
////                } secondBlock:^(id obj) {
////                    delModel.reset = @"0";
////                    [self delBook:delModel];
////                }];
////            } else {
////                delModel.reset = @"1";
////                [self delBook:delModel];
////            }
//
////        } else {
////            [self delBook:delModel];
////        }
//        YXStudyBookModel *sbModel = self.myBooks[indexPath.section];;
//        [self deleteStudyBooks:sbModel.bookId];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <YXMyBookCellDelegate>
- (void)myBookCellChangeBook:(YXMyBookCell *)cell {
    __weak typeof(self) weakSelf = self;
    YXSelectBookVC *selectBookVC = [YXSelectBookVC selectBookVCSelectedSuccessBlock:^{
                                                                            [weakSelf reload];
                                                                        }];
    [self.navigationController pushViewController:selectBookVC animated:YES];
}

- (void)myBookCellStudyThatBook:(YXMyBookCell *)cell {
    [self setBookLearning:cell.studyBookModel.bookId];
}

- (void)myBookCellChangeStudyPlan:(YXMyBookCell *)cell {
    YXStudyBookModel *studyBookModel = cell.studyBookModel;
    NSInteger leftWords = [studyBookModel.wordCount integerValue] - [studyBookModel.learnedCount integerValue];
    NSInteger planRemain = [studyBookModel.planRemain integerValue];
    YXBookPlanModel *planModel = [YXBookPlanModel planModelWith:studyBookModel.bookId
                                                        planNum:[studyBookModel.planNum integerValue]
                                                      leftWords:leftWords
                                                 todayLeftWords:planRemain];
    
    YXStudyProgressView *progressView = [YXStudyProgressView showProgressInView:self.view withPlanModel:planModel WithDelegate:self];//[YXStudyProgressView showProgressInView:self.view withPlanModel:planModel];
//    progressView.delegate = self;
    self.progressView = progressView;
}

- (void)myBookCellDownLoadMaterial:(YXMyBookCell *)cell {
//    NSIndexPath *selIndexPath = [self.accountTalbe indexPathForCell:cell];
//    if (selIndexPath.section != self.curDownLoadIndexPath.section && self.curBookTask) {
//        // 非同一行，切正在现在
//        [YXUtils showHUD:self.view title:@"有现在任务正在现在中"];
//        return;
//    }
//
//    if (self.curBookTask) {
//        [self.curBookTask.task resume];
//        cell.progressView.hidden = NO;
//        return;
//    }
    
    YXStudyBookModel *model = cell.studyBookModel;
    self.currentDownLoadBookModel = cell.studyBookModel; // 执行下载记录模型
    __weak typeof(self) weakSelf = self;
    [YXUtils showProgress:self.view info:@"正在下载..."];
    self.curBookTask = [YXDataProcessCenter DOWNLOAD:model.resPath parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async_to_mainThread(^{
            cell.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
    } completion:^(YRHttpResponse *response, BOOL result) {
        [YXUtils hideHUD:weakSelf.view];
        
        if (result) {
            model.materialState = kBookMaterialDownloaded;
            [weakSelf.accountTalbe reloadData];
            [weakSelf successDownLoadWith:response.responseObject andStudyModel:model];
        }else {
            cell.progressView.progress = 0.0;
            model.materialState = kBookMaterialUnDownload;
            [weakSelf.accountTalbe reloadData];
            [weakSelf resetDownloadTask];
        }
//        weakSelf.currentDownLoadBookModel = nil;
    }];
    
    //    [model addObserver:self
    //            forKeyPath:kProgressValueKeyPath
    //               options:NSKeyValueObservingOptionNew
    //               context:nil];
//    [[YXBookMaterialManager shareManager] downloadBookMaterial:model.resPath
//                                                        bookId:model.bookId
//                                                      progress:^(NSProgress *downloadProgress) {
//        model.progressValue = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//    } completion:^(YRHttpResponse *response, BOOL result) {
//        if (result) {
//            [weakSelf successDownLoadWith:response.responseObject andStudyModel:model];
//        }
//        if (weakSelf) {
//            [model removeObserver:weakSelf forKeyPath:kProgressValueKeyPath];
//        }
//        weakSelf.currentDownLoadBookModel = nil;
//    }];
}

- (void)resetDownloadTask {
    self.curBookTask = nil;
}

//- (YRHttpTask *)curBookTask {
//    return [YXBookMaterialManager shareManager].curBookTask;
//}

- (void)restBookTask {
    self.currentDownLoadBookModel = nil;
}

- (void)successDownLoadWith:(NSData *)data andStudyModel:(YXStudyBookModel *)model {
    [YXUtils showProgress:self.view info:@"正在解压..."];
    dispatch_async_to_globalThread(^{
        NSString *subPath = [model.bookId stringByAppendingPathComponent:model.resUrl.lastPathComponent];
        BOOL isSuccess = [[YXFileDBManager shared] saveAndUnzip:data andOriFileName:subPath]; //model.resPath.lastPathComponent
        dispatch_async_to_mainThread(^{
            [YXUtils hideHUD:self.view];
            if (isSuccess) {
                YXBookMaterialModel *bModel = [[YXBookMaterialModel alloc] init];
                bModel.bookId = model.bookId;
                bModel.bookName = model.bookName;
                bModel.materialSize = [NSString stringWithFormat:@"%.2f",1.0 * (data.length) / (1024 * 1024)];
                bModel.resPath = [[YXUtils resourcePath] DIR:model.bookId];
                bModel.isFinished = @"1";
                [YXFMDBManager.share insertBookMaterial:@[bModel] completeBlock:^(id obj, BOOL result) {
                    [self resetDownloadTask];
                }];
            }else {
                [self resetDownloadTask];
                [YXUtils showHUD:self.view title:@"下载失败"];
            }
        });
    });
}

- (void)myBookCellDownloadStoped:(YXMyBookCell *)cell {
    [self.curBookTask.task suspend];
    cell.progressView.hidden = YES;
}

- (NSIndexPath *)curDownLoadIndexPath {
    return [NSIndexPath indexPathForRow:0 inSection:[self.myBooks indexOfObject:self.currentDownLoadBookModel]];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    YXStudyBookModel *model = (YXStudyBookModel *)object;
    YXMyBookCell *cell = (YXMyBookCell *)[self.accountTalbe cellForRowAtIndexPath:self.curDownLoadIndexPath];
    if (![model.bookId isEqualToString:cell.studyBookModel.bookId]) {
//        self.progressView.progress = 0.0;
        return;
    }else {
        if ([keyPath isEqualToString:kProgressValueKeyPath]) {
            cell.progressView.progress = [change[NSKeyValueChangeNewKey] floatValue];
        }
    }
}

#pragma mark - <YXStudyProgressViewDelegate>
//- (void)studyProgressViewSetPlan:(YXStudyProgressView *)pView withHttpResponse:(YRHttpResponse *)response {
- (void)setProgressViewSetPlan:(YXSetProgressView *)pView withHttpResponse:(YRHttpResponse *)response {
    if (!response.error) { // 计划设置成功
        [YXUtils showHUD:self.view title:@"学习计划保存成功，将于明天生效"];
        [self reload];
    }
}
#pragma mark - handleData
- (void)reload {
//    [YXUtils showProgress:self.view];
    [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:DOMAIN_MYBOOKS modelClass:[YXMyBooksInfo class] parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result)
    {
//        [YXUtils hideHUD:weakSelf.view];
        [self hideLoadingView];
        if (result) {
            [weakSelf hideNoNetWorkView];
            YXMyBooksInfo *myBooksInfo = response.responseObject;
            weakSelf.myBooksInfo = myBooksInfo;
            YXStudyBookModel *learningModel = myBooksInfo.learning;
            NSMutableArray *myBooks = [NSMutableArray array];
            if (learningModel) {
                learningModel.learning = YES;
                [myBooks addObject:learningModel];
                [YXConfigure shared].currLearningBookId = learningModel.bookId;
            }

//            [myBooks addObjectsFromArray:myBooksInfo.learned];
//            [myBooks addObjectsFromArray:myBooksInfo.learned];
//            [myBooks addObjectsFromArray:myBooksInfo.learned];
//            [myBooks addObjectsFromArray:myBooksInfo.learned];
//            [myBooks addObjectsFromArray:myBooksInfo.learned];
//            [myBooks addObjectsFromArray:myBooksInfo.learned];
            for (YXStudyBookModel *studyBook in myBooksInfo.learned) {
                [myBooks addObject:studyBook];
            }
            weakSelf.myBooks = myBooks;
//            [weakSelf.accountTalbe reloadData];
            [weakSelf checkBookState];
        }else {
            if (response.error.type == kBADREQUEST_TYPE) {
                [weakSelf showNoNetWorkView:^{
                    [weakSelf reload];
                }];
            }
        }
    }];
}


- (void)checkBookState {
    NSMutableArray *booIds = [NSMutableArray array];
    NSMutableDictionary *bookDics = [NSMutableDictionary dictionary];
    for (YXStudyBookModel *bookModel in self.myBooks) {
        [booIds addObject:bookModel.bookId];
        [bookDics setObject:bookModel forKey:bookModel.bookId];
    }
    [[YXBookMaterialManager shareManager] quaryBookStates:booIds completeBlock:^(id obj, BOOL result) {
        NSArray *matesrialStates = obj;
        for (YXBookMaterialModel * matesrialState in matesrialStates) {
            YXStudyBookModel *bookModel = [bookDics objectForKey:matesrialState.bookId];
            if ([matesrialState.isFinished boolValue]) {
                bookModel.materialState = kBookMaterialDownloaded;
            }
        }
        
        // 当前是否有正在下载的任务
        NSString *bookId = [YXBookMaterialManager shareManager].curTaskBookId;
        YXStudyBookModel *bookModel = [bookDics objectForKey:bookId];
        bookModel.materialState = kBookMaterialDownloading;
        [self.accountTalbe reloadData];
    }];
}

- (void)deleteStudyBooks:(YXStudyBookModel *)sbModel {
    NSDictionary *param = @{@"bookId" : sbModel.bookId};
    [YXDataProcessCenter POST:DOMAIN_DELBOOK parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 删除成功
            [self reload];
        }
    }];
}

- (void)resetStudyBooks:(YXStudyBookModel *)sbModel {
    NSDictionary *param = @{@"bookId" : sbModel.bookId};
    [YXDataProcessCenter POST:DOMAIN_RESETBOOK parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 重置成功
            [self reload];
            [Growing track:@"BookReset" withVariable:@{@"book_reset_progress" : [NSNumber numberWithFloat:sbModel.progressValue], @"book_name" : sbModel.bookName, @"book_id":sbModel.bookId}];
        }
    }];
}

// 设置要学习的书籍
- (void)setBookLearning:(NSString *)bookId {
    NSDictionary *param = @{ @"bookId" : bookId };
    [YXDataProcessCenter POST:DOMAIN_SETLEARNING parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 设置成功
            [self reload];
        }
    }];
}

- (void)getBook:(finishBlock)block {
//    __weak YXPersonalBookVC *weakSelf = self;
//    [self.bookViewModel getBookList:^(id obj, BOOL result) {
//        block (obj, result);
//        if (result) {
//            [weakSelf.accountTalbe reloadData];
//        } else {
//            [YXUtils showHUD:weakSelf.view title:@"网络错误!"];
//        }
//    }];
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

#pragma mark - 提示
- (BOOL)checkOperateCanbeHandeled {
    [YXUtils showHUD:self.view title:@"有词书正在下载，无法进行次操作"];
    return YES;
}

#pragma mark - subView
- (UITableView *)accountTalbe {
    if (!_accountTalbe) {
        CGFloat leftMargin = iPhone5 ? 0 : 15;
        _accountTalbe = [[UITableView alloc]initWithFrame:CGRectMake(leftMargin,0, SCREEN_WIDTH - 2 * leftMargin, SCREEN_HEIGHT-kNavHeight) style:UITableViewStyleGrouped];
        _accountTalbe.delegate = self;
        _accountTalbe.dataSource = self;
        _accountTalbe.backgroundColor = [UIColor clearColor];
        _accountTalbe.separatorStyle = UITableViewCellSeparatorStyleNone;
        _accountTalbe.showsVerticalScrollIndicator = NO;
        _accountTalbe.rowHeight = 190;
        _accountTalbe.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25 + kSafeBottomMargin)];
        [_accountTalbe registerClass:[YXBookTitleHeader class] forHeaderFooterViewReuseIdentifier:@"YXBookTitleHeader"];
        [_accountTalbe registerClass:[YXMyBookCell class] forCellReuseIdentifier:@"YXMyBookCell"];
        [self.view addSubview:_accountTalbe];
    }
    return _accountTalbe;
}
@end
//    if (SYSTEM_VERSION_LESS_THAN(11)) {
//        UIView *titleBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight)];
//        titleBackView.backgroundColor = self.view.backgroundColor;
//        [self.view addSubview:titleBackView];
//
//        self.accountTalbe.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } else {
//        self.accountTalbe.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight);
//    }

//    self.singleLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, 1)];
//    self.singleLine.backgroundColor = UIColorOfHex(0xe6e6e6);
//    [self.view addSubview:self.singleLine];


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return self.myBooksInfo.learning ? 1 : 0;
//    }else {
//        if (self.myBooksInfo.learned.count) {
//            return 1;
//        }else {
//            return 0;
//        }
//    }
//}
