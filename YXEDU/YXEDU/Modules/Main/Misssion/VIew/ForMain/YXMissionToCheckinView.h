//
//  YXMissionToCheckinView.h
//  YXEDU
//
//  Created by 吉乞悠 on 2019/1/1.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMissionToCheckinView : UIView

@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) NSInteger credits;
@property (nonatomic, weak) UIImageView *douzi;
@property (nonatomic, copy) void(^checkSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
