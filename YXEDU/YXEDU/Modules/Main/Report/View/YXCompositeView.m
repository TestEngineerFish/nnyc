//
//  YXCompositeView.m
//  YXEDU
//
//  Created by yao on 2018/12/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCompositeView.h"

@interface YXCompositeEleView : UIView
@property (nonatomic, strong)UIImageView *leftIcon;
@property (nonatomic, strong)UIImageView *bottomIcon;
@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UILabel *scoreL;

@property (nonatomic, strong)UILabel *recomL;
@property (nonatomic, strong)UILabel *descL;

@property (nonatomic, strong)YXOverallModel *oam;
@end

@implementation YXCompositeEleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bottomIcon = [[UIImageView alloc] init];
        self.bottomIcon.image = nil;
        [self addSubview:self.bottomIcon];
        
        self.leftIcon = [[UIImageView alloc] init];
        self.leftIcon.image = nil;
        [self addSubview:self.leftIcon];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = [UIFont systemFontOfSize:AdaptSize(15)];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.textColor = [UIColor whiteColor];
        [self addSubview:self.titleL];
        
        self.scoreL = [[UILabel alloc] init];
        self.scoreL.font = [UIFont systemFontOfSize:AdaptSize(71)];
        self.scoreL.textAlignment = NSTextAlignmentCenter;
        self.scoreL.textColor = [UIColor whiteColor];
        [self addSubview:self.scoreL];
        
        self.recomL = [[UILabel alloc] init];
        self.recomL.font = [UIFont systemFontOfSize:AdaptSize(15)];
        self.recomL.textColor = [UIColor whiteColor];
        [self.bottomIcon addSubview:self.recomL];
        
        self.descL = [[UILabel alloc] init];
        self.descL.numberOfLines = 0;
        self.descL.font = [UIFont systemFontOfSize:AdaptSize(12)];
        self.descL.textColor = [UIColor whiteColor];
        [self.bottomIcon addSubview:self.descL];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat leftIconW = AdaptSize(103);
    self.leftIcon.frame = CGRectMake(0, 0,leftIconW , AdaptSize(129));
    CGFloat leftMargin = AdaptSize(15);
    self.bottomIcon.frame = CGRectMake(leftMargin, AdaptSize(20), size.width - leftMargin, AdaptSize(105));
    
    self.titleL.frame = CGRectMake(0, AdaptSize(19), leftIconW, AdaptSize(15));
    self.scoreL.frame = CGRectMake(0, self.titleL.bottom + 10, leftIconW, AdaptSize(71));
    
    
    CGFloat recomLeft = AdaptSize(96);
    CGFloat descMaxWidth = AdaptSize(196);
    self.recomL.frame = CGRectMake(recomLeft, AdaptSize(26), descMaxWidth, AdaptSize(15));
    self.descL.frame = CGRectMake(recomLeft, self.recomL.bottom + AdaptSize(13), descMaxWidth, AdaptSize(32));
}

- (void)setOam:(YXOverallModel *)oam {
    _oam = oam;
    self.scoreL.text = oam.revel;
    self.recomL.text = oam.options.firstObject;
    self.descL.text = [oam.options lastObject];
}
@end

@interface YXCompositeView ()
@property (nonatomic, strong)YXCompositeEleView *lisReaView;
@property (nonatomic, strong)YXCompositeEleView *reaWriView;
@end
@implementation YXCompositeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lisReaView = [[YXCompositeEleView alloc] init];
        self.lisReaView.titleL.text = @"听说评分";
//        self.lisReaView.scoreL.text = @"A";
//        self.lisReaView.recomL.text = @"《福尔摩斯探案故事》";
//        self.lisReaView.descL.text = @"听说第八册下册听说第八册下下册册听说第八册下册听说第八册下下册册";
        self.lisReaView.leftIcon.image = [UIImage imageNamed:@"listenReadIcon"];
        self.lisReaView.bottomIcon.image = [UIImage imageNamed:@"listenReadBGIcon"];
        [self addSubview:self.lisReaView];
        
        self.reaWriView = [[YXCompositeEleView alloc] init];
        self.reaWriView.titleL.text = @"读写评分";
//        self.reaWriView.scoreL.text = @"B";
//        self.reaWriView.recomL.text = @"《福尔摩斯探案故事》";
//        self.reaWriView.descL.text = @"读写第八册下册读写第八册下册册读写第八册下册读写第八册下册册";
        self.reaWriView.leftIcon.image = [UIImage imageNamed:@"readWriteIcon"];
        self.reaWriView.bottomIcon.image = [UIImage imageNamed:@"readWriteBGIcon"];
        [self addSubview:self.reaWriView];
    }
    return self;
}

- (void)setOverall:(NSArray *)overall {
    _overall = [overall copy];
    for (YXOverallModel *oam in overall) {
        if (oam.type == 1) { // 听说
            self.lisReaView.oam = oam;
        }else {
            self.reaWriView.oam = oam;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = AdaptSize(10);
    CGSize size = self.bounds.size;
    CGRect oriRect = CGRectMake(margin, AdaptSize(49), size.width - 2 * margin, AdaptSize(129));
    self.lisReaView.frame = oriRect;
    
    oriRect.origin.y = AdaptSize(188);
    self.reaWriView.frame = oriRect;
}

@end
