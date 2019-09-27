//
//  YXMissionCollectionViewCell.m
//  YXEDU
//
//  Created by yixue on 2018/12/27.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXMissionCollectionViewCell.h"

@interface YXMissionCollectionViewCell ()

@property (nonatomic, strong) UIImageView *cellBg;
@property (nonatomic, strong) UIView *titleBg;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *credits;
@property (nonatomic, strong) UILabel *times;
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIButton *centerImgBtn;
@property (nonatomic, assign) NSInteger count;

@end

@implementation YXMissionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setModel:(YXTaskModel *)model {
    _model = model;
    //_model.state = 1;
    
    UIColor *targetColor = [UIColor hexStringToColor:model.color];

    if (_model.state == 0) { //未完成
        [_cellBg sd_setImageWithURL:[NSURL URLWithString:_model.notGainImg] placeholderImage:[UIImage imageNamed:@"Mission_Card_Blue"]];
        [_cellBg addSubview:_centerBtn];
        [_centerBtn setHidden:NO];
        _centerImgBox.hidden = YES;
        _centerImgBtn.hidden = YES;
    } else if (_model.state == 1) { //完成未领取
        [_cellBg sd_setImageWithURL:[NSURL URLWithString:_model.notGainImg] placeholderImage:[UIImage imageNamed:@"Mission_Card_Blue"]];
        [_cellBg insertSubview:_centerImgBtn belowSubview:_titleBg];
        [_centerBtn setHidden:YES];
        _centerImgBtn.hidden = NO;
        _centerImgBox.hidden = NO;
    } else if (_model.state == 2) { //完成领取
        [_cellBg sd_setImageWithURL:[NSURL URLWithString:_model.gainImg] placeholderImage:[UIImage imageNamed:@"Mission_Card_Blue"]];
        targetColor = [UIColor hexStringToColor:@"#647681"];
        [_centerBtn setHidden:YES];
        _centerImgBtn.hidden = YES;
        _centerImgBox.hidden = YES;
    }
    _title.text = model.name;
    _title.shadowColor = targetColor;
    _titleBg.backgroundColor = targetColor;
    _credits.shadowColor = targetColor;
    _credits.text = [NSString stringWithFormat:@"积分：+%zd",model.credits];
    _times.shadowColor = targetColor;
    _times.text = model.timeStr;
    _centerBtn.layer.shadowColor = targetColor.CGColor;
    [_centerBtn setTitleColor:targetColor forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
}

- (void)setupUI {
    _cellBg = [[UIImageView alloc] init];
    _cellBg.frame = CGRectMake(0, 0, self.width, self.height);
    _cellBg.userInteractionEnabled = YES;
    [self addSubview:_cellBg];
    
    _title = [[UILabel alloc] init];
    _title.text = @"完成今日学习计划";
//    _title.frame = CGRectMake(AdaptSize(8), AdaptSize(15), AdaptSize(121), AdaptSize(25));
    _title.font = [UIFont pfSCMediumFontWithSize:AdaptSize(14)];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = [UIColor whiteColor];
    _title.shadowColor = UIColorOfHex(0x3774ED);
    _title.shadowOffset = CGSizeMake(0, 1);
    _title.numberOfLines = 0;
    [_cellBg addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AdaptSize(8));
        make.right.equalTo(self.contentView).offset(-AdaptSize(8));
        make.top.equalTo(self.contentView).offset(AdaptSize(15));
    }];
    
    _titleBg = [[UIView alloc] init];
    _titleBg.alpha = 0.3;
    [_cellBg insertSubview:_titleBg belowSubview:_title];
    [_titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AdaptSize(1.5));
        make.right.equalTo(self.contentView).offset(-AdaptSize(1.5));
        make.top.equalTo(_title).offset(-AdaptSize(5));
        make.bottom.equalTo(_title).offset(AdaptSize(5));
    }];
    
    _credits = [[UILabel alloc] init];
    _credits.frame = CGRectMake(AdaptSize(30), AdaptSize(130), AdaptSize(90), AdaptSize(14));
    _credits.text = @"积分：+30";
    _credits.font = [UIFont systemFontOfSize:12];
    _credits.textAlignment = NSTextAlignmentLeft;
    _credits.textColor = [UIColor whiteColor];
    _credits.shadowColor = UIColorOfHex(0x3774ED);
    _credits.shadowOffset = CGSizeMake(0, 1);
    [_cellBg addSubview:_credits];
    
    _times = [[UILabel alloc] init];
    _times.frame = CGRectMake(AdaptSize(30), AdaptSize(153), AdaptSize(90), AdaptSize(14));
    _times.text = @"今天";
    _times.font = [UIFont systemFontOfSize:12];
    _times.textAlignment = NSTextAlignmentLeft;
    _times.textColor = [UIColor whiteColor];
    _times.shadowColor = UIColorOfHex(0x3774ED);
    _times.shadowOffset = CGSizeMake(0, 1);
    [_cellBg addSubview:_times];
    
    _centerBtn = [[UIButton alloc] init];
    _centerBtn.frame = CGRectMake(AdaptSize(22), AdaptSize(70), AdaptSize(92), AdaptSize(30));
    _centerBtn.backgroundColor = [UIColor whiteColor];
    _centerBtn.layer.cornerRadius = AdaptSize(15);
    //    [_centerBtn setImage:[UIImage imageNamed:@"Mission_Card_ToDo_Blue"] forState:UIControlStateNormal];
    [_centerBtn setTitle:@"去完成" forState:UIControlStateNormal];
    [_centerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _centerBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(13)];
    _centerBtn.layer.shadowColor = UIColorOfHex(0x3774ED).CGColor;
    _centerBtn.layer.shadowOffset = CGSizeMake(0, 1);
    _centerBtn.layer.shadowOpacity = 0.5;
    _centerBtn.layer.shadowRadius = 3;
    [_centerBtn addTarget:self action:@selector(transferTo) forControlEvents:UIControlEventTouchUpInside];
    //[_cellBg addSubview:_centerBtn];
    
    _centerImgBtn = [[UIButton alloc] init];
    _centerImgBtn.frame = CGRectMake(AdaptSize(21), AdaptSize(30), AdaptSize(94), AdaptSize(95));
    [_centerImgBtn setImage:[UIImage imageNamed:@"Mission_Card_Boxbg"] forState:UIControlStateNormal];
    [_centerImgBtn addTarget:self action:@selector(getNextTask) forControlEvents:UIControlEventTouchUpInside];
    //[_cellBg insertSubview:_centerImgBtn belowSubview:_titleBg];
    
    _centerImgBox = [[UIImageView alloc] init];
    _centerImgBox.frame = CGRectMake(AdaptSize(24), AdaptSize(32), AdaptSize(46), AdaptSize(46));
    _centerImgBox.image = [UIImage imageNamed:@"Mission_Card_Boxbox"];
    //[_centerImgBox setUserInteractionEnabled:YES];
    [_centerImgBtn addSubview:_centerImgBox];
    
    // 弹框动画有必要时添加
    CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animater.values = @[@0,@(-M_PI/7),@0,@(M_PI/7),@0,@(-M_PI/9),@0,@(M_PI/9),@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    animater.duration = 3.2;
    animater.repeatCount = MAXFLOAT;
    animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [_centerImgBox.layer addAnimation:animater forKey:@""];
}

