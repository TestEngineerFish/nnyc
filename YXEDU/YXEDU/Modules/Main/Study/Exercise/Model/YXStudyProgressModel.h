//
//  YXStudyProgressModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXStudyProgressModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *unitid;
@property (nonatomic, strong) NSString *wordid;
@property (nonatomic, strong) NSString *questionid;
@property (nonatomic, strong) NSString *answer;
@end
