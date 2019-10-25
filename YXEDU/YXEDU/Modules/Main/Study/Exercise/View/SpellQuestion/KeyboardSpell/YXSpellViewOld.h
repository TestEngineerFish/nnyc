//
//  YXSpellViewOld.h
//  1111
//
//  Created by yao on 2018/10/31.
//  Copyright © 2018年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXSpellViewOld;
@protocol YXSpellViewOldDelegate <NSObject>
- (void)spellView:(YXSpellViewOld *)spellView complate:(BOOL)complate;
- (void)spellView:(YXSpellViewOld *)spellView canCheck:(BOOL)canCheck;
@end

@interface YXSpellViewOld : UIView
@property (nonatomic, weak)id<YXSpellViewOldDelegate> delegate;
@property (nonatomic, readonly, copy)NSString *oriWord;
@property (nonatomic, readonly, copy)NSArray *blankLocs;
@property (nonatomic, readonly, assign) BOOL result;
@property (nonatomic, copy)NSString *resultWord;

+ (YXSpellViewOld *)spellViewWithOriWord:(NSString *)oriWord andBlankLocs:(NSString *)blankLocs;
- (void)beginEditing;
@end

