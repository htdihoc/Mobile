//
//  DeniedRegisterVC_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "TimePickerVC.h"

@interface DeniedRegisterVC_iPad : TTNS_BaseSubView_iPad

@property (weak, nonatomic) IBOutlet UILabel *stateLB;

@property (weak, nonatomic) IBOutlet UILabel *stateContentLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UILabel *nguoiTuChoiLB;

@property (weak, nonatomic) IBOutlet UITextView *reasonTV;

@property (weak, nonatomic) IBOutlet UILabel *lyDoNghiLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *timeButtonLB;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UITextView *locationTV;

@property (weak, nonatomic) IBOutlet UILabel *phoneLB;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *choiseHandoverLB;

@property (weak, nonatomic) IBOutlet UILabel *contentHandOverLB;

@property (weak, nonatomic) IBOutlet UIView *handoverView;

@property (weak, nonatomic) IBOutlet UILabel *managerLB;
@property (weak, nonatomic) IBOutlet UILabel *choiseManagerLB;

@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (weak, nonatomic) IBOutlet UITextView *handoverContentTV;

@property (strong, nonatomic) IBOutlet UIView *handOverUserView;

@property (strong, nonatomic) IBOutlet UIView *managerUserView;

@property (weak, nonatomic) IBOutlet UIButton *ghiLaiButton;

@property (weak, nonatomic) IBOutlet UIButton *trinhKyButton;

@property (weak, nonatomic) IBOutlet UIButton *btnClearReason;

@property (weak, nonatomic) IBOutlet UIButton *btnClearLocation;

@property (weak, nonatomic) IBOutlet UIButton *btnClearHandoverContent;

@property (assign ,nonatomic) NSInteger personalFormId;

@property (strong, nonatomic) TimePickerVC *timePickerVC;

- (IBAction)chooseTimeOff:(id)sender;

- (void)loadingData:(NSInteger)personalFormId;

- (IBAction)handoverAction:(id)sender;

- (IBAction)managerAction:(id)sender;

- (IBAction)ghiLaiAction:(id)sender;

- (IBAction)trinhKyAction:(id)sender;

- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

- (IBAction)clearHandoverContentAction:(id)sender;



@end
