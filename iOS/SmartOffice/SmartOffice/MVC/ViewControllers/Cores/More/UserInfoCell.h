//
//  UserInfoCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 7/28/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_EmployeeTimeKeeping.h"
@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_Profile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Position;

@property (weak, nonatomic) IBOutlet UILabel *lbl_PhoneNumber;

- (void)setDataForCell:(TTNS_EmployeeTimeKeeping *)model;
@end
