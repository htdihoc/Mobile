//
//  PMTC_ListDocumentTableViewCell_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentCategoryModel.h"
#define DATE_DOCUMENT_FROM_SERVER @"yyyy-MM-dd HH:mm:ss.0"

@interface PMTC_ListDocumentTableViewCell_iPad : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_Tittle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Serria;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;

@end
