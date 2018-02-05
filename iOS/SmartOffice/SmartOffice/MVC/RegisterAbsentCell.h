//
//  RegisterAbsentCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonCheckBox.h"
@interface RegisterAbsentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ButtonCheckBox *ckOff1;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *ckWork1;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

- (IBAction)locationAction:(id)sender;

@end
