//
//  YXCareerNoteWordListCell.h
//  YXEDU
//
//  Created by yixue on 2019/2/25.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCareerNoteWordInfoModel.h"
#import "YXDeleteAnimateView.h"

NS_ASSUME_NONNULL_BEGIN

@class YXCareerNoteWordListCell;

@protocol YXCareerNoteWordListCellDelegate <NSObject>
- (void)cellDidFinishedDeleteAnimation:(YXCareerNoteWordListCell *)noteWordListCell;
@end

@interface YXCareerNoteWordListCell : UITableViewCell

@property (nonatomic, weak)id<YXCareerNoteWordListCellDelegate> delegate;

- (void)doAnimationAt:(NSIndexPath *)indexPath withDeleteAnimateView:(YXDeleteAnimateView *)deleteAnimateView withTableView:(UITableView *)tableView;

@property (nonatomic, strong) YXCareerNoteWordInfoModel *wordInfoModel;

@property (nonatomic, assign) BOOL isDetailHidden;

@end

NS_ASSUME_NONNULL_END
