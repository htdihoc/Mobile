//
//  QLTT_DetailViewContentCell_iPhone.h
//  SmartOffice
//
//  Created by NguyenVanTu on 8/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "General_Infomation_View.h"
#import "SOInsectTextLabel.h"
@class QLTT_DetailViewContentCell;
@protocol QLTT_DetailViewContentCellDelegate<NSObject>
@optional
- (void)didSelectLikeButton;
- (BOOL)isVisibleContentCell:(QLTT_DetailViewContentCell*)cell;
- (BOOL)isSameItem;
@end
@interface QLTT_DetailViewContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SOInsectTextLabel *lbl_SectionTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Version;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_StatusName;
@property (weak, nonatomic) IBOutlet UIImageView *img_Doc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NumerLike;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NumReadAndDownload;
@property (weak, nonatomic) IBOutlet UIButton *img_Like;
@property (weak, nonatomic) IBOutlet UIImageView *img_Time;
@property (weak, nonatomic) IBOutlet UIImageView *img_FileType;
@property (weak, nonatomic) IBOutlet UIImageView *iconSecurityImg;
@property (weak, nonatomic) id<QLTT_DetailViewContentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet General_Infomation_View *info;
- (void)enterDataToView:(QLTTMasterDocumentModel *)model;
@end
