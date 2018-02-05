//
//  QLTT_InfoDetail.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_InfoDetail.h"
#import "UILabel+Util.h"
#import "SOInsectTextLabel.h"
#import "NSString+Util.h"
#import "NSString+Util.h"
#define maxLines 5
@implementation QLTT_InfoDetail 
{
    BOOL isActiveButton;
    CGFloat lbl_constaintHeight;
    CGFloat scl_constaintHeight;
}

- (void)reloadAt:(NSIndexSet *)section
{
    [self.tbl_ListDocument reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTableView
{
    [self.tbl_ListDocument reloadData];
}
- (void)enterDataToView:(QLTTMasterDocumentModel *)model
{
    isActiveButton = YES;
    self.cst_LblBookDetailInfo.constant = 15;
    if (![model.description checkValidString]) {
        self.cst_Top.constant = -75;
        _lbl_BookDetailInfo.text = @"";
    }
    else
    {
        self.cst_Top.constant = 16;
        _lbl_BookDetailInfo.text = model.description;
        [self.topView setHidden:NO];
    }
    [self calculateLayout];
    [self setFrameForTittleLB];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.lbl_BookDetailInfo layoutIfNeeded];
    self.backgroundColor = AppColor_MainAppBackgroundColor;
    self.containerView.backgroundColor = AppColor_MainAppBackgroundColor;
    self.scl_MainScrollView.backgroundColor = AppColor_MainAppBackgroundColor;
    
    self.tbl_ListDocument.estimatedRowHeight = 80;
    self.tbl_ListDocument.rowHeight = UITableViewAutomaticDimension;
    self.tbl_ListDocument.backgroundColor = AppColor_MainAppBackgroundColor;
    
    self.lbl_SectionTitle.text = LocalizedString(@"QLTT_InfoDetail_Thông_tin_tài_liệu_đính_kèm");
    self.lbl_SectionTitle.font = [UIFont systemFontOfSize:15];
    self.lbl_SectionTitle.backgroundColor = AppColor_MainAppBackgroundColor;
    
    self.lbl_BookDetailInfo.font = [UIFont systemFontOfSize:15];
    
    [self.btn_LoadMore setTitleColor:CommonColor_Blue forState:UIControlStateNormal];
    self.btn_LoadMore.titleLabel.font = [UIFont systemFontOfSize:15];
    
    isActiveButton = YES;
    lbl_constaintHeight = 245;
    scl_constaintHeight = 0;
//    self.cst_LblBookDetailInfo.constant = lbl_constaintHeight;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard:(UIGestureRecognizer*) recognizer
{
    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
    {
        [self.delegate dismissVC:recognizer];
    }
}
- (BOOL)checkIsEnoughHeightOfBookDetailInfo
{
    CGFloat numberOfLines = [self.lbl_BookDetailInfo lineCount];
    if (numberOfLines > maxLines) {
        return NO;
    }
    return YES;
}
- (CGFloat)heightOfBookDetailInfo
{
    //36 is total margin width of left and right lbl_BookDetailInfo
    return [self.lbl_BookDetailInfo.text findHeightForText:self.frame.size.width - 36 andFont:self.lbl_BookDetailInfo.font].height;
}
- (void)calculateLayout
{
    BOOL checkLines = [self checkIsEnoughHeightOfBookDetailInfo];
    [self.btn_LoadMore setHidden:[self checkIsEnoughHeightOfBookDetailInfo]];
    if (!isActiveButton) {
        if (checkLines) {
            [self showFullContent];
        }
        else
        {
            self.lbl_BookDetailInfo.numberOfLines = maxLines;
        }
    }
    else
    {
        [self showFullContent];
    }
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
}
- (void)showFullContent
{
    self.lbl_BookDetailInfo.numberOfLines = 0;
    [self.lbl_BookDetailInfo layoutIfNeeded];
    NSLog(@"%f %f", self.cst_scrollViewHeight.constant, self.cst_LblBookDetailInfo.constant);
    self.cst_scrollViewHeight.constant = self.cst_scrollViewHeight.constant + self.cst_LblBookDetailInfo.constant;
}

//Set frame for tittleLB
- (void)setFrameForTittleLB {
    _lbl_SectionTitle.font = [UIFont systemFontOfSize:14];
    _lbl_SectionTitle.backgroundColor = AppColor_MainAppBackgroundColor;
    _lbl_SectionTitle.text = LocalizedString(@"QLTT_DetailView_Cùng_chuyên_mục");
    if (IS_IPHONE) {
        self.lbl_SectionTitle.edgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    } else {
        self.lbl_SectionTitle.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark ibaction
- (IBAction)loadMore:(id)sender {
    isActiveButton = !isActiveButton;
    [self calculateLayout];
}


@end
