//
//  YXSelectBookView.h
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXConfigure.h"
NS_ASSUME_NONNULL_BEGIN
@class YXSelectBookView;
@protocol YXSelectBookViewDelegate <NSObject>
- (void)selectBookView:(YXSelectBookView *)selBookView didSelectedBook:(YXConfigBookModel *)bModel;
@end

@interface YXSelectBookView : UIView
@property (nonatomic, weak)id<YXSelectBookViewDelegate> delegate;
@property (nonatomic, strong)YXConfigGradeModel *gradeModel;
+ (YXSelectBookView *)selectedBookViewWith:(YXConfigGradeModel *)gradeModel
                               andDeletate:(id<YXSelectBookViewDelegate>)delegate;
- (void)refreshTableWithCurrentBookId:(NSString *)bookId;
@end

NS_ASSUME_NONNULL_END
