//
//  YXMyWordBookListBlankView.h
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordBookActionProtocol.h"
NS_ASSUME_NONNULL_BEGIN
//@class YXMyWordBookListBlankView;
//@protocol YXMyWordBookListBlankViewDelegate <NSObject>
//- (void)myWordBookListBlankViewCreateAction:(YXMyWordBookListBlankView *)blankView;
//- (void)myWordBookListBlankViewShareAction:(YXMyWordBookListBlankView *)blankView;;
//@end

@interface YXMyWordBookListBlankView : UIView
@property (nonatomic, weak) id<YXMyWordBookActionProtocol> delegate;
- (instancetype)initWithDelegate:(id<YXMyWordBookActionProtocol>)delegate;
@end

NS_ASSUME_NONNULL_END
