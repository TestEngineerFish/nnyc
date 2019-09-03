//
//  YXGraphTipThreeViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GraphTipThreeCellType) {
    GraphTipThreeWord,
    GraphTipThreeTranslate,
    GraphTipThreeSentence,
    GraphTipThreeIllustration,
    GraphTipThreeConfusionWord,
};

@interface YXGraphTipThreeViewModel : NSObject
- (GraphTipThreeCellType)rowIdx:(NSInteger)idx;
- (NSInteger)rowCount;
- (float)rowHeight:(NSInteger)idx;
@end
