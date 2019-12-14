//
//  YXShareHelper.h
//  YXEDU
//
//  Created by yao on 2018/12/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXPunchModel.h"
#import "YXShareImageGenerator.h"
@interface YXShareHelper : NSObject
+ (void)shareImage:(UIImage *)image
        toPaltform:(YXSharePalform)platform
             title:(NSString *)title
      describution:(NSString *)desc
     shareBusiness:(NSString *)shareBusiness;;

+ (void)shareResultToPaltform:(YXSharePalform)platform
                   punchModel:(YXPunchModel *)punchModel;

+(void)shareBageImageToPaltform:(YXSharePalform)platform
                     badgeImage:(UIImage *)badgeImage
                          title:(NSString *)title
                           date:(NSString *)date
                    describtion:(NSString *)desc;


//+(void)shareGameImageToPaltform:(YXSharePalform)platform
//                     gameResult:(YXGameResultModel *)gameResult;
@end

