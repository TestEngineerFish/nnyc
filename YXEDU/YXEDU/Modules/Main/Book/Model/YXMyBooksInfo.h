//
//  YXMyBooksInfo.h
//  YXEDU
//
//  Created by yao on 2018/10/19.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, YXBookMaterialState) {
//    kBookMaterialUnKnow,
    kBookMaterialUnDownload,
    kBookMaterialDownloading,
    kBookMaterialDownloaded
};

@interface YXStudyBookModel : NSObject
/** 是否正在学习 */
@property (nonatomic, assign,getter=isLearning)BOOL learning;
@property (nonatomic, copy)NSString *bookId;
@property (nonatomic, copy)NSString *bookName;
@property (nonatomic, copy)NSString *cover;
@property (nonatomic, copy)NSString *wordCount;
@property (nonatomic, copy)NSString *learnedCount;
@property (nonatomic, copy)NSString *planNum;
@property (nonatomic, copy)NSString *planRemain;
@property (nonatomic, copy)NSString *unitNum;
@property (nonatomic, copy)NSString *resUrl;

@property (nonatomic, assign)BOOL materialDownloaded;
@property (nonatomic, copy)NSString *resPath;
//@property (nonatomic, copy)progressBlock proBlock;
@property (nonatomic, assign)CGFloat progressValue;
@property (nonatomic,assign)YXBookMaterialState materialState;
@end

@interface YXMyBooksInfo : NSObject
@property (nonatomic, strong)YXStudyBookModel *learning;
@property (nonatomic, copy)NSArray *learned;
@end

