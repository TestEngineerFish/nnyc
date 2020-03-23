//
//  YXWordModelManager.m
//  YXEDU
//
//  Created by yao on 2018/10/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordModelManager.h"
#import "YXFileDBManager.h"

@implementation YXWordModelManager
+ (void)saveWordsDetails:(NSArray *)wordDetails andVersionTime:(NSString *)versionTime {
    [YXFMDBManager.share insertWordsDetailWithWordsDetail:wordDetails completeBlock:^(id obj, BOOL result) {
        if (result) { // 所有插入成功
            [self saveVersionTime:versionTime];
        }else {
            YXLog(@"----插入失败");
            YXLog(@"%@",obj);
        }
    }];
}

+ (NSString *)versionTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kWordDetailVersionTimeKey];
}

+ (void)saveVersionTime:(NSString *)versionTime {
    if (versionTime) {
        [[NSUserDefaults standardUserDefaults] setObject:versionTime forKey:kWordDetailVersionTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)quardWithWordId:(NSString *)wordId completeBlock:(finishBlock)block {
    [self quardWithWordIds:@[wordId] completeBlock:^(id obj, BOOL result) {
        block([obj firstObject],result);
    }];
}
+ (void)quardWithWordIds:(NSArray *)wordIds completeBlock:(finishBlock)block{
    NSMutableArray *stringWordIds = [NSMutableArray arrayWithCapacity:wordIds.count];
    
    for (int i = 0; i < wordIds.count; i++) {
        [stringWordIds addObject: [NSString stringWithFormat:@"%@", wordIds[i]]];
    }
    
    [YXFMDBManager.share queryWordsDetailWithWordIds:stringWordIds completeBlock:^(id obj, BOOL result) {
        NSMutableArray  *words = nil;
        if (result) {
            //YXWordDetailModel模型解析
            words = [YXWordDetailModel mj_objectArrayWithKeyValuesArray:obj];
        }
        block(words , result);
    }];
}

+ (void)keepWordId:(NSString *)wordId bookId:(NSString *)bookId isFav:(BOOL)fav completeBlock:(YXFinishBlock)block {
    NSDictionary *param = @{
                            @"fav" : @(fav),
                            @"wordId"  :  (wordId ? wordId : @""),
                            @"bookId"  :  (bookId ? bookId : @""),
                            };
    
    //    [YXDataProcessCenter POST:DOMAIN_WORDFAVORITE parameters:param finshedBlock:block];
    [YXDataProcessCenter POST:DOMAIN_WORDFAVORITE parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            //   id favState = response.responseObject[@"fav"];
            NSString *tips = fav ? @"已收藏"  : @"已取消收藏";
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            [YXUtils showHUD:window title:tips];
        }
        block(response,result);
    }];
    NSString *desc = [NSString stringWithFormat:@"%@-%d",wordId,fav];
    [MobClick event:kTraceWordFavourite attributes:@{kTraceDescKey : desc}];
}

+ (void)downLoadWordMaterials:(NSArray *)words andBookId:(NSString *)bookId completeBlock:(YXFinishBlock)block {
    __block NSInteger errorCount = words.count;
    dispatch_group_t dispatchGroup = dispatch_group_create();
    //   dispatch_semaphore_t sema = dispatch_semaphore_create(5);
    for (YXWordDetailModel *model in words) {
        // NSInteger index = [words indexOfObject:model];
//        YXLog(@"发送第%zd请求",index);
        // NSString *path = [NSString stringWithFormat:@"http://www.tttnnnnnnn.com%@",model.curMaterialSubPath];
        [YXDataProcessCenter DOWNLOAD:model.materialPath
                           parameters:@{}
                             progress:^(NSProgress * _Nonnull downloadProgress) {}
                           completion:^(YRHttpResponse *response, BOOL result)
        {
            // YXLog(@"接受成功%zd恢复",index);
            if (result) { // 下载资源成功
                // YXLog(@"------%@",[NSThread currentThread]);
                NSString *subPath = [bookId stringByAppendingPathComponent:model.curMaterialSubPath];
                BOOL isSuccess = [[YXFileDBManager shared] saveWordMaterial:response.responseObject andSupPath:subPath];
                if (isSuccess) {
                    errorCount --;
                }
            }else {
            }
            //  dispatch_semaphore_signal(sema);
            dispatch_group_leave(dispatchGroup);
        }];
        dispatch_group_enter(dispatchGroup);
        // dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        // 因为有些单词资源不存在或是下载不了，会影响答题流程，所以为了用户可以正常答题，直接向上层返回YES
        block(nil,YES); //errorCount ? NO : YES,
        YXLog(@"-------下载完成,有%zd个单词没有下载成功",errorCount);
    });
    
}


+ (void)quaryWordsWithType:(YXWordQuaryFieldType)wordQuaryFieldType
          fuzzyQueryPrefix:(NSString *)fuzzyQueryPrefix
             completeBlock:(finishBlock)block{
    [YXFMDBManager.share queryWordsWithFuzzyQueryPrefix:fuzzyQueryPrefix completeBlock:^(id obj, BOOL result) {
        NSMutableArray  *words = nil;
        if (result) {
            words = [YXWordDetailModel mj_objectArrayWithKeyValuesArray:obj];
        }
        block(words , result);
    }];
}

@end
