//
//  YXMyWordListCellModel.h
//  YXEDU
//
//  Created by yao on 2019/2/26.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
//"wordId":1,     //单词的id
//"bookId":1,  //所属词书id
//"learnState":1, //是否已经学习 1表示未学习，2表示学习中，3表示学习完成
//"listenState":1  //是否已经听写，1表示未听写，2表示听写学习中，3表示听写完成

@interface YXMyWordListCellModel : YXMyWordCellBaseModel
//@property (nonatomic, copy) NSString *wordId;
@property (nonatomic, assign) NSInteger learnState;
@property (nonatomic, assign) NSInteger listenState;
@end

NS_ASSUME_NONNULL_END
