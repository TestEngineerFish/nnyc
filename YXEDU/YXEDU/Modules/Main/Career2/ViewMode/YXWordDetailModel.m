//
//  YXWordDetailModel.m
//  YXEDU
//
//  Created by yao on 2018/10/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordDetailModel.h"

//@implementation YXMemoryKeyModel
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{
//             @"content" : @"YXMemoryKeyContentModel"
//             };
//}
//@end
//
//@implementation YXExamKeyModel
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{
//             @"content" : @"YXExamKeyContentModel"
//             };
//}
//@end



@implementation YXWordDetailModel
- (NSString *)explainText {
    if (!_explainText) {
        _explainText = [NSString stringWithFormat:@"%@%@",_property,_paraphrase];
    }
    return _explainText;
}

- (NSString *)materialPath {
    YXConfigModel *configModel = [YXConfigure shared].confModel;
    NSString *cdn = configModel.baseConfig.cdn;
    NSString *materialPath = [NSString stringWithFormat:@"%@%@",cdn,self.curMaterialSubPath];
    return materialPath;
}

- (NSString *)curMaterialSubPath {
    return ([YXConfigure shared].confModel.baseConfig.speech ? self.usvoice : self.ukvoice);
}

- (BOOL)hasImage {
    NSString *pathEx = [_image pathExtension];
    return _image.length && [_image pathExtension].length;
}
//- (NSMutableDictionary *)wordDetailDict {
//    if (!_wordDetailDict) {
//        _wordDetailDict = [self mj_keyValues];
//    }
//    return _wordDetailDict;
//}

//- (NSMutableAttributedString *)getAttributedValueForKey:(NSString *)key {
//    NSString *attriKey = [NSString stringWithFormat:@"%@Attri",key];
//    NSMutableAttributedString *attriStr = [self.wordDetailDict objectForKey:attriKey];
//    if (!attriStr) {
//        NSString *text = [self.wordDetailDict objectForKey:key];
//        attriStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
//        NSRange range = NSMakeRange(0, attriStr.length);
//        // 设置字体大小
//        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
//        [self.wordDetailDict setObject:attriStr forKey:attriKey];
//    }
//
//    return attriStr;
//}
@end
