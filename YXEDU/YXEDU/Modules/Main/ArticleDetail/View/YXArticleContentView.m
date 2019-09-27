//
//  YXArticleContentView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleContentView.h"
#import "YXWordPreviewPopView.h"
#import "YXWordModelManager.h"
#import "YXKeyPointTextStorage.h"

@interface YXArticleContentView ()<TYAttributedLabelDelegate>
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TYAttributedLabel *tmpLabel;
@property (nonatomic, strong) YXWordDetailModel *wordDetailModel;
@property (nonatomic, strong) UIView *popBgView;
@property (nonatomic, strong) YXWordPreviewPopView *wordPopView;
@property (nonatomic, assign) NSInteger sentenceRealIndex;
@property (nonatomic, assign) BOOL isPop;
@property (nonatomic, assign) BOOL isShowTranslate;
@end

@implementation YXArticleContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewWidth = SCREEN_WIDTH - 30.f;
    }
    return self;
}

- (void)setContent: (YXArticleModel *)articleModel showTranslate:(BOOL)isShow {
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
        self.attriStrModelList = @[];
        self.maxY = 0;
        self.sentenceRealIndex = 0;
        self.totalUseTime = 0;
    }
    self.isShowTranslate = isShow;
    NSMutableArray<YXArticleDetailAttributionStringModel *> *tmpAttriStrModelList = [[NSMutableArray alloc] init];

    //设置文章标题
    TYAttributedLabel *titleLabel = [[TYAttributedLabel alloc] init];
    titleLabel.frame = CGRectMake(0.f, self.maxY + 15.f, self.viewWidth, 19.f);
    titleLabel.text = articleModel.textTitle;
    titleLabel.textColor = UIColorOfHex(0x55A7FD);
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.contentView addSubview:titleLabel];
    self.maxY = CGRectGetMaxY(titleLabel.frame);

    //设置文章from
    TYAttributedLabel *fromLabel = [[TYAttributedLabel alloc] init];
    fromLabel.frame = CGRectMake(0.f, self.maxY + 8.f, self.viewWidth, 15.f);
    fromLabel.text = articleModel.from;
    fromLabel.textColor = UIColorOfHex(0x485461);
    fromLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:fromLabel];
    self.maxY = CGRectGetMaxY(fromLabel.frame);

    for (YXArticleTypeModel *model in articleModel.content) {
        switch (model.type.integerValue) {
            case 1: {
                YXArticleSubtitleModel *subtitleModel = [YXArticleSubtitleModel mj_objectWithKeyValues: model.content];
                YXArticleDetailAttributionStringModel *attrModel = [self setSubtitleLabel:subtitleModel showTranslate:isShow];
                [tmpAttriStrModelList addObject:attrModel];
                break;
            }
            case 2: {
                YXArticleSectionModel *sectionModel = [YXArticleSectionModel mj_objectWithKeyValues:model.content];
                NSArray<YXArticleDetailAttributionStringModel *> *attrModelArray = [self setSectionLabel:sectionModel rootUrl:articleModel.rootUrl showTranslate:isShow];
                [tmpAttriStrModelList addObjectsFromArray:attrModelArray];
                break;
            }
            case 3: {
                YXArticleImageModel *imageModel = [YXArticleImageModel mj_objectWithKeyValues:model.content];
                [self setImageView:imageModel];
                break;
            }
            case 4: {

                YXArticleDialogModel *dialogModel = [YXArticleDialogModel mj_objectWithKeyValues:model.content];
                NSArray<YXArticleDetailAttributionStringModel *> *attrModelArray = [self setDialogLabel:dialogModel rootUrl:articleModel.rootUrl showTranslate:isShow];
                [tmpAttriStrModelList addObjectsFromArray:attrModelArray];
                break;
            }
            default:
                break;
        }
    }
    self.attriStrModelList = [tmpAttriStrModelList copy];
    self.contentView.frame = CGRectMake(0, 0, self.viewWidth, self.maxY);
}

