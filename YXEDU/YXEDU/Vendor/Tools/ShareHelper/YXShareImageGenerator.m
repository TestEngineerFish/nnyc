//
//  YXShareImageGenerator.m
//  lindash
//
//  Created by yao on 2018/12/5.
//  Copyright © 2018年 yao. All rights reserved.
//

#import "YXShareImageGenerator.h"
#import "BSUtils.h"
#import "YXShareLodingView.h"
#import "YXHttpService.h"

//绘制分享图片
@implementation YXShareImageGenerator

+(UIImage *)generateResultImage:(YXPunchModel *)model
                           link:(NSString *)link {

    //背景图片
//    NSString *imagePath =[[NSBundle mainBundle] pathForResource:@"sharePosterResultBG@3x.png" ofType:nil];
//    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    NSString *imageStr = [kUserDefault objectForKey:@"shareBgImage"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
    CGSize size = CGSizeMake(375.f, 667.f);
    //1125 × 2001
//    UIGraphicsBeginImageContext(image.size); // 绘制文字模糊
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *todayImg = [UIImage imageNamed:@"打卡日期底块"];
    [todayImg drawInRect:CGRectMake(7.0, 19.0, 94.0, 40)];
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *datyTime = [formatter stringFromDate:[NSDate date]];
    
    
    NSMutableDictionary *datyTimeAttri = [NSMutableDictionary dictionary];
    [datyTimeAttri setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [datyTimeAttri setValue:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    CGRect datyTimeRect = CGRectMake(27, 21, 60, 14);
    [datyTime drawInRect:datyTimeRect withAttributes:datyTimeAttri];
    
    NSMutableDictionary *noteAttri = [NSMutableDictionary dictionary];
    [noteAttri setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [noteAttri setValue:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    NSString *note = @"我在念念有词背单词";
    CGRect noteRect = CGRectMake(25, 107, 155, 20);
    [note drawInRect:noteRect withAttributes:noteAttri];
    
    //第20天 第几天
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"第%@天",model.days]];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"第"].location + 1;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@"天"].location;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, noteStr.length)];
    
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:NSMakeRange(0, noteStr.length)];
    
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50.0] range:range];
    
    [noteStr drawAtPoint:CGPointMake(245, 75)];
    
    
    CGFloat textMargin = 30;
    CGFloat textWidth = size.width - textMargin * 2;
    
    NSMutableDictionary *sayingAttri = [NSMutableDictionary dictionary];
    [sayingAttri setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [sayingAttri setValue:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    NSString *saying = model.eng;
    
    CGFloat sayHight = [saying boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:sayingAttri
                                            context:nil].size.height;
    CGRect sayRect = CGRectMake(textMargin, 300, textWidth, sayHight);
    [saying drawInRect:sayRect withAttributes:sayingAttri];
    
    NSString *tranlate = model.chs;//@"火对金子是考验，逆境对人是磨练。";
    [sayingAttri setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [sayingAttri setValue:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    CGFloat tranlateHight = [tranlate boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:sayingAttri
                                            context:nil].size.height;
    CGFloat tranlateY = CGRectGetMaxY(sayRect) + 15;
    CGRect tranlateRect = CGRectMake(textMargin, tranlateY, textWidth, tranlateHight);
    [tranlate drawInRect:tranlateRect withAttributes:sayingAttri];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentRight;
    [sayingAttri setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    
    CGFloat margin = 16;
    CGFloat width = size.width - 2 * margin;
    
    UIImage *dataBGImg = [UIImage imageNamed:@"打卡分享页数据底块"];
    [dataBGImg drawInRect:CGRectMake(10, 138, 355, 150)];
    
    
    NSURL *url = [NSURL URLWithString:model.cover];// 获取的图片地址
    if (![BSUtils isBlankString:url.absoluteString]) {
        UIImage *userImg  = [UIImage imageNamed:@"placeholder"];
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(28, 28), NO, 0.0);
        // 获得图形上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 设置一个范围
        CGRect rect = CGRectMake(0, 0, 28, 28);
        // 根据radius的值画出路线
        CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:14.0].CGPath);
        // 裁剪
        CGContextClip(ctx);
        // 将原照片画到图形上下文
        [userImg drawInRect:rect];
        // 从上下文上获取剪裁后的照片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
        
        [newImage drawInRect:CGRectMake(70, 162, 28, 28)];
    }
    else{
        UIImage *userImg = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; // 根据地址取出图片
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(28, 28), NO, 0.0);
        // 获得图形上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 设置一个范围
        CGRect rect = CGRectMake(0, 0, 28, 28);
        // 根据radius的值画出路线
        CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:14.0].CGPath);
        // 裁剪
        CGContextClip(ctx);
        // 将原照片画到图形上下文
        [userImg drawInRect:rect];
        // 从上下文上获取剪裁后的照片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
        
        [newImage drawInRect:CGRectMake(70, 162, 28, 28)];
    }
    
    NSString *carrerStr = [NSString stringWithFormat:@"\"%@\"%@",model.userName,@"的生涯数据"];
    NSMutableDictionary *carrerStrAttri = [NSMutableDictionary dictionary];
    [carrerStrAttri setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [carrerStrAttri setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    paragraph.alignment = NSTextAlignmentLeft;
    [carrerStrAttri setObject:paragraph forKey:NSParagraphStyleAttributeName];
    [carrerStr drawAtPoint:CGPointMake(106, 170) withAttributes:carrerStrAttri];
    //分割线-横
    UIImage *horizontalImg = [UIImage imageNamed:@"分割线-横"];
    [horizontalImg drawInRect:CGRectMake(37, 205, 302, 0.5)];
    
    UIImage *VerticalImg = [UIImage imageNamed:@"分割线-竖"];
    [VerticalImg drawInRect:CGRectMake(187, 215, 1, 46)];
    
    NSDictionary *tipsAttri = @{
                                NSFontAttributeName : [UIFont systemFontOfSize:12],
                                NSForegroundColorAttributeName : UIColorOfHex(0x79899D)
                                };
    NSString *todayLearnedWordTips = @"今日学习单词";
    CGFloat tipsHeight = 13;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:tipsAttri];
    paragraph.alignment = NSTextAlignmentCenter;
    [dic setObject:paragraph forKey:NSParagraphStyleAttributeName];
    CGRect leftRect = CGRectMake(margin, 219, width * 0.5, tipsHeight);
    [todayLearnedWordTips drawInRect:leftRect withAttributes:dic];
    
    
    NSString *studyDaysTips = @"累计学习单词";
    CGRect rightRect = leftRect;//CGRectMake(size.width * 0.5, 394, width * 0.5, tipsHeight);
    rightRect.origin.x = size.width * 0.5;
    [studyDaysTips drawInRect:rightRect withAttributes:dic];
    
    NSMutableDictionary *todayNumberAttri = [NSMutableDictionary dictionary];
    [todayNumberAttri setObject:[UIFont systemFontOfSize:28] forKey:NSFontAttributeName];
    [todayNumberAttri setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [todayNumberAttri setObject:paragraph forKey:NSParagraphStyleAttributeName];
    NSString *todayNumberStr = [NSString stringWithFormat:@"%ld",model.todayLearned];
    [todayNumberStr drawInRect:CGRectMake(margin, 235, width*0.5, 28) withAttributes:todayNumberAttri];
    
    NSMutableDictionary *addupNumberAttri = [NSMutableDictionary dictionary];
    [addupNumberAttri setObject:[UIFont systemFontOfSize:28] forKey:NSFontAttributeName];
    [addupNumberAttri setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [addupNumberAttri setObject:paragraph forKey:NSParagraphStyleAttributeName];
    NSString *addupNumberStr = [NSString stringWithFormat:@"%@",model.learned];
    [addupNumberStr drawInRect:CGRectMake(size.width * 0.5, 235, width*0.5, 28) withAttributes:addupNumberAttri];
    
    
//    UIImage *songshuBgImg =  [UIImage imageNamed:@"分享海报配图"];
//    [songshuBgImg drawInRect:CGRectMake(0, size.height - 230.0, size.width, 287.0)];

    NSString *appName = @"念念有词";
    NSDictionary *attri = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:18],
                           NSForegroundColorAttributeName : [UIColor blackColor]
                           };
    CGPoint markPoint = CGPointMake(42, 580);
    [appName drawAtPoint:markPoint withAttributes:attri];
    
    NSString *slogan = @"念念不忘背单词";
    NSDictionary *sloganAttri = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:16],
                            NSForegroundColorAttributeName : UIColorOfHex(0x79899D)
                            };
    
    markPoint = CGPointMake(42, 605);
    [slogan drawAtPoint:markPoint withAttributes:sloganAttri];
    
