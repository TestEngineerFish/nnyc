//
//  YXMaterialManageVC.m
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalMaterialManageVC.h"
#import "BSCommon.h"
#import "YXPersonalMaterialCell.h"
#import "YXUtils.h"
#import "YXComAlertView.h"
#import "NSObject+YR.h"
#import "YXNoResourceView.h"
#import "YXNoNetworkView.h"
@interface YXPersonalMaterialManageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *removeAllButton;

@property (nonatomic, strong) NSMutableArray *materialSources;
@end

@implementation YXPersonalMaterialManageVC

- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    self.title = @"素材包管理";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColor.whiteColor;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.masksToBounds = NO;
    
    self.containerView.layer.shadowColor = UIColorOfHex(0xAED7E3).CGColor;
    self.containerView.layer.shadowRadius = 2.5;
    self.containerView.layer.shadowOpacity = 0.44;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 3);
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.layer.cornerRadius = 8;
    [self.tableView registerClass:[YXPersonalMaterialCell class] forCellReuseIdentifier:@"YXPersonalMaterialCell"];
    
    self.removeAllButton = [[UIButton alloc] init];
    self.removeAllButton.layer.cornerRadius = 22;
    [self.removeAllButton setTitle:@"全部清除" forState:UIControlStateNormal];
    [self.removeAllButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.removeAllButton setBackgroundColor:UIColorOfHex(0xF6F8FA)];
    self.removeAllButton.layer.borderWidth = 1.0;
    self.removeAllButton.layer.borderColor = UIColorOfHex(0xEAF4FC).CGColor;
    [self.removeAllButton addTarget:self action:@selector(deleteAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.tableView];
    [self.view addSubview:self.removeAllButton];
    
    [self.removeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.bottom.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.removeAllButton.mas_top).offset(-20);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.containerView);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CGFloat size = 0;
    if (self.refreshBookMaterial) {
//        for (YXBookMaterialModel *bmm in self.materialSources) {
//            size += [bmm.materialSize floatValue];
//        }
//        self.refreshBookMaterial([NSString stringWithFormat:@"%.2fM",size]);
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
//    [[YXBookMaterialManager shareManager] quaryMaterialOfAllBooksCompleteBlock:^(id obj, BOOL result) {
//        self.materialSources = obj;
//        [self.tableView reloadData];
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.materialSources && self.materialSources.count == 0) {
        [self showNoDataView:@"暂未下载离线包" image:[UIImage imageNamed:@"nomaterials"]];
    }else {
        [self hideNoDataView];
    }
    return self.materialSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXPersonalMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXPersonalMaterialCell" forIndexPath:indexPath];
//    YXBookMaterialModel *model = self.materialSources[indexPath.row];
//
//    cell.titleLable.text = model.bookName;
//    cell.sizeLabel.text = [NSString stringWithFormat:@"%@M", model.materialSize];
//    cell.deleteBlock = ^(id obj) {
//        [YXComAlertView showAlert:YXAlertCommon inView:[UIApplication sharedApplication].keyWindow info:nil content:@"确定删除该资源？" firstBlock:^(id obj) {
//            [self deleteBook:model];
//        } secondBlock:^(id obj) {
//        }];
//    };
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//- (void)deleteBook:(YXBookMaterialModel *)book {
//    if (book.bookId) {
//        [YXFMDBManager.share deleteBookMaterialsWithBookIds:@[book.bookId] completeBlock:^(id obj, BOOL result) {
//            if (result) {
//                NSError *error = nil;
//                BOOL suceess = [[NSFileManager defaultManager] removeItemAtPath:book.resPath error:&error];
//                if (suceess) {
//                    [self.materialSources removeObject:book];
//                    [self.tableView reloadData];
//                }
//            }
//        }];
//    }
//}

- (void)deleteAllButtonClicked:(id)sender {
    [YXComAlertView showAlert:YXAlertCommon inView:[UIApplication sharedApplication].keyWindow info:nil content:@"删除所有资源?" firstBlock:^(id obj) {
        [self deleteAllBooks];
    } secondBlock:^(id obj) {
    }];
}

- (void)deleteAllBooks {
    [YXFMDBManager.share deleteAllBookMaterialsWithCompleteBlock:^(id obj, BOOL result) {
        if (result) {
            NSError *error = nil;
            NSString *path = [YXUtils resourcePath];
            BOOL isDic;
            if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDic]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
            [self.materialSources removeAllObjects];
            [self.tableView reloadData];
        }
    }];
}

@end
