//
//  YXSpellView.h
//  1111
//
//  Created by yao on 2018/10/31.
//  Copyright © 2018年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXSpellView;
@protocol YXSpellViewDelegate <NSObject>
- (void)spellView:(YXSpellView *)spellView complate:(BOOL)complate;
- (void)spellView:(YXSpellView *)spellView canCheck:(BOOL)canCheck;
@end

@interface YXSpellView : UIView
@property (nonatomic, weak)id<YXSpellViewDelegate> delegate;
@property (nonatomic, readonly, copy)NSString *oriWord;
@property (nonatomic, readonly, copy)NSArray *blankLocs;
@property (nonatomic, readonly, assign) BOOL result;
@property (nonatomic, copy)NSString *resultWord;

+ (YXSpellView *)spellViewWithOriWord:(NSString *)oriWord andBlankLocs:(NSString *)blankLocs;
- (void)beginEditing;
@end