// 设置副标题
- (YXArticleDetailAttributionStringModel *)setSubtitleLabel:(YXArticleSubtitleModel *)model showTranslate:(BOOL)isShow {
    TYAttributedLabel *subtitle = [[TYAttributedLabel alloc] init];
    [self.contentView addSubview:subtitle];
    subtitle.delegate = self;
    //设置UI
    subtitle.frame = CGRectMake(0, self.maxY + 15.f, self.viewWidth, 0);
    subtitle.text = model.title;
    if (model.location.integerValue == 2) {
        subtitle.textAlignment = kCTTextAlignmentCenter;
    } else if (model.location.integerValue == 3) {
        subtitle.textAlignment = kCTTextAlignmentRight;
    } else {
        subtitle.textAlignment = kCTTextAlignmentLeft;
    }
    //添加属性
    YXSentenceTextStorage *sentenceTS = [[YXSentenceTextStorage alloc] init];
    sentenceTS.range = NSMakeRange(0, model.title.length);
    sentenceTS.text = model.title;
    sentenceTS.textColor = UIColorOfHex(0x485461);
    sentenceTS.realIndex = self.sentenceRealIndex;
    self.sentenceRealIndex += 1;
    //显示译文
    if (isShow) {
        YXSentenceTextStorage *sentenceTS = [[YXSentenceTextStorage alloc] init];
        sentenceTS.text = model.title;
    }
    [subtitle addTextStorage:sentenceTS];
    [subtitle sizeToFit];
    subtitle.frame = CGRectMake(0, self.maxY + 15.f, self.viewWidth, subtitle.height);
    self.maxY = CGRectGetMaxY(subtitle.frame);
    // 添加到数组
    YXArticleDetailAttributionStringModel *attrModel = [YXArticleDetailAttributionStringModel createArticleDetailAttributionStringModel:subtitle sentenceTextStorage:sentenceTS];
    return attrModel;
}

