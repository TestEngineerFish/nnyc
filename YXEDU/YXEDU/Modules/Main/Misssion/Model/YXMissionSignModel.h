//
//  YXMissionSignModel.h
//  YXEDU
//
//  Created by yixue on 2019/1/2.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMissionSignModel : NSObject

@property (nonatomic, strong) NSArray *baseScore;
@property (nonatomic, strong) NSString *multiplierScore;
@property (nonatomic, strong) NSString *userSignIn;
@property (nonatomic, strong) NSString *serveTime;
@property (nonatomic, strong) NSString *userCredits;

 @property (nonatomic, copy) NSString *convertedUserSignIn;
 @property (nonatomic, copy) NSArray *convertedBaseScore;

@property (nonatomic, assign) BOOL isTodayCheck;

@end

NS_ASSUME_NONNULL_END
