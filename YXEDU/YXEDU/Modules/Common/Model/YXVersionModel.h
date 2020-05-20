//
//  YXVersionModel.h
//  YXEDU
//
//  Created by shiji on 2018/6/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXVersionResUpdateModel : NSObject<NSCoding>
@property (nonatomic, strong) NSNumber *flag;
@property (nonatomic, strong) NSString *url;
@end

@interface YXVersionResModel : NSObject<NSCoding>
@property (nonatomic, strong) YXVersionResUpdateModel *update;
@end

@interface YXVersionModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *pf;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *channel;
@end
