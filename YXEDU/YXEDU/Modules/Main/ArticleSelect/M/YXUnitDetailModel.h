//
//  YXUnitDetailModel.h
//  YXEDU
//
//  Created by jukai on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXUnitDetailModel : NSObject

@property (nonatomic, assign) NSInteger unitId;
@property (nonatomic, copy) NSString *unitName;
@property (nonatomic, copy) NSArray *text;

@end

NS_ASSUME_NONNULL_END
