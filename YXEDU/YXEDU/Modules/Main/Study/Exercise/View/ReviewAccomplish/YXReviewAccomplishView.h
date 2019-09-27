//
//  YXReviewAccomplishView.h
//  YXEDU
//
//  Created by jukai on 2019/4/23.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YXReviewAccomplishView;
@protocol YXReviewAccomplishViewDelegate <NSObject>
- (void)reviewAccomplishViewBtn;
@end

@interface YXReviewAccomplishView : UIView

@property (nonatomic, weak) id<YXReviewAccomplishViewDelegate> delegate;

@property (nonatomic, weak) UIButton *goOnBtn;
@property (nonatomic, assign) NSInteger totalQuestionsCount;

+ (YXReviewAccomplishView *)reviewAccomplishShowToView:(UIView *)view delegate:(id<YXReviewAccomplishViewDelegate>)delegate totalQuestionsCount:(NSInteger)totalQuestionsCount;

@end

NS_ASSUME_NONNULL_END
