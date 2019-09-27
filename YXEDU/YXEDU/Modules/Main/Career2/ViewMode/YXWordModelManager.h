//
//  YXWordModelManager.h
//  YXEDU
//
//  Created by yao on 2018/10/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXWordDetailModel.h"


typedef NS_ENUM(NSUInteger, YXWordQuaryFieldType) {
    YXWordQuaryFieldWord, // 单词
    YXWordQuaryFieldparaphrase // 中文翻译
};


@interface YXWordModelManager : NSObject
+ (void)saveWordsDetails:(NSArray *)wordDetails andVersionTime:(NSString *)versionTime;
+ (NSString *)versionTime;
+ (void)saveVersionTime:(NSString *)versionTime;
+ (void)quardWithWordIds:(NSArray *)wordIds completeBlock:(finishBlock)block;
+ (void)quardWithWordId:(NSString *)wordId completeBlock:(finishBlock)block;

//+ (YXWordDetailModel *)quardWithWordId:(NSArray *)wordId;

+ (void)keepWordId:(NSString *)wordId bookId:(NSString *)bookId isFav:(BOOL)fav completeBlock:(YXFinishBlock)block;

+ (void)downLoadWordMaterials:(NSArray *)words andBookId:(NSString *)bookId completeBlock:(YXFinishBlock)block;

+ (void)quaryWordsWithType:(YXWordQuaryFieldType)wordQuaryFieldType
          fuzzyQueryPrefix:(NSString *)fuzzyQueryPrefix
             completeBlock:(finishBlock)block;

+ (void)quaryWordsWithFuzzyQueryPrefix:(NSString *)fuzzyQueryPrefix
                         completeBlock:(finishBlock)block;
@end