// 设置段落
- (NSArray<YXArticleDetailAttributionStringModel *> *)setSectionLabel: (YXArticleSectionModel *)model rootUrl:(NSString *)rootUrl showTranslate:(BOOL)isShow {
    NSMutableString *contentText = [[NSMutableString alloc] initWithString:@""];
    NSMutableArray *textSentenceEngRunArray = [NSMutableArray array];
    NSMutableArray *textSentenceCheRunArray = [NSMutableArray array];
    NSMutableArray *textWordRunArray = [NSMutableArray array];
    NSMutableArray *textKeyPointRunArray = [NSMutableArray array];
    NSMutableArray<YXArticleDetailAttributionStringModel *> *tmpArray = [NSMutableArray array];
    TYAttributedLabel *section = [[TYAttributedLabel alloc] init];
    section.delegate = self;
    section.frame = CGRectMake(0, self.maxY + 15.f, self.viewWidth, 0);
    section.sectionId = model.sectionId;
    [self.contentView addSubview:section];
    [contentText appendString:@"\t"];
    //默认只显示英文
    for (YXArticleSentenceModel *sentenceModel in model.sentence) {
        //添加属性
        YXSentenceTextStorage *sentenceEngTS = [[YXSentenceTextStorage alloc] init];
        //整理句子,通过正则获取单词内容
        NSDictionary *dict = [self getKeyPointWithRegular:sentenceModel.eng section:contentText];
        NSString *newSentence = (NSString*)dict[@"newSentence"];
        NSArray<YXWordTextStorage *> *array = (NSArray<YXWordTextStorage *> *)dict[@"wordArray"];
        [textWordRunArray addObjectsFromArray:array];
        NSArray<YXKeyPointTextStorage *> *keyPointArray = (NSArray<YXKeyPointTextStorage *> *)dict[@"keyPointArray"];
        [textKeyPointRunArray addObjectsFromArray:keyPointArray];
        //设置句子格式
        sentenceEngTS.range = NSMakeRange(contentText.length, newSentence.length);
        sentenceEngTS.text = newSentence;
        sentenceEngTS.font = [UIFont systemFontOfSize:15.f];
        sentenceEngTS.textColor = isShow ? UIColorOfHex(0x8095AB) : UIColorOfHex(0x485461);
        sentenceEngTS.sentenceId = sentenceModel.sentenceId;
        sentenceEngTS.audioUrl = [NSString stringWithFormat:@"%@%@", rootUrl, sentenceModel.audioUrl];
        sentenceEngTS.useTimeRange = NSMakeRange(self.totalUseTime, sentenceModel.useTime.unsignedIntegerValue);
        sentenceEngTS.realIndex = self.sentenceRealIndex;
        self.totalUseTime += sentenceModel.useTime.unsignedIntegerValue;
        self.sentenceRealIndex += 1;
        [textSentenceEngRunArray addObject:sentenceEngTS];
        [contentText appendString:newSentence];
    }
    //显示中文
    if (isShow) {
        [contentText appendString:@"\n\n\t"];
        for (YXArticleSentenceModel *sentenceModel in model.sentence) {
            YXSentenceTextStorage *sentenceCheTS = [[YXSentenceTextStorage alloc] init];
            sentenceCheTS.font = [UIFont systemFontOfSize:14.f];
            sentenceCheTS.textColor = UIColorOfHex(0x485461);
            sentenceCheTS.text = sentenceModel.che;
            sentenceCheTS.range = NSMakeRange(contentText.length, sentenceModel.che.length);
            [textSentenceCheRunArray addObject:sentenceCheTS];
            [contentText appendString:sentenceModel.che];
        }
    }

    section.attributedText = [[NSMutableAttributedString alloc] initWithString:[contentText copy]];
    [section setLinesSpacing:2.f];
    [section addTextStorageArray:textSentenceEngRunArray];
    [section addTextStorageArray:textSentenceCheRunArray];
    [section addTextStorageArray:textWordRunArray];
    [section addTextStorageArray:textKeyPointRunArray];
    [section sizeToFit];
    section.frame = CGRectMake(0, self.maxY + 15, self.viewWidth, section.height);
    self.maxY = CGRectGetMaxY(section.frame);
    // 添加到数组
    for (YXSentenceTextStorage *run in textSentenceEngRunArray) {
        YXArticleDetailAttributionStringModel *attrModel = [YXArticleDetailAttributionStringModel createArticleDetailAttributionStringModel:section sentenceTextStorage:run];
        [tmpArray addObject:attrModel];
    }
    //设置选中状态
    if (self.selectedAttrModel) {
        if ([section.sectionId isEqualToNumber:self.selectedAttrModel.attributedLabel.sectionId]) {
            YXArticleDetailAttributionStringModel *attrModel = [YXArticleDetailAttributionStringModel createArticleDetailAttributionStringModel:section sentenceTextStorage:self.selectedAttrModel.sentenceTextStorage];
            [self selectSentence:attrModel];
        }
    }
    return tmpArray;
}

// 设置图片
- (void)setImageView: (YXArticleImageModel *)model {
    UIView *imageBg = [[UIView alloc] init];
    imageBg.frame = CGRectMake(0, self.maxY + 15, self.viewWidth, self.viewWidth * model.imgRatio.floatValue);
    imageBg.backgroundColor = UIColor.clearColor;
    imageBg.layer.cornerRadius = 7.5f;
    imageBg.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = imageBg.bounds;
    imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imgUrl]]];
    [imageBg addSubview:imageView];
    [self.contentView addSubview:imageBg];
    self.maxY = CGRectGetMaxY(imageBg.frame);
}

