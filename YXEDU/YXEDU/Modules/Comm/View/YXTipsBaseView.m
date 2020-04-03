//
//  YXTipsBaseView.m
//  YXEDU
//
//  Created by yao on 2018/11/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXTipsBaseView.h"
@interface YXTipsBaseView ()
@property (nonatomic, copy)YXTouchBlock touchBlock;
@end
@implementation YXTipsBaseView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
//        [self addGestureRecognizer:tap];
        
        UIButton *tapButton = [[UIButton alloc] init];
        [tapButton addTarget:self action:@selector(tapView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tapButton];
  
        UIImageView *tipsImageView = [[UIImageView alloc] init];
        tipsImageView.userInteractionEnabled = NO;
        tipsImageView.image = [UIImage imageNamed:@"blankPage"];
        tipsImageView.contentMode = UIViewContentModeScaleAspectFit;
        [tapButton addSubview:tipsImageView];
        self.tipsImageView = tipsImageView;
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.userInteractionEnabled = NO;
        tipsLabel.numberOfLines = 0;
        tipsLabel.font = [UIFont systemFontOfSize:15];
        tipsLabel.textColor = UIColorOfHex(0x849EC5);
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [tapButton addSubview:tipsLabel];
        self.tipsLabel = tipsLabel;
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipsImageView.mas_bottom).offset(20);
            make.centerX.equalTo(tapButton);
        }];
        
        self.tapButton = tapButton;
        [tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.top.left.right.equalTo(tipsImageView);
            make.bottom.equalTo(tipsLabel);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

//+(YXTipsBaseView *)showTipsToView:(UIView *)view
//                            image:(UIImage *)image
//                   imageTopMargin:(CGFloat)topMargin
//                             tips:(NSString *)tips
//                       touchBlock:(YXTouchBlock)touchBlock

+ (YXTipsBaseView *)showTipsToView:(UIView *)view image:(UIImage *)image tips:(NSString *)tips contentOffsetY:(CGFloat)offsetY touchBlock:(YXTouchBlock)touchBlock {
    YXTipsBaseView *tipsView = [[YXTipsBaseView alloc] initWithFrame:view.bounds];
    tipsView.tipsImageView.image = image;
    tipsView.tipsLabel.text = tips;
    CGSize size = image.size;
    if (size.width > SCREEN_WIDTH) {
        size.width = 1.0 * size.height * SCREEN_WIDTH / size.width;
    }
    
    offsetY = offsetY ? offsetY : (tips ? -40 : -30);
    [tipsView.tapButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsView).offset(offsetY);
    }];
    
    [tipsView.tipsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];

    if (touchBlock) {
        tipsView.touchBlock = [touchBlock copy];
    }
    
    [view addSubview:tipsView];
    return tipsView;
}

+ (YXTipsBaseView *)showTipsToView:(UIView *)view
                             image:(UIImage *)image
                              tips:(NSString *)tips
                        touchBlock:(YXTouchBlock)touchBlock
{
    return [self showTipsToView:view image:image tips:tips contentOffsetY:0 touchBlock:touchBlock];
}

- (void)tapView {
    if (self.touchBlock) {
        self.touchBlock();
    }
}
@end
