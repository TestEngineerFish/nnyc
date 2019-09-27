//
//  YXDescoverModel.m
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoverModel.h"

@implementation YXDescoverModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"banners"         : [YXDescoverBannerModel class],
             @"currentRankings" : [YXUserRankModel class]
             };
}

- (NSArray *)bannerImageLinks {
    if (!_bannerImageLinks) {
        NSMutableArray *links = [NSMutableArray array];
        for (YXDescoverBannerModel *banner in self.banners) {
            [links addObject:banner.img];
        }
        _bannerImageLinks = [links copy];
    }
    return _bannerImageLinks;
}

//- (NSArray *)filterDataSource {
//    
//}

- (NSArray<YXUserRankModel *> *)topThreeUsers {
    if (!_topThreeUsers) {
        NSMutableArray *topThreeUsers = [NSMutableArray array];
        NSInteger count = (self.currentRankings.count > 3) ? 3 : self.currentRankings.count;
        for (NSInteger i = 0; i < count; i++) {
            YXUserRankModel *model = [self.currentRankings objectAtIndex:i];
            if (model) {
                [topThreeUsers addObject:model];
            }
        }
        _topThreeUsers = [topThreeUsers copy];//[self.currentRankings subarrayWithRange:NSMakeRange(0, 3)];
    }
    return _topThreeUsers;
}

- (NSArray<YXUserRankModel *> *)leftSevenUsers {
    if (!_leftSevenUsers) {
        _leftSevenUsers = [self.currentRankings subarrayWithRange:NSMakeRange(3, 7)];
    }
    return _leftSevenUsers;
}
@end