//    NSString *tips = @"长按识别二维码下载";
//    CGPoint tipsPoint = CGPointMake(42, 637);
//    [tips drawAtPoint:tipsPoint withAttributes:tipsAttri];

    UIImage *longPressIcon = [UIImage imageNamed:@"Share长按识别"];
    [longPressIcon drawInRect:CGRectMake(41, 631, 145, 18)];
    
    UIImage *qrcode = [self generatorQRCodeImageWith:link];
    CGRect qrcodeRect = CGRectMake(251, size.height-13.0-86.0, 86, 86);
    [qrcode drawInRect:qrcodeRect];
    
    UIImage *icon = [UIImage imageNamed:@"miniIcon"];
    [icon drawInRect:CGRectMake(282, 598, 23, 23)];
    
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImage;
}

//+ (UIImage *)generateBadgeImage {
+ (UIImage *)generateBadgeImage:(UIImage *)badgeImage
                          title:(NSString *)title
                           date:(NSString *)date
                    describtion:(NSString *)des
                           link:(NSString *)link
{

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    [attri setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attri setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSString *imagePath =[[NSBundle mainBundle] pathForResource:@"shareBadgeBG@2x.png" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    CGSize size = image.size;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
//    UIImage *badgeImage = [UIImage imageNamed:@""];
    [badgeImage drawInRect:CGRectMake(129, 209, 118, 118)];
    
//    UIBezierPath *badgePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(129, 209, 118, 118) cornerRadius:3];
//    [[UIColor whiteColor] setFill];
//    [badgePath fill];
    [attri setValue:[UIFont systemFontOfSize:21] forKey:NSFontAttributeName];
    [title drawInRect:CGRectMake(0, 347, size.width, 22) withAttributes:attri];
    
    CGRect desRect = CGRectMake(0, 385, size.width, 15);
    if (date) {
        desRect = CGRectMake(0, 404, size.width, 40);
        [attri setValue:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
        [attri setObject:UIColorOfHex(0xB0B7F3) forKey:NSForegroundColorAttributeName];
        [date drawInRect:CGRectMake(0, 380, size.width, 12) withAttributes:attri];
    }
    [attri setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attri setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [des drawInRect:desRect withAttributes:attri];
    
    NSString *appName = @"念念有词";
    paragraph.alignment = NSTextAlignmentLeft;
    [attri setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    CGPoint markPoint = CGPointMake(22, 526);
    [appName drawAtPoint:markPoint withAttributes:attri];
    
    NSString *slogan = @"念念不忘背单词";
    markPoint = CGPointMake(22, 549);
    [slogan drawAtPoint:markPoint withAttributes:attri];
    
    NSString *tips = @"长按识别二维码下载";
    CGPoint tipsPoint = CGPointMake(22, 573);
    [attri setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [tips drawAtPoint:tipsPoint withAttributes:attri];
    
    CGRect qrcodeRect = CGRectMake(278, 504, 83, 83);
    UIBezierPath *qrBgPath = [UIBezierPath bezierPathWithRoundedRect:qrcodeRect cornerRadius:3];
    [[UIColor whiteColor] setFill];
    [qrBgPath fill];
    UIImage *qrcode = [self generatorQRCodeImageWith:link];
    [qrcode drawInRect:CGRectInset(qrcodeRect, 2, 2)];
    
    UIImage *icon = [UIImage imageNamed:@"miniIcon"];
    [icon drawInRect:CGRectMake(312.5, 538.5, 20, 20)];
    
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImage;
}

+ (UIImage *)generatorQRCodeImageWith:(NSString *)info {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
//    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:79];
}


+ (UIImage *)generatorQRCodeImageWith:(NSString *)info withSize:(CGFloat)qrWH {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    //    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    qrWH = qrWH ? qrWH : 79;
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:qrWH];
}


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage *hdQrcode = [UIImage imageWithCGImage:scaledImage];
    return hdQrcode;
}
@end
