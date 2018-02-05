//
//  ManageIO.m
//  QuanLyRaVao
//
//  Created by NguyenDucBien on 4/12/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "NormalCheckOutCell.h"

@implementation NormalCheckOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lbAddress.textColor = AppColor_MainTextColor;
    _lbTime.textColor = AppColor_MainTextColor;
    _lbStatus.textColor = AppColor_MainTextColor;
    _lbReason.textColor = AppColor_MainTextColor;
    _lbContentDeny.textColor = CommonColor_Red;
    
    _lbl_Content.text = LocalizedString(@"TTNS_NormalCheckOutCell_Nội_dung_ra_ngoài");
    _lbReason.text = LocalizedString(@"TTNS_NormalCheckOutCell_Lý_do_từ_chối");
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
