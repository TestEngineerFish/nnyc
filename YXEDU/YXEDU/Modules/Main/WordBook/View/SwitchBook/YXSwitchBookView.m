//
//  YXSeletWordsSourceNameView.m
//  YXEDU
//
//  Created by yao on 2019/2/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSwitchBookView.h"
#import "YXLeftTitleButton.h"
#import "YXIndicatorTableView.h"
#import "YXBookCategoryModel.h"

#define kSourceContentHeight AdaptSize(275)
@interface YXSwitchBookView () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIButton *wordBookBtn;
@property (nonatomic, weak) UIButton *wordListBtn;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UITableView *bookListTable;
@property (nonatomic, weak) UIButton *lastSelectBtn;
@property (nonatomic, strong) YXBookCategoryModel *curBookCategory;

@property (nonatomic, weak) UIImageView *blankIcon;
@property (nonatomic, weak) UILabel *tipsLabel;

@end

@implementation YXSwitchBookView
+ (instancetype)showSourceNameViewToView:(UIView *)view {
    YXSwitchBookView *sourceNameView = [[self alloc] initWithFrame:view.bounds];
    [view addSubview:sourceNameView];
    return sourceNameView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *blankIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:blankIcon];
        _blankIcon = blankIcon;
        
        self.backgroundColor = [UIColor clearColor];
        self.maskView.alpha = 0.0;
        
        self.contentView.frame = CGRectMake(0, - kSourceContentHeight, kSCREEN_WIDTH, kSourceContentHeight);

        CGFloat perHeight = AdaptSize(50);
        self.wordBookBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH * 0.5, perHeight);
        self.wordListBtn.frame = CGRectMake(kSCREEN_WIDTH * 0.5, 0, kSCREEN_WIDTH * 0.5, perHeight);
        
        [self.blankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(MakeAdaptCGSize(175, 133));
        }];
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.textColor = UIColorOfHex(0x485461);
        tipsLabel.font = [UIFont systemFontOfSize:AdaptSize(16)];
        [self.contentView addSubview:tipsLabel];
        _tipsLabel = tipsLabel;
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(blankIcon.mas_bottom);
        }];
        
        UIView *seprateLine = [[UIView alloc] initWithFrame:CGRectMake(0, perHeight - 1, SCREEN_WIDTH, 1)];
        seprateLine.backgroundColor = UIColorOfHex(0xEAF4FC);
        [self addSubview:seprateLine];
        
        self.bookListTable.frame = CGRectMake(0, perHeight, kSCREEN_WIDTH, AdaptSize(225));
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = self.bounds;
}

- (void)setBookCategorys:(NSMutableArray *)bookCategorys {
    _bookCategorys = bookCategorys;
    UIButton *selectedBtn = (self.currentSeletBookInfo.bookCategoryType == 0) ? self.wordBookBtn : self.wordListBtn;
    [self switchCategory:selectedBtn];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.curBookCategory) {
        if (self.curBookCategory.content.count == 0) {
            self.blankIcon.hidden = NO;
            self.tipsLabel.hidden = NO;
            tableView.hidden = YES;
            self.blankIcon.image = self.lastSelectBtn.tag ? [UIImage imageNamed:@"wordListBlank"] : [UIImage imageNamed:@"normalBookBlank"];
            self.tipsLabel.text = self.lastSelectBtn.tag ? @"你还没有添加过词单" : @"这里空空如也~";
        }else {
            self.blankIcon.hidden = YES;
            tableView.hidden = NO;
            self.tipsLabel.hidden = YES;
        }
    }
    return self.curBookCategory.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        cell.textLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(15)];
        
        
        cell.detailTextLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        UIView *sepLine = [[UIView alloc] init];
        sepLine.backgroundColor = UIColorOfHex(0xEAF4FC);
        [cell.contentView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell.contentView);
            make.height.mas_equalTo(1.0);
        }];
    }
    YXBookContentModel *bookContent = [self.curBookCategory.content objectAtIndex:indexPath.row];
    cell.textLabel.text = bookContent.name;
    if (bookContent.bookSelectedWordsCount) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"已选:%zd",bookContent.bookSelectedWordsCount];
    }else {
        cell.detailTextLabel.text = @"";
    }
    
    
    if (self.lastSelectBtn.tag == self.currentSeletBookInfo.bookCategoryType && indexPath.row == self.currentSeletBookInfo.categoryBookIndex) {
        cell.textLabel.textColor = UIColorOfHex(0x55A7FD);
        cell.detailTextLabel.textColor = UIColorOfHex(0x55A7FD);
    }else {
        cell.textLabel.textColor = UIColorOfHex(0x19315A);
        cell.detailTextLabel.textColor = UIColorOfHex(0x849EC5);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXBookContentModel *bookContent = [self.curBookCategory.content objectAtIndex:indexPath.row];
    self.currentSeletBookInfo.bookCategoryType = self.lastSelectBtn.tag;
    self.currentSeletBookInfo.categoryBookIndex = indexPath.row;
    self.currentSeletBookInfo.bookName = bookContent.name;
    self.currentSeletBookInfo.bookId= bookContent.ID;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = UIColorOfHex(0x55A7FD);
    cell.detailTextLabel.textColor = UIColorOfHex(0x55A7FD);
    
    if ([self.delegate respondsToSelector:@selector(switchBookViewSelectABook:)]) {
        [self.delegate switchBookViewSelectABook:self];
    }
    [self maskViewWasTapped];
}

