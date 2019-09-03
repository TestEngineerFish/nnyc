//
//  YXStartStudyViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"
#import "YXBookModel.h"

@interface YXUnitDetailViewModel : NSObject

- (void)getUnit:(id)unitModel finish:(finishBlock)block;



- (BOOL)checkFileIfExistsavePath:(NSString *)name
                         zipFile:(NSString *)zipName;

- (void)startDownload:(NSString *)URLString
             savePath:(NSString *)name
              zipFile:(NSString *)zipName
          sourceModel:(YXUnitModel *)model
             progress:(progressBlock)progress
             complete:(finishBlock)block;

- (void)cancel;
@end
