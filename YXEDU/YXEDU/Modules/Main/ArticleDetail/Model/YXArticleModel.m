//
//  YXArticleModel.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleModel.h"

@implementation YXArticleTypeModel

@end

@implementation YXArticleModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"content" : [YXArticleTypeModel class]
             };
}
@end

@implementation YXArticleSubtitleModel

@end

@implementation YXArticleSentenceModel

@end

@implementation YXArticleSectionModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"sentence" : [YXArticleSentenceModel class]
             };
}
@end

@implementation YXArticleImageModel

@end

@implementation YXArticleDialogModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"sentence" : [YXArticleSentenceModel class]
             };
}
@end

@implementation YXKeyPointWordModel

@end

@implementation YXKeyPointPhraseModel

@end

@implementation YXKeyPointModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"word" : [YXKeyPointWordModel class],
             @"phrase" : [YXKeyPointPhraseModel class]
             };
}

@end
