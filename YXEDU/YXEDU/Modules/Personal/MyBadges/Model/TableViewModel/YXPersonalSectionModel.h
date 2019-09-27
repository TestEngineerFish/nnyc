//
//  YXPersonalBadgeSection.h
//  YXEDU
//
//  Created by Jake To on 10/20/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXPersonalBadgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXPersonalSectionModel : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *badges;

@end

NS_ASSUME_NONNULL_END
