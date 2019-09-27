//
//  YXPinkProgressView.m
//  YXEDU
//
//  Created by Jake To on 10/30/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXPinkProgressView.h"

@implementation YXPinkProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressImage = [UIImage imageNamed:@"gradient_layer_view"];
        self.trackTintColor = UIColorOfHex(0xEEF1F3);
    }
    return self;
}


@end
