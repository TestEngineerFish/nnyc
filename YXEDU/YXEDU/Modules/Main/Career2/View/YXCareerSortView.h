//
//  YXCareerSortView.h
//  YXEDU
//
//  Created by yixue on 2019/2/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCareerModel.h"

NS_ASSUME_NONNULL_BEGIN

@class YXCareerSortView;

@protocol YXCareerSortViewDelegate <NSObject>

- (void)careerSortViewDidChangeSort:(YXCareerSortView *)careerSortView sortIndex:(NSInteger)index;

@end

@interface YXCareerSortView : UIView

@property (nonatomic, weak) id<YXCareerSortViewDelegate> delegate;

@property (nonatomic, strong) YXCareerModel *careerModel;

@end

NS_ASSUME_NONNULL_END
