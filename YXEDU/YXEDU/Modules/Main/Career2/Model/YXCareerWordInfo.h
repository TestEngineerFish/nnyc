//
//  YXCareerWordInfo.h
//  YXEDU
//
//  Created by yao on 2018/10/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXWordDetailModel.h"
//bookId": "3",
//"wordId": "862",
//"createdAt": "2018-07-13 15:53:11"
#define kWordRowHeight 75

typedef void(^WordDetailBlock) (YXWordDetailModel *);
@interface YXCareerWordInfo : NSObject
@property (nonatomic, copy)NSString *bookId;
@property (nonatomic, copy)NSString *wordId;
@property (nonatomic, assign)NSInteger createdAt;
@property (nonatomic, copy)NSString *dateStr;
@property (nonatomic, strong)YXWordDetailModel *wordDetail;

//- (void)quaryWordDetail:(WordDetailBlock)wordDetailBlock;
@end

