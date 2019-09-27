//
//  YXMyPreGradeModel.h
//  YXEDU
//
//  Created by yao on 2019/1/9.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXRankBaseInfo.h"

//"myGrades":{
//    "state":2,//1:本期尚未完成单词挑战2:当期内学习计划已完成，未完成挑战3:挑战完成后——失败4挑战完成后——成功
//    "avatar":"http://thirdqq.qlogo.cn/qqapp/101475072/BCE0B0E072C6181F6D0D7907018F4C81/100", //头像
//    "userCredits":150,//用户当前积分
//    "desc":{ //state=4有返回值，否则为{}
//        "nick":"用户1231****123", //用户名
//        "speedTime":120  //耗时
//        "correctNum":12  //正答数
//        "ranking":16    //排名 200名以内返回排名，200名外返回0
//    }
//},


//"myGrades":{
//    "ranking":16    //排名
//    "nick":"用户1231****123", //用户名
//    "speedTime":66  //耗时
//    "correctNum":12  //正答数
//    "avatar":"http://thirdqq.qlogo.cn/qqapp/101475072/BCE0B0E072C6181F6D0D7907018F4C81/100", //头像
//    "userCredits" :200    //获取积分
//    "state": 1    //1:挑战成功 2：挑战失败 3：没有参加挑战
//},
@interface YXMyPreGradeModel : YXRankBaseInfo
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger userCredits;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) UIImage *acrIcon;
@end
