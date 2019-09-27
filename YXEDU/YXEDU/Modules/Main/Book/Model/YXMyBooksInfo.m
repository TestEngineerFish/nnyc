

//
//  YXMyBooksInfo.m
//  YXEDU
//
//  Created by yao on 2018/10/19.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMyBooksInfo.h"
@implementation YXStudyBookModel

//- (BOOL)isMaterialDownLoad {
//    return NO;
//}

- (NSString *)resPath {
    NSString *cdn = [YXConfigure shared].confModel.baseConfig.cdn;
    if (cdn) {
        return [NSString stringWithFormat:@"%@/%@",cdn,self.resUrl];
    }else {
        return @"";
    }
}

//- (YXBookMaterialState)materialState {
//    if (_materialState == kBookMaterialDownloading) {
//        return _materialState;
//    }else {
//        return 0;
//    }
//}


@end

@implementation YXMyBooksInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"learned" : [YXStudyBookModel class]};
}
@end
