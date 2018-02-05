//
//  RegTakeLeaveVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "TimePickerVC.h"

@interface RegTakeLeaveVC : TTNS_BaseVC



@property (weak, nonatomic) IBOutlet UILabel *remainDay;

@property (weak, nonatomic) IBOutlet UITextView *reasonTV;

@property (weak, nonatomic) IBOutlet UIButton *timeTV;

@property (weak, nonatomic) IBOutlet UILabel *totalNumOfDayLeaveLB;

@property (weak, nonatomic) IBOutlet UILabel *totalSabaticalDays;

@property (weak, nonatomic) IBOutlet UITextView *locationTV;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextView *noteTV;

@property (weak, nonatomic) IBOutlet UIView *view_handover;

@property (weak, nonatomic) IBOutlet UITextView *handoverTV;

@property (weak, nonatomic) IBOutlet UIView *view_manager;

@property (strong, nonatomic) IBOutlet UIView *handoverUserView;

@property (strong, nonatomic) IBOutlet UIView *managerUserView;

@property (weak, nonatomic) IBOutlet UIButton *btnClearReason;

@property (weak, nonatomic) IBOutlet UIButton *btnClearLocation;

@property (weak, nonatomic) IBOutlet UIButton *btnClearNote;

@property (weak, nonatomic) IBOutlet UIButton *btnClearHandoverContent;

@property (assign, nonatomic) NSInteger personalFormId;

@property (assign, nonatomic) NSInteger typeOfForm;

@property (assign, nonatomic) NSInteger employeeId;

@property (strong, nonatomic) TimePickerVC *timePickerVC;

- (IBAction)showTimePicker:(id)sender;

- (IBAction)handoverAction:(id)sender;

- (IBAction)managerUserAction:(id)sender;

- (IBAction)ghiLaiAction:(id)sender;

- (IBAction)trinhKyAction:(id)sender;

- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

- (IBAction)clearNoteAction:(id)sender;

- (IBAction)clearHandoverContentAction:(id)sender;


@end
