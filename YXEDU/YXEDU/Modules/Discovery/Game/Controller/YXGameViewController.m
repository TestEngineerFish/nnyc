//
//  YXGameViewController.m
//  YXEDU
//
//  Created by yao on 2018/12/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGameViewController.h"
#import "YXGameBackgroundView.h"
#import "YXGameAnswerModel.h"
#import "YXGameGuideView.h"
#import "YXGameResultViewController.h"
static NSString *const kOneDrawGameGuidedKey = @"OneDrawGameGuidedKey";

@interface YXGameViewController ()<YXGameBackgroundViewDelegate,YXGameGuideViewDelegate>
@property (nonatomic, weak) YXComNaviView *naviView;
@property (nonatomic, weak) YXGameBackgroundView *gameView;
@property (nonatomic, strong) NSArray *gameIndexes;
@property (nonatomic, weak) YXSquareView *squareView;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger leftSeconds;

@property (nonatomic, weak) YXGameGuideView *guideGuideView;

@property (nonatomic, strong) NSDate *guideStartDate;
@end

@implementation YXGameViewController
- (NSArray *)gameIndexes {
    if (!_gameIndexes) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gameDictionary.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        _gameIndexes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    }
    return _gameIndexes;
}

- (void)setGameDetail:(YXGameDetailModel *)gameDetail {
    for (YXGameContent *gameContent in gameDetail.gameContent) {
        gameContent.questionIndex = [self.gameIndexes indexOfObject:gameContent.encryptKey];
    }
    
    [gameDetail.gameContent sortUsingComparator:^NSComparisonResult(YXGameContent *gameContent1, YXGameContent *gameContent2) {
        if (gameContent1.questionIndex > gameContent2.questionIndex) {
            return NSOrderedDescending;
        }else {
            return NSOrderedAscending;
        }
    }];

    _gameDetail = gameDetail;
    self.leftSeconds = gameDetail.gameConf.totalTime;
}

- (BOOL)popGestureRecognizerEnabled {
    return NO;
}

- (void)loadView {
    YXGameBackgroundView *gameView = [[YXGameBackgroundView alloc] init];
    gameView.delegate = self;
    self.gameView = gameView;
    self.view = gameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    YXGameBackgroundView *gameView = [[YXGameBackgroundView alloc] init];
//    gameView.frame = CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    [self.view addSubview:gameView];
    
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [kNotificationCenter addObserver:self selector:@selector(loginOut) name:kLogoutNotify object:nil];
    [self naviView];
    self.squareView = self.gameView.squareView;
    [self gameIndexes];
    
    // 创建答案模型
    YXGameAnswerModel *gameAnswerModel = [[YXGameAnswerModel alloc] init];
    gameAnswerModel.gameId = self.gameDetail.gameConf.gameId;
    gameAnswerModel.startTime = self.gameDetail.startTime;
    gameAnswerModel.times = self.gameModel.times;
    self.gameView.gameAnswerModel = gameAnswerModel;
    
    if ([YXGameGuideView isGameGuideShowedWith:kOneDrawGameGuidedKey]) {
//        [self setupTimer];
        [self startPlayGame];
    }else {
        [self.gameView.squareView doOpenAnimation];
        self.guideGuideView = [YXGameGuideView gameGuideShowToView:self.view delegate:self];
        self.guideGuideView.gameGuideKey = kOneDrawGameGuidedKey;
        self.guideStartDate = [NSDate date];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}
#pragma mark - start game
- (void)startPlayGame {
    [self setupTimer];// 启动定时器
    self.gameView.gameDetail = self.gameDetail;
}
#pragma mark - handle data

#pragma mark - <YXGameBackgroundViewDelegate>
- (void)gameBackgroundViewGameFinished:(YXGameBackgroundView *)gamebgView {
    [self invalidateTimer];// 暂停定时器
    YXGameAnswerModel *gameAnswerModel = self.gameView.gameAnswerModel;
    gameAnswerModel.lastTime = self.leftSeconds;
    // 上报答题结果

    YXGameResultViewController *gameResultVC= [[YXGameResultViewController alloc] init];
    gameResultVC.gameAnswerModel = gameAnswerModel;
    gameResultVC.gameId = self.gameModel.gameId;
    gameResultVC.title = self.gameModel.name;

    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs removeLastObject];
    [vcs addObject:gameResultVC];
    [self.navigationController setViewControllers:vcs animated:YES];
}

#pragma mark - <YXGameGuideViewDelegate>
- (void)gameGuideView:(YXGameGuideView *)gameGuider guideStep:(NSInteger)step {
    if (step > 3) { // finish guide
        self.gameView.gameAnswerModel.preloadTime = [[NSDate date] timeIntervalSinceDate:self.guideStartDate];
        [self.gameView.squareView doCloseAnimationWith:^{
            [self startPlayGame];
        }];
    }
}
#pragma mark - subViews
- (YXComNaviView *)naviView {
    if (!_naviView) {
        YXComNaviView *naviView = [YXComNaviView comNaviViewWithLeftButtonType:YXNaviviewLeftButtonGray];
        naviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
        [naviView.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        naviView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:naviView];
        naviView.titleLabel.textColor = UIColorOfHex(0x485562);
        naviView.titleLabel.font = [UIFont pfSCRegularFontWithSize:19];
        naviView.titleLabel.text = self.gameModel.name;
        _naviView = naviView;
    }
    return _naviView;
}

- (void)back {
   YXComAlertView *alertView = [YXComAlertView showAlert:YXAlertCommon
                       inView:[UIApplication sharedApplication].keyWindow
                         info:@"提示"
                      content:@"挑战尚未完成，是否退出并放弃本次挑战？"
                   firstBlock:^(id obj) {
                       [self invalidateTimer];
                       [kNotificationCenter postNotificationName:kReloadRankNotify object:nil];
                       [self.navigationController popViewControllerAnimated:YES];
                   } secondBlock:^(id obj) {
                       [self resumeTimer];
                   }];
    [self pauseTimer];
    [alertView.firstBtn setTitle:@"确定退出" forState:UIControlStateNormal];
    [alertView.secondBtn setTitle:@"继续挑战" forState:UIControlStateNormal];

}

#pragma mark - 定时器
- (void)setupTimer {
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)countDown {
    self.leftSeconds --;
    NSInteger leftSeconds = self.leftSeconds;
    if(self.leftSeconds <= 0){
        [self invalidateTimer];
        self.leftSeconds = 0;
        leftSeconds = 0;
        [self.gameView gameFinished];
    }
    
    NSInteger minute = leftSeconds / 60;
    NSInteger second = leftSeconds % 60;
    NSString *countDownStr = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    self.gameView.countdownLabel.text = countDownStr;
}

- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)loginOut {
    [self invalidateTimer];
}

- (void)pauseTimer {
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)resumeTimer {
    if (_timer) {
        [_timer setFireDate:[NSDate date]];
    }
}
@end
