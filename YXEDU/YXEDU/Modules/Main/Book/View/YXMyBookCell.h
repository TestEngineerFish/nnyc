//
//  YXStudyingBookCell.h
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMyBooksInfo.h"
#import "YXDownloadProgressView.h"


@class YXMyBookCell;
@protocol YXMyBookCellDelegate <NSObject>
@optional
- (void)myBookCellChangeBook:(YXMyBookCell *)cell;
- (void)myBookCellDownLoadMaterial:(YXMyBookCell *)cell;
- (void)myBookCellChangeStudyPlan:(YXMyBookCell *)cell;
- (void)myBookCellStudyThatBook:(YXMyBookCell *)cell;
- (void)myBookCellDownloadStoped:(YXMyBookCell *)cell;
@end

@interface YXMyBookCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *totalVocabularyLab;
@property (nonatomic, strong) UILabel *haveLearnedLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *manageBtn;

@property (nonatomic, weak)YXDownloadProgressView *progressView;
@property (nonatomic, weak)UIButton *controlBtn;

@property (nonatomic, assign) id<YXMyBookCellDelegate>delegate;

@property (nonatomic, strong)YXStudyBookModel *studyBookModel;
- (void)setProgress:(CGFloat)progress;
@end
