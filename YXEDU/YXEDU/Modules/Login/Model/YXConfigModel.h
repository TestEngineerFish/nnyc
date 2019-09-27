//
//  YXConfigModel.h
//  YXEDU
//
//  Created by yao on 2018/10/17.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBadgeListModel.h"
#import "YXConfigBookModel.h"

typedef NS_ENUM(NSInteger, YXSharePalform) {
    YXShareWXSession,
    YXShareWXTimeLine,
    YXShareQQ
};



@interface YXSpokenCheckInterval : NSObject
@property (nonatomic, assign)NSInteger delay;
@property (nonatomic, assign)NSInteger interval;
@property (nonatomic, assign)NSInteger max;
@end

@interface YXExpandTab : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSNumber *order;
@property (nonatomic, copy) NSString *url;
@end

@interface YXTabBarModel : NSObject
@property (nonatomic, copy) NSString *titleCh;
@property (nonatomic, copy) NSString *titleEn;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *selectedImageStr;
@property (nonatomic, copy) NSString *normalImageStr;
@end

@interface YXBaseConfig : NSObject
@property (nonatomic, assign)BOOL bindMobile;
@property (nonatomic, assign)BOOL learning;
@property (nonatomic, copy)NSString *wordDict;
@property (nonatomic, copy)NSString *cdn;
@property (nonatomic, copy)NSString *versionTime;
/** 0表英式 ，1表美式 */
@property (nonatomic, assign)NSInteger speech;
@property (nonatomic, strong)YXSpokenCheckInterval *speechx;
/** 分享中间页Url */
@property (nonatomic, copy)NSString *picUrl;
//单词和词书的关系json地址
@property (nonatomic, copy)NSString *wordBookDict;
// 自定义tool bar
@property (nonatomic, strong) YXExpandTab *expandTab;
//用户的uuid标示
@property (nonatomic, copy)NSString *uuid;
//前端弹窗中识别的正则规则
@property (nonatomic, copy)NSString *popUpRule;

//用户的词汇工具包状态， 1是为未体验，2表示在在有效时间内，3表示已经过期
@property (nonatomic, assign)NSInteger wordToolkitState;

- (NSString *)shareLinkOf:(YXSharePalform)paltform;
@end


//@interface YXConfigBookModel : NSObject
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *bookId;
//@property (nonatomic, strong) NSString *desc;
//@property (nonatomic, strong) NSString *cover;
//@property (nonatomic, strong) NSString *wordCount;
//@property (nonatomic,readonly, assign,getter=isLearning)  BOOL learning;
//@property (nonatomic, assign) BOOL isSetSuccess;
//@end

@interface YXConfigGradeModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <YXConfigBookModel *>*options;
@end


@interface YXContentListItem : NSObject
@property (nonatomic, copy)NSString *contentKey;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString *urlKey;
@end

@interface YXWordFormModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)NSMutableArray *contentList;
@end

@interface YXTaskModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger credits;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *gainImg;
@property (nonatomic, strong) NSString *notGainImg;
@property (nonatomic, strong) NSString *color;

 @property (nonatomic, copy) NSString *timeStr;

@end

@interface YXConfigModel : NSObject
@property (nonatomic, strong)YXBaseConfig *baseConfig;
@property (nonatomic, strong)NSArray *bookList;

@property (nonatomic, readonly, copy)NSString *cdn;
@property (nonatomic, strong)NSMutableArray *wordFrame;
@property (nonatomic, strong)NSMutableArray *badgeList;
@property (nonatomic, strong)NSMutableDictionary *badgesDic;
@property (nonatomic, strong)NSMutableArray *taskList;

@property (nonatomic, strong)NSArray *allBookIds;
@property (nonatomic, strong)NSArray *allBookNames;
@property (nonatomic, copy) NSArray *completedTaskAry;
@property (nonatomic, copy) NSArray *completedTaskModelAry;

 @property (nonatomic, copy) NSString *taskStatusString;

- (NSString *)getBookNameWithId:(NSString *)bookId;
@end

