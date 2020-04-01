//
//  YXPosterShareView.m
//  YXEDU
//
//  Created by jukai on 2019/4/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXPosterShareView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "YXShareHelper.h"
#import "YXHttpService.h"

@implementation YXPosterShareButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat wh = 53;
    CGFloat x = (contentRect.size.width - wh) * 0.5;
    return CGRectMake(x, 10, wh, wh);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 73, contentRect.size.width, 15);
}

@end

@interface YXPosterShareView()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *link;
@property (nonatomic, strong)YXPunchModel *punchModel;
@property (nonatomic, weak)UILabel *engLabel;
@property (nonatomic, weak)UILabel *chnLabel;
@property (nonatomic, weak)UILabel *sayingLabel;
@property (nonatomic, weak)UIImageView *userImgView;
@property (nonatomic, weak)UILabel *careerLabel;
@property (nonatomic, weak)UILabel *todayWordNumLabel;
@property (nonatomic, weak)UILabel *careerWordNumLabel;
@property (nonatomic, strong)UILabel *momentsShareCreditsTotalL;
@property (nonatomic, weak)UIButton *wechatFriendBtn;
@property (nonatomic, copy) YXPosterShareBlock shareBlock;

@end

@implementation YXPosterShareView

+ (YXPosterShareView *)showShareInView:(UIView *)view
                            punchModel:(YXPunchModel *)punchModel block:(YXPosterShareBlock)block {
    YXPosterShareView *shareView = [[self alloc] initWithFrame:view.bounds];
    shareView.punchModel = punchModel;
    shareView.shareBlock = block;
    [view addSubview:shareView];
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorOfHex(0xEEF4FC);
        UIImageView *posterBGView = [[UIImageView alloc]initWithFrame:CGRectMake(15, kStatusBarHeight+13.0, SCREEN_WIDTH-30.0, AdaptSize(530.0))];
        [posterBGView setImage:[UIImage imageNamed:@"打卡分享页-橙色底"]];

        NSString *imageStr = [kUserDefault objectForKey:@"shareBgImage"];
        UIImage *bgImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
        if (bgImage) {
            [posterBGView setImage:bgImage];
        }
        [self addSubview:posterBGView];
        posterBGView.layer.cornerRadius = 13;
        posterBGView.layer.masksToBounds = YES;

        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(6, kStatusBarHeight, 34, 34)];
        [cancleBtn setImage:[UIImage imageNamed:@"Share关闭"] forState:UIControlStateNormal];
        [cancleBtn setImage:[UIImage imageNamed:@"Share关闭"] forState:UIControlStateSelected];
        [cancleBtn addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
        
//        UIImageView *songshuBGView = [[UIImageView alloc]initWithFrame:CGRectMake(0, AdaptSize(230.0), SCREEN_WIDTH-30.0, AdaptSize(300.0))];
//        [songshuBGView setImage:[UIImage imageNamed:@"分享海报配图"]];
//        [posterBGView addSubview:songshuBGView];

        
        UILabel *engLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, AdaptSize(51.0), SCREEN_WIDTH-60.0, AdaptSize(48.0))];
        engLabel.text = @"";
        engLabel.numberOfLines = 0;
        engLabel.textColor = [UIColor whiteColor];
        [engLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [posterBGView addSubview:engLabel];
        self.engLabel = engLabel;
        
        
        UILabel *chnLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, AdaptSize(104.0), SCREEN_WIDTH-60.0, AdaptSize(48.0))];
        chnLabel.text = @"";
        chnLabel.numberOfLines = 0;
        chnLabel.textColor = [UIColor whiteColor];
        [chnLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [posterBGView addSubview:chnLabel];
        self.chnLabel = chnLabel;
        
        UILabel *sayingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, AdaptSize(132.0), SCREEN_WIDTH-60.0, AdaptSize(15.0))];
        sayingLabel.text = @"——— 念念谚语";
        sayingLabel.textAlignment = NSTextAlignmentRight;
        
        sayingLabel.textColor = [UIColor whiteColor];
        [sayingLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [posterBGView addSubview:sayingLabel];
        self.sayingLabel = sayingLabel;
        
        
        //分享生涯数据底块
        UIImageView *shareCareerBGView = [[UIImageView alloc]initWithFrame:CGRectMake(6, AdaptSize(365.0), SCREEN_WIDTH-42.0, AdaptSize(165.0))];
        [shareCareerBGView setImage:[UIImage imageNamed:@"分享生涯数据底块"]];
        [posterBGView addSubview:shareCareerBGView];
        
        UIImageView *userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(45.0), AdaptSize(22.0), AdaptSize(28.0), AdaptSize(28.0))];
        [userImgView setImage:[UIImage imageNamed:@""]];
        userImgView.layer.cornerRadius = 14.0;
        userImgView.layer.masksToBounds = YES;
        [shareCareerBGView addSubview:userImgView];
        self.userImgView = userImgView;
        
        
        UILabel *careerLabel = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(86.0), AdaptSize(31.0), SCREEN_WIDTH-AdaptSize(86.0), AdaptSize(14.0))];
        [careerLabel setText:@"春暖花开”的生涯数据"];
        [careerLabel setFont:[UIFont systemFontOfSize:AdaptSize(14.0)]];
        [careerLabel setTextColor:UIColorOfHex(0x333E4B)];
        [shareCareerBGView addSubview:careerLabel];
        self.careerLabel = careerLabel;
        
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(15.0), AdaptSize(62.0), AdaptSize(302.0), AdaptSize(1.0))];
        
        [lineView setImage:[UIImage imageNamed:@"分割线-横"]];
        [shareCareerBGView addSubview:lineView];
        
        UILabel *todayWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(45.0), AdaptSize(76.0), SCREEN_WIDTH/2.0, AdaptSize(12.0))];
        [todayWordLabel setText:@"今日学习单词"];
        todayWordLabel.textAlignment = NSTextAlignmentCenter;
        [todayWordLabel setFont:[UIFont systemFontOfSize:AdaptSize(12.0)]];
        [todayWordLabel setTextColor:UIColorOfHex(0x79899D)];
        [shareCareerBGView addSubview:todayWordLabel];
        todayWordLabel.centerX = SCREEN_WIDTH/4.0;
        
        UILabel *todayWordNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-AdaptSize(64.0+33.0), AdaptSize(98.0), SCREEN_WIDTH/2.0, AdaptSize(22.0))];
        [todayWordNumLabel setText:@"35"];
        todayWordNumLabel.textAlignment = NSTextAlignmentCenter;
        [todayWordNumLabel setFont:[UIFont systemFontOfSize:AdaptSize(28.0)]];
        [todayWordNumLabel setTextColor:UIColorOfHex(0x333E4B)];
        [shareCareerBGView addSubview:todayWordNumLabel];
        todayWordNumLabel.centerX = SCREEN_WIDTH/4.0;
        self.todayWordNumLabel = todayWordNumLabel;
        
        UILabel *careerWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-AdaptSize(208.0),AdaptSize(76.0), SCREEN_WIDTH/2.0, AdaptSize(12.0))];
        [careerWordLabel setText:@"累计学习单词"];
        careerWordLabel.textAlignment = NSTextAlignmentCenter;
        [careerWordLabel setFont:[UIFont systemFontOfSize:AdaptSize(12.0)]];
        [careerWordLabel setTextColor:UIColorOfHex(0x79899D)];
        [shareCareerBGView addSubview:careerWordLabel];
        careerWordLabel.centerX = 3*SCREEN_WIDTH/4.0-50.0;
        
        UILabel *careerWordNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-AdaptSize(64.0+33.0), AdaptSize(98.0), SCREEN_WIDTH/2.0, AdaptSize(22.0))];
        careerWordNumLabel.textAlignment = NSTextAlignmentCenter;
        [careerWordNumLabel setText:@"55"];
        [careerWordNumLabel setFont:[UIFont systemFontOfSize:AdaptSize(28.0)]];
        [careerWordNumLabel setTextColor:UIColorOfHex(0x333E4B)];
        [shareCareerBGView addSubview:careerWordNumLabel];
        careerWordNumLabel.centerX = 3*SCREEN_WIDTH/4.0-50.0;
        
        self.careerWordNumLabel = careerWordNumLabel;
        
        UIImageView *verticalLineView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(166.0), AdaptSize(84.0), AdaptSize(1.0), AdaptSize(46.0))];
        
        [verticalLineView setImage:[UIImage imageNamed:@"分割线-竖"]];
        [shareCareerBGView addSubview:verticalLineView];
        
    }
    return self;
}


