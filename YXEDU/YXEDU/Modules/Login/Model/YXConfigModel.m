//
//  YXConfigModel.m
//  YXEDU
//
//  Created by yao on 2018/10/17.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXConfigModel.h"
#import "YXRouteManager.h"
#import "BSUtils.h"

@implementation YXSpokenCheckInterval
@end



@implementation YXExpandTab
@end

@implementation YXTabBarModel

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.titleCh forKey:@"titleCh"];
    [coder encodeObject:self.titleEn forKey:@"titleEn"];
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.normalImageStr forKey:@"normalImageStr"];
    [coder encodeObject:self.selectedImageStr forKey:@"selectedImageStr"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.titleCh = [coder decodeObjectForKey:@"titleCh"];
        self.titleEn = [coder decodeObjectForKey:@"titleEn"];
        self.url = [coder decodeObjectForKey:@"url"];
        self.normalImageStr = [coder decodeObjectForKey:@"normalImageStr"];
        self.selectedImageStr = [coder decodeObjectForKey:@"selectedImageStr"];
    }
    return self;
}

@end



@implementation YXBaseConfig
//http://111.231.115.83:10011/resource/dict.json?time=1537363607

- (NSString *)versionTime {
    if (!_versionTime) {
        _versionTime = [[_wordBookDict componentsSeparatedByString:@"="] lastObject];
    }
    return _versionTime;
}

- (NSString *)shareLinkOf:(YXSharePalform)paltform {
    NSString *platformStr;
    if (paltform == YXShareWXSession) {
        platformStr  =@"wechat";
    }else if(paltform == YXShareWXTimeLine){
        platformStr = @"moments";
    }else {
        platformStr = @"qq";
    }
    
    NSURL *url = [NSURL URLWithString:_picUrl];
    if (url.query.length) {
        return [NSString stringWithFormat:@"%@&way=%@",_picUrl,platformStr];
    }else {
        return [NSString stringWithFormat:@"%@?way=%@",_picUrl,platformStr];
    }
}

- (void)setExpandTab:(YXExpandTab *)expandTab {
    _expandTab = expandTab;
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"tabBarArray.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (isExists) {
        [fileManager removeItemAtPath:path error:nil];
    }
    NSMutableArray *tabBarList = [NSMutableArray array];
    YXTabBarModel *learnModel = [[YXTabBarModel alloc] init];
    learnModel.titleCh = @"学习";
    learnModel.titleEn = @"main";
    learnModel.selectedImageStr = @"learn_selected";
    learnModel.normalImageStr = @"learn_normal";
    [tabBarList addObject:learnModel];
    YXTabBarModel *challengeModel = [[YXTabBarModel alloc] init];
    challengeModel.titleCh = @"挑战";
    challengeModel.titleEn = @"find";
    challengeModel.selectedImageStr = @"challengeImage_selected";
    challengeModel.normalImageStr = @"challengeImage_normal";
    [tabBarList addObject:challengeModel];
    YXTabBarModel *profileModel = [[YXTabBarModel alloc] init];
    profileModel.titleCh = @"我的";
    profileModel.titleEn = @"user";
    profileModel.selectedImageStr = @"mineImage_selected";
    profileModel.normalImageStr = @"mineImage_normal";
    [tabBarList addObject:profileModel];
    if (![BSUtils isBlankString:expandTab.url]) {
        YXTabBarModel *barModel = [[YXTabBarModel alloc] init];
        barModel.titleCh = @"发现";
        barModel.titleEn = @"browse";
        barModel.url = expandTab.url;
        barModel.selectedImageStr = @"descoverImage_selected";
        barModel.normalImageStr = @"descoverImage_normal";
        [tabBarList insertObject:barModel atIndex:expandTab.order.intValue];
    }
    [NSKeyedArchiver archiveRootObject:tabBarList toFile:path];
}
@end




//#pragma mark -----
//@implementation YXConfigBookModel
//- (BOOL)isLearning {
//    return [self.bookId isEqualToString:[YXConfigure shared].currLearningBookId];
//}
//@end

#pragma mark -----

@implementation YXConfigGradeModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"options" : [YXConfigBookModel class]
             };
}
@end









#pragma mark -----
@implementation YXContentListItem

@end











#pragma mark -----
@implementation YXWordFormModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contentList" : [YXContentListItem class]
             };
}
@end





@implementation YXTaskModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"taskId":@"id"};
}

- (NSString *)timeStr{
    if (!_timeStr) {
        NSString *temStr = nil;
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"YYYY-MM-dd";
        NSDate *today = [NSDate date];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_time];
        NSString *todayStampStr = [format stringFromDate:today];
        NSString *dateStampStr = [format stringFromDate:date];
        if ([todayStampStr isEqualToString:dateStampStr]) {
            temStr = @"今天";
        } else {
            temStr = dateStampStr;
        }
        
        _timeStr = temStr;
    }
    return _timeStr;
}

@end





#pragma mark -----
@implementation YXConfigModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"bookList" : [YXConfigGradeModel class],
             @"wordFrame" : [YXWordFormModel class],
             @"badgeList" : [YXBadgeListModel class],
             @"taskList" : [YXTaskModel class]
             };
}

- (NSMutableDictionary *)badgesDic {
    if (!_badgesDic) {
        _badgesDic = [NSMutableDictionary dictionary];
        for (YXBadgeListModel *groupBadges in _badgeList) {
            for (YXBadgeModel *badgeModel in groupBadges.options) {
                [_badgesDic setObject:badgeModel forKey:badgeModel.badgeId];
            }
        }
    }
    return _badgesDic;
}

- (NSArray *)allBookIds {
    if (!_allBookIds) {
        [self caculateIdNames];
    }
    return _allBookIds;
}

- (NSArray *)allBookNames {
    if (!_allBookNames) {
        [self caculateIdNames];
    }
    return _allBookNames;
}

- (void)caculateIdNames {
    NSMutableArray *bookIds = [NSMutableArray array];
    NSMutableArray *bookNames = [NSMutableArray array];
    for (YXConfigGradeModel *grade in self.bookList) {
        for (YXConfigBookModel *book in grade.options) {
            [bookIds addObject:book.bookId];
            [bookNames addObject:book.name];
        }
    }
    
    _allBookIds = [bookIds copy];
    _allBookNames = [bookNames copy];
}

- (NSString *)getBookNameWithId:(NSString *)bookId {
    NSInteger index = [self.allBookIds indexOfObject:bookId];
    if (index == NSNotFound) {
        return @"";
    }else {
       return [self.allBookNames objectAtIndex:index];
    }
}

- (NSString *)cdn {
    return _baseConfig.cdn;
}

-(void)setCompletedTaskAry:(NSArray *)completedTaskAry {
    _completedTaskAry = completedTaskAry;
    
    if (_completedTaskAry.count) {
        NSMutableArray *taskModels = [NSMutableArray array];
        for (NSString *taskId in _completedTaskAry) {
            for (YXTaskModel *model in _taskList) {
                if (model.taskId == taskId.integerValue) {
                    if (![taskModels containsObject:model]) {
                        [taskModels addObject:model];
                        model.state = 1;
                    }
                }
            }
        }
        _completedTaskModelAry = taskModels;
        [kNotificationCenter postNotificationName:@"refreshCompletedTasks" object:nil];
    }
}

- (NSString *)taskStatusString {
    NSInteger countAll = _taskList.count;
    NSInteger count = 0;
    for (YXTaskModel *model in _taskList) {
        if (model.state != 0) {
            count ++;
        }
    }
    return [NSString stringWithFormat:@"%zd/%zd",count,countAll];
}

@end
