//
//  YXASTextLibModel.h
//  YXEDU
//
//  Created by jukai on 2019/5/29.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXASTextLibModel : NSObject

@property (nonatomic, assign) NSInteger bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, assign) NSInteger textCount;
@property (nonatomic, assign) NSInteger verId;
@property (nonatomic, copy) NSString *verName;
@property (nonatomic, assign) NSInteger gradeId;
@property (nonatomic, copy) NSString *gradeName;

@end

NS_ASSUME_NONNULL_END
