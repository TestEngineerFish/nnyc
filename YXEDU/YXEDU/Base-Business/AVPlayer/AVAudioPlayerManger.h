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

@interface AVAudioPlayerLocal : NSObject

- (void)startPlay:(NSURL *)url;

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

+ (instancetype)shared;

- (void)configuration;

- (void)startPlay:(NSURL *)url;

- (void)play;

- (void)stop;
@end
