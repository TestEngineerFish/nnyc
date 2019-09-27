//
//  YXArticleBottomView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSentenceTextStorage.h"
#import "YXWordDetailModel.h"
#import "YXArticleDetailAttributionStringModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ArticleDelegate <NSObject>

// 全量播放文章
- (void)playArticleAudioWithFrom:(NSInteger)index;
// 继续播放文章
- (void)continueplayArticle;
// 根据时间,播放对应段的内容
- (void)playSentenceWith:(float)times isPlay:(BOOL)isPlay;
// 暂停播放
- (void)stopArticleAudio;
// 播放上一句
- (void)playPreviousSentence;
// 播放下一句
- (void)playNextSenceten;
// 显示播放控制器
- (void)showPlayControllerView:(BOOL)isShow;
// 显示文章译文
- (void)translateArticle:(BOOL)isShow;
// 显示单词卡
- (void)showWordDetailCard:(nonnull YXWordTextStorage *)textStorage point:(CGPoint)point;
// 查看单词详情
- (void)showWordDetailView:(YXWordDetailModel *)wordModel bookId:(NSString *)bookId;
// 设置上一句按钮状态
- (void)setPreviousBtn:(BOOL)isEnable;
// 设置下一句按钮的状态
- (void)setNextBtn:(BOOL)isEnable;

@end

@interface YXArticleBottomView : UIView
@property (nonatomic, weak) id<ArticleDelegate> delegate;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak)   UIView *playAudioView;

- (void)showSpeakerAnimation;
- (void)stopSpeakerAnimation;
@end

NS_ASSUME_NONNULL_END
