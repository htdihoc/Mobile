//
//  QLTT_InfoDetailContentCell.m
//  SmartOffice
//
//  Created by NguyenDucBien on 8/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_InfoDetailContentCell.h"
#import "UILabel+Util.h"
#import "SOInsectTextLabel.h"
#import "NSString+Util.h"
#import "NSString+Util.h"
#define maxLines 5

@implementation QLTT_InfoDetailContentCell
{
    CGFloat lbl_constaintHeight;
    CGFloat scl_constaintHeight;
}

- (void)checkLoadMore
{
    if ([self.delegate isActive]) {
    self.lbl_BookDetailInfo.numberOfLines = 0;
        [self.btn_LoadMore setTitle:LocalizedString(@"QLTT_CommentView_Ẩn_đi") forState:UIControlStateNormal];
        return;
    }
    NSInteger lines = [self.lbl_BookDetailInfo lineCount];
    if(lines <= maxLines)
    {
        [self.btn_LoadMore setHidden:YES];
        self.lbl_BookDetailInfo.numberOfLines = 0;
    } else {
        [self.btn_LoadMore setHidden:NO];
        self.lbl_BookDetailInfo.numberOfLines = maxLines;
    }
}

- (void)enterDataToView:(QLTTMasterDocumentModel *)model index:(NSInteger)index
{
    [self.btn_LoadMore setTitle:LocalizedString(@"QLTT_DetailVC_Xem_thêm") forState:UIControlStateNormal];
    if (![model.description checkValidString]) {
        _lbl_BookDetailInfo.text = @"";
    }
    else
    {
        self.cst_Top.constant = 16;
        _lbl_BookDetailInfo.text = model.description;
    }
    [self checkLoadMore];
//    [self calculateLayout];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lbl_BookDetailInfo.textColor = AppColor_TittleTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)checkIsEnoughHeightOfBookDetailInfo
{
    CGFloat numberOfLines = [self.lbl_BookDetailInfo lineCount];
    if (numberOfLines > maxLines) {
        return NO;
    }
    return YES;
}

//- (void)calculateLayout
//{
//    BOOL checkLines = [self checkIsEnoughHeightOfBookDetailInfo];
//    [self.btn_LoadMore setHidden:[self checkIsEnoughHeightOfBookDetailInfo]];
//    if (!isActiveButton) {
//        if (checkLines) {
//            [self showFullContent];
//        }
//        else
//        {
//            self.lbl_BookDetailInfo.numberOfLines = maxLines;
//            [self.btn_LoadMore setTitle:LocalizedString(@"QLTT_InfoDetail_Xem_thêm") forState:UIControlStateNormal];
//        }
//    }
//    else
//    {
//        [self showFullContent];
//    }
    //    if (scl_constaintHeight == 0) {
    //        scl_constaintHeight = self.scl_MainScrollView.contentSize.height;
    //    }
    //    if (isActiveButton) {
    //        self.cst_LblBookDetailInfo.constant = lbl_constaintHeight;
    //        self.scl_MainScrollView.contentSize = CGSizeMake(0, scl_constaintHeight);
    //        self.cst_TblBottom.constant = 0;
    //    }
    //    else
    //    {
    //        if ([self checkIsEnoughHeightOfBookDetailInfo] == NO) {
    //            self.cst_LblBookDetailInfo.constant = [self heightOfBookDetailInfo];
    //            self.scl_MainScrollView.contentSize = CGSizeMake(0, self.scl_MainScrollView.contentSize.height+[self heightOfBookDetailInfo]-lbl_constaintHeight);
    //            self.cst_TblBottom.constant = - ([self heightOfBookDetailInfo]-lbl_constaintHeight);
    //        }
    //    }
//}
//- (void)showFullContent {
//    self.lbl_BookDetailInfo.numberOfLines = 0;
//    [self.lbl_BookDetailInfo layoutIfNeeded];
//    self.cst_LblBookDetailInfo.constant = self.cst_LblBookDetailInfo.constant * 5;
//    [self.btn_LoadMore setTitle:LocalizedString(@"QLTT_CommentView_Ẩn_đi") forState:UIControlStateNormal];
//}


- (IBAction)loadMore:(id)sender {
    if ([self.delegate isActive]) {
        self.lbl_BookDetailInfo.numberOfLines = 0;
        [self.btn_LoadMore setTitle:LocalizedString(@"QLTT_CommentView_Ẩn_đi") forState:UIControlStateNormal];
    }
    else
    {
        self.lbl_BookDetailInfo.numberOfLines = maxLines;
        [self.btn_LoadMore setTitle:LocalizedString(@"QLTT_DetailVC_Xem_thêm") forState:UIControlStateNormal];
    }
    [self.lbl_BookDetailInfo layoutIfNeeded];
    [self.delegate viewMore];
//    [self calculateLayout];
}
@end
