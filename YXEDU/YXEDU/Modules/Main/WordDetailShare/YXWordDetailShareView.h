//
//  YXWordDetailShareView.h
//  YXEDU
//
//  Created by jukai on 2019/4/25.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMyWordListDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YXWordDetailShareViewDelegate <NSObject>

- (void)YXWordDetailShareViewSureDetailModel:(YXMyWordListDetailModel*)detailModel;

- (void)YXWordDetailShareViewSureDetailReload;

@end


@interface YXWordDetailShareView : UIView

@property (nonatomic, weak) id<YXWordDetailShareViewDelegate> delegate;

+ (YXWordDetailShareView *)showShareInView:(UIView *)view delegate:(id<YXWordDetailShareViewDelegate>)delegate
                            detailModel:(YXMyWordListDetailModel *)detailModel;

@end

NS_ASSUME_NONNULL_END
