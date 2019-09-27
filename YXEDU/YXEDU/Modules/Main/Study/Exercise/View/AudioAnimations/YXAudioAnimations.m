//
//  YXAudioAnimation.m
//  YXEDU
//
//  Created by Jake To on 11/1/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXAudioAnimations.h"

@interface YXAudioAnimations ()

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger duration;

@end

@implementation YXAudioAnimations

+ (YXAudioAnimations *)playAudioAnimation {
    return [self playAudioAnimation:YES];
}

+ (YXAudioAnimations *)playAudioAnimation:(BOOL)immediately {
    YXAudioAnimations *view = [[self alloc] initWithAudioAnimationType:@"playAudio" with:1 play:immediately];
    return view;
}

+ (YXAudioAnimations *)playSpeakerAnimation {
    return [self playSpeakerAnimation:YES];
}

+ (YXAudioAnimations *)playSpeakerAnimation:(BOOL)immediately {
    YXAudioAnimations *view = [[self alloc] initWithAudioAnimationType:@"Speaker" with:1.5 play:immediately];
    view.gifImageView.image = [UIImage imageNamed:@"speaker_animate3"];
    view.gifImageView.contentMode = UIViewContentModeCenter;
    return view;
}

+ (YXAudioAnimations *)uploadAudioAnimation {
    YXAudioAnimations *view = [[self alloc] initWithAudioAnimationType:@"uploadAudio" with:1.5 play:YES];
    return view;
}

+ (YXAudioAnimations *)playRecordAnimation {
    YXAudioAnimations *view = [[self alloc] initWithAudioAnimationType:@"audioFrequency" with:0.95 play:NO];
    return view;
}
- (instancetype)initWithAudioAnimationType:(NSString *)type with:(NSInteger)duration play:(BOOL)immediately{
    if (self = [super init]) {
        self.type = type;
        self.duration = duration;
        
        self.backgroundColor = [UIColor whiteColor]; // 不接受事件
        [self gifImageView];
        if (immediately) {
            [self startAnimating];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)startAnimating {
    self.userInteractionEnabled = NO;
    [self.gifImageView startAnimating];
}

- (void)stopAnimating {
    self.userInteractionEnabled = YES;
    [self.gifImageView stopAnimating];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self stopAnimating];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gifImageView.frame = self.bounds;
}

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        UIImageView *gifImageView = [[UIImageView alloc] init];
        gifImageView.animationDuration = self.duration;
        gifImageView.image = self.images.firstObject;
        gifImageView.animationImages = self.images;
        gifImageView.userInteractionEnabled = NO;
        [self addSubview:gifImageView];
        _gifImageView = gifImageView;
    }
    return _gifImageView;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        
        if ([self.type isEqualToString:@"playAudio"]) {
            for (int i = 1; i <= 14; i++) {
                NSString *name = [NSString stringWithFormat:@"playAudio%d.png",i];
                UIImage *image = [UIImage imageNamed:name];
                [_images addObject:image];
            }
        } else if ([self.type isEqualToString:@"uploadAudio"]) {
            for (int i = 1; i <= 33; i++) {
                NSString *name = [NSString stringWithFormat:@"uploadAudio%d.png",i];
                UIImage *image = [UIImage imageNamed:name];
                [_images addObject:image];
            }
        }else if ([self.type isEqualToString:@"Speaker"]) {
            [_images addObject:[UIImage imageNamed:@"speaker_animate3"]];
            for (int i = 1; i <= 3; i++) {
                NSString *name = [NSString stringWithFormat:@"speaker_animate%d",i];
                UIImage *image = [UIImage imageNamed:name];
                [_images addObject:image];
            }
        }else if ([self.type isEqualToString:@"audioFrequency"]) {
            for (int i = 1; i <= 5; i++) {
                NSString *name = [NSString stringWithFormat:@"audioFrequency%d",i];
                UIImage *image = [UIImage imageNamed:name];
                [_images addObject:image];
            }
            
            [_images addObjectsFromArray:_images];
        }
    }
    return _images;
}

@end
