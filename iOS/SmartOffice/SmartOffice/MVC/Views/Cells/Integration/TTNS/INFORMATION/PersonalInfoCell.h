//
//  PersonalInfoCell.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avtImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *phoneLB;

@property (weak, nonatomic) IBOutlet UILabel *positionLB;

@property (weak, nonatomic) IBOutlet UIButton *fixPhoneNumberOutlet;

- (IBAction)fixPhoneNumberAction:(id)sender;

@end
