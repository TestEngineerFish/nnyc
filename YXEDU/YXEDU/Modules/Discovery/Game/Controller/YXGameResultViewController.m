//
//  YXGameResultViewController.m
//  YXEDU
//
//  Created by yao on 2019/1/4.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXGameResultViewController.h"
#import "YXGameResultModel.h"
#import "YXGameShareView.h"
#import "YXShareHelper.h"

@interface YXGameResultViewController ()
@property (nonatomic, weak) YXComNaviView *naviView;
@property (nonatomic, weak) UIImageView *resultImageView;
@property (nonatomic, strong) YXGameResultModel *resultModel;
@property (nonatomic, weak) YXGameShareView *shareView;
@end

@implementation YXGameResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"一笔画";
    [self naviView];
    
//    [self refreshView];
    [self reportGameResult];
}

- (void)reportGameResult {
    NSString *resultJson = [self.gameAnswerModel mj_JSONString];
    NSString *gameId = self.gameId;
    NSDictionary *param = @{
                            @"gameId" : gameId,
                            @"result" : resultJson
                            };
    [YXDataProcessCenter POST:DIMAIN_GAMEREPORT parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            [self hideNoNetWorkView];
            if ([[response.responseObject objectForKey:@"state"] integerValue] == 1) {
                [kNotificationCenter postNotificationName:kReloadRankNotify object:nil];
                [self getResult];
            }else {
                __weak typeof(self) weakSelf = self;
                [self showNoNetWorkView:^{
                    [weakSelf reportGameResult];
                }];
            }
        }else {
            __weak typeof(self) weakSelf = self;
            [self showNoNetWorkView:^{
                [weakSelf reportGameResult];
            }];
        }
    }];
}

- (void)getResult {
    [YXDataProcessCenter GET:DIMAIN_GAMERESULT
                  modelClass:[YXGameResultModel class]
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            self.resultModel = response.responseObject;
            [self refreshView];
        }
    }];
}


- (void)refreshView {
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, AdaptSize(463))];
    [self.view addSubview:resultImageView];
    NSInteger state = self.resultModel.state;
    
    if (state == 2) {
        resultImageView.frame = CGRectMake(0, kNavHeight + AdaptSize(30), SCREEN_WIDTH, AdaptSize(558));
        resultImageView.image = [UIImage imageNamed:@"gameResultFail"];
    }else {
        CGFloat lrMargin = AdaptSize(10);
        UIImageView *colockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gameResultTime"]];
        [resultImageView addSubview:colockIcon];
        [colockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(resultImageView).offset(lrMargin);
            make.size.mas_equalTo(MakeAdaptCGSize(39, 39));
        }];
        
        UILabel *countTimelabel = [[UILabel alloc] init];
        [resultImageView addSubview:countTimelabel];
        [countTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(colockIcon.mas_right).offset(5);
            make.centerY.equalTo(colockIcon);
        }];
        
        UILabel *rankingLabel = [[UILabel alloc] init];
        [resultImageView addSubview:rankingLabel];
        [rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(countTimelabel);
            make.right.equalTo(resultImageView).offset(-lrMargin);
        }];
        
        UIImageView *rankingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gameResultRank"]];
        [resultImageView addSubview:rankingIcon];
        [rankingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rankingLabel.mas_left).offset(-5);
            make.size.centerY.equalTo(colockIcon);
        }];
        
        // 分享
        __weak typeof(self) weakSelf = self;
        YXGameShareView *shareView = [[YXGameShareView alloc] init];
        shareView.shareBlock = ^(YXSharePalform platForm) {
            [weakSelf shareResultTo:platForm];
        };
        [self.view addSubview:shareView];
        _shareView = shareView;
        [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-AdaptSize(16)-kSafeBottomMargin);
            make.height.mas_equalTo(AdaptSize(106));
        }];
        
        NSString *rightNum = self.resultModel.rightNum;
        UIFont *biggerFont = [UIFont pfSCMediumFontWithSize:AdaptSize(20)];
        UIFont *smallFont = [UIFont pfSCMediumFontWithSize:AdaptSize(17)];
        NSString *timeString = [NSString stringWithFormat:@"(%@)",self.resultModel.answerTimeString];
        NSMutableAttributedString *rightAttributedString = [[NSMutableAttributedString alloc] initWithString:rightNum
                                                                                                  attributes:@{
                                                                                                               NSForegroundColorAttributeName : UIColorOfHex(0x01A36A),
                                                                                                               NSFontAttributeName : biggerFont
                                                                                                               }];
        NSAttributedString *timeAttributedString = [[NSAttributedString alloc] initWithString:timeString
                                                                                   attributes:@{
                                                                                                NSForegroundColorAttributeName : UIColorOfHex(0x6BCDA2),
                                                                                                NSFontAttributeName : smallFont,
                                                                                                NSBaselineOffsetAttributeName : @1
                                                                                                }];
        [rightAttributedString appendAttributedString:timeAttributedString];
        countTimelabel.attributedText = rightAttributedString;
        
        NSDictionary *rankAttriDic = @{
                                       NSForegroundColorAttributeName : UIColorOfHex(0xF38606),
                                       NSFontAttributeName : smallFont
                                       };

        if (self.resultModel.ranking == 0) {
            NSAttributedString *rankAttributedString = [[NSAttributedString alloc] initWithString:@"未获得排名" attributes:rankAttriDic];
            rankingLabel.attributedText = rankAttributedString;
        }else {
            NSString *rankString = [NSString stringWithFormat:@"No.%@",self.resultModel.rankingString];
            NSMutableAttributedString *rankAttributedString = [[NSMutableAttributedString alloc] initWithString:rankString attributes:rankAttriDic];
            NSRange range = [rankString rangeOfString:self.resultModel.rankingString];
            [rankAttributedString addAttributes:@{ NSFontAttributeName : biggerFont} range:range];
            rankingLabel.attributedText = rankAttributedString;
        }
        
        if (state == 1) { // 成功
            resultImageView.image = [UIImage imageNamed:@"gameResultSuccess"];
        }else {// 错过时间
            resultImageView.image = [UIImage imageNamed:@"gameResultOverDeadline"];
        }
    }
}

