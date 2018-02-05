//
//  RegisterMore_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerVC.h"

@protocol RegisterMore_iPadDelegate <NSObject>

- (void)pressButton:(UIButton *)sender;

@end

@interface RegisterMore_iPad : BaseVC

@property (weak, nonatomic) id <RegisterMore_iPadDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *fromTimeLB;

@property (weak, nonatomic) IBOutlet UIButton *fromTimeButton;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLB;

@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UITextView *reasonTV;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UITextView *locationTV;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIButton *clearReasonButton;

@property (weak, nonatomic) IBOutlet UIButton *clearLocationButton;

@property (strong, nonatomic) TimePickerVC *timePickerVC;

- (IBAction)fromTimeAction:(id)sender;

- (IBAction)endTimeAction:(id)sender;

- (IBAction)closeAction:(id)sender;

- (IBAction)registerAction:(id)sender;

- (IBAction)clearReasonAction:(id)sender;

- (IBAction)clearLocationAction:(id)sender;

@end
