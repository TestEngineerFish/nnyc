//
//  AVPlayerManger.h
//  YXEDU
//
//  Created by shiji on 2018/3/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlayerType) {
    PlayerUnknow,     // 未知
    PlayerRemote,     // 远程
    PlayerLocal,      // 本地
};

typedef NS_ENUM(NSInteger,TipsSoundType) {
    TipsSoundWrong,
    TipsSoundRight
};


@interface AVAudioPlayerLocal : NSObject

- (void)startPlay:(NSURL *)url;
- (void)startPlay:(NSURL *)url finish:(void(^)(BOOL isSuccess))playFinishBlock;
- (void)pauseOrPlay;

- (void)stop;

@end


@interface AVPlayerRemote : NSObject

- (void)startPlay:(NSURL *)url;

- (void)pause;

- (void)play;

@end

@interface AVAudioPlayerManger : NSObject

@property (nonatomic, assign, readonly) PlayerType playerType;
//@property (nonatomic, strong) AVAudioPlayerLocal *wrongPlayer;

+ (instancetype)shared;

- (void)configuration;

- (void)startPlay:(NSURL *)url;
- (void)startPlay:(NSURL *)url finish:(void(^)(BOOL isSuccess))playFinishBlock;
- (void)startPlaySentence:(NSURL *)url finish:(void (^)(BOOL))playFinishBlock;

- (void)play;

- (void)stop;

- (void)cancleFinishAction;
- (void)cancleFinishActionAndStopPlaying;

- (void)playTipsSoundType:(TipsSoundType)soundType playFinishBlock:(void(^)(BOOL isSuccess))playFinishBlock;
- (void)stopPlayTipsSoundType:(TipsSoundType)soundType;

//- (void)playRightSoundFinish:(void(^)(BOOL isSuccess))playFinishBlock;
//- (void)playWrongSoundFinishBlock:(void(^)(BOOL isSuccess))playFinishBlock;
//- (void)stopPlayWrongSound;
@end
