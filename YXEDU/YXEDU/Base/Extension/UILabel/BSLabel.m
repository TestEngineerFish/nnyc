//
//  FVLabel.m
//  FunVideo
//
//  Created by shiji on 2018/1/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSLabel.h"

@implementation BSLabel

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    _verticalAlignment= verticalAlignment;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (_verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentCenter:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
        default:
            break;
    }
    return textRect;
}
-(void)drawTextInRect:(CGRect)rect {
    if (_verticalAlignment == VerticalAlignmentNone){
        [super drawTextInRect:UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets)];
    }
    else {
        CGRect textRect = [self textRectForBounds:UIEdgeInsetsInsetRect(rect, self.edgeInsets) limitedToNumberOfLines:self.numberOfLines];
        [super drawTextInRect:textRect];
    }
}

@end
