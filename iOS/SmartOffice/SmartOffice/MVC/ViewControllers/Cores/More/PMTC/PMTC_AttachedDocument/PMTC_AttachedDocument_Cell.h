//
//  PMTC_AttachedDocument_Cell.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMTC_AttachedDocument_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_DocumentName;
@property (weak, nonatomic) IBOutlet UIImageView *documentTypeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_DocumentType;

@end
