//
//  YXPersonalAboutVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalAboutVC.h"
#import "YXAboutComCell.h"
#import "BSCommon.h"
#import "YXAboutHeaderView.h"
#import "YXPolicyVC.h"
#import "YXPersonalFeedBackVC.h"

@interface YXPersonalAboutVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *aboutTable;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) YXAboutHeaderView *aboutHeaderView;
@end

@implementation YXPersonalAboutVC

- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = UIColorOfHex(0x4DB3FE);
    self.aboutTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight) style:UITableViewStylePlain];
    self.aboutTable.delegate = self;
    self.aboutTable.dataSource = self;
    [self.view addSubview:self.aboutTable];
    
    [self.aboutTable registerClass:[YXAboutComCell class] forCellReuseIdentifier:@"YXAboutComCell"];
    self.aboutHeaderView = [[YXAboutHeaderView alloc]initWithFrame:CGRectMake(0, -248, SCREEN_WIDTH, 248)];
    [self.aboutTable insertSubview:self.aboutHeaderView atIndex:0];
    self.aboutTable.contentInset = UIEdgeInsetsMake(248, 0, 0, 0);
    [self setExtraCellLineHidden:self.aboutTable];
    
    self.rightLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SafeBottomMargin-50, SCREEN_WIDTH, 20)];
    self.rightLab.text = @"@Copyright@2018 念念有词";
    self.rightLab.textColor = UIColorOfHex(0xBCBCBC);
    self.rightLab.font = [UIFont systemFontOfSize:12];
    self.rightLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.rightLab];
}

// 清除底部多余的线条
-(void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [tableView setTableFooterView:view];
}

- (void)viewWillAppear:(BOOL)animated {
    self.textColorType = TextColorWhite;
    [super viewWillAppear:animated];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXAboutComCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:@"YXAboutComCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        aboutCell.titleLab.text = [NSString stringWithFormat:@"用户协议"];
    } else if (indexPath.row == 1)  {
        aboutCell.titleLab.text = [NSString stringWithFormat:@"意见反馈"];
    }
    return aboutCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        YXPolicyVC *policyVC = [[YXPolicyVC alloc]init];
        [self.navigationController pushViewController:policyVC animated:YES];
    } else if (indexPath.row == 1) {
        YXPersonalFeedBackVC *feedVC = [[YXPersonalFeedBackVC alloc]init];
        [self.navigationController pushViewController:feedVC animated:YES];
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
