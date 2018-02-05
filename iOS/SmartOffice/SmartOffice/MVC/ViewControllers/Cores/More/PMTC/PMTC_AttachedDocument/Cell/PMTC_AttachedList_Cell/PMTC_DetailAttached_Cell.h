//
//  PMTC_DetailAttached_Cell.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentCategoryModel.h"
#define DATE_DOCUMENT_FROM_SERVER @"yyyy-MM-dd HH:mm:ss.0"


@interface PMTC_DetailAttached_Cell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Serial;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;

@end