// 设置对话
- (NSArray<YXArticleDetailAttributionStringModel *> *)setDialogLabel: (YXArticleDialogModel *)model rootUrl:(NSString *)rootUrl showTranslate:(BOOL)isShow {
    
    NSMutableArray<YXArticleDetailAttributionStringModel *> *tmpArray = [NSMutableArray array];
    for (YXArticleSentenceModel *sentenceModel in model.sentence) {
        //初始化数据空间
        NSMutableString *contentText = [[NSMutableString alloc] initWithString:@""];
        NSMutableArray *textSentenceRunArray = [NSMutableArray array];
        NSMutableArray *textWordRunArray = [NSMutableArray array];
        NSMutableArray *textKeyPointRunArray = [NSMutableArray array];

        // 添加发言者
        UILabel *speaker = [[UILabel alloc] init];
        speaker.frame = CGRectMake(0.f, self.maxY + 15.f, 50.f, 18.f);
        speaker.backgroundColor = UIColor.clearColor;
        speaker.textColor = UIColorOfHex(0x8095AB);
        speaker.font = [UIFont systemFontOfSize:15.f];
        speaker.text = sentenceModel.speaker;
        speaker.numberOfLines = 0;
        [speaker sizeToFit];
        [self.contentView addSubview:speaker];
        if (isShow) {
            UILabel *talker = [[UILabel alloc] init];
            talker.frame = CGRectMake(0.f, CGRectGetMaxY(speaker.frame) + 5.f, 50.f, 18.f);
            talker.backgroundColor = UIColor.clearColor;
            talker.textColor = UIColorOfHex(0x485461);
            talker.font = [UIFont systemFontOfSize:15.f];
            talker.text = sentenceModel.talker;
            talker.numberOfLines = 0;
            [talker sizeToFit];
            [self.contentView addSubview:talker];
        }

        TYAttributedLabel *dialog = [[TYAttributedLabel alloc] init];
        dialog.delegate = self;
        dialog.frame = CGRectMake(CGRectGetMaxX(speaker.frame) + 15.f, speaker.frame.origin.y, self.viewWidth - speaker.width, 0);
        dialog.sectionId = model.sectionId;
        [self.contentView addSubview:dialog];

        YXSentenceTextStorage *sentenceEngTS = [[YXSentenceTextStorage alloc] init];
        //整理句子,通过正则获取单词内容
        NSDictionary *dict = [self getKeyPointWithRegular:sentenceModel.eng section:contentText];
        NSString *newSentence = (NSString*)dict[@"newSentence"];
        NSArray<YXWordTextStorage *> *array = (NSArray<YXWordTextStorage *> *)dict[@"wordArray"];
        [textWordRunArray addObjectsFromArray:array];
        NSArray<YXKeyPointTextStorage *> *keyPointArray = (NSArray<YXKeyPointTextStorage *> *)dict[@"keyPointArray"];
        [textKeyPointRunArray addObjectsFromArray:keyPointArray];
        //设置句子格式
        sentenceEngTS.range = NSMakeRange(contentText.length, newSentence.length);
        sentenceEngTS.text = newSentence;
        sentenceEngTS.textColor = UIColorOfHex(0x485461);
        sentenceEngTS.sentenceId = sentenceModel.sentenceId;
        sentenceEngTS.audioUrl = [NSString stringWithFormat:@"%@%@", rootUrl, sentenceModel.audioUrl];;
        sentenceEngTS.useTimeRange = NSMakeRange(self.totalUseTime, sentenceModel.useTime.unsignedIntegerValue);
        sentenceEngTS.realIndex = self.sentenceRealIndex;
        self.totalUseTime += sentenceModel.useTime.unsignedIntegerValue;
        self.sentenceRealIndex += 1;
        [textSentenceRunArray addObject:sentenceEngTS];
        [contentText appendString:newSentence];

        //显示中文
        if (isShow) {
            [contentText appendString:@"\n"];
            [contentText appendString:sentenceModel.che];
        }

        dialog.text = [contentText copy];
        [dialog addTextStorageArray:textSentenceRunArray];
        [dialog addTextStorageArray:textWordRunArray];
        [dialog addTextStorageArray:textKeyPointRunArray];
        [dialog sizeToFit];
        dialog.frame = CGRectMake(CGRectGetMaxX(speaker.frame) + 15.f, speaker.frame.origin.y, self.viewWidth - speaker.width, dialog.height);
        self.maxY = CGRectGetMaxY(dialog.frame);
        // 添加到数组
        for (YXSentenceTextStorage *run in textSentenceRunArray) {
            YXArticleDetailAttributionStringModel *attrModel = [YXArticleDetailAttributionStringModel createArticleDetailAttributionStringModel:dialog sentenceTextStorage:run];
            [tmpArray addObject:attrModel];
        }
        //设置选中状态
        if (self.selectedAttrModel) {
            if ([dialog.sectionId isEqualToNumber:self.selectedAttrModel.attributedLabel.sectionId] && [sentenceEngTS.sentenceId isEqualToNumber:self.selectedAttrModel.sentenceTextStorage.sentenceId]) {
                YXArticleDetailAttributionStringModel *attrModel = [YXArticleDetailAttributionStringModel createArticleDetailAttributionStringModel:dialog sentenceTextStorage:self.selectedAttrModel.sentenceTextStorage];
                [self selectSentence:attrModel];
            }
        }
    }

    return tmpArray;
}

