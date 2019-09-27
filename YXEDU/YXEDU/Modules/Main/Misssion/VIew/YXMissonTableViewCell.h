//
//  YXMissonTableViewCell.h
//  YXEDU
//
//  Created by yixue on 2018/12/26.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMissionCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class YXMissonTableViewCell;
@protocol YXMissonTableViewCellDelegate <NSObject>
- (void)missonTableViewCellTransferTo:(YXMissionCollectionViewCell *)missionCollectionCell;
- (void)missonTableViewCellGetNewTask:(YXMissionCollectionViewCell *)missionCollectionCell taskModel:(YXTaskModel *)model;
@end

@interface YXMissonTableViewCell : UITableViewCell

@property (nonatomic, weak) id<YXMissonTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *taskListAfterSelected;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