-(void)configCareer{
    
}

-(void)configBtns{
    
    float iPhoneXfloat = AdaptSize(601);
    if (kIsIPhoneXSerious){
        iPhoneXfloat = AdaptSize(701);
    }
    UIButton *qqBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(17.0), 0 + iPhoneXfloat , AdaptSize(44.0), AdaptSize(45.0))];
    [qqBtn setImage:[UIImage imageNamed:@"ShareQQ"] forState:UIControlStateNormal];
    [qqBtn setImage:[UIImage imageNamed:@"ShareQQ"] forState:UIControlStateSelected];
    qqBtn.tag = 2;
    [qqBtn addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:qqBtn];
    
    UIButton *wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(74.0), 0+ iPhoneXfloat , AdaptSize(44.0), AdaptSize(45.0))];
    
    [wechatBtn setImage:[UIImage imageNamed:@"Share微信"] forState:UIControlStateNormal];
    [wechatBtn setImage:[UIImage imageNamed:@"Share微信"] forState:UIControlStateSelected];
    wechatBtn.tag = 0;
    [wechatBtn addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wechatBtn];
    
    UIButton *wechatFriendBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(137.0), 0 + iPhoneXfloat , AdaptSize(228.0*44.0/49.0), AdaptSize(44.0))];
    //457 × 98
    [wechatFriendBtn setImage:[UIImage imageNamed:@"分享到朋友圈"] forState:UIControlStateNormal];
    [wechatFriendBtn setImage:[UIImage imageNamed:@"分享到朋友圈"] forState:UIControlStateSelected];
    wechatFriendBtn.tag = 1;
    [wechatFriendBtn addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
    self.wechatFriendBtn = wechatFriendBtn;
    
    
    
    [self addSubview:wechatFriendBtn];
    
    [wechatFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15.0);
        make.top.mas_equalTo(iPhoneXfloat);
    }];
    
    self.momentsShareCreditsTotalL = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(170), AdaptSize(5), AdaptSize(50), AdaptSize(13))];
    [self.momentsShareCreditsTotalL setTextColor:[UIColor whiteColor]];
    [self.momentsShareCreditsTotalL setText:@""];
    [self.momentsShareCreditsTotalL setHidden:YES];
    [self.momentsShareCreditsTotalL setFont:[UIFont systemFontOfSize:13.0]];
    [wechatFriendBtn addSubview:self.momentsShareCreditsTotalL];
    
    [self.momentsShareCreditsTotalL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wechatFriendBtn).offset(-15.0);
        make.top.mas_equalTo(wechatFriendBtn).offset(5.0);
    }];
    
    [self netConfigShare];
}

