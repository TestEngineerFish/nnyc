//
//  YXGraphTipThreeViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphTipThreeViewModel.h"
#import "YXStudyCmdCenter.h"
#import "NSString+YR.h"
#import "BSCommon.h"
#import "NSString+YX.h"
#import "YXConfigure.h"
#import "YXStudyBookUnitModel.h"
#import "YXUtils.h"
#import <UIKit/UIKit.h>

@interface YXGraphTipThreeViewModel ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation YXGraphTipThreeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr = [NSMutableArray array];
        [self configure];
    }
    return self;
}

- (void)configure {
    [self.dataArr removeAllObjects];
    [self.dataArr addObject:@(GraphTipThreeWord)];
    [self.dataArr addObject:@(GraphTipThreeTranslate)];
    [self.dataArr addObject:@(GraphTipThreeSentence)];
    
    YXStudyBookUnitModel *unitModel = [YXConfigure shared].bookUnitModel;
    NSString *name = [[unitModel.bookid DIR:unitModel.unitid]DIR:unitModel.filename];
    NSString *resourcePath = [[YXUtils resourcePath]DIR:name];
    NSString *filePath = [resourcePath DIR:[YXStudyCmdCenter shared].curUnitInfo.image];
    NSData *data = [YXUtils fileData:filePath];
    if (data.length) {
        [self.dataArr addObject:@(GraphTipThreeIllustration)];
    }
    if ([YXStudyCmdCenter shared].curUnitInfo.confusion.length) {
        [self.dataArr addObject:@(GraphTipThreeConfusionWord)];
    }
}

- (GraphTipThreeCellType)rowIdx:(NSInteger)idx {
    return [self.dataArr[idx] integerValue];
}

- (NSInteger)rowCount {
    return self.dataArr.count;
}

- (float)rowHeight:(NSInteger)idx {
    GraphTipThreeCellType cellType = [self rowIdx:idx];
    switch (cellType) {
        case GraphTipThreeWord:
            return 95;
        case GraphTipThreeTranslate: {
            CGSize translateLabSize = [[YXStudyCmdCenter shared].curUnitInfo.paraphrase sizeWithMaxWidth:SCREEN_WIDTH-97 font:[UIFont systemFontOfSize:16]];
            return translateLabSize.height + 69;
        }
        case GraphTipThreeSentence: {
            NSString *strEng = [YXStudyCmdCenter shared].curUnitInfo.eng;
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[strEng dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            CGSize engSize = [attrStr.string sizeWithMaxWidth:SCREEN_WIDTH-97 font:[UIFont systemFontOfSize:18]];
            CGSize tranSize = [[YXStudyCmdCenter shared].curUnitInfo.chs sizeWithMaxWidth:SCREEN_WIDTH-97 font:[UIFont systemFontOfSize:16]];
            return 31+engSize.height + tranSize.height;
        }
            
        case GraphTipThreeIllustration:
            return 174;
        case GraphTipThreeConfusionWord:
            return 139;
        default:
            break;
    }
    return 0;
}



@end
