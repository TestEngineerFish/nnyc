//
//  YXStudyBatchModel.h
//  YXEDU
//
//  Created by shiji on 2018/6/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXStudyBatchDataModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *unitid;
@property (nonatomic, strong) NSString *questionidx;
@property (nonatomic, strong) NSString *questionid;
@property (nonatomic, strong) NSString *learn_status; //learn_status:学习状态
@end

@interface YXStudyBatchModel : NSObject<NSCoding>
@property (nonatomic, strong) NSArray <YXStudyBatchDataModel *>*data;
@property (nonatomic, strong) NSArray *learning_log;
@end
