//
//  WorkNotDataCell.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "WorkNotDataCell.h"

@implementation WorkNotDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.contentLB.textColor    = AppColor_MainTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI{
    self.contentLB.text         = @"Hiện tại Đ/c không có nhiệm vụ nào";
    self.contentLB.textColor    = AppColor_MainTextColor;
}

- (void)setupUIWithContent:(NSString *)content{
	self.contentLB.text  = content;
}
@end
