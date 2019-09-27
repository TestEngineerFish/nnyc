//
//  YXArticleModel.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * type：目前分为 4个种类
 * type：1 表示 是副标题类型
 * location ： 1表示标题位置在左边 ，2表示标题位置在中间，3表示标题位置在右边
 *
 * type:2 表示 是段落类型
 * eng表示一句英文，che表示英文的中文翻译，audioUrl表示英文语音地址
 *
 * type:3 表示 是图片类型
 * imgUrl 表示图片地址
 *
 * type:4 表示 是对话类型
 * speaker 表示对话人，其他和段落一样
 **/

@interface YXArticleTypeModel : NSObject
@property (nonatomic, assign) NSNumber *type;
@property (nonatomic, strong) NSObject *content;
@end

// 副标题
@interface YXArticleSubtitleModel : NSObject
@property (nonatomic, assign) NSNumber *location;
@property (nonatomic, copy)   NSString *title;
@end

// 句子
@interface YXArticleSentenceModel : NSObject
@property (nonatomic, assign) NSNumber *sentenceId;//句子ID
@property (nonatomic, copy)   NSString *eng;//英文
@property (nonatomic, copy)   NSString *che;//中文
@property (nonatomic, copy)   NSString *audioUrl;//音频地址
@property (nonatomic, assign) NSNumber *useTime; //播放时长 单位:秒
@property (nonatomic, copy)   NSString *speaker;// 发言者-英文
@property (nonatomic, copy)   NSString *talker;// 发言者-中文
@end

// 段落
@interface YXArticleSectionModel : NSObject
@property (nonatomic, assign) NSNumber *sectionId;//段落ID
@property (nonatomic, strong) NSArray<YXArticleSentenceModel *> *sentence;//句子数组
@end

// 图片
@interface YXArticleImageModel : NSObject
@property (nonatomic, copy)   NSString *imgUrl;
@property (nonatomic, assign) NSNumber *imgRatio;
@property (nonatomic, assign) NSNumber *wide;
@property (nonatomic, assign) NSNumber *high;
@end

// 对话
@interface YXArticleDialogModel : NSObject
@property (nonatomic, assign) NSNumber *sectionId;//段落ID
@property (nonatomic, strong) NSArray<YXArticleSentenceModel *> *sentence;
@end

// 重点单词
@interface YXKeyPointWordModel : NSObject
@property (nonatomic, assign) NSNumber *wordId;
@property (nonatomic, assign) NSNumber *bookId;
@end

// 重点词组
@interface YXKeyPointPhraseModel : NSObject
@property (nonatomic, copy) NSString *eng;
@property (nonatomic, copy) NSString *che;
@end

@interface YXKeyPointModel : NSObject
@property (nonatomic, strong) NSArray<YXKeyPointWordModel *> *word;
@property (nonatomic, strong) NSArray<YXKeyPointPhraseModel *> *phrase;
@end

@interface YXArticleModel : NSObject
@property (nonatomic, copy)   NSString *textTitle;
@property (nonatomic, assign) NSNumber *textId;
@property (nonatomic, copy)   NSString *rootUrl;
@property (nonatomic, copy)   NSString *from;
@property (nonatomic, strong) NSArray<YXArticleTypeModel *> *content;
@property (nonatomic, strong) YXKeyPointModel *keyPoint;
@end

NS_ASSUME_NONNULL_END
