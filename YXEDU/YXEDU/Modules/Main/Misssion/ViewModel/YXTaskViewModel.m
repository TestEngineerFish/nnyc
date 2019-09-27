//
//  YXTaskViewModel.m
//  YXEDU
//
//  Created by yixue on 2019/1/10.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXTaskViewModel.h"
#import "YXMissionSignModel.h"

@implementation YXTaskViewModel

+ (void)getSigninInfofinshedBlock:(YXFinishBlock)finishBlock {
    [YXDataProcessCenter GET:DOMAIN_SIGNININFO parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSDictionary *userSignInInfo = [response.responseObject objectForKey:@"userSignInInfo"];
            YXMissionSignModel *model = [YXMissionSignModel mj_objectWithKeyValues:userSignInInfo];
            response = [[YRHttpResponse alloc] initWithResponseObject:model statusCode:response.statusCode message:response.message error:response.error isCache:response.isCache requestType:response.requestType task:response.sessionTask];
        }
        finishBlock(response, result);
    }];
}

@end
