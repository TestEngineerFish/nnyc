//
//  YXRemotePlayer.m
//  YXEDU
//
//  Created by yao on 2018/11/19.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRemotePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface YXRemotePlayer ()
@property (nonatomic , strong) AVPlayer *player;
//@property (nonatomic, copy) void (^playFinishBlock)(BOOL);
@property (nonatomic, weak)AVPlayerItem *songItem;
@end
@implementation YXRemotePlayer

- (instancetype)initWithPlayUrl:(NSURL *)url {
    if (self = [super init]) {
        AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
        self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        self.player.volume = 1.0;
    }
    return self;
}

- (void)startPlay:(NSURL *)url {
    [self startPlay:url finish:nil];
}

- (void)startPlay:(NSURL *)url finish:(void (^)(BOOL))playFinishBlock {
//    YXLog(@"sound url -> %@\n>>>Extension -> %@",url,[url pathExtension]);
    // 开始新的播放链接之前停止旧的
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
    self.player.volume = 1.0;
    if (playFinishBlock) {
        self.playFinishBlock = playFinishBlock;
        self.songItem = songItem;
        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [self.player play];
}

- (void)setPlayFinishBlock:(void (^)(BOOL))playFinishBlock {
    if (self.playFinishBlock) {
        [kNotificationCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    _playFinishBlock = playFinishBlock;
    
    if (playFinishBlock) {
        [kNotificationCenter addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString: @"status"]) {
        if (self.player.status != AVPlayerStatusReadyToPlay) { // 播放器加载失败
            if (self.playFinishBlock) {
                self.playFinishBlock(YES);
            }
        }else {
            [self.player play];
        }
    }
    
//    AVPlayerItemStatusUnknown:     YXLog(@"未知资源");
}

- (void)playEnd:(NSNotification *)notify {
    [self.player seekToTime:kCMTimeZero];
    
    if (self.playFinishBlock) {
        self.playFinishBlock(YES);
    }
}

- (void)pause {
    [self.player pause];
}

- (void)resetToPlay {
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
}

- (void)play {
    [self.player play];
}

- (void)releaseSource {
    [kNotificationCenter removeObserver:self];
    if (self.songItem) {
        [self.songItem removeObserver:self forKeyPath:@"status"];
        self.songItem = nil;
    }
    self.player = nil;
    self.playFinishBlock = nil;
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}
@end
