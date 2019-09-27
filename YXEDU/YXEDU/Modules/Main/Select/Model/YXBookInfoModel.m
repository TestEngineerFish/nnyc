//
//  YXBookInfoModel.m
//  YXEDU
//
//  Created by yao on 2018/10/18.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookInfoModel.h"


@implementation YXBookInfoModel
- (BOOL)isLearning {
    return [self.bookId isEqualToString:[YXConfigure shared].currLearningBookId];
}
@end
//"bookId": "1",
//"bookName":"词书名称",
//"cover":"词书封面地址",
//"learnedStatus":false,    //词书的是否学过，false表示未学，true表示学过
//"wordCount":"234",    //词书具有的单词个数
//"learnedCount":"0",    //已经学习的单词个数
//"planNum":"12" ,      //用户设置的计划个数
//"unitNum":"12"       //词书具有的单元个数