// 通过正则获取单词
- (NSDictionary *)getWordWithRegular:(NSString *)sentence locatin:(NSUInteger)location {
    NSString *filerTag = @"<word ([^\"]*?)>(.*?)</word>";
    NSString *filerWord = @">(.*?)<";
    NSString *filerWordId = @"wordid=([0-9]+) ";
    NSString *filerBookId = @"bookid=([0-9]+)>";
    NSMutableArray<YXWordTextStorage *> *wordArray = [NSMutableArray array];
    NSError *error;
    NSString *newStr = sentence;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:filerTag options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        BOOL scan = YES;
        while (scan) {
            NSTextCheckingResult *match = [regex firstMatchInString:newStr options:NSMatchingReportProgress range:NSMakeRange(0, newStr.length)];
            if (match == nil || match.range.location == NSNotFound) {
                scan = NO;
                continue;
            }
            YXWordTextStorage *word = [[YXWordTextStorage alloc] init];
            NSString *wordTagStr = [newStr substringWithRange:match.range];
            NSArray<NSString *> *filterArray = @[filerWord, filerWordId, filerBookId];
            for (NSString *filter in filterArray) {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:filter options:NSRegularExpressionCaseInsensitive error:&error];
                if (!error) {
                    NSTextCheckingResult *m = [regex firstMatchInString:wordTagStr options:NSMatchingReportProgress range:NSMakeRange(0, wordTagStr.length)];
                    if ([filter isEqualToString:filerWord]) {
                        //重写word
                        NSString *wordStr = [wordTagStr substringWithRange:NSMakeRange(m.range.location + 1, m.range.length - 2)];
                        newStr = [newStr stringByReplacingCharactersInRange:NSMakeRange(match.range.location, match.range.length) withString:wordStr];
                        word.range = NSMakeRange(location + match.range.location, wordStr.length);
                        word.text = wordStr;
                    } else if ([filter isEqualToString:filerWordId]) {
                        NSString *wordId = [wordTagStr substringWithRange:NSMakeRange(m.range.location + 7, m.range.length - 8)];
                        word.wordId = wordId;
                    } else if ([filter isEqualToString:filerBookId]) {
                        NSString *bookId = [wordTagStr substringWithRange:NSMakeRange(m.range.location + 7, m.range.length - 8)];
                        word.bookId = bookId;
                    }
                } else {
                    NSLog(@"%@",error);
                }
            }
            word.textColor = UIColor.redColor;
            [wordArray addObject:word];
        }
    }else {
        NSLog(@"%@",error);
    }
    return @{@"newSentence":newStr,@"wordArray":[wordArray copy]};
}

