//
//  YXEnumCom.h
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

typedef NS_ENUM(NSInteger, SelectTableCellType) {
    SelectTableCellHeader, // 头
    SelectTableCellPlain,  // 中间
    SelectTableCellTail,   // 尾
    SelectTableCellSingle,   // 只有一个
};


typedef NS_ENUM(NSInteger, YXCellSelectedState) {
    YXCellSelectedNO,
    YXCellSelectedYES
};

typedef NS_ENUM(NSInteger, YXGraphSelectType) {
    YXGraphSelectNone,
    YXGraphSelectRight,
    YXGraphSelectFalse,
};
