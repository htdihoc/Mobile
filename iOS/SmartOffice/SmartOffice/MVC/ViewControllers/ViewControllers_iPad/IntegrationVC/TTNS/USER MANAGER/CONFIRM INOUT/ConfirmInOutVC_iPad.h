//
//  ConfirmInOutVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_Base_iPad.h"

@interface ConfirmInOutVC_iPad : TTNS_Base_iPad

@property (weak, nonatomic) IBOutlet UIView *containerView1;

@property (weak, nonatomic) IBOutlet UIView *containerView2;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)confirmAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

@end
