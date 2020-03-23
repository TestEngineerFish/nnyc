//
//  YXShareHelper.m
//  YXEDU
//
//  Created by yao on 2018/12/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXShareHelper.h"
#import "QQApiManager.h"
#import "WXApiManager.h"
@implementation YXShareHelper

+ (void)shareResultToPaltform:(YXSharePalform)platform
                   punchModel:(YXPunchModel *)punchModel
{
    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platform];
    UIImage *shareImage = [YXShareImageGenerator generateResultImage:punchModel link:picUrl];
    if (picUrl && shareImage && punchModel) {
        [self shareImage:shareImage
              toPaltform:platform
                   title:nil
            describution:nil
         shareBusiness:kSharePunch];
    }
}

+ (void)shareBageImageToPaltform:(YXSharePalform)platform
                      badgeImage:(UIImage *)badgeImage
                           title:(NSString *)title
                            date:(NSString *)date
                     describtion:(NSString *)desc
{
    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platform];
    UIImage *shareImage = [YXShareImageGenerator generateBadgeImage:badgeImage
                                                              title:title
                                                               date:date
                                                        describtion:desc
                                                               link:picUrl];
    if (badgeImage && picUrl && shareImage) {
        [self shareImage:shareImage
              toPaltform:platform
                   title:title
            describution:desc
         shareBusiness:kShareBadge];
    }
}

//+ (void)shareGameImageToPaltform:(YXSharePalform)platform gameResult:(YXGameResultModel *)gameResult {
//    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platform];
//    UIImage *shareImage = [YXShareImageGenerator generateBadgeImage:badgeImage
//                                                              title:title
//                                                               date:date
//                                                        describtion:desc
//                                                               link:picUrl];
//    if (badgeImage && picUrl && shareImage) {
//        [self shareImage:shareImage
//              toPaltform:platform
//                   title:title
//            describution:desc
//           shareBusiness:kShareBadge];
//    }
//}

+ (void)shareImage:(UIImage *)image
        toPaltform:(YXSharePalform)platform
             title:(NSString *)title
      describution:(NSString *)desc
     shareBusiness:(NSString *)shareBusiness
{
    if (platform == YXShareQQ) {

        [[QQApiManager shared] shareImage:image
                               toPaltform:platform
                                    title:title
                             describution:desc
                            shareBusiness:shareBusiness];
    }else {
        [[WXApiManager shared] shareImage:image
                               toPaltform:platform
                                    title:title
                             describution:desc
                            shareBusiness:shareBusiness];
    }
}


@end



//#import "WXApi.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/QQApiInterfaceObject.h>


//        NSData *oriData = UIImageJPEGRepresentation(image, 0.8);
//        NSData *thumData = UIImageJPEGRepresentation(image, 0.5);
//
//        QQApiImageObject *imageObj = [QQApiImageObject objectWithData:oriData
//                                                     previewImageData:thumData
//                                                                title:title
//                                                          description:desc];
//        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObj];
//        QQApiSendResultCode retCode = [QQApiInterface sendReq:req];
//        YXLog(@"%d",retCode);


//        WXImageObject *imageObj = [WXImageObject object];
//
//        imageObj.imageData = UIImageJPEGRepresentation(image, 0.8);
//        WXMediaMessage *message = [WXMediaMessage message];
//        message.mediaObject = imageObj;
//        message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
//
//        SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
//        sentMsg.message = message;
//        sentMsg.bText = NO;
//        sentMsg.scene = (platform == YXShareWXSession) ? WXSceneSession : WXSceneTimeline;
//
//        [WXApi sendReq:sentMsg];
