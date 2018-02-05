//
//  RefuseVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "TimePickerVC.h"

@interface RefuseVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *stateLB;

@property (weak, nonatomic) IBOutlet UILabel *stateContentLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UILabel *nguoiTuChoiLB;

@property (weak, nonatomic) IBOutlet UITextView *reasonTV;

@property (weak, nonatomic) IBOutlet UIButton *clearReasonButton;

@property (weak, nonatomic) IBOutlet UILabel *lyDoNghiLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UITextView *locationTV;

@property (weak, nonatomic) IBOutlet UIButton *clearButtonLocation;

@property (weak, nonatomic) IBOutlet UILabel *phoneLB;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *choiseHandoverLB;

@property (weak, nonatomic) IBOutlet UILabel *contentHandOverLB;

@property (weak, nonatomic) IBOutlet UIView *handoverView;

@property (weak, nonatomic) IBOutlet UILabel *managerLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseManagerLB;

@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (weak, nonatomic) IBOutlet UITextView *handoverContentTV;

@property (weak, nonatomic) IBOutlet UIButton *clearHandOverContentButton;

@property (strong, nonatomic) IBOutlet UIView *handOverUserView;

@property (strong, nonatomic) IBOutlet UIView *managerUserView;

@property (weak, nonatomic) IBOutlet UIButton *ghiLaiButton;

@property (weak, nonatomic) IBOutlet UIButton *trinhKyButton;

@property (assign ,nonatomic) NSInteger personalFormId;

@property (assign, nonatomic) NSInteger typeOfForm;

@property (strong, nonatomic) TimePickerVC *timePickerVC;


- (IBAction)showDatePicker:(id)sender;

- (IBAction)handoverAction:(id)sender;

- (IBAction)managerAction:(id)sender;

- (IBAction)ghiLaiAction:(id)sender;

- (IBAction)trinhKyAction:(id)sender;

- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

//- (IBAction)clearNoteAction:(id)sender;

- (IBAction)clearHandOverContentAction:(id)sender;

@end
