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
#import "YXRemotePlayer.h"

typedef void(^PlayFinishBlock)(BOOL);
#pragma mark -AVAudioPlayerLocal-
@interface AVAudioPlayerLocal ()<AVAudioPlayerDelegate>
@property (nonatomic , strong) AVAudioPlayer *player;
@property (nonatomic, copy) void (^playFinishBlock)(BOOL);
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
    [self startPlay:url finish:nil];
}

- (void)startPlay:(NSURL *)url finish:(void (^)(BOOL))playFinishBlock {
    if (playFinishBlock) { // 先记录
        self.playFinishBlock = [playFinishBlock copy];
    }
    [self configAudioSession];// 偶发没声音
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    self.player.volume = 1.0;
    if (error) {
        [self executeFinishBlock];
        YXEventLog(@"本地播放器创建失败-》%@", error.description);
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

- (void)configAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    [audioSession setActive:YES error:&error];
}

- (void)stopPlaying {
    if (self.player != nil) {
        if ([self.player isPlaying] == YES) {
            [self.player stop];
        }
        self.player = nil;
    }
}

- (void)stop { // 被中断
    [self stopPlaying];
    [self executeFinishBlock];
}

- (void)executeFinishBlock {
    if (self.playFinishBlock) {
        PlayFinishBlock pfblock = self.playFinishBlock;
        self.playFinishBlock = nil;
        pfblock(YES);
    }
    self.player = nil;
}

#pragma mark -AVAudioPlayerDelegate-
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([self.player isEqual:player]) {
        [self executeFinishBlock];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    if ([self.player isEqual:player]) {
        [self executeFinishBlock];
    }
}

@end


#pragma mark -AVPlayerRemote-
@interface AVPlayerRemote ()
@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic, copy) void (^playFinishBlock)(BOOL);
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
//    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
//    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
//    [self.player play];
    [self startPlay:url finish:nil];
}

- (void)startPlaSentence:(NSURL *)url finish:(void (^)(BOOL))playFinishBlock {

    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    if (playFinishBlock) {
        self.playFinishBlock = playFinishBlock;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
    [self.player play];

}

- (void)startPlay:(NSURL *)url finish:(void (^)(BOOL))playFinishBlock {
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    if (playFinishBlock) {
        self.playFinishBlock = playFinishBlock;
//       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
    
    [self.player play];
    
}




- (void)playEnd:(NSNotification *)notify {
    if (self.playFinishBlock) {
        self.playFinishBlock(YES);
    }
}

- (void)pause {
//    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player pause];
//    }
}

- (void)play {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player play];
    }
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}

@end


#pragma mark -AVAudioPlayerManger-
@interface AVAudioPlayerManger () < AVAudioPlayerDelegate>

@property (nonatomic , strong) AVAudioPlayerLocal *localPlayer;

@property (nonatomic , strong) AVPlayerRemote *remotePlayer;

@property (nonatomic, assign) PlayerType playerType;

//@property (nonatomic, strong) AVAudioPlayerLocal *rightPlayer;

@property (nonatomic, strong) YXRemotePlayer *rightPlayer;
@property (nonatomic, strong) YXRemotePlayer *wrongPlayer;
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
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

- (void)startPlay:(NSURL *)url {   
    [self startPlay:url finish:nil];
}

// 播放句子
- (void)startPlaySentence:(NSURL *)url finish:(void (^)(BOOL))playFinishBlock {
    //     YXEventLog(@"Manager sound url -> %@\n>>>Extension -> %@",url,[url pathExtension]);
    [self stop];
    if ([url.absoluteString hasPrefix:@"http://"] || [url.absoluteString hasPrefix:@"https://"]) {
        self.playerType = PlayerRemote;
    } else {
        self.playerType = PlayerLocal;
    }
    //本地或者远程
    if (self.playerType == PlayerLocal) {
        [self.localPlayer startPlay:url finish:playFinishBlock];
    } else if (self.playerType == PlayerRemote) {
        [self.remotePlayer startPlaSentence:url finish:playFinishBlock];
    }
}

- (void)startPlay:(NSURL *)url finish:(void (^)(BOOL))playFinishBlock {
//     YXEventLog(@"Manager sound url -> %@\n>>>Extension -> %@",url,[url pathExtension]);
    [self stop];
    if ([url.absoluteString hasPrefix:@"http://"] || [url.absoluteString hasPrefix:@"https://"]) {
        self.playerType = PlayerRemote;
    } else {
        self.playerType = PlayerLocal;
    }
    //本地或者远程
    if (self.playerType == PlayerLocal) {
        [self.localPlayer startPlay:url finish:playFinishBlock];
    } else if (self.playerType == PlayerRemote) {
//        [self.remotePlayer startPlay:url];
        [self.remotePlayer startPlay:url finish:playFinishBlock];
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
        [self.remotePlayer pause];// 暂时不要中断远端播放
    }
}


- (void)cancleFinishAction {
    if (self.playerType == PlayerLocal) {
        self.localPlayer.playFinishBlock = nil;
    }else if(self.playerType == PlayerRemote) {
        self.remotePlayer.playFinishBlock = nil;
    }
}

