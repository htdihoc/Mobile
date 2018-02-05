//
//  UserManagementCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserManagementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIButton *badgeButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@end
