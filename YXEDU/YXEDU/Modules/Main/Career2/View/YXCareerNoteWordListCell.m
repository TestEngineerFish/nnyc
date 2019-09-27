//
//  YXCareerNoteWordListCell.m
//  YXEDU
//
//  Created by yixue on 2019/2/25.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerNoteWordListCell.h"

@interface YXCareerNoteWordListCell ()

@property (nonatomic, weak) UILabel *wordLbl;
@property (nonatomic, weak) UILabel *detailLbl;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIButton *detailMaskBtn;
@property (nonatomic, strong) UIView *redContentView;

@end

@implementation YXCareerNoteWordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self wordLbl];
        [self detailLbl];
        [self line];
    }
    return self;
}

- (void)setWordInfoModel:(YXCareerNoteWordInfoModel *)wordInfoModel {
    _wordInfoModel = wordInfoModel;
    _wordLbl.text = _wordInfoModel.wordModel.word;
    _detailLbl.text = _wordInfoModel.wordModel.explainText;
}

- (void)setIsDetailHidden:(BOOL)isDetailHidden {
    _isDetailHidden = isDetailHidden;
    if (_isDetailHidden) {
        [self detailMaskBtn];
    } else {
        [self.detailMaskBtn removeFromSuperview];
    }
}

- (UILabel *)wordLbl {
    if (!_wordLbl) {
        UILabel *wordLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, 118, 17)];
        wordLbl.font = [UIFont pfSCRegularFontWithSize:16];
        wordLbl.textColor = UIColorOfHex(0x55A7FD);
        [self addSubview:wordLbl];
        _wordLbl = wordLbl;
    }
    return _wordLbl;
}

- (UILabel *)detailLbl {
    if (!_detailLbl) {
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(135, 16, SCREEN_WIDTH - 180, 17)];
        detailLbl.font = [UIFont pfSCRegularFontWithSize:16];
        detailLbl.textColor = UIColorOfHex(0x849EC5);
        [self addSubview:detailLbl];
        _detailLbl = detailLbl;
    }
    return _detailLbl;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 1)];
        line.backgroundColor = UIColorOfHex(0xEAF4FC);
        [self addSubview:line];
        _line = line;
    }
    return _line;
}

- (UIButton *)detailMaskBtn {
    if (!_detailMaskBtn) {
        UIButton *detailMaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(135, 10, SCREEN_WIDTH - 180, 29)];
        detailMaskBtn.backgroundColor = UIColorOfHex(0xC7DAF5);
        detailMaskBtn.layer.cornerRadius = 14;
        [self addSubview:detailMaskBtn];
        [detailMaskBtn addTarget:self action:@selector(removeMaskBtn:) forControlEvents:UIControlEventTouchUpInside];
        _detailMaskBtn = detailMaskBtn;
    }
    return _detailMaskBtn;
}

- (void)removeMaskBtn:(UIButton *)sender {
    [_detailMaskBtn removeFromSuperview];
}

- (void)doAnimationAt:(NSIndexPath *)indexPath withDeleteAnimateView:(YXDeleteAnimateView *)deleteAnimateView withTableView:(UITableView *)tableView{
    CGRect cellOriFrame = self.frame;
    cellOriFrame.origin.x = 0;
    CGRect contendRect = [tableView convertRect:cellOriFrame toView:deleteAnimateView];
    deleteAnimateView.contentFrame = contendRect;
    UIView *cancleView = nil;
    if (@available(iOS 11.0, *)) { // ios11以上
        for (UIView *sbv in tableView.subviews) {
            if ([sbv isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
                cancleView = sbv;
            }
        }
    }else {
        for (UIView *sbv in self.subviews) {
            if ([sbv isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
                cancleView = sbv;
            }
        }
    }
    CGFloat cancleViewWidth = cancleView.bounds.size.width;
    CGRect animateViewOriFrame = deleteAnimateView.animateView.frame;
    CGRect desRect = CGRectOffset(animateViewOriFrame, -cancleViewWidth - 10, 0);
    self.backgroundColor = UIColorOfHex(0xFC7D8B);
    [UIView animateWithDuration:0.1 animations:^{
        deleteAnimateView.animateView.frame = desRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.redContentView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            [deleteAnimateView doAnimationWithCompletion:^{
                self.backgroundColor = [UIColor whiteColor];
                self.contentView.hidden = YES;
                
//                [tableView beginUpdates];
//                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:0];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                [tableView endUpdates];
                
                if ([self.delegate respondsToSelector:@selector(cellDidFinishedDeleteAnimation:)]) {
                    [self.delegate cellDidFinishedDeleteAnimation:self];
                }
            }];
        }];
    }];
}

@end
