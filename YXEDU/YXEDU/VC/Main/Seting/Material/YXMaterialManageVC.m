//
//  YXMaterialManageVC.m
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMaterialManageVC.h"
#import "BSCommon.h"
#import "YXMaterialCell.h"
#import "YXFMDBManager.h"
#import "YXMaterialViewModel.h"
#import "YXUtils.h"
#import "YXComAlertView.h"

@interface YXMaterialManageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *materialTalbe;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) YXMaterialViewModel*materialViewModel;
@end

@implementation YXMaterialManageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.materialViewModel = [[YXMaterialViewModel alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    self.title = @"素材包管理";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorOfHex(0x4DB3FE);
    self.materialTalbe = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight-50-SafeBottomMargin) style:UITableViewStylePlain];
    self.materialTalbe.delegate = self;
    self.materialTalbe.dataSource = self;
    self.materialTalbe.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.materialTalbe.backgroundColor = UIColorOfHex(0xffffff);
    [self.view addSubview:self.materialTalbe];
    
    [self.materialTalbe registerClass:[YXMaterialCell class] forCellReuseIdentifier:@"YXMaterialCell"];
    
    self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.delBtn setFrame:CGRectMake(0, SCREEN_HEIGHT-SafeBottomMargin-50, SCREEN_WIDTH, SafeBottomMargin+50)];
    [self.delBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [self.delBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.delBtn setBackgroundColor:[UIColor whiteColor]];
    [self.delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.delBtn];
    
    [self.view bringSubviewToFront:self.noResourceView];
    [self.noResourceView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.textColorType = TextColorWhite;
    [super viewWillAppear:animated];
    [self requestAllMaterial];
}

- (void)requestAllMaterial {
    [self.materialViewModel requestAllDB:^(id obj, BOOL result) {
        [self.materialTalbe reloadData];
    }];
}

- (void)delBtnClicked:(id)sender {
    if (![self.materialViewModel rowCount]) {
        return;
    }
    
    [YXComAlertView showAlert:YXAlertMaterial inView:self.view info:@"删除所有资源?" content:nil  firstBlock:^(id obj) {
        [self.materialViewModel deleteAll:^(id obj, BOOL result) {
            [self.materialTalbe reloadData];
        }];
    } secondBlock:^(id obj) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.materialViewModel rowCount]==0) {
        self.noResourceView.hidden = NO;
    } else {
        self.noResourceView.hidden = YES;
    }
    return [self.materialViewModel rowCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMaterialCell" forIndexPath:indexPath];
    YXMaterialModel *model = [self.materialViewModel model:indexPath.row];
    cell.titleLab.text = model.resname;
    cell.resultLab.text = [YXUtils fileSizeToString:model.size.longLongValue];
    cell.delBlock = ^(id obj) {
        [YXComAlertView showAlert:YXAlertMaterial inView:self.view info:@"确定删除该资源？" content:nil  firstBlock:^(id obj) {
            [self.materialViewModel deleteDB:indexPath.row finished:^(id obj, BOOL result) {
                [self.materialTalbe reloadData];
            }];
        } secondBlock:^(id obj) {
        }];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [YXComAlertView showAlert:YXAlertMaterial inView:self.view info:@"确定删除该资源？" content:nil  firstBlock:^(id obj) {
            [self.materialViewModel deleteDB:indexPath.row finished:^(id obj, BOOL result) {
                [self.materialTalbe reloadData];
            }];
        } secondBlock:^(id obj) {
            
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
