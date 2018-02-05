//
//  PersonalVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "NSDate+Utilities.h"
@interface PersonalInfoVC () <TTNS_BaseNavViewDelegate> {
    
}

@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bankInfoView setHidden:YES];
    self.cst_BankHeight.constant = 0;
    self.backTitle  = LocalizedString(@"KGENERALINFO_SCR_PERSIONAL_INFO");
    [self setDataForViews];
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}
- (void)setDataForViews
{
    self.cmtLB.text = self.employeeDetail.personalIdNumber;
    self.locationLB.text = self.employeeDetail.placeOfBirth;
    self.ngaycapLB.text = [self convertDateToString:self.employeeDetail.personalIdIssuedDate];
    self.noicapLB.text = self.employeeDetail.personalIdIssuedPlace;
    self.thuongtruLB.text = self.employeeDetail.permanentAddress;
    
    self.soTaiKhoanLB.text = LocalizedString(@"N/A");
    self.nganHangLB.text = LocalizedString(@"N/A");
    self.chiNhanhLB.text = LocalizedString(@"N/A");
    
    self.maSoThueLB.text = self.employeeDetail.taxNumber;
    self.ngayNhapMSTLB.text = [self convertDateToString:self.employeeDetail.taxNumberUpdatedTime];
    self.ngayCapMSTLB.text = [self convertDateToString:self.employeeDetail.taxCodeDate];
    self.chiCucLB.text = self.employeeDetail.taxManageOrg;

}

- (NSString *)convertDateToString:(NSString *)dateString
{
    if (dateString == nil || [dateString isEqualToString:@""] || [dateString isEqualToString:LocalizedString(@"N/A")]) {
        return LocalizedString(@"N/A");
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000];
    return [date stringWithFormat:@"dd/MM/yyyy"];
}
@end
