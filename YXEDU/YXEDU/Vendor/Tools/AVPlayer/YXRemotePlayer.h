//
//  YXRemotePlayer.h
//  YXEDU
//
//  Created by yao on 2018/11/19.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YXRemotePlayer : NSObject
@property (nonatomic, copy) void (^playFinishBlock)(BOOL);

/** 创建播放器（不会自动播放）
 @param url 音频链接本地或远程
 @return 播放器对象
 */
- (instancetype)initWithPlayUrl:(NSURL *)url;

- (void)startPlay:(NSURL *)url;
- (void)startPlay:(NSURL *)url finish:(void (^)(BOOL isSuccess))playFinishBlock;
- (void)pause;
- (void)resetToPlay;
- (void)play;
- (void)releaseSource;
@end

