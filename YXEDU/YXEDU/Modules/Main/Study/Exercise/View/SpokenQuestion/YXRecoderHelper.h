//
//  YXRecoderHelper.h
//  YXEDU
//
//  Created by yao on 2018/11/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface YXRecoderHelper : NSObject
+ (YXRecoderHelper *)shareHelper;
- (void)statrRecord:(void(^)(BOOL success)) startSuccessBlock;
- (void)stopRecord;
- (void)deleteOldRecordFile;
- (void)playRecord;
- (void)playRecordFinish:(void(^)(void))playFinishBlock;
- (BOOL)isAvailableWithDeviveMediaType:(AVMediaType)mediaType;
- (NSData *)currentRecordSoundData;
@end

