//
//  YXSpellGuideView.h
//  YXEDU
//
//  Created by jukai on 2019/4/17.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YXSpellGuideView;
@protocol YXSpellGuideViewDelegate <NSObject>
- (void)spellGuideView:(YXSpellGuideView *)spellGuider guideStep:(NSInteger)step;
@end

//选择向导
@interface YXSpellGuideView : UIView
@property (nonatomic, weak) id<YXSpellGuideViewDelegate> delegate;
@property (nonatomic, copy) NSString *spellGuideKey;
+ (YXSpellGuideView *)spellGuideShowToView:(UIView *)view delegate:(id<YXSpellGuideViewDelegate>)delegate;
+ (BOOL)isspellGuideShowedWith:(NSString *)spellKey;
- (void)spellGuideShowed:(NSString *)spellKey;
@end

NS_ASSUME_NONNULL_END
