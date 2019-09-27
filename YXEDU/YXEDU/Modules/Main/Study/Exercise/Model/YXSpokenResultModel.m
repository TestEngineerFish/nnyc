//
//  YXSpokenResultModel.m
//  YXEDU
//
//  Created by yao on 2018/11/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSpokenResultModel.h"
@implementation YXSpokenSymbolModel
@end


@implementation YXSpokenResultModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"details" : [YXSpokenSymbolModel class]};
}

- (NSAttributedString *)symbolAttri {
    NSMutableAttributedString *symbol = [[NSMutableAttributedString alloc] init];
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *woringDic = @{
                                NSFontAttributeName : font,
                                NSForegroundColorAttributeName : [UIColor redColor]
                                };
    
    NSDictionary *rightDic = @{
                                NSFontAttributeName : font,
                                NSForegroundColorAttributeName : UIColorOfHex(0x849EC5)
                                };
    for (YXSpokenSymbolModel *ssm in self.details) {
        NSDictionary *attri = [ssm.type isEqualToString:@"Error"] ? woringDic : rightDic;
         NSAttributedString *attriStr = [[NSAttributedString alloc] initWithString:ssm.name attributes:attri];
        [symbol appendAttributedString:attriStr];
    }
    
    return [symbol copy];
}
@end



