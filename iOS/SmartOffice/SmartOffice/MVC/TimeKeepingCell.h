//
//  TimeKeepingCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_EmployeeTimeKeeping.h"
@interface TimeKeepingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_Height;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
- (void)loadEmployeeInfo:(TTNS_EmployeeTimeKeeping *)employee;
@end
