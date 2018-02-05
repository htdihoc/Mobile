//
//  UserNormalInfoCell.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 10/3/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PARoundImageView.h"
#import "TTNS_EmployeeTimeKeeping.h"
@interface UserNormalInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PARoundImageView *img_Profile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
- (void)setDataForCell:(TTNS_EmployeeTimeKeeping *)model;
@end
