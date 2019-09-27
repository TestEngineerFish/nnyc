//
//  YXWordListGuideView.m
//  YXEDU
//
//  Created by yao on 2019/3/4.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXWordListGuideView.h"
#import "YXSelectMyWordCell.h"
@interface YXWordListGuideView ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>
@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UILabel *knowLabel;
@property (nonatomic, weak) UITableView *contentView;
@property (nonatomic, weak) UIImageView *guideArrow;
@property (nonatomic, weak) UIImageView *guideGes;
@property (nonatomic, assign) NSInteger index;
@end

@implementation YXWordListGuideView
{
    NSTimer *timer;
}


+ (instancetype)WordListGuideViewShowToView:(UIView *)view {
    YXWordListGuideView *giudeView = [[self alloc] initWithFrame:view.bounds];
    [view addSubview:giudeView];
    [giudeView layoutIfNeeded];
    [giudeView.contentView reloadData];
    [giudeView startTimer];
    return giudeView;
}

- (void)startTimer {
    [self cancleTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(doAnimate) userInfo:nil repeats:YES];
}

- (void)doAnimate {
    if (self.index <= 3) {
        if (self.index == 0) {
            CGRect oriFrame = self.guideGes.frame;
            oriFrame.origin.y = AdaptSize(9) + 3 * AdaptSize(49);
            [UIView animateWithDuration:1.2 animations:^{
                self.guideGes.frame = oriFrame;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.guideGes.frame = CGRectMake(AdaptSize(7), AdaptSize(9), AdaptSize(60), AdaptSize(44));
                    for (NSInteger i = 1 ;i <=3; i++) {
                        YXSelectMyWordCell *cell = [self.contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        cell.manageBtn.selected = NO;
                    }
                });
            }];
        }
        YXSelectMyWordCell *cell = [self.contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]];
        cell.manageBtn.selected = YES;
        self.index ++;
    }else {
        self.index = 0;

    }

}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat margin = AdaptSize(15);
        self.maskView.alpha = 0.7;
        self.index = 0;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-AdaptSize(30));
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH - 2 * margin, AdaptSize(200)));
        }];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.contentView.mas_top).offset(-margin);
        }];
        
        [self.knowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.contentView.mas_bottom).offset(AdaptSize(20));
            make.size.mas_equalTo(MakeAdaptCGSize(165, 38));
        }];
        
        UIImageView *guideArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideArrow"]];
        [self.contentView addSubview:guideArrow];
        [guideArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(AdaptSize(10));
            make.size.mas_equalTo(MakeAdaptCGSize(20, 49));
        }];
        
        UIImageView *guideGes = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideGesIcon"]];
        [self.contentView addSubview:guideGes];
        _guideGes = guideGes;
        
        self.guideGes.frame = CGRectMake(AdaptSize(7), AdaptSize(9), AdaptSize(60), AdaptSize(44));
    }
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXSelectMyWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.wordL.text = @"morning";
    cell.explanationL.text = @"n.早晨";
    cell.descLabel.text = @"未学";
//    cell.manageBtn.selected = (indexPath.row == 1);
    return cell;
}

- (void)maskViewWasTapped {
    [super maskViewWasTapped];
    [self cancleTimer];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kWordListGuideViewShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeFromSuperview];
}

- (void)cancleTimer {
    [timer invalidate];
    timer = nil;
}


- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"手指滑动，快速选中单词";
        tipsLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(20)];
        tipsLabel.textColor = UIColorOfHex(0xFEFEFF);
        tipsLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tipsLabel];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

- (UILabel *)knowLabel {
    if (!_knowLabel) {
        UILabel *knowLabel = [[UILabel alloc] init];
        knowLabel.text = @"我知道了";
        knowLabel.textAlignment = NSTextAlignmentCenter;
        knowLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        knowLabel.layer.borderColor = UIColorOfHex(0xFEFEFF).CGColor;
        knowLabel.layer.borderWidth = 1.0;
        knowLabel.layer.cornerRadius = AdaptSize(19);
        knowLabel.textColor = UIColorOfHex(0xFEFEFF);
        knowLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:knowLabel];
        _knowLabel = knowLabel;
    }
    return _knowLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        UITableView *contentView = [[UITableView alloc] init];
        contentView.scrollEnabled = NO;
        contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentView.rowHeight = AdaptSize(49);
        contentView.delegate = self;
        contentView.dataSource = self;
        [contentView registerClass:[YXSelectMyWordCell class] forCellReuseIdentifier:@"cell"];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = AdaptSize(8);
        contentView.backgroundColor = UIColorOfHex(0xFEFEFF);
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}
@end