// 通过正则获取重点单词
- (NSDictionary *)getKeyPointWithRegular:(NSString *)sentence section:(NSString *)section {
    NSString *filerTag = @"<phrase>(.*?)</phrase>";
    NSString *newStr = sentence;
    NSError *error;
    NSMutableArray<YXWordTextStorage *> *wordArray = [NSMutableArray array];
    NSMutableArray<YXKeyPointTextStorage*>*keyPointArray = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:filerTag options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        BOOL scan = YES;
        while (scan) {
            NSTextCheckingResult *match = [regex firstMatchInString:newStr options:NSMatchingReportProgress range:NSMakeRange(0, newStr.length)];
            if (match == nil || match.range.location == NSNotFound) {
                scan = NO;
                continue;
            }
            //去除<phrase></phrase>标签
            NSString *phraseStr = [newStr substringWithRange:match.range];
            phraseStr = [phraseStr substringWithRange: NSMakeRange(8, phraseStr.length - 17)];
            //去除<word></word>标签
            NSDictionary *dict = [self getWordWithRegular:phraseStr locatin:section.length + match.range.location];
            phraseStr = (NSString*)dict[@"newSentence"];
            NSArray<YXWordTextStorage *> *array = (NSArray<YXWordTextStorage *> *)dict[@"wordArray"];
            YXKeyPointTextStorage *keyPoint = [[YXKeyPointTextStorage alloc] init];
            keyPoint.text = phraseStr;
            keyPoint.range = NSMakeRange(section.length + match.range.location, phraseStr.length);
            keyPoint.underLineStyle = kCTUnderlineStyleSingle;
            keyPoint.modifier = kCTUnderlinePatternDot;
            [keyPointArray addObject:keyPoint];
            [wordArray addObjectsFromArray:array];
            newStr = [newStr stringByReplacingCharactersInRange:match.range withString:phraseStr];
        }
    } else {
        NSLog(@"%@", error);
    }
    NSDictionary *dict = [self getWordWithRegular:newStr locatin:section.length];
    newStr = (NSString*)dict[@"newSentence"];
    NSArray<YXWordTextStorage *> *array = (NSArray<YXWordTextStorage *> *)dict[@"wordArray"];
    [wordArray addObjectsFromArray:array];
    return @{@"newSentence":newStr,@"wordArray":[wordArray copy], @"keyPointArray":[keyPointArray copy]};
}

#pragma mark subviews && data

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.clearColor;
        [_contentView setUserInteractionEnabled:YES];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (void)setArticleModel:(YXArticleModel *)articleModel {
    _articleModel = articleModel;
    [self setContent:articleModel showTranslate:NO];
}

- (NSInteger)sentenceRealIndex {
    if (!_sentenceRealIndex) {
        _sentenceRealIndex = 0;
    }
    return _sentenceRealIndex;
}

- (NSArray<YXArticleDetailAttributionStringModel *> *)attriStrModelList {
    if (!_attriStrModelList) {
        _attriStrModelList = [[NSArray alloc] init];
    }
    return _attriStrModelList;
}

- (YXWordPreviewPopView *)wordPopView {
    if (!_wordPopView) {
        YXWordPreviewPopView *wordPopView = [[YXWordPreviewPopView alloc] init];
        _wordPopView = wordPopView;
    }
    return _wordPopView;
}

#pragma mark - event

- (void)showWordPopViewWithWord:(YXWordTextStorage *)textStorage point:(CGPoint)point {

    //查找本地单词详情
    [YXWordModelManager quardWithWordId:textStorage.wordId completeBlock:^(id obj, BOOL result) {
        if (result) {
            self.wordDetailModel = obj;//词单列表
        } else {
            NSLog(@"查询数据失败");
        }
    }];
    if (self.wordDetailModel && !self.isPop) {
        self.wordPopView = [YXWordPreviewPopView createWordPreviewPopView:self.wordDetailModel];
        if ([self.delegate respondsToSelector:@selector(stopArticleAudio)]) {
            [self.delegate stopArticleAudio];
        }
        [self.wordPopView sizeToFit];
        [self.wordPopView.checkDetail addTarget:self action:@selector(checkWordDetail:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat height = 200.f;
        CGFloat y = point.y;
        if (y + height > SCREEN_HEIGHT) {
            y = y - height - 5;
            [self.wordPopView.downImageView setHidden:NO];
            [self.wordPopView.downImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(point.x - 15);
            }];
        } else {
            y = y + 5;
            [self.wordPopView.upImageView setHidden:NO];
            [self.wordPopView.upImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(point.x - 15);
            }];
        }
        self.wordPopView.frame = CGRectMake(10, y, SCREEN_WIDTH - 50.f, height);
        self.popBgView = [[UIView alloc] init];
        self.popBgView.frame = kWindow.bounds;
        self.popBgView.backgroundColor = UIColor.clearColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideWordPopView)];
        [self.popBgView addGestureRecognizer:tap];
        [kWindow addSubview:self.popBgView];
        [kWindow addSubview:self.wordPopView];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.1f;
        animation.fromValue = @0.f;
        animation.toValue = @1.f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.wordPopView.layer addAnimation:animation forKey:nil];
        self.isPop = YES;
    }
}

