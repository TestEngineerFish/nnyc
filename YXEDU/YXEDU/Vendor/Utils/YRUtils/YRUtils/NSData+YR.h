//
//  NSData+additions.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import <CommonCrypto/CommonCryptor.h>

@interface NSData (YR)

/*
 * md5Digest 接口废弃 新接口调用 md5Data
 */
- (NSData *) md5Digest DEPRECATED_ATTRIBUTE;
- (NSData *) md5Data;
- (NSString *) md5String;

/*
 * sha1Digest 接口废弃 新接口调用 sha1Data
 */
- (NSData *) sha1Digest DEPRECATED_ATTRIBUTE;
- (NSData *) sha1Data;
- (NSString *) sha1String;
- (NSString *) base64Encoded;
- (NSData *) base64Decoded;

@end
