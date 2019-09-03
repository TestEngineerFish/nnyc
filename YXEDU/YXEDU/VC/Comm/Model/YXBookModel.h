//
//  YXLearningModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YXUnitNameModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *bgcolor;
@property (nonatomic, strong) NSString *visited;
@property (nonatomic, strong) NSString *line1;
@property (nonatomic, strong) NSString *line2;
+ (instancetype)modelWithName:(NSString *)name;
@end

@interface YXUnitModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *unitid;
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *learn_status;
@property (nonatomic, strong) NSString *learned;
@property (nonatomic, strong) NSString *q_idx;
@end

@interface YXBookModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <YXUnitModel *>*unit;
@end
