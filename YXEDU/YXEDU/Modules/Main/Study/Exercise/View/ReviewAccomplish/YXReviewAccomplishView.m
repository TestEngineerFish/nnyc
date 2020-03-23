//
//  YXReviewAccomplishView.m
//  YXEDU
//
//  Created by jukai on 2019/4/23.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXReviewAccomplishView.h"

@interface YXReviewAccomplishView()

@end

@implementation YXReviewAccomplishView

+ (YXReviewAccomplishView *)reviewAccomplishShowToView:(UIView *)view delegate:(id<YXReviewAccomplishViewDelegate>)delegate totalQuestionsCount:(NSInteger)totalQuestionsCount {
    YXReviewAccomplishView *accomplishView = [[YXReviewAccomplishView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    accomplishView.delegate = delegate;
    accomplishView.totalQuestionsCount = totalQuestionsCount;
    
    [view addSubview:accomplishView];
    return accomplishView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:frame];
        [bgImgView setImage:[UIImage imageNamed:@"ReviewAccomplish背景"]];
        [self addSubview:bgImgView];
        
    }
    return self;
}

-(void)setTotalQuestionsCount:(NSInteger)totalQuestionsCount{
    _totalQuestionsCount = totalQuestionsCount;
    [self configViews];
}

-(void)configViews{
    
    UIImageView *songshuBGView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(57.0), AdaptSize(kStatusBarHeight +238.0), AdaptSize(529*0.5), AdaptSize(221*0.5))];
    
    [songshuBGView setImage:[UIImage imageNamed:@"ReviewAccomplish框"]];
    
    [self addSubview:songshuBGView];
    
    UILabel *noteLabel01 = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(62.0), AdaptSize( 46.0), AdaptSize(190.0), AdaptSize(25.0))];
    [noteLabel01 setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 16]];
    [noteLabel01 setTextColor: UIColorOfHex(0x434A5D)];
    noteLabel01.text = [NSString stringWithFormat:@"完成了%zd个单词的复习！",_totalQuestionsCount];
    [songshuBGView addSubview:noteLabel01];
    
    UILabel *noteLabel02 = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(62.0), AdaptSize( 76.0), AdaptSize(190.0), AdaptSize(25.0))];
    [noteLabel02 setTextColor: UIColorOfHex(0x434A5D)];
    [noteLabel02 setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 14]];
    noteLabel02.text = @"快开始今天的学习吧！";
    [songshuBGView addSubview:noteLabel02];
//    noteLabel02.centerX = songshuBGView.centerX;
    
    [self addSubview:self.goOnBtn];
    
}

- (UIButton *)goOnBtn {
    if (!_goOnBtn) {
        
        UIButton *goOnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AdaptSize(239.0), AdaptSize(61.0))];
        goOnBtn.centerX = self.centerX;
        [goOnBtn setTop:AdaptSize(kStatusBarHeight+556.0)];
        
        [goOnBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_hight"] forState:UIControlStateNormal];
        [goOnBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_hight"] forState:UIControlStateSelected];
        [goOnBtn setTitle:@"继 续" forState:UIControlStateNormal];
        [goOnBtn setTitle:@"继 续" forState:UIControlStateSelected];
        [goOnBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        [goOnBtn setTitleColor:UIColorOfHex(0xFBFDFF) forState:UIControlStateNormal];
        [goOnBtn setTitleColor:UIColorOfHex(0xFBFDFF) forState:UIControlStateSelected];
        [goOnBtn addTarget:self action:@selector(goOnBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [goOnBtn setTitleEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
        
        _goOnBtn = goOnBtn;
    }
    return _goOnBtn;
}

-(void) goOnBtnAction{
    YXLog(@"goOnBtnAction");
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(reviewAccomplishViewBtn)]) {
        [self.delegate reviewAccomplishViewBtn];
    }
}



@end
