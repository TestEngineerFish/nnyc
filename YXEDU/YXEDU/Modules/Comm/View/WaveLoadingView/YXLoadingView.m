//
//  YXLoadingView.m
//  waveLoading
//
//  Created by yao on 2018/10/18.
//  Copyright © 2018年 yao. All rights reserved.
//

#import "YXLoadingView.h"
#import "YXWaveView.h"

@interface YXLoadingView ()

@property (nonatomic, weak) UIImageView *gifIV;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak)YXWaveView *waveView;
@property (nonatomic, weak)UILabel *tipsLabel;

@end

@implementation YXLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self gifIV];
        [self waveView];
        [self tipsLabel];
        [self startAnimating];
    }
    return self;
}

- (void)startAnimating {
    [self.gifIV startAnimating];
    [self.waveView startAnimating];
}

- (void)stopAnimating {
    [self.gifIV stopAnimating];
    [self.waveView stopAnimating];
}
- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self stopAnimating];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat gifIVWH = 90;
    CGFloat x = (size.width - gifIVWH) * 0.5;
    CGFloat y = (size.height - gifIVWH) * 0.5;
    self.gifIV.frame = CGRectMake(x, y, gifIVWH, gifIVWH);
    
    CGFloat tipsY = self.gifIV.bottom + 20;
    self.tipsLabel.frame = CGRectMake(0, tipsY, SCREEN_WIDTH, 20);
}

- (UIImageView *)gifIV {
    if (!_gifIV) {
        UIImageView *gifIV = [[UIImageView alloc] init];
        gifIV.animationDuration = 1;
        gifIV.animationImages = self.images;
        [self addSubview:gifIV];
        _gifIV = gifIV;
    }
    return _gifIV;
}

- (YXWaveView *)waveView {
    if (!_waveView) {
        YXWaveView *waveView = [[YXWaveView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        waveView.layer.cornerRadius = 45;
        waveView.layer.masksToBounds = YES;
        [self.gifIV addSubview:waveView];
        _waveView = waveView;
    }
    return _waveView;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        
        for (int i = 29; i >= 0; i--) {
            NSString *name = [NSString stringWithFormat:@"WaveLoadingImages/bubble-%d@2x.png",i];
            NSString *ImagePath =[[NSBundle mainBundle] pathForResource:name ofType:nil];
            
            UIImage *image = [UIImage imageWithContentsOfFile:ImagePath];
            [_images addObject:image];
        }
//        [_images addObject:_images.firstObject];
    }
    return _images;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:15];
        tipsLabel.textColor = UIColorOfHex(0x849EC5);
        tipsLabel.text = @"页面正在加载中";
        [self addSubview:tipsLabel];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}
- (void)dealloc {
    
}
@end
