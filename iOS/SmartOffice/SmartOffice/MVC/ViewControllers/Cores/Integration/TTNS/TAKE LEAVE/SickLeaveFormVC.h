//
//  SickLeaveFormVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "UIPlaceHolderTextView.h"
#import "TimePickerVC.h"

@interface SickLeaveFormVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTV;

@property (weak, nonatomic) IBOutlet UIButton *clearReasonBTN;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *locationTV;

@property (weak, nonatomic) IBOutlet UIButton *clearLocationBTN;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLB;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;

@property (weak, nonatomic) IBOutlet UILabel *handoverLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseHandOverLB;

@property (weak, nonatomic) IBOutlet UIView *handoverView;

@property (weak, nonatomic) IBOutlet UILabel *managerLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseManagerLB;

@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (strong, nonatomic) IBOutlet UIView *handOverUserView;

@property (strong, nonatomic) IBOutlet UIView *managerUserView;

@property (weak, nonatomic) IBOutlet UIButton *ghiLaiButton;

@property (weak, nonatomic) IBOutlet UIButton *trinhKyButton;

@property (strong, nonatomic) TimePickerVC *timePickerVC;


- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

- (IBAction)choiseTimeAction:(id)sender;

- (IBAction)handOverAction:(id)sender;

- (IBAction)managerAction:(id)sender;

- (IBAction)ghiLaiAction:(id)sender;

- (IBAction)trinhKyAction:(id)sender;

@end
