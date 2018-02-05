//
//  UserManagementCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "UserManagementCell.h"

@implementation UserManagementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupCell{
    self.titleLB.textColor = AppColor_MainTextColor;
    self.badgeButton.layer.cornerRadius = self.badgeButton.layer.frame.size.width/2;
    [self.badgeButton setHidden:YES];
}

@end
