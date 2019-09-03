//
//  YXPersonalViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"
#import "YXPersonalBindModel.h"

typedef NS_ENUM(NSInteger, PersonalCellType) {
    PersonalCellPlain,
    PersonalCellBlank,
    PersonalCellLogout,
};

@class YXLogoutModel;
@interface YXPersonalViewModel : NSObject

- (NSInteger)rowCount;
- (PersonalCellType)rowType:(NSInteger)idx;
- (float)rowHeight:(NSInteger)idx;

- (void)logout:(YXLogoutModel *)model finish:(finishBlock)block;

- (void)bindSO:(YXPersonalBindModel *)bindModel complete:(finishBlock)block;

- (void)unbindSO:(NSString *)unbind complete:(finishBlock)block;

- (void)requestUserInfo:(finishBlock)block;
@end