- (void)cancleFinishActionAndStopPlaying {
    [self cancleFinishAction];
    [self stop];
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
    [kNotificationCenter removeObserver:self];
}


#pragma mark - 提示音
- (YXRemotePlayer *)rightPlayer {
    if (!_rightPlayer) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"right" withExtension:@"mp3"];
        _rightPlayer = [[YXRemotePlayer alloc] initWithPlayUrl:url];
    }
    return _rightPlayer;
}

- (YXRemotePlayer *)wrongPlayer {
    if (!_wrongPlayer) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"wrong" withExtension:@"mp3"];
        _wrongPlayer = [[YXRemotePlayer alloc] initWithPlayUrl:url];
    }
    return _wrongPlayer;
}

- (void)playTipsSoundType:(TipsSoundType)soundType playFinishBlock:(void (^)(BOOL))playFinishBlock {
    (soundType == TipsSoundRight) ? [self playRightSoundFinishBlock:playFinishBlock] : [self playWrongSoundFinishBlock:playFinishBlock];
}

- (void)stopPlayTipsSoundType:(TipsSoundType)soundType {
    (soundType == TipsSoundRight) ? [self stopPlayRightSound] : [self stopPlayWrongSound];
}
- (void)playWrongSoundFinishBlock:(void (^)(BOOL))playFinishBlock {
    [self.wrongPlayer resetToPlay];
    self.wrongPlayer.playFinishBlock = [playFinishBlock copy];
    [self.wrongPlayer play];
}

- (void)stopPlayWrongSound {
    [self.wrongPlayer resetToPlay];
}

- (void)playRightSoundFinishBlock:(void (^)(BOOL))playFinishBlock {
    [self.rightPlayer resetToPlay];
    self.rightPlayer.playFinishBlock = [playFinishBlock copy];
    [self.rightPlayer play];
}

- (void)stopPlayRightSound {
    [self.rightPlayer resetToPlay];
}

//+ (void)playRight {
//    NSURL *path = [[NSBundle mainBundle]URLForResource:@"right" withExtension:@"mp3"];
//    [[AVAudioPlayerManger shared] startPlay:path];
//}
//#pragma mark -sound
//+ (void)playWrong {
//    NSURL *path = [[NSBundle mainBundle]URLForResource:@"wrong" withExtension:@"mp3"];
//    [[AVAudioPlayerManger shared] startPlay:path];
//}

@end



//- (AVAudioPlayerLocal *)rightPlayer {
//    if (!_rightPlayer) {
//        NSError *error;
//        NSURL *path = [[NSBundle mainBundle]URLForResource:@"right" withExtension:@"mp3"];
//        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:path error:&error];
//        player.volume = 1.0;
//        _rightPlayer = [[AVAudioPlayerLocal alloc] init];
//        _rightPlayer.player = player;
//    }
//    return _rightPlayer;
//}
//
//
//- (void)playRightSoundFinish:(void (^)(BOOL))playFinishBlock {
//    if ([self.rightPlayer.player isPlaying]) {
//        [self.rightPlayer.player pause];
//        self.rightPlayer.player.currentTime = 0;
//    }
//    if ([self.rightPlayer.player prepareToPlay]) {
//        [self.rightPlayer.player play];
//    }
//}


//- (AVAudioPlayerLocal *)wrongPlayer {
//    if (!_wrongPlayer) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
//        [[AVAudioSession sharedInstance] setActive: YES error: nil];
//        NSError *error;
////
//        NSString *filepath = [[NSBundle mainBundle]pathForResource:@"wrong" ofType:@"mp3"];
//        NSData *data = [[NSData data] initWithContentsOfFile:filepath];
////        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error];
//////        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:&error];
////        player.volume = 1.0;
//////        [player setNumberOfLoops:0];
////        _wrongPlayer = [[AVAudioPlayerLocal alloc] init];
////        _wrongPlayer.player = player;
//
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"wrong" withExtension:@"mp3"];
//        AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
////        self.wrongAVPlayer = [[AVPlayer alloc]initWithPlayerItem:songItem];
////        self.wrongAVPlayer.volume = 1.0;
////        [self.wrongAVPlayer play];
//    }
//    return _wrongPlayer;
//}
//
//- (AVPlayer *)wrongAVPlayer {
//    if (!_wrongAVPlayer) {
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"wrong" withExtension:@"mp3"];
//        AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
//        _wrongAVPlayer = [[AVPlayer alloc]initWithPlayerItem:songItem];
//
//
//    }
//    return _wrongAVPlayer;
//}











//- (void)startPlay:(NSURL *)url {
//    //    [self stop];
//    //    if ([url.absoluteString hasPrefix:@"http://"] || [url.absoluteString hasPrefix:@"https://"]) {
//    //        self.playerType = PlayerRemote;
//    //    } else {
//    //        self.playerType = PlayerLocal;
//    //    }
//    //    if (self.playerType == PlayerLocal) {
//    //        [self.localPlayer startPlay:url];
//    //    } else if (self.playerType == PlayerRemote) {
//    //        [self.remotePlayer startPlay:url];
//    //    }
//    [self startPlay:url finish:nil];
//}