//获取打卡积分配置
- (void)netConfigShare{
    __weak typeof (self) weakself = self;
    [YXDataProcessCenter GET:DOMAIN_CONFIGSHARE parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            if (response.responseObject) {
                YXLog(@"%@",response.responseObject);
                NSDictionary *userShareConfigDict = [response.responseObject objectForKey:@"userShareConfig"];
                NSInteger momentsShareCredits =  [[userShareConfigDict objectForKey:@"momentsShareCredits"]longValue];
                //已经分享成功
                if (momentsShareCredits == 0) {
                    [weakself.wechatFriendBtn setImage:[UIImage imageNamed:@"分享到朋友圈"] forState:UIControlStateNormal];
                    [weakself.wechatFriendBtn setImage:[UIImage imageNamed:@"分享到朋友圈"] forState:UIControlStateSelected];
                    [weakself.momentsShareCreditsTotalL setHidden:YES];
                }
                else{
                    [weakself.wechatFriendBtn setImage:[UIImage imageNamed:@"Share提交-点击"] forState:UIControlStateNormal];
                    [weakself.wechatFriendBtn setImage:[UIImage imageNamed:@"Share提交-点击"] forState:UIControlStateSelected];
                    
                    [weakself.momentsShareCreditsTotalL setHidden:NO];
                    [weakself.momentsShareCreditsTotalL setText:[NSString stringWithFormat:@"x%ld",(long)momentsShareCredits]];
                }
                
            }
        } else {
            //请求失败
            if (response.error.type == kBADREQUEST_TYPE) {
            }
        }
    }];
}