#pragma mark - actions
- (void)switchCategory:(UIButton *)btn {
    if (self.lastSelectBtn.tag != btn.tag || !self.lastSelectBtn) {
        btn.selected = YES;
        self.lastSelectBtn.selected = NO;
        self.lastSelectBtn = btn;
        
        if (btn.tag < self.bookCategorys.count) {
            self.curBookCategory = [self.bookCategorys objectAtIndex:btn.tag];
            [self.bookListTable reloadData];
        }else {
            self.blankIcon.hidden = NO;
            self.tipsLabel.hidden = NO;
            self.bookListTable.hidden = YES;
            self.blankIcon.image = self.lastSelectBtn.tag ? [UIImage imageNamed:@"wordListBlank"] : [UIImage imageNamed:@"normalBookBlank"];
            self.tipsLabel.text = self.lastSelectBtn.tag ? @"你还没有添加过词单" : @"这里空空如也~";
        }
    }
}

- (void)hide {
    [self hideActive:NO];
}

- (void)maskViewWasTapped {
    [self hideActive:YES];
}


- (void)hideActive:(BOOL)active {
    [self removeFromSuperview];
    if (active) {
        if ([self.delegate respondsToSelector:@selector(switchBookViewTouchedToHide:)]) {
            [self.delegate switchBookViewTouchedToHide:self];
        }
    }

}
- (void)showAnimate {
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 0.5;
        self.contentView.frame = contentFrame;
    }];
}
#pragma mark - subviews
- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}


- (UITableView *)bookListTable {
    if (!_bookListTable) {
        UITableView *bookListTable = [[UITableView alloc] init];
        bookListTable.delegate = self;
        bookListTable.dataSource = self;
        bookListTable.rowHeight = AdaptSize(50);
        bookListTable.backgroundColor = [UIColor whiteColor];
        bookListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:bookListTable];
        _bookListTable = bookListTable;
    }
    return _bookListTable;
}

- (UIButton *)wordBookBtn {
    if (!_wordBookBtn) {
        UIButton *wordBookBtn = [self titleBtn:@"词书"];
        wordBookBtn.tag = 0;
        [self.contentView addSubview:wordBookBtn];
        _wordBookBtn = wordBookBtn;
    }
    return _wordBookBtn;
}

- (UIButton *)wordListBtn {
    if (!_wordListBtn) {
        UIButton *wordListBtn = [self titleBtn:@"词单"];
        wordListBtn.tag = 1;
        [self.contentView addSubview:wordListBtn];
        _wordListBtn = wordListBtn;
    }
    return _wordListBtn;
}

- (YXNoHightButton *)titleBtn:(NSString *)title {
    YXNoHightButton *btn = [[YXNoHightButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorOfHex(0x19315A) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(switchCategory:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:@"indicatorIcon_open"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"indicatorIcon_close"] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(17)];
    return btn;
}



//- (UITableView *)sourceNameTable {
//    if (!_sourceNameTable) {
//        UITableView *sourceNameTable = [[UITableView alloc] init];
//        //        sourceNameTable.delegate = self;
//        //        sourceNameTable.dataSource = self;
//        sourceNameTable.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:sourceNameTable];
//        _sourceNameTable = sourceNameTable;
//    }
//    return _sourceNameTable;
//}
@end
