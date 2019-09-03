//
//  YXStudyBookUnitModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXStudyBookUnitTopicModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *question_id;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *type;
@end

@interface YXStudyBookUnitInfoModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *confusion;
@property (nonatomic, strong) NSString *eng;
@property (nonatomic, strong) NSString *chs;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *paraphrase;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSArray <YXStudyBookUnitTopicModel*>*topic;
@property (nonatomic, strong) NSString *ukvoice;
@property (nonatomic, strong) NSString *usvoice;
@property (nonatomic, strong) NSString *ukphone;
@property (nonatomic, strong) NSString *usphone;
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *wordid;
@end


@interface YXStudyBookUnitModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *checksum;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *unitid;
@property (nonatomic, strong) NSArray *group;
@property (nonatomic, strong) NSArray *group_word_count;
@property (nonatomic, strong) NSArray <YXStudyBookUnitInfoModel*>*unitinfo;
@end
