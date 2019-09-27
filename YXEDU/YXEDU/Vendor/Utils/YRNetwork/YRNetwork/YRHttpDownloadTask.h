//
//  YRHttpDownloadTask.h
//  YRNetwork
//
//  Created by shiji on 2018/6/11.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "YRHttpTask.h"

@interface YRHttpDownloadTask : YRHttpTask
@property (nonatomic, strong) NSString *tmpFileDir;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
- (void)cancelTask;
@end
