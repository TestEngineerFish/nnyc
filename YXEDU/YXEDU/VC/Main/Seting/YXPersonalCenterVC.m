//
//  YXPersonlCenterVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalCenterVC.h"
#import "YXPersonalCenterCell.h"
#import "YXPersonalBlankCell.h"
#import "YXPersonalViewModel.h"
#import "YXBindPhoneVC.h"
#import "BSCommon.h"
#import "YXComAlertView.h"
#import "YXConfigure.h"
#import "UIImageView+YR.h"
#import "YXMediator.h"
#import "YXLogoutModel.h"
#import "YXUtils.h"
#import "YXCommHeader.h"
#import "YXPersonalHeaderView.h"
#import "YXPersonalAboutVC.h"
#import "YXPersonalFeedBackVC.h"
#import "YXMaterialManageVC.h"
#import "YXMaterialViewModel.h"
#import "WXApiManager.h"
#import "QQApiManager.h"
#import "NetWorkRechable.h"
#import "YXPersonalLogoutCell.h"
#import "YXStudyRecordCenter.h"

@interface YXPersonalCenterVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *personalTalbe;
@property (nonatomic, strong) YXPersonalHeaderView *personalView;
@property (nonatomic, strong) YXPersonalViewModel *viewModel;

@property (nonatomic, strong) YXMaterialViewModel *materialViewModel;
@end

@implementation YXPersonalCenterVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [[YXPersonalViewModel alloc]init];
        self.materialViewModel = [[YXMaterialViewModel alloc]init];
        
        __weak YXPersonalCenterVC *weakSelf = self;
        [[WXApiManager shared]setFinishBlock:^(id obj, BOOL result) {
            if (((NSString *)obj).length) {
                YXPersonalBindModel *sendModel = [[YXPersonalBindModel alloc]init];
                sendModel.bind_pf = @"wechat";
                sendModel.code = obj;
                sendModel.openid = @"";
                [weakSelf bind:sendModel];
            }
        }];
        
        [[QQApiManager shared]setFinishBlock:^(id obj1, id obj2, BOOL result) {
            if (((NSString *)obj1).length) {
                YXPersonalBindModel *sendModel = [[YXPersonalBindModel alloc]init];
                sendModel.bind_pf = @"qq";
                sendModel.code = obj1;
                sendModel.openid = obj2;
                [weakSelf bind:sendModel];
            }
        }];
    }
    return self;
}

- (void)bind:(YXPersonalBindModel *)bindModel {
    __weak YXPersonalCenterVC *weakSelf = self;
    [YXUtils showHUD:self.view];
    [self.viewModel bindSO:bindModel complete:^(id obj, BOOL result) {
        if (result) {
            [weakSelf.viewModel requestUserInfo:^(id obj, BOOL result) {
                [YXUtils hideHUD:weakSelf.view];
                if (result) {
                    [weakSelf.personalTalbe reloadData];
                }
            }];
        } else {
            [YXUtils hideHUD:weakSelf.view];
        }
    }];
}

- (void)unbind:(NSString *)platform {
    __weak YXPersonalCenterVC *weakSelf = self;
    [YXUtils showHUD:self.view];
    [self.viewModel unbindSO:platform complete:^(id obj, BOOL result) {
        if (result) {
            [weakSelf.viewModel requestUserInfo:^(id obj, BOOL result) {
                [YXUtils hideHUD:weakSelf.view];
                if (result) {
                    [weakSelf.personalTalbe reloadData];
                }
            }];
        } else {
            [YXUtils hideHUD:weakSelf.view];
        }
    }];
}

- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    self.title = @"个人中心";
    self.view.backgroundColor = UIColorOfHex(0x4DB3FE);
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.personalView = [[YXPersonalHeaderView alloc]initWithFrame:CGRectMake(0, -110, SCREEN_WIDTH, 110)];
    
    self.personalTalbe = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight) style:UITableViewStylePlain];
    self.personalTalbe.delegate = self;
    self.personalTalbe.dataSource = self;
    self.personalTalbe.backgroundColor = [UIColor clearColor];
    self.personalTalbe.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.personalTalbe.clipsToBounds = YES;
    self.personalTalbe.bounces = NO;
    [self.view addSubview:self.personalTalbe];
    
    [self.personalTalbe registerClass:[YXPersonalCenterCell class] forCellReuseIdentifier:@"YXPersonalCenterCell"];
    [self.personalTalbe registerClass:[YXPersonalBlankCell class] forCellReuseIdentifier:@"YXPersonalBlankCell"];
    [self.personalTalbe registerClass:[YXPersonalLogoutCell class] forCellReuseIdentifier:@"YXPersonalLogoutCell"];
    [self.personalTalbe insertSubview:self.personalView atIndex:0];
    self.personalTalbe.contentInset = UIEdgeInsetsMake(110, 0, 0, 0);
    self.personalView.titleLab.text = [YXConfigure shared].loginModel.user.nick.length?[YXConfigure shared].loginModel.user.nick:[YXConfigure shared].loginModel.user.mobile;
    [self.personalView.titleImage yr_setImageUrlString:[YXConfigure shared].loginModel.user.avatar placeholderImage:[UIImage imageNamed:@"personal_user"]];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = UIColorOfHex(0xF6F6F6);
    self.personalTalbe.backgroundView = backView;
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.textColorType = TextColorWhite;
    [super viewWillAppear:animated];
    [self requestAllMaterial];
}

- (void)requestAllMaterial {
    [self.materialViewModel requestAllDB:^(id obj, BOOL result) {
        [self.personalTalbe reloadData];
    }];
}

