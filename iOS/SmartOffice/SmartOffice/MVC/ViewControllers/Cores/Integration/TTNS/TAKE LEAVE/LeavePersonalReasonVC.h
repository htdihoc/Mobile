//
//  LeavePersonalReasonVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "ButtonCheckBox.h"
#import "UIPlaceHolderTextView.h"
#import "TimePickerVC.h"

@interface LeavePersonalReasonVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTV;

@property (weak, nonatomic) IBOutlet UIButton *clearReasonButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *locationTV;

@property (weak, nonatomic) IBOutlet UIButton *clearLocationButton;

@property (weak, nonatomic) IBOutlet UILabel *phoneLB;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *handOverLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseHandOverLB;

@property (weak, nonatomic) IBOutlet UIView *handoverView;

@property (weak, nonatomic) IBOutlet UILabel *managerLB;

@property (weak, nonatomic) IBOutlet UILabel *managerChoiseLB;

@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (strong, nonatomic) IBOutlet UIView *handOverUserView;

@property (strong, nonatomic) IBOutlet UIView *managerUserView;

@property (weak, nonatomic) IBOutlet UILabel *cheDoXinNghiLB;

@property (weak, nonatomic) IBOutlet UILabel *salaryLB;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *salaryLeaveOutlet;

@property (weak, nonatomic) IBOutlet UILabel *notSalaryLB;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *notSalaryLeaveOutlet;

@property (weak, nonatomic) IBOutlet UIButton *ghiLaiButton;

@property (weak, nonatomic) IBOutlet UIButton *trinhKyButton;

@property (strong, nonatomic) TimePickerVC *timePickerVC;

- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

- (IBAction)choiseTimeAction:(id)sender;

- (IBAction)handOverAction:(id)sender;

- (IBAction)managerAction:(id)sender;

- (IBAction)salaryLeaveAction:(id)sender;

- (IBAction)notSalaryLeaveAction:(id)sender;

- (IBAction)ghiLaiAction:(id)sender;

- (IBAction)trinhKyAction:(id)sender;

@end
