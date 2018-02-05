//
//  RegisterSickLeaveDetail.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "UIPlaceHolderTextView.h"
#import "TimePickerVC.h"

@interface RegisterSickLeaveDetail : TTNS_BaseSubView_iPad;

@property (weak, nonatomic) IBOutlet UILabel *offReason;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTV;
@property (weak, nonatomic) IBOutlet UILabel *timeOff;
@property (weak, nonatomic) IBOutlet UILabel *timeOffLB;
@property (weak, nonatomic) IBOutlet UIButton *btnTimeOff;
@property (weak, nonatomic) IBOutlet UILabel *offPlace;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *locationTV;
@property (weak, nonatomic) IBOutlet UILabel *telNumber;
@property (weak, nonatomic) IBOutlet UITextField *telNumberTextfile;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseHandlerButton;
@property (weak, nonatomic) IBOutlet UILabel *unitCommanderLabel;
@property (weak, nonatomic) IBOutlet UIButton *unitCommanderButton;
@property (weak, nonatomic) IBOutlet UIButton *registryButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *contentHandlerChoose;
@property (weak, nonatomic) IBOutlet UILabel *contentManagerUnit;
@property (weak, nonatomic) IBOutlet UIButton *btnClearReason;
@property (weak, nonatomic) IBOutlet UIButton *btnClearLocation;
@property (strong, nonatomic) TimePickerVC *timePickerVC;

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeOff;
- (IBAction)clearReasonAction:(id)sender;
- (IBAction)clearLocationAction:(id)sender;
- (IBAction)handlerButtonAction:(id)sender;
- (IBAction)commanderButtonAction:(id)sender;
- (IBAction)registryButtonAction:(id)sender;
- (IBAction)recordButtonAction:(id)sender;
- (IBAction)chooseTimeOffAction:(id)sender;


@end
