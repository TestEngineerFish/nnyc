//
//  YXConfigure3Model.h
//  YXEDU
//
//  Created by shiji on 2018/6/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXConfigure3BookModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *word_count;
@end

@interface YXConfigure3GradeModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <YXConfigure3BookModel *>*options;
@end


@interface YXConfigure3Model : NSObject<NSCoding>
@property (nonatomic, strong) NSArray <YXConfigure3GradeModel *>*config;
@end
