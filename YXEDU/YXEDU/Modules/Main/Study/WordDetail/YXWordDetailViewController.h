//
//  YXWordDetailViewController.h
//  YXEDU
//
//  Created by yao on 2018/10/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXCareerWordInfo.h"
@interface YXWordDetailViewController : BSRootVC
+ (YXWordDetailViewController *)wordDetailWith:(YXWordDetailModel *)wordDetailModel
                                        bookId:(NSString *)bookId;

+ (YXWordDetailViewController *)wordDetailWith:(YXWordDetailModel *)wordDetailModel
                                        bookId:(NSString *)bookId
                                 withBackBlock:(void(^)(void))backActionBlock;

@property (nonatomic, strong) YXWordDetailModel *wordDetailModel;
@property (nonatomic, copy)NSString *bookId;
@property (nonatomic, strong) YXCareerWordInfo *careerWordInfo;
@property (nonatomic, assign) BOOL isFavWord;
@property (nonatomic, copy)NSString *backTitle;
@property (nonatomic, assign) BOOL isExercise;//标记是否在学习流程中
@end

