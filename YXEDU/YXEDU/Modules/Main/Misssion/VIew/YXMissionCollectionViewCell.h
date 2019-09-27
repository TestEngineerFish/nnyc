//
//  YXMissionCollectionViewCell.h
//  YXEDU
//
//  Created by yixue on 2018/12/27.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YXMissionCollectionViewCell;
@protocol YXMissionCollectionViewCellDelegate <NSObject>
- (void)missionCollectionViewCellTransferTo:(YXMissionCollectionViewCell *)missionCollectionCell;
- (void)missionCollectionViewCellGetNextTask:(YXMissionCollectionViewCell *)missionCollectionCell;
@end


@interface YXMissionCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<YXMissionCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) YXTaskModel *model;

@property (nonatomic, strong) UIImageView *centerImgBox;

@end

NS_ASSUME_NONNULL_END
