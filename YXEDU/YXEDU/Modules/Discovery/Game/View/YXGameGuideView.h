//
//  YXGameGuideView.h
//  YXEDU
//
//  Created by yao on 2019/1/3.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXGameGuideView;
@protocol YXGameGuideViewDelegate <NSObject>
- (void)gameGuideView:(YXGameGuideView *)gameGuider guideStep:(NSInteger)step;

@end
//游戏向导图GuideView
@interface YXGameGuideView : UIView
@property (nonatomic, weak) id<YXGameGuideViewDelegate> delegate;
@property (nonatomic, copy) NSString *gameGuideKey;
+ (YXGameGuideView *)gameGuideShowToView:(UIView *)view delegate:(id<YXGameGuideViewDelegate>)delegate;
+ (BOOL)isGameGuideShowedWith:(NSString *)gameKey;
- (void)gameGuideShowed:(NSString *)gameKey;
@end

