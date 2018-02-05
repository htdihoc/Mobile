//
//  NotificationCell.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonCheckBox.h"

@interface NotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *stateImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

- (IBAction)btnCheckAction:(id)sender;

@end
