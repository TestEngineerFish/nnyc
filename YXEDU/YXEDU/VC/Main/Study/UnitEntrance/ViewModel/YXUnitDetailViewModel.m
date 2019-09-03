//
//  YXStartStudyViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXUnitDetailViewModel.h"
#import "BSCommon.h"
#import "YXHttpService.h"
#import "YX_URL.h"
#import "YXStudyBookUnitModel.h"
#import "NSObject+YR.h"
#import "YXFileDBManager.h"
#import "SVProgressHUD.h"
#import "YXHttpService.h"
#import "NSString+YX.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import <UIKit/UIKit.h>
#import "NetWorkRechable.h"
#import "YXFMDBManager.h"
#import "YXInterfaceCacheService.h"
#import "YXComHttpService.h"

@interface YXUnitDetailViewModel ()

@end

@implementation YXUnitDetailViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)getUnit:(id)unitModel finish:(finishBlock)block {
    YXUnitModel *unitM = unitModel;
    YXBookModel *bookM = [YXConfigure shared].loginModel.learning;
    [[YXHttpService shared]GET:DOMAIN_BOOKUNIT parameters:@{@"unitid":unitM.unitid} finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXStudyBookUnitModel *bookUnit = [YXStudyBookUnitModel yrModelWithJSON:obj[@"bookunit"]];
            [YXConfigure shared].bookUnitModel = bookUnit;
            [[YXInterfaceCacheService shared]write:bookUnit key:STRCAT(bookM.bookid, unitM.unitid)];
            block(bookUnit,result);
        } else {
            YXStudyBookUnitModel *model = [[YXInterfaceCacheService shared]read:STRCAT(bookM.bookid, unitM.unitid)];
            if (model) {
                [YXConfigure shared].bookUnitModel = model;
                block(model, YES);
            } else {
                block(obj, result);
            }
        }
    }];
}


- (BOOL)checkFileIfExistsavePath:(NSString *)name
                         zipFile:(NSString *)zipName {
    if ([[YXFileDBManager shared]unitFileIsExist:[name DIR:zipName]]) {
        return YES;
    }
    return NO;
}

- (void)startDownload:(NSString *)URLString
             savePath:(NSString *)name
              zipFile:(NSString *)zipName
          sourceModel:(YXUnitModel *)model
             progress:(progressBlock)progress
             complete:(finishBlock)block {

    [YXUtils createResourceDir:name];
    [YXUtils createTmpResourceDir:name];
    [[YXHttpService shared]DOWNLOAD:URLString dstFilePath:[[[YXUtils resourcePath]DIR:name] DIR:zipName] progress:^(NSProgress *downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(downloadProgress);
        });
    } completion:^(id responseObject) {
        YRHttpResponse * response = responseObject;
        if (!response.error) {
//            NSURL *targetUrl = [NSURL fileURLWithPath:[[[YXUtils resourcePath]DIR:name] DIR:zipName]];
//            NSData *fileData = response.responseObject;
//            [fileData writeToURL:targetUrl atomically:YES];
            [[YXFileDBManager shared]unzipFile:[name DIR:zipName]];
            
            YXUnitNameModel *nameModel = [YXUnitNameModel modelWithName:model.name];
            YXMaterialModel *materialModel = [[YXMaterialModel alloc]init];
            materialModel.path = name;
            materialModel.resname = [NSString stringWithFormat:@"%@%@第%@单元", [YXConfigure shared].loginModel.learning.desc, nameModel.line1,nameModel.line2];
            materialModel.resid = model.unitid;
            materialModel.date = [NSDate date];
            materialModel.size = [NSString stringWithFormat:@"%lu", [YXConfigure shared].bookUnitModel.size.longValue];
            [[YXFMDBManager shared]insertMaterial:materialModel completeBlock:^(id obj, BOOL result) {
            }];
            block(nil, YES);
        } else {
            block(@(response.error.code), NO);
        }
    }];
}

- (void)cancel {
    [[YXHttpService shared]CANCEL];
}

@end
