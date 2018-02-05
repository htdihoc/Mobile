//
//  QLTT_InfoDetail.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"
#import "FullWidthSeperatorTableView.h"
#import "SOInsectTextLabel.h"
#import "NSString+SizeOfString.h"
@protocol QLTT_InfoDetailDelegate <NSObject>
- (void)dismissVC:(UIGestureRecognizer *)recognizer;

@end
@interface QLTT_InfoDetail : BaseSubView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_Top;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scl_MainScrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet SOInsectTextLabel *lbl_SectionTitle;
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tbl_ListDocument;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookDetailInfo;
@property (weak, nonatomic) IBOutlet UIButton *btn_LoadMore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_LblBookDetailInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_TblBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_scrollViewHeight;

@property (weak, nonatomic) id<QLTT_InfoDetailDelegate> delegate;

- (void)enterDataToView:(QLTTMasterDocumentModel *)model;

- (void)reloadTableView;

- (void)reloadAt:(NSIndexSet *)section;

@end
