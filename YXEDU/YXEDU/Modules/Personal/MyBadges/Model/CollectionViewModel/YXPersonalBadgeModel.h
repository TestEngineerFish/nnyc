//
//  YXPersonalBadgeModel.h
//  YXEDU
//
//  Created by Jake To on 10/20/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPersonalBadgeModel : NSObject

@property (nonatomic, strong) NSString *badgeID;
@property (nonatomic, strong) NSString *completedBadgeImageUrl;
@property (nonatomic, strong) NSString *incompleteBadgeImageUrl;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *badgeName;
@property (nonatomic, strong) NSString *finishDate;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *done;


@end

NS_ASSUME_NONNULL_END
