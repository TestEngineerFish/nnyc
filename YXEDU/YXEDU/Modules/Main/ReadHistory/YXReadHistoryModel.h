//
//  YXReadHistoryModel.h
//  YXEDU
//
//  Created by jukai on 2019/5/29.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXReadHistoryModel : NSObject

@property (nonatomic, assign) NSInteger textId;
@property (nonatomic, copy) NSString *textTitle;
@property (nonatomic, assign) NSInteger followRank;
@property (nonatomic, assign) NSInteger reciteRank;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, assign) NSInteger lastLearnTime;
@property (nonatomic, copy) NSString *textJson;

@end

NS_ASSUME_NONNULL_END
