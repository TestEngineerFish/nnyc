//
//  YXWordTextStorage.h
//  AttributedDemo
//
//  Created by 沙庭宇 on 2019/5/24.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import "TYTextContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXWordTextStorage : TYTextStorage<YXWordStorageProtocol>

@property (nonatomic, strong) NSString *wordId;
@property (nonatomic, strong) NSString *bookId;

@end

NS_ASSUME_NONNULL_END
