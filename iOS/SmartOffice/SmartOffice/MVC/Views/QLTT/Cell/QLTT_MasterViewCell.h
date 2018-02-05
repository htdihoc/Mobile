//
//  QLTT_MasterViewCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTTMasterDocumentModel.h"
@class QLTT_MasterViewCell;
@protocol QLTT_MasterViewCellDelegate <NSObject>
- (BOOL)isVisible:(QLTT_MasterViewCell *)cell;
@end

@interface QLTT_MasterViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_Book;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Author;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Version;
@property (weak, nonatomic) IBOutlet UILabel *lbl_State;
@property (weak, nonatomic) IBOutlet UILabel *lbl_AuthorTitle;
@property (weak, nonatomic) IBOutlet UIImageView *img_Status;
@property (weak, nonatomic) IBOutlet UIImageView *iconSecurityImg;
@property (weak, nonatomic) id<QLTT_MasterViewCellDelegate> delegate;

- (void)enterDataToCell:(QLTTMasterDocumentModel *)model;
@end