- (void)transferTo {
    if ([self.delegate respondsToSelector:@selector(missionCollectionViewCellTransferTo:)]) {
        [self.delegate missionCollectionViewCellTransferTo:self];
    }
}

- (void)getNextTask {
    
    [UIView animateWithDuration:1.0 animations:^{
        [self centerImgBoxAnimate];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(missionCollectionViewCellGetNextTask:)]) {
            [self.delegate missionCollectionViewCellGetNextTask:self];
        }
    }];
}

//任务中心 领取积分动画
- (void)centerImgBoxAnimate
{
    // y方向平移
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    // 平移100
    animation1.toValue = @(-100);
    
    // 绕Z轴中心旋转
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 起始角度
    animation2.fromValue = [NSNumber numberWithFloat:0.0];
    // 终止角度
    animation2.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
    // 比例缩放
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 终止scale
    animation3.toValue = @(0.2);
    
    // 动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    // n秒后执行
    group.beginTime = CACurrentMediaTime();
    // 持续时间
    group.duration = 1.2;
    // 重复次数
    group.repeatCount = 1;
    // 动画结束是否恢复原状
    group.removedOnCompletion = NO;
    // 动画组
    group.animations = [NSArray arrayWithObjects:animation1, animation2, animation3, nil];
    // 添加动画
    [_centerImgBox.layer addAnimation:group forKey:@"group"];
}



@end
