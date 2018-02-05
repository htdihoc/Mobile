//
//  BirthLeaveFormVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"

@interface BirthLeaveFormVC : TTNS_BaseVC


@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UITextView *locationTV;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLB;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;

@property (weak, nonatomic) IBOutlet UILabel *handOverUserLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseHandOverLB;

@property (weak, nonatomic) IBOutlet UIView *handoverView;

@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (strong, nonatomic) IBOutlet UIView *handOverUserView;

@property (weak, nonatomic) IBOutlet UILabel *managerUserLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseManagerLB;

@property (strong, nonatomic) IBOutlet UIView *managerUserView;

@property (weak, nonatomic) IBOutlet UIButton *ghiLaiButton;

@property (weak, nonatomic) IBOutlet UIButton *trinhKyButton;

- (IBAction)handOverAction:(id)sender;

- (IBAction)managerAction:(id)sender;

- (IBAction)ghiLaiAction:(id)sender;

- (IBAction)trinhKyAction:(id)sender;

@end
