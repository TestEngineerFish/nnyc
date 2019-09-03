//
//  YXNOSignalVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXNOSignalVC.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "YXMediator.h"
#import "NetWorkRechable.h"
#import "YXCommHeader.h"

@interface YXNOSignalView ()
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *centerImage;
@property (nonatomic, strong) UIView *labeView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *reloadBtn;
@end

@implementation YXNOSignalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorOfHex(0xffffff);
        self.topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 16+NavHeight, SCREEN_WIDTH, 520*SCREEN_WIDTH/616.0)];
        self.topImage.image = [UIImage imageNamed:@"nosignal_404"];
        [self addSubview:self.topImage];
        
        self.labeView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.labeView];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.font = [UIFont boldSystemFontOfSize:18];
        self.nameLab.textColor = UIColorOfHex(0x999999);
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.text = @"找不到信号了";
        [self.labeView addSubview:self.nameLab];
        
        self.reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reloadBtn setFrame:CGRectZero];
        [self.reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [self.reloadBtn setTitleColor:UIColorOfHex(0x1CB0F6) forState:UIControlStateNormal];
        [self.reloadBtn setBackgroundColor:[UIColor clearColor]];
        [self.reloadBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [self.reloadBtn addTarget:self action:@selector(reloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.labeView addSubview:self.reloadBtn];
        
        CGFloat tipWidth = [self.nameLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.nameLab.font].width;
        CGFloat policyWidth = [self.reloadBtn.titleLabel.text sizeWithMaxWidth:SCREEN_WIDTH font:self.reloadBtn.titleLabel.font].width;
        self.labeView.frame = CGRectMake((SCREEN_WIDTH - policyWidth-tipWidth)/2.0, CGRectGetMaxY(self.topImage.frame) + 50, policyWidth+tipWidth, 20);
        self.nameLab.frame = CGRectMake(0, 0, tipWidth, 20);
        self.reloadBtn.frame = CGRectMake(18+tipWidth, 0, policyWidth, 20);
    }
    return self;
}

- (void)reloadBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadBtnClicked:)]) {
        [self.delegate reloadBtnClicked:sender];
    }
}

@end

@interface YXNOSignalVC () <YXNOSignalViewDelegate>

@end

@implementation YXNOSignalVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.coverAll = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -YXNOSignalViewDelegate-
- (void)reloadBtnClicked:(id)sender {
    [self refreshBtnClicked];
}

- (void)reloadNoSignalView {
    switch ([NetWorkRechable shared].netWorkStatus) {
        case NetWorkStatusUnknown: {
            
        }
            break;
        case NetWorkStatusNotReachable: {
            [self noSignalView];
        }
            break;
        case NetWorkStatusReachableViaWWAN: {
            RELEASE(_noSignalView);
        }
            break;
        case NetWorkStatusReachableViaWiFi: {
            RELEASE(_noSignalView);
        }
            break;
        default:
            break;
    }
}

- (void)refreshBtnClicked {
    [self reloadNoSignalView];
}

- (YXNOSignalView *)noSignalView {
    if (!_noSignalView) {
        _noSignalView = [[YXNOSignalView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_noSignalView setDelegate:self];
        if (self.coverAll) {
            [[UIApplication sharedApplication].keyWindow addSubview:_noSignalView];
        } else {
            [self.view addSubview:_noSignalView];
        }
        
    }
    return _noSignalView;
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
