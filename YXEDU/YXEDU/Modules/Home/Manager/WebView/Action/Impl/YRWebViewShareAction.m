//
//  YRWebViewShareAction.m
//  pyyx
//
//  Created by sunwu on 2018/6/21.
//  Copyright © 2018年 朋友印象. All rights reserved.
//

#import "YRWebViewShareAction.h"


static NSString *ShareType_SharePanel = @"SHAREPANEL";
static NSString *ShareType_WeChatMiniProgram = @"WECHATMINIPROGRAM";

@interface YRWebViewShareAction() {
}

@property (nonatomic, strong) NSString *shareType;

@end

@implementation YRWebViewShareAction

/**
 * 执行动作，实现分享的具体逻辑
 */
- (void)action {
    
    [super action];
    
    NSString *shareType = self.params[@"type"];
    shareType = [shareType uppercaseString];
//    if ([ShareType_SharePanel isEqualToString:shareType]) {
//        [self sharePanelProcess];
//    } else if ([ShareType_WeChatMiniProgram isEqualToString:shareType]) {
//        [self weChatMiniProgramProces];
//    }
}

/**
 * 拉起分享面板
 */
- (void)sharePanelProcess {
    
}


@end
