//
//  YXPersonalCenterModel.h
//  YXEDU
//
//  Created by Jake To on 10/13/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPersonalCenterCellModel : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rightDetail;

@property (nonatomic, assign) BOOL isShowAccessory;
@property (nonatomic, assign) BOOL isShowBottomLine;

@end

NS_ASSUME_NONNULL_END
