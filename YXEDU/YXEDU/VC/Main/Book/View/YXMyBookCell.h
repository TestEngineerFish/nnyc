//
//  YXStudyingBookCell.h
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YXMyBookCellDelegate <NSObject>
@optional
- (void)manageBtnDidClicked:(id)sender;
@end

@interface YXMyBookCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *totalVocabularyLab;
@property (nonatomic, strong) UILabel *haveLearnedLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *manageBtn;
@property (nonatomic, assign) id<YXMyBookCellDelegate>delegate;
@end
