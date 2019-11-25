//
//  YXBadgeTypeModel.h
//  YXEDU
//
//  Created by yao on 2018/10/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

//"title": "行动力徽章",
//"type": 1,   //徽章类型，1表示学习能力，2表示行动能力，3表示藏金阁，4表示毅力徽章
//"options": [
//            {
//                "badgeId": "6",
//                "badgeName": "初来乍到",
//                "realize": "http://111.231.115.83:10011/resource/badge/badge2.png", //获取徽章状态的图片地址
//                "unRealized": "http://111.231.115.83:10011/resource/badge/badge1.png", //未获取徽章状态的图片地址
//                "desc": "完成一次打卡"
//            }
//            ]

typedef NS_ENUM(NSUInteger, YXBadgeType) {
    YXBadgeTypeStudyAbility = 1,
    YXBadgeTypeExecution,
    YXBadgeTypeCollection,
    YXBadgeTypeWillpower
};

@interface YXBadgeModelOld : NSObject
@property (nonatomic, copy)NSString *badgeId;
@property (nonatomic, copy)NSString *badgeName;
@property (nonatomic, copy)NSString *realize;
@property (nonatomic, copy)NSString *unRealized;
@property (nonatomic, copy)NSString *desc;
@end


@interface YXBadgeListModelOld : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, strong)NSMutableArray *options;
@end

