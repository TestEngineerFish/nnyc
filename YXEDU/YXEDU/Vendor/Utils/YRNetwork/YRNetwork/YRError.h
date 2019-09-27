//
//  YRError.h
//  pyyx
//
//  Created by Chunlin Ma on 15/5/4.
//  Copyright (c) 2015年 PengYouYinXing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YRErrorCode) {
    YRErrorLogout = 10106,
    YRErrorClosure = 10122,
};

@interface YRError : NSObject

/** 原始Error */
@property (nonatomic, strong) NSError *originalError;
@property(nonatomic)NSInteger code;
@property(nonatomic,strong)NSString *desc;//message
@property(nonatomic,strong)NSString *warningDesc;
@property(nonatomic,strong)NSString *notice;
@property(nonatomic,strong)NSString *warningOperation;
@property(nonatomic,assign)BOOL isCache;
@property (nonatomic, assign) NSInteger type;

+ (id)errorWithCode:(NSInteger)code desc:(NSString *)desc;
+ (id)errorWithCode:(NSInteger)code desc:(NSString *)desc warningDesc:(NSString *)warningDesc;

@end
