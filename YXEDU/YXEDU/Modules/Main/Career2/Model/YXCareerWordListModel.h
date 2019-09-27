//
//  YXCareerWordListModel.h
//  YXEDU
//
//  Created by yixue on 2019/2/20.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCareerWordListModel : NSObject

@property (nonatomic, assign)NSInteger wordNum;
@property (nonatomic, assign) NSInteger bookId;
@property (nonatomic, copy)NSString *bookName;

@end

NS_ASSUME_NONNULL_END
