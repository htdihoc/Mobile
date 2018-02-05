//
//  RegisterAbsentCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegisterAbsentCell.h"
#import "UIButton+BorderDefault.h"

@interface RegisterAbsentCell()
@property (weak, nonatomic) IBOutlet UILabel *lbl_RegisterType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Place;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Absent;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Watch;

@end
@implementation RegisterAbsentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_ckOff1 setSelected:YES];
    
    _lbl_RegisterType.textColor = AppColor_MainTextColor;
    _lbl_Place.textColor = AppColor_MainTextColor;
    _lbl_Absent.textColor = AppColor_MainTextColor;
    _lbl_Watch.textColor = AppColor_MainTextColor;
    
    
    
    _lbl_RegisterType.text = LocalizedString(@"TTNS_RegisterAbsentCell_Loại_đăng_ký");
    _lbl_Place.text = LocalizedString(@"TTNS_RegisterAbsentCell_Nơi_nghỉ");
    _lbl_Absent.text = LocalizedString(@"TTNS_RegisterAbsentCell_Nghỉ");
    _lbl_Watch.text = LocalizedString(@"TTNS_RegisterAbsentCell_Trực");
 
    [self.locationButton setDefaultBorder];
    
    // Initialization code
}

- (void)checkRefresh{
    [_ckOff1 refresh];
    [_ckWork1 refresh];
}
- (IBAction)checkOff1:(ButtonCheckBox *)sender {
    [self checkRefresh];
    [sender setSelected:!sender.selected];
}

- (IBAction)checkWork1:(ButtonCheckBox *)sender {
    [self checkRefresh];
    [sender setSelected:!sender.selected];
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark IBAction
- (IBAction)locationAction:(id)sender {
}
@end
