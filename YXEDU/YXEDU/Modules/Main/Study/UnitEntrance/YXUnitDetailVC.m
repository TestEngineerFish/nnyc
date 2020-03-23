//
//  YXStartStudyVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXUnitDetailVC.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "YXExerciseVC.h"
#import "YXUnitDetailViewModel.h"
#import "SVProgressHUD.h"
#import "YXStudyBookUnitModel.h"
#import "NSString+YX.h"
#import "YXUtils.h"
#import "NetWorkRechable.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import "YXUnitDownLoadView.h"


@interface YXUnitDetailVC () <YXUnitDownLoadViewDelegate>

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *unitLab;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *bottomTitleLab;
@property (nonatomic, strong) UILabel *studyNumLab;
@property (nonatomic, strong) UILabel *wordChLab;
@property (nonatomic, strong) UIView *wordView;
@property (nonatomic, strong) UILabel *downloadStatusLab;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) YXUnitModel *unitModel;

@property (nonatomic, strong) YXUnitDetailViewModel *unitViewModel;
@property (nonatomic, strong) YXUnitDownLoadView *downLoadView;
@end

@implementation YXUnitDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.unitViewModel = [[YXUnitDetailViewModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    self.view.backgroundColor = UIColorOfHex(0x4DB3FE);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2.0f, kNavHeight + 28, 200, 178)];
    self.titleImageView.image = [UIImage imageNamed:@"study_unit_titleimage"];
    [self.view addSubview:self.titleImageView];
    
    self.startLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 92+kNavHeight, SCREEN_WIDTH, 20)];
    self.startLab.font = [UIFont boldSystemFontOfSize:20];
    self.startLab.textColor = UIColorOfHex(0xffffff);
    self.startLab.clipsToBounds = NO;
    self.startLab.textAlignment = NSTextAlignmentCenter;
    self.startLab.text = @"Starter Unit";
    [self.view addSubview:self.startLab];
    
    self.unitLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.startLab.frame) + 14, SCREEN_WIDTH, 30)];
    self.unitLab.font = [UIFont boldSystemFontOfSize:36];
    self.unitLab.textColor = UIColorOfHex(0xffffff);
    self.unitLab.clipsToBounds = NO;
    self.unitLab.textAlignment = NSTextAlignmentCenter;
    self.unitLab.text = @"1";
    [self.view addSubview:self.unitLab];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight + 260, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight-260)];
    self.bottomView.backgroundColor = UIColorOfHex(0xffffff);
    [self.view addSubview:self.bottomView];
    
    self.bottomTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 50)];
    self.bottomTitleLab.font = [UIFont boldSystemFontOfSize:20];
    self.bottomTitleLab.textColor = UIColorOfHex(0x535353);
    self.bottomTitleLab.text = @"Good morning！";
    self.bottomTitleLab.numberOfLines = 0;
    self.bottomTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.bottomTitleLab];
    
    if (iPhone5) {
        self.bottomTitleLab.frame = CGRectMake(0, 10, SCREEN_WIDTH, 50);
    } else if (iPhone4) {
        self.bottomTitleLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    }
    
    self.wordView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomTitleLab.frame) + 10, SCREEN_WIDTH, 67)];
    self.wordView.backgroundColor = [UIColor clearColor];
    [self.bottomView addSubview:self.wordView];
    
    self.studyNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 67)];
    self.studyNumLab.font = [UIFont boldSystemFontOfSize:48];
    self.studyNumLab.textColor = UIColorOfHex(0x535353);
    self.studyNumLab.text = @"30";
    self.studyNumLab.textAlignment = NSTextAlignmentCenter;
    [self.wordView addSubview:self.studyNumLab];
    
    self.wordChLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 25)];
    self.wordChLab.font = [UIFont systemFontOfSize:18];
    self.wordChLab.textColor = UIColorOfHex(0x232323);
    self.wordChLab.text = @"词";
    self.wordChLab.textAlignment = NSTextAlignmentCenter;
    [self.wordView addSubview:self.wordChLab];
    
    CGFloat studyWidth = [self.studyNumLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.studyNumLab.font].width;
    CGFloat wordWidth = [self.wordChLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.wordChLab.font].width;
    
    self.wordView.frame = CGRectMake((SCREEN_WIDTH - studyWidth - wordWidth)/2.0, CGRectGetMaxY(self.bottomTitleLab.frame) + 10, SCREEN_WIDTH, 67);
    self.studyNumLab.frame = CGRectMake(0, 0, studyWidth, 67);
    self.wordChLab.frame = CGRectMake(studyWidth, 30, wordWidth, 37);
    
    self.downloadStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wordView.frame) + 60, SCREEN_WIDTH, 20)];
    self.downloadStatusLab.font = [UIFont systemFontOfSize:14];
    self.downloadStatusLab.textColor = UIColorOfHex(0x999999);
    self.downloadStatusLab.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.downloadStatusLab];
    
    if (iPhone5) {
        self.downloadStatusLab.frame = CGRectMake(0, CGRectGetMaxY(self.wordView.frame)+ 10, SCREEN_WIDTH, 20);
    } else if (iPhone4) {
        self.downloadStatusLab.frame = CGRectMake(0, CGRectGetMaxY(self.wordView.frame)+ 0, SCREEN_WIDTH, 20);
    }
    
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startBtn setFrame:CGRectMake((SCREEN_WIDTH-260)/2.0, CGRectGetMaxY(self.downloadStatusLab.frame) + 20, 260, 50)];
    [self.startBtn setTitle:@"重新回顾" forState:UIControlStateNormal];
    [self.startBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
    [self.startBtn setBackgroundColor:[UIColor clearColor]];
    [self.startBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.startBtn];
    
    if (iPhone5) {
        [self.startBtn setFrame:CGRectMake((SCREEN_WIDTH-260)/2.0, CGRectGetMaxY(self.downloadStatusLab.frame) + 10, 260, 50)];
    } else if (iPhone4) {
        [self.startBtn setFrame:CGRectMake((SCREEN_WIDTH-260)/2.0, CGRectGetMaxY(self.downloadStatusLab.frame) + 0, 260, 50)];
    }
    [self reloadView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)reloadData {
    __weak YXUnitDetailVC *weakSelf = self;
    [self.unitViewModel getUnit:self.unitModel finish:^(id obj, BOOL result) {
        NSString *bookid = [YXConfigure shared].loginModel.learning.bookid;
        if ([weakSelf.unitViewModel checkFileIfExistsavePath:[bookid DIR:self.unitModel.unitid] zipFile:[YXConfigure shared].bookUnitModel.filename]) {
            weakSelf.downloadStatusLab.text = [NSString stringWithFormat:@"素材包：已下载"];
            if (self.unitModel.learned.integerValue == self.unitModel.word.integerValue) {
                [weakSelf.startBtn setTitle:@"重新回顾" forState:UIControlStateNormal];
            } else {
                [weakSelf.startBtn setTitle:@"开始学习" forState:UIControlStateNormal];
            }
        } else {
            weakSelf.downloadStatusLab.text = [NSString stringWithFormat:@"素材包：待下载"];
            [weakSelf.startBtn setTitle:@"下载素材包" forState:UIControlStateNormal];
        }
    }];
}

- (void)insertModel:(id)model {
    self.unitModel = model;
}

- (void)reloadView {
    YXUnitNameModel *nameModel = [YXUnitNameModel modelWithName:self.unitModel.name];
    self.startLab.text = nameModel.line1;
    self.unitLab.text = nameModel.line2;
    
    self.studyNumLab.text = self.unitModel.word;
    self.bottomTitleLab.text = self.unitModel.desc;
    
    CGFloat numWidth = [self.studyNumLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.studyNumLab.font].width;
    CGFloat wordWidth = [self.wordChLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.wordChLab.font].width;
    self.wordView.frame = CGRectMake((SCREEN_WIDTH - numWidth - wordWidth)/2.0, CGRectGetMaxY(self.bottomTitleLab.frame) + 10, numWidth+wordWidth, 67);
    self.studyNumLab.frame = CGRectMake(0, 0, numWidth, 67);
    self.wordChLab.frame = CGRectMake(numWidth, 30, wordWidth, 30);
    
    if (self.unitModel.learned.integerValue == self.unitModel.word.integerValue) {
        [self.startBtn setTitle:@"重新回顾" forState:UIControlStateNormal];
    } else {
        [self.startBtn setTitle:@"开始学习" forState:UIControlStateNormal];
    }
    
    if (iPhone5) {
        self.wordView.frame = CGRectMake((SCREEN_WIDTH - numWidth - wordWidth)/2.0, CGRectGetMaxY(self.bottomTitleLab.frame) + 10, numWidth+wordWidth, 67);
    } else if (iPhone4) {
        self.wordView.frame = CGRectMake((SCREEN_WIDTH - numWidth - wordWidth)/2.0, CGRectGetMaxY(self.bottomTitleLab.frame) + 0, numWidth+wordWidth, 67);
    }
    
    if (iPhone5) {
        self.downloadStatusLab.frame = CGRectMake(0, CGRectGetMaxY(self.wordView.frame)+ 10, SCREEN_WIDTH, 20);
    } else if (iPhone4) {
        self.downloadStatusLab.frame = CGRectMake(0, CGRectGetMaxY(self.wordView.frame)+ 0, SCREEN_WIDTH, 20);
    }
    
    if (iPhone5) {
        [self.startBtn setFrame:CGRectMake((SCREEN_WIDTH-260)/2.0, CGRectGetMaxY(self.downloadStatusLab.frame) + 10, 260, 50)];
    } else if (iPhone4) {
        [self.startBtn setFrame:CGRectMake((SCREEN_WIDTH-260)/2.0, CGRectGetMaxY(self.downloadStatusLab.frame) + 0, 260, 50)];
    }
}

- (void)startBtnClicked:(id)sender {
    [self getUnitResource:^(id obj, BOOL result) {
    }];
}

- (void)getUnitResource:(finishBlock)block {
    [YXUtils showProgress:self.view];
    __weak YXUnitDetailVC *weakSelf = self;
    [self.unitViewModel getUnit:self.unitModel finish:^(id obj, BOOL result) {
        [YXUtils hidenProgress:weakSelf.view];
        if (result) {
            YXStudyBookUnitModel *bookUnit = obj;
            [weakSelf checkResourceIfNeedDownLoadURLString:bookUnit.resource savePath:[bookUnit.bookid DIR:bookUnit.unitid] zipName:[bookUnit.resource lastPathComponent]];
            block(obj, result);
        } else {
            [YXUtils showHUD:weakSelf.view title:@"网络错误"];
        }
    }];
}

- (void)checkResourceIfNeedDownLoadURLString:(NSString *)URLString
                                    savePath:(NSString *)name
                                     zipName:(NSString *)zipName {
    if (![self.unitViewModel checkFileIfExistsavePath:name zipFile:[zipName stringByDeletingPathExtension]]) {
        switch ([NetWorkRechable shared].netWorkStatus) {
            case NetWorkStatusUnknown:
                
                break;
            case NetWorkStatusNotReachable:
                
                break;
            case NetWorkStatusReachableViaWWAN:{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到您当前为非wifi环境，是否继续下载素材包" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { YXLog(@"action = %@", action); }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"继续下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    self.downLoadView = [YXUnitDownLoadView showDownLoadView:self.view rootVC:self];
                    [self.unitViewModel startDownload:URLString savePath:name zipFile:zipName sourceModel:self.unitModel progress:^(NSProgress *progress) {
                        float percent = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
                        [self.downLoadView updateProgress:percent];
                    } complete:^(id obj, BOOL result) {
                        if (result) {
                            if (self.downLoadView) {
                                [self.downLoadView removeFromSuperview];
                            }
                            YXExerciseVC *exerciseVC = [[YXExerciseVC alloc]init];
                            [exerciseVC insertModel:self.unitModel];
                            [self.navigationController pushViewController:exerciseVC animated:YES];
                        } else {
                            if (((NSNumber *)obj).intValue == -1005) { // 网络错误
                                if (self.downLoadView) {
                                    [self.downLoadView removeFromSuperview];
                                }
                                [YXUtils showHUD:self.view title:@"网络错误!"];
                            }
                        }
                    }];
                }];
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            case NetWorkStatusReachableViaWiFi: {
                self.downLoadView = [YXUnitDownLoadView showDownLoadView:self.view rootVC:self];
                [self.unitViewModel startDownload:URLString
                                               savePath:name
                                                zipFile:zipName
                                            sourceModel:self.unitModel
                                               progress:^(NSProgress *progress) {
                                                   float percent = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
                                                   [self.downLoadView updateProgress:percent];
                                                   YXLog(@"%f", percent);
                                               }
                                               complete:^(id obj, BOOL result) {
                    if (result) {
                        if (self.downLoadView) {
                            [self.downLoadView removeFromSuperview];
                        }
                        YXExerciseVC *exerciseVC = [[YXExerciseVC alloc]init];
                        [exerciseVC insertModel:self.unitModel];
                        [self.navigationController pushViewController:exerciseVC animated:YES];
                    } else {
                        if (((NSNumber *)obj).intValue == -1005) { // 网络错误
                            if (self.downLoadView) {
                                [self.downLoadView removeFromSuperview];
                            }
                            [YXUtils showHUD:self.view title:@"网络错误!"];
                        }
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
    } else {
        YXExerciseVC *exerciseVC = [[YXExerciseVC alloc]init];
        [exerciseVC insertModel:self.unitModel];
        [self.navigationController pushViewController:exerciseVC animated:YES];
    }
}

#pragma mark --
- (void)cancelBtnDidClicked:(id)sender {
    if (self.downLoadView) {
        [self.downLoadView removeFromSuperview];
    }
    [self.unitViewModel cancel];
}


- (void)dealloc {
    
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
