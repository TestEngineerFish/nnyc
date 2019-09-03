//
//  AVPlayerManger.m
//  YXEDU
//
//  Created by shiji on 2018/3/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "AVAudioPlayerManger.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


#pragma mark -AVAudioPlayerLocal-
@interface AVAudioPlayerLocal () <AVAudioPlayerDelegate>
@property (nonatomic , strong) AVAudioPlayer *player;
@end
@implementation AVAudioPlayerLocal
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startPlay:(NSURL *)url {
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
    self.player.delegate = self;
    [self.player prepareToPlay];
    [self.player play];
}

- (void)pauseOrPlay {
    if ([self.player isPlaying]) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

- (void)stop {
    [self.player stop];
}


#pragma mark -AVAudioPlayerDelegate-
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

@end


#pragma mark -AVPlayerRemote-
@interface AVPlayerRemote ()
@property (nonatomic , strong) AVPlayer *player;
@end
@implementation AVPlayerRemote
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startPlay:(NSURL *)url {
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [self.player play];
}

- (void)pause {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player pause];
    }
}

- (void)play {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player play];
    }
}

@end


#pragma mark -AVAudioPlayerManger-
@interface AVAudioPlayerManger ()

@property (nonatomic , strong) AVAudioPlayerLocal *localPlayer;

@property (nonatomic , strong) AVPlayerRemote *remotePlayer;

@property (nonatomic, assign) PlayerType playerType;
@end

@implementation AVAudioPlayerManger
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.playerType = PlayerUnknow;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

+ (instancetype)shared {
    static AVAudioPlayerManger *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [AVAudioPlayerManger new];
    });
    return shared;
}

- (void)configuration {
    //设置锁屏仍能继续播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)startPlay:(NSURL *)url {
    [self stop];
    if ([url.absoluteString hasPrefix:@"http://"] || [url.absoluteString hasPrefix:@"https://"]) {
        self.playerType = PlayerRemote;
    } else {
        self.playerType = PlayerLocal;
    }
    if (self.playerType == PlayerLocal) {
        [self.localPlayer startPlay:url];
    } else if (self.playerType == PlayerRemote) {
        [self.remotePlayer startPlay:url];
    }
}


- (void)play { //
    if (self.playerType == PlayerLocal) {
        [self.localPlayer pauseOrPlay];
    } else if (self.playerType == PlayerRemote) {
        [self.remotePlayer play];
    }
}

- (void)stop {
    if (self.playerType == PlayerLocal) {
        [self.localPlayer stop];
    } else if (self.playerType == PlayerRemote) {
        [self.remotePlayer pause];
    }
}

-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self stop];
        }
    }
}

- (AVAudioPlayerLocal *)localPlayer {
    if (!_localPlayer) {
        _localPlayer = [[AVAudioPlayerLocal alloc]init];
    }
    return _localPlayer;
}

- (AVPlayerRemote *)remotePlayer {
    if (!_remotePlayer) {
        _remotePlayer = [[AVPlayerRemote alloc]init];
    }
    return _remotePlayer;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

@end
