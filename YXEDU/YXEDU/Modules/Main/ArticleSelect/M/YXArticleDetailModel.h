//
//  YXArticleDetailModel.h
//  YXEDU
//
//  Created by jukai on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXArticleDetailModel : NSObject

@property (nonatomic, assign) NSInteger bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSArray *unit;
@property (nonatomic, copy) NSArray *unitIds;

@end

NS_ASSUME_NONNULL_END
