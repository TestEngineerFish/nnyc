//
//  YXWordListBaseInfo.h
//  YXEDU
//
//  Created by yao on 2019/2/28.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//"currentWordListSize": 2,  //当前的已经创建的词单长度
//"maxWordListSize": 50,  //可创建的词单的最大长度
//"maxWordsSize": 100,  //词单包含单词的最大长度
//"wordListCreateState": true   //是否可以新增词单，true是可以，false是不可以
@interface YXWordListBaseInfo : NSObject
@property (nonatomic, assign) NSInteger currentWordListSize;
@property (nonatomic, assign) NSInteger maxWordListSize;
@property (nonatomic, assign) NSInteger maxWordsSize;
@property (nonatomic, assign) NSInteger wordListCreateState;
@end

NS_ASSUME_NONNULL_END
