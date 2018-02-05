//
//  RegisterFormCell.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterFormCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconTypeRegister;
@property (weak, nonatomic) IBOutlet UILabel *typeRegisterLB;
@property (weak, nonatomic) IBOutlet UILabel *overDateLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeRegLBCenterY;

@end
