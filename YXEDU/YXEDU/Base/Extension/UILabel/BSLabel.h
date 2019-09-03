//
//  FVLabel.h
//  FunVideo
//
//  Created by shiji on 2018/1/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    VerticalAlignmentNone = 0,
    VerticalAlignmentCenter,
    VerticalAlignmentTop,
    VerticalAlignmentBottom
} VerticalAlignment;

@interface BSLabel : UILabel
@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@property (nonatomic) UIEdgeInsets edgeInsets; 
@end
