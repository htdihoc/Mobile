//
//  NotSubmitedVC_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "TimePickerVC.h"

@interface NotSubmitedVC_iPad : TTNS_BaseSubView_iPad
@property (weak, nonatomic) IBOutlet UILabel *remainDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UILabel *remainDay;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *reasonTV;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOffLB;
@property (weak, nonatomic) IBOutlet UILabel *dateSumLB;

@property (weak, nonatomic) IBOutlet UIButton *btnClearReason;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UILabel *noteLB;
@property (weak, nonatomic) IBOutlet UILabel *contentHandoverLB;

@property (weak, nonatomic) IBOutlet UIButton *btnTime;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UILabel *totalNumOfDayLeaveLB;

@property (weak, nonatomic) IBOutlet UILabel *totalSabaticalDays;
@property (weak, nonatomic) IBOutlet UILabel *unitManagerLB;

@property (weak, nonatomic) IBOutlet UIButton *btnClearLocation;

@property (weak, nonatomic) IBOutlet UITextView *locationTV;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *btnClearHandoverContent;

@property (weak, nonatomic) IBOutlet UITextView *handoverTV;

@property (weak, nonatomic) IBOutlet UILabel *handoverContentLB;

@property (weak, nonatomic) IBOutlet UILabel *managerUnitContentLB;

@property (strong, nonatomic) TimePickerVC *timePickerVC;

@property (assign, nonatomic) NSInteger employeeId;

- (IBAction)handoverAction:(id)sender;

- (IBAction)managerUserAction:(id)sender;

- (IBAction)ghiLaiAction:(id)sender;

- (IBAction)trinhKyAction:(id)sender;

- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

- (IBAction)clearHandOverContentAction:(id)sender;

- (IBAction)chooseTimeAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UIButton *btnHandler;

@property (weak, nonatomic) IBOutlet UIButton *btnManagerUser;

- (IBAction)deleteAction:(id)sender;

- (void)loadingData:(NSInteger)personalFormId;



@end