- (void)hideWordPopView {
    if (self.wordPopView) {
        [self.popBgView removeFromSuperview];
        [self.wordPopView removeFromSuperview];
        self.popBgView = nil;
        self.wordPopView = nil;
        self.isPop = NO;
    }
}

- (void)checkWordDetail:(UIButton *)btn {
    if (self.delegate) {
        if (self.wordDetailModel) {
            [self hideWordPopView];
            [self.delegate stopArticleAudio];
            [self.delegate showWordDetailView:self.wordDetailModel bookId:self.wordDetailModel.bookId];
        }
    }
}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textRun atPoint:(CGPoint)point
{
    if ([textRun isKindOfClass:[YXSentenceTextStorage class]]) {
        YXSentenceTextStorage *sentence = (YXSentenceTextStorage *)textRun;
        if (!sentence.audioUrl) {
            return;
        }
        //设置选中状态
        YXArticleDetailAttributionStringModel *attrModel = [YXArticleDetailAttributionStringModel createArticleDetailAttributionStringModel:attributedLabel sentenceTextStorage:sentence];
        [self selectSentence:attrModel];
        if (self.delegate) {
            [self.delegate playArticleAudioWithFrom:attrModel.sentenceTextStorage.realIndex];
        }
    }
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageLongPressed:(id<TYTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point {
    if ([textStorage isKindOfClass:[YXWordTextStorage class]]) {
        if (self.delegate) {
            [self showWordPopViewWithWord:(YXWordTextStorage *)textStorage point:point];
        }
    }
}

// 重置AttributionTextStorage的默认设置
- (void)resetAttributionString {
    for (YXArticleDetailAttributionStringModel *model in self.attriStrModelList) {
        if ([model.attributedLabel.sectionId isEqualToNumber:self.selectedAttrModel.attributedLabel.sectionId]) {
            UIColor *textColor = UIColorOfHex(0x485461);
            if (self.isShowTranslate && ![model.sentenceTextStorage.audioUrl isEqualToString:@""]) {
                textColor =  UIColorOfHex(0x8095AB);
            }
            NSMutableAttributedString *tmpAttr = model.attributedLabel.attributedText;
            [tmpAttr addAttributeTextColor:textColor range:model.sentenceTextStorage.range];
            model.attributedLabel.attributedText = tmpAttr;
        }
    }
}

//选中句子
- (void)selectSentence:(YXArticleDetailAttributionStringModel *)attrModel {
    if (attrModel.sentenceTextStorage.realIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(setPreviousBtn:)]) {
            [self.delegate setPreviousBtn:NO];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(setPreviousBtn:)]) {
            [self.delegate setPreviousBtn:YES];
        }
    }
    
    if (attrModel.sentenceTextStorage.realIndex >= self.attriStrModelList.lastObject.sentenceTextStorage.realIndex) {
        if ([self.delegate respondsToSelector:@selector(setNextBtn:)]) {
            [self.delegate setNextBtn:NO];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(setNextBtn:)]) {
            [self.delegate setNextBtn:YES];
        }
    }

    //清除选中状态
    if (self.selectedAttrModel) {
        [self resetAttributionString];
    }
    //设置新选中状态
    [self selectedAttributionString:attrModel];
}

// AttributionTextStorage添加选中效果
- (void)selectedAttributionString: (YXArticleDetailAttributionStringModel *) model {
    NSMutableAttributedString *tmpAttr = model.attributedLabel.attributedText;
    [tmpAttr addAttributeTextColor:UIColorOfHex(0x55A7FD) range:model.sentenceTextStorage.range];
    model.attributedLabel.attributedText = tmpAttr;
    self.selectedAttrModel = model;
}

@end
