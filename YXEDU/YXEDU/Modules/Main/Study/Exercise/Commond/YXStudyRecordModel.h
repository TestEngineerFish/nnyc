//
//  YXStudyRecordModel.h
//  YXEDU
//
//  Created by shiji on 2018/6/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXStudyRecordModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString *recordid;
@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *unitid;
@property (nonatomic, strong) NSString *questionidx;
@property (nonatomic, strong) NSString *questionid;
@property (nonatomic, strong) NSString *learn_status;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *log;
@end
