//
//  RegisterPrivateWorkDetail.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "ButtonCheckBox.h"
#import "UIPlaceHolderTextView.h"
#import "TimePickerVC.h"


@interface RegisterPrivateWorkDetail : TTNS_BaseSubView_iPad;

@property (weak, nonatomic) IBOutlet UILabel *offReason;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTV;
@property (weak, nonatomic) IBOutlet UILabel *timeOff;

@property (weak, nonatomic) IBOutlet UILabel *timeLabelContent;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UILabel *offRegime;
@property (weak, nonatomic) IBOutlet ButtonCheckBox *btnCheckSalary;
@property (weak, nonatomic) IBOutlet UILabel *haveSalary;
@property (weak, nonatomic) IBOutlet ButtonCheckBox *btnCheckNotSalary;
@property (weak, nonatomic) IBOutlet UILabel *notSalary;
@property (weak, nonatomic) IBOutlet UILabel *offPlace;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *locationTV;
@property (weak, nonatomic) IBOutlet UILabel *telNumber;
@property (weak, nonatomic) IBOutlet UITextField *telNumberTextfile;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseHandlerButton;
@property (weak, nonatomic) IBOutlet UILabel *handOverLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *handOverContentTV;
@property (weak, nonatomic) IBOutlet UILabel *unitCommanderLabel;
@property (weak, nonatomic) IBOutlet UIButton *unitCommanderButton;
@property (weak, nonatomic) IBOutlet UIButton *registryButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *contentHandlerChoose;
@property (weak, nonatomic) IBOutlet UILabel *contentManagerUnit;
@property (weak, nonatomic) IBOutlet UIButton *btnClearReason;
@property (weak, nonatomic) IBOutlet UIButton *btnClearLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnClearHandoverContent;
@property (strong, nonatomic) TimePickerVC *timePickerVC;

- (IBAction)chooseTimeOff:(id)sender;
- (IBAction)checkboxSalary:(id)sender;
- (IBAction)checkboxNotSalary:(id)sender;
- (IBAction)handlerButtonAction:(id)sender;
- (IBAction)commanderButtonAction:(id)sender;
- (IBAction)registryButtonAction:(id)sender;
- (IBAction)recordButtonAction:(id)sender;
- (IBAction)clearReasonAction:(id)sender;
- (IBAction)clearLocationAction:(id)sender;
- (IBAction)clearHandoverContentAction:(id)sender;

@end
