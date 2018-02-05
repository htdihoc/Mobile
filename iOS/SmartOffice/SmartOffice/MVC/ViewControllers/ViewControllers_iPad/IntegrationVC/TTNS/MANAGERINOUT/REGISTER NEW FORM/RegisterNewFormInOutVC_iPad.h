//
//  RegisterNewFormInOutVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "UIPlaceHolderTextView.h"
#import "TimePickerVC.h"

@interface RegisterNewFormInOutVC_iPad : TTNS_BaseSubView_iPad

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UIButton *reasonButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *detailTV;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *sendRegisterButton;

@property (weak, nonatomic) IBOutlet UIButton *btnClearDetailReason;

@property (strong, nonatomic) TimePickerVC *timePickerVC;

- (IBAction)choiseRegisterReasonAction:(id)sender;

- (IBAction)choiseLocationAction:(id)sender;

- (IBAction)choiseTimeAction:(id)sender;

- (IBAction)sendRegisterAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

- (IBAction)clearDetailReasonAction:(id)sender;


@end
