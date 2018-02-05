//
//  ListCheckOut.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListCheckOut.h"

@implementation ListCheckOut

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblTitle.textColor = AppColor_MainTextColor;
    self.lblSubTitle.textColor = AppColor_MainTextColor;
    self.lblTitle.text = LocalizedString(@"TTNS_ListCheckOut_Nội_dung_ra_ngoài");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
