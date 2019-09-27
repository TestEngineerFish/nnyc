//
//  YXMissionToCheckinView.m
//  YXEDU
//
//  Created by 吉乞悠 on 2019/1/1.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXMissionToCheckinView.h"

@interface YXMissionToCheckinView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *ratio;

@end

@implementation YXMissionToCheckinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setDays:(NSInteger)days {
    _days = days;
    _title.text = [NSString stringWithFormat:@"本周已签到%zd天,今日签到可得",_days];
}

- (void)setCredits:(NSInteger)credits {
    _credits = credits;
    NSString *temStr = [NSString stringWithFormat:@"X %zd",_credits];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13.3],NSForegroundColorAttributeName: [UIColor colorWithRed:67/255.0 green:74/255.0 blue:93/255.0 alpha:1.0]}];
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(13)]} range:NSMakeRange(0, 1)];
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(24)]} range:NSMakeRange(2, 2)];
    _ratio.attributedText = string;
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    UIView *alertView = [[UIView alloc] init];
    alertView.frame = CGRectMake(SCREEN_WIDTH/2-AdaptSize(130), SCREEN_HEIGHT/2-AdaptSize(110), AdaptSize(260), AdaptSize(235));
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 10;
    [self addSubview:alertView];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.frame = CGRectMake(alertView.width/2 - AdaptSize(35), -AdaptSize(30), AdaptSize(70), AdaptSize(70));
    icon.image = [UIImage imageNamed:@"Mission_tocheck"];
    [alertView addSubview:icon];
    
    UIImageView *bulingbuling = [[UIImageView alloc] init];
    bulingbuling.frame = CGRectMake(SCREEN_WIDTH/2-AdaptSize(105), SCREEN_HEIGHT/2-AdaptSize(200), AdaptSize(212), AdaptSize(217));
    bulingbuling.image = [UIImage imageNamed:@"Mission_buling"];
    [self insertSubview:bulingbuling belowSubview:alertView];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(AdaptSize(36), AdaptSize(63), AdaptSize(190), AdaptSize(15));
    title.text = @"本周已签到0天,今日签到可得";
    title.font = [UIFont systemFontOfSize:AdaptSize(14)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UIColorOfHex(0x434A5D);
    [alertView addSubview:title];
    _title = title;
    
    UIImageView *douzi = [[UIImageView alloc] init];
    douzi.frame = CGRectMake(AdaptSize(74), AdaptSize(93), AdaptSize(68), AdaptSize(46));
    douzi.image = [UIImage imageNamed:@"Mission_douzi"];
    [alertView addSubview:douzi];
    _douzi = douzi;
    
    UILabel *ratio = [[UILabel alloc] init];
    ratio.frame = CGRectMake(AdaptSize(134),AdaptSize(105),AdaptSize(100),AdaptSize(24));
    ratio.textAlignment = NSTextAlignmentLeft;
    ratio.numberOfLines = 0;
    [alertView addSubview:ratio];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"X 20" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13.3],NSForegroundColorAttributeName: [UIColor colorWithRed:67/255.0 green:74/255.0 blue:93/255.0 alpha:1.0]}];
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(13)]} range:NSMakeRange(0, 1)];
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(24)]} range:NSMakeRange(2, 2)];
    ratio.attributedText = string;
    _ratio = ratio;
    
    UIButton *toCheckBtn = [[UIButton alloc] init];
    toCheckBtn.frame = CGRectMake(AdaptSize(56), AdaptSize(157), AdaptSize(150), AdaptSize(50));
    [toCheckBtn setImage:[UIImage imageNamed:@"Mission_tocheckBtn"] forState:UIControlStateNormal];
    [alertView addSubview:toCheckBtn];
    [toCheckBtn addTarget:self action:@selector(toCheck) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH/2-AdaptSize(17), SCREEN_HEIGHT/2+AdaptSize(140), AdaptSize(34), AdaptSize(34));
    [closeBtn setImage:[UIImage imageNamed:@"Mission_closeBtn"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}
     
- (void)toCheck {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    [YXDataProcessCenter POST:DOMAIN_SIGNIN parameters:@{@"time":timeString} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            if (response.responseObject) { //防过期签到
                //成功
//                [self removeFromSuperview];
                if (self.checkSuccessBlock) {
                    self.checkSuccessBlock();
                }
            } else {
                //过期
                [self removeFromSuperview];
            }
        } else {
            //请求失败
            [self removeFromSuperview];
        }
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc {
    
}
@end
