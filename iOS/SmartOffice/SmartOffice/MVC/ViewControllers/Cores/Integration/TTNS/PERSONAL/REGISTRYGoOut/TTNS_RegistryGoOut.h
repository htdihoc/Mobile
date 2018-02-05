//
//  demo10ViewController.h
//  demo10
//
//  Created by KhacViet Dinh on 4/17/17.
//  Copyright © 2017 KhacViet Dinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePersonRuleCheckInAndOut.h"
#import "SO_CustomTimePicker.h"
#import "TimePickerVC.h"
#import "UIPlaceHolderTextView.h"

@interface TTNS_RegistryGoOut : BasePersonRuleCheckInAndOut {
    
}
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTV;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TitlePlace;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TitleReason;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TitleReasonDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TitleTimeGoOut;
@property (strong, nonatomic) TimePickerVC *timePickerVC;
@property (weak, nonatomic) IBOutlet UIButton *clearReasonBTN;

- (IBAction)SelectDestination:(id)sender;

- (IBAction)SelectReason:(id)sender;

- (IBAction)SelectPeriod:(id)sender;

- (IBAction)clearReasonAction:(id)sender;

@end
