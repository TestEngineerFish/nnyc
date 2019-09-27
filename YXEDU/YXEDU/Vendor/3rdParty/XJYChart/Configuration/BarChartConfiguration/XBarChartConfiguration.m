//
//  XBarChartConfiguration.m
//  XJYChart
//
//  Created by 谢俊逸 on 24/5/2018.
//  Copyright © 2018 JunyiXie. All rights reserved.
//

#import "XBarChartConfiguration.h"

@implementation XBarChartConfiguration
-(instancetype)init {
  if (self = [super init]) {
    self.x_width = 0;
  }
  return self;
}

-(UIColor *)backgroundLayerColor {
    if (!_backgroundLayerColor) {
        _backgroundLayerColor = UIColor.clearColor;
    }
    return _backgroundLayerColor;
}

@end