- (void)logoutBtnClicked:(id)sender {
    
    [[YXStudyRecordCenter shared]queryRecord:^(id obj, BOOL result) {
        NSString *content = result?@"检测到有未上传的学习记录，退出登录后将会丢失！！！取消后打开网络连接即可自动上传。":nil;
        [YXComAlertView showAlert:YXAlertLogout inView:self.navigationController.view info:nil content:content firstBlock:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                YXLogoutModel *logoutModel = [[YXLogoutModel alloc]init];
                logoutModel.jp_devices_id = [YXConfigure shared].deviceId;
                logoutModel.jp_registration_id = jgId;
                [YXUtils showHUD:self.view];
                __weak YXPersonalCenterVC *weakSelf = self;
                [self.viewModel logout:logoutModel finish:^(id obj, BOOL result) {
                    [YXUtils hideHUD:weakSelf.view];
                    [[YXMediator shared]afterLogout];
                }];
            });
        } secondBlock:^(id obj) {
        }];
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel rowCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel rowHeight:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalCellType cellType = [self.viewModel rowType:indexPath.row];
    switch (cellType) {
        case PersonalCellPlain: {
            YXPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXPersonalCenterCell" forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.personalCenterCellType = PersonalCenterCellText;
                cell.nameLab.text = @"手机号";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_mobile"];
                cell.resultLab.text = [YXConfigure shared].loginModel.user.mobile;
                cell.lineView.hidden = NO;
            } else if (indexPath.row == 2) {
                cell.nameLab.text = @"QQ";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_qq"];
                cell.resultLab.text = [YXConfigure shared].loginModel.user.nick;
                if (![[YXConfigure shared].loginModel.user.user_bind containsString:@"1"]) {
                    cell.personalCenterCellType = PersonalCenterCellButton;
                } else {
                    cell.personalCenterCellType = PersonalCenterCellBindIcon;
                    cell.iconImageView.image = [UIImage imageNamed:@"personal_bind"];
                }
                cell.lineView.hidden = NO;
            } else if (indexPath.row == 3) {
                cell.personalCenterCellType = PersonalCenterCellButton;
                cell.nameLab.text = @"微信";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_weichat"];
                if (![[YXConfigure shared].loginModel.user.user_bind containsString:@"2"]) {
                    cell.personalCenterCellType = PersonalCenterCellButton;
                } else {
                    cell.personalCenterCellType = PersonalCenterCellBindIcon;
                    cell.iconImageView.image = [UIImage imageNamed:@"personal_bind"];
                }
                cell.lineView.hidden = YES;
            } else if (indexPath.row == 5) {
                cell.personalCenterCellType = PersonalCenterCellTextAndIcon;
                cell.nameLab.text = @"默认音标和发音";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_voice"];
                if ([YXConfigure shared].isUSVoice) {
                    cell.resultLab.text = @"美式";
                } else {
                    cell.resultLab.text = @"英式";
                }
                cell.lineView.hidden = NO;
            } else if (indexPath.row == 6) {
                cell.personalCenterCellType = PersonalCenterCellTextAndIcon;
                cell.nameLab.text = @"素材包管理";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_download"];
                cell.resultLab.text = [YXUtils fileSizeToString:[self.materialViewModel getAllSize]];
                cell.lineView.hidden = YES;
            } else if (indexPath.row == 8) {
                cell.personalCenterCellType = PersonalCenterCellText;
                cell.nameLab.text = @"关于我们";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_about"];
                cell.resultLab.text = @"";
                cell.lineView.hidden = NO;
            } else if (indexPath.row == 9) {
                cell.personalCenterCellType = PersonalCenterCellText;
                cell.nameLab.text = @"意见反馈";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_feedback"];
                cell.resultLab.text = @"";
                cell.lineView.hidden = YES;
            } else if (indexPath.row == 11) {
                cell.personalCenterCellType = PersonalCenterCellText;
                cell.nameLab.text = @"意见反馈";
                cell.titleImageView.image = [UIImage imageNamed:@"personal_feedback"];
                cell.resultLab.text = @"";
                cell.lineView.hidden = YES;
            }
            return cell;
        }
        case PersonalCellBlank: {
            YXPersonalBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXPersonalBlankCell" forIndexPath:indexPath];
            return cell;
        }
        case PersonalCellLogout: {
            YXPersonalLogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXPersonalLogoutCell" forIndexPath:indexPath];
            return cell;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PersonalCellType cellType = [self.viewModel rowType:indexPath.row];
    switch (cellType) {
        case PersonalCellPlain: {
            if (indexPath.row == 1) {
                
            } else if (indexPath.row == 2) {
                if ([[YXConfigure shared].loginModel.user.user_bind containsString:@"1"]) {
                    [self unBindSO:@"qq"];
                } else {
                    [self bindQQ];
                }
            } else if (indexPath.row == 3) {
                if ([[YXConfigure shared].loginModel.user.user_bind containsString:@"2"]) {
                    [self unBindSO:@"wechat"];
                } else {
                    [self bindWX];
                }
            } else if (indexPath.row == 4) {
                if (![YXConfigure shared].loginModel.user.mobile.length) {
                    YXBindPhoneVC *bindVC = [[YXBindPhoneVC alloc]init];
                    [self.navigationController pushViewController:bindVC animated:YES];
                }
            } else if (indexPath.row == 5) {
                [self selectPronunciation:^{
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
                
            } else if (indexPath.row == 6) {
                YXMaterialManageVC *materialVC = [[YXMaterialManageVC alloc]init];
                [self.navigationController pushViewController:materialVC animated:YES];
            } else if (indexPath.row == 8) {
                YXPersonalAboutVC *aboutVC = [[YXPersonalAboutVC alloc]init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            } else if (indexPath.row == 9) {
                YXPersonalFeedBackVC *feedVC = [[YXPersonalFeedBackVC alloc]init];
                [self.navigationController pushViewController:feedVC animated:YES];
            }
        }
            break;
        case PersonalCellLogout: {
            [self logoutBtnClicked:nil];
        }break;
            
        default:
            break;
    }
}

- (void)bindQQ {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    [[QQApiManager shared]qqLogin];
}

- (void)bindWX {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    [[WXApiManager shared]wxLogin];
}

- (void)unBindSO:(NSString *)platform {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认要解除绑定%@", platform] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { NSLog(@"action = %@", action); }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self unbind:platform];
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)selectPronunciation:(void(^)(void))block {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择音标和发音方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionEN = [UIAlertAction actionWithTitle:@"英式音标和发音" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [YXConfigure shared].isUSVoice = NO;
        block();
    }];
    
    UIAlertAction *actionUS = [UIAlertAction actionWithTitle:@"美式音标和发音" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [YXConfigure shared].isUSVoice = YES;
        block();
    }];
    [alertCtrl addAction:actionEN];
    [alertCtrl addAction:actionUS];
    [alertCtrl addAction:actionCancel];
    [self presentViewController:alertCtrl animated:YES completion:^{
    }];
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
