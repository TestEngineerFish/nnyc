//
//  YXBindResultModel.h
//  YXEDU
//
//  Created by shiji on 2018/5/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YXBindResultMobileModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *mobile;
@end


@interface YXBindResultModel : NSObject<NSCoding>
@property (nonatomic, strong) YXBindResultMobileModel *bindmobile;
@end
