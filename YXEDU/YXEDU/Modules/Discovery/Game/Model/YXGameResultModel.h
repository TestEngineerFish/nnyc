//
//  YXGameResultModel.h
//  YXEDU
//
//  Created by yao on 2019/1/4.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
//
//"state": 1    //1:挑战成功 2：挑战失败 3：挑战错过时间
//'avatar':'http://thirdqq.qlogo.cn/qqapp/101475072/BCE0B0E072C6181F6D0D7907018F4C81/100',
//"rightNum":10,   //答对题数
//"answerTime":120, //答题耗时 秒
//"ranking":16,      //排名 200名以内返回排名，200名外返回0
@interface YXGameResultModel : NSObject
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *rightNum;
@property (nonatomic, assign) NSInteger answerTime;
@property (nonatomic, assign) NSInteger ranking;
@property (nonatomic, copy) NSString *rankingString;
@property (nonatomic, copy) NSString *answerTimeString;
@property (nonatomic, strong) UIImage *userIcon;
@end

