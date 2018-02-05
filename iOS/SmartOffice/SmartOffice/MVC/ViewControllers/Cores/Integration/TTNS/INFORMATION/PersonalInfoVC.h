//
//  PersonalVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "TTNS_EmployeeTimeKeeping.h"
@interface PersonalInfoVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *cmtLB;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UILabel *ngaycapLB;

@property (weak, nonatomic) IBOutlet UILabel *noicapLB;

@property (weak, nonatomic) IBOutlet UILabel *thuongtruLB;

@property (weak, nonatomic) IBOutlet UILabel *soTaiKhoanLB;

@property (weak, nonatomic) IBOutlet UILabel *nganHangLB;

@property (weak, nonatomic) IBOutlet UILabel *chiNhanhLB;

@property (weak, nonatomic) IBOutlet UILabel *maSoThueLB;

@property (weak, nonatomic) IBOutlet UILabel *ngayNhapMSTLB;

@property (weak, nonatomic) IBOutlet UILabel *ngayCapMSTLB;

@property (weak, nonatomic) IBOutlet UILabel *chiCucLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_BankHeight;
@property (weak, nonatomic) IBOutlet UIView *bankInfoView;

@property (strong, nonatomic) TTNS_EmployeeTimeKeeping *employeeDetail;
@end
