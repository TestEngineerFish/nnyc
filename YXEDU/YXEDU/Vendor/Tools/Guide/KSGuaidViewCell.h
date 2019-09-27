//
//  KSGuaidViewCell.h
//  KSGuaidViewDemo
//
//  Created by Mr.kong on 2017/5/24.
//  Copyright © 2017年 Bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSGuaidViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton * buttonStart;
@property (nonatomic, strong) UIView * buttonStartBack;

@end

UIKIT_EXTERN NSString * const KSGuaidViewCellID;
