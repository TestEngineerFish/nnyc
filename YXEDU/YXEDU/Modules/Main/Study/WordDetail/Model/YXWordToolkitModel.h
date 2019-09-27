//
//  YXWordToolkitModel.h
//  YXEDU
//
//  Created by jukai on 2019/5/15.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXWordToolkitModel : NSObject

@property (nonatomic, copy)NSString *vipId;
@property (nonatomic, copy)NSMutableArray *comment;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *wordToolkitState;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *userCredits;

@end

NS_ASSUME_NONNULL_END
