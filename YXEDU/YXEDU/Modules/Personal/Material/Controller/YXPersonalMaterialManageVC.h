//
//  YXMaterialManageVC.h
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"

@interface YXPersonalMaterialManageVC : BSRootVC
@property (nonatomic, copy)void(^refreshBookMaterial)(NSString *size);
@end
