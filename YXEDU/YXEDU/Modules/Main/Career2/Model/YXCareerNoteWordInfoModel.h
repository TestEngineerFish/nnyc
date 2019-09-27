//
//  YXCareerNoteWordInfoModel.h
//  YXEDU
//
//  Created by yixue on 2019/2/25.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXWordModelManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCareerNoteWordInfoModel : NSObject

@property (nonatomic, copy) NSString *word_id;
@property (nonatomic, copy) NSString *book_id;

@property (nonatomic, strong) YXWordDetailModel *wordModel;

@end

NS_ASSUME_NONNULL_END