#pragma mark - share action

- (void)shareResultTo:(YXSharePalform)platform {
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self.view title:@"网络不给力"];
        return;
    }
    
    if(!self.resultModel) {
        return;
    }
    self.shareView.userInteractionEnabled = NO;
    YXGameResultModel *resultModel = self.resultModel;
    if (resultModel.userIcon) {
        UIImage *shareImage = [YXShareImageGenerator generateGameResultImage:resultModel
                                                                    platform:platform];
        [self shareResultTo:platform withImage:shareImage];
        return;
    }
    __weak typeof(self) weakSelf = self;
    // 下载头像
    [[SDWebImageManager sharedManager].imageDownloader
     downloadImageWithURL:[NSURL URLWithString:self.resultModel.avatar]
     options:SDWebImageDownloaderLowPriority
     progress:nil
     completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image && !error) {
            resultModel.userIcon = image;
        }else {
            resultModel.userIcon = [UIImage imageNamed:@"userPlaceHolder"];
        }
        UIImage *shareImage = [YXShareImageGenerator generateGameResultImage:resultModel
                                                                platform:platform];
         
         [weakSelf shareResultTo:platform withImage:shareImage];
     }];
}

- (void)shareResultTo:(YXSharePalform)platform withImage:(UIImage *)image {
    self.shareView.userInteractionEnabled = YES;
    if (image) {
        [YXShareHelper shareImage:image
                       toPaltform:platform
                            title:nil
                     describution:nil
                    shareBusiness:kShareGameResult];
    }
}

#pragma mark - subViews
- (YXComNaviView *)naviView {
    if (!_naviView) {
        YXComNaviView *naviView = [YXComNaviView comNaviViewWithLeftButtonType:YXNaviviewLeftButtonGray];
        naviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
        [naviView.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        naviView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:naviView];
        naviView.titleLabel.textColor = UIColorOfHex(0x485562);
        naviView.titleLabel.font = [UIFont pfSCRegularFontWithSize:19];
        naviView.titleLabel.text = self.title;
        _naviView = naviView;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight - 1, SCREEN_WIDTH, 1)];
        line.backgroundColor = UIColorOfHex(0xD8E0E5);
        [naviView addSubview:line];
    }
    return _naviView;
}

- (void)back {
    [kNotificationCenter postNotificationName:kReloadRankNotify object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
