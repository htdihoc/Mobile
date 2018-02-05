//
//  RegisterInformation.h
//  AdditionalRegistrationInformation
//
//  Created by NguyenDucBien on 4/17/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
@interface RegisterOtherFreeDay : TTNS_BaseVC
@property (weak, nonatomic) IBOutlet UIButton *btnTimeBeforeOff;
@property (weak, nonatomic) IBOutlet UIButton *btnTimeAfterOff;
@property (weak, nonatomic) IBOutlet UITextView *textViewContentReason;
@property (weak, nonatomic) IBOutlet UITextField *contentPlaceOff;

@property (weak, nonatomic) IBOutlet UIButton *btnSendRegister;

- (IBAction)sendRegisterAction:(id)sender;

@end
