//
//  YXMaterialModel.h
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXMaterialModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *resname;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *resid;
@property (nonatomic, strong) NSDate *date;
@end
