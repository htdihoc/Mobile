//
//  VOffice_DocumentDetailCell_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOCycleView.h"
@interface VOffice_DocumentDetailCell_iPad : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDocTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRaiseMember;
@property (weak, nonatomic) IBOutlet UILabel *lblSignedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPriority;
@property (weak, nonatomic) IBOutlet SOCycleView *imgPriority;
@property (weak, nonatomic) IBOutlet UIImageView *iconPerson;
@property (weak, nonatomic) IBOutlet UIImageView *iconTime;


//Data
- (void)setupDataByModel:(id)model;
@end
