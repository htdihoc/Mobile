//
//  QLTT_DetailView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_MasterTableView.h"
#import "SOInsectTextLabel.h"
#import "QLTTMasterDocumentModel.h"
#import "General_Infomation_View.h"
#import "QLTT_MasterViewCell.h"
#import "QLTT_DetailViewContentCell.h"
@protocol QLTT_DetailViewDelegate <NSObject>

- (void)didSelectLikeButton;
- (void)dismissVC:(UIGestureRecognizer*) recognizer;

@end
@interface QLTT_DetailView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *sc_Detail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_BottomHeight;
@property (weak, nonatomic) IBOutlet QLTT_MasterTableView *qltt_MasterTableView;
@property (weak, nonatomic) IBOutlet SOInsectTextLabel *lbl_SectionTitle;
@property (weak, nonatomic) id <QLTT_DetailViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Version;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_StatusName;
@property (weak, nonatomic) IBOutlet UIImageView *img_Doc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Author;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Language;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CheckPerson;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DocSize;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedUser;

@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_AuthorTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_LanguageTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CheckPersonTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NumberOfPagesTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedByTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NumerLike;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NumReadAndDownload;
@property (weak, nonatomic) IBOutlet UIButton *img_Like;
@property (weak, nonatomic) IBOutlet UIImageView *img_Time;
@property (nonatomic, strong) UIView *view;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_TopHeight;

@property (weak, nonatomic) IBOutlet UIImageView *img_FileType;

@property (weak, nonatomic) IBOutlet General_Infomation_View *info;
@property (weak, nonatomic) IBOutlet UIImageView *iconSecurityImg;

- (void)enterDataToView:(QLTTMasterDocumentModel *)model;
- (void)addTextToLikeLbl:(long)modelNumLike isLike:(BOOL)isLike;
- (void)scrollTableView:(NSIndexPath *)indexPath animation:(BOOL)animation;
- (void)scrollTo:(CGPoint)point;
- (CGPoint)getContentOffSet;
// tiep.vu added comment 17/07/2017
@property (weak, nonatomic) IBOutlet UIView *info_view;


@property (nonatomic) BOOL isLoading;
- (BOOL)checkVisible:(UITableViewCell *)cell;
- (NSIndexPath *)getIndexWith:(QLTT_MasterViewCell *)cell;
- (NSIndexPath *)getIndexWithCell:(QLTT_DetailViewContentCell *)cell;
- (void)reloadSections:(NSIndexSet *)sections;
- (void)reloadTable:(NSIndexPath *)index;
- (void)reloadTableData;
@end
