//
//  YXUnitDetailTextModel.h
//  YXEDU
//
//  Created by jukai on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXUnitDetailTextModel : NSObject

@property (nonatomic, assign) NSInteger textId;
@property (nonatomic, copy) NSString *textTitle;
@property (nonatomic, assign) NSInteger followRank;
@property (nonatomic, assign) NSInteger reciteRank;
@property (nonatomic, copy) NSString *textJson;
@property (nonatomic, copy) NSString *textZip;

@end

NS_ASSUME_NONNULL_END
