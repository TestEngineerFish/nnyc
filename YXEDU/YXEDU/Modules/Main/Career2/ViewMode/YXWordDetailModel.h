//
//  YXWordDetailModel.h
//  YXEDU
//
//  Created by yao on 2018/10/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

//chs = "\U4f60\U6709\U8fd9\U4e48\U4e00\U4e2a\U597d\U7684\U673a\U4f1a\U3002";
//confusion = "";
//eng = "You have such a <font color='#55a7fd'>good</font> chance.";
//image = "/res/rj_1//image/good_image.jpg";
//morph = "";
//paraphrase = "\U597d\U7684";
//property = "adj.";
//speech = "/speech/a00c5c2830ffc50a68f820164827f356.mp3";
//synonym = "";
//ukphone = "\U82f1/g\U028ad/";
//ukvoice = "/res/rj_1/voice/good_uk.mp3";
//usage = "";
//usphone = "\U7f8e/\U0261\U028ad/";
//usvoice = "/res/rj_1/voice/good_us.mp3";
//word = good;
//"word_root" = "";
//wordid = 1;
//
//@interface YXMemoryKeyContentModel : NSObject
//@property (nonatomic, copy)NSString *title;
//@property (nonatomic, copy)NSString *content;
//@end
//
//@interface YXMemoryKeyModel : NSObject
//@property (nonatomic, copy)NSString *memoryKey;
//@property (nonatomic, strong)NSArray *content;
//@end
//
//@interface YXExamKeyContentModel : NSObject
//@property (nonatomic, copy)NSString *fre;
//@property (nonatomic, copy)NSString *totalFre;
//@property (nonatomic, copy)NSString *title;
//@property (nonatomic, copy)NSString *content;
//@end
//
//@interface YXExamKeyModel : NSObject
//@property (nonatomic, copy)NSString *star;
//@property (nonatomic, strong)NSArray *content;
//@end
//
//
//@interface YXToolkitModel : NSObject
//@property (nonatomic, strong)YXMemoryKeyModel *memoryKey;
//@property (nonatomic, strong)YXExamKeyModel *examKey;
//
//@end


@interface YXWordDetailModel : NSObject
@property (nonatomic, strong) NSString *wordid ;
@property (nonatomic, strong) NSString *meanings;
@property (nonatomic, strong) NSString *word_root ;
@property (nonatomic, strong) NSString *word ;
@property (nonatomic, strong) NSString *usvoice;
@property (nonatomic, strong) NSString *usphone;
@property (nonatomic, strong) NSString *usage;
@property (nonatomic, strong) NSString *ukvoice;
@property (nonatomic, strong) NSString *ukphone;
@property (nonatomic, strong) NSString *synonym;
/** 例句发音 */
@property (nonatomic, strong) NSString *speech;
/** 词性 */
@property (nonatomic, strong) NSString *property;
/** 翻译 */
@property (nonatomic, strong) NSString *paraphrase;
@property (nonatomic, strong) NSString *morph ;
/** 单词图片 */
@property (nonatomic, strong) NSString *image ;
/** 英文例句 */
@property (nonatomic, strong) NSString *eng ;
@property (nonatomic, strong) NSString *confusion ;
/** 中文例句 */
@property (nonatomic, strong) NSString *chs;
/** 反义词 */
@property (nonatomic, strong) NSString *antonym;
@property (nonatomic, assign) BOOL hasImage;

@property (nonatomic, copy)NSString *explainText;
@property (nonatomic, copy)NSString *materialPath;
@property (nonatomic, copy)NSString *curMaterialSubPath;
@property (nonatomic, assign)BOOL isFav;
//工具包
@property (nonatomic,copy)NSString *toolkit;

@property (nonatomic, copy)NSString *bookId;

//@property (nonatomic, copy)NSMutableDictionary *wordDetailDict;
//- (NSMutableAttributedString *)getAttributedValueForKey:(NSString *)key;
@end