- (void)setPunchModel:(YXPunchModel *)punchModel{
    
    _punchModel = punchModel;
    //英语谚语
    self.engLabel.text = punchModel.eng;
    NSMutableDictionary *engAttri = [NSMutableDictionary dictionary];
    [engAttri setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [engAttri setValue:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    NSString *eng = [NSString stringWithFormat:@"%@%@",self.engLabel.text,@"        "];
    
    CGFloat engHight = [eng boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60.0, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:engAttri
                                            context:nil].size.height;
    
    [self.engLabel setFrame:CGRectMake(15.0, AdaptSize(51.0), SCREEN_WIDTH-60.0, engHight)];
    
    self.chnLabel.text = punchModel.chs;
    NSMutableDictionary *chsAttri = [NSMutableDictionary dictionary];
    [chsAttri setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [chsAttri setValue:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    
    NSString *chs = [NSString stringWithFormat:@"%@%@",self.chnLabel.text,@"        "];
    CGFloat chsHight = [chs boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60.0, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:chsAttri
                                         context:nil].size.height;
    
    [self.chnLabel setFrame:CGRectMake(15.0, AdaptSize(51.0+18.0)+engHight, SCREEN_WIDTH-60.0, chsHight)];
    
    [self.sayingLabel setText:[NSString stringWithFormat:@"—— %@",punchModel.author]];
    [self.sayingLabel setFrame:CGRectMake(15.0, AdaptSize(51.0+18.0+13.0)+engHight+chsHight, SCREEN_WIDTH-60.0, AdaptSize(15.0))];
    
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:punchModel.cover]placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [self.careerLabel setText:[NSString stringWithFormat:@"\"%@\"%@",punchModel.userName,@"的生涯数据"]];
    
    self.todayWordNumLabel.text = [NSString stringWithFormat:@"%ld",(long)punchModel.todayLearned];
    
    self.careerWordNumLabel.text = punchModel.learned;
    
    [self configBtns];
}

- (void)shareResult:(YXPosterShareButton *)shareButton {
    
    [YXShareHelper shareResultToPaltform:shareButton.tag
                              punchModel:self.punchModel];
    
    //关闭分享页面
    [self cancleShare];
    
    //分享朋友圈
    __weak typeof(self) weakSelf = self;
    if (self.shareBlock){
        self.shareBlock(weakSelf);
    }
    
    NSString *way = @"";
    switch (shareButton.tag) {
        case YXShareWXSession:
            way = @"wechat";break;
        case YXShareWXTimeLine:
            way = @"moments";break;
        case YXShareQQ:
            way = @"qq";break;
        default:
            break;
    }
    NSDictionary *contentDic = @{@"way":way};
    NSDictionary *param = @{
                            @"event":@"clockSharing",
                            @"comment":[contentDic mj_JSONString]
                            };
    [YXDataProcessCenter POST:DOMAIN_SEEDSREPORT parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        
    }];
    //分享朋友圈
    if ([way isEqualToString:@"moments"]){
        [YXDataProcessCenter POST:DOMAIN_USERSHARECREDIT parameters:contentDic finshedBlock:^(YRHttpResponse *response, BOOL result) {
            YXLog(@"%@",response.responseObject);
        }];
    }
}

- (void)wxBackResponst:(NSNotification *)notify {
    [self cancleShare];
}

- (void)cancleShare {
    CGRect oriFrame = self.bottomView.frame;
    oriFrame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
        self.bottomView.frame = oriFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - share
- (UIImage *)genrateShareImage:(YXSharePalform)platForm {
    //    dispatch_async_to_globalThread(^{
    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platForm];
    UIImage *shareImage = [YXShareImageGenerator generateResultImage:self.punchModel
                                                                link:picUrl];
    return shareImage;
    //    });
}

- (NSData *)genrateShareImageData:(YXSharePalform)platForm {
    UIImage *image = [self genrateShareImage:platForm];
    return UIImageJPEGRepresentation(image, 0.8);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
