//
//  CompassionateLeaveVC.h
//  SmartOffice
//
//  Created by Administrator on 5/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "UIPlaceHolderTextView.h"
#import "TimePickerVC.h"

@interface CompassionateLeaveVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *starNote;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cstChooseHandlerLabel;

@property (weak, nonatomic) IBOutlet UILabel *starNoteChooseHandler;

@property (weak, nonatomic) IBOutlet UILabel *totalRemainDay;

@property (weak, nonatomic) IBOutlet UILabel *totalSabaticalDaysLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *resonTV;

@property (weak, nonatomic) IBOutlet UIButton *clearReasonBTN;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *countLB;

@property (weak, nonatomic) IBOutlet UILabel *ngay_qua_phepLB;

@property (weak, nonatomic) IBOutlet UILabel *dayLB;

@property (weak, nonatomic) IBOutlet UILabel *totalNumOfDayLeaveLB;

@property (weak, nonatomic) IBOutlet UILabel *remainingAnnualDayLB;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *locationTV;

@property (weak, nonatomic) IBOutlet UIButton *clearLocationBTN;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLB;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;

@property (weak, nonatomic) IBOutlet UILabel *noteLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *noteTV;

@property (weak, nonatomic) IBOutlet UIButton *clearNoteBTN;

@property (weak, nonatomic) IBOutlet UILabel *handoverLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseHandOverLB;

@property (weak, nonatomic) IBOutlet UILabel *choiseHandOverContentLB;

@property (weak, nonatomic) IBOutlet UIButton *handoverButton;

@property (weak, nonatomic) IBOutlet UIView *choiseHandoverUserView;

@property (weak, nonatomic) IBOutlet UIView *handoverView;

@property (weak, nonatomic) IBOutlet UIImageView *avtImg;

@property (weak, nonatomic) IBOutlet UILabel *nameHandOverLB;

@property (weak, nonatomic) IBOutlet UILabel *positionHandOverLB;

@property (weak, nonatomic) IBOutlet UILabel *contentHandOverLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentHandOverTV;

@property (weak, nonatomic) IBOutlet UILabel *managerLB;

@property (weak, nonatomic) IBOutlet UIButton *managerUserButton;

@property (weak, nonatomic) IBOutlet UIView *choiseManagerUserView;

@property (weak, nonatomic) IBOutlet UILabel *choiseManagerUserContentLB;

@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (weak, nonatomic) IBOutlet UILabel *nameManagerLB;

@property (weak, nonatomic) IBOutlet UIButton *clearContentHandOverBTN;

@property (weak, nonatomic) IBOutlet UILabel *positionManagerLB;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *signButton;

@property (strong, nonatomic) TimePickerVC *timePickerVC;

- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

- (IBAction)clearNoteAction:(id)sender;

- (IBAction)clearContentHandOverAction:(id)sender;

- (IBAction)choiseTimeAction:(id)sender;

- (IBAction)handOverUserAction:(id)sender;

- (IBAction)managerUserAction:(id)sender;

- (IBAction)saveAction:(id)sender;

- (IBAction)signAction:(id)sender;

@end
