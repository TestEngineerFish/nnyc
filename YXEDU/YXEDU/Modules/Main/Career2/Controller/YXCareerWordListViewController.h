//
//  YXCareerWordListViewController.h
//  YXEDU
//
//  Created by yixue on 2019/2/20.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCareerModel.h"
#import "BSRootVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef  NS_ENUM(NSInteger, kYXWordListViewType) {
    kYXWordListStudied,
    kYXWordListCollection,
    kYXWordListError,
    kYXWordListNotStudied
};

@interface YXCareerWordListViewController : BSRootVC

@property (nonatomic, assign) kYXWordListViewType wordListViewType;
@property (nonatomic, strong) YXCareerModel *careerModel;

@end

NS_ASSUME_NONNULL_END
