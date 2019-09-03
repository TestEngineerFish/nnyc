//
//  YXFeedSendModel.h
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXFeedSendModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString *feed;
@property (nonatomic, strong) NSString *env;
@property (nonatomic, strong) NSArray *files;
@end
