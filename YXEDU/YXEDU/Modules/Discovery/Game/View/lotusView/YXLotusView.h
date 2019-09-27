//
//  YXLotusView.h
//  YXEDU
//
//  Created by yao on 2019/1/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXLotusState) {
    YXLotusStateNormal,
    YXLotusStateSelect,
    YXLotusStateCorrect,
    YXLotusStateError
};

//#define kNormalLotusWidth AdaptSize(92.5)
//#define kNormalLotusHeight AdaptSize(75.5)
#define kNormalLotusSize MakeAdaptCGSize(92.5, 75.5)
#define kUnNormalLotusSize MakeAdaptCGSize(108, 88)
//#define kUnNormalLotusWidth AdaptSize(108)
//#define kUnNormalLotusHeight AdaptSize(88)

#define kCharacterFont AdaptSize(40)



@interface YXCenterLabel : UILabel
@property(nonatomic, assign) UIEdgeInsets edgeInsets;
@end



@interface YXLotusView : UIView
@property (nonatomic, weak) YXCenterLabel *characterLabel;
@property (nonatomic, weak) UIImageView *lotusIcon;
@property (nonatomic, assign) YXLotusState state;
@property (nonatomic, copy) NSString *character;
@end
