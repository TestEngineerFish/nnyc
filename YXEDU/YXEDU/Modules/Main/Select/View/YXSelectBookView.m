//
//  YXSelectBookView.m
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSelectBookView.h"
#import "YXSelectBookCell.h"

static NSString * const kYXSelectBookCellID = @"kYXSelectBookCellID";

@interface YXSelectBookView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak)UITableView *bookTableView;
@property (nonatomic, strong)NSArray *books;
@property (nonatomic, strong)NSString *setSuccessBookId;
@end
@implementation YXSelectBookView
+ (YXSelectBookView *)selectedBookViewWith:(YXConfigGradeModel *)gradeModel
                               andDeletate:(id<YXSelectBookViewDelegate>)delegate {
    YXSelectBookView *sbView = [[YXSelectBookView alloc] init];
    sbView.delegate = delegate;
    sbView.gradeModel = gradeModel;
    return sbView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self bookTableView];
    }
    return self;
}

- (void)setBooks:(NSArray *)books {
    _books = [books copy];
    [self.bookTableView reloadData];
}

- (void)setGradeModel:(YXConfigGradeModel *)gradeModel {
    _gradeModel = gradeModel;
    self.books = gradeModel.options;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bookTableView.frame = self.bounds;
}

- (UITableView *)bookTableView {
    if (!_bookTableView) {
        UITableView *bookTableView = [[UITableView alloc] init];
        bookTableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
        bookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        bookTableView.delegate = self;
        bookTableView.dataSource = self;
        [bookTableView registerClass:[YXSelectBookCell class] forCellReuseIdentifier:kYXSelectBookCellID];
        bookTableView.rowHeight = iPhone5 ? 130 : 150;
        bookTableView.backgroundColor = UIColorOfHex(0xF3F8FB);
        [self addSubview:bookTableView];
        _bookTableView = bookTableView;
    }
    return _bookTableView;
}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXSelectBookCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXSelectBookCellID forIndexPath:indexPath];
    YXConfigBookModel *bModel = self.books[indexPath.row];
    cell.bookNameL.text = bModel.name;
    
    [cell.bookIcon sd_setImageWithURL:[NSURL URLWithString:bModel.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.totolWordL.text = [NSString stringWithFormat:@"总词汇：%@",bModel.wordCount];
    cell.studyStatusL.hidden = !bModel.isLearning;
    cell.selImageView.hidden = ![bModel.bookId isEqualToString:self.setSuccessBookId];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXConfigBookModel *bModel = self.books[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectBookView:didSelectedBook:)]) {
        [self.delegate selectBookView:self didSelectedBook:bModel];
    }
}

- (void)refreshTableWithCurrentBookId:(NSString *)bookId {
    self.setSuccessBookId = bookId;
    [self.bookTableView reloadData];
}
@end

//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *book_id;
//@property (nonatomic, strong) NSString *desc;
//@property (nonatomic, strong) NSString *cover;
//@property (nonatomic, strong) NSString *word_count;
