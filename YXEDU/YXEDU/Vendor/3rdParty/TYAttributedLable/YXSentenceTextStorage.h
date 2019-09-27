//
//  YXSentenceTextStorage.h
//  AttributedDemo
//
//  Created by 沙庭宇 on 2019/5/25.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import "TYTextContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXSentenceTextStorage : TYTextStorage<YXSentenceStorageProtocol>

@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, assign) NSNumber *sentenceId;
@property (nonatomic, assign) NSInteger realIndex;
@property (nonatomic, assign) NSRange useTimeRange;

@end

NS_ASSUME_NONNULL_END
