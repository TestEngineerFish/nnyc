//
//  YXMissionToReceiveView.m
//  YXEDU
//
//  Created by 吉乞悠 on 2019/1/1.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXMissionToReceiveView.h"

@interface CompletedMissionCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *img;

@end

@implementation CompletedMissionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *icon = [[UIImageView alloc] init];
        icon.frame = CGRectMake(AdaptSize(5), AdaptSize(3), AdaptSize(15), AdaptSize(15));
        icon.image = [UIImage imageNamed:@"Mission_mark"];
        [self.contentView addSubview:icon];
        
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(AdaptSize(30), AdaptSize(0), AdaptSize(120), AdaptSize(20));
        [self.contentView addSubview:title];
        title.font = [UIFont pfSCMediumFontWithSize:AdaptSize(13)];
        title.textColor = [UIColorOfHex(0x2B8AEE) colorWithAlphaComponent:0.86];
        _title = title;
        
    }
    return self;
}

@end





//领取积分页面
@interface YXMissionToReceiveView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *missionTableView;
@property (nonatomic, strong) UILabel *ratio;

@end

@implementation YXMissionToReceiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setCompletedTaskModelAry:(NSArray *)completedTaskModelAry {
    _completedTaskModelAry = completedTaskModelAry;
    [self.missionTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [_missionTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:completedTaskModelAry.count - 1 inSection:0]
                                 atScrollPosition:UITableViewScrollPositionBottom
                                         animated:YES];
    });
    NSInteger credits = 0;
    for (YXTaskModel *model in completedTaskModelAry) {
        credits += model.credits;
    }
    NSString *str = [NSString stringWithFormat:@"X %zd",credits];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont pfSCMediumFontWithSize:AdaptSize(24)],NSForegroundColorAttributeName: UIColorOfHex(0x2B8AEE)}];
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(13)]} range:NSMakeRange(0, 2)];
    //[string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(24)]} range:NSMakeRange(2, 2)];
    _ratio.attributedText = string;
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    UIImageView *alertView = [[UIImageView alloc] init];
    alertView.frame = CGRectMake(0, SCREEN_HEIGHT/2-AdaptSize(250), AdaptSize(375), AdaptSize(490));
    alertView.image = [UIImage imageNamed:@"Mission_toReceive"];
    [alertView setUserInteractionEnabled:YES];
    [self addSubview:alertView];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(AdaptSize(110), AdaptSize(300), AdaptSize(155), AdaptSize(56));
    [btn setImage:[UIImage imageNamed:@"立即领取"] forState:UIControlStateNormal];
    [alertView addSubview:btn];
    _toCheckBtn = btn;
    [_toCheckBtn addTarget:self action:@selector(receiveCredits) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *douzi = [[UIImageView alloc] init];
    douzi.frame = CGRectMake(AdaptSize(124), AdaptSize(240), AdaptSize(68), AdaptSize(46));
    douzi.image = [UIImage imageNamed:@"Mission_douzi"];
    [alertView addSubview:douzi];
    _douzi = douzi;
    
    UILabel *ratio = [[UILabel alloc] init];
    ratio.frame = CGRectMake(AdaptSize(190),AdaptSize(250),AdaptSize(100),AdaptSize(24));
    ratio.textAlignment = NSTextAlignmentLeft;
    ratio.numberOfLines = 0;
    [alertView addSubview:ratio];
    _ratio = ratio;

    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH/2-AdaptSize(17), SCREEN_HEIGHT/2+AdaptSize(170), AdaptSize(34), AdaptSize(34));
    [closeBtn setImage:[UIImage imageNamed:@"Mission_closeBtn"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTableView];
}

- (void)setupTableView{
    _missionTableView = [[UITableView alloc] init];
    CGFloat width = AdaptSize(150);
    CGFloat height = AdaptSize(50);
    _missionTableView.frame = CGRectMake(0, 0, width, height);
    _missionTableView.center =  CGPointMake(self.centerX, self.centerY - AdaptSize(40));
    
    _missionTableView.delegate = self;
    _missionTableView.dataSource = self;
    
    _missionTableView.bounces = false;
    _missionTableView.showsVerticalScrollIndicator = false;
    _missionTableView.rowHeight = AdaptSize(20);
    _missionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_missionTableView registerClass:[CompletedMissionCell class] forCellReuseIdentifier:@"cell"];
    
    [self addSubview:_missionTableView];
    
    UIImageView *tableCoverImage = [[UIImageView alloc] init];
    CGFloat coverHeight = AdaptSize(20);
    tableCoverImage.frame = CGRectMake(_missionTableView.left, _missionTableView.bottom - coverHeight, width, coverHeight);
    tableCoverImage.image = [UIImage imageNamed:@"taskAlertCoverImage"];
    [self addSubview:tableCoverImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _completedTaskModelAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompletedMissionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    YXTaskModel *model = _completedTaskModelAry[indexPath.row];
    //cell.backgroundColor = [UIColor orangeColor];
    cell.title.text = model.name;
    return cell;
}

- (void)receiveCredits {
    //截止重复点击
    _toCheckBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _toCheckBtn.enabled = YES;
    });
    
    if (self.getAllCreditsBlock) {
        __weak typeof(self) weakself = self;
        self.getAllCreditsBlock(weakself.completedTaskModelAry);
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
