//
//  YXFeedBackViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXFeedSendModel.h"
#import "YXCommHeader.h"

@interface YXFeedBackViewModel : NSObject
- (void)submitFeedBack:(YXFeedSendModel *)sendModel
                finish:(finishBlock)block;
@end
