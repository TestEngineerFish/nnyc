//
//  YXFeedBackSelectImageView.h
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXFeedBackSelectImageViewDelegate<NSObject>
- (void)didClickedAddImage:(id)sender;
@end

@interface YXFeedBackSelectImageView : UIView
@property (nonatomic, strong) NSMutableArray <UIImage *>*imageArr;
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, assign) id<YXFeedBackSelectImageViewDelegate>delegate;

- (NSMutableArray <UIImage *>*)getImageArray;
@end
