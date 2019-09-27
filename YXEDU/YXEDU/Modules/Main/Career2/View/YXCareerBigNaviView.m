//
//  YXCareerBigNaviView.m
//  YXEDU
//
//  Created by yixue on 2019/2/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerBigNaviView.h"
#import "LGYSegmentView.h"
#import "YXCareerViewController.h"

@interface YXCareerBigNaviView ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIView *naviView;//without statusbar
@property (nonatomic, strong) UIButton *naviBackBtn;
@property (nonatomic, strong) UIButton *naviTitleBtn;

//@property (nonatomic, strong) LGYSegmentView *segmentView;

@end

@implementation YXCareerBigNaviView

- (id)initWithPosition:(CGPoint)position {
    self = [super initWithFrame:CGRectMake(position.x, position.y, SCREEN_WIDTH, kNavHeight + 30)];
    if(self != nil){
        [self setupBackImageView];
        [self setupNaviView];
        [self setupSegmentView];
    }
    return self;
}

- (void)setCareerModel:(YXCareerModel *)careerModel {
    _careerModel = careerModel;
    //naviTitleBtn
    [_naviTitleBtn setTitle:_careerModel.bookName forState:UIControlStateNormal];
    [_naviTitleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_naviTitleBtn.imageView.image.size.width,
                                                       0, _naviTitleBtn.imageView.image.size.width)];
    [_naviTitleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _naviTitleBtn.titleLabel.bounds.size.width + 5,
                                                       0, -_naviTitleBtn.titleLabel.bounds.size.width - 5)];
    //
    [_segmentView removeFromSuperview];
    [self setupSegmentView];
}

- (void)setupBackImageView {
    _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_top_nav_ipx"]];
    _backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight + 30);
    _backImageView.userInteractionEnabled = YES;
    [self addSubview:_backImageView];
}

- (void)setupNaviView { //without statusbar
    _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    _naviView.backgroundColor = [UIColor clearColor];
    [self addSubview:_naviView];
    
    _naviBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    [_naviBackBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [_naviView addSubview:_naviBackBtn];
    [_naviBackBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _naviTitleBtn = [[UIButton alloc] initWithFrame:CGRectMake(_naviView.centerX-110, 10, 220, 24)];
    [_naviTitleBtn setImage:[UIImage imageNamed:@"career_spread"] forState:UIControlStateNormal];
    [_naviTitleBtn setTitle:_careerModel.bookName forState:UIControlStateNormal];
    _naviTitleBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:20];
    [_naviTitleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_naviTitleBtn.imageView.image.size.width,
                                                       0, _naviTitleBtn.imageView.image.size.width)];
    [_naviTitleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _naviTitleBtn.titleLabel.bounds.size.width + 5,
                                                       0, -_naviTitleBtn.titleLabel.bounds.size.width - 5)];
    [_naviView addSubview:_naviTitleBtn];
    [_naviTitleBtn addTarget:self action:@selector(titleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSegmentView {
    _segmentView = [LGYSegmentView segmentViewWithTitles:_careerModel.itemTitles withDelegate:self.delegate];
    _segmentView.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, 30);
    _segmentView.titleSelectedEnlageScale = 0.1;
    _segmentView.segmentTitleFont = [UIFont systemFontOfSize:17];
    _segmentView.indicatorVHeight = 3;
    _segmentView.indicatorVColor = [UIColor whiteColor];
    //segmentTitleView.segmentSelectedColor = [UIColor hcRedColor];
    _segmentView.segmentNormalColor = [UIColor whiteColor];
    _segmentView.intrinsicContentSize = CGSizeMake(240, 44);
    [self addSubview:_segmentView];
}

- (void)titleBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(careerBigNaviViewDidClickedTitle:)]) {
        [self.delegate careerBigNaviViewDidClickedTitle:self];
    }
}

- (void)backBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(careerBigNaviViewDidClickedBack:)]) {
        [self.delegate careerBigNaviViewDidClickedBack:self];
    }
}

@end
