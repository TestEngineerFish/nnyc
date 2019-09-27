//
//  YXNNCareerView.h
//  YXEDU
//
//  Created by yao on 2018/11/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YXNNCareerButton : YXNoHightButton
@property (nonatomic, copy)NSString *tips;
@property (nonatomic, copy)NSString *number;
@end

@interface YXNNCareerView : UIView
@property (nonatomic, copy)void(^careerViewClickedBlock)(NSInteger index);
@property (nonatomic,readonly, strong) YXNNCareerButton *haveLearnBtn;
@property (nonatomic, readonly, strong) YXNNCareerButton *collectionbtn;
@property (nonatomic, readonly, strong) YXNNCareerButton *wrongBookbtn;
@end
