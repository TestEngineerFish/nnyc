//
//  YXSelectedWordsMiniView.m
//  YXEDU
//
//  Created by yao on 2019/2/27.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSelectedWordsMiniView.h"
#import "YXSelectMyWordHeaderView.h"


static NSString *const kYXMiniWordCellID = @"YXMiniWordCellID";
@class YXMiniWordCell;
@protocol YXMiniWordCellDelegate <NSObject>
- (void)miniCellClickDeleteWord:(YXMiniWordCell *)miniWordCell;
@end


@interface YXMiniWordCell : UITableViewCell
@property (nonatomic, weak) id<YXMiniWordCellDelegate> delegate;
@property (nonatomic, weak) UILabel *wordLabel;
@property (nonatomic, weak) UIButton *deleteButton;
@property (nonatomic, strong) YXSelectWordCellModel *wordModel;
@end
@implementation YXMiniWordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(AdaptSize(40));
        }];
        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.deleteButton.mas_right);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)deleteWord {
    if ([self.delegate respondsToSelector:@selector(miniCellClickDeleteWord:)]) {
        [self.delegate miniCellClickDeleteWord:self];
    }
}

- (void)setWordModel:(YXSelectWordCellModel *)wordModel {
    _wordModel = wordModel;
    self.wordLabel.text = wordModel.wordDetail.word;
    
}
- (UILabel *)wordLabel {
    if (!_wordLabel) {
        UILabel *wordLabel = [[UILabel alloc] init];
        wordLabel.textColor = UIColorOfHex(0x103B69);
        wordLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(15)];
        wordLabel.text = @"morinig";
        [self.contentView addSubview:wordLabel];
        _wordLabel = wordLabel;
    }
    return _wordLabel;
}


- (UIButton *)deleteButton {
    if (!_deleteButton) {
        UIButton *deleteButton = [[YXNoHightButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"miniDeleteIcon"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteWord) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteButton];
        _deleteButton = deleteButton;
    }
    return _deleteButton;
}
@end







@interface YXSelectedWordsMiniView ()<UITableViewDelegate,UITableViewDataSource,YXMiniWordCellDelegate>
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, weak) YXSelectMyWordHeaderView *headerView;
@property (nonatomic, weak) UILabel *bottomLabel;

@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, weak) UIImageView *openIcon;
@property (nonatomic, weak) UIView *tapView;
@property (nonatomic, assign) BOOL open;

@property (nonatomic, weak) UITableView *wordList;
@end

@implementation YXSelectedWordsMiniView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"floatViewBGIcon"]];
        [self addSubview:self.bgImage];
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat marigin = AdaptSize(15);
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(AdaptSize(10));
            make.right.equalTo(self).offset(-marigin);
            make.bottom.equalTo(self).offset(-marigin);
        }];
        

        [self countLabel];
        UIImageView *openIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miniOpenIcon"]];
        openIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:openIcon];
        _openIcon = openIcon;
        
        [openIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.countLabel);
            make.right.equalTo(self).offset(-marigin);
            make.size.mas_equalTo(MakeAdaptCGSize(12, 10));
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomLabel);
            make.right.equalTo(openIcon.mas_left);
            make.top.equalTo(self).offset(AdaptSize(10));
            make.height.mas_equalTo(AdaptSize(20));//.priority(MASLayoutPriorityDefaultHigh);
        }];
        
        UIView *tapView = [[UIView alloc] init];
        [self addSubview:tapView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [tapView addGestureRecognizer:tap];
        
        [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(AdaptSize(35));
        }];
        
        
        [self.wordList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self).offset(-AdaptSize(5));
            make.top.equalTo(tapView.mas_bottom);
            make.bottom.equalTo(self.bottomLabel.mas_top).offset(AdaptSize(-5));
        }];
    }
    return self;
}

- (void)setSelectedWords:(NSMutableArray *)selectedWords {
    _selectedWords = selectedWords;
    self.countLabel.text = [NSString stringWithFormat:@"已选择：%zd",_selectedWords.count];
    if (self.isOpen) {
        [self.wordList reloadData];
    }
}

- (void)tapAction {
    _open = !_open;
    NSString *name = _open ? @"miniCloseIcon" : @"miniOpenIcon";
    self.openIcon.image = [UIImage imageNamed:name];
    if (_open) {
        [self.wordList reloadData];
    }
    if ([self.delegate respondsToSelector:@selector(selectedWordsMiniViewTitleClick:)]) {
        [self.delegate selectedWordsMiniViewTitleClick:self];
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMiniWordCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMiniWordCellID forIndexPath:indexPath];
    YXSelectWordCellModel *wordModel = [self.selectedWords objectAtIndex:indexPath.row];
    cell.wordModel = wordModel;
    cell.delegate = self;
    return cell;
}

- (void)miniCellClickDeleteWord:(YXMiniWordCell *)miniWordCell {
    if ([self.delegate respondsToSelector:@selector(selectedWordsMiniViewDeleteWords:)]) {
        [self.delegate selectedWordsMiniViewDeleteWords:miniWordCell.wordModel];
    }
}
#pragma mark - subview
- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.textColor = UIColorOfHex(0x103B69);
        bottomLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        bottomLabel.text = @"*最多选择100个单词";
        [self addSubview:bottomLabel];
        _bottomLabel = bottomLabel;
    }
    return _bottomLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.textColor = UIColorOfHex(0x1B4068);
        countLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(15)];
        countLabel.text = @"已选择：0";
        [self addSubview:countLabel];
        _countLabel = countLabel;
    }
    return _countLabel;
}

- (YXSelectMyWordHeaderView *)headerView {
    if (!_headerView) {
        YXSelectMyWordHeaderView *headerView = [[YXSelectMyWordHeaderView alloc] initWithReuseIdentifier:@"header"];
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.titleLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(15)];
        headerView.titleLabel.textColor = UIColorOfHex(0x103B69);
        headerView.progressLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        headerView.progressLabel.textColor = UIColorOfHex(0x103B69);
        [self addSubview:headerView];
        _headerView = headerView;
    }
    return _headerView;
}


- (UITableView *)wordList {
    if (!_wordList) {
        UITableView *wordList = [[UITableView alloc] init];
        wordList.backgroundColor = [UIColor clearColor];
        wordList.separatorStyle = UITableViewCellSeparatorStyleNone;
        [wordList registerClass:[YXMiniWordCell class] forCellReuseIdentifier:kYXMiniWordCellID];
        wordList.rowHeight = AdaptSize(32);
        wordList.delegate = self;
        wordList.dataSource = self;
        [self addSubview:wordList];
        _wordList = wordList;
    }
    return _wordList;
}
@end
